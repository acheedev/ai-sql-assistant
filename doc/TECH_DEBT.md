# AI SQL Assistant — Technical Debt

This document records gaps found by comparing the current implementation with the product intent in `README.md`, the normative boundary in `SECURITY.md`, and the alpha direction in `doc/FUTURE.md`.

It is a working engineering backlog, not a criticism of the prototype. The current code proves the Oracle/OpenAI end-to-end concept. The next phase is to turn that concept into a controlled, portable alpha product supporting Oracle, PostgreSQL, and multiple approved LLM providers.

See `doc/PLATFORM_ARCHITECTURE.md` for the target database and provider contracts.

## Priority Definitions

- **P0 — Alpha blocker:** security, data exposure, correctness, or operational risk that must be resolved before outside users rely on the system.
- **P1 — Required for a credible alpha:** portability, reliability, observability, evaluation, and deployment work needed before a sustained pilot.
- **P2 — Post-alpha hardening:** maintainability, performance, and product maturity work that can follow a controlled alpha.

---

## P0 — Alpha Blockers

### 1. Generated SQL is not deterministically authorized against the semantic layer

**Current state**

`validator.py` checks statement shape, semicolons, and a short forbidden-keyword list. The prompt tells the model to use approved objects and columns, but code does not independently enforce that rule.

**Risk**

- A model can reference raw tables, unapproved schemas, catalog objects, functions, packages/routines, database links, foreign servers, extensions, or expensive constructs.
- A syntactically read-only query can still expose protected data or invoke unsafe behavior.
- Regex authorization cannot safely cover either Oracle or PostgreSQL syntax.

**Required direction**

- Parse SQL into a dialect-aware AST.
- Resolve and authorize every schema, object, column, callable object, type, and remote-data construct.
- Enforce an allowlist derived from semantic metadata and authenticated policy context.
- Reject unresolved or unsupported syntax by default.
- Keep the allow/deny decision deterministic and LLM-free.
- Independently require least-privilege database identities so parser failure cannot expand access.

### 2. The application is structurally coupled to Oracle

**Current state**

Core modules import `oracledb`, create an Oracle pool directly, execute Oracle-specific health SQL, and build prompts with unconditional Oracle syntax rules. Semantic metadata queries and result assumptions are Oracle-specific.

**Risk**

Adding PostgreSQL directly to the current structure would spread database conditionals through the pipeline, prompt builder, authorization layer, health checks, serialization, settings, and tests. That creates two partially divergent products rather than one portable product.

**Required direction**

- Introduce a `DatabaseAdapter` contract before implementing PostgreSQL.
- Move driver, pool lifecycle, semantic loading, dialect rules, authorization integration, execution limits, serialization, health, and error normalization behind adapters.
- Re-implement current behavior as an Oracle adapter.
- Add PostgreSQL as a first-class adapter satisfying the same normalized contracts.
- Keep the API, pipeline, cache, audit, and semantic business model database-neutral.

### 3. The application is structurally coupled to OpenAI

**Current state**

`llm.py`, health checking, settings, retries, and response handling directly use the OpenAI SDK and OpenAI response model.

**Risk**

- Provider switching requires core-code changes.
- Provider errors and usage metadata leak into product behavior.
- Cost, latency, privacy, and data-residency choices cannot be governed cleanly.
- SQL generation and explanation cannot use different approved providers/models.
- Fallback behavior could later transmit protected data to an unapproved provider.

**Required direction**

- Introduce an `LLMProvider` contract before adding another SDK.
- Re-implement current behavior through an OpenAI adapter.
- Add direct adapters for Anthropic and Google Gemini.
- Normalize provider/model identity, usage, latency, request IDs, finish reasons, retries, timeouts, and failure categories.
- Make provider/model selection policy- and configuration-driven.
- Require explicit data-classification and fallback policy before transmitting prompts or rows.

### 4. No authentication or authorization boundary

The API exposes `/query` and optional raw rows without authentication. Anyone who can reach it can generate SQL, consume provider budget, and request data.

**Required direction**

- Add authenticated principals before shared deployment.
- Define roles and per-user/per-group access.
- Bind semantic objects, columns, raw-result visibility, database deployment, and provider policy to authorization context.
- Include that context in cache keys, audit records, and evaluations.

### 5. Database privilege assumptions are not verified by the application or deployment process

The product assumes a least-privilege runtime identity but does not provision, inspect, or negatively test effective privileges.

**Required direction**

- Document Oracle and PostgreSQL least-privilege deployment patterns.
- Automate negative tests for raw tables, system catalogs, callable objects, remote-data access, role changes, DML, DDL, and locking.
- Audit inherited roles, ownership, and `PUBLIC` grants.
- Fail deployment readiness when required privilege evidence is missing or invalid.

### 6. Query execution is unbounded

`db.py` calls `cursor.fetchall()` without a statement timeout, row cap, byte cap, fetch batching, cancellation, or hard concurrency policy.

**Required direction**

- Implement platform-specific timeout and cancellation through database adapters.
- Enforce maximum rows and bytes.
- Fetch incrementally.
- Add bounded pool/concurrency behavior.
- Consider dialect-specific estimated-cost gates.

