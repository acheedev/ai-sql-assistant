# AI SQL Assistant

AI SQL Assistant turns ordinary business questions into safe Oracle SQL, runs the query, and explains the answer in plain English.

It is built around a deliberate idea: the model should not wander through raw database DDL. Instead, it sees a curated semantic layer of business-friendly views, column meanings, aliases, and examples. The result is a small but complete natural-language analytics system with a FastAPI API, a Streamlit UI, a CLI batch runner, deterministic SQL validation, structured logging, and tests that exercise every pipeline outcome without touching a real database or LLM.

## Why It Exists

Business users should be able to ask:

```text
Show top 5 customers by order amount
Show what has shipped but not been paid
Show low stock items by location
```

and get back:

- the generated Oracle SQL,
- a safety decision,
- result rows from Oracle,
- a short business-readable explanation,
- a `request_id` that ties the response to logs.

This repo demonstrates how to connect an LLM to enterprise data without handing it the whole database and hoping for the best.

## The Flow

```text
User question
  -> prompt.py       builds a SQL-generation prompt from the semantic layer
  -> llm.py          calls GPT-4.1-mini at temperature 0
  -> validator.py    allows only SELECT/WITH and rejects risky statements
  -> db.py           executes against Oracle through a connection pool
  -> explain.py      asks the LLM for a concise business summary
  -> PipelineResult  returns status, SQL, safety, rows, explanation, request_id
```

The SQL generator and explanation generator both use OpenAI. The validator does not. It is deterministic Python code, which is the important safety boundary in the application.

## Architecture At A Glance

| Layer | Files | Purpose |
|---|---|---|
| API | `src/sql_assistant/api.py` | FastAPI app with `POST /query` and `GET /health`. |
| UI | `src/sql_assistant/app.py` | Streamlit interface that calls the API and renders status, SQL, rows, and explanations. |
| CLI | `src/sql_assistant/main.py` | Single-question mode and batch mode for scripted test runs. |
| Pipeline | `src/sql_assistant/pipeline.py` | Orchestrates schema loading, LLM SQL generation, validation, execution, explanation, caching, and status mapping. |
| Prompting | `src/sql_assistant/prompt.py` | Formats semantic schema and few-shot examples into a constrained Oracle SQL prompt. |
| LLM Client | `src/sql_assistant/llm.py` | OpenAI wrapper with retry handling for rate limits, connection errors, and transient 5xx failures. |
| Database | `src/sql_assistant/db.py` | Oracle connection pool, query execution, and semantic schema loading. |
| Safety | `src/sql_assistant/validator.py` | Regex-based SQL gate: SELECT/WITH only, no semicolons, no DML/DDL/execute keywords. |
| Explanation | `src/sql_assistant/explain.py` | Summarizes result samples in 2-4 business-focused bullets. |
| Cache | `src/sql_assistant/cache.py` | Thread-safe TTL cache for successful normalized questions. |
| Logging | `src/sql_assistant/logging_utils.py` | Human-readable console logs plus JSON file logs. |
| Models | `src/sql_assistant/models.py` | Pydantic request/response models and pipeline status enum. |
| Settings | `config/settings.py` | Environment-driven configuration via Pydantic settings. |
| Oracle DDL/Seed | `sql/`, `scripts/` | Base tables, views, semantic metadata tables, demo seed data, and semantic reseeding helper. |
| Tests | `tests/` | Unit tests for prompt structure, validation, pipeline outcomes, and cache behavior. |

## Semantic Layer

The model never sees the raw `t_` base-table DDL. It sees only metadata read from four semantic tables:

| Table | Role |
|---|---|
| `t_semantic_object` | Registers AI-visible views and ranks preferred objects. |
| `t_semantic_column` | Describes business names and flags columns as identifiers, human-readable fields, defaults, or filters. |
| `t_semantic_object_alias` | Maps user language such as "orders", "customers", or "stock" to the right view. |
| `t_semantic_example_question` | Stores few-shot question-to-SQL examples used to ground generation. |

## Safety Model

Generated SQL must pass `validator.py` before execution.

The validator:

1. strips SQL comments,
2. requires the statement to start with `SELECT` or `WITH`,
3. rejects semicolons to prevent multiple statements,
4. rejects forbidden keywords:

```text
INSERT UPDATE DELETE MERGE DROP ALTER TRUNCATE CREATE
GRANT REVOKE EXECUTE EXEC CALL BEGIN
```

The prompt also tells the model to use only listed objects and columns, prefer human-readable fields, use Oracle syntax such as `FETCH FIRST N ROWS ONLY`, and return exactly `CANNOT_ANSWER` when the semantic schema cannot answer the question.

## Pipeline Statuses

| Status | Meaning | HTTP |
|---|---|---|
| `OK` | SQL generated, validated, executed, and explained. | 200 |
| `QUESTION_ERROR` | The LLM returned `CANNOT_ANSWER`. | 422 |
| `CANCELLED` | The LLM returned empty SQL after normalization. | 422 |
| `UNSAFE_SQL` | The validator rejected the generated SQL. | 422 |
| `DB_ERROR` | Oracle schema loading or query execution failed. | 502 |
| `LLM_ERROR` | SQL-generation LLM call failed. | 502 |
| `EXPLANATION_ERROR` | SQL ran, but explanation generation failed. | 502 |

Every response has a UUID `request_id`. Use it to correlate API responses, CLI output, and JSON logs.

## Setup

### Requirements

