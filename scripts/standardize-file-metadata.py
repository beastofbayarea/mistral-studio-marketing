from __future__ import annotations

import argparse
import json
import os
import re
import struct
import subprocess
import zlib
import zipfile
from pathlib import Path
from xml.etree import ElementTree as ET

from pypdf import PdfReader, PdfWriter


ROOT = Path(__file__).resolve().parents[1]
PORTFOLIO_AUTHOR = "Shiv, Prospective PMM, Mistral Studio"
PORTFOLIO_COMMENT = "Unofficial portfolio concept for field enablement."

CORE_NS = {
    "cp": "http://schemas.openxmlformats.org/package/2006/metadata/core-properties",
    "dc": "http://purl.org/dc/elements/1.1/",
    "dcterms": "http://purl.org/dc/terms/",
}
APP_NS = "http://schemas.openxmlformats.org/officeDocument/2006/extended-properties"

for prefix, uri in CORE_NS.items():
    ET.register_namespace(prefix, uri)
ET.register_namespace("dcmitype", "http://purl.org/dc/dcmitype/")
ET.register_namespace("xsi", "http://www.w3.org/2001/XMLSchema-instance")
ET.register_namespace("", APP_NS)


OFFICE_METADATA = {
    "author-profile.pptx": {
        "title": "Mistral AI - Author Profile and Team Background",
        "subject": "Author profile, experience, and product marketing portfolio",
        "creator": PORTFOLIO_AUTHOR,
        "description": "Portfolio presentation covering relevant product marketing, industry GTM, and AI platform experience.",
        "keywords": "mistral-ai, author-profile, product-marketing, portfolio",
    },
    "eu-policy-company-thesis.pptx": {
        "title": "Mistral AI - EU Policy and Company Thesis",
        "subject": "European AI sovereignty, market strategy, and policy architecture",
        "creator": PORTFOLIO_AUTHOR,
        "description": "Company thesis connecting Mistral AI's product position with European AI policy and sovereignty.",
        "keywords": "mistral-ai, eu-policy, ai-sovereignty, company-thesis",
    },
    "gtm-and-launch-strategy-framework.pptx": {
        "title": "Mistral Studio - Launch and Commercialization Plan",
        "subject": "Go-to-market launch plan, pricing, channels, and readiness gates",
        "creator": PORTFOLIO_AUTHOR,
        "description": "Outside-in launch and commercialization framework for Mistral Studio.",
        "keywords": "mistral-studio, launch-strategy, commercialization, go-to-market",
    },
    "product-marketing-strategy.pptx": {
        "title": "Mistral Studio - Product Marketing Strategy",
        "subject": "Product marketing strategy and positioning for Mistral Studio",
        "creator": PORTFOLIO_AUTHOR,
        "description": "Product marketing strategy spanning market context, positioning, messaging, launch, and field enablement.",
        "keywords": "mistral-studio, product-marketing, positioning, field-enablement",
    },
    "studio-pmm/category-narrative-keynote.pptx": {
        "title": "Mistral Studio - Category Narrative Keynote",
        "subject": "From agent prototype to governed production",
        "creator": PORTFOLIO_AUTHOR,
        "description": "Category narrative for moving enterprise AI agents from prototypes into governed production.",
        "keywords": "mistral-studio, category-narrative, keynote, governance",
    },
    "studio-pmm/competitive-landscape-differentiation-framework.pptx": {
        "title": "Mistral Studio - Competitive Landscape and Differentiation Framework",
        "subject": "Competitive analysis and field differentiation",
        "creator": PORTFOLIO_AUTHOR,
        "description": "Competitive decision framework for positioning Mistral Studio against alternative AI operating models.",
        "keywords": "mistral-studio, competitive-analysis, differentiation, positioning",
    },
    "studio-pmm/core-sales-deck.pptx": {
        "title": "Mistral Studio - Core Sales Deck",
        "subject": "Enterprise sales narrative and field enablement",
        "creator": PORTFOLIO_AUTHOR,
        "description": "Core enterprise sales narrative for building, deploying, and governing production AI workflows.",
        "keywords": "mistral-studio, sales-deck, enterprise-ai, field-enablement",
    },
    "studio-pmm/enterprise-prosumer-segmentation.pptx": {
        "title": "Mistral Studio - Enterprise and Prosumer Segmentation Framework",
        "subject": "Builder segmentation, qualification, and enterprise conversion",
        "creator": PORTFOLIO_AUTHOR,
        "description": "Segmentation framework for qualifying prosumer builders and converting adoption into enterprise proof.",
        "keywords": "mistral-studio, segmentation, prosumer, enterprise, personas",
    },
    "studio-pmm/gtm-strategy.pptx": {
        "title": "Mistral Studio - Go-to-Market Strategy",
        "subject": "Go-to-market strategy and operating plan",
        "creator": PORTFOLIO_AUTHOR,
        "description": "Operational launch strategy connecting audience, proof, execution, and measurement.",
        "keywords": "mistral-studio, gtm-strategy, launch, execution-plan",
    },
    "resources/front-end-tech-stack.xlsx": {
        "title": "Mistral Studio - Front-End Technology Stack",
        "subject": "Technology stack inventory for the Mistral web properties",
        "creator": PORTFOLIO_AUTHOR,
        "description": "Structured inventory of front-end technologies observed across Mistral web experiences.",
        "keywords": "mistral-ai, front-end, technology-stack, web-audit",
    },
    "studio-pmm/data/gtm-market-research-and-fact-base.xlsx": {
        "title": "Mistral Studio - GTM Market Research and Fact Base",
        "subject": "Market research, customer evidence, and go-to-market hypotheses",
        "creator": PORTFOLIO_AUTHOR,
        "description": "Research workbook consolidating product facts, personas, evidence, competitive context, and KPIs.",
        "keywords": "mistral-studio, gtm, fact-base, market-research",
    },
    "studio-pmm/data/mistral-studio-master-positioning-and-playbooks-database.xlsx": {
        "title": "Mistral Studio - Master Positioning and Playbooks Database",
        "subject": "Master positioning, use-case playbooks, messaging, and battlecards",
        "creator": PORTFOLIO_AUTHOR,
        "description": "Master workbook consolidating positioning, use cases, messaging, discovery, and competitive playbooks.",
        "keywords": "mistral-studio, positioning, playbooks, battlecards, messaging",
    },
    "studio-pmm/data/technical-to-business-value-roi-translation-framework.xlsx": {
        "title": "Mistral Studio - Technical-to-Business Value and ROI Framework",
        "subject": "Translation of technical capabilities into enterprise outcomes and ROI",
        "creator": PORTFOLIO_AUTHOR,
        "description": "Framework connecting technical capabilities, buyer value, use cases, assumptions, and measurable outcomes.",
        "keywords": "mistral-studio, business-value, roi, technical-translation",
    },
}


