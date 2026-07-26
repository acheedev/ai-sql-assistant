# AI SQL Assistant — Path to Alpha

AI SQL Assistant is moving beyond a sample application.

The product direction is a **governed, database- and model-provider-portable natural-language analytics system**. Authenticated users ask business questions, the system generates dialect-correct SQL against curated data surfaces, deterministic policy authorizes the query, the selected database adapter executes it under strict resource limits, and the system returns a traceable answer.

Oracle and PostgreSQL are the initial database platforms. The LLM layer must not be coupled to one vendor or one model family.

The alpha is not a public chatbot and not an autonomous DBA. It is a controlled, single-organization deployment with a deliberately narrow trust boundary.

---

## Alpha Product Contract

An alpha release must support this promise:

> An authenticated user can ask a question against an approved Oracle or PostgreSQL semantic layer and receive a traceable answer, while database privileges and deterministic application policy—not the LLM—control what may be queried and how much work may be performed.

The same product contract must hold regardless of the configured supported LLM provider.

### Initial Alpha Users

- business analysts working within an approved data domain,
- application support and operations teams answering recurring business questions,
- database and data-platform teams evaluating governed natural-language access,
- product owners reviewing whether semantic metadata matches real business language.

### Initial Deployment Boundary

- one organization,
- one controlled Oracle or PostgreSQL environment, or an approved read replica,
- a dedicated least-privilege database identity,
- explicitly curated semantic views,
- authenticated users and simple role-based policies,
- one configured LLM provider per deployment, with provider switching supported through configuration,
- no public anonymous access,
- no DML, DDL, stored-procedure execution, database links, extensions, or autonomous remediation.

### Initial Platform Matrix

#### Databases

- **Oracle** — first-class support.
- **PostgreSQL** — first-class support.

Both platforms must implement the same application-level contracts for semantic metadata, SQL authorization, bounded execution, serialization, health reporting, and audit evidence. Dialect-specific behavior must remain inside database adapters.

#### LLM providers

The core application must depend on a provider-neutral interface. Initial direct-provider targets are:

- **OpenAI**,
- **Anthropic**,
- **Google Gemini**.

Enterprise-hosted routes such as Azure OpenAI, Amazon Bedrock, Google Vertex AI, and approved OpenAI-compatible endpoints should be addable through adapters without changing the pipeline, authorization, cache, API, or evaluation contracts.

Support means more than accepting an API key. Each supported provider/model combination must pass the required evaluation suite and expose normalized usage, latency, error, and provenance metadata.

### Alpha Non-Goals

- broad multi-tenant SaaS,
- support for every SQL dialect,
- automatic portability to an untested database or model,
- unrestricted access to arbitrary enterprise schemas,
- replacing analysts or DBAs,
- autonomous database changes,
- perfect answers for every natural-language question,
- automatic cross-provider transmission of protected data without policy approval,
- UI breadth at the expense of safety and evaluation.

---

## Architectural Principles

1. **The database identity is the authoritative containment boundary.**
2. **The LLM proposes; deterministic policy decides.**
3. **Database-specific behavior belongs behind a database adapter.**
4. **Provider-specific behavior belongs behind an LLM provider adapter.**
5. **Semantic meaning is shared; SQL rendering and execution are dialect-specific.**
6. **Provider and database portability must be demonstrated by evaluation.**
7. **Cost, latency, privacy, and data residency are routing inputs—not afterthoughts.**
8. **No fallback may silently send protected data to a provider not allowed by policy.**

See `doc/PLATFORM_ARCHITECTURE.md` for the target contracts.

---

## Release Strategy

The path to alpha is organized around trust layers and portability boundaries. Each phase has an exit condition; later work should not hide unresolved earlier risks.

## Phase 0 — Establish the Product Baseline

### Deliverables

- Resolve API/package version inconsistencies.
- Choose supported launch paths for API, UI, and CLI.
- Add a changelog and version policy.
- Add CI for linting, typing, tests, and package installation.
- Pin or constrain tested dependency versions.
- Publish the architecture, threat model, database adapter contract, and LLM provider contract.
- Define the initial compatibility matrix: Python versions, Oracle versions, PostgreSQL versions, providers, and model families.
- Convert `doc/TECH_DEBT.md` items into tracked issues or milestones.

### Exit Condition

A clean checkout can be installed, tested, and launched through documented commands on a supported Python version, and the portability contracts are reviewed before implementation expands.

