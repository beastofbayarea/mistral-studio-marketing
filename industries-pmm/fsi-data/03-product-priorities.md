---
title: "FSI Voice of Customer and Product Priorities"
description: "Financial services use cases, product priorities, and roadmap implications."
author: "Shiv, Prospective PMM, Mistral Studio"
---

# FSI Voice of Customer (VoC) & Product Priorities

---

## 1. Executive Product Thesis

The FSI Product agenda should support two P0 plays:

1. **Controlled AI for Regulated Financial Workflows**
2. **Financial Intelligence & Document Automation**

with **Developer & IT AI** as a P1 expansion wedge.

Prioritize Product work through:

> **Evidence -> Buyer Need -> Priority Play -> Current Capability -> Actual Gap -> Commercial Consequence -> Delivery Strategy -> Recommendation**

**Decision rule:** do not turn a field request into a Product roadmap item until Product / FDE confirms whether the issue is a real capability gap, an integration pattern, configuration, or bespoke customer requirement.

All pipeline impact, roadmap dates, engineering effort and delivery commitments require internal validation.

---

## 2. Six Recurring VoC Themes

| Theme | What customers / buyers need | Product implication |
|---|---|---|
| **1. Deployment and data control** | self-hosted, private, managed-cloud or data-platform deployment depending on workload | make deployment choice repeatable; do not assume “on-prem everywhere” |
| **2. Auditability and human governance** | traceability, evidence, policy controls and accountable human review | make workflow lineage and evidence export first-class |
| **3. Identity and permissions** | enterprise identity context, least privilege, source permissions | strengthen permission-aware retrieval and policy integration |
| **4. Financial document reliability** | tables, citations, provenance, figure consistency, reviewability | optimize end-to-end financial document workflows, not generic multimodal benchmarks |
| **5. Model adaptation and evaluation** | private evaluation and, where useful, adaptation on proprietary data | provide reusable evaluation and governed customization patterns |
| **6. Operational integration** | logging, SIEM, routing, human review, workflow and deployment lifecycle | reduce the integration burden required to reach production |

**Evidence anchors:** HSBC self-hosted; La Banque Postale bank infrastructure; BNP internal enterprise infrastructure; Ardian secure multi-model environment and document workflows.

---

## 3. Product Requirement Portfolio

### P0 — Must be validated and solved for repeatable FSI execution

| Req | Requirement | Need / likely gap | Delivery strategy | Evidence / status |
|---|---|---|---|---|
| **REQ-01** | **Production-Grade Controlled Deployment Packaging** | reduce bespoke installation, restricted-network lifecycle, upgrade and validation work | Native Product + standardized FDE reference pattern | HSBC, La Banque Postale; exact lifecycle gaps require Product / FDE validation |
| **REQ-02** | **Enterprise Auditability, Lineage & Evidence Export** | trace model / version, context, tool calls, policy decisions, source evidence and human review | Native primitives + enterprise export integrations | cross-play requirement; current coverage requires Product validation |
| **REQ-03** | **Enterprise Identity, RBAC / ABAC & Permission-Aware Retrieval** | preserve source permissions and identity context through retrieval / workflow execution | Native identity / policy integration + connectors | enterprise need is strong; exact current capability / gap requires validation |
| **REQ-04** | **Policy Controls, PII Handling & Safety Guardrails** | institution-specific policy enforcement and auditable exception handling | Native policy primitives + customer / partner policy content | current safety capabilities exist; enterprise gap requires validation |
| **REQ-05** | **Financial Document / Table Intelligence** | structured extraction, tables / footnotes, source coordinates, evaluation and production integration | Native Product + reusable FDE evaluation templates | strongest evidence: Ardian, HSBC, BNP Paribas |

### P1 — Important expansion / differentiation

| Req | Requirement | Product direction |
|---|---|---|
| **REQ-08** | **Enterprise Fine-Tuning / Adaptation Workbench** | govern adaptation, versioning, evaluation, adapter management, approval and deployment |
| **REQ-10** | **Human-in-the-Loop Review & Escalation** | reusable review primitives plus integration with existing case / workflow systems |
| **REQ-11** | **Deterministic / Schema-Constrained Policy Outputs** | structured outputs, validation, evidence requirements and threshold-based routing; do not promise perfect determinism |

### P2 — Supporting platform capabilities

| Req | Requirement | Product direction |
|---|---|---|
| **REQ-06** | **FSI Evaluation & Golden-Set Tooling** | private datasets, reusable templates, regression tests, human evaluation and evidence capture |
| **REQ-07** | **Model Routing / Cost-Aware Orchestration** | integrate with customer gateways first; build native routing only if repeated field evidence shows an unmet need |
| **REQ-09** | **SIEM / SOC / Enterprise Telemetry Connectors** | standards-based export / connectors rather than replacing enterprise observability platforms |

---

## 4. Product Prioritization Logic by Field Motion

