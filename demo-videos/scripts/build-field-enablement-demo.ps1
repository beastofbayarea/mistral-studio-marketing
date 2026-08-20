[CmdletBinding()]
param(
    [string]$OutputPath,
    [switch]$RegenerateNarration
)

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'video-build-common.ps1')

$paths = Get-DemoVideoPaths -ScriptsRoot $PSScriptRoot

if (-not $OutputPath) {
    $OutputPath = Join-Path $paths.Outputs 'asml-mistral-field-enablement-demo-75s-1080p.mp4'
}

$absoluteOutputPath = Initialize-DemoOutputPath -OutputPath $OutputPath
$ffmpegPath = Resolve-FfmpegExecutable
$ffprobePath = Join-Path (Split-Path -Parent $ffmpegPath) 'ffprobe.exe'

$computationalVideo = Resolve-Path -LiteralPath (Join-Path $paths.IndustryFootage 'asml-computational-lithography-720p.mp4') -ErrorAction Stop
$engineerVideo = Resolve-Path -LiteralPath (Join-Path $paths.IndustryFootage 'asml-mature-products-and-service-720p.mp4') -ErrorAction Stop
$workflowVideo = Resolve-Path -LiteralPath (Join-Path $paths.ProductFootage 'mistral-studio-introducing-workflows-720p.mp4') -ErrorAction Stop
$connectorVideo = Resolve-Path -LiteralPath (Join-Path $paths.ProductFootage 'mistral-studio-custom-connectors-720p.mp4') -ErrorAction Stop
$overlayPath = Resolve-Path -LiteralPath (Join-Path $paths.Overlays 'field-enablement-demo.ass') -ErrorAction Stop
$logoPath = Resolve-Path -LiteralPath (Join-Path $paths.RepoRoot 'official-designs-and-docs\logos\icon-monogram-m-orange-on-dark.png') -ErrorAction Stop
$fontDirectory = Resolve-Path -LiteralPath (Join-Path $paths.RepoRoot 'resources\fonts\silkscreen') -ErrorAction Stop
$narrationConfigPath = Resolve-Path -LiteralPath (Join-Path $paths.Narration 'field-enablement-narration.json') -ErrorAction Stop
$narrationConfig = Get-Content -LiteralPath $narrationConfigPath.Path -Raw | ConvertFrom-Json

$pythonCommand = Get-Command py -ErrorAction SilentlyContinue
if (-not $pythonCommand) {
    throw 'Python was not found. Install the narration dependency with a Python environment that provides edge-tts.'
}

$temporaryRoot = Join-Path $env:TEMP 'mistral-asml-field-enablement'
$sentenceDirectory = Join-Path $temporaryRoot 'narration'
New-Item -ItemType Directory -Path $sentenceDirectory -Force | Out-Null

