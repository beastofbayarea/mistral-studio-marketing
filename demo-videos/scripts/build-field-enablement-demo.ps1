[CmdletBinding()]
param(
    [string]$OutputPath,
    [switch]$RegenerateNarration
)

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'video-build-common.ps1')

$paths = Get-DemoVideoPaths -ScriptsRoot $PSScriptRoot

if (-not $OutputPath) {
    $OutputPath = Join-Path $paths.Outputs 'asml-mistral-field-enablement-ad-v2-48s-1080p.mp4'
}

$absoluteOutputPath = Initialize-DemoOutputPath -OutputPath $OutputPath
$ffmpegPath = Resolve-FfmpegExecutable
$ffprobePath = Join-Path (Split-Path -Parent $ffmpegPath) 'ffprobe.exe'

$computationalVideo = Resolve-Path -LiteralPath (Join-Path $paths.IndustryFootage 'asml-computational-lithography-720p.mp4') -ErrorAction Stop
$lightGenerationVideo = Resolve-Path -LiteralPath (Join-Path $paths.IndustryFootage 'asml-high-na-euv-light-generation-720p.mp4') -ErrorAction Stop
$unveilingVideo = Resolve-Path -LiteralPath (Join-Path $paths.IndustryFootage 'asml-unveiling-high-na-euv-720p.mp4') -ErrorAction Stop
$waferStageVideo = Resolve-Path -LiteralPath (Join-Path $paths.IndustryFootage 'asml-high-na-euv-wafer-stage-720p.mp4') -ErrorAction Stop
$engineerVideo = Resolve-Path -LiteralPath (Join-Path $paths.IndustryFootage 'fraunhofer-300mm-semiconductor-cleanroom-tour-2024-720p.mp4') -ErrorAction Stop
$asmlMistralVideo = Resolve-Path -LiteralPath (Join-Path $paths.IndustryFootage 'asml-mistral-advanced-lithography-customer-story-720p.mp4') -ErrorAction Stop
$metrologyVideo = Resolve-Path -LiteralPath (Join-Path $paths.IndustryFootage 'physik-instrumente-wafer-inspection-metrology-720p.mp4') -ErrorAction Stop
$waferTransportVideo = Resolve-Path -LiteralPath (Join-Path $paths.IndustryFootage 'rockwell-automated-wafer-transport-720p.mp4') -ErrorAction Stop
$opticsVideo = Resolve-Path -LiteralPath (Join-Path $paths.IndustryFootage 'zeiss-optics-chip-manufacturing-720p.mp4') -ErrorAction Stop
$workflowVideo = Resolve-Path -LiteralPath (Join-Path $paths.ProductFootage 'mistral-studio-introducing-workflows-720p.mp4') -ErrorAction Stop
$connectorVideo = Resolve-Path -LiteralPath (Join-Path $paths.ProductFootage 'mistral-studio-custom-connectors-720p.mp4') -ErrorAction Stop
$versionedSkillVideo = Resolve-Path -LiteralPath (Join-Path $paths.ProductFootage 'mistral-studio-update-versioned-skill-720p.mp4') -ErrorAction Stop
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
        $sentenceRate = if ($sentence.rate) { $sentence.rate } else { $narrationConfig.rate }
        $sentencePitch = if ($sentence.pitch) { $sentence.pitch } else { $narrationConfig.pitch }
        $sentenceVolume = if ($sentence.volume) { $sentence.volume } else { $narrationConfig.volume }

        & $pythonCommand.Source -m edge_tts `
            --voice $narrationConfig.voice `
            --rate $sentenceRate `
            --pitch $sentencePitch `
            --volume $sentenceVolume `
            --text $sentence.text `
            --write-media $sentencePath

        if ($LASTEXITCODE -ne 0) {
            throw "Narration generation failed for sentence $($index + 1). Install dependencies from scripts\neural-voice-requirements.txt."
        }
    }

    $sentenceFiles += $sentencePath
}

$audioPremixPath = Join-Path $temporaryRoot 'field-enablement-audio-premix.wav'
$narrationMixPath = Join-Path $temporaryRoot 'field-enablement-audio-mastered.wav'
$audioArguments = @('-hide_banner', '-y')
foreach ($sentenceFile in $sentenceFiles) {
    $audioArguments += @('-i', $sentenceFile)
}

