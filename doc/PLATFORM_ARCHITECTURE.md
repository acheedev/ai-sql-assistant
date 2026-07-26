# AI SQL Assistant — Platform Architecture

This document defines the target portability architecture for AI SQL Assistant.

The product starts with two database platforms—Oracle and PostgreSQL—and a provider-neutral LLM layer. The purpose of the architecture is not to hide meaningful differences. It is to isolate them behind explicit contracts so the security, API, semantic, audit, and evaluation models remain stable.

## Design Goal

Core pipeline code should be able to express the workflow without importing a database driver or an LLM vendor SDK:

```text
authenticated request
  -> resolve database deployment + authorization policy
  -> load normalized semantic contract
  -> select approved LLM provider/model
  -> generate dialect-aware SQL
  -> parse and deterministically authorize SQL
  -> execute through bounded database adapter
  -> normalize rows and evidence
  -> optionally explain through approved provider/model
  -> return traceable response + audit event
```

The application must not become a collection of statements such as:

```python
if database == "oracle": ...
elif database == "postgres": ...

if provider == "openai": ...
elif provider == "anthropic": ...
```

Those decisions belong at adapter construction and capability negotiation boundaries, not throughout the business pipeline.

---

## 1. Database Portability Contract

The recommended conceptual interface is `DatabaseAdapter`. The exact Python shape may evolve, but its responsibilities should remain explicit.

```python
class DatabaseAdapter(Protocol):
    platform: DatabasePlatform
    capabilities: DatabaseCapabilities

    def start(self) -> None: ...
    def close(self) -> None: ...

    def load_semantic_schema(self) -> SemanticSchema: ...
    def health(self) -> DatabaseHealth: ...

    def parse_sql(self, sql: str) -> ParsedQuery: ...
    def authorize_sql(
        self,
        query: ParsedQuery,
        policy: QueryPolicy,
        semantic_schema: SemanticSchema,
    ) -> AuthorizationDecision: ...

    def execute(
        self,
        query: AuthorizedQuery,
        limits: ExecutionLimits,
        context: RequestContext,
    ) -> QueryResult: ...
```

### Adapter responsibilities

Each database adapter owns:

- driver and connection-pool lifecycle,
- platform-specific connection configuration,
- semantic metadata persistence and loading,
- SQL dialect and parser integration,
- identifier resolution,
- platform-specific forbidden or allowlisted constructs,
- statement timeout and cancellation behavior,
- fetch batching and byte/row limits,
- session/application tagging where available,
- result-type conversion into the normalized result model,
- health/readiness information,
- safe classification of database exceptions,
- platform-specific audit evidence.

### Core responsibilities that must not move into adapters

The core application owns:

- authenticated request identity,
- product-level authorization context,
- normalized semantic model,
- response and public error contracts,
- cache policy,
- provider selection policy,
- audit event schema,
- evaluation orchestration,
- UI and API behavior.

Adapters implement database mechanics; they do not decide who the user is or whether an organization permits a provider.

---

## 2. Shared Semantic Contract

Oracle and PostgreSQL should expose the same logical semantic concepts even when their physical DDL differs.

The normalized model should include:

- semantic object identifier,
- physical schema and object name,
- database platform,
- business name and description,
- approved columns,
- identifiers and join relationships,
- human-readable/default-select columns,
- filterable and aggregate-safe columns,
- aliases and business vocabulary,
- approved examples,
- sensitivity classification,
- authorization tags,
- semantic version.

The LLM receives a rendered form of this normalized contract. The SQL authorization layer receives the structured form.

### Dialect-specific semantic data

Some metadata will necessarily differ:

- Oracle and PostgreSQL physical data types,
- function names and date arithmetic,
- pagination syntax,
- quoting and case behavior,
- schemas and ownership rules,
- JSON, array, interval, LOB, and large-object capabilities,
- platform-specific approved functions.

Those differences should be represented as explicit dialect metadata or adapter capabilities—not hidden inside business descriptions.

---

## 3. SQL Generation Strategy

The initial implementation may continue to ask a model for SQL, but the prompt must be assembled from:

- a provider-neutral task contract,
- a database-dialect rule set,
- the normalized semantic schema,
- reviewed dialect-specific examples,
- explicit output constraints.

The prompt builder should accept a database platform rather than containing unconditional Oracle rules.

