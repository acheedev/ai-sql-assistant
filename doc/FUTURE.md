# AI SQL Assistant — Path to Alpha

AI SQL Assistant is moving beyond a sample application.

The product direction is a **governed natural-language analytics system for enterprise Oracle environments**: authenticated users ask business questions, the system generates authorized SQL against curated data surfaces, executes it under strict resource limits, and returns an answer whose origin and limitations can be inspected.

The alpha is not a public chatbot and not an autonomous DBA. It is a controlled, single-organization deployment with a deliberately narrow trust boundary.

---

## Alpha Product Contract

An alpha release must support this promise:

> An authenticated user can ask a question against an approved Oracle semantic layer and receive a traceable answer, while deterministic policy—not the LLM—controls what may be queried and how much work may be performed.

### Initial Alpha Users

- business analysts working within an approved data domain,
- application support and operations teams answering recurring business questions,
- database and data-platform teams evaluating governed natural-language access,
- product owners reviewing whether semantic metadata matches real business language.

### Initial Deployment Boundary

- one organization,
- one controlled Oracle environment or approved read replica,
- a least-privilege read-only database account,
- explicitly curated semantic views,
- authenticated users and simple role-based policies,
- no public anonymous access,
- no DML, DDL, stored-procedure execution, database links, or autonomous remediation.

### Alpha Non-Goals

- broad multi-tenant SaaS,
- support for every SQL dialect,
- unrestricted access to arbitrary enterprise schemas,
- replacing analysts or DBAs,
- autonomous database changes,
- perfect answers for every natural-language question,
- UI breadth at the expense of safety and evaluation.

---

## Release Strategy

The path to alpha is organized around trust layers. Each phase has an exit condition; later work should not hide unresolved earlier risks.

## Phase 0 — Establish the Product Baseline

### Deliverables

- Resolve all API/package version inconsistencies.
- Choose one supported launch path for API, UI, and CLI.
- Add a changelog and version policy.
- Add CI for linting, typing, tests, and package installation.
- Pin or constrain tested dependency versions.
- Publish the current architecture and threat model.
- Convert `doc/TECH_DEBT.md` items into tracked issues or milestones.

### Exit Condition

A clean checkout can be installed, tested, and launched through documented commands on a supported Python version.

---

## Phase 1 — Lock Down Identity and Data Access

### Deliverables

- Add authentication to the API and UI.
- Define roles and authorization context.
- Run Oracle through a dedicated least-privilege read-only account.
- Remove access to raw base tables from that account wherever possible.
- Make raw result inclusion an explicit authorized capability.
- Add request-size, rate, concurrency, and cost controls.
- Disable the current global result cache until isolation rules are implemented.

### Exit Condition

Every query has a known principal and policy context, and an unauthenticated caller cannot execute SQL or retrieve data.

---

## Phase 2 — Build Deterministic SQL Authorization

### Deliverables

- Introduce an Oracle-capable SQL parser or AST layer.
- Resolve all referenced schemas, objects, columns, functions, packages, and database links.
- Generate an allowlist from the active semantic-layer version.
- Reject unapproved objects and columns regardless of what the prompt requested.
- Reject side-effect-capable functions, database links, dynamic constructs, hints outside policy, and unresolved names.
- Preserve `validator.py` as a deterministic boundary with no LLM calls.
- Return structured rejection reasons suitable for audit and evaluation.

### Exit Condition

A hostile or mistaken model output cannot escape the semantic allowlist in the authorization test suite.

---

## Phase 3 — Govern Query Execution

### Deliverables

- Add Oracle statement/call timeouts.
- Enforce maximum rows, fetched bytes, and explanation sample size.
- Replace unbounded `fetchall()` with incremental bounded fetching.
- Add cancellation and concurrency controls.
- Add session tagging with request and user identifiers.
- Capture latency, rows, bytes, timeout state, and database error class.
- Optionally inspect estimated plan cost and reject pathological work before execution.
- Define behavior for LOB, binary, date, timestamp, numeric, and unsupported result types.

### Exit Condition

Every query terminates within configured resource bounds and cannot exhaust application or database capacity during load tests.

---

## Phase 4 — Make Answers Trustworthy and Inspectable

### Deliverables

- Return a structured answer envelope containing:
  - normalized question,
  - generated and authorized SQL,
  - semantic-schema version,
  - model and prompt version,
  - row count and truncation state,
  - explanation,
  - warnings and limitations,
  - request identifier.
- Treat database values as untrusted data in explanation prompts.
- Add deterministic empty-result handling.
- Add explanation faithfulness checks and evidence references.
- Preserve valid SQL results when explanation generation fails; report a degraded result instead of losing the answer.
- Define when raw rows may be displayed, downloaded, cached, or logged.

### Exit Condition

A reviewer can determine what data and policy produced an answer, and explanation tests detect unsupported claims or prompt injection from row values.

---

## Phase 5 — Complete Observability and Auditability

### Deliverables

