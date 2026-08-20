---
title: "FSI Performance Measurement Framework"
description: "Metrics and measurement principles for financial services go-to-market execution."
author: "Shiv, Prospective PMM, Mistral Studio"
---

# FSI Performance Measurement Framework

---

## 1. Executive Measurement Philosophy

The measurement system should answer one question:

> **Which plays, field motions, accounts, deal mechanisms, partner routes and Product decisions are changing opportunity progression and repeatability?**

Do not set numeric pipeline, win-rate, conversion, adoption or cycle-time targets until internal baselines and target-setting logic are validated.

Every KPI must follow:

> **Definition -> Formula -> Required Data -> Source -> Cadence -> Decision**

**Executive rule:** fewer metrics, each tied to a decision. Asset consumption and activity counts are diagnostic signals, not business outcomes.

---

## 2. Core KPI Set

| KPI | Definition / formula | Primary decision | Status |
|---|---|---|---|
| **1. Pipeline by Priority Play / Field Motion** | sum of qualified opportunity value by play / motion using the approved commercial-value field | validate whether P0/P1 focus matches market response | baseline / target require RevOps validation |
| **2. Win Rate by Play / Field Motion** | `Closed Won / (Closed Won + Closed Lost)` for the defined qualified cohort | change positioning, qualification, competitive routing or Product priorities | use only with sufficient sample size |
| **3. Stage / Decision Velocity** | median elapsed time between meaningful opportunity decisions / stages | identify Security, evaluation, procurement, Product, sponsor or other blockers | stage definitions require validation |
| **4. Target-Account Progression** | count / share of priority accounts moving across defined engagement / opportunity milestones | prune low-yield accounts and concentrate resources | use Activate Now / Develop / Monitor states |
| **5. Deal-Accelerator Progression** | `Deals using mechanism X that progress / Deals using mechanism X` plus qualitative blocker review | retain, improve, combine or retire mechanisms | downloads / views alone do not count |
| **6. Evaluation / POV Progression** | `Evaluations reaching agreed next decision / Evaluations started` | improve scoping, qualification, Product readiness or evaluation design | a technical success without a decision is a process signal |
| **7. Partner-Sourced / Influenced Pipeline** | opportunity value / wins segmented by partner and actual role | allocate Alliances / PMM effort to partners that change deals | avoid double counting; integration != influence |
| **8. Product Blocker / Win-Loss Impact** | count and value of opportunities where a normalized requirement is a documented blocker, loss contributor or win reason | prioritize Product and field workarounds | do not imply causal lost revenue without deal evidence |

### Recommended field-motion segmentation

- Financial Document Intelligence
- KYC / AML / Financial-Crime Support
- Due Diligence & Deal Analysis
- Research / Credit / Investment Intelligence
- Developer & IT Expansion
- Employee AI Expansion

Do not assume ARR is the correct commercial metric until RevOps confirms the revenue model.

---

## 3. KPI Specifications

### KPI 1 — Pipeline by Play / Motion

**Required data:** opportunity value, stage, primary play, field motion, creation date  
**Source:** CRM  
**Cadence:** monthly / quarterly  
**Decision:** scale, rework or deprioritize a motion

### KPI 2 — Win Rate

**Required data:** close disposition, play, field motion, competitor / alternative, loss reason  
**Source:** CRM + win/loss  
**Cadence:** quarterly  
**Decision:** update positioning, qualification, competitive routing or Product priorities

Avoid publishing rates from tiny samples.

### KPI 3 — Stage / Decision Velocity

**Required data:** stage history / milestone dates, blocker  
**Source:** CRM field history  
**Cadence:** monthly / quarterly  
**Decision:** identify where opportunities repeatedly stall

Do not impose a universal POC duration or assumed Sales stage structure.

### KPI 4 — Target-Account Progression

**Required data:** account tier, activation state, owner, engagement / opportunity status  
**Source:** CRM / account-planning system  
**Cadence:** monthly  
**Decision:** concentrate or withdraw account-level GTM effort

### KPI 5 — Deal-Accelerator Progression

Mechanisms:

- Workload Prioritization Worksheet
- Controlled Deployment & Security Blueprint
- Workload Evaluation Kit
- POV Decision Blueprint
- Deployment Economics Model

**Required data:** blocker, mechanism used, stage, next-decision date, outcome  
**Source:** CRM + sales / enablement activity  
**Cadence:** monthly  
**Decision:** retain, improve, combine or retire

### KPI 6 — Evaluation / POV Progression

**Required data:** evaluation start, workload, golden set, success criteria, decision date, result, next stage  
**Source:** CRM + FDE / project records  
**Cadence:** monthly / quarterly  
**Decision:** improve qualification, scoping, Product readiness or evaluation design

### KPI 7 — Partner Contribution

**Required data:** partner, maturity, role, source / influence attribution, opportunity value, outcome  
**Source:** CRM + partner system  
**Cadence:** quarterly  
**Decision:** invest in partners that create access, implementation capacity, procurement advantage or progression

### KPI 8 — Product Blocker Impact

**Required data:** requirement, field motion, stage, outcome, opportunity value, evidence, workaround, Product disposition  
**Source:** CRM + win/loss + Product / VoC records  
**Cadence:** quarterly  
**Decision:** separate repeated Product gaps from one-off integration issues

