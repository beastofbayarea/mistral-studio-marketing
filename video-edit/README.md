# Improved ASML × Mistral Demo Edit

This edit turns the existing 70-second concept video into a clearer, faster 56-second narrative while preserving the original source file.

## What changes

- Introduces the ASML × Mistral AI story immediately.
- Speeds the edit to 80% of its original duration without removing any chapter.
- Adds a consistent branded header and readable narrative captions.
- Covers the most distracting generated interface copy with clean evidence-chain and source panels.
- Makes the human approval step explicit.
- Replaces the abrupt ending with a clear root-cause and corrective-action conclusion.
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
