---
title: "FSI Sources, Evidence Taxonomy, and Assumptions"
description: "Source registry, evidence controls, and assumptions for the FSI GTM operating system."
author: "Shiv, Prospective PMM, Mistral Studio"
---

# Sources, Evidence Taxonomy, and Assumptions Catalog

**Purpose:** Source registry and control layer for the FSI GTM operating system. Use this file to determine what can be stated as fact, what is inference or recommendation, and what still requires internal validation.

---

## 1. Evidence Taxonomy

| Label | Meaning |
|---|---|
| **[Confirmed Fact]** | A primary / authoritative source directly supports the specific claim |
| **[Strong Inference]** | A reasoned conclusion from confirmed evidence, but not directly stated by the source |
| **[Recommended Practice]** | A proposed Product, GTM or operating practice rather than a claim about current Mistral practice |
| **[Requires Internal Validation]** | Depends on CRM, Product roadmap, Sales process, FDE implementation, Legal, pricing, partnerships or other internal information |
| **[Requires Exact Source Validation]** | The claim lacks a sufficiently precise source tying the named customer, workload, model or deployment to Mistral |

### Attribution rules

1. Relationship != investment != partnership != deployment != production.
2. Indirect ISV usage != direct Mistral customer.
3. Technology availability != customer usage.
4. Customer-wide AI metric != Mistral-specific metric.
5. On-premises != air-gapped unless explicitly stated.
6. Regulation != purchase motivation.
7. Regulatory requirement != self-hosting mandate.
8. Product recommendation != existing capability.
9. Roadmap proposal != committed release.
10. Partner relationship / integration != confirmed FSI co-sell.
11. Vendor benchmark != customer production result.
12. Compatibility / MCP support != production deployment.
13. A public customer logo != automatic public referenceability.

---

## 2. Primary FSI Customer Sources

### SRC-C01 — BNP Paribas

**Source:** BNP Paribas, May 26 2026 partnership extension  
**URL:** https://group.bnpparibas/en/press-release/bnp-paribas-and-mistral-ai-extend-their-partnership-to-support-the-next-phase-of-generative-ai-deployment-within-the-group

**Supports:**

- three-year partnership extension;
- earlier Global Markets relationship / experimentation;
- Mistral integration into internal LLM infrastructure;
- co-development, knowledge transfer and progressive deployment;
- internal document search and data extraction;
- complex financial analysis / cross-source reasoning;
- KYC / banking workflow support where named;
- Hello bank! / HelloïZ assistant incorporating Mistral and serving more than one million customers in the cited period;
- employee-assistant expansion in 2026;
- multi-model enterprise context.

**Do not infer:** exact production model IDs, a bank-wide Mistral user count, exclusivity, or DORA / sovereignty as the causal purchase reason.

---

### SRC-C02 — HSBC

**Source:** HSBC, Dec 1 2025 Mistral partnership release  
**URL:** https://www.hsbc.com/-/files/hsbc/media/media-release/2025/251201-hsbc-and-mistral-ai-join-forces-to-accelerate-ai-adoption-across-global-bank.pdf

**Supports:**

- multi-year partnership;
- self-hosted Mistral models on HSBC technology systems;
- employee / productivity use cases;
- multilingual communication / reasoning;
- document-heavy lending / financing workflows;
- procurement / business workflow themes;
- developer / engineering use cases;
- future expansion areas when explicitly described as future.

**Do not infer:** HSBC's total AI-use-case count is a Mistral-use-case count, every discussed workload is already in production, or one architecture applies globally.

---

### SRC-C03 — La Banque Postale

**Source:** La Banque Postale, May 6 2026  
**URL:** https://www.labanquepostale.com/content/dam/lbp/documents/communiques-de-presse/en/2026/PR-LBP-Mistral-AI.pdf

**Supports:**

- three-year partnership after a testing phase;
- Mistral models on bank servers / data-center infrastructure;
- initial 5,000-employee rollout in 2026;
- Le Chat / Mistral Code / IT use;
- customer-relations, AML and fraud-related business workflows;
- close / dedicated collaboration with Mistral teams;
- sovereignty / strategic-control themes.

