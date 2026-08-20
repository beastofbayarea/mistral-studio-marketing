# ASML × Mistral Demo Videos

This is the self-contained production workspace for the ASML client demo. Source footage, reusable edit assets, build tooling, creative documentation, and generated exports are separated so each file has one clear role.

## Structure

```text
demo-videos/
├── assets/
│   └── overlays/                  # Version-controlled subtitle and graphic overlays
├── docs/                          # Storyboard, narration, and production guidance
├── outputs/                       # Generated review and delivery exports
├── scripts/                       # Build scripts and shared PowerShell helpers
└── source-footage/
    ├── industry/                  # ASML, semiconductor, and industrial reference clips
    ├── masters/                   # Original and narrated ASML × Mistral masters
    └── mistral-studio/            # Mistral Studio product demonstrations
```

Video files are intentionally ignored by Git. The folder structure, scripts, overlays, and documentation remain version controlled.

## Primary workflow demo

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

The two builds share `scripts\video-build-common.ps1` for folder discovery, output preparation, FFmpeg discovery, and subtitle-path conversion. Optional neural-voice experiments use the pinned dependency in `scripts\neural-voice-requirements.txt`.

## Creative reference

The current storyboard, approved narration, and production principles are in `docs\rethought-demo-script.md`. The primary edit uses presentation-scale lower thirds, real Mistral Studio product footage, explicit engineer approval, and a vertically centered ASML-specific pilot call to action.
