# Contributing to Mistral Studio Marketing Assets

Thank you for contributing to the **Mistral Studio Marketing & Product Marketing Strategy** repository!

## 📋 Guidelines

1. **File & Folder Naming**: Use **lowercase kebab-case** for project files and subdirectories (e.g. `mistral-studio-banner.jpg`, `sales-and-field-enablement/`). Avoid spaces, underscores, or special characters (`&`). Keep GitHub-standard root documents such as `README.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, and `SECURITY.md` in their conventional form.
2. **Design Assets & Brand Compliance**: Ensure all visual assets, screenshots, banners, and diagrams are provided in high resolution (.png, .jpg, or .svg). All graphic assets must adhere strictly to the official [Mistral Logo & Brand Guidelines](official-designs-and-docs/mistral-logo-guidelines.pdf) (clearspace rules, minimum 100px lockup width, sunset gradient defaults, solid black/white monochrome on photography, and no wordmark recoloring or logo distortion).
3. **Data & Spreadsheets**: Keep Excel models and frameworks cleanly formatted in `.xlsx` or `.csv`.
4. **Metadata**: Give published documents and media descriptive titles, subjects, keywords, and attribution. Preserve known third-party attribution and do not infer missing authors or ownership.
5. **Pull Request Process**: Submit changes via Pull Requests with descriptive commit messages and details of modified collateral.

## Metadata maintenance

Install the pinned Python dependencies, then preview the metadata scope before applying it:

```powershell
python scripts/standardize-file-metadata.py
python scripts/standardize-file-metadata.py --apply
```

To include local MP4 files, provide both FFmpeg executables. The script remuxes the container and preserves the encoded audio and video streams:

```powershell
python scripts/standardize-file-metadata.py --apply --ffmpeg C:\path\to\ffmpeg.exe --ffprobe C:\path\to\ffprobe.exe
```