PDF_METADATA = {
    "mistral-industries-field-enablement-strategy.pdf": {
        "Title": "Mistral Financial Services PMM Case - Turn FSI Pain into Production Wins",
        "Author": PORTFOLIO_AUTHOR,
        "Subject": "Financial services product marketing case and field enablement strategy",
        "Keywords": "mistral-ai, financial-services, field-enablement, product-marketing, production-ai",
    },
    "sales-enterprise-architecture-one-pager.pdf": {
        "Title": "Mistral Studio - Enterprise Architecture Sales One-Pager",
        "Author": PORTFOLIO_AUTHOR,
        "Subject": "Enterprise architecture and production AI sales brief",
        "Keywords": "mistral-studio, enterprise-architecture, sales-enablement, production-ai",
    },
    "sales-master-battlecards.pdf": {
        "Title": "Mistral Studio - Master Competitive Battlecards",
        "Author": PORTFOLIO_AUTHOR,
        "Subject": "Competitive battlecards for enterprise sales teams",
        "Keywords": "mistral-studio, battlecards, competitive-analysis, sales-enablement",
    },
    "official-designs-and-docs/mistral-logo-guidelines.pdf": {
        "Title": "Mistral AI - Brand and Logo Guidelines",
        "Author": "Mistral AI",
        "Subject": "Official logo usage, typography, and brand identity guidelines",
        "Keywords": "mistral-ai, logo, brand-guidelines, typography",
    },
    "official-designs-and-docs/docs/mistral-ai-european-competitiveness-whitepaper.pdf": {
        "Title": "European AI - A Playbook to Own It",
        "Author": "Mistral AI",
        "Subject": "European AI sovereignty and competitiveness",
        "Keywords": "mistral-ai, european-ai, competitiveness, sovereignty, whitepaper",
    },
    "official-designs-and-docs/docs/mistral-ai-strategic-memo.pdf": {
        "Title": "Mistral AI - Strategic Memo",
        "Author": "Mistral AI",
        "Subject": "Generative AI market strategy and platform vision",
        "Keywords": "mistral-ai, strategic-memo, generative-ai, market-strategy",
    },
    "resources/case-studies-and-reports/ki-radar-steuerberatung-de-2026-07-29-report.pdf": {
        "Title": "KI-Radar Steuerberatung Deutschland - July 2026",
        "Author": PORTFOLIO_AUTHOR,
        "Subject": "German tax advisory AI market radar and recommendations",
        "Keywords": "ki-radar, steuerberatung, deutschland, artificial-intelligence, market-research",
    },
    "resources/case-studies-and-reports/la-banque-postale-mistral-ai-press-release.pdf": {
        "Title": "La Banque Postale and Mistral AI - Strategic Partnership Press Release",
        "Author": "La Banque Postale and Mistral AI",
        "Subject": "Strategic partnership announcement for enterprise AI in banking",
        "Keywords": "la-banque-postale, mistral-ai, press-release, strategic-partnership",
    },
}


