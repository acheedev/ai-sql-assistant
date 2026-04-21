# AI SQL Assistant

A natural language SQL querying system that translates plain-English business questions into validated, executable SQL — and explains the results in plain English.

Built with Python and Oracle, grounded by a hand-curated semantic metadata layer that gives the AI controlled, governed access to your database schema.

---

## What It Does

You ask a question. It generates SQL, validates it for safety, executes it, and explains what came back.

```
$ python src/main.py --question "Show what has shipped but not been paid"

sql:
  select sh.shipment_number, sh.shipment_date, sh.status_code as shipment_status,
         inv.invoice_number, inv.status_code as invoice_status, inv.invoice_total_amount,
         pay.payment_reference, pay.status_code as payment_status
  from v_shipment_header sh
  join v_invoice_header inv on sh.order_id = inv.order_id
  left join v_payment_transaction pay on inv.invoice_id = pay.invoice_id
  where sh.status_code in ('IN_TRANSIT', 'DELIVERED')
  and (pay.invoice_id is null or pay.status_code != 'COMPLETED')
  order by sh.shipment_date desc

row_count: 3

explanation:
  - Three shipments have been dispatched but remain unpaid.
  - One payment is pending, another failed, and one shipment has no payment record at all.
  - The highest outstanding invoice is $1,578 for a delivered shipment — the most significant receivables risk.
```

---

## What Makes It Different

Most natural language to SQL systems throw AI at a raw database schema and hope for the best. This one doesn't.

The core design principle: **use AI for flexible interpretation, but surround it with deterministic control layers.**

### Semantic Metadata Layer

The system doesn't expose raw tables to the AI. Instead, it reads from four semantic tables that a database administrator controls:

| Table | Purpose |
|---|---|
| `t_semantic_object` | Which views the AI can see, ranked by preference |
| `t_semantic_column` | Which columns are identifiers, human-readable, filterable, or default |
| `t_semantic_object_alias` | Natural language synonyms for object names |
| `t_semantic_example_question` | Few-shot SQL examples that ground the LLM |

This means the AI sees a curated, governed surface — not your raw schema. You control what it can query, how it joins, and what status values are valid.

### Deterministic Safety Validation

LLM output is treated as untrusted until it passes a deterministic validator:
- Must be a `SELECT` or `WITH` statement
- No DML (`INSERT`, `UPDATE`, `DELETE`, `MERGE`)
- No DDL (`DROP`, `ALTER`, `TRUNCATE`, `CREATE`)
- No multiple statements (no semicolons)
- No stored procedure invocation (`EXEC`, `EXECUTE`, `CALL`, `BEGIN`)
- Comment stripping before validation to prevent keyword hiding

### View Layer

Every base table has a mandatory 1:1 view. The AI queries views only — never base tables directly. This gives you:
- Schema change isolation (rename a column in the base table, update the view, AI queries keep working)
- Row-level security hooks if needed
- A clean separation between storage and query surface

### Explicit Pipeline State

The Python pipeline uses a `Status` enum and a `PipelineResult` dataclass. Each stage either enriches the result or stops the pipeline with an explicit failure reason — no silent failures, no ambiguous state.

```
user question
  → build SQL prompt (semantic layer injected)
  → LLM generates SQL
  → normalize SQL
  → validate SQL (deterministic)
  → execute against Oracle
  → build explanation prompt
  → LLM explains results in plain English
```

---

## Repository Layout

```
.
├── src/
│   ├── main.py          # Entry point, pipeline orchestration, test runner
│   ├── prompt.py        # Schema formatter and SQL generation prompt
│   ├── db.py            # Oracle connection, query execution, semantic layer reader
│   ├── llm.py           # OpenAI API wrapper
│   ├── validator.py     # Deterministic SQL safety validation
│   ├── explain.py       # Result explanation prompt
│   └── llm_exceptions.py
├── sql/
│   ├── ddl/
│   │   ├── basetables/  # 12 base table definitions (t_ prefix)
│   │   ├── views/       # 15 view definitions (v_ prefix)
│   │   └── semantic/    # 4 semantic metadata table definitions
│   ├── seed/
│   │   ├── seed_oltp_all.sql              # Status codes, orgs, customers, products, orders, finance, shipments, inventory
│   │   ├── seed_semantic_object_all.sql   # View registrations with descriptions
│   │   ├── seed_semantic_column_all.sql   # Column metadata and identifier flags
│   │   ├── seed_semantic_object_alias_all.sql
│   │   └── seed_semantic_example_question_all.sql
│   ├── build_obj.sql    # Builds all objects in dependency order
│   └── build_seed.sql   # Seeds all data in dependency order
├── tests/
│   ├── test_questions.txt   # 25 test questions for batch testing
│   └── testdb.py
└── .env.example
```

