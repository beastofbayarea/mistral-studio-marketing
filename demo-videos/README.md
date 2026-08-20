# ASML × Mistral Demo Videos

This folder keeps the ASML client-demo source, generated edits, downloaded Mistral Studio product footage, build scripts, and edit assets together.

The three downloaded product-footage references are:

- `Build your first Mistral Workflow 720P.mp4`
- `Introducing versioned prompts and skills in Studio 720P.mp4`
- `Update a skill with versioning in Studio 720P.mp4`

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

Place `ASMLxMistral_Final_Trim_NoCap_4K.mp4` in `demo-videos`, then run from the repository root:

```powershell
.\demo-videos\scripts\build-improved-demo.ps1
```

The default output is `demo-videos\ASMLxMistral_Improved_Web_1080p.mp4`. Video files remain ignored by Git; the script and overlay source are the reusable, version-controlled assets.

Custom source and output paths are supported:

```powershell
.\demo-videos\scripts\build-improved-demo.ps1 -InputPath 'C:\path\source.mp4' -OutputPath 'C:\path\improved.mp4'
```

## Updated four-act master

The 48-second structure is Detect, Investigate, Explain, Approve, and Pilot. The update rebuilds the ASML scenes from `ASMLxMistral_Final_Trim_NoCap_4K.mp4`, keeps the approved narration and ambient bed from `ASMLxMistral_Rethought_Workflow_1080p.mp4`, and replaces the former static Studio images with real product usage from the downloaded Mistral videos.

Build it with:

```powershell
.\demo-videos\scripts\build-rethought-demo.ps1
```

The default output is `demo-videos\ASMLxMistral_Updated_Studio_Workflow_1080p.mp4`. The browser viewports are cropped out of the source videos' decorative frames, sharpened for the 1080p export, and placed beneath presentation-scale lower thirds. The source script is documented in `edit-assets\rethought-demo-script.md`, and the overlay system is defined in `edit-assets\rethought-demo.ass`.