MARKDOWN_METADATA = {
    "demo-videos/docs/field-enablement-demo.md": (
        "ASML x Mistral Field Enablement Ad",
        "Delivery specifications, evidence rules, and build guidance for the field enablement ad.",
    ),
    "demo-videos/docs/rethought-demo-script.md": (
        "ASML x Mistral Evidence-Backed Incident Workflow",
        "Storyboard and narrative principles for the incident workflow demo.",
    ),
    "industries-pmm/fsi-data/01-field-playbook.md": (
        "Mistral AI Financial Services Field Playbook",
        "Field messaging, plays, objections, and execution guidance for financial services.",
    ),
    "industries-pmm/fsi-data/02-customers-and-accounts.md": (
        "FSI Customers, Priority Accounts, and Evidence Matrix",
        "Customer evidence, account priorities, and unresolved proof gaps for financial services.",
    ),
    "industries-pmm/fsi-data/03-product-priorities.md": (
        "FSI Voice of Customer and Product Priorities",
        "Financial services use cases, product priorities, and roadmap implications.",
    ),
    "industries-pmm/fsi-data/04-gtm-and-operating-plan.md": (
        "FSI Go-to-Market Strategy and Operating Plan",
        "Six-to-twelve-month go-to-market strategy, field motions, and operating cadence.",
    ),
    "industries-pmm/fsi-data/05-performance-framework.md": (
        "FSI Performance Measurement Framework",
        "Metrics and measurement principles for financial services go-to-market execution.",
    ),
    "industries-pmm/fsi-data/06-sources-and-assumptions.md": (
        "FSI Sources, Evidence Taxonomy, and Assumptions",
        "Source registry, evidence controls, and assumptions for the FSI GTM operating system.",
    ),
    "resources/mistral-ai-site-summaries.md": (
        "Mistral AI Root and Level 1 Site Summaries",
        "Structured summaries of Mistral AI root and first-level web pages.",
    ),
    "resources/mistral-ai-level-2-site-summaries.md": (
        "Mistral AI Level 2 Site Summaries",
        "Structured summaries of second-level Mistral AI web pages.",
    ),
}


PNG_TITLE_OVERRIDES = {
    "demo-videos/assets/thumbnails/asml-mistral-anomaly-to-action-thumbnail.png": "ASML x Mistral - Anomaly to Action Thumbnail",
    "demo-videos/assets/thumbnails/asml-mistral-unofficial-concept-thumbnail.png": "ASML x Mistral - Unofficial Concept Thumbnail",
    "resources/cover-images/european-ai-sovereignty-and-governance-shield-cover.png": "European AI Sovereignty and Governance Shield",
    "resources/cover-images/european-sovereign-ai-network-security-cover.png": "European Sovereign AI Network Security",
    "resources/cover-images/hybrid-cloud-to-private-ai-infrastructure-cover.png": "Hybrid Cloud to Private AI Infrastructure",
    "resources/cover-images/sovereign-ai-infrastructure-stack-cover.png": "Sovereign AI Infrastructure Stack",
    "resources/cover-images/sovereign-cloud-industrial-ai-infrastructure-cover.png": "Sovereign Cloud and Industrial AI Infrastructure",
    "self-service-journey-friction-diagnostic.png": "Mistral Studio - Self-Service Journey Friction Diagnostic",
    "studio-pmm/product-journey-roadmap.png": "Mistral Studio - Product Journey Roadmap",
    "studio-pmm/sales-one-pagers/enterprise-architecture-one-pager.png": "Mistral Studio - Enterprise Architecture One-Pager",
    "studio-pmm/sales-one-pagers/workflow-poc-one-pager.png": "Mistral Studio - Workflow Proof-of-Concept One-Pager",
}