---

## Demo Schema

The included schema is a B2B order management system — realistic enough to exercise complex queries, simple enough to understand quickly.

**12 base tables:** `address_master`, `customer_account`, `organization`, `product_master`, `product_sku`, `order_header`, `order_line_item`, `invoice_header`, `payment_transaction`, `shipment_header`, `inventory_balance`, `status_code_lookup`

**15 views:** 1:1 views for every base table plus three denormalized business views — `v_order_detail`, `v_customer_order_summary`, `v_inventory_status`

**Domain-specific status codes** across five lifecycle domains:

| Domain | Values |
|---|---|
| Orders | `DRAFT`, `CONFIRMED`, `FULFILLED`, `CANCELLED`, `CLOSED` |
| Shipments | `PENDING`, `IN_TRANSIT`, `DELIVERED`, `RETURNED`, `CANCELLED` |
| Invoices | `ISSUED`, `PAID`, `OVERDUE`, `CANCELLED`, `VOID` |
| Payments | `PENDING`, `COMPLETED`, `FAILED`, `REFUNDED` |
| General | `ACTIVE`, `INACTIVE`, `PENDING`, `SUSPENDED`, `CLOSED`, `ARCHIVED` |

**Test scenarios baked into the seed data:**
- Fulfilled orders with paid invoices and delivered shipments
- In-transit shipments with issued but unpaid invoices
- An overdue invoice with a failed payment attempt
- A fulfilled order with a partially paid invoice and a pending payment
- A cancelled order with a returned shipment
- Draft and confirmed orders with no shipment or invoice yet
- Low stock and out-of-stock inventory across two warehouse locations

---

## Setup

### Requirements

- Python 3.10+
- Oracle database (19c or later)
- OpenAI API key

### Install dependencies

```bash
pip install -r requirements.txt
```

### Configure environment

```bash
cp .env.example .env
# Edit .env with your DB credentials and OpenAI API key
```

### Build the database

Run in SQL*Plus, SQLcl, or your preferred Oracle client:

```sql
@sql/build_obj.sql
@sql/build_seed.sql
```

---

## Usage

### Single question

```bash
python src/main.py --question "Show overdue invoices"
python src/main.py --question "Show top 5 customers by order amount"
python src/main.py --question "Show what has shipped but not been paid"
```

### Batch test mode

```bash
python src/main.py -f tests/test_questions.txt -o tests/test_results
```

Each question gets its own directory under `test_results/`:

```
tests/test_results/
  test_001_show_overdue_invoices/
    summary.log    ← question, status, SQL, row count, explanation
    data.csv       ← actual result rows (only written if rows exist)
  test_002_show_top_5_customers_by_order_amount/
    summary.log
    data.csv
```

---

## Design Goals

**Controlled AI surface** — the model reasons over a curated semantic layer, not raw schema. `include_in_ai`, `preferred_for_ai`, `is_identifier`, `is_filterable`, and `is_human_readable` flags give the DBA precise control over what the AI sees and how it behaves.

**Deterministic safety boundary** — SQL validation is not AI-assisted. It's a regex-based filter that runs before any execution. The LLM cannot bypass it.

**Portable by design** — the semantic layer abstraction is database-agnostic. The Oracle-specific pieces (`db.py`, SQL dialect rules in the prompt) are isolated for future portability to PostgreSQL, SQL Server, and others.

**Production-oriented patterns** — explicit status enums, structured result objects, gated pipeline stages, environment-based credential management. This isn't a notebook experiment.
