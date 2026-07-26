# AI SQL Assistant — Technical Debt

This document records gaps found by comparing the current implementation with the product intent and the guarantees described in `README.md`.

It is a working engineering backlog, not a criticism of the prototype. The current code proves the end-to-end concept. The next phase is to turn that concept into a controlled alpha product.

## Priority Definitions

- **P0 — Alpha blocker:** security, data exposure, correctness, or operational risk that must be resolved before outside users are allowed to rely on the system.
- **P1 — Required for a credible alpha:** reliability, observability, evaluation, and deployment work needed before a sustained pilot.
- **P2 — Post-alpha hardening:** maintainability, performance, and product maturity work that can follow a controlled alpha.

---

## P0 — Alpha Blockers

### 1. Generated SQL is not deterministically authorized against the semantic layer

**Current state**

`validator.py` checks that SQL begins with `SELECT` or `WITH`, contains no semicolon after normalization, and does not contain a short list of forbidden keywords.

The prompt tells the model to use only semantic objects and columns, but the validator does not independently enforce that rule.

**Risk**

- The model can reference raw tables, unapproved views, columns, functions, packages, database links, or schemas.
- A syntactically read-only statement can still invoke functions with side effects or expensive behavior.
- Oracle `WITH` syntax and callable functions make keyword filtering an insufficient authorization boundary.

**Required direction**

- Parse Oracle SQL into an AST.
- Resolve every referenced object, column, function, and database link.
- Enforce an explicit allowlist derived from the semantic layer and authorization context.
- Reject unresolved, ambiguous, cross-schema, database-link, dynamic, or callable constructs by default.
- Keep the decision deterministic; do not place an LLM inside the authorization path.

### 2. No authentication or authorization boundary

**Current state**

The FastAPI application exposes `/query` and optional raw result rows without authentication. `api.py` contains a TODO for API-key middleware.

**Risk**

Anyone who can reach the service can generate SQL, execute it, consume LLM budget, and request raw database results. There is no user, role, tenant, or policy context.

**Required direction**

- Add authenticated identities before any shared deployment.
- Define roles and per-user/per-group data access.
- Bind semantic objects and result visibility to authorization context.
- Include authorization context in cache keys, audit records, and evaluation scenarios.

### 3. Query execution is unbounded

**Current state**

`db.py` executes generated SQL and calls `cursor.fetchall()` with no server-side statement timeout, row cap, byte cap, fetch batching, cancellation, or resource governance.

**Risk**

A valid `SELECT` can consume excessive CPU, I/O, memory, database sessions, network bandwidth, or application memory. The API's 30-second UI timeout does not cancel work on the server or database.

**Required direction**

- Use a least-privilege read-only Oracle account.
- Configure per-session query timeout/call timeout and resource limits.
- Enforce a maximum row count and response-size budget.
- Fetch incrementally rather than using unbounded `fetchall()`.
- Add cancellation and a hard concurrency limit.
- Consider an explain/estimate gate for unusually expensive plans.

### 4. Error responses can leak internal and database details

**Current state**

Pipeline failures place raw exception text into `PipelineResult.message`, including:

- `Unhandled pipeline error: {exc}`
- `Database execution failed: {exc}`
- `LLM call failed: {exc}`
- `Explanation generation failed: {exc}`

The API returns that message to callers. Tests explicitly assert that Oracle-style connection details remain in the response message.

**README discrepancy**

The README states that API errors must never expose connection strings, credentials, or raw Oracle diagnostics.

**Required direction**

- Return stable public error codes and safe user-facing messages.
- Log detailed exceptions only in protected server logs.
- Add structured exception classes for schema loading, execution, timeout, authorization, provider, and internal failures.
- Add regression tests that seed credential-like and Oracle diagnostic text and prove it is redacted from responses.

### 5. Cache isolation is unsafe for a real product

**Current state**

The cache key is only a normalized natural-language question. Successful `PipelineResult` objects, including SQL, explanation, and raw rows, are stored in a process-global cache.

**Risk**

- Different users or roles can receive data generated under another authorization context.
- Results remain stale when semantic metadata, prompt rules, model versions, or source data change.
- Sensitive rows remain in process memory.
- Multiple application workers have independent, inconsistent caches.

**Required direction**

Either disable result caching for alpha or version and isolate keys by at least:

- authenticated principal and role,
- authorization policy version,
- semantic-schema version,
- prompt version,
- model/provider version,
- database/source identifier,
- normalized question and relevant request options.