ACRONYMS = {
    "ai": "AI", "asml": "ASML", "aws": "AWS", "bnp": "BNP", "fsi": "FSI",
    "gtm": "GTM", "hsbc": "HSBC", "m": "M", "pmm": "PMM", "poc": "POC",
    "roi": "ROI", "sdk": "SDK", "tts": "TTS", "ui": "UI", "vs": "vs.",
}


VIDEO_METADATA = {
    "asml-mistral-field-enablement-ad-48s-1080p.mp4": ("ASML x Mistral Field Enablement Ad", PORTFOLIO_AUTHOR, PORTFOLIO_COMMENT),
    "demo-videos/outputs/asml-mistral-field-enablement-ad-48s-1080p.mp4": ("ASML x Mistral Field Enablement Ad", PORTFOLIO_AUTHOR, PORTFOLIO_COMMENT),
    "demo-videos/outputs/asml-mistral-field-enablement-ad-v2-48s-1080p.mp4": ("ASML x Mistral Field Enablement Ad - Version 2", PORTFOLIO_AUTHOR, PORTFOLIO_COMMENT),
    "demo-videos/outputs/asml-mistral-field-enablement-demo-75s-1080p.mp4": ("ASML x Mistral Field Enablement Demo", PORTFOLIO_AUTHOR, PORTFOLIO_COMMENT),
    "demo-videos/outputs/asml-mistral-field-enablement-tiktok-48s-1080x1920.mp4": ("ASML x Mistral Field Enablement Vertical Ad", PORTFOLIO_AUTHOR, PORTFOLIO_COMMENT),
    "demo-videos/outputs/asml-mistral-incident-workflow-demo-50s-1080p.mp4": ("ASML x Mistral Incident Workflow Demo", PORTFOLIO_AUTHOR, PORTFOLIO_COMMENT),
    "demo-videos/outputs/asml-mistral-studio-workflow-demo-48s-1080p.mp4": ("ASML x Mistral Studio Workflow Demo", PORTFOLIO_AUTHOR, PORTFOLIO_COMMENT),
    "demo-videos/outputs/rejected/rejected-asml-mistral-presenter-intermediate-48s-1080p.mp4": ("Rejected ASML x Mistral Presenter Intermediate", PORTFOLIO_AUTHOR, "Rejected intermediate retained for production reference."),
    "demo-videos/source-footage/masters/asml-mistral-narrated-workflow-master-48s-1080p.mp4": ("ASML x Mistral Narrated Workflow Master", PORTFOLIO_AUTHOR, PORTFOLIO_COMMENT),
    "demo-videos/source-footage/masters/asml-mistral-original-master-70s-2160p.mp4": ("ASML x Mistral Original Master", PORTFOLIO_AUTHOR, PORTFOLIO_COMMENT),
}


def rel(path: Path) -> str:
    return path.relative_to(ROOT).as_posix()


def human_title(stem: str) -> str:
    stem = re.sub(r"-\d+s-(?:\d+p|\d+x\d+)$", "", stem)
    stem = re.sub(r"-(?:\d+p|\d+x\d+)$", "", stem)
    words = [ACRONYMS.get(word, word.capitalize()) for word in stem.split("-")]
    return " ".join(words)


def set_xml_text(root: ET.Element, namespace: str, name: str, value: str) -> None:
    tag = f"{{{namespace}}}{name}"
    node = root.find(tag)
    if node is None:
        node = ET.SubElement(root, tag)
    node.text = value


def rewrite_office_metadata(path: Path, metadata: dict[str, str]) -> None:
    with zipfile.ZipFile(path, "r") as source:
        entries = [(item, source.read(item.filename)) for item in source.infolist()]

    updated = []
    for item, data in entries:
        if item.filename == "docProps/core.xml":
            root = ET.fromstring(data)
            for key, value in metadata.items():
                namespace = CORE_NS["dc"] if key in {"title", "subject", "creator", "description"} else CORE_NS["cp"]
                set_xml_text(root, namespace, key, value)
            data = ET.tostring(root, encoding="utf-8", xml_declaration=True)
        elif item.filename == "docProps/app.xml":
            root = ET.fromstring(data)
            company = root.find(f"{{{APP_NS}}}Company")
            if company is not None:
                root.remove(company)
            data = ET.tostring(root, encoding="utf-8", xml_declaration=True)
        updated.append((item, data))

    temp = path.with_name(f".{path.name}.metadata-tmp")
    with zipfile.ZipFile(temp, "w") as target:
        for item, data in updated:
            target.writestr(item, data)
    os.replace(temp, path)


