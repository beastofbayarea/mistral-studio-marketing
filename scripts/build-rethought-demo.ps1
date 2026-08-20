[CmdletBinding()]
param(
    [string]$InputPath,
    [string]$OutputPath,
    [string]$NarrationVoice = 'en-GB-RyanNeural'
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot

if (-not $InputPath) {
    $InputPath = Join-Path $repoRoot 'ASMLxMistral_Final_Trim_NoCap_4K.mp4'
}

if (-not $OutputPath) {
    $OutputPath = Join-Path $repoRoot 'ASMLxMistral_Rethought_Workflow_1080p.mp4'
}

$resolvedInput = Resolve-Path -LiteralPath $InputPath -ErrorAction Stop
$overlayPath = Resolve-Path -LiteralPath (Join-Path $repoRoot 'video-edit\rethought-demo.ass') -ErrorAction Stop
$workflowImage = Resolve-Path -LiteralPath (Join-Path $repoRoot 'resources\product-images\mistral-ai-studio-workflows-platform-mockup.png') -ErrorAction Stop
$traceImage = Resolve-Path -LiteralPath (Join-Path $repoRoot 'official-designs-and-docs\ui-screenshots\multi-turn-workflow-execution-trace.png') -ErrorAction Stop
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

$pythonCommand = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonCommand) {
    throw 'Python was not found. Install Python, then install the neural voice dependency from video-edit\neural-voice-requirements.txt.'
}

$pythonPath = $pythonCommand.Source
& $pythonPath -c 'import edge_tts'
if ($LASTEXITCODE -ne 0) {
    throw 'The neural voice dependency is missing. Run: python -m pip install --user --upgrade -r video-edit\neural-voice-requirements.txt'
}

$narrationWorkDir = Join-Path ([System.IO.Path]::GetTempPath()) ('asml-mistral-neural-{0}' -f [guid]::NewGuid().ToString('N'))
[System.IO.Directory]::CreateDirectory($narrationWorkDir) | Out-Null
$narrationPath = Join-Path $narrationWorkDir 'narration.wav'
$concatListPath = Join-Path $narrationWorkDir 'narration-concat.txt'

$narrationLines = @(
    [pscustomobject]@{ Text = 'When a production anomaly occurs, the evidence is rarely in one place.'; Rate = '-6%'; Pitch = '-1Hz'; GapMs = 500 },
    [pscustomobject]@{ Text = 'Logs, service history, and engineering documentation each hold part of the story.'; Rate = '-4%'; Pitch = '-1Hz'; GapMs = 520 },
    [pscustomobject]@{ Text = 'A Mistral Studio workflow brings those sources into one investigation.'; Rate = '-3%'; Pitch = '+0Hz'; GapMs = 460 },
    [pscustomobject]@{ Text = 'It retrieves the relevant evidence, compares similar incidents, and builds a concise, source-linked explanation.'; Rate = '-5%'; Pitch = '-1Hz'; GapMs = 560 },
    [pscustomobject]@{ Text = 'Engineers can inspect every step, challenge the diagnosis, and approve the next action.'; Rate = '-4%'; Pitch = '-1Hz'; GapMs = 520 },
    [pscustomobject]@{ Text = 'The result is a repeatable incident workflow, designed around your sources, engineering standards, and human control.'; Rate = '-5%'; Pitch = '-2Hz'; GapMs = 560 },
    [pscustomobject]@{ Text = "Let's pilot it on one high-value diagnostic use case."; Rate = '-4%'; Pitch = '-1Hz'; GapMs = 900 }
)

