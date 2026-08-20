# ASML × Mistral Field Enablement Ad

## Delivery

- Runtime: 55 seconds
- Format: 1920 × 1080, 30 fps, H.264 High Profile, AAC stereo
- Master: `outputs\asml-mistral-field-enablement-ad-55s-1080p.mp4`
- Build: `scripts\build-field-enablement-demo.ps1`
- Overlay source: `assets\overlays\field-enablement-demo.ass`
- Narration source: `assets\narration\field-enablement-narration.json`

This is a fast field-enablement conversation starter that can also run as a short-form account ad. It presents a representative synthetic-data scenario, not a claim that the depicted workflow is currently deployed at ASML.

## Story structure

| Time | Beat | Message |
|---:|---|---|
| 00:00–00:04 | Immediate hook | Anomaly detected. Evidence scattered. Every second counts. |
| 00:04–00:10 | Establish complexity | Signals can begin across optics, stages, sensors, equipment, and service logs. |
| 00:10–00:16 | Introduce Mistral | Bring every source into one controlled, traceable investigation. |
| 00:16–00:28 | Build the brief | Compare prior incidents, surface conflicting signals, and create a concise diagnostic brief. |
| 00:28–00:35 | Handle uncertainty | Ask for more evidence instead of guessing; keep the engineer in control. |
| 00:35–00:42 | Approve action | Only an engineer-approved action moves forward. |
| 00:42–00:49 | State the outcome | Faster investigation, stronger evidence, and a clear path to action. |
| 00:49–00:55 | Convert interest | Define one high-value workflow and launch a measurable pilot. |

## Source edit map

| Edit time | Source file | Source in | Purpose |
|---:|---|---:|---|
| 00:00–00:01 | `source-footage\industry\asml-computational-lithography-720p.mp4` | 01:56 | Anomaly impact shot |
| 00:01–00:02 | `source-footage\industry\asml-high-na-euv-light-generation-720p.mp4` | 00:56 | Detection impact shot |
| 00:02–00:03 | `source-footage\industry\asml-high-na-euv-wafer-stage-720p.mp4` | 00:57 | Scattered-evidence impact shot |
| 00:03–00:04 | `source-footage\industry\asml-unveiling-high-na-euv-720p.mp4` | 00:08 | Every-second-counts impact shot |
| 00:04–00:07 | `source-footage\industry\asml-high-na-euv-light-generation-720p.mp4` | 00:57 | EUV light generation |
| 00:07–00:10 | `source-footage\industry\asml-high-na-euv-wafer-stage-720p.mp4` | 00:58 | Wafer-stage movement |
| 00:10–00:13 | `source-footage\mistral-studio\mistral-studio-introducing-workflows-720p.mp4` | 02:25 | Controlled workflow proof point |
| 00:13–00:16 | `source-footage\mistral-studio\mistral-studio-custom-connectors-720p.mp4` | 00:43 | Source connectivity |
| 00:16–00:20 | `source-footage\industry\asml-computational-lithography-720p.mp4` | 00:17 | Lithography equipment detail |
| 00:20–00:24 | `source-footage\industry\asml-high-na-euv-reticle-stage-720p.mp4` | 02:03 | High-NA reticle stage |
| 00:24–00:28 | `source-footage\industry\asml-computational-lithography-720p.mp4` | 00:56 | Comparison and analysis |
| 00:28–00:31 | `source-footage\mistral-studio\mistral-studio-introducing-workflows-720p.mp4` | 02:44 | Additional-evidence state |
| 00:31–00:35 | `source-footage\industry\asml-mature-products-and-service-720p.mp4` | 00:53 | Operational engineer review |
| 00:35–00:38 | `source-footage\mistral-studio\mistral-studio-introducing-workflows-720p.mp4` | 02:46 | Approval state |
| 00:38–00:42 | `source-footage\industry\asml-unveiling-high-na-euv-720p.mp4` | 00:09 | Approved-action momentum |
| 00:42–00:45 | `source-footage\mistral-studio\mistral-studio-introducing-workflows-720p.mp4` | 02:32 | Traceability proof point |
| 00:45–00:49 | `source-footage\industry\asml-computational-lithography-720p.mp4` | 01:00 | Abstract computational outcome; replaces presenter footage |
| 00:49–00:55 | `source-footage\industry\asml-computational-lithography-720p.mp4` | 01:56 | Vertically centered pilot CTA |

## Creative system

- The first four seconds use four full-screen one-second shots, rapid push-ins, kinetic typography, and synchronized impact beats.
- Eighteen shots use hard editorial cuts for ad-like momentum, while the explanatory section settles into three- and four-second proof points.
- Manufacturing footage occupies 40 seconds; Mistral Studio appears in five three-second proof points totaling 15 seconds.
- Presenter and talking-head ranges are excluded without exception. Human presence is limited to operators performing cleanroom work, never addressing camera.
- The complete 55-second master is audited at 0.5-second intervals after every source-range change.
- Burned-in source subtitles are excluded through subtitle-free ranges and top-safe product crops.
- Overlays stay short and at the top of frame, leaving the manufacturing and product imagery unobstructed.
- Mistral navy, orange rails, technical grids, pixel markers, amber uncertainty, and green approval create one consistent visual language.
- The CTA is outcome-led and vertically centered. Its main message is account-neutral, so the cut can be reused by changing only the small ASML lockup.

## Voice and sound design

The narration uses the expressive `en-US-AvaNeural` voice. Eleven individually directed cues use their own rate, pitch, volume, punctuation, pause treatment, and mix gain. The opening sentence is split into three forceful beats—“Anomaly detected!”, “Evidence scattered.”, and “Every second counts!”—starting at 0.05 seconds and synchronized with the kinetic montage. The remaining cues create distinct explanatory, cautionary, and outcome beats instead of one repeated cadence. The final CTA ends at 54.0 seconds.

A restrained industrial texture and low rhythmic pulse support the faster edit. Four low-frequency impacts synchronize with the opening montage, while short tonal cues mark additional evidence and approved action. Light compression preserves vocal expression. The first second measures −16.27 dB RMS with a −1.54 dB peak; the complete encode measures −16.02 LUFS with a −1.52 dBTP peak.

## Rebuild and revision

```powershell
# Standard rebuild; reuses generated sentence audio when available
.\demo-videos\scripts\build-field-enablement-demo.ps1

# Recreate the full performance after changing voice, delivery, copy, or timing
.\demo-videos\scripts\build-field-enablement-demo.ps1 -RegenerateNarration

# Write a review variant to another location
.\demo-videos\scripts\build-field-enablement-demo.ps1 `
    -OutputPath 'C:\path\asml-mistral-field-enablement-review.mp4'
```

Generated video and sentence-audio caches are not committed. The build definition, timing, narration, overlays, fonts, and documentation are version controlled.
