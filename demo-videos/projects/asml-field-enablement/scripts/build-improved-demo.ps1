[CmdletBinding()]
param(
    [string]$InputPath,
    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '..\..\..\tooling\video-build-common.ps1')

$paths = Get-DemoVideoPaths -ScriptsRoot $PSScriptRoot

if (-not $InputPath) {
    $InputPath = Join-Path $paths.Masters 'asml-mistral-original-master-70s-2160p.mp4'
}

if (-not $OutputPath) {
    $OutputPath = Join-Path $paths.ArchivedOutputs 'asml-mistral-incident-workflow-demo-50s-1080p.mp4'
}

$resolvedInput = Resolve-Path -LiteralPath $InputPath -ErrorAction Stop
$overlayPath = Resolve-Path -LiteralPath (Join-Path $paths.Overlays 'improved-demo.ass') -ErrorAction Stop
$logoPath = Resolve-Path -LiteralPath (Join-Path $paths.RepoRoot 'official-designs-and-docs\logos\icon-monogram-m-orange-on-dark.png') -ErrorAction Stop

$absoluteOutputPath = Initialize-DemoOutputPath -OutputPath $OutputPath
$ffmpegPath = Resolve-FfmpegExecutable
$assFilterPath = ConvertTo-FfmpegSubtitlePath -Path $overlayPath.Path

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
    '-map_metadata', '-1',
    '-metadata', 'title=ASML x Mistral Incident Workflow Demo',
    '-metadata', 'artist=Shiv, Prospective PMM, Mistral Studio',
    '-metadata', 'comment=Unofficial portfolio concept for field enablement.',
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
    $absoluteOutputPath
)

& $ffmpegPath @ffmpegArguments

if ($LASTEXITCODE -ne 0) {
    throw "FFmpeg exited with code $LASTEXITCODE"
}

Write-Output $absoluteOutputPath
