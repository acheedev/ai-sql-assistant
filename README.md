# AI SQL Assistant

## Overview

AI SQL Assistant is a controlled AI-driven system that translates natural language into SQL, executes queries against an Oracle database, and returns both results and business-level explanations.

This project is designed as both:
- A **portfolio-quality system**
- A **foundation for a production-grade AI data access layer**

---

## Key Features

- Natural language → SQL generation
- Safe execution (no destructive queries)
- Schema-aware prompting
- Semantic metadata layer for accuracy
- AI-generated business explanations
- Scalable from small to enterprise schemas

---

## Architecture

User Input → Prompt Builder → LLM → Normalization → Validation → Execution → Explanation → Output

---

## Project Structure

```
ai-sql-assistant/
│
├── main.py               # Orchestrates flow
├── llm.py                # LLM interaction
├── prompt.py             # SQL prompt builder
├── validator.py          # SQL safety checks
├── db.py                 # Oracle connection + execution
├── explain.py            # Explanation prompt builder
├── schema.py             # Schema introspection (future)
├── schema_selector.py    # Table selection logic
│
├── .env                  # DB + API config
├── requirements.txt
│
├── docs/
│   └── design-spec.md
```

---

## Python Components

### main.py
- Entry point
- Handles end-to-end pipeline

### llm.py
- Sends prompts to LLM
- Returns generated SQL or explanations

### prompt.py
- Builds SQL generation prompt
- Injects schema context

### validator.py
- Blocks unsafe SQL
- Prevents DML/DDL execution

### db.py
- Oracle connection using `oracledb`
- Executes SQL queries

### explain.py
- Converts results into business insights

### schema_selector.py
- Selects relevant tables using metadata

---

## Setup

### 1. Install dependencies

```
pip install -r requirements.txt
```

---

### 2. Configure environment

Create `.env`:

```
DB_USER=your_user
DB_PASSWORD=your_password
DB_DSN=host:1521/service
OPENAI_API_KEY=your_key
```

---

### 3. Run the application

```
python main.py
```

---

## Example Usage

```
Ask a question:
> Show top 5 customers by total order amount
```

Output:
- Generated SQL
- Query results
- AI explanation

---

## Safety Controls

- Blocks INSERT, UPDATE, DELETE, DROP, ALTER
- Enforces single SELECT statement
- Limits result size sent to LLM

---

## Database Design

### Phase 1 Tables

- customer_account
- organization
- product_master
- product_sku
- order_header
- order_line_item
- shipment_header
- inventory_balance
- invoice_header
- payment_transaction
- address_master
- status_code_lookup

---

## Semantic Layer

Tables:
- semantic_object
- semantic_object_alias
- semantic_column
- semantic_example_question

Purpose:
- Improve schema selection
- Improve SQL quality
- Provide deterministic control

---

## Roadmap

### Phase 1
- 12 tables
- Metadata layer
- Deterministic schema selection

### Phase 2
- Expand to ~50 tables
- Add FK awareness

### Phase 3
- Web UI (Flask)
- Documentation automation

---

## Positioning

This is not a chatbot.

This is:

> A controlled semantic query layer for enterprise data

---

## Author

Built as part of an advanced AI + database engineering portfolio project.
