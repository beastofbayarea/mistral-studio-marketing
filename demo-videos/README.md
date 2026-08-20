# ASML × Mistral Demo Videos

This is the self-contained production workspace for the ASML client demo. Source footage, reusable edit assets, build tooling, creative documentation, and generated exports are separated so each file has one clear role.

## Structure

```text
demo-videos/
├── assets/
│   ├── narration/                 # Voice, timing, and approved narration configuration
│   └── overlays/                  # Version-controlled subtitle and graphic overlays
├── docs/                          # Storyboard, narration, and production guidance
├── outputs/                       # Generated review and delivery exports
├── scripts/                       # Build scripts and shared PowerShell helpers
└── source-footage/
    ├── duplicates/                # Preserved duplicate or alternate-encoding downloads
    ├── industry/                  # ASML, semiconductor, and industrial reference clips
    ├── masters/                   # Original and narrated ASML × Mistral masters
    ├── mistral-products/          # Mistral product, platform, and customer-story footage
    └── mistral-studio/            # Mistral Studio product demonstrations
```

Video files are intentionally ignored by Git. The folder structure, scripts, overlays, and documentation remain version controlled.

## Field enablement ad master

The recommended client-facing cut is a 47.7-second ASML diagnostic-workflow story designed to work as both field enablement and a short-form account ad. A four-shot kinetic opening moves quickly into grounded evidence, uncertainty handling, engineer approval, traceability, and a measurable-pilot invitation. The presenter-free timeline uses approximately 36 seconds of industrial and precision-system imagery and 12 seconds of framed Mistral Studio proof points; human presence is limited to operator hands performing cleanroom work. Burned-in source captions are excluded. An expressive eleven-cue Ava narration opens with three forceful synchronized beats, then uses cue-specific pace, pitch, emphasis, mix gain, and pause direction instead of one repeated delivery setting.

Build it from the repository root:

```powershell
.\demo-videos\scripts\build-field-enablement-demo.ps1
```

The default export is `outputs\asml-mistral-field-enablement-ad-v2-48s-1080p.mp4`. Use `-RegenerateNarration` after changing the script or voice settings:

```powershell
.\demo-videos\scripts\build-field-enablement-demo.ps1 -RegenerateNarration
```

The full edit map, narration, source timecodes, and design rationale are in `docs\field-enablement-demo.md`.

## Earlier workflow demo

The 48-second structure is Detect, Investigate, Explain, Approve, and Pilot. It combines:

- `source-footage\masters\asml-mistral-original-master-4k.mp4`
- `source-footage\masters\asml-mistral-narrated-workflow-master-1080p.mp4`
- `source-footage\mistral-studio\mistral-studio-build-first-workflow-720p.mp4`
- `source-footage\mistral-studio\mistral-studio-update-versioned-skill-720p.mp4`
- `assets\overlays\rethought-demo.ass`

Build it from the repository root:

```powershell
.\demo-videos\scripts\build-rethought-demo.ps1
```

The default export is `outputs\asml-mistral-studio-workflow-demo-1080p.mp4`.

## Alternate improved edit

The alternate build condenses the original concept into a faster client-demo narrative while preserving the source master. It uses `assets\overlays\improved-demo.ass` and exports to `outputs\asml-mistral-improved-demo-1080p.mp4`.

```powershell
.\demo-videos\scripts\build-improved-demo.ps1
```

Both scripts accept custom source and output paths:

```powershell
.\demo-videos\scripts\build-improved-demo.ps1 `
    -InputPath 'C:\path\source.mp4' `
    -OutputPath 'C:\path\improved.mp4'
```

## Tooling

Install FFmpeg once:

```powershell
winget install --id Gyan.FFmpeg --exact
```

All builds share `scripts\video-build-common.ps1` for folder discovery, output preparation, FFmpeg discovery, and subtitle-path conversion. The field-enablement build uses the pinned neural-voice dependency in `scripts\neural-voice-requirements.txt` and generates each narration sentence separately for controlled pacing.

## Creative reference

The current field-enablement storyboard and approved narration are in `docs\field-enablement-demo.md`. The earlier 48-second concept remains documented in `docs\rethought-demo-script.md`.

The reusable, company- and role-neutral production methodology is documented in `docs\account-specific-demo-video-generation-playbook.md`. It covers briefing, workflow selection, role adaptation, scripting, footage, product proof, narration, music, overlays, disclosure, thumbnails, delivery specifications, quality gates, failure modes, and reusable templates.