---

## Phase 1 — Extract Database and Provider Boundaries

### Database adapter deliverables

Introduce a database contract that owns:

- connection-pool creation and lifecycle,
- semantic metadata loading,
- dialect name and capabilities,
- SQL parsing/normalization integration,
- dialect-specific authorization rules,
- bounded query execution and cancellation,
- result-type serialization,
- liveness/readiness dependency checks,
- safe error classification and audit metadata.

Implement an Oracle adapter around the existing behavior without changing the external API contract.

### LLM provider deliverables

Introduce an LLM provider contract that normalizes:

- SQL-generation requests,
- explanation-generation requests,
- provider and model identity,
- timeout and retry behavior,
- structured-output capabilities,
- token/usage reporting,
- provider request identifiers,
- safety and content-policy failures,
- transient versus permanent errors,
- cost metadata supplied through configuration rather than hard-coded prices.

Implement the existing OpenAI path through the new contract before adding another provider.

### Exit Condition

The pipeline, API, cache, audit model, and tests no longer import Oracle- or OpenAI-specific implementations directly. Existing behavior passes through the new adapters without regression.

---

## Phase 2 — Lock Down Identity and Data Access

### Deliverables

- Add authentication to the API and UI.
- Define roles and authorization context.
- Provision dedicated least-privilege identities for both Oracle and PostgreSQL deployment patterns.
- Remove access to raw base tables from runtime identities wherever possible.
- Audit direct privileges, roles, inherited privileges, `PUBLIC`, executable routines, database links, foreign data wrappers, and extensions as applicable to the active platform.
- Make raw-result inclusion an explicit authorized capability.
- Add request-size, rate, concurrency, and cost controls.
- Disable the current global result cache until isolation rules are implemented.
- Define which LLM providers are approved for which data classifications and deployments.

### Exit Condition

Every query has a known principal, database policy context, and provider policy context. An unauthenticated caller cannot execute SQL or retrieve data, and application failure cannot expand database privileges.

---

## Phase 3 — Build Deterministic Multi-Dialect SQL Authorization

### Deliverables

- Select or implement a parser/AST layer validated for both Oracle and PostgreSQL syntax used by the product.
- Preserve a dialect-neutral authorization policy model with dialect-specific resolution where required.
- Resolve every referenced schema, object, column, function, package/routine, type, database link, foreign server, and extension-sensitive construct.
- Generate an allowlist from the active semantic-layer and authorization-policy versions.
- Reject unapproved objects and columns regardless of what the prompt requested.
- Reject unresolved names, cross-schema references outside policy, Oracle database links, PostgreSQL foreign-server access, locking clauses, dynamic constructs, and callable behavior outside an explicit allowlist.
- Preserve the validator as a deterministic boundary with no LLM calls.
- Return structured rejection reasons suitable for audit and evaluation.
- Build dialect-specific hostile-query corpora, including catalog and system-object access attempts.

### Exit Condition

A hostile or mistaken model output cannot escape the semantic allowlist in either the Oracle or PostgreSQL authorization suite. Database privilege tests independently prove that bypassed application controls still cannot access unapproved objects.

---

## Phase 4 — Govern Query Execution Across Platforms

### Deliverables

- Implement platform-appropriate statement timeouts and cancellation.
- Enforce maximum rows, fetched bytes, and explanation sample size.
- Replace unbounded `fetchall()` with incremental bounded fetching.
- Add concurrency controls and configurable pool limits.
- Tag sessions/connections with request and user identifiers where supported.
- Capture latency, rows, bytes, timeout state, platform, and normalized database error class.
- Optionally inspect estimated plan cost using a dialect-specific policy.
- Define normalized behavior for numeric, date/time, interval, JSON, array, LOB/large object, binary, UUID, and unsupported result types.
- Ensure health/readiness checks call the active database adapter rather than embedding Oracle assumptions.

### Exit Condition

Every query terminates within configured bounds on both supported databases and cannot exhaust application or database capacity during platform-specific load tests.

---

## Phase 5 — Add Multi-Provider LLM Support and Cost Governance

### Deliverables

