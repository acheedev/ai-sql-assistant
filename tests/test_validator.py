import pytest
from sql_assistant.validator import is_safe_sql, normalize_sql


# ---------------------------------------------------------------------------
# Safe SQL — must return (True, "")
# ---------------------------------------------------------------------------

@pytest.mark.parametrize("sql", [
    "SELECT * FROM v_order_detail",
    "WITH cte AS (SELECT 1 FROM DUAL) SELECT * FROM cte",
    "select id from v_inventory_status",
    "SELECT id -- get the id\nFROM v_orders",
    "SELECT /* comment */ id FROM v_orders",
])
def test_safe_sql(sql):
    safe, reason = is_safe_sql(sql)
    assert safe is True
    assert reason == ""


# ---------------------------------------------------------------------------
# Unsafe SQL — must return (False, non-empty reason)
# ---------------------------------------------------------------------------

@pytest.mark.parametrize("sql", [
    "INSERT INTO t_orders VALUES (1)",
    "DELETE FROM t_orders WHERE id = 1",
    "UPDATE t_orders SET status = 'X'",
    "DROP TABLE t_orders",
    "ALTER TABLE t_orders ADD COLUMN foo VARCHAR2(10)",
    "TRUNCATE TABLE t_orders",
    "CREATE TABLE foo (id NUMBER)",
    "GRANT SELECT ON t_orders TO user1",
    "EXECUTE some_proc",
    "BEGIN NULL; END;",
    "SELECT 1; SELECT 2",
    "",
])
def test_unsafe_sql(sql):
    safe, reason = is_safe_sql(sql)
    assert safe is False
    assert reason


# ---------------------------------------------------------------------------
# normalize_sql
# ---------------------------------------------------------------------------

def test_normalize_strips_leading_trailing_whitespace():
    assert normalize_sql("  SELECT 1  ") == "SELECT 1"


def test_normalize_strips_trailing_semicolon():
    assert normalize_sql("SELECT 1;") == "SELECT 1"


def test_normalize_preserves_internal_structure():
    sql = "SELECT a, b\nFROM v_orders\nWHERE id = 1"
    assert normalize_sql(sql) == sql


def test_normalize_strips_line_comments():
    result = normalize_sql("SELECT id -- get the id\nFROM v_orders")
    assert "--" not in result
    assert "id" in result
    assert "FROM" in result


def test_normalize_strips_block_comments():
    result = normalize_sql("SELECT /* comment */ id FROM v_orders")
    assert "/*" not in result
    assert "id" in result
