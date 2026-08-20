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
| 00:07–00:15 | Start investigation | Mistral Studio workflow execution | This representative Mistral workflow brings the investigation into one controlled process. |
| 00:15–00:23 | Retrieve evidence | Mistral Studio connector interface | It retrieves the relevant diagnostics, service history, engineering documentation, and previous cases, while preserving a link to every source. |
| 00:23–00:35 | Build evidence set | Workflow steps progressing through retry and completion states | — |
| 00:35–00:43 | Compare and explain | Computational-lithography model visualization | It compares related incidents, identifies supporting and conflicting evidence, and builds a concise diagnostic brief. |
| 00:43–00:50 | Handle uncertainty | Workflow state changes to additional evidence required | When confidence is limited, it flags the uncertainty instead of guessing. |
| 00:50–00:56 | Engineer review | ASML engineer and equipment footage | An engineer reviews the evidence, challenges the recommendation, and approves the next action. |
| 00:56–01:02 | Approve action | Mistral Studio human-approval state | — |
| 01:02–01:09 | Preserve traceability | Full workflow run with decisions and retries visible | Every step, decision, retry, and approval remains visible and traceable in Mistral Studio. |
| 01:09–01:15 | Define the pilot | Vertically centered split end card | Let's map one high-value ASML diagnostic workflow and define the pilot. |

## Source edit map

| Edit time | Source file | Source in | Purpose |
|---:|---|---:|---|
| 00:00–00:07 | `source-footage\industry\asml-computational-lithography-720p.mp4` | 01:56 | Opening manufacturing context |
| 00:07–00:15 | `source-footage\mistral-studio\mistral-studio-introducing-workflows-720p.mp4` | 02:25 | Workflow execution |
| 00:15–00:23 | `source-footage\mistral-studio\mistral-studio-custom-connectors-720p.mp4` | 00:43 | Evidence-source connectivity |
| 00:23–00:35 | `source-footage\mistral-studio\mistral-studio-introducing-workflows-720p.mp4` | 02:32 | Evidence workflow progression |
| 00:35–00:43 | `source-footage\industry\asml-computational-lithography-720p.mp4` | 00:56 | Comparison and analysis |
| 00:43–00:50 | `source-footage\mistral-studio\mistral-studio-introducing-workflows-720p.mp4` | 02:44 | Uncertainty state |
| 00:50–00:56 | `source-footage\industry\asml-mature-products-and-service-720p.mp4` | 05:28 | Human expert review |
| 00:56–01:02 | `source-footage\mistral-studio\mistral-studio-introducing-workflows-720p.mp4` | 02:46 | Approval state |
| 01:02–01:09 | `source-footage\mistral-studio\mistral-studio-introducing-workflows-720p.mp4` | 02:25 | Traceable execution |
| 01:09–01:15 | `source-footage\industry\asml-computational-lithography-720p.mp4` | 01:56 | End-card manufacturing context |

## Visual system

- Dark navy (`#151524`) anchors the opening and CTA.
- Mistral orange (`#FF7000`) appears as a thin rail, status accent, and pixel marker.
- Pale-blue technical grids organize the manufacturing imagery without obscuring it.
- Silkscreen is reserved for short system labels; Segoe UI carries the narrative and CTA.
- Product footage receives only a small top-left step label, preserving the interface as the proof.
- Uncertainty is amber, approval is green, and neutral progress framing is pale blue.
- The end card places the full content group at the vertical center of the navy panel.

## Sound design

The narration uses `en-US-AndrewMultilingualNeural` at a slightly slower rate and lower pitch. Every sentence is generated separately so pauses and emphasis follow the edit instead of a single synthetic cadence. A low original industrial bed is ducked beneath the narration, with brief tonal cues for uncertainty and approval.

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
