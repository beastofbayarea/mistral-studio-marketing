# ASML × Mistral Field Enablement Demo

## Delivery

- Runtime: 75 seconds
- Format: 1920 × 1080, 30 fps, H.264 High Profile, AAC stereo
- Master: `outputs\asml-mistral-field-enablement-demo-75s-1080p.mp4`
- Build: `scripts\build-field-enablement-demo.ps1`
- Overlay source: `assets\overlays\field-enablement-demo.ass`
- Narration source: `assets\narration\field-enablement-narration.json`

This is a field-enablement conversation starter for an existing ASML relationship. It is a representative, synthetic-data scenario rather than a claim that the depicted workflow is currently deployed at ASML.

## Story structure

| Time | Beat | Visual | Narration |
|---:|---|---|---|
| 00:00–00:07 | Outcome first | Split card with ASML computational-lithography footage | When a system anomaly appears, the evidence needed to act is rarely in one place. |
| 00:07–00:15 | Start investigation | EUV light-generation detail, followed by a four-second framed Studio workflow | This representative Mistral workflow brings the investigation into one controlled process. |
| 00:15–00:23 | Retrieve evidence | Wafer-stage movement, followed by a four-second framed connector interface | It retrieves the relevant diagnostics, service history, engineering documentation, and previous cases, while preserving a link to every source. |
| 00:23–00:35 | Build evidence set | Wafer handling, chip applications, and High-NA reticle-stage footage | — |
| 00:35–00:43 | Compare and explain | Computational-lithography model visualization | It compares related incidents, identifies supporting and conflicting evidence, and builds a concise diagnostic brief. |
| 00:43–00:50 | Handle uncertainty | Four-second framed workflow state, followed by EUV plasma footage | When confidence is limited, it flags the uncertainty instead of guessing. |
| 00:50–00:56 | Engineer review | Cleanroom maintenance activity with no presenter shot | An engineer reviews the evidence, challenges the recommendation, and approves the next action. |
| 00:56–01:02 | Approve action | Four-second framed Studio approval state, followed by High-NA equipment | — |
| 01:02–01:09 | Preserve traceability | Three-second framed workflow run between High-NA stage shots | Every step, decision, retry, and approval remains visible and traceable in Mistral Studio. |
| 01:09–01:15 | Define the pilot | Vertically centered split end card | Let's map one high-value ASML diagnostic workflow and define the pilot. |

## Source edit map

| Edit time | Source file | Source in | Purpose |
|---:|---|---:|---|
| 00:00–00:07 | `source-footage\industry\asml-computational-lithography-720p.mp4` | 01:56 | Opening manufacturing context |
| 00:07–00:11 | `source-footage\industry\asml-high-na-euv-light-generation-720p.mp4` | 00:56 | EUV light generation |
| 00:11–00:15 | `source-footage\mistral-studio\mistral-studio-introducing-workflows-720p.mp4` | 02:25 | Workflow execution proof point |
| 00:15–00:19 | `source-footage\industry\asml-high-na-euv-wafer-stage-720p.mp4` | 00:57 | Wafer-stage movement |
| 00:19–00:23 | `source-footage\mistral-studio\mistral-studio-custom-connectors-720p.mp4` | 00:43 | Evidence-source connectivity |
| 00:23–00:29 | `source-footage\industry\asml-mature-products-and-service-720p.mp4` | 01:58 | Wafer handling and chip applications |
| 00:29–00:35 | `source-footage\industry\asml-high-na-euv-reticle-stage-720p.mp4` | 02:03 | High-NA reticle stage |
| 00:35–00:43 | `source-footage\industry\asml-computational-lithography-720p.mp4` | 00:56 | Comparison and analysis |
| 00:43–00:47 | `source-footage\mistral-studio\mistral-studio-introducing-workflows-720p.mp4` | 02:44 | Uncertainty state |
| 00:47–00:50 | `source-footage\industry\asml-high-na-euv-light-generation-720p.mp4` | 01:44 | EUV plasma detail |
| 00:50–00:56 | `source-footage\industry\asml-mature-products-and-service-720p.mp4` | 04:19 | Cleanroom maintenance and engineer review |
| 00:56–01:00 | `source-footage\mistral-studio\mistral-studio-introducing-workflows-720p.mp4` | 02:46 | Approval state |
| 01:00–01:04 | `source-footage\industry\asml-unveiling-high-na-euv-720p.mp4` | 00:45 | High-NA equipment |
| 01:04–01:07 | `source-footage\mistral-studio\mistral-studio-introducing-workflows-720p.mp4` | 02:32 | Traceable execution proof point |
| 01:07–01:09 | `source-footage\industry\asml-unveiling-high-na-euv-720p.mp4` | 01:00 | Sub-nanometer stage movement |
| 01:09–01:15 | `source-footage\industry\asml-computational-lithography-720p.mp4` | 01:56 | End-card manufacturing context |

## Visual system

- Dark navy (`#151524`) anchors the opening and CTA.
- Mistral orange (`#FF7000`) appears as a thin rail, status accent, and pixel marker.
- Pale-blue technical grids organize the manufacturing imagery without obscuring it.
- Silkscreen is reserved for short system labels; Segoe UI carries the narrative and CTA.
- Product footage receives only a small top-left step label, preserving the interface as the proof.
- Product footage is limited to five framed proof points totaling 19 seconds; manufacturing footage occupies the remaining 56 seconds.
- Presenter and talking-head ranges are excluded. Human presence is limited to operational cleanroom activity.
- Uncertainty is amber, approval is green, and neutral progress framing is pale blue.
- The end card places the full content group at the vertical center of the navy panel.

## Sound design

The narration uses `en-US-AndrewMultilingualNeural` at a slightly slower rate and lower pitch. Every sentence is generated separately so pauses and emphasis follow the edit instead of a single synthetic cadence. The mix applies speech-focused compression, a restrained original industrial bed, and brief tonal cues for uncertainty and approval. A measured two-pass mastering stage targets −16 LUFS, a −1.5 dBTP ceiling, and a controlled presentation-friendly loudness range before the final AAC encode.

## Rebuild and revision

```powershell
# Standard rebuild; reuses generated sentence audio when available
.\demo-videos\scripts\build-field-enablement-demo.ps1

# Recreate all narration after changing voice, rate, pitch, text, or timings
.\demo-videos\scripts\build-field-enablement-demo.ps1 -RegenerateNarration

# Write a review variant to another location
.\demo-videos\scripts\build-field-enablement-demo.ps1 `
    -OutputPath 'C:\path\asml-mistral-field-enablement-review.mp4'
```

Generated video and sentence-audio caches are not committed. The build definition, timing, narration, overlays, fonts, and documentation are version controlled.
