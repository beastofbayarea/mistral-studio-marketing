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
| 00:00–00:07 | Outcome first | Split card with ASML computational-lithography footage | An anomaly appears. Now the investigation has to move—fast, with the right evidence in reach! |
| 00:07–00:15 | Start investigation | EUV light-generation detail, followed by a four-second framed Studio workflow | That signal can begin anywhere: optics, stages, sensors, equipment, or service logs. Mistral Studio brings it together in one controlled investigation—from the very first step. |
| 00:15–00:23 | Retrieve evidence | Wafer-stage movement, followed by a four-second framed connector interface | Diagnostics, maintenance history, engineering documentation, and prior cases connect in seconds. |
| 00:23–00:35 | Build evidence set | Computational-lithography equipment and High-NA reticle-stage footage | Every source stays linked, so engineers can verify every claim immediately. Then the workflow turns that evidence into a concise, actionable diagnostic brief. |
| 00:35–00:43 | Compare and explain | Computational-lithography model visualization | It spots supporting signals, surfaces conflicts, and shows exactly what is still missing. |
| 00:43–00:50 | Handle uncertainty | Four-second framed workflow state, followed by EUV light detail | Not enough confidence? It pauses and asks for more evidence—no guessing. |
| 00:50–00:56 | Engineer review | Cleanroom maintenance activity with no presenter shot | Now the engineer takes control: review the reasoning, challenge it, and add operational judgment. |
| 00:56–01:02 | Approve action | Four-second framed Studio approval state, followed by High-NA equipment | Only the approved action moves forward, with uncertainty visible at every step. |
| 01:02–01:09 | Preserve traceability | Three-second framed workflow run between High-NA stage shots | Sources, retries, decisions, approvals—everything stays visible and traceable in Studio. |
| 01:09–01:15 | Define the pilot | Vertically centered split end card | And here’s the opportunity: map one high-value ASML workflow, align the evidence and approvals, and launch a measurable pilot—with clear success measures from day one! |

## Source edit map

| Edit time | Source file | Source in | Purpose |
|---:|---|---:|---|
| 00:00–00:07 | `source-footage\industry\asml-computational-lithography-720p.mp4` | 01:56 | Opening manufacturing context |
| 00:07–00:11 | `source-footage\industry\asml-high-na-euv-light-generation-720p.mp4` | 00:56 | EUV light generation |
| 00:11–00:15 | `source-footage\mistral-studio\mistral-studio-introducing-workflows-720p.mp4` | 02:25 | Workflow execution proof point |
| 00:15–00:19 | `source-footage\industry\asml-high-na-euv-wafer-stage-720p.mp4` | 00:57 | Wafer-stage movement |
| 00:19–00:23 | `source-footage\mistral-studio\mistral-studio-custom-connectors-720p.mp4` | 00:43 | Evidence-source connectivity |
| 00:23–00:29 | `source-footage\industry\asml-computational-lithography-720p.mp4` | 00:17 | Lithography equipment detail |
| 00:29–00:35 | `source-footage\industry\asml-high-na-euv-reticle-stage-720p.mp4` | 02:03 | High-NA reticle stage |
| 00:35–00:43 | `source-footage\industry\asml-computational-lithography-720p.mp4` | 00:56 | Comparison and analysis |
| 00:43–00:47 | `source-footage\mistral-studio\mistral-studio-introducing-workflows-720p.mp4` | 02:44 | Uncertainty state |
| 00:47–00:50 | `source-footage\industry\asml-high-na-euv-light-generation-720p.mp4` | 01:51 | EUV optics detail |
| 00:50–00:56 | `source-footage\industry\asml-mature-products-and-service-720p.mp4` | 00:53 | Cleanroom maintenance and engineer review |
| 00:56–01:00 | `source-footage\mistral-studio\mistral-studio-introducing-workflows-720p.mp4` | 02:46 | Approval state |
| 01:00–01:04 | `source-footage\industry\asml-unveiling-high-na-euv-720p.mp4` | 00:08 | High-NA equipment |
| 01:04–01:07 | `source-footage\mistral-studio\mistral-studio-introducing-workflows-720p.mp4` | 02:32 | Traceable execution proof point |
| 01:07–01:09 | `source-footage\industry\asml-high-na-euv-wafer-stage-720p.mp4` | 01:02 | Wafer-stage movement |
| 01:09–01:15 | `source-footage\industry\asml-computational-lithography-720p.mp4` | 01:56 | End-card manufacturing context |

## Visual system

- Dark navy (`#151524`) anchors the opening and CTA.
- Mistral orange (`#FF7000`) appears as a thin rail, status accent, and pixel marker.
- Pale-blue technical grids organize the manufacturing imagery without obscuring it.
- Silkscreen is reserved for short system labels; Segoe UI carries the narrative and CTA.
- Product footage receives only a small top-left step label, preserving the interface as the proof.
- Product footage is limited to five framed proof points totaling 19 seconds; manufacturing footage occupies the remaining 56 seconds.
- Presenter and talking-head ranges are excluded. Human presence is limited to operational cleanroom activity.
- Burned-in source subtitles are excluded through subtitle-free time ranges and top-safe crops. Only product-interface text and the edit's intentional overlays remain.
- Uncertainty is amber, approval is green, and neutral progress framing is pale blue.
- The end card places the full content group at the vertical center of the navy panel.

## Sound design

The narration uses the brighter `en-US-JennyNeural` voice at `+8%` rate, `+5Hz` pitch, and `+6%` volume. Twelve action-oriented sentences use short clauses, questions, and emphatic punctuation to create an enthusiastic field-demo performance. Measured cue durations leave only 0.02 seconds between the first eleven cues; the final CTA narration ends at 74.71 seconds. The mix uses light speech compression to preserve expression, a restrained original industrial bed, and brief tonal cues for uncertainty and approval. A measured two-pass mastering stage targets −16 LUFS and a −1.5 dBTP ceiling before the final AAC encode.

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