$audioFilters = @()
$narrationLabels = @()
for ($index = 0; $index -lt $narrationConfig.sentences.Count; $index++) {
    $delay = [int]$narrationConfig.sentences[$index].startMilliseconds
    $mixGain = if ($narrationConfig.sentences[$index].mixGain) { [double]$narrationConfig.sentences[$index].mixGain } else { 1.0 }
    $cueVolume = (1.28 * $mixGain).ToString('0.###', [System.Globalization.CultureInfo]::InvariantCulture)
    $label = "n$index"
    $audioFilters += "[${index}:a]aresample=48000,aformat=sample_fmts=fltp:channel_layouts=stereo,adelay=$delay|$delay,volume=$cueVolume[$label]"
    $narrationLabels += "[$label]"
}

$duration = [double]$narrationConfig.durationSeconds
$durationText = $duration.ToString('0.###', [System.Globalization.CultureInfo]::InvariantCulture)
$audioFilters += (($narrationLabels -join '') + "amix=inputs=$($narrationLabels.Count):duration=longest:normalize=0[narrationRaw]")
$audioFilters += '[narrationRaw]highpass=f=85,lowpass=f=13000,equalizer=f=2800:width_type=o:width=1.4:g=2.2,equalizer=f=6200:width_type=o:width=1.1:g=1.5,acompressor=threshold=0.075:ratio=1.55:attack=5:release=75:makeup=1.22[voice]'
$audioFilters += "aevalsrc='0.020*sin(2*PI*73.42*t)+0.012*sin(2*PI*110*t)+0.009*sin(2*PI*146.83*t)+0.007*sin(2*PI*174.61*t)':s=48000:d=11.8,aformat=channel_layouts=stereo,lowpass=f=920,afade=t=in:st=0:d=0.65,afade=t=out:st=10.9:d=0.9[pad0]"
$audioFilters += "aevalsrc='0.020*sin(2*PI*58.27*t)+0.012*sin(2*PI*87.31*t)+0.009*sin(2*PI*116.54*t)+0.007*sin(2*PI*146.83*t)':s=48000:d=12.3,aformat=channel_layouts=stereo,lowpass=f=920,afade=t=in:st=0:d=0.65,afade=t=out:st=11.4:d=0.9,adelay=11180|11180[pad1]"
$audioFilters += "aevalsrc='0.020*sin(2*PI*87.31*t)+0.012*sin(2*PI*130.81*t)+0.009*sin(2*PI*174.61*t)+0.007*sin(2*PI*220*t)':s=48000:d=14.8,aformat=channel_layouts=stereo,lowpass=f=980,afade=t=in:st=0:d=0.65,afade=t=out:st=13.9:d=0.9,adelay=22780|22780[pad2]"
$audioFilters += "aevalsrc='0.020*sin(2*PI*65.41*t)+0.012*sin(2*PI*98*t)+0.009*sin(2*PI*130.81*t)+0.007*sin(2*PI*164.81*t)':s=48000:d=10.73,aformat=channel_layouts=stereo,lowpass=f=1020,afade=t=in:st=0:d=0.65,afade=t=out:st=9.8:d=0.93,adelay=36970|36970[pad3]"
$audioFilters += '[pad0][pad1][pad2][pad3]amix=inputs=4:duration=longest:normalize=0,volume=0.70[pad]'
$audioFilters += "aevalsrc='0.016*sin(2*PI*293.66*t)*exp(-10*mod(t\,2))':s=48000:d=$durationText,aformat=channel_layouts=stereo[arp0]"
$audioFilters += "aevalsrc='0.016*sin(2*PI*349.23*t)*exp(-10*mod(t\,2))':s=48000:d=47.2,aformat=channel_layouts=stereo,adelay=500|500[arp1]"
$audioFilters += "aevalsrc='0.016*sin(2*PI*440*t)*exp(-10*mod(t\,2))':s=48000:d=46.7,aformat=channel_layouts=stereo,adelay=1000|1000[arp2]"
$audioFilters += "aevalsrc='0.014*sin(2*PI*523.25*t)*exp(-10*mod(t\,2))':s=48000:d=46.2,aformat=channel_layouts=stereo,adelay=1500|1500[arp3]"
$audioFilters += '[arp0][arp1][arp2][arp3]amix=inputs=4:duration=longest:normalize=0,highpass=f=240,lowpass=f=2800,aecho=0.8:0.65:220|440:0.12|0.07,volume=0.72[arp]'
$audioFilters += "aevalsrc='0.035*sin(2*PI*54*t)*exp(-17*mod(t\,0.5))+0.012*sin(2*PI*108*t)*exp(-21*mod(t\,0.5))':s=48000:d=$durationText,aformat=channel_layouts=stereo,lowpass=f=210,volume=0.78[pulse]"
$audioFilters += "anoisesrc=color=pink:amplitude=0.006:d=${durationText}:r=48000,aformat=channel_layouts=stereo,highpass=f=3600,lowpass=f=9200,tremolo=f=4:d=0.82,volume=0.05[texture]"
$audioFilters += "aevalsrc='0.015*sin(2*PI*392*t)*exp(-8*mod(t\,0.5))+0.009*sin(2*PI*659.25*t)*exp(-9*mod(t\,1))':s=48000:d=5.18,aformat=channel_layouts=stereo,highpass=f=300,lowpass=f=3200,afade=t=in:st=0:d=0.35,afade=t=out:st=4.5:d=0.68,adelay=42520|42520[ctaLift]"
$audioFilters += "[pad][arp][pulse][texture][ctaLift]amix=inputs=5:duration=longest:normalize=0,acompressor=threshold=0.09:ratio=1.5:attack=20:release=250:makeup=1,volume='if(lt(t\,5.18)\,0.92\,if(lt(t\,16.34)\,0.62\,if(lt(t\,32.38)\,0.76\,if(lt(t\,42.52)\,0.90\,1.04))))':eval=frame[scoreRaw]"
$audioFilters += '[voice]asplit=2[voiceMain][voiceKey]'
$audioFilters += '[scoreRaw][voiceKey]sidechaincompress=threshold=0.035:ratio=5:attack=10:release=220:makeup=1[scoreDucked]'
$audioFilters += "aevalsrc='0.034*sin(2*PI*48*t)*exp(-11*mod(t\,1))':s=48000:d=4,aformat=channel_layouts=stereo,lowpass=f=160,volume=0.75[introimpact]"
$audioFilters += 'sine=frequency=430:sample_rate=48000:duration=0.32,afade=t=out:st=0:d=0.32,adelay=22780|22780,volume=0.07,aformat=channel_layouts=stereo[uncertainty]'
$audioFilters += 'sine=frequency=820:sample_rate=48000:duration=0.22,afade=t=out:st=0:d=0.22,adelay=32380|32380,volume=0.06,aformat=channel_layouts=stereo[approved]'
$audioFilters += "[scoreDucked][voiceMain][introimpact][uncertainty][approved]amix=inputs=5:duration=longest:normalize=0,alimiter=limit=0.95,apad=pad_dur=0.2,atrim=duration=$durationText[a]"

