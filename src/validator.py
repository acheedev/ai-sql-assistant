import re

def strip_sql_comments(sql: str) -> str:
    sql = re.sub(r'--[^\n]*', '', sql)           # single-line comments
    sql = re.sub(r'/\*.*?\*/', '', sql, flags=re.DOTALL)  # block comments
    return sql

FORBIDDEN_KEYWORDS = {
    "INSERT",
    "UPDATE",
    "DELETE",
    "MERGE",
    "DROP",
    "ALTER",
    "TRUNCATE",
    "CREATE",
    "GRANT",
    "REVOKE",
    "EXECUTE",
    "EXEC",
    "CALL",       # Oracle stored proc invocation
    "BEGIN",      # PL/SQL anonymous block
}

def normalize_sql(sql: str) -> str:
    """
    Cleans up LLM output before validation/execution
    """
    if not sql:
        return sql

    # Strip whitespace
    cleaned = sql.strip()

    # Remove trailing semicolon
    if cleaned.endswith(";"):
        cleaned = cleaned[:-1]

    # Strip sql comments
    cleaned = strip_sql_comments(cleaned)

    return cleaned

def is_safe_sql(sql: str) -> tuple[bool, str]:
    """
    Returns (is_safe, reason_if_not)
    """

    if not sql:
        return False, "Empty SQL"

    # Normalize
    cleaned = sql.strip().upper()

    # Must start with SELECT or WITH
    if not (cleaned.startswith("SELECT") or cleaned.startswith("WITH")):
        return False, "Only SELECT statements are allowed"

    # No semicolons (prevents multiple statements)
    if ";" in cleaned:
        return False, "Multiple statements are not allowed"

    # Check forbidden keywords
    for keyword in FORBIDDEN_KEYWORDS:
        if re.search(rf"\b{keyword}\b", cleaned):
            return False, f"Forbidden keyword detected: {keyword}"

    return True, ""
