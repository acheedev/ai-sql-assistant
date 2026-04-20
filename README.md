# AI SQL Assistant

AI-assisted SQL querying system for Oracle that translates natural language into SQL, validates it for safety, executes it against the database, and returns a plain-English explanation of the results.

This project is being built as a portfolio-quality proof of concept with production-oriented design choices:
- controlled AI-visible schema surface
- deterministic SQL validation before execution
- explicit pipeline state handling in Python
- 1:1 database view layer plus business views
- lean semantic metadata for schema selection and prompt grounding

---

## Current Status

The project currently includes:

### Python application layer
- CLI-driven natural language input
- prompt construction for SQL generation
- LLM-driven SQL generation
- SQL normalization and safety validation
- Oracle execution
- LLM-generated explanation of results
- explicit status-driven pipeline orchestration using a structured result object

### Database layer
- 12-table Phase 1 starter schema
- mandatory 1:1 views for every base table
- business views for richer AI-facing query surfaces
- lean 4-table semantic metadata model
- repeatable build scripts and seed data

This is now at the point where the next major step is to return to Python testing and run real end-to-end natural-language questions against the expanded schema.

---

## Design Goals

### 1. Controlled AI surface
The model should not reason directly over arbitrary base tables without structure.
The system exposes a controlled query surface through:
- 1:1 views
- business views
- semantic metadata

### 2. Deterministic safety boundary
LLM output is treated as untrusted until it passes deterministic checks.
Validation enforces:
- query-only access
- single-statement restrictions
- no DDL
- no DML
- other safety/shape constraints

### 3. Explicit pipeline state
The Python pipeline uses a structured result object and a status enum so failures are represented explicitly and later stages are gated cleanly.

### 4. Portfolio-quality first
The initial goal is a clean, understandable, testable system that can later evolve toward a more production-oriented implementation.

---

## Repository Layout

```text
.
├── LICENSE
├── README.md
├── doc
│   └── ai_sql_assistant_design_spec.docx
├── requirements.txt
├── sql
│   ├── build.sql
│   ├── build2.sql
│   ├── ddl
│   │   ├── basetables
│   │   ├── semantic
│   │   └── views
│   └── seed
├── src
│   ├── config.json
│   ├── db.py
│   ├── explain.py
│   ├── llm.py
│   ├── llm_exceptions.py
│   ├── main.py
│   ├── prompt.py
│   └── validator.py
````

---

## SQL Structure

### Base tables

The Phase 1 schema currently includes the following base tables:

* `address_master`
* `customer_account`
* `inventory_balance`
* `invoice_header`
* `order_header`
* `order_line_item`
* `organization`
* `payment_transaction`
* `product_master`
* `product_sku`
* `shipment_header`
* `status_code_lookup`

### Semantic metadata tables

The lean semantic model includes:

* `semantic_object`
* `semantic_object_alias`
* `semantic_column`
* `semantic_example_question`

### 1:1 views

Each base table has a mandatory 1:1 view:

* `v_address_master`
* `v_customer_account`
* `v_inventory_balance`
* `v_invoice_header`
* `v_order_header`
* `v_order_line_item`
* `v_organization`
* `v_payment_transaction`
* `v_product_master`
* `v_product_sku`
* `v_shipment_header`
* `v_status_code_lookup`

### Business views

The project also includes denormalized business views intended to provide more useful AI-facing query surfaces:

* `v_order_detail`
* `v_customer_order_summary`
* `v_inventory_status`

---

## Current SQL Build Files

### `sql/build.sql`

Original/main build flow for Phase 1 foundation.

### `sql/build2.sql`

Expanded build flow for Stage 2 additions such as:

* fulfillment/inventory seeds
* finance seeds
* Stage 2 semantic metadata
* business views

If you eventually consolidate the scripts, this can become a single canonical build again. For now, the split is acceptable during active evolution.

---

## Seed Data

The repository includes seed scripts for:

### Foundation/reference/business data

* `seed_reference_data.sql`
* `seed_business_data.sql`
* `seed_product_data.sql`
* `seed_order_data.sql`
* `seed_shipment_inventory_data.sql`
* `seed_finance_data.sql`

### Semantic metadata

Base semantic seeds:

* `seed_semantic_object.sql`
* `seed_semantic_object_alias.sql`
* `seed_semantic_column.sql`
* `seed_semantic_example_question.sql`

Incremental semantic expansions:

* product
* order
* operational
* stage2

This incremental approach keeps schema evolution understandable while the design is still being shaped.

---

## Python Application Structure

### `src/main.py`

Application entry point.

Responsibilities:

* parse CLI arguments
* load configuration
* resolve the user question
* orchestrate the pipeline
* print the final pipeline result

### `src/prompt.py`

Builds the prompt used for SQL generation.

### `src/llm.py`

Contains the LLM call wrapper.

### `src/llm_exceptions.py`

Custom exception types for LLM-related failures.

### `src/validator.py`

Normalizes and validates generated SQL before execution.

### `src/db.py`

Executes validated SQL against Oracle.

### `src/explain.py`

Builds the explanation prompt used to summarize SQL results.

### `src/config.json`

Contains configuration such as:

* sample questions
* default question mode
* test mode behavior

---

## Python Pipeline

High-level runtime flow:

```text
user question
  -> build SQL prompt
  -> LLM generates SQL
  -> normalize SQL
  -> validate SQL
  -> execute against Oracle
  -> build explanation prompt
  -> LLM explains results