```python
build_sql_request(
    question=question,
    semantic_schema=schema,
    dialect=adapter.platform,
    prompt_version=prompt_version,
)
```

Longer-term, the safer target is a constrained intermediate query representation that application code compiles into platform SQL. That would reduce free-form dialect generation and make cross-platform equivalence easier to test. It is not required for the first alpha, but the architecture should not block it.

---

## 4. Deterministic Authorization Across Dialects

A shared authorization policy should describe product intent:

- allowed semantic objects and columns,
- allowed query shape,
- allowed joins and aggregates,
- allowed function categories,
- maximum complexity,
- prohibited remote-data and callable behavior,
- row and resource requirements.

Each adapter resolves that policy against its dialect and catalog rules.

### Oracle-specific examples

- packages and callable functions,
- `DBA_*`, `V_$`/`V$`, and `SYS` access,
- database links,
- hints and session-affecting behavior,
- Oracle-specific locking and hierarchical syntax.

### PostgreSQL-specific examples

- catalog and statistics surfaces,
- functions with volatile or privileged behavior,
- foreign data wrappers and foreign servers,
- extensions and server-side execution capabilities,
- role/session changes,
- row-level-security implications,
- locking clauses and platform-specific syntax.

Authorization tests must include SQL that is semantically equivalent but syntactically different across the two platforms.

---

## 5. Normalized Query Results

Database adapters should return a stable result envelope:

```python
@dataclass(frozen=True)
class QueryResult:
    columns: tuple[ResultColumn, ...]
    rows: list[dict[str, JsonValue]]
    row_count: int
    truncated: bool
    bytes_returned: int
    latency_ms: int
    database_platform: str
    database_version: str | None
    adapter_version: str
    warnings: tuple[str, ...]
```

Serialization must explicitly handle platform differences such as:

- Oracle `NUMBER` and PostgreSQL `numeric`,
- timestamps and time zones,
- intervals,
- UUID values,
- JSON/JSONB,
- arrays,
- binary data,
- CLOB/BLOB and PostgreSQL large objects,
- unsupported driver-native objects.

No provider adapter should receive raw driver objects.

---

## 6. LLM Provider Contract

The recommended conceptual interface is `LLMProvider`.

```python
class LLMProvider(Protocol):
    provider: ProviderName
    capabilities: ProviderCapabilities

    def generate_sql(self, request: SQLGenerationRequest) -> LLMResponse: ...
    def generate_explanation(self, request: ExplanationRequest) -> LLMResponse: ...
    def health(self) -> ProviderHealth: ...
```

### Normalized request fields

- task type,
- system/developer instructions,
- user content,
- database dialect,
- semantic-schema version,
- prompt version,
- maximum output tokens,
- timeout,
- required output format,
- data classification,
- request identifier.

### Normalized response fields

```python
@dataclass(frozen=True)
class LLMResponse:
    content: str
    provider: str
    model: str
    provider_request_id: str | None
    input_tokens: int | None
    output_tokens: int | None
    latency_ms: int
    retries: int
    finish_reason: str | None
    estimated_cost: Decimal | None
    adapter_version: str
```

### Normalized failures

Provider SDK exceptions must map into stable categories:

- authentication/configuration failure,
- invalid request,
- rate limit,
- timeout,
- network failure,
- transient provider failure,
- content/safety refusal,
- malformed or empty output,
- unsupported capability,
- internal adapter failure.

The public API should not expose raw vendor exceptions.

---

## 7. Initial Provider Strategy

Initial direct adapters:

- OpenAI,
- Anthropic,
- Google Gemini.

The architecture should also permit enterprise-hosted adapters without pipeline changes:

- Azure OpenAI,
- Amazon Bedrock,
- Google Vertex AI,
- approved OpenAI-compatible gateways or self-hosted endpoints.

These routes are not assumed equivalent. A deployment route is a security and governance attribute alongside provider and model.

### Separate model choices by task

SQL generation and explanation have different requirements. Configuration should permit:

```text
SQL generation: high-accuracy model
Explanation: lower-cost approved model or deterministic summarizer
```

This creates an immediate cost-control lever without weakening deterministic SQL authorization.

### Routing modes

Supported policy concepts should include:

- fixed provider/model,
- approved ordered fallback,
- no fallback,
- task-specific provider/model,
- maximum token budget,
- maximum configured estimated cost,
- provider allowlist by data classification.

