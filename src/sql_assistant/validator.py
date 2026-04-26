import logging
import re

logger = logging.getLogger(__name__)

_STRIP_LINE_COMMENTS = re.compile(r'--[^\n]*')
_STRIP_BLOCK_COMMENTS = re.compile(r'/\*.*?\*/', re.DOTALL)
_FORBIDDEN = re.compile(
    r'\b(INSERT|UPDATE|DELETE|MERGE|DROP|ALTER|TRUNCATE|CREATE'
    r'|GRANT|REVOKE|EXECUTE|EXEC|CALL|BEGIN)\b'
)

def normalize_sql(sql: str) -> str:
    if not sql:
        return sql
    cleaned = sql.strip()
    if cleaned.endswith(";"):
        cleaned = cleaned[:-1]
    cleaned = _STRIP_LINE_COMMENTS.sub('', cleaned)
    cleaned = _STRIP_BLOCK_COMMENTS.sub('', cleaned)
    return cleaned


def is_safe_sql(sql: str) -> tuple[bool, str]:
    def _fail(reason: str) -> tuple[bool, str]:
        logger.error("validation_fail", extra={"event": "validation_fail", "reason": reason})
        return False, reason

    if not sql:
        return _fail("Empty SQL")

    cleaned = sql.strip().upper()

    if not (cleaned.startswith("SELECT") or cleaned.startswith("WITH")):
        return _fail("Only SELECT statements are allowed")

    if ";" in cleaned:
        return _fail("Multiple statements are not allowed")

    match = _FORBIDDEN.search(cleaned)
    if match:
        return _fail(f"Forbidden keyword detected: {match.group()}")

    logger.info("validation_pass", extra={"event": "validation_pass", "normalized_sql": sql})
    return True, ""