$sentenceFiles = @()
for ($index = 0; $index -lt $narrationConfig.sentences.Count; $index++) {
    $sentence = $narrationConfig.sentences[$index]
    $sentencePath = Join-Path $sentenceDirectory ("sentence-{0:D2}.mp3" -f ($index + 1))

    if ($RegenerateNarration -or -not (Test-Path -LiteralPath $sentencePath -PathType Leaf)) {
        & $pythonCommand.Source -m edge_tts `
            --voice $narrationConfig.voice `
            --rate $narrationConfig.rate `
            --pitch $narrationConfig.pitch `
            --text $sentence.text `
            --write-media $sentencePath

        if ($LASTEXITCODE -ne 0) {
            throw "Narration generation failed for sentence $($index + 1). Install dependencies from scripts\neural-voice-requirements.txt."
        }
    }

    $sentenceFiles += $sentencePath
}

$narrationMixPath = Join-Path $temporaryRoot 'field-enablement-audio.wav'
$audioArguments = @('-hide_banner', '-y')
foreach ($sentenceFile in $sentenceFiles) {
    $audioArguments += @('-i', $sentenceFile)
}

$audioFilters = @()
$narrationLabels = @()
for ($index = 0; $index -lt $narrationConfig.sentences.Count; $index++) {
    $delay = [int]$narrationConfig.sentences[$index].startMilliseconds
    $label = "n$index"
    $audioFilters += "[${index}:a]aresample=48000,aformat=sample_fmts=fltp:channel_layouts=stereo,adelay=$delay|$delay,volume=1.08[$label]"
    $narrationLabels += "[$label]"
}

$duration = [double]$narrationConfig.durationSeconds
$durationText = $duration.ToString('0.###', [System.Globalization.CultureInfo]::InvariantCulture)
$audioFilters += (($narrationLabels -join '') + "amix=inputs=$($narrationLabels.Count):duration=longest:normalize=0[narration]")
$audioFilters += "aevalsrc='0.022*sin(2*PI*55*t)+0.008*sin(2*PI*110*t)':s=48000:d=$durationText,aformat=channel_layouts=stereo,lowpass=f=700,afade=t=in:st=0:d=2,afade=t=out:st=72:d=3[drone]"
$audioFilters += "anoisesrc=color=pink:amplitude=0.012:d=${durationText}:r=48000,aformat=channel_layouts=stereo,highpass=f=100,lowpass=f=900,volume=0.25,afade=t=in:st=0:d=2,afade=t=out:st=72:d=3[texture]"
$audioFilters += '[drone][texture]amix=inputs=2:duration=longest:normalize=0,volume=0.34[bed]'
$audioFilters += '[bed][narration]sidechaincompress=threshold=0.012:ratio=8:attack=15:release=320[ducked]'
$audioFilters += 'sine=frequency=430:sample_rate=48000:duration=0.32,afade=t=out:st=0:d=0.32,adelay=43800|43800,volume=0.07,aformat=channel_layouts=stereo[uncertainty]'
$audioFilters += 'sine=frequency=820:sample_rate=48000:duration=0.22,afade=t=out:st=0:d=0.22,adelay=56300|56300,volume=0.06,aformat=channel_layouts=stereo[approved]'
$audioFilters += "[ducked][narration][uncertainty][approved]amix=inputs=4:duration=longest:normalize=0,alimiter=limit=0.92,apad=pad_dur=0.2,atrim=duration=$durationText[a]"

$audioArguments += @(
    '-filter_complex', ($audioFilters -join ';'),
    '-map', '[a]',
    '-c:a', 'pcm_s16le',
    '-ar', '48000',
    $narrationMixPath
)

& $ffmpegPath @audioArguments
if ($LASTEXITCODE -ne 0) {
    throw "Narration mix failed with code $LASTEXITCODE"
}

$assFilterPath = ConvertTo-FfmpegSubtitlePath -Path $overlayPath.Path
$fontsFilterPath = ConvertTo-FfmpegSubtitlePath -Path $fontDirectory.Path

$filterGraph = @"
[0:v]trim=duration=7,setpts=PTS-STARTPTS,scale=920:1080:force_original_aspect_ratio=increase,crop=920:1080,eq=contrast=1.04:saturation=0.92,drawgrid=w=230:h=180:t=1:c=0xB7E3FF@0.12,pad=1920:1080:1000:0:color=0x151524,drawbox=x=960:y=0:w=40:h=1080:color=0xFF7000:t=fill,fps=30,setsar=1,format=yuv420p[s0];
[1:v]trim=duration=8,setpts=PTS-STARTPTS,crop=995:560:285:0,scale=1920:1080:flags=lanczos,eq=contrast=1.08:saturation=0.82,drawbox=x=28:y=28:w=1864:h=1024:color=0xB7E3FF@0.20:t=1,fps=30,setsar=1,format=yuv420p[s1];
[2:v]trim=duration=8,setpts=PTS-STARTPTS,crop=1030:580:125:55,scale=1920:1080:flags=lanczos,unsharp=5:5:0.30:5:5:0,drawbox=x=28:y=28:w=1864:h=1024:color=0xB7E3FF@0.20:t=1,fps=30,setsar=1,format=yuv420p[s2];
[3:v]trim=duration=12,setpts=PTS-STARTPTS,crop=995:560:285:0,scale=1920:1080:flags=lanczos,eq=contrast=1.08:saturation=0.82,drawbox=x=28:y=28:w=1864:h=1024:color=0xB7E3FF@0.20:t=1,fps=30,setsar=1,format=yuv420p[s3];
[4:v]trim=duration=8,setpts=PTS-STARTPTS,scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,eq=contrast=1.05:saturation=0.78:brightness=-0.04,drawgrid=w=240:h=180:t=1:c=0xB7E3FF@0.16,fps=30,setsar=1,format=yuv420p[s4];
[5:v]trim=duration=7,setpts=PTS-STARTPTS,crop=995:560:285:0,scale=1920:1080:flags=lanczos,eq=contrast=1.08:saturation=0.82,drawbox=x=28:y=28:w=1864:h=1024:color=0xFFB000@0.32:t=2,fps=30,setsar=1,format=yuv420p[s5];
[6:v]trim=duration=6,setpts=PTS-STARTPTS,crop=1280:600:0:0,scale=1920:1080:flags=lanczos,eq=contrast=1.04:saturation=0.88,drawbox=x=28:y=28:w=1864:h=1024:color=0xB7E3FF@0.20:t=1,fps=30,setsar=1,format=yuv420p[s6];
[7:v]trim=duration=6,setpts=PTS-STARTPTS,crop=995:560:285:0,scale=1920:1080:flags=lanczos,eq=contrast=1.08:saturation=0.82,drawbox=x=28:y=28:w=1864:h=1024:color=0x55D98C@0.36:t=2,fps=30,setsar=1,format=yuv420p[s7];
[8:v]trim=duration=7,setpts=PTS-STARTPTS,crop=995:560:285:0,scale=1920:1080:flags=lanczos,eq=contrast=1.08:saturation=0.82,drawbox=x=28:y=28:w=1864:h=1024:color=0xB7E3FF@0.20:t=1,fps=30,setsar=1,format=yuv420p[s8];
[9:v]trim=duration=6,setpts=PTS-STARTPTS,scale=660:1080:force_original_aspect_ratio=increase,crop=660:1080,eq=contrast=1.06:saturation=1.08,drawgrid=w=220:h=180:t=1:c=0xB7E3FF@0.13,pad=1920:1080:1260:0:color=0x151524,drawbox=x=1240:y=0:w=20:h=1080:color=0xFF7000:t=fill,fps=30,setsar=1,format=yuv420p[s9];
[s0][s1][s2][s3][s4][s5][s6][s7][s8][s9]concat=n=10:v=1:a=0,subtitles=filename='$assFilterPath':fontsdir='$fontsFilterPath'[story];
[10:v]scale=52:52:flags=lanczos,format=rgba[brandmark];
[story][brandmark]overlay=30:26:format=auto:enable='between(t,7,68.95)',fade=t=in:st=0:d=0.25,fade=t=out:st=74.45:d=0.55[v];
[11:a]atrim=duration=75,asetpts=PTS-STARTPTS[a]
"@

$filterGraph = $filterGraph -replace "`r?`n", ''

$videoArguments = @(
    '-hide_banner',
    '-y',
    '-ss', '116', '-t', '7', '-i', $computationalVideo.Path,
    '-ss', '145', '-t', '8', '-i', $workflowVideo.Path,
    '-ss', '43', '-t', '8', '-i', $connectorVideo.Path,
    '-ss', '152', '-t', '12', '-i', $workflowVideo.Path,
    '-ss', '56', '-t', '8', '-i', $computationalVideo.Path,
    '-ss', '164', '-t', '7', '-i', $workflowVideo.Path,
    '-ss', '328', '-t', '6', '-i', $engineerVideo.Path,
    '-ss', '166', '-t', '6', '-i', $workflowVideo.Path,
    '-ss', '145', '-t', '7', '-i', $workflowVideo.Path,
    '-ss', '116', '-t', '6', '-i', $computationalVideo.Path,
    '-loop', '1', '-framerate', '30', '-i', $logoPath.Path,
    '-i', $narrationMixPath,
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
    '-t', '75',
    $absoluteOutputPath
)

& $ffmpegPath @videoArguments
if ($LASTEXITCODE -ne 0) {
    throw "FFmpeg exited with code $LASTEXITCODE"
}

Write-Output $absoluteOutputPath