Avoid automatic "cheapest model" routing until evaluation proves which models satisfy the task's quality and safety threshold. Cost optimization should select among qualified models, not substitute for qualification.

---

## 8. Provider Privacy and Data Boundaries

SQL generation may transmit:

- the user's question,
- semantic object and column metadata,
- example questions and SQL.

Explanation generation may additionally transmit sampled result data.

Those are separate data-governance events. A deployment may allow external SQL generation but prohibit sending result rows to an external provider. The architecture must therefore permit:

- explanation disabled,
- deterministic explanations,
- a different approved provider for explanation,
- local/self-hosted explanation,
- field-level redaction before explanation,
- aggregate-only explanation inputs.

No fallback may broaden the data boundary silently.

---

## 9. Configuration Model

Configuration should select adapters explicitly:

```yaml
database:
  platform: postgres
  deployment_id: finance_readonly
  adapter: postgres

llm:
  sql_generation:
    provider: anthropic
    model: configured-model-id
  explanation:
    provider: openai
    model: configured-model-id
  fallback_policy: none
```

Secrets belong in environment variables or a secret manager, not in the ordinary configuration file.

Model identifiers and cost rates must remain configuration data because vendor offerings and prices change independently of releases.

---

## 10. Caching Implications

A cache key cannot be only the normalized question.

At minimum, it must include:

- authenticated principal or authorization scope,
- database deployment identifier,
- database platform,
- semantic-schema version,
- authorization-policy version,
- provider and model,
- provider-adapter version,
- prompt version,
- request options,
- normalized question.

For alpha, disabling result caching remains safer until this full isolation model and retention policy are implemented.

---

## 11. Health and Readiness

`/health/live` verifies only that the application process can respond.

`/health/ready` verifies the active deployment configuration:

- selected database adapter initialized,
- connection pool can acquire a connection,
- semantic schema is loadable,
- required policy is available,
- selected provider configuration is valid,
- required internal components are initialized.

Readiness should not call every supported database or provider. It tests the configured deployment combination. It should not perform a billable LLM generation on every health probe.

Detailed dependency diagnostics should be protected.

---

## 12. Evaluation Matrix

Portability is a test result, not an interface declaration.

The evaluation system should track:

```text
database platform
× database version
× provider/deployment route
× model
× prompt version
× semantic-schema version
× authorization-policy version
```

Not every Cartesian combination must be supported. The release must publish a compatibility matrix declaring combinations as:

- supported,
- experimental,
- known incompatible,
- not tested.

### Cross-dialect evaluation

Equivalent Oracle and PostgreSQL fixtures should test:

- equivalent business questions,
- equivalent result sets,
- correct dialect syntax,
- authorization behavior,
- timeout and truncation behavior,
- normalized serialization.

### Cross-provider evaluation

Each provider/model should test:

- SQL correctness,
- refusal/unanswerable behavior,
- hostile prompt behavior,
- malformed output rate,
- explanation faithfulness,
- latency,
- token usage,
- configurable estimated cost.

---

## 13. Implementation Sequence

1. Extract the current Oracle code into an Oracle database adapter without changing behavior.
2. Extract the current OpenAI code into an OpenAI provider adapter without changing behavior.
3. Move prompt assembly to dialect-neutral inputs plus dialect rule sets.
4. Move provider SDK response/error handling entirely behind the provider contract.
5. Implement normalized result serialization and audit provenance.
6. Implement PostgreSQL semantic metadata, authorization, execution, and integration tests.
7. Add Anthropic and Google Gemini adapters with provider-contract tests.
8. Build the database × provider evaluation matrix.
9. Add policy-controlled task routing and cost visibility.
10. Add enterprise-hosted or self-hosted adapters according to customer demand.

This sequence avoids attempting a PostgreSQL port and multiple provider integrations while the existing Oracle/OpenAI assumptions are still embedded throughout the core.

---

## Decision Summary

- Oracle and PostgreSQL are first-class initial database platforms.
- OpenAI, Anthropic, and Google Gemini are the initial direct-provider targets.
- The core pipeline is database-driver-neutral and provider-SDK-neutral.
- Security remains database-enforced and provider-policy-enforced; adapters do not weaken either boundary.
- SQL generation, authorization, execution, explanation, caching, audit, and evaluation carry explicit database/provider provenance.
- A model is eligible for cost-based routing only after it passes the required quality and safety gates.

The product should be able to change databases or models without rewriting its identity, security, API, semantic, or audit foundations.