| Field motion | Critical dependencies | Supporting capabilities | Proof posture |
|---|---|---|---|
| **Financial Document Intelligence** | REQ-05 documents; REQ-03 permissions; REQ-02 evidence | REQ-06 evaluation; REQ-10 review; REQ-09 telemetry | strongest public proof: Ardian, HSBC, BNP |
| **KYC / AML / Financial-Crime Support** | REQ-03 permissions; REQ-04 policy; REQ-02 lineage; REQ-10 review | REQ-01 deployment; REQ-05 extraction | related public evidence exists; autonomous AML production proof is weaker |
| **Due Diligence & Deal Analysis** | REQ-05 documents; REQ-02 citations / lineage | REQ-06 evaluation; REQ-10 review; REQ-08 adaptation | strongest public proof: Ardian |
| **Developer & IT AI** | REQ-01 control where required | REQ-08 adaptation; REQ-09 telemetry | HSBC / La Banque Postale; COBOL outcomes unproven publicly |
| **Employee AI Expansion** | REQ-03 identity / permissions; REQ-02 auditability | REQ-04 policy; REQ-09 telemetry | common horizontal adoption pattern |

---

## 5. What Product Should Avoid

- Do not infer every bank requires air-gapped deployment.
- Do not claim DORA or the EU AI Act mandates a specific architecture.
- Do not market an identity / ACL capability as available until Product confirms it.
- Do not invent Product release names, quarters or implementation details.
- Do not build a replacement identity, SIEM or generic workflow platform when integration is sufficient.
- Do not turn one account's bespoke requirement into an FSI-wide roadmap priority without repeated evidence.
- Do not use headline model benchmarks as a substitute for customer-specific workload evaluation.

---

## 6. Product Execution Risks

| Risk | Business consequence | Response |
|---|---|---|
| **Controlled deployment remains bespoke** | FDE capacity limits repeatability | productize lifecycle, documentation and reference patterns |
| **Agentic workflows lack end-to-end lineage** | governance / audit objections increase | standardize traceability and evidence export across steps |
| **FSI evaluations show parity, not superiority** | model-quality-only story weakens | sell workload fit, control, deployment and customer-specific evaluation |
| **Guardrails remain too generic** | regulated workflows need institution-specific behavior | provide configurable policy primitives |
| **Internal bank AI platforms mature** | platform displacement becomes unrealistic | position Mistral as model / deployment / customization layer |
| **Human review becomes bespoke app work** | every account rebuilds the same pattern | provide reusable review primitives + integrations |
| **Field claims outrun capability** | credibility and legal risk | maintain strict capability vs gap vs roadmap discipline |

---

## 7. Product Constraint / Workaround Discipline

| Field issue | Current posture | Temporary approach | Product recommendation |
|---|---|---|---|
| Controlled deployment packaging | customer-controlled deployment supported in some forms; lifecycle gap uncertain | FDE reference architecture | repeatable enterprise deployment package |
| Permission-aware retrieval | enterprise need is clear; exact capability must be checked | customer / FDE integration | native permission propagation |
| Financial structured extraction | OCR / multimodal capability exists | prompt / schema / golden-set tuning | finance-oriented extraction workflow |
| Enterprise evidence export | logging / observability exists in some form | integrate customer logging stack | standardized export / lineage |
| HITL review | checkpoints possible; native review UX uncertain | integrate customer workflow / case tool | reusable review primitives |

Every row remains subject to Product / FDE validation before external use.

---

## 8. VoC Operating Loop

```text
Field blocker / customer request
        |
        v
Normalize evidence
(account, motion, stage, blocker, consequence)
        |
        v
PMM synthesis
        |
        v
Product + FDE review
        |
        v
Disposition
- already supported
- configuration / integration
- FDE pattern
- Product gap
- partner opportunity
- not prioritized
        |
        v
Field update + Product decision
```

For each issue capture:

- account / segment;
- priority play and field motion;
- business workflow;
- opportunity stage;
- technical / governance blocker;
- current workaround;
- competitive consequence;
- commercial consequence, if known;
- number of distinct opportunities affected;
- source / owner;
- Product disposition.

---

## 9. Highest-Value Internal Questions

1. Which REQ-01..11 capabilities already exist today?
2. Which are committed roadmap items versus recommendations only?
3. Which gaps are blocking active FSI opportunities repeatedly?
4. Which issues are integration / FDE patterns rather than Product gaps?
5. Is current observability / governance sufficient for the workflows being sold?
6. Can controlled / self-hosted deployment be repeated efficiently for a new Tier-1 customer?
7. What private FSI evaluation / golden-set framework should be standardized?
8. Which model names, OCR versions, pricing and deployment modes are approved for external use?
9. What is the default coexistence story for customers standardized on Azure, AWS, Google or an internal AI platform?

**Until answered, roadmap language remains recommendation, not fact.**
