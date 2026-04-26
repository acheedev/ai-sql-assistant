
  ---
  # AI SQL Assistant — Codebase Reference

  ## What It Is
  A Python NL-to-SQL pipeline that takes natural language questions, generates Oracle SQL via an LLM, validates and executes the SQL, then returns a plain-English explanation of the results.

  ## Stack
  - **LLM**: OpenAI GPT-4.1-mini (temperature=0, via `llm.py`)
  - **Database**: Oracle via `oracledb` connection pool (min 1 / max 5)
  - **Entry point**: `src/main.py` — single question or batch file mode

  ## Pipeline Flow
  User question
    → prompt.py     : inject semantic schema + few-shot examples → LLM generates SQL
    → validator.py  : deterministic regex safety check (SELECT/WITH only; no DML/DDL)
    → db.py         : execute on Oracle, return list[dict]
    → explain.py    : LLM summarizes results as 2–4 business-focused bullet points
    → PipelineResult(status, sql, is_safe, results, explanation)

  ## PipelineResult Statuses
  `OK` | `DB_ERROR` | `QUESTION_ERROR` | `LLM_ERROR` | `CANCELLED` | `UNSAFE_SQL` | `EXPLANATION_ERROR`

  ## Source Files (`src/`)
  | File | Role |
  |------|------|
  | `main.py` | Entry point, argument parsing, batch loop, pipeline orchestration |
  | `prompt.py` | Builds SQL generation prompt from semantic schema + few-shot examples |
  | `db.py` | Oracle connection pool, `run_query()`, `get_semantic_schema()` |
  | `llm.py` | Thin OpenAI wrapper — single `ask_llm(prompt)` function |
  | `validator.py` | Regex SQL safety check: `is_safe_sql()` + `normalize_sql()` |
  | `explain.py` | Builds result-explanation prompt (caps at 20 sample rows) |
  | `llm_exceptions.py` | Exception hierarchy: `LLMPipelineError`, `LLMFailed`, `LLMEmptyOutput` |
  | `config.json` | Sample questions, mode flags |

  ## Database Schema
  - **12 base tables** (`t_` prefix) — never exposed to the LLM
  - **15 views** (`v_` prefix): 12 one-to-one wrappers + 3 denormalized business views:
    - `v_order_detail`
    - `v_customer_order_summary`
    - `v_inventory_status`

  ## Semantic Layer (4 tables — the LLM's only schema surface)
  | Table | Purpose |
  |-------|---------|
  | `t_semantic_object` | Registers views; `include_in_ai`, `preferred_for_ai` flags |
  | `t_semantic_column` | Per-column metadata: `is_identifier`, `is_human_readable`, `is_default_select`, `is_filterable` |
  | `t_semantic_object_alias` | Natural-language synonyms for objects |
  | `t_semantic_example_question` | Few-shot SQL examples for grounding |

  `get_semantic_schema()` in `db.py` reads these 4 tables and assembles a structured dict that `prompt.py` formats into the LLM prompt.

  ## SQL Safety Validator (deterministic, no AI)
  Strips comments first, then:
  1. Requires statement starts with `SELECT` or `WITH`
  2. Rejects DML/DDL keywords: `INSERT UPDATE DELETE MERGE DROP ALTER TRUNCATE CREATE GRANT REVOKE EXECUTE EXEC CALL BEGIN`
  3. Rejects multiple statements (semicolons)

  **Design constraint**: must remain regex-only. Never add LLM calls inside `validator.py`.

  ## SQL Generation Prompt Rules (from `prompt.py`)
  - SQL only — no markdown fences, no commentary
  - Prefer `[PREFERRED]` objects (purpose-built views for AI)
  - Prefer `(human-readable)` columns in SELECT over raw IDs
  - Use `(identifier)` columns as join keys
  - Use `(filterable)` columns in WHERE clauses
  - Oracle syntax (e.g., `FETCH FIRST N ROWS ONLY` not `LIMIT`)
  - No trailing semicolons
  - Resolve user terms against aliases
  - Never invent status code values in WHERE clauses
  - If unanswerable from schema, return exactly: `CANNOT_ANSWER`

  ## CLI Usage
  ```bash
  # Single question
  python src/main.py --question "Show overdue invoices"

  # Batch from file
  python src/main.py -f tests/test_questions.txt -o tests/test_results

  Batch output: tests/test_results/test_NNN_<slug>/summary.log + data.csv

  Environment Variables (.env)

  - OPENAI_API_KEY
  - DB_USER, DB_PASSWORD, DB_DSN

  Design Constraints (non-negotiable)

  - The LLM never sees raw t_ table DDL — semantic layer only
  - validator.py stays deterministic regex
  - LLM temperature stays at 0 (set in llm.py)

  ---