**Use:** “on-premises” or “bank infrastructure.”  
**Do not automatically say:** air-gapped, disconnected, 100% zero-egress or bank-wide model exclusivity.

---

### SRC-C04 — Ardian

**Source:** Ardian GAIA case study  
**URL:** https://www.ardian.com/news-insights/article/ardians-ai-integration-leveraging-gaia-powerful-tool-success

**Supports:**

- GAIA production platform;
- Mistral + Azure OpenAI multi-model architecture;
- private-market / due-diligence document workflows;
- summarization, analysis, comparison and information collection;
- substantial employee adoption;
- 280,000 questions answered in the cited period;
- public figures of roughly 450–500 weekly active users depending on source date;
- strong daily-usage growth in the cited period.

**Rule:** use the exact source date when quoting adoption figures.

---

### SRC-C05 — ABN AMRO

**Source:** ABN AMRO, Aug 2026 strategic partnership  
**URL:** https://www.abnamro.com/en/news/abn-amro-and-mistral-enter-strategic-partnership-to-strengthen-european-ai-innovation

**Supports:** strategic partnership, co-development, European innovation / autonomy / resilience / security / transparency / privacy themes.

**Production status:** early / unclear unless later evidence explicitly confirms production workloads.

---

### SRC-C06 — Groupe Mutuel

**Source:** Groupe Mutuel partnership announcement, July 2026.

**Supports:** individual pension / protection subscription, benefits-management workflows, customer-relations / processing benefits and Swiss / European data-protection context.

**Publication requirement:** capture the exact Groupe Mutuel announcement URL before external publication.

---

## 3. Multi-Model / Indirect Sources

### SRC-C07 — AXA

**Source basis:** current Mistral customer material plus AXA corporate / technology material describing Secure GPT and AXA's multi-provider strategy.  
**Root:** https://mistral.ai/customers

**Use:** evidence that Mistral can operate inside a multi-model insurance environment.

**Do not infer:** the full Secure GPT population uses Mistral, Mistral was the original foundation of Secure GPT, or all AXA workloads use Mistral.

### SRC-C08 — Groupe BPCE

**Source basis:** Groupe BPCE public material describing the MAiA environment using external models including Mistral alongside other major providers.  
**Roots:** https://www.groupebpce.com / https://www.groupebpce.fr

**Use:** multi-model enterprise architecture proof.

**Do not infer:** exclusivity, direct strategic partnership, Mistral-specific usage volumes or business outcomes.

### SRC-C09 — Standard Chartered via Squirro

**Source basis:** Squirro / solution-provider material linking the Standard Chartered solution to Mistral / Mixtral support or embedding.  
**Root:** https://squirro.com

**Use:** indirect / ISV-embedded model-layer example only.

### SRC-C10 — Pennylane MCP Integration

**URL:** https://www.pennylane.com/fr/mcp

**Use:** interoperability / ecosystem evidence.

**Do not infer:** Pennylane's whole product, customer base or production estate runs on Mistral.

---

## 4. Claims Requiring Exact-Source Validation

Do not use these as confirmed customer proof until precise evidence is captured:

- State Street + Mistral production through Snowflake Cortex;
- Fifth Third + Mistral in contact-center workloads;
- Qonto Moshi model attribution;
- Alan direct Mistral production workload;
- Pictet / LGT / other Unique customer-level Mistral model selection;
- any customer-wide metric not explicitly tied to Mistral.

These may remain research leads or ecosystem examples.

---

## 5. Public Evidence Gaps

Public sources do **not** reliably establish:

1. contract value / ARR / ACV for named FSI customers;
2. exact model version deployed at each account;
3. production-vs-pilot split for every announced use case;
4. customer-specific ROI beyond explicitly published metrics;
5. all workloads inside insurance partnerships;
6. broad payments / fintech adoption;
7. regulator / central-bank customer status;
8. Mistral-specific competitive win / loss rates;
9. partner-generated pipeline or co-sell conversion;
10. exact internal architecture when the customer has not published it;
11. customer willingness to participate in public references or quantified case studies.

These belong in internal validation, not external claims.

---

## 6. Mistral Product / Technical Sources