def rewrite_pdf_metadata(path: Path, metadata: dict[str, str]) -> None:
    reader = PdfReader(path)
    writer = PdfWriter()
    writer.clone_document_from_reader(reader)
    current = {str(key): str(value) for key, value in (reader.metadata or {}).items() if value is not None}
    for key, value in metadata.items():
        current[f"/{key}"] = value
    writer.add_metadata(current)
    temp = path.with_name(f".{path.name}.metadata-tmp")
    with temp.open("wb") as stream:
        writer.write(stream)
    os.replace(temp, path)


def png_chunk(chunk_type: bytes, data: bytes) -> bytes:
    return struct.pack(">I", len(data)) + chunk_type + data + struct.pack(">I", zlib.crc32(chunk_type + data) & 0xFFFFFFFF)


def png_keyword(chunk_type: bytes, data: bytes) -> str | None:
    if chunk_type not in {b"tEXt", b"zTXt", b"iTXt"} or b"\x00" not in data:
        return None
    return data.split(b"\x00", 1)[0].decode("latin-1", errors="replace")


def rewrite_png_metadata(path: Path, metadata: dict[str, str]) -> None:
    payload = path.read_bytes()
    if payload[:8] != b"\x89PNG\r\n\x1a\n":
        raise ValueError(f"Not a PNG file: {path}")
    offset = 8
    chunks: list[tuple[bytes, bytes]] = []
    while offset < len(payload):
        length = struct.unpack(">I", payload[offset:offset + 4])[0]
        chunk_type = payload[offset + 4:offset + 8]
        data = payload[offset + 8:offset + 8 + length]
        offset += 12 + length
        if png_keyword(chunk_type, data) not in {"Title", "Author", "Copyright", "Description"}:
            chunks.append((chunk_type, data))

    encoded_metadata = []
    for key in ("Title", "Author", "Copyright", "Description"):
        value = metadata.get(key)
        if value:
            encoded_metadata.append((b"iTXt", key.encode("latin-1") + b"\x00\x00\x00\x00\x00" + value.encode("utf-8")))

    output = bytearray(payload[:8])
    inserted = False
    for chunk_type, data in chunks:
        if not inserted and chunk_type in {b"IDAT", b"IEND"}:
            for meta_type, meta_data in encoded_metadata:
                output.extend(png_chunk(meta_type, meta_data))
            inserted = True
        output.extend(png_chunk(chunk_type, data))
    path.write_bytes(output)


def png_metadata(path: Path) -> dict[str, str]:
    relative = rel(path)
    title = PNG_TITLE_OVERRIDES.get(relative, human_title(path.stem))
    if "/bank-icons/" in f"/{relative}":
        description = f"Brand asset for {title}."
        author = ""
        copyright_text = ""
    elif relative.startswith("official-designs-and-docs/"):
        description = f"Official Mistral AI visual asset: {title}."
        author = "Mistral AI"
        copyright_text = "Mistral AI"
    elif relative.startswith("demo-videos/assets/thumbnails/"):
        description = f"YouTube thumbnail for the unofficial portfolio concept: {title}."
        author = PORTFOLIO_AUTHOR
        copyright_text = ""
    else:
        description = f"Mistral Studio marketing portfolio asset: {title}."
        author = PORTFOLIO_AUTHOR
        copyright_text = ""
    return {"Title": title, "Author": author, "Copyright": copyright_text, "Description": description}


def rewrite_markdown_metadata(path: Path, title: str, description: str) -> None:
    text = path.read_text(encoding="utf-8-sig")
    if text.startswith("---\n") or text.startswith("---\r\n"):
        match = re.match(r"^---\r?\n.*?\r?\n---\r?\n", text, flags=re.DOTALL)
        if match:
            text = text[match.end():]
    frontmatter = (
        "---\n"
        f'title: "{title}"\n'
        f'description: "{description}"\n'
        f'author: "{PORTFOLIO_AUTHOR}"\n'
        "---\n\n"
    )
    path.write_text(frontmatter + text.lstrip("\r\n"), encoding="utf-8", newline="\n")