---

## 4. Diagnostic Signals

Keep these below the executive KPI layer.

### A. Recurring objections

Capture category, motion, account / segment, stage, competitor / alternative, response used, resolution and final outcome.

**Decision:** determine whether the issue is messaging, proof, Product, qualification, competitive, procurement or organizational.

### B. Lighthouse value and referenceability

Track confirmed workload, available evidence, measurable adoption / business evidence, referenceability, expansion hypothesis and next proof action.

**Decision:** package, expand or hold back a customer proof point.

### C. Field adoption

Track whether AEs / FDEs actually use the playbook, evaluation framework and deal mechanisms in relevant opportunities.

**Decision:** fix awareness, usability, fit or redundancy. Do not force adoption for its own sake.

---

## 5. Recommended CRM / RevOps Instrumentation

These are recommended fields, not claims about the current CRM.

| Field | Purpose | Example values |
|---|---|---|
| **Primary FSI Play** | identify umbrella strategy | Controlled Regulated Workflow; Financial Intelligence; Developer Expansion |
| **Primary Field Motion** | identify concrete workload | Financial Document Intelligence; KYC/AML; Due Diligence; Research/Credit; Developer Expansion |
| **FSI Sub-Vertical** | segment performance | Banking; Capital Markets; Private Markets; Wealth; Insurance; Market Infrastructure; Payments |
| **Opportunity Blocker** | normalize why a deal is stuck | Security; Governance; Accuracy; Product Gap; Procurement; Sponsor; Integration; Business Case |
| **Deal Accelerator Used** | connect mechanism to blocker | Prioritization; Security Blueprint; Evaluation Kit; POV Blueprint; Economics Model |
| **Product Requirement** | link opportunity evidence to REQ-01..11 | one or more defined requirements |
| **Competitor / Alternative** | separate direct competitors from status quo | Microsoft; OpenAI; Anthropic; AWS; Google; Internal Platform; Vertical ISV; No Decision |
| **Partner / Role** | separate source, influence, implementation and procurement | partner + role |
| **Evaluation Decision** | track POV outcome | proceed; re-scope; stop; Product blocked; no business case |
| **Primary Objection / Loss Reason** | normalize field friction | Product; Security; Price; Procurement; Sponsor; Competitor; No Decision |

All field names, API names and workflows require RevOps validation.

---

## 6. Dashboard Design

### Weekly — Action dashboard

Show only signals requiring action now:

- active evaluations / POVs;
- unresolved blockers;
- target-account movement;
- new proof / Product gaps;
- owner + next decision.

### Monthly — Operating dashboard

Show:

- pipeline by play / motion;
- stage / decision velocity;
- target-account progression;
- evaluation progression;
- deal-accelerator progression;
- recurring objections;
- Product blockers;
- partner contribution.

**Purpose:** reallocate field focus and remove repeated blockers.

### Quarterly — Executive dashboard

Show:

- pipeline and wins by play / motion;
- top-account progression;
- competitive patterns;
- Product blocker impact;
- partner contribution;
- lighthouse expansion / referenceability;
- decisions to scale, change or stop.

### Quarterly — Product VoC view

Show requirement frequency, affected accounts / motions, documented consequence, workaround and Product disposition.

**Purpose:** distinguish real Product gaps from isolated requests.

---

## 7. Win / Loss Framework

Use win/loss analysis when sample size and deal significance justify it.

Capture:

- buyer problem and priority play;
- field motion;
- winning / losing alternative;
- deployment choice;
- decisive Product capability / gap;
- Security / governance issue;
- evaluation result;
- partner involvement;
- commercial / procurement issue;
- coexistence vs displacement expectation;
- evidence quality of the stated reason.

Output **repeatable themes**, not battlecard changes after every anecdote.

---

## 8. Decision Rules

### Scale when

- multiple distinct accounts progress around the same buyer problem;
- proof survives customer and competitive falsification;
- field can repeat the motion without bespoke PMM intervention;
- Product / delivery requirements are manageable.

### Rework when

- pipeline exists but repeatedly stalls at the same decision point;
- competitive losses cluster around one capability;
- evaluations succeed technically but do not reach commercial / production decisions;
- field repeatedly bypasses the intended asset or motion.

### Deprioritize when

- opportunity volume remains low after sufficient coverage;
- customers consistently buy a horizontal incumbent instead;
- Product requirements exceed likely strategic value;
- the motion depends on unsupported claims or bespoke work.

### Retire an asset when

- it is not attached to a real blocker;
- consumption does not correlate with progression;
- it is stale or duplicative;
- Sales / FDE consistently replaces it with a better mechanism.

---

## 9. Baseline and Target-Setting Protocol

Before setting a numeric target:

1. define the cohort and metric precisely;
2. confirm the commercial-value field;
3. pull historical baseline data;
4. clean missing / inconsistent fields;
5. determine sample size and variance;
6. set a target tied to a real operating decision;
7. document owner, review cadence and revision date.

Until then, do not invent pipeline, win-rate, adoption, conversion, cycle-time, partner or Product-impact targets.