Because models, APIs, pricing and deployment support change, revalidate current documentation before external publication.

| Source | Root | Use |
|---|---|---|
| **SRC-P01 — Product / Model Docs** | https://docs.mistral.ai | current models, deployment, OCR, embeddings, customization, workflows, safety and API behavior |
| **SRC-P02 — News / Release Notes** | https://mistral.ai/news/ | dated launches and Product announcements |
| **SRC-P03 — Finance Industry Page** | https://mistral.ai/industry/finance/ | official finance positioning and solution themes |
| **SRC-P04 — Customers / Partners** | https://mistral.ai/customers and https://mistral.ai/partners/ | official customer / partner references; still classify relationship vs production |

### Revalidate before external use

- exact OCR model name, throughput and pricing;
- exact context window / model IDs;
- current Forge capabilities;
- Studio / workflow / human-review capabilities;
- policy / moderation Product names;
- self-hosted licensing / offline lifecycle;
- availability on Snowflake / AWS / Azure / GCP;
- supported hardware / orchestration;
- enterprise identity / permission features.

---

## 7. Competitor / Platform Source Rules

### Microsoft

**Docs:** https://learn.microsoft.com/

Validate the specific Azure OpenAI / Foundry / local / disconnected model and deployment path. **Do not say Microsoft broadly cannot support local or disconnected AI.**

### AWS

**Bedrock docs:** https://docs.aws.amazon.com/bedrock/

Also validate SageMaker, PrivateLink, Outposts / local infrastructure and Marketplace. **Do not say AWS broadly cannot support private / local open-model architectures.**

### Google Cloud

**Vertex AI:** https://cloud.google.com/vertex-ai

Validate Model Garden, Private Service Connect and Distributed Cloud / disconnected options where relevant.

### OpenAI

Use current official enterprise / API data-control, residency and deployment documentation. Do not base differentiation on outdated privacy or residency claims.

### Anthropic

**Docs:** https://docs.anthropic.com

Validate current customization, enterprise controls, regional deployment and partner distribution before battlecard publication.

### Snowflake

**Docs:** https://docs.snowflake.com

Validate current Cortex functions, Mistral model availability / retirement, data movement, pricing and actual co-sell status.

### Internal bank AI platforms

Treat sophisticated internal platforms as a separate competitive / coexistence category. The strategic question is often whether Mistral becomes a model / deployment layer **inside** the platform.

### Vertical ISVs

When a specialized KYC, sanctions, claims, research or workflow application owns the workflow, evaluate a partnership / model-layer route before assuming direct displacement.

---

## 8. Regulatory Sources and Interpretation

### EU DORA

**Authoritative source:** EUR-Lex Regulation (EU) 2022/2554.

**Use:** operational resilience, third-party ICT risk, contractual, audit, oversight, concentration and exit considerations.  
**Do not claim:** DORA forces banks to self-host or eliminate cloud providers.

### EU AI Act

**Authoritative source:** Regulation (EU) 2024/1689 / EUR-Lex.

**Use:** obligations depend on actor role and system classification; recordkeeping and human oversight are relevant where applicable.  
**Do not claim:** one article applies identically to every GenAI, KYC or document workflow.

### UK PRA / FCA

Use official Bank of England / PRA / FCA sources for model risk, operational resilience, accountability and consumer-outcome obligations where applicable.

### FINMA

Use official FINMA and Swiss legal sources for operational risk, outsourcing / confidentiality and model-governance expectations.

### MAS / HKMA

Use official regulator guidance. Do not call guidance mandatory unless the source creates a binding obligation.

### US SEC / FINRA / Federal banking regulators

Use the exact rule / guidance relevant to the institution and workflow. Do not apply broker-dealer or bank model-risk requirements indiscriminately across FSI.

---

## 9. Claims Excluded Without New Evidence

Do not use the following as facts or default field claims:

- “Mistral is the #1 / only provider for FSI.”
- “Banks are switching from OpenAI / Microsoft to Mistral.”
- “European vendor status is an automatic win.”
- “DORA requires self-hosting / zero egress.”
- “EU AI Act certified / compliant by default.”
- “On-premises is always the winning architecture.”
- “Open weights are inherently explainable / auditable.”
- “Inspecting model weights explains a model decision.”
- “Mistral universally outperforms GPT-4o / Claude / Gemini on financial tasks.”
- “Mistral is the only frontier model that can run locally / privately.”
- a BNP Paribas Mistral user count unless the source ties the number to Mistral;
- all HSBC AI use cases as Mistral workloads;
- AXA's full Secure GPT population as Mistral users;
- `$35M+` pipeline without CRM evidence;
- `65%+` win rate without a baseline;
- `180 days -> <110 days` sales-cycle improvement without a baseline;
- `99%+` extraction / F1 / straight-through-processing claims without workload evidence;
- `35%` developer productivity / COBOL improvement without evidence;
- `40–60%` TCO savings as a universal promise;
- fixed ACV minimums / expansion multiples;
- universal POC durations;
- invented Product release names / quarters;
- PMM-implied sprint / GA commitments;
- generic Employee AI as the P0 FSI industry landing play;
- debt financing as software deployment;
- adjacent non-FSI evidence as FSI customer proof.

---

## 10. Internal Validation Catalog

### Customer / Sales / RevOps

Validate:

- actual production customer roster and account ownership;
- active FSI pipeline and opportunity stages;
- customer referenceability / case-study approval;
- Sales methodology / qualification process;
- historical win rate and stage velocity;
- commercial-value convention: ARR / ACV / TCV / consumption;
- CRM fields and attribution logic;
- target-account status / next actions;
- partner attribution / registration process.

### Product

Validate:

- REQ-01..11 current capability status;
- roadmap / committed dates;
- Studio / platform governance and observability sufficiency;
- identity / permission controls;
- workflow / human-review features;
- audit / evidence-export capability;
- current OCR / safety / moderation / model names;
- deployment / licensing / upgrade packaging;
- pricing / packaging for controlled deployment.

### FDE / Engineering

Validate:

- repeatability of a new controlled / self-hosted deployment;
- FDE capacity for concurrent evaluations / deployments;
- reference architectures;
- offline / restricted-network requirements;
- supported hardware / orchestration;
- financial-document evaluation metrics;
- demo / evaluation ownership boundaries.

### Partnerships

Validate:

- which relationships are active;
- which have technical integration;
- which have a joint solution;
- which have FSI customer proof;
- which have active FSI co-sell / pipeline;
- marketplace / committed-spend mechanics;
- field incentives and competitive conflict.

### Legal / Compliance

Validate external use of:

- compliant / certified;
- sovereign;
- zero-egress;
- air-gapped;
- data residency;
- regulatory mappings;
- record retention;
- indemnification / enterprise SLA.

---

## 11. Highest-Value Internal Questions

1. Can controlled / self-hosted deployment be repeated efficiently for a new Tier-1 customer, or is it still heavily bespoke?
2. Which lighthouse customers are willing to be public references, and for which exact workloads / metrics?
3. Is current platform observability and governance sufficient for the FSI workflows being positioned?
4. Which Product requirements are already supported, which are integration patterns and which are genuine gaps?
5. What private FSI evaluation / golden-set framework should be standardized?
6. Should Mistral maintain dedicated FSI FDE / SA coverage or use generalist coverage?
7. What is the default coexistence story for customers standardized on Azure, AWS, Google or an internal AI platform?
8. What is the pricing / packaging strategy for controlled deployment?
9. Which partner relationships actually produce access, implementation capacity or procurement advantage?
10. Which existing field assets solve repeated blockers and which should be retired?
11. What is the real FSI pipeline / revenue contribution by motion?
12. Which recurring objections are Product problems versus messaging / qualification problems?

---

## 12. Source Maintenance Standard

Before an external executive deck, campaign or battlecard is published:

1. revalidate every time-sensitive Product / competitor claim;
2. ensure every customer proof maps to a precise source;
3. remove technology-availability evidence when customer usage is being claimed;
4. distinguish direct, multi-model and indirect usage;
5. confirm customer referenceability before promising public proof;
6. flag generic / secondary URLs as insufficient for consequential claims;
7. update unresolved source-validation items;
8. preserve the distinction between fact, inference, recommendation and internal validation.