$audioArguments += @(
    '-filter_complex', ($audioFilters -join ';'),
    '-map', '[a]',
    '-c:a', 'pcm_s24le',
    '-ar', '48000',
    $audioPremixPath
)

& $ffmpegPath @audioArguments
if ($LASTEXITCODE -ne 0) {
    throw "Narration mix failed with code $LASTEXITCODE"
}

$loudnessScan = & $ffmpegPath `
    -hide_banner `
    -nostats `
    -i $audioPremixPath `
    -af 'loudnorm=I=-16:TP=-1.5:LRA=10:print_format=json' `
    -f null `
    NUL 2>&1 | Out-String

if ($LASTEXITCODE -ne 0) {
    throw "Narration loudness analysis failed with code $LASTEXITCODE"
}

$loudnessJson = [regex]::Match($loudnessScan, '(?s)\{.*?\}').Value
if (-not $loudnessJson) {
    throw 'Narration loudness analysis did not return measurement data.'
}

$loudness = $loudnessJson | ConvertFrom-Json
$loudnessFilter = "loudnorm=I=-16:TP=-1.5:LRA=10:measured_I=$($loudness.input_i):measured_TP=$($loudness.input_tp):measured_LRA=$($loudness.input_lra):measured_thresh=$($loudness.input_thresh):offset=$($loudness.target_offset):linear=true"