```

The pipeline is driven by a structured result object with a status enum.
Each stage may:

* enrich the result
* update its status
* stop downstream processing if status is no longer `OK`

This keeps the control flow explicit and makes failures easier to reason about.

---

## Semantic Metadata Strategy

The semantic layer is intentionally lean and deterministic.

It is used to support:

* AI-visible object selection
* alias matching
* column prioritization
* example-question grounding

Rather than introducing vector search or heavy orchestration early, the project relies on:

* object-level ranking
* aliases
* human-readable columns
* curated example questions

This keeps the system understandable and testable while still providing meaningful schema guidance.

---

## Example Business Questions This Schema Supports

The current schema and views are intended to support questions like:

* Show the top customers by total order amount
* List customers with no orders
* Show recent orders
* Show order detail by customer
* Show total quantity ordered by SKU
* Show low stock items by location
* Show recent shipments
* Show invoices by due date
* Show payments by method

These are the kinds of prompts that will be used in the next round of Python testing.

---

## How to Build the Database

Run the SQL build scripts in SQL*Plus, SQLcl, or your preferred Oracle client.

Example:

```sql
@sql/build.sql
@sql/build2.sql
```

If you later consolidate to a single build script, update this section accordingly.

---

## How to Run the Python Tool

From the project root:

```bash
python src/main.py
```

Or with explicit arguments, depending on how you are currently testing:

```bash
python src/main.py --test_mode --question_type valid
python src/main.py --question "Show top customers by total order amount"
```

---

## Environment / Setup Notes

This project expects:

* Oracle database access
* Python environment with dependencies from `requirements.txt`
* LLM API credentials/configuration available to the Python layer

Database connectivity and model/API configuration are handled in the Python source and local configuration/environment setup.

---

## What Comes Next

The next major step is to move back into end-to-end Python testing with the expanded schema and semantic layer.

Planned next activities:

* run a batch of real NL test prompts
* observe incorrect object/view selection
* tune prompt construction and semantic ranking
* improve schema grounding
* refine business views where needed

At this stage, the highest-value work is no longer adding raw schema blindly, but testing the AI pipeline against realistic business questions and tightening the system based on evidence.

---

## Project Positioning

This project is intentionally aimed at the space between:

* traditional database/reporting systems
* AI-assisted querying
* safe enterprise data access patterns

The core design principle is:

> Use AI for flexible interpretation, but surround it with deterministic control layers.