- Python 3.11+
- Oracle database reachable from this machine
- OpenAI API key

### Install

```powershell
python -m venv .venv
.venv\Scripts\activate
pip install -e .[dev]
```

For runtime-only installation:

```powershell
pip install -e .
```

### Configure

Create `.env` in the repo root:

```env
OPENAI_API_KEY=sk-...
DB_USER=your_db_user
DB_PASSWORD=your_db_password
DB_DSN=your_db_host:1521/your_service_name
LOG_LEVEL=INFO
LOG_FILE=logs/pipeline.log
CACHE_TTL_SECONDS=300
CACHE_MAX_SIZE=128
```

Set `CACHE_TTL_SECONDS=0` to disable response caching.

## Database Setup

The `sql/` directory contains the Oracle objects used by the demo domain.

From an Oracle client that supports `@@` scripts, run:

```sql
@@sql/build_obj.sql
@@sql/build_seed.sql
```

`build_obj.sql` creates admin helpers, base tables, semantic tables, and views. `build_seed.sql` loads OLTP demo data and semantic metadata.

To reseed only the semantic layer from Python:

```powershell
python scripts\seed_semantic_layer.py
python scripts\seed_semantic_layer.py --dry-run
python scripts\seed_semantic_layer.py --reset
```

## Run The API

```powershell
uvicorn sql_assistant.api:app --reload
```

Open Swagger UI:

```text
http://localhost:8000/docs
```

Ask a question:

```bash
curl -X POST "http://localhost:8000/query" \
  -H "Content-Type: application/json" \
  -d '{"question": "show me open orders"}'
```

Include raw result rows:

```bash
curl -X POST "http://localhost:8000/query?include_results=true" \
  -H "Content-Type: application/json" \
  -d '{"question": "show me low stock items by location"}'
```

Example response:

```json
{
  "request_id": "a1b2c3d4-1111-2222-3333-abcdefabcdef",
  "status": "OK",
  "sql": "SELECT customer_name, status_code FROM v_order_header WHERE status_code = 'OPEN'",
  "is_safe": true,
  "row_count": 8,
  "explanation": "- There are 8 open orders awaiting fulfillment.",
  "message": null,
  "results": null
}
```

Health check:

```bash
curl http://localhost:8000/health
```

The health endpoint verifies Oracle connectivity and LLM client configuration. It returns redacted errors and never exposes connection strings, credentials, or Oracle error details in the response body.

## Run The Streamlit UI

Start the API first, then run:

```powershell
streamlit run src\sql_assistant\app.py
```

The UI defaults to:

```text
http://localhost:8000
```

To point it at a different API:

```powershell
$env:SQL_ASSISTANT_API_URL="http://localhost:9000"
streamlit run src\sql_assistant\app.py
```

## Run The CLI

Single question:

```powershell
python -m sql_assistant.main --question "Show overdue invoices"
```

Batch file:

```powershell
python -m sql_assistant.main -f tests\test_questions.txt -o tests\test_results
```

Batch mode creates one folder per question:

```text
tests/test_results/test_NNN_<slug>/
  summary.log
  data.csv
```

That makes it useful for demos, regression checks, and before/after prompt tuning.

## Good Demo Questions

These are already represented in `tests/test_questions.txt`:

```text
Show all fulfilled orders
Show overdue invoices
Show low stock items by location
Show what has shipped but not been paid
Show orders with their shipment and invoice status
Show customers with their most recent order and payment status
Show total revenue by customer
Show total paid vs outstanding invoices by customer
Show customers with suspended accounts
```

## Testing

```powershell
pytest
```

The suite is designed to run without a real Oracle database or real OpenAI calls. Database and LLM boundaries are mocked where needed.

Current coverage areas:

- SQL validator behavior and normalization
- prompt formatting and schema/example inclusion
- all seven pipeline result statuses
- request ID uniqueness and error containment
- cache TTL, cache disabling, cache hits, eviction, and thread safety

## Logging And Observability

`configure_logging()` is the single logging setup point and is called by both the API and CLI startup paths.

Logs go to:

- stdout in a compact human-readable format,
- `logs/pipeline.log` as structured JSON.

Important logged events include:

- `pipeline_start`
- `prompt_built`
- `schema_loaded`
- `sql_generated`
- `validation_pass` / `validation_fail`
- `db_execute_complete`
- `explanation_complete`
- `cache_hit`
- `pipeline_complete`

Use `request_id` as the thread that ties everything together.

## Design Constraints

These are intentional:

- The LLM never sees raw `t_` table DDL.
- The semantic layer is the only schema surface exposed to the model.
- `validator.py` stays deterministic and contains no LLM calls.
- The LLM temperature is fixed at `0`.
- SQL must be Oracle-compatible.
- API error responses must never leak credentials, connection strings, or raw Oracle diagnostics.
- Logging configuration stays centralized in `configure_logging()`.

## Project Structure

```text
config/
  settings.py
scripts/
  seed_semantic_layer.py
sql/
  build_obj.sql
  build_seed.sql
  ddl/
    basetables/
    semantic/
    views/
    procedures/
  seed/
src/
  sql_assistant/
    api.py
    app.py
    cache.py
    db.py
    explain.py
    llm.py
    logging_utils.py
    main.py
    models.py
    pipeline.py
    prompt.py
    validator.py
tests/
  test_cache.py
  test_pipeline.py
  test_prompt.py
  test_validator.py
  test_questions.txt
```