& $ffmpegPath `
    -hide_banner `
    -loglevel error `
    -y `
    -i $audioPremixPath `
    -af $loudnessFilter `
    -ar 48000 `
    -c:a pcm_s24le `
    $narrationMixPath

if ($LASTEXITCODE -ne 0) {
    throw "Narration mastering failed with code $LASTEXITCODE"
}

$assFilterPath = ConvertTo-FfmpegSubtitlePath -Path $overlayPath.Path
$fontsFilterPath = ConvertTo-FfmpegSubtitlePath -Path $fontDirectory.Path

$filterGraph = @"
[0:v]trim=duration=0.85,setpts=PTS-STARTPTS,crop=1080:608:40:56,scale=1920:1080,zoompan=z='min(zoom+0.003,1.06)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:s=1920x1080:fps=30,eq=contrast=1.18:saturation=0.72:brightness=-0.08,drawbox=color=0x151524@0.26:t=fill,drawgrid=w=240:h=180:t=1:c=0xFF7000@0.16,setsar=1,format=yuv420p[s0];
[1:v]trim=duration=0.85,setpts=PTS-STARTPTS,scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,zoompan=z='min(zoom+0.003,1.06)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:s=1920x1080:fps=30,eq=contrast=1.18:saturation=1.08:brightness=-0.08,drawbox=color=0x151524@0.24:t=fill,drawgrid=w=240:h=180:t=1:c=0xFF7000@0.16,setsar=1,format=yuv420p[s1];
[2:v]trim=duration=1.6,setpts=PTS-STARTPTS,scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,zoompan=z='min(zoom+0.002,1.06)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:s=1920x1080:fps=30,eq=contrast=1.18:saturation=0.78:brightness=-0.08,drawbox=color=0x151524@0.24:t=fill,drawgrid=w=240:h=180:t=1:c=0xFF7000@0.16,setsar=1,format=yuv420p[s2];
[3:v]trim=duration=1.88,setpts=PTS-STARTPTS,scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,zoompan=z='min(zoom+0.0015,1.06)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:s=1920x1080:fps=30,eq=contrast=1.18:saturation=0.78:brightness=-0.08,drawbox=color=0x151524@0.24:t=fill,drawgrid=w=240:h=180:t=1:c=0xFF7000@0.16,setsar=1,format=yuv420p[s3];
[4:v]trim=duration=2,setpts=PTS-STARTPTS,crop=1280:600:0:0,scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,eq=contrast=1.08:saturation=0.94:brightness=-0.04,drawgrid=w=240:h=180:t=1:c=0xB7E3FF@0.12,fps=30,setsar=1,format=yuv420p[s4];
[5:v]trim=duration=2,setpts=PTS-STARTPTS,scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,eq=contrast=1.07:saturation=0.90,drawgrid=w=240:h=180:t=1:c=0xB7E3FF@0.11,fps=30,setsar=1,format=yuv420p[s5];
[6:v]trim=duration=2,setpts=PTS-STARTPTS,crop=1080:608:40:56,scale=1920:1080,eq=contrast=1.09:saturation=0.87:brightness=-0.04,drawgrid=w=240:h=180:t=1:c=0xB7E3FF@0.13,fps=30,setsar=1,format=yuv420p[s6];
[7:v]trim=duration=2.35,setpts=PTS-STARTPTS,crop=1030:580:125:55,scale=1480:832:flags=lanczos,unsharp=5:5:0.28:5:5:0,pad=1920:1080:400:124:color=0x151524,drawbox=x=380:y=104:w=1520:h=872:color=0xB7E3FF@0.32:t=2,fps=30,setsar=1,format=yuv420p[s7];
[8:v]trim=duration=2.81,setpts=PTS-STARTPTS,crop=995:460:285:0,scale=1480:684:flags=lanczos,eq=contrast=1.10:saturation=0.84,pad=1920:1080:400:198:color=0x151524,drawbox=x=380:y=178:w=1520:h=724:color=0xB7E3FF@0.34:t=2,fps=30,setsar=1,format=yuv420p[s8];
[9:v]trim=duration=2.2,setpts=PTS-STARTPTS,crop=1180:620:50:25,scale=1480:778:flags=lanczos,eq=contrast=1.05:saturation=0.92,pad=1920:1080:400:151:color=0x151524,drawbox=x=380:y=131:w=1520:h=818:color=0xB7E3FF@0.38:t=2,fps=30,setsar=1,format=yuv420p[s9];
[10:v]trim=duration=2.1,setpts=PTS-STARTPTS,scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,zoompan=z='min(zoom+0.0012,1.04)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:s=1920x1080:fps=30,eq=contrast=1.16:saturation=0.92:brightness=-0.03,drawbox=x=960:y=235:w=570:h=600:color=0xFF7000@0.55:t=3:enable='between(t,0.45,2.1)',drawgrid=w=240:h=180:t=1:c=0xB7E3FF@0.13,setsar=1,format=yuv420p[s10];
[11:v]trim=duration=2.14,setpts=PTS-STARTPTS,crop=995:460:285:0,scale=1480:684:flags=lanczos,eq=contrast=1.10:saturation=0.84,pad=1920:1080:400:198:color=0x151524,drawbox=x=380:y=178:w=1520:h=724:color=0xB7E3FF@0.34:t=2,fps=30,setsar=1,format=yuv420p[s11];
[12:v]trim=duration=2.3,setpts=PTS-STARTPTS,crop=995:460:285:0,scale=1480:684:flags=lanczos,eq=contrast=1.10:saturation=0.84,pad=1920:1080:400:198:color=0x151524,drawbox=x=380:y=178:w=1520:h=724:color=0xFFB000@0.50:t=3,fps=30,setsar=1,format=yuv420p[s12];
[13:v]trim=duration=2.26,setpts=PTS-STARTPTS,crop=1080:608:40:56,scale=1920:1080,eq=contrast=1.10:saturation=0.90:brightness=-0.05,drawgrid=w=240:h=180:t=1:c=0xFFB000@0.14,fps=30,setsar=1,format=yuv420p[s13];
[14:v]trim=duration=4,setpts=PTS-STARTPTS,crop=1280:620:0:0,scale=1920:930:flags=lanczos,pad=1920:1080:0:75:color=0x151524,eq=contrast=1.06:saturation=0.90:brightness=-0.02,drawbox=x=28:y=28:w=1864:h=1024:color=0xB7E3FF@0.22:t=1,fps=30,setsar=1,format=yuv420p[s14];
[15:v]trim=duration=1.04,setpts=PTS-STARTPTS,crop=1180:620:50:25,scale=1480:778:flags=lanczos,eq=contrast=1.05:saturation=0.92,pad=1920:1080:400:151:color=0x151524,drawbox=x=380:y=131:w=1520:h=818:color=0xB7E3FF@0.38:t=2,fps=30,setsar=1,format=yuv420p[s15];
[16:v]trim=duration=2.3,setpts=PTS-STARTPTS,crop=995:460:285:0,scale=1480:684:flags=lanczos,eq=contrast=1.10:saturation=0.84,pad=1920:1080:400:198:color=0x151524,drawbox=x=380:y=178:w=1520:h=724:color=0x55D98C@0.52:t=3,fps=30,setsar=1,format=yuv420p[s16];
[17:v]trim=duration=1,setpts=PTS-STARTPTS,crop=995:460:285:0,scale=1480:684:flags=lanczos,eq=contrast=1.10:saturation=0.84,pad=1920:1080:400:198:color=0x151524,drawbox=x=380:y=178:w=1520:h=724:color=0x55D98C@0.52:t=3,fps=30,setsar=1,format=yuv420p[s17];
[18:v]trim=duration=1.29,setpts=PTS-STARTPTS,scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,eq=contrast=1.09:saturation=0.84:brightness=-0.04,drawgrid=w=240:h=180:t=1:c=0x55D98C@0.14,fps=30,setsar=1,format=yuv420p[s18];
[19:v]trim=duration=1.85,setpts=PTS-STARTPTS,scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,eq=contrast=1.08:saturation=0.92:brightness=-0.02,drawgrid=w=240:h=180:t=1:c=0x55D98C@0.12,fps=30,setsar=1,format=yuv420p[s19];
[20:v]trim=duration=1.85,setpts=PTS-STARTPTS,crop=1080:608:40:56,scale=1920:1080,eq=contrast=1.08:saturation=0.80:brightness=-0.04,drawgrid=w=240:h=180:t=1:c=0x55D98C@0.14,fps=30,setsar=1,format=yuv420p[s20];
[21:v]trim=duration=1.85,setpts=PTS-STARTPTS,scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,eq=contrast=1.08:saturation=0.92:brightness=-0.02,drawgrid=w=240:h=180:t=1:c=0x55D98C@0.14,fps=30,setsar=1,format=yuv420p[s21];
[22:v]trim=duration=0.04,setpts=PTS-STARTPTS,fps=30,tpad=stop_mode=clone:stop_duration=5.14,scale=660:372:force_original_aspect_ratio=decrease,pad=660:1080:0:354:color=0x000000,eq=contrast=1.08:saturation=1.08,drawgrid=w=220:h=180:t=1:c=0xB7E3FF@0.14,pad=1920:1080:1260:0:color=0x151524,drawbox=x=1240:y=0:w=20:h=1080:color=0xFF7000:t=fill,setsar=1,format=yuv420p[s22];
[s0][s1][s2][s3][s4][s5][s6][s7][s8][s9][s10][s11][s12][s13][s14][s15][s16][s17][s18][s19][s20][s21][s22]concat=n=23:v=1:a=0,subtitles=filename='$assFilterPath':fontsdir='$fontsFilterPath'[story];
[23:v]scale=52:52:flags=lanczos,format=rgba[brandmark];
[story][brandmark]overlay=30:26:format=auto:enable='between(t,5.18,42.47)',fade=t=in:st=0:d=0.18,fade=t=out:st=47.15:d=0.55[v];
[24:a]atrim=duration=$durationText,asetpts=PTS-STARTPTS[a]
"@