- Add Anthropic and Google Gemini adapters after the OpenAI adapter is stable.
- Allow SQL generation and explanation to use independently configured provider/model choices.
- Define a provider capability matrix covering structured output, context size, timeout behavior, usage reporting, safety responses, and supported deployment routes.
- Normalize provider errors into stable internal and public error contracts.
- Add per-request provider/model provenance, token usage, latency, retry count, and configurable estimated cost.
- Add deployment policies for:
  - fixed provider/model,
  - approved fallback order,
  - no-fallback mode,
  - provider allowlists by data classification,
  - maximum cost and token budgets.
- Never perform cross-provider fallback when policy does not allow the prompt or result data to be sent to the fallback provider.
- Keep prompts provider-neutral where possible; isolate unavoidable provider-specific formatting inside adapters.
- Version prompts independently from provider adapters.

### Exit Condition

The same reviewed question corpus can run through each supported provider without core pipeline changes, and every enabled provider/model meets minimum safety, correctness, latency, and cost thresholds.

---

## Phase 6 — Make Answers Trustworthy and Inspectable

### Deliverables

Return a structured answer envelope containing:

- normalized question,
- generated and authorized SQL,
- database platform and dialect-adapter version,
- semantic-schema version,
- provider, model, and provider-adapter version,
- prompt version,
- authorization-policy version,
- row count and truncation state,
- explanation,
- warnings and limitations,
- request identifier.

Additionally:

- Treat database values as untrusted data in explanation prompts.
- Add deterministic empty-result handling.
- Add explanation faithfulness checks and evidence references.
- Preserve valid SQL results when explanation generation fails; report degraded success instead of losing the answer.
- Define when raw rows may be displayed, downloaded, cached, logged, or sent to an external provider.
- Permit deterministic or local explanation strategies for deployments that cannot send result data to an external model.

### Exit Condition

A reviewer can determine which database, provider, model, prompt, schema, and policy produced an answer, and explanation tests detect unsupported claims or prompt injection from row values.

---

## Phase 7 — Complete Observability and Auditability

### Deliverables

- Propagate request context through API, pipeline, authorization, database adapter, provider adapter, cache, and explanation layers.
- Separate public error messages from protected diagnostic detail.
- Redact sensitive question text, SQL literals, prompts, and row data by policy.
- Add `/health/live` for process liveness and `/health/ready` for active deployment readiness.
- Make readiness platform- and provider-aware without performing an expensive model generation on every probe.
- Add database-pool, provider, error-rate, latency, rejection, timeout, token, estimated-cost, and cache metrics.
- Introduce a durable audit event model with principal, database platform, provider/model, policy, schema, prompt, adapter, and SQL hashes.
- Add log rotation/retention guidance and deployment-safe structured logging.

### Exit Condition

Every alpha request can be reconstructed operationally without exposing protected data in ordinary logs, and operators can distinguish process failure, database unavailability, provider degradation, and policy rejection.

---

## Phase 8 — Build the Cross-Platform Evaluation System

Evaluation is part of the product, not a final QA step.

### Evaluation corpus

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
- empty and truncated results,
- equivalent Oracle/PostgreSQL schemas and expected result sets,
- provider refusal, throttling, timeout, and malformed-output behavior.

### Metrics

Track at least:

- answerable/unanswerable classification accuracy,
- SQL execution correctness,
- semantic object and column compliance,
- authorization rejection accuracy,
- result equivalence to reviewed SQL,
- cross-dialect semantic equivalence,
- explanation faithfulness,
- unsafe-query escape rate,
- provider/model variance,
- latency, token usage, and estimated cost,
- timeout and failure rates.

### Deliverables

- Versioned evaluation datasets.
- Deterministic expected outcomes where possible.
- Disposable Oracle and PostgreSQL integration fixtures.
- A test matrix across database platform × provider × model × prompt version.
- Before/after reports for database adapter, provider adapter, prompt, model, schema, and authorization changes.
- Release gates with zero tolerance for defined critical authorization escapes.
- A path to export compatible tasks into DB-Agent Bench.

### Exit Condition

Every release candidate has a reproducible evaluation report showing whether safety, correctness, portability, latency, or cost regressed.

---

## Phase 9 — Package a Deployable Alpha

### Deliverables

- Containerized API and UI builds.
- Environment-variable or secret-manager configuration.
- Database pool lifecycle management through adapters.
- Semantic metadata migrations and seed packages for Oracle and PostgreSQL.
- Deployment guides for both platforms.
- Provider configuration and data-governance guides.
- Backup, rollback, and incident procedures.
- Sample policy and semantic-layer packages.
- Operator runbooks and troubleshooting guides.
- Basic usage, quality, latency, and cost analytics.