- Propagate request context through API, pipeline, validator, database, LLM, cache, and explanation layers.
- Separate public error messages from protected diagnostic detail.
- Redact sensitive question text, SQL literals, prompts, and row data by policy.
- Add liveness and readiness endpoints.
- Add pool, provider, error-rate, latency, rejection, timeout, and cache metrics.
- Introduce a durable audit event model with policy, schema, prompt, model, and SQL hashes.
- Add log rotation/retention guidance and deployment-safe structured logging.

### Exit Condition

Every alpha request can be reconstructed operationally without exposing protected data in ordinary logs.

---

## Phase 6 — Build the Evaluation System

Evaluation is part of the product, not a final QA step.

### Evaluation Corpus

Create reviewed cases across:

- straightforward retrieval,
- joins and aggregations,
- time-window questions,
- status and business-term resolution,
- ambiguous questions,
- unanswerable questions,
- unsafe requests,
- semantic-schema gaps,
- prompt injection in user text,
- prompt injection in stored database values,
- expensive but read-only SQL,
- explanation faithfulness,
- empty and truncated results.

### Metrics

Track at least:

- answerable/unanswerable classification accuracy,
- SQL execution correctness,
- semantic object and column compliance,
- authorization rejection accuracy,
- result equivalence to reviewed SQL,
- explanation faithfulness,
- unsafe-query escape rate,
- latency and provider cost,
- timeout and failure rates.

### Deliverables

- Versioned evaluation datasets.
- Deterministic expected outcomes where possible.
- Oracle integration fixtures in a disposable environment.
- Before/after comparison reports for prompt, model, schema, or validator changes.
- A release gate with minimum thresholds and zero tolerance for defined critical safety escapes.
- A path to export compatible tasks into DB-Agent Bench.

### Exit Condition

Every release candidate has a reproducible evaluation report showing whether safety, correctness, or cost regressed.

---

## Phase 7 — Package a Deployable Alpha

### Deliverables

- Containerized API and UI builds.
- Environment-variable or secret-manager configuration.
- Database pool lifecycle management.
- Schema migration and semantic-seed versioning.
- Deployment guide for a controlled Oracle environment.
- Backup, rollback, and incident procedures.
- A sample policy and semantic-layer package.
- An operator runbook and troubleshooting guide.
- Basic usage analytics and user-feedback capture.

### Exit Condition

A second machine or controlled environment can deploy the product from documentation without relying on the original developer's workstation state.

---

## Phase 8 — Controlled Alpha Pilot

### Pilot Shape

- small named user group,
- one approved data domain,
- curated question set plus monitored free-form use,
- clear warning that the product is alpha,
- human verification for consequential decisions,
- weekly review of failed, rejected, and misleading answers.

### Pilot Questions

The pilot should answer:

- Do users ask questions covered by the semantic layer?
- Which business terms are missing or ambiguous?
- Does the assistant reduce time-to-answer for recurring requests?
- Which answers require analyst or DBA correction?
- Are rejections understandable and appropriately conservative?
- What data do users actually need returned versus summarized?
- What controls do security and data-governance stakeholders require next?

### Exit Condition

The pilot produces reviewed evidence that the system is useful, bounded, and diagnosable—and a prioritized beta backlog based on observed behavior rather than assumptions.

---

## Alpha Release Criteria

The project may be labeled **alpha** when all of the following are true:

### Security and Governance

- [ ] Authentication is required.
- [ ] Oracle access is least-privilege and read-only.
- [ ] Parsed object/column/function authorization is enforced.
- [ ] Anonymous raw-result access is impossible.
- [ ] Error responses and ordinary logs pass redaction tests.

### Reliability

- [ ] Query timeout, row, byte, and concurrency limits are enforced.
- [ ] Database pool startup and shutdown are managed.
- [ ] Expected failures have stable public error codes.
- [ ] UI preserves structured API error responses and request IDs.
- [ ] Health/readiness checks reflect real dependency state.

### Trust

- [ ] Every response records schema, prompt, model, and policy versions.
- [ ] Explanation generation treats rows as untrusted data.
- [ ] Empty, partial, truncated, and explanation-degraded results are explicit.
- [ ] Critical safety evaluation cases have zero escapes.

### Engineering

- [ ] CI passes unit, API, security, and Oracle integration suites.
- [ ] A reproducible evaluation report is generated for the release candidate.
- [ ] Container and deployment documentation are verified from a clean environment.
- [ ] Known remaining debt is documented with owners or milestones.

### Pilot Readiness

- [ ] The semantic layer covers one real, bounded business domain.
- [ ] A named alpha user group and support process exist.
- [ ] Feedback and correction capture are operational.
- [ ] Rollback and incident procedures have been exercised.

---

## Product Principles Going Forward

1. **The LLM proposes; deterministic policy decides.**
2. **The semantic layer is a governed contract, not prompt decoration.**
3. **Read-only is necessary but not sufficient.**
4. **Every answer must be traceable to versions, policy, SQL, and evidence.**
5. **Evaluation ships with the feature.**
6. **A conservative refusal is better than an unauthorized answer.**
7. **Trust and operational control outrank UI expansion.**

The objective is not merely to generate SQL. The objective is to make AI-mediated access to enterprise data safe enough to evaluate honestly and useful enough to earn continued deployment.