# Demo Video Production

This workspace separates reusable footage from client-specific edits, shared tooling, and retired material.

## Structure

```text
demo-videos/
├── archive/                         # Duplicate or retired source material
├── library/footage/
│   ├── asml/                        # Client-specific ASML footage
│   ├── industrial/                  # Reusable manufacturing and technology footage
│   └── mistral/
│       ├── products/                # Mistral product footage
│       └── studio/                  # Mistral Studio demonstrations
├── projects/
│   └── asml-field-enablement/
│       ├── assets/                  # Narration, overlays, and thumbnails
│       ├── docs/                    # Storyboard and production notes
│       ├── exports/
│       │   ├── final/               # Current approved render
│       │   ├── archive/             # Superseded concepts
│       │   └── rejected/            # Cuts excluded from delivery
│       ├── scripts/                 # Project build scripts
│       └── source/masters/          # Original project masters
├── tooling/                         # Shared build helpers and dependencies
└── tmp/                             # Disposable working files
```

Video files are ignored by Git. Scripts, edit assets, documentation, and placeholder files remain version controlled.

## Current ASML build

From the repository root:

```powershell
.\demo-videos\projects\asml-field-enablement\scripts\build-field-enablement-demo.ps1
```

The current master is written to:

```text
projects\asml-field-enablement\exports\final\asml-mistral-field-enablement-ad-v2-48s-1080p.mp4
```

Use `-RegenerateNarration` after changing copy or voice direction. The full edit map is in `projects\asml-field-enablement\docs\field-enablement-demo.md`.

Earlier horizontal concepts remain reproducible through the other project scripts and write to `exports\archive`. The discarded vertical experiment writes to `exports\rejected`.

## Tooling

Install FFmpeg once:

```powershell
winget install --id Gyan.FFmpeg --exact
```

Shared folder discovery and FFmpeg helpers live in `tooling\video-build-common.ps1`. Narration dependencies are pinned in `tooling\neural-voice-requirements.txt`.