### Exit Condition

A second machine or controlled environment can deploy one supported database/provider combination from documentation without relying on the original developer's workstation state.

---

## Phase 10 — Controlled Alpha Pilot

### Pilot shape

- small named user group,
- one approved data domain,
- one supported database platform per pilot deployment,
- one primary provider/model plus an explicitly approved fallback or no-fallback policy,
- curated question set plus monitored free-form use,
- clear warning that the product is alpha,
- human verification for consequential decisions,
- weekly review of failed, rejected, expensive, and misleading answers.

### Pilot questions

- Do users ask questions covered by the semantic layer?
- Which business terms are missing or ambiguous?
- Does the assistant reduce time-to-answer for recurring requests?
- Which answers require analyst or DBA correction?
- Are rejections understandable and appropriately conservative?
- What data do users actually need returned versus summarized?
- How do cost, latency, and answer quality vary by provider/model?
- Does the same semantic contract produce equivalent answers on Oracle and PostgreSQL?
- What controls do security and data-governance stakeholders require next?

### Exit Condition

The pilot produces reviewed evidence that the system is useful, bounded, portable, and diagnosable—and a prioritized beta backlog based on observed behavior rather than assumptions.

---

## Alpha Release Criteria

The project may be labeled **alpha** when all of the following are true.

### Security and governance

- [ ] Authentication is required.
- [ ] Oracle and PostgreSQL deployment patterns use dedicated least-privilege identities.
- [ ] Parsed object/column/function authorization is enforced for both dialects.
- [ ] Database-level negative privilege tests pass on both platforms.
- [ ] Anonymous raw-result access is impossible.
- [ ] Provider use is restricted by deployment and data-classification policy.
- [ ] Error responses and ordinary logs pass redaction tests.

### Portability

- [ ] Oracle and PostgreSQL adapters satisfy the same database contract.
- [ ] OpenAI, Anthropic, and Google Gemini adapters satisfy the same provider contract, or any provider not yet release-ready is explicitly excluded from the alpha compatibility matrix.
- [ ] Core pipeline code contains no direct database-driver or provider-SDK dependency.
- [ ] Platform/provider combinations are declared as tested, experimental, or unsupported.

### Reliability

- [ ] Query timeout, row, byte, and concurrency limits are enforced.
- [ ] Database pool startup and shutdown are managed.
- [ ] Expected failures have stable public error codes.
- [ ] UI preserves structured API error responses and request IDs.
- [ ] Liveness and readiness checks reflect active database and provider state.
- [ ] Provider retry and fallback behavior is bounded and policy-controlled.

### Trust and cost

- [ ] Every response records database, schema, provider, model, prompt, adapter, and policy versions.
- [ ] Explanation generation treats rows as untrusted data.
- [ ] Empty, partial, truncated, and explanation-degraded results are explicit.
- [ ] Token usage, latency, and configurable estimated cost are recorded.
- [ ] Critical safety evaluation cases have zero escapes.

### Engineering

- [ ] CI passes unit, API, security, Oracle integration, PostgreSQL integration, and provider-contract suites.
- [ ] A reproducible cross-platform evaluation report is generated for the release candidate.
- [ ] Container and deployment documentation are verified from a clean environment.
- [ ] Known remaining debt is documented with owners or milestones.

### Pilot readiness

- [ ] The semantic layer covers one real, bounded business domain on at least one supported database.
- [ ] A named alpha user group and support process exist.
- [ ] Feedback and correction capture are operational.
- [ ] Rollback and incident procedures have been exercised.

---

## Product Principles Going Forward

1. **The database identity is the authoritative containment boundary.**
2. **The LLM proposes; deterministic policy decides.**
3. **The semantic layer is a governed contract, not prompt decoration.**
4. **Read-only is necessary but not sufficient.**
5. **Database and provider portability must be earned through testing.**
6. **Every answer must be traceable to platform, provider, versions, policy, SQL, and evidence.**
7. **Evaluation ships with the feature.**
8. **A conservative refusal is better than an unauthorized answer.**
9. **A cheaper model is valuable only when it meets the required quality and safety threshold.**
10. **Trust, cost visibility, and operational control outrank UI expansion.**

The objective is not merely to generate SQL. The objective is to make AI-mediated access to enterprise data safe, portable, measurable, and useful enough to earn continued deployment.