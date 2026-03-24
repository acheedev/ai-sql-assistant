SCHEMA = """
Table: t_customers
- customer_id
- customer_name
- region

Table: t_orders
- order_id
- customer_id
- order_date
- amount
""".strip()


def build_sql_prompt(user_question: str) -> str:
    return f"""
You are a SQL generator for an Oracle database.

Your task is to convert a natural language question into a single SQL query.

Rules:
- Return SQL only
- Do not include markdown code fences
- Do not include commentary or explanation
- Generate only a single SELECT statement
- You may use a WITH clause if needed
- Do not generate INSERT, UPDATE, DELETE, MERGE, DROP, ALTER, TRUNCATE, CREATE, or GRANT
- Use only the tables and columns listed in the schema below
- Use Oracle-compatible SQL syntax (e.g., FETCH FIRST N ROWS ONLY instead of LIMIT)
- Do not add a semicolon to the end of the sql statement

Output requirements:
- Always include human-readable fields when available (e.g., names, descriptions), not just IDs
- Use clear column aliases when appropriate
- Prefer meaningful output over minimal output

If the question cannot be answered from the schema, return exactly:
CANNOT_ANSWER

Schema:
{SCHEMA}

User question:
{user_question}
""".strip()
