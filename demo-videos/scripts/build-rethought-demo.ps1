[CmdletBinding()]
param(
    [string]$InputPath,
    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'

$demoRoot = Split-Path -Parent $PSScriptRoot
$repoRoot = Split-Path -Parent $demoRoot

if (-not $InputPath) {
    $InputPath = Join-Path $demoRoot 'ASMLxMistral_Final_Trim_NoCap_4K.mp4'
}

if (-not $OutputPath) {
    $OutputPath = Join-Path $demoRoot 'ASMLxMistral_Updated_Studio_Workflow_1080p.mp4'
}

$resolvedInput = Resolve-Path -LiteralPath $InputPath -ErrorAction Stop
$overlayPath = Resolve-Path -LiteralPath (Join-Path $demoRoot 'edit-assets\rethought-demo.ass') -ErrorAction Stop
$workflowVideo = Resolve-Path -LiteralPath (Join-Path $demoRoot 'Build your first Mistral Workflow 720P.mp4') -ErrorAction Stop
$skillVideo = Resolve-Path -LiteralPath (Join-Path $demoRoot 'Update a skill with versioning in Studio 720P.mp4') -ErrorAction Stop
$logoPath = Resolve-Path -LiteralPath (Join-Path $repoRoot 'official-designs-and-docs\logos\icon-monogram-m-orange-on-dark.png') -ErrorAction Stop
$narrationMaster = Resolve-Path -LiteralPath (Join-Path $demoRoot 'ASMLxMistral_Rethought_Workflow_1080p.mp4') -ErrorAction Stop

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
[0:v]trim=start=3:end=10.35,setpts=PTS-STARTPTS,scale=1920:1080:flags=lanczos,fps=30,format=yuv420p[s0];
[0:v]trim=start=14:end=21.35,setpts=PTS-STARTPTS,scale=1920:1080:flags=lanczos,fps=30,format=yuv420p[s1];
[1:v]trim=start=302.20:end=309.55,setpts=PTS-STARTPTS,crop=1030:580:125:55,scale=1920:1080:flags=lanczos,unsharp=5:5:0.35:5:5:0,fps=30,format=yuv420p[s2];
[0:v]trim=start=41:end=49.35,setpts=PTS-STARTPTS,scale=1920:1080:flags=lanczos,fps=30,format=yuv420p[s3];
[2:v]trim=start=59.50:end=65.85,setpts=PTS-STARTPTS,crop=1030:580:125:55,scale=1920:1080:flags=lanczos,unsharp=5:5:0.35:5:5:0,fps=30,format=yuv420p[s4];
[0:v]trim=start=55:end=61.35,setpts=PTS-STARTPTS,scale=1920:1080:flags=lanczos,fps=30,format=yuv420p[s5];
color=c=0x11121C:s=1920x1080:r=30:d=7[s6];
[s0][s1]xfade=transition=fade:duration=0.35:offset=7[x1];
[x1][s2]xfade=transition=fade:duration=0.35:offset=14[x2];
[x2][s3]xfade=transition=fade:duration=0.35:offset=21[x3];
[x3][s4]xfade=transition=fade:duration=0.35:offset=29[x4];
[x4][s5]xfade=transition=fade:duration=0.35:offset=35[x5];
[x5][s6]xfade=transition=fade:duration=0.35:offset=41,
eq=contrast=1.04:saturation=0.92:brightness=-0.02,
drawbox=x=0:y=0:w=iw:h=120:color=0x11121C@0.97:t=fill,
drawbox=x=0:y=780:w=iw:h=300:color=0x11121C@0.91:t=fill:enable='between(t,0,41)',
subtitles=filename='$assFilterPath'[story];
[3:v]scale=68:68:flags=lanczos,format=rgba[brandmark];
[story][brandmark]overlay=30:26:format=auto,fade=t=in:st=0:d=0.35,fade=t=out:st=47.5:d=0.5[v];
[4:a]aresample=48000,atrim=duration=48[a]
"@

$filterGraph = $filterGraph -replace "`r?`n", ''

$ffmpegArguments = @(
    '-hide_banner',
    '-y',
    '-i', $resolvedInput.Path,
    '-i', $workflowVideo.Path,
    '-i', $skillVideo.Path,
    '-loop', '1', '-framerate', '30', '-i', $logoPath.Path,
    '-i', $narrationMaster.Path,
    '-filter_complex', $filterGraph,
    '-map', '[v]',
    '-map', '[a]',
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
    '-t', '48',
    ([System.IO.Path]::GetFullPath($OutputPath))
)

& $ffmpegPath @ffmpegArguments

if ($LASTEXITCODE -ne 0) {
    throw "FFmpeg exited with code $LASTEXITCODE"
}

Write-Output ([System.IO.Path]::GetFullPath($OutputPath))