Define data-retention, eviction, and invalidation behavior before re-enabling it.

### 6. Database results are treated as trusted instructions during explanation

**Current state**

The explanation prompt interpolates Python representations of database rows directly into an LLM prompt. Result values are not delimited as untrusted data, typed, serialized through a stable format, or screened for prompt-injection content.

**Risk**

A database value can manipulate the explanation model, cause unfaithful output, expose data from the prompt, or produce unsafe links/markup in the UI.

**Required direction**

- Serialize a bounded, typed result envelope.
- Mark all row values as untrusted data, never instructions.
- Add prompt-injection test cases stored in database fields.
- Validate explanation structure and require evidence references to returned rows/aggregates.
- Prefer deterministic summaries for simple result shapes.

### 7. Sensitive data can be written to logs

**Current state**

Debug logs can contain the complete prompt, generated SQL, and complete database rows. User questions are logged directly. Several lower-level events do not carry `request_id`.

**README discrepancy**

The README presents `request_id` as the thread tying the full operation together, but `db_execute_complete`, validator events, prompt events, and explanation events are not consistently enriched with it.

**Required direction**

- Establish a logging data-classification policy.
- Remove raw rows and full prompts from default logs.
- Redact or hash sensitive literals in SQL and questions.
- Propagate request context through every layer.
- Add log rotation, retention, access controls, and structured exception fields.
- Ensure logging failures cannot break query processing.

### 8. The UI discards the API's structured non-200 responses

**Current state**

`app.py` calls `raise_for_status()`. FastAPI intentionally returns 422 or 502 for pipeline statuses, so the UI catches `HTTPError` and replaces the structured response with a generic message such as `API returned 422.`

The status badge mappings and detailed messages for `QUESTION_ERROR`, `UNSAFE_SQL`, `DB_ERROR`, `LLM_ERROR`, and `EXPLANATION_ERROR` are therefore bypassed on normal error paths.

**Required direction**

- Parse the JSON response body for expected API statuses before treating it as a transport failure.
- Preserve `request_id`, status, safe message, and permitted SQL/results.
- Add API-to-UI integration tests for every status.

### 9. Direct apply of provider and database exceptions creates unstable API contracts

The application currently mixes transport failures, expected product outcomes, provider errors, database errors, and unexpected internal exceptions into seven broad statuses. Unexpected exceptions are labeled `DB_ERROR` even when they are unrelated to Oracle.

**Required direction**

Define a stable public error taxonomy and separate:

- invalid request,
- unanswerable question,
- authorization rejection,
- unsafe SQL,
- query timeout/resource limit,
- database unavailable,
- provider unavailable,
- explanation degraded,
- internal error.

An explanation failure after successful SQL execution should be considered a partial/degraded success rather than automatically discarding a valid answer behind HTTP 502.

---

## P1 — Required for a Credible Alpha

### 10. Response-model behavior does not match its documentation

`QueryResponse` says `sql` and `row_count` are `None` on error paths. In practice:

- `sql` is returned for unsafe SQL, database errors, and explanation errors when generation succeeded.
- `row_count` is usually `0` on early error paths because `PipelineResult.results` defaults to an empty list.
- `is_safe` is hidden unless the final status is `OK`, even when validation succeeded before a later failure.

Choose and document one contract, then test it at the API boundary.

### 11. Application and package versions disagree

- `pyproject.toml` declares version `0.1.0`.
- FastAPI declares version `1.0.0`.

Use one source of truth and expose build/version metadata in health and logs.

### 12. The API console-script entry point is not a valid server launcher

`pyproject.toml` defines:

```toml
sql-assistant-api = "sql_assistant.api:app"
```

A console script expects a callable command function, not an ASGI application object requiring `scope`, `receive`, and `send`. Provide a real launcher or remove the entry point and document `uvicorn` as the supported command.

### 13. Streamlit module has import-time side effects

`app.py` calls `main_page()` at module import time. The console entry point imports the module before invoking `main()`, which can execute Streamlit UI code outside the intended runner before spawning Streamlit.

Move rendering behind an explicit entry function and test the packaged command.

### 14. Health check does not verify LLM service health

The health endpoint only constructs an OpenAI client when an API key exists. It does not verify credentials, network access, model availability, or provider health.

Split health into:

- **liveness:** process is running,
- **readiness:** required configuration, Oracle connectivity, schema availability, and optional provider probe,
- **dependency detail:** protected operational endpoint, not public diagnostics.

### 15. Semantic schema is reloaded on every uncached question

