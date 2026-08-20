# ASML × Mistral Demo Videos

This folder keeps the ASML client-demo source, generated edits, downloaded product and industry footage, build scripts, and edit assets together. Video filenames use lowercase kebab case and end with their resolution.

## Local video library

Demo masters and exports:

- `asml-mistral-original-master-4k.mp4`
- `asml-mistral-narrated-workflow-master-1080p.mp4`
- `asml-mistral-improved-demo-1080p.mp4`
- `asml-mistral-studio-workflow-demo-1080p.mp4`

Mistral Studio product footage:

- `mistral-studio-build-first-workflow-720p.mp4`
- `mistral-studio-versioned-prompts-and-skills-720p.mp4`
- `mistral-studio-update-versioned-skill-720p.mp4`
- `mistral-studio-introducing-workflows-720p.mp4`
- `mistral-studio-document-processing-workflow-720p.mp4`
- `mistral-studio-custom-connectors-720p.mp4`
- `mistral-studio-connector-auth-debugger-720p.mp4`
- `mistral-studio-deepwiki-database-advisor-agent-720p.mp4`

ASML, semiconductor, and industrial reference footage:

- `asml-computational-lithography-720p.mp4`
- `asml-high-na-euv-light-generation-720p.mp4`
- `asml-high-na-euv-reticle-stage-720p.mp4`
- `asml-high-na-euv-wafer-stage-720p.mp4`
- `asml-mature-products-and-service-720p.mp4`
- `asml-unveiling-high-na-euv-720p.mp4`
- `fraunhofer-300mm-semiconductor-cleanroom-tour-2024-720p.mp4`
- `imec-operator-day-in-the-life-720p.mp4`
- `semiconductor-wafer-inspection-and-metrology-720p.mp4`
- `cern-technician-meet-jamie-720p.mp4`
- `nasa-artemis-mission-control-launch-720p.mp4`
- `siemens-pratt-whitney-predictive-maintenance-720p.mp4`
- `skf-pulse-machine-monitoring-720p.mp4`

The improved edit turns the existing 70-second concept video into a clearer, faster 50-second client-demo narrative while preserving the original source file.

## What changes

- Introduces the ASML × Mistral AI new-workflow demo immediately.
- Speeds the edit to 80% of its original duration without removing any chapter.
- Removes the complete repeated incident-comparison narration from the second correlation segment.
- Adds presentation-scale typography, deliberate two-line wrapping, and enlarged narrative panels for readability from across a meeting room.
- Covers the most distracting generated interface copy with clean evidence-chain and source panels.
- Makes the human approval step explicit.
- Vertically centers the complete call-to-action block on the end card.
- Replaces the abrupt ending with an ASML-specific invitation to scope a high-value diagnostic workflow pilot.
- Exports a web-ready 1080p H.264 High Profile file with progressive-download metadata.

## Build

Install FFmpeg once:

```powershell
winget install --id Gyan.FFmpeg --exact
```

Place `asml-mistral-original-master-4k.mp4` in `demo-videos`, then run from the repository root:

```powershell
.\demo-videos\scripts\build-improved-demo.ps1
```

The default output is `demo-videos\asml-mistral-improved-demo-1080p.mp4`. Video files remain ignored by Git; the script and overlay source are the reusable, version-controlled assets.

Custom source and output paths are supported:

```powershell
.\demo-videos\scripts\build-improved-demo.ps1 -InputPath 'C:\path\source.mp4' -OutputPath 'C:\path\improved.mp4'
```

## Updated four-act master

The 48-second structure is Detect, Investigate, Explain, Approve, and Pilot. The update rebuilds the ASML scenes from `asml-mistral-original-master-4k.mp4`, keeps the approved narration and ambient bed from `asml-mistral-narrated-workflow-master-1080p.mp4`, and replaces the former static Studio images with real product usage from the downloaded Mistral videos.

Build it with:

```powershell
.\demo-videos\scripts\build-rethought-demo.ps1
```

The default output is `demo-videos\asml-mistral-studio-workflow-demo-1080p.mp4`. The browser viewports are cropped out of the source videos' decorative frames, sharpened for the 1080p export, and placed beneath presentation-scale lower thirds. The source script is documented in `edit-assets\rethought-demo-script.md`, and the overlay system is defined in `edit-assets\rethought-demo.ass`.
