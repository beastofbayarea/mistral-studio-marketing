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
[0:v]trim=start=0:end=30,setpts=PTS-STARTPTS[v0];
[0:v]trim=start=39.5:end=70,setpts=PTS-STARTPTS[v1];
[v0][v1]concat=n=2:v=1:a=0,
setpts=PTS/1.25,
scale=1920:1080:flags=lanczos,
eq=contrast=1.03:saturation=0.94:brightness=-0.015,
fade=t=in:st=0:d=0.45,
drawbox=x=0:y=0:w=iw:h=150:color=0x11121C@0.97:t=fill,
drawbox=x=0:y=770:w=iw:h=310:color=0x11121C@0.97:t=fill,
drawbox=x=0:y=150:w=iw:h=620:color=black@0.46:t=fill:enable='between(t,0,3.7)',
drawbox=x=0:y=150:w=940:h=620:color=0x11121C@0.88:t=fill:enable='between(t,28,35)',
drawbox=x=940:y=150:w=980:h=620:color=0x11121C@0.90:t=fill:enable='between(t,35,41.8)',
drawbox=x=0:y=150:w=iw:h=930:color=0x11121C@0.96:t=fill:enable='between(t,44.7,50.4)',
subtitles=filename='$assFilterPath'
[story];
[1:v]scale=82:82:flags=lanczos,format=rgba[brandmark];
[story][brandmark]overlay=30:34:format=auto,tpad=stop_mode=clone:stop_duration=2,fade=t=out:st=49.8:d=0.6[v];
[0:a]atrim=start=0:end=30,asetpts=PTS-STARTPTS[a0];
[0:a]atrim=start=39.5:end=70,asetpts=PTS-STARTPTS[a1];
[a0][a1]concat=n=2:v=0:a=1,atempo=1.25,afade=t=in:st=0:d=0.25,afade=t=out:st=47.2:d=1.2,apad=pad_dur=2[a]
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
