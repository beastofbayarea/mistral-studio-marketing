[CmdletBinding()]
param(
    [string]$InputPath,
    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot

if (-not $InputPath) {
    $InputPath = Join-Path $repoRoot 'ASMLxMistral_Final_Trim_NoCap_4K.mp4'
}

if (-not $OutputPath) {
    $OutputPath = Join-Path $repoRoot 'ASMLxMistral_Improved_Web_1080p.mp4'
}

$resolvedInput = Resolve-Path -LiteralPath $InputPath -ErrorAction Stop
$overlayPath = Resolve-Path -LiteralPath (Join-Path $repoRoot 'video-edit\improved-demo.ass') -ErrorAction Stop
$logoPath = Resolve-Path -LiteralPath (Join-Path $repoRoot 'official-designs-and-docs\logos\icon-monogram-m-orange-on-dark.png') -ErrorAction Stop

$outputDirectory = Split-Path -Parent ([System.IO.Path]::GetFullPath($OutputPath))
if (-not (Test-Path -LiteralPath $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
}

$ffmpegCommand = Get-Command ffmpeg -ErrorAction SilentlyContinue
if ($ffmpegCommand) {
    $ffmpegPath = $ffmpegCommand.Source
}
else {
    $wingetPackages = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'
    $ffmpegCandidate = Get-ChildItem -LiteralPath $wingetPackages -Directory -ErrorAction SilentlyContinue |
        Where-Object Name -Like 'Gyan.FFmpeg*' |
        ForEach-Object { Get-ChildItem -LiteralPath $_.FullName -Recurse -Filter ffmpeg.exe -ErrorAction SilentlyContinue } |
        Select-Object -First 1

    if (-not $ffmpegCandidate) {
        throw 'FFmpeg was not found. Install it with: winget install --id Gyan.FFmpeg --exact'
    }

    $ffmpegPath = $ffmpegCandidate.FullName
}

$assFilterPath = $overlayPath.Path.Replace('\', '/').Replace(':', '\:').Replace("'", "\'")

$filterGraph = @"
[0:v]
setpts=PTS/1.25,
scale=1920:1080:flags=lanczos,
eq=contrast=1.03:saturation=0.94:brightness=-0.015,
fade=t=in:st=0:d=0.45,
drawbox=x=0:y=0:w=iw:h=120:color=0x11121C@0.95:t=fill,
drawbox=x=0:y=840:w=iw:h=240:color=0x11121C@0.95:t=fill,
drawbox=x=0:y=120:w=iw:h=720:color=black@0.42:t=fill:enable='between(t,0,3.7)',
drawbox=x=0:y=120:w=940:h=720:color=0x11121C@0.82:t=fill:enable='between(t,32,40)',
drawbox=x=960:y=120:w=960:h=720:color=0x11121C@0.86:t=fill:enable='between(t,40,48)',
drawbox=x=0:y=120:w=iw:h=720:color=0x11121C@0.94:t=fill:enable='between(t,52,58)',
subtitles=filename='$assFilterPath'
[story];
[1:v]scale=64:64:flags=lanczos,format=rgba[brandmark];
[story][brandmark]overlay=30:28:format=auto,tpad=stop_mode=clone:stop_duration=2,fade=t=out:st=57.4:d=0.6[v];
[0:a]atempo=1.25,afade=t=in:st=0:d=0.25,afade=t=out:st=54.8:d=1.2,apad=pad_dur=2[a]
"@

$filterGraph = $filterGraph -replace "`r?`n", ''

$ffmpegArguments = @(
    '-hide_banner',
    '-y',
    '-i', $resolvedInput.Path,
    '-loop', '1',
    '-framerate', '30',
    '-i', $logoPath.Path,
    '-filter_complex', $filterGraph,
    '-map', '[v]',
    '-map', '[a]',
    '-c:v', 'libx264',
    '-preset', 'medium',
    '-crf', '19',
    '-profile:v', 'high',
    '-level:v', '4.2',
    '-pix_fmt', 'yuv420p',
    '-r', '30',
    '-g', '60',
    '-c:a', 'aac',
    '-b:a', '192k',
    '-ar', '48000',
    '-movflags', '+faststart',
    '-shortest',
    ([System.IO.Path]::GetFullPath($OutputPath))
)

& $ffmpegPath @ffmpegArguments

if ($LASTEXITCODE -ne 0) {
    throw "FFmpeg exited with code $LASTEXITCODE"
}

Write-Output ([System.IO.Path]::GetFullPath($OutputPath))