### 7. Error responses can leak provider, database, and internal details

Pipeline failures place raw exception text into public messages. The current behavior can expose database diagnostics, connection details, and provider text.

**Required direction**

- Return stable public error codes and safe messages.
- Keep protected diagnostics only in controlled logs.
- Normalize database and provider failures behind adapter exception contracts.
- Add redaction regressions for Oracle, PostgreSQL, OpenAI, Anthropic, and Gemini-shaped errors.

### 8. Cache isolation is unsafe

The cache key is only the normalized question, while cached values include SQL, explanations, and raw rows.

**Required direction**

Disable result caching for alpha or include at least:

- principal/authorization scope,
- database deployment and platform,
- semantic-schema and policy versions,
- provider, model, and provider-adapter version,
- database-adapter version,
- prompt version,
- normalized question and request options.

Define retention, invalidation, and protected-data handling before re-enabling it.

### 9. Database results are treated as trusted instructions during explanation

Rows are interpolated directly into an LLM prompt as Python representations.

**Required direction**

- Serialize a bounded typed envelope before any provider call.
- Mark rows as untrusted data.
- Add stored-data prompt-injection cases.
- Permit deterministic, redacted, aggregate-only, local, or disabled explanation modes.
- Enforce provider/data-classification policy separately for explanation.

### 10. Provider transmission and fallback policy does not exist

The application has no formal decision point governing which schema, question, SQL, or result data may be sent to which provider or hosted route.

**Required direction**

- Resolve provider policy before constructing a request.
- Define approved providers, models, routes, regions, and data classes.
- Default to no cross-provider fallback.
- Audit provider/model provenance without storing protected payloads by default.

### 11. Sensitive data can be written to logs

Debug logs can contain complete prompts, generated SQL, database rows, and user questions. Several events lack `request_id`.

**Required direction**

- Establish logging classification and redaction policy.
- Remove raw rows and full prompts from ordinary logs.
- Propagate request context through every layer and adapter.
- Add rotation, retention, access control, and failure-safe logging.

### 12. The UI discards structured non-200 API responses

`raise_for_status()` converts expected 422/502 product outcomes into generic transport errors.

**Required direction**

Parse expected response bodies, preserve `request_id` and structured status, and add integration tests for every result path.

### 13. Public result/error semantics are unstable

Provider failures, database failures, authorization rejections, expected product outcomes, and internal exceptions are compressed into seven broad statuses. Unexpected errors are mislabeled as database failures, and successful SQL with failed explanation becomes a 502.

**Required direction**

Define stable outcomes for invalid request, unanswerable question, authorization rejection, unsafe SQL, timeout/resource limit, database unavailable, provider unavailable, provider refusal, malformed model output, explanation degraded, and internal error.

---

## P1 — Required for a Credible Alpha

### 14. Prompt construction is hard-coded to Oracle

`prompt.py` unconditionally identifies the target as Oracle and teaches Oracle-specific syntax.

**Required direction**

- Accept a dialect rule set from the active database adapter.
- Maintain reviewed Oracle and PostgreSQL examples.
- Version prompt templates independently of provider adapters.
- Test that one dialect never emits syntax from the other.

### 15. Semantic metadata has no cross-platform normalized contract

Current semantic loading is tied to Oracle tables and Oracle driver values.

**Required direction**

Define a normalized semantic model shared by both platforms, with dialect-specific migrations and physical metadata. Include platform, physical object identity, sensitivity, authorization tags, and semantic version.

### 16. No normalized result-type contract

Oracle values such as `Decimal`, timestamps, LOBs, and bytes are not centrally normalized. PostgreSQL adds UUID, JSONB, arrays, intervals, and additional driver-native values.

**Required direction**

Create one bounded JSON-safe result model with explicit handling for all supported platform types and safe behavior for unsupported or oversized values.

### 17. Provider request/response contract is incomplete

The model is hard-coded and calls lack explicit total timeout, output-token limit, prompt version, provider request ID, normalized usage, or cost metadata.

**Required direction**

Normalize provider request/response evidence and keep model identifiers and configurable cost rates outside code.

### 18. Retry behavior is provider-specific and incomplete

The current retry code has an unused helper, no jitter, no `Retry-After` handling, blocking sleeps, and confusing delay logging.

**Required direction**

Implement bounded adapter-level retry policies while preserving stable product outcomes. Retry must never change provider or route unless policy explicitly permits it.

### 19. Health checking is Oracle/OpenAI-shaped

The current `/health` performs `SELECT 1 FROM DUAL` and only constructs an OpenAI client.

**Required direction**

- Add `/health/live` without external dependencies.
- Add `/health/ready` through the active database and provider adapters.
- Test the configured deployment combination, not every supported adapter.
- Avoid a billable model call on every probe.
- Protect detailed dependency diagnostics.

### 20. Response-model behavior does not match documentation

`sql`, `row_count`, and `is_safe` do not consistently follow their documented error-path behavior.

Choose one contract and test it at the API boundary.

