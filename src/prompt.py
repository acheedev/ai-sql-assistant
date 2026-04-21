def format_schema(semantic_schema: dict) -> str:
    """
    Convert semantic schema dict into a structured schema block
    for LLM prompt grounding.
    """
    lines = []

    for obj in semantic_schema.values():
        # Header
        preferred_tag = " [PREFERRED]" if obj["preferred_for_ai"] == "Y" else ""
        lines.append(
            f"## {obj['object_name']} ({obj['object_type']}){preferred_tag}"
        )
        lines.append(f"Business name: {obj['business_name']}")

        if obj["short_description"]:
            lines.append(f"Description: {obj['short_description']}")

        if obj["aliases"]:
            lines.append(f"Also known as: {', '.join(obj['aliases'])}")

        # Columns
        lines.append("Columns:")
        for col in obj["columns"]:
            tags = []
            if col["is_identifier"] == "Y":
                tags.append("identifier")
            if col["is_human_readable"] == "Y":
                tags.append("human-readable")
            if col["is_default_select"] == "Y":
                tags.append("default-select")
            if col["is_filterable"] == "Y":
                tags.append("filterable")

            biz = f" — {col['business_name']}" if col["business_name"] else ""
            tag_str = f" ({', '.join(tags)})" if tags else ""
            lines.append(f"  - {col['column_name']}{biz}{tag_str}")

        lines.append("")

    return "\n".join(lines).strip()


def format_examples(semantic_schema: dict) -> str:
    """
    Build a few-shot example block from semantic_example_question rows.
    Only includes examples that have exemplar_sql populated.
    """
    lines = []

    for obj in semantic_schema.values():
        for ex in obj["example_questions"]:
            if not ex["sql"]:
                continue
            lines.append(f"Q: {ex['question']}")
            lines.append(f"SQL: {ex['sql'].strip()}")
            lines.append("")

    if not lines:
        return ""

    return "## Example Questions\n\n" + "\n".join(lines).strip()


def build_sql_prompt(user_question: str, semantic_schema: dict) -> str:
    schema_block = format_schema(semantic_schema)
    examples_block = format_examples(semantic_schema)

    examples_section = ""
    if examples_block:
        examples_section = f"""
{examples_block}

---
"""

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
- Use only the objects and columns listed in the schema below
- Prefer objects marked [PREFERRED] — these are purpose-built views for AI querying
- Prefer columns marked (human-readable) in SELECT output over raw IDs
- When joining views, always use columns marked (identifier) as join keys
- Use columns marked (filterable) in WHERE clauses
- Use Oracle-compatible SQL syntax (e.g., FETCH FIRST N ROWS ONLY instead of LIMIT)
- Do not add a semicolon to the end of the SQL statement
- If a user term matches an alias listed under "Also known as", resolve it to that object

Output requirements:
- Always include human-readable fields when available, not just IDs
- Use clear column aliases when appropriate
- Prefer meaningful output over minimal output

If the question cannot be answered from the schema, return exactly:
CANNOT_ANSWER
{examples_section}
---

Schema:
{schema_block}

User question:
{user_question}
""".strip()
