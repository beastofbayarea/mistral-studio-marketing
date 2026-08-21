# Demo Video Production

This workspace separates reusable footage, the active client edit, and shared tooling.

## Structure

```text
demo-videos/
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
│       ├── exports/final/            # Current approved render
│       └── scripts/                  # Active project build
└── tooling/                          # Shared build helpers and dependencies
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

## Tooling

Install FFmpeg once:

```powershell
winget install --id Gyan.FFmpeg --exact
```

Shared folder discovery and FFmpeg helpers live in `tooling\video-build-common.ps1`. Narration dependencies are pinned in `tooling\neural-voice-requirements.txt`.
