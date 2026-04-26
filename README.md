# AI SQL Assistant

Translates natural language questions into Oracle SQL, executes them, and returns a plain-English explanation of the results. Exposes a FastAPI HTTP interface and a CLI batch runner.

---

## How It Works

```
User question
  → prompt.py      build SQL generation prompt from semantic schema + few-shot examples
  → LLM            GPT-4.1-mini generates Oracle SQL (or CANNOT_ANSWER)
  → validator.py   deterministic regex safety check — SELECT/WITH only, no DML/DDL
  → db.py          execute on Oracle, return list[dict]
  → explain.py     LLM summarizes results as 2–4 business-focused bullet points
  → PipelineResult(status, request_id, sql, is_safe, results, explanation)
```

The LLM never sees raw table DDL. It works exclusively from a semantic layer — a set of views with human-readable metadata describing what each object and column means.

---

## Stack

| Component | Choice |
|-----------|--------|
| LLM | OpenAI GPT-4.1-mini (temperature=0) |
| Database | Oracle via `oracledb` connection pool (min 1 / max 5) |
| API | FastAPI + uvicorn |
| UI | Streamlit (Sprint 2) |
| Config | Pydantic `BaseSettings` — all config from environment |
| Logging | Structured JSON (prod) + human-readable (dev) |

---

## Prerequisites

- Python 3.13+
- Oracle database (with semantic layer views pre-seeded — see [Semantic Layer](#semantic-layer))
- OpenAI API key

---

## Setup

```powershell
# Create and activate virtual environment
python -m venv .venv
.venv\Scripts\activate

# Install dependencies
pip install -e .
```

Create a `.env` file in the project root:

```env
OPENAI_API_KEY=sk-...
DB_USER=your_db_user
DB_PASSWORD=your_db_password
DB_DSN=your_db_host:1521/your_service_name
```

---

## Running

### API (FastAPI)

```powershell
uvicorn sql_assistant.api:app --reload
```

Swagger UI: [http://localhost:8000/docs](http://localhost:8000/docs)

#### POST /query

```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{"question": "show me open orders"}'
```

Response (200 OK):
```json
{
  "request_id": "a1b2c3d4-...",
  "status": "OK",
  "sql": "SELECT customer_name, status FROM v_order_detail WHERE status = 'OPEN'",
  "is_safe": true,
  "row_count": 8,
  "explanation": "There are 8 open orders...",
  "message": null,
  "results": null
}
```

Add `?include_results=true` to get the full result rows in the response body.

#### GET /health

```bash
curl http://localhost:8000/health
```

Returns 200 if both DB and LLM are reachable; 503 with a redacted error if not. Never exposes connection strings or ORA error codes in the response body.

### CLI

```powershell
# Single question
python -m sql_assistant.main --question "Show overdue invoices"

# Batch from file
python -m sql_assistant.main -f tests/test_questions.txt -o tests/test_results
```

Batch output: `tests/test_results/test_NNN_<slug>/summary.log` + `data.csv`

---

## Project Structure

```
src/
  sql_assistant/
    api.py             FastAPI app — POST /query, GET /health
    main.py            CLI entry point — single question or batch file mode
    pipeline.py        Pipeline orchestration — run() returns PipelineResult
    prompt.py          Builds SQL generation prompt from semantic schema + few-shot examples
    db.py              Oracle connection pool, run_query(), get_semantic_schema()
    llm.py             Thin OpenAI wrapper — ask_llm(prompt)
    validator.py       Regex SQL safety check — is_safe_sql(), normalize_sql()
    explain.py         Builds result-explanation prompt (caps at 20 sample rows)
    logging_utils.py   configure_logging() — shared by CLI and API startup
    llm_exceptions.py  LLMPipelineError, LLMFailed, LLMEmptyOutput
config/
  settings.py          Pydantic BaseSettings
tests/
  conftest.py          Shared fixtures (minimal schema dict)
  test_validator.py    is_safe_sql() and normalize_sql() — 22 cases, no mocks
  test_pipeline.py     All 7 PipelineResult statuses — Oracle and LLM calls mocked
  test_prompt.py       build_prompt() structural assertions — 12 cases
```

---

## Pipeline Result Statuses

| Status | Meaning | HTTP |
|--------|---------|------|
| `OK` | Clean result | 200 |
| `QUESTION_ERROR` | LLM returned `CANNOT_ANSWER` — schema can't answer the question | 422 |
| `CANCELLED` | LLM returned empty or blank SQL | 422 |
| `UNSAFE_SQL` | Validator rejected the generated SQL | 422 |
| `DB_ERROR` | Oracle execution failed | 502 |
| `LLM_ERROR` | OpenAI call failed | 502 |
| `EXPLANATION_ERROR` | SQL ran fine; explanation LLM call failed | 502 |

Every result carries a `request_id` (UUID) that appears on every log event for that request — use it to correlate API responses to log lines.

---

## Semantic Layer

The LLM's only schema surface is four metadata tables:

| Table | Purpose |
|-------|---------|
| `t_semantic_object` | Registers views; `include_in_ai`, `preferred_for_ai` flags |
| `t_semantic_column` | Per-column metadata: `is_identifier`, `is_human_readable`, `is_default_select`, `is_filterable` |
| `t_semantic_object_alias` | Natural-language synonyms for objects |
| `t_semantic_example_question` | Few-shot SQL examples for grounding |

The database has 12 base tables (`t_` prefix) — never exposed to the LLM — and 15 views (`v_` prefix), including three denormalized business views the LLM prefers:

- `v_order_detail`
- `v_customer_order_summary`
- `v_inventory_status`

---

## SQL Safety Rules

`validator.py` is deterministic regex — no LLM calls, ever.

1. Statement must start with `SELECT` or `WITH` (after comment stripping)
2. Rejects DML/DDL: `INSERT UPDATE DELETE MERGE DROP ALTER TRUNCATE CREATE GRANT REVOKE EXECUTE EXEC CALL BEGIN`
3. Rejects multiple statements (semicolons)

---

## SQL Generation Rules (enforced via prompt)

- Oracle syntax — `FETCH FIRST N ROWS ONLY`, not `LIMIT`
- No trailing semicolons
- Prefer `[PREFERRED]` views (purpose-built for AI)
- Prefer `(human-readable)` columns in SELECT over raw IDs
- Use `(identifier)` columns as join keys
- Use `(filterable)` columns in WHERE clauses
- Resolve user terms against object aliases before querying
- Never invent status code values in WHERE clauses
- If the question can't be answered from the schema, return exactly: `CANNOT_ANSWER`

---

## Tests

```powershell
pytest
```

46 tests across 3 modules. Zero skips required. No real DB or LLM calls anywhere in the suite.

```
tests/test_validator.py   22 cases — safe/unsafe SQL, normalize
tests/test_pipeline.py    12 cases — all 7 statuses, request_id uniqueness, error containment
tests/test_prompt.py      12 cases — structural prompt assertions
```

---

## Design Constraints

These are intentional and non-negotiable:

- The LLM never sees raw `t_` table DDL — semantic layer only
- `validator.py` stays deterministic regex — no LLM calls inside it
- LLM temperature stays at 0 (set in `llm.py`)
- No credentials in any API response under any circumstances
- `configure_logging()` is the only place logging is configured — called once at startup by both CLI and API

---

## Environment Variables

| Variable | Purpose |
|----------|---------|
| `OPENAI_API_KEY` | OpenAI API key |
| `DB_USER` | Oracle username |
| `DB_PASSWORD` | Oracle password |
| `DB_DSN` | Oracle DSN (`host:port/service`) |