def video_tags(ffprobe: Path, path: Path) -> dict[str, str]:
    result = subprocess.run(
        [str(ffprobe), "-v", "error", "-show_entries", "format_tags", "-of", "json", str(path)],
        check=True,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
    )
    return json.loads(result.stdout).get("format", {}).get("tags", {})


def inferred_video_metadata(path: Path, ffprobe: Path) -> tuple[str, str, str] | None:
    relative = rel(path)
    if relative in VIDEO_METADATA:
        return VIDEO_METADATA[relative]
    if not relative.startswith("demo-videos/source-footage/"):
        return None
    tags = {key.lower(): value for key, value in video_tags(ffprobe, path).items()}
    if tags.get("title"):
        return None
    title = human_title(path.stem)
    artist = ""
    if "/mistral-products/" in f"/{relative}" or "/mistral-studio/" in f"/{relative}":
        artist = "Mistral AI"
    elif "/industry/" in f"/{relative}":
        prefix_artists = {
            "asml-": "ASML", "cern-": "CERN", "fraunhofer-": "Fraunhofer",
            "nasa-": "NASA", "skf-": "SKF",
        }
        for prefix, source in prefix_artists.items():
            if path.stem.startswith(prefix):
                artist = source
                break
    return title, artist, "Source footage; original publisher attribution preserved where available."


def rewrite_video_metadata(path: Path, ffmpeg: Path, ffprobe: Path, metadata: tuple[str, str, str]) -> None:
    title, artist, comment = metadata
    temp = path.with_name(f".{path.stem}.metadata-tmp{path.suffix}")
    command = [
        str(ffmpeg), "-hide_banner", "-loglevel", "error", "-y", "-i", str(path),
        "-map", "0", "-c", "copy", "-map_metadata", "0",
        "-metadata", f"title={title}", "-metadata", f"comment={comment}",
    ]
    if artist:
        command.extend(["-metadata", f"artist={artist}"])
    command.extend(["-movflags", "+faststart", str(temp)])
    subprocess.run(command, check=True)
    os.replace(temp, path)


def main() -> None:
    parser = argparse.ArgumentParser(description="Standardize descriptive metadata without changing visible content.")
    parser.add_argument("--apply", action="store_true", help="Write the metadata changes. Default is a dry run.")
    parser.add_argument("--ffmpeg", type=Path, help="FFmpeg executable for lossless MP4 metadata remuxing.")
    parser.add_argument("--ffprobe", type=Path, help="FFprobe executable used to preserve existing source attribution.")
    args = parser.parse_args()

    office_files = [(ROOT / name, metadata) for name, metadata in OFFICE_METADATA.items()]
    pdf_files = [(ROOT / name, metadata) for name, metadata in PDF_METADATA.items()]
    markdown_files = [(ROOT / name, values) for name, values in MARKDOWN_METADATA.items()]
    png_files = sorted(path for path in ROOT.rglob("*.png") if ".git" not in path.parts and ".venv" not in path.parts and ".codex-tmp" not in path.parts)
    video_files: list[tuple[Path, tuple[str, str, str]]] = []
    if args.ffmpeg or args.ffprobe:
        if not args.ffmpeg or not args.ffprobe:
            parser.error("--ffmpeg and --ffprobe must be supplied together")
        for path in sorted(ROOT.rglob("*.mp4")):
            if ".git" in path.parts or ".venv" in path.parts or ".codex-tmp" in path.parts:
                continue
            metadata = inferred_video_metadata(path, args.ffprobe)
            if metadata:
                video_files.append((path, metadata))

    summary = {
        "office_files": len(office_files),
        "pdf_files": len(pdf_files),
        "markdown_files": len(markdown_files),
        "png_files": len(png_files),
        "video_files": len(video_files),
        "mode": "apply" if args.apply else "dry-run",
    }
    print(json.dumps(summary, indent=2))
    if not args.apply:
        return

    for path, metadata in office_files:
        rewrite_office_metadata(path, metadata)
    for path, metadata in pdf_files:
        rewrite_pdf_metadata(path, metadata)
    for path, (title, description) in markdown_files:
        rewrite_markdown_metadata(path, title, description)
    for path in png_files:
        rewrite_png_metadata(path, png_metadata(path))
    for path, metadata in video_files:
        print(f"Updating video metadata: {rel(path)}")
        rewrite_video_metadata(path, args.ffmpeg, args.ffprobe, metadata)


if __name__ == "__main__":
    main()