### 21. Application and package versions disagree

`pyproject.toml` declares `0.1.0`; FastAPI declares `1.0.0`.

Use one version source and include build/adapter versions in health, responses, and audit records.

### 22. The API console-script entry point is invalid

The console-script target points to an ASGI application object rather than a callable launcher.

Provide a launcher or document `uvicorn` as the supported command.

### 23. Streamlit has import-time side effects

`main_page()` runs on import, conflicting with console-script behavior and testability.

Move rendering behind explicit entry functions.

### 24. Semantic schema is reloaded on every uncached question

Add a bounded, versioned semantic snapshot with explicit refresh/invalidation. Include its version in responses and cache/audit keys.

### 25. Question input and provider spend have no abuse controls

There is no maximum question size, rate limit, quota, concurrency policy, token budget, or cost budget.

Add per-principal and deployment controls with safe defaults.

### 26. Database pool lifecycle is unmanaged

The Oracle pool is lazy and never closed. Pool sizing is fixed. PostgreSQL will require a parallel but not identical lifecycle.

Move lifecycle into database adapters and FastAPI lifespan hooks with acquisition timeout and metrics.

### 27. Empty-result behavior wastes a provider call

Return a deterministic empty-result explanation instead of invoking an LLM.

### 28. CLI behavior is not automation-friendly

The CLI catches broad exceptions, does not consistently return non-zero status, permits ambiguous arguments, and lacks a machine-readable run manifest.

### 29. Dependencies and supported combinations are not reproducible

Runtime dependencies are unbounded. There is no lock file, supply-chain scan, database-driver extras, provider extras, or compatibility matrix.

Define tested ranges and optional dependencies such as database/provider adapter groups without forcing every SDK into every deployment.

### 30. Test coverage stops at mocked component boundaries

Alpha needs:

- API contract tests,
- UI/API integration tests,
- Oracle integration tests,
- PostgreSQL integration tests,
- dialect parser/authorization tests,
- provider contract tests for OpenAI, Anthropic, and Gemini,
- provider refusal/throttle/timeout/malformed-output tests,
- cross-dialect result-equivalence tests,
- database × provider evaluation runs,
- concurrency, timeout, prompt-injection, and data-exfiltration tests.

### 31. No CI compatibility or release gate

Add CI for supported Python versions, unit and integration suites, package/install verification, adapter extras, dependency scanning, and a declared compatibility matrix. Releases need measurable safety, correctness, portability, latency, and cost gates.

### 32. Cost visibility and model qualification are absent

The application cannot compare qualified models using token use, latency, and configurable estimated cost.

**Required direction**

- Record normalized usage and latency.
- Load price assumptions through configuration, never hard-code volatile vendor prices.
- Establish minimum evaluation thresholds before a model becomes eligible for cost-based routing.
- Allow different qualified models for SQL generation and explanation.

---

## P2 — Post-Alpha Hardening

### 33. Pipeline concerns are tightly coupled

The pipeline imports global cache, database, provider, prompt, validator, and explanation implementations. Use explicit interfaces and dependency injection.

### 34. Logging mutates the root logger

Move to application-owned logging suitable for multi-worker deployment and external observability backends.

### 35. Regex normalization can alter SQL literals

Comment stripping is not quote-aware, and semicolon behavior differs from the README. Replace it with parser-aware normalization.

### 36. No durable product-level audit record

Add a structured audit model containing principal, database deployment/platform, provider/model/route, policy/schema/prompt/adapter versions, SQL hash, authorization decision, resource metrics, result classification, and final disposition—without protected payloads by default.

### 37. No feedback and correction loop

Users and reviewers need to mark answers correct, incorrect, unsafe, incomplete, expensive, or misleading and feed reviewed cases into the evaluation corpus.

### 38. No intermediate query representation

Free-form SQL generation makes cross-dialect equivalence and authorization harder. Explore a constrained query representation compiled by database adapters after the first portable alpha is stable.

### 39. No enterprise provider gateway or local-model strategy

After direct adapters are stable, evaluate Azure OpenAI, Bedrock, Vertex AI, approved OpenAI-compatible gateways, and self-hosted models according to customer governance and cost needs. Do not add them as ad hoc SDK branches.

---

## Recommended Resolution Order

1. Disable/isolate cache; add authentication and verified least-privilege database access.
2. Extract current Oracle behavior behind the database adapter contract.
3. Extract current OpenAI behavior behind the provider adapter contract.
4. Replace the regex gate with parsed, dialect-aware semantic authorization.
5. Add execution row/byte/concurrency/timeout limits and normalized result serialization.
6. Stop error/log leakage and establish stable public outcomes.
7. Implement PostgreSQL through the database contract.
8. Add Anthropic and Google Gemini through the provider contract.
9. Build Oracle/PostgreSQL integration fixtures and the database × provider evaluation matrix.
10. Add cost visibility and policy-controlled model/provider routing.
11. Package and deploy a controlled single-organization alpha.

This ordering intentionally prioritizes **security boundaries and clean abstraction before multiplying platforms**, babe.