# Improved ASML × Mistral Demo Edit

This edit turns the existing 70-second concept video into a clearer, faster 50-second client-demo narrative while preserving the original source file.

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

Place `ASMLxMistral_Final_Trim_NoCap_4K.mp4` in the repository root, then run:

```powershell
.\scripts\build-improved-demo.ps1
```

The default output is `ASMLxMistral_Improved_Web_1080p.mp4` in the repository root. Video files remain ignored by Git; the script and overlay source are the reusable, version-controlled assets.

Custom source and output paths are supported:

```powershell
.\scripts\build-improved-demo.ps1 -InputPath 'C:\path\source.mp4' -OutputPath 'C:\path\improved.mp4'
```

## Rethought four-act master

The from-scratch concept uses a new 48-second structure: Detect, Investigate, Explain, and Approve. It combines selected incident footage with real Mistral Studio workflow and execution-trace visuals, generates a single continuous voiceover locally, and closes with a vertically centered pilot invitation.

Install the pinned neural narration dependency once:

```powershell
python -m pip install --user --upgrade -r .\video-edit\neural-voice-requirements.txt
```

Build it with:

```powershell
.\scripts\build-rethought-demo.ps1
```

The default output is `ASMLxMistral_Rethought_Workflow_1080p.mp4`. Narration is produced sentence-by-sentence with the warm British-English `en-GB-RyanNeural` voice, with individually controlled pacing, pitch, and pauses. The source script is documented in `rethought-demo-script.md`, and the presentation-scale overlay system is defined in `rethought-demo.ass`.