$filterGraph = $filterGraph -replace "`r?`n", ''

$videoArguments = @(
    '-hide_banner',
    '-y',
    '-ss', '44', '-t', '0.85', '-i', $metrologyVideo.Path,
    '-ss', '56', '-t', '0.85', '-i', $lightGenerationVideo.Path,
    '-ss', '57', '-t', '1.6', '-i', $waferStageVideo.Path,
    '-ss', '8', '-t', '1.88', '-i', $unveilingVideo.Path,
    '-ss', '30.8', '-t', '2', '-i', $opticsVideo.Path,
    '-ss', '78', '-t', '2', '-i', $waferTransportVideo.Path,
    '-ss', '36.5', '-t', '2', '-i', $metrologyVideo.Path,
    '-ss', '43', '-t', '2.35', '-i', $connectorVideo.Path,
    '-ss', '145', '-t', '2.81', '-i', $workflowVideo.Path,
    '-ss', '23', '-t', '2.2', '-i', $versionedSkillVideo.Path,
    '-ss', '94.6', '-t', '2.1', '-i', $computationalVideo.Path,
    '-ss', '152', '-t', '2.14', '-i', $workflowVideo.Path,
    '-ss', '164', '-t', '2.3', '-i', $workflowVideo.Path,
    '-ss', '164', '-t', '2.26', '-i', $metrologyVideo.Path,
    '-ss', '127', '-t', '4', '-i', $engineerVideo.Path,
    '-ss', '52', '-t', '1.04', '-i', $versionedSkillVideo.Path,
    '-ss', '166', '-t', '2.3', '-i', $workflowVideo.Path,
    '-ss', '168.3', '-t', '1', '-i', $workflowVideo.Path,
    '-ss', '160.5', '-t', '1.29', '-i', $waferTransportVideo.Path,
    '-ss', '145', '-t', '1.85', '-i', $waferTransportVideo.Path,
    '-ss', '185.8', '-t', '1.85', '-i', $metrologyVideo.Path,
    '-ss', '165', '-t', '1.85', '-i', $waferTransportVideo.Path,
    '-ss', '96.5', '-t', '0.08', '-i', $asmlMistralVideo.Path,
    '-loop', '1', '-framerate', '30', '-i', $logoPath.Path,
    '-i', $narrationMixPath,
    '-filter_complex', $filterGraph,
    '-map', '[v]',
    '-map', '[a]',
    '-map_metadata', '-1',
    '-metadata', 'title=ASML x Mistral Field Enablement Ad',
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
    '-t', $durationText,
    $absoluteOutputPath
)

& $ffmpegPath @videoArguments
if ($LASTEXITCODE -ne 0) {
    throw "FFmpeg exited with code $LASTEXITCODE"
}

Write-Output $absoluteOutputPath