try {
    $concatEntries = New-Object System.Collections.Generic.List[string]

    for ($index = 0; $index -lt $narrationLines.Count; $index++) {
        $line = $narrationLines[$index]
        $sequence = $index + 1
        $lineMp3 = Join-Path $narrationWorkDir ('line-{0:D2}.mp3' -f $sequence)
        $lineWav = Join-Path $narrationWorkDir ('line-{0:D2}.wav' -f $sequence)
        $silenceWav = Join-Path $narrationWorkDir ('pause-{0:D2}.wav' -f $sequence)

        & $pythonPath -m edge_tts `
            '--voice' $NarrationVoice `
            ("--rate={0}" -f $line.Rate) `
            ("--pitch={0}" -f $line.Pitch) `
            '--text' $line.Text `
            '--write-media' $lineMp3

        if ($LASTEXITCODE -ne 0) {
            throw "Neural narration generation failed for line $sequence."
        }

        & $ffmpegPath -hide_banner -loglevel error -y -i $lineMp3 -ar 48000 -ac 1 -c:a pcm_s16le $lineWav
        if ($LASTEXITCODE -ne 0) {
            throw "Narration conversion failed for line $sequence."
        }

        $pauseSeconds = [Math]::Round($line.GapMs / 1000, 3)
        & $ffmpegPath -hide_banner -loglevel error -y -f lavfi -i 'anullsrc=r=48000:cl=mono' -t $pauseSeconds -c:a pcm_s16le $silenceWav
        if ($LASTEXITCODE -ne 0) {
            throw "Narration pause generation failed for line $sequence."
        }

        $lineConcatPath = $lineWav.Replace('\', '/')
        $silenceConcatPath = $silenceWav.Replace('\', '/')
        $concatEntries.Add("file '$lineConcatPath'")
        $concatEntries.Add("file '$silenceConcatPath'")
    }

    [System.IO.File]::WriteAllLines($concatListPath, $concatEntries, [System.Text.UTF8Encoding]::new($false))
    & $ffmpegPath -hide_banner -loglevel error -y -f concat -safe 0 -i $concatListPath -ar 48000 -ac 1 -c:a pcm_s16le $narrationPath

    if ($LASTEXITCODE -ne 0) {
        throw 'The sentence-level neural narration could not be assembled.'
    }
}
catch {
    if (Test-Path -LiteralPath $narrationWorkDir) {
        [System.IO.Directory]::Delete($narrationWorkDir, $true)
    }
    throw
}

$assFilterPath = $overlayPath.Path.Replace('\', '/').Replace(':', '\:').Replace("'", "\'")

$filterGraph = @"
[0:v]trim=start=3:end=10.35,setpts=PTS-STARTPTS,scale=1920:1080:flags=lanczos,fps=30,format=yuv420p[s0];
[0:v]trim=start=14:end=21.35,setpts=PTS-STARTPTS,scale=1920:1080:flags=lanczos,fps=30,format=yuv420p[s1];
[1:v]trim=duration=7.35,setpts=PTS-STARTPTS,scale=1920:-1:flags=lanczos,crop=1920:1080:x=0:y='45+18*sin(t*0.45)',fps=30,format=yuv420p[s2];
[0:v]trim=start=41:end=49.35,setpts=PTS-STARTPTS,scale=1920:1080:flags=lanczos,fps=30,format=yuv420p[s3];
[2:v]trim=duration=6.35,setpts=PTS-STARTPTS,scale=-1:1080:flags=lanczos,crop=1920:1080:x='53+28*sin(t*0.4)':y=0,fps=30,format=yuv420p[s4];
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
drawbox=x=0:y=710:w=iw:h=370:color=0x11121C@0.91:t=fill:enable='between(t,0,14)+between(t,21,29)+between(t,35,41)',
drawbox=x=0:y=120:w=760:h=960:color=0x11121C@0.90:t=fill:enable='between(t,14,21)+between(t,29,35)',
subtitles=filename='$assFilterPath'[story];
[3:v]scale=68:68:flags=lanczos,format=rgba[brandmark];
[story][brandmark]overlay=30:26:format=auto,fade=t=in:st=0:d=0.35,fade=t=out:st=47.5:d=0.5[v];
[4:a]aresample=48000,volume=1.08,apad=pad_dur=48,atrim=duration=48[narration];
aevalsrc='0.018*sin(2*PI*55*t)+0.007*sin(2*PI*110*t)':s=48000:d=48,afade=t=in:st=0:d=2,afade=t=out:st=45:d=3[bed];
[narration][bed]amix=inputs=2:duration=longest:dropout_transition=0,alimiter=limit=0.92,atrim=duration=48[a]
"@

$filterGraph = $filterGraph -replace "`r?`n", ''

$ffmpegArguments = @(
    '-hide_banner',
    '-y',
    '-i', $resolvedInput.Path,
    '-loop', '1', '-framerate', '30', '-i', $workflowImage.Path,
    '-loop', '1', '-framerate', '30', '-i', $traceImage.Path,
    '-loop', '1', '-framerate', '30', '-i', $logoPath.Path,
    '-i', $narrationPath,
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

try {
    & $ffmpegPath @ffmpegArguments

    if ($LASTEXITCODE -ne 0) {
        throw "FFmpeg exited with code $LASTEXITCODE"
    }
}
finally {
    if (Test-Path -LiteralPath $narrationWorkDir) {
        [System.IO.Directory]::Delete($narrationWorkDir, $true)
    }
}

Write-Output ([System.IO.Path]::GetFullPath($OutputPath))