The semantic layer is queried for every pipeline execution. There is no schema-version token, bounded metadata cache, or explicit invalidation.

Add a versioned semantic-schema snapshot with controlled refresh and include its version in audit records and answer metadata.

### 16. LLM configuration is hard-coded and incomplete

The model name is fixed in code. Calls do not set an explicit request timeout, output-token limit, provider request identifier, or application prompt version.

Make model/provider settings explicit and versioned. Record them with each request and evaluation result.

### 17. Retry behavior is incomplete

- `_is_retryable()` is unused.
- Retry logs report the delay before the failed attempt rather than the wait before the next attempt.
- There is no jitter or `Retry-After` handling.
- A blocking `time.sleep()` occupies a worker thread.

Adopt a tested retry policy with bounded total duration and provider guidance.

### 18. Question input has no maximum size or abuse controls

Pydantic enforces only a minimum length of one character. There is no request-size cap, rate limit, quota, concurrency policy, or per-user budget.

### 19. Oracle connection-pool lifecycle is unmanaged

The global pool is lazily created but never explicitly closed during application shutdown. Pool sizing and acquisition behavior are fixed in code and not exposed as settings.

Initialize and close the pool through application lifespan hooks. Add acquisition timeout, health metrics, and environment-specific sizing.

### 20. No deterministic result contract for Oracle data types

Raw Oracle values may include `Decimal`, dates, timestamps, LOBs, bytes, or other objects that are not consistently JSON serializable or suitable for prompt interpolation and CSV output.

Create a central typed serialization layer with size limits and explicit handling for LOBs and binary data.

### 21. Empty-result behavior wastes an LLM call

An empty result set still goes through explanation generation. Return a deterministic empty-result explanation and avoid provider cost and latency.

### 22. CLI error handling is not automation-friendly

The CLI catches broad exceptions, prints an error, and does not consistently return a non-zero exit status. `--question` and `--file` are not mutually exclusive. Batch output has no machine-readable run manifest or aggregate summary.

### 23. Dependency and build reproducibility are weak

Runtime dependencies are unbounded. There is no lock file, supported-version matrix, build verification, or supply-chain scan.

Set tested version ranges and add reproducible development/release environments.

### 24. Test coverage stops at mocked component boundaries

The unit tests cover useful pipeline paths, prompt formatting, caching, and validation, but alpha needs:

- API contract tests,
- Streamlit/API integration tests,
- Oracle integration tests against a disposable database,
- SQL-parser authorization tests,
- concurrency and timeout tests,
- prompt-injection and data-exfiltration tests,
- migration/schema-version tests,
- provider contract tests with recorded or controlled responses.

### 25. No continuous integration or release gate is documented

Add CI for supported Python versions, linting, typing, unit tests, integration tests, dependency scanning, and package build/install verification. Protect releases with a measurable alpha acceptance suite.

---

## P2 — Post-Alpha Hardening

### 26. Pipeline concerns are tightly coupled

The pipeline directly imports global implementations for cache, database, LLM, prompt, validator, and explanation behavior. Introduce explicit interfaces/dependency injection so policies can be tested and swapped without pervasive patching.

### 27. Logging configuration mutates the root logger

The application adds handlers to the root logger and has no rotation or external logging adapter. Move to application-owned logger configuration suitable for multi-worker deployment.

### 28. Validator normalization is regex-based and can alter literals

Comment stripping does not understand quoted strings, and a trailing semicolon is removed before validation even though the README describes semicolons as rejected. Replace regex normalization with parser-aware handling and align documentation with actual policy.

### 29. No product-level audit record

Logs are not a durable audit model. Add a structured request record containing identity, policy version, schema version, model/prompt version, generated SQL hash, authorization decision, execution metrics, result classification, and final disposition—without storing protected data by default.

### 30. No feedback or correction loop

A production-bound assistant needs a way to mark answers correct, incorrect, unsafe, incomplete, or misleading and feed reviewed cases into the evaluation corpus.

---

## Recommended Resolution Order

1. Disable or isolate cache; add authentication and least-privilege database access.
2. Replace the regex gate with parsed semantic authorization.
3. Add execution, row, byte, concurrency, and timeout limits.
4. Stop error and log leakage; establish stable public error contracts.
5. Fix API/UI status handling and response-model inconsistencies.
6. Add versioned schema/prompt/model metadata and full request correlation.
7. Build the evaluation corpus and Oracle integration suite.
8. Package and deploy a controlled single-organization alpha.

This ordering intentionally prioritizes **trust before UI expansion**.