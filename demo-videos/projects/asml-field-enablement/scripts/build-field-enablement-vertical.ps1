[CmdletBinding()]
param(
    [string]$InputPath,
    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '..\..\..\tooling\video-build-common.ps1')

$paths = Get-DemoVideoPaths -ScriptsRoot $PSScriptRoot

if (-not $InputPath) {
    $InputPath = Join-Path $paths.Outputs 'asml-mistral-field-enablement-ad-v2-48s-1080p.mp4'
}

if (-not $OutputPath) {
    $OutputPath = Join-Path $paths.RejectedOutputs 'asml-mistral-field-enablement-tiktok-48s-1080x1920.mp4'
}

$absoluteInputPath = (Resolve-Path -LiteralPath $InputPath -ErrorAction Stop).Path
$absoluteOutputPath = Initialize-DemoOutputPath -OutputPath $OutputPath
$ffmpegPath = Resolve-FfmpegExecutable
$overlayPath = Resolve-Path -LiteralPath (Join-Path $paths.Overlays 'field-enablement-vertical.ass') -ErrorAction Stop
$logoPath = Resolve-Path -LiteralPath (Join-Path $paths.RepoRoot 'official-designs-and-docs\logos\icon-monogram-m-orange-on-dark.png') -ErrorAction Stop
$fontDirectory = Resolve-Path -LiteralPath (Join-Path $paths.RepoRoot 'resources\fonts\silkscreen') -ErrorAction Stop

$assFilterPath = ConvertTo-FfmpegSubtitlePath -Path $overlayPath.Path
$fontsFilterPath = ConvertTo-FfmpegSubtitlePath -Path $fontDirectory.Path

$filterGraph = @"
[0:v]trim=start=0:end=5.18,setpts=PTS-STARTPTS,crop=608:1080:(iw-608)/2:0,scale=1080:1920:flags=lanczos,eq=contrast=1.16:saturation=0.94:brightness=-0.04,drawgrid=w=180:h=240:t=1:c=0xFF7000@0.13,fps=30,setsar=1,format=yuv420p[intro];
[0:v]trim=start=5.18:end=42.52,setpts=PTS-STARTPTS,split=2[midbgsource][midfgsource];
[midbgsource]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=34:steps=2,eq=contrast=1.08:saturation=0.66:brightness=-0.22,drawbox=color=0x151524@0.34:t=fill,drawgrid=w=180:h=240:t=1:c=0xB7E3FF@0.08,fps=30,setsar=1[midbg];
[midfgsource]scale=1000:563:flags=lanczos,eq=contrast=1.06:saturation=0.94,setsar=1[midfg];
[midbg]drawbox=x=24:y=640:w=1032:h=603:color=0x151524@0.78:t=fill,drawbox=x=38:y=654:w=1004:h=575:color=0xB7E3FF@0.42:t=3[midframe];
[midframe][midfg]overlay=40:660:format=auto[mid];
[0:v]trim=start=42.52:end=47.7,setpts=PTS-STARTPTS,scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=26:steps=2,eq=contrast=1.12:saturation=0.92:brightness=-0.24,drawbox=color=0x151524@0.74:t=fill,drawgrid=w=180:h=240:t=1:c=0xFF7000@0.14,fps=30,setsar=1,format=yuv420p[cta];
[intro][mid][cta]concat=n=3:v=1:a=0,subtitles=filename='$assFilterPath':fontsdir='$fontsFilterPath'[story];
[1:v]scale=72:72:flags=lanczos,format=rgba[brandmark];
[story][brandmark]overlay=52:54:format=auto:enable='between(t,0,47.7)'[v];
[0:a]atrim=duration=47.7,asetpts=PTS-STARTPTS[a]
"@

$filterGraph = $filterGraph -replace "`r?`n", ''

$arguments = @(
    '-hide_banner',
    '-y',
    '-i', $absoluteInputPath,
    '-loop', '1', '-framerate', '30', '-i', $logoPath.Path,
    '-filter_complex', $filterGraph,
    '-map', '[v]',
    '-map', '[a]',
    '-map_metadata', '-1',
    '-metadata', 'title=ASML x Mistral Field Enablement Vertical Ad',
    '-metadata', 'artist=Shiv, Prospective PMM, Mistral Studio',
    '-metadata', 'comment=Unofficial portfolio concept for field enablement.',
    '-c:v', 'libx264',
    '-preset', 'medium',
    '-crf', '18',
    '-profile:v', 'high',
    '-level:v', '4.2',
    '-pix_fmt', 'yuv420p',
    '-r', '30',
    '-g', '60',
    '-c:a', 'aac',
    '-b:a', '192k',
    '-ar', '48000',
    '-movflags', '+faststart',
    '-t', '47.7',
    $absoluteOutputPath
)

& $ffmpegPath @arguments
if ($LASTEXITCODE -ne 0) {
    throw "FFmpeg exited with code $LASTEXITCODE"
}

Write-Output $absoluteOutputPath
