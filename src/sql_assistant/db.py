import logging
import time

import oracledb
from config.settings import settings

logger = logging.getLogger(__name__)

_pool: oracledb.ConnectionPool | None = None


def _get_pool() -> oracledb.ConnectionPool:
    global _pool
    if _pool is None:
        _pool = oracledb.create_pool(
            user=settings.db_user,
            password=settings.db_password,
            dsn=settings.db_dsn,
            min=1,
            max=5,
            increment=1,
        )
    return _pool


def run_query(sql: str) -> list[dict]:
    start = time.monotonic()
    with _get_pool().acquire() as conn:
        with conn.cursor() as cursor:
            cursor.execute(sql)
            columns = [col[0].lower() for col in cursor.description]
            rows = [dict(zip(columns, row)) for row in cursor.fetchall()]

    latency_ms = int((time.monotonic() - start) * 1000)
    logger.info("db_execute_complete", extra={
        "event": "db_execute_complete",
        "row_count": len(rows),
        "latency_ms": latency_ms,
    })
    if not rows:
        logger.warning("db_empty_result", extra={"event": "db_empty_result", "sql": sql})
    logger.debug("db_rows", extra={"event": "db_rows", "rows": rows})
    return rows


def get_semantic_schema() -> dict:
    """
    Query the semantic layer and return structured schema data
    for use in prompt construction.
    """
    with _get_pool().acquire() as conn:
        with conn.cursor() as cursor:
            # --- Objects + columns ---
            cursor.execute("""
                SELECT
                    so.object_name,
                    so.object_type,
                    so.business_name        AS object_business_name,
                    so.short_description,
                    so.preferred_for_ai,
                    so.default_rank,
                    sc.column_name,
                    sc.business_name        AS column_business_name,
                    sc.is_human_readable,
                    sc.is_identifier,
                    sc.is_default_select,
                    sc.is_filterable,
                    sc.display_rank
                FROM t_semantic_object so
                JOIN t_semantic_column sc ON sc.object_name = so.object_name
                WHERE so.include_in_ai = 'Y'
                AND   so.status = 'ACTIVE'
                ORDER BY so.default_rank, so.object_name,
                         sc.display_rank, sc.column_name
            """)

            objects = {}
            for row in cursor.fetchall():
                (obj_name, obj_type, obj_biz_name, short_desc, preferred,
                 default_rank, col_name, col_biz_name, is_human_readable,
                 is_identifier, is_default_select, is_filterable, display_rank) = row

                if obj_name not in objects:
                    objects[obj_name] = {
                        "object_name":       obj_name,
                        "object_type":       obj_type,
                        "business_name":     obj_biz_name,
                        "short_description": short_desc,
                        "preferred_for_ai":  preferred,
                        "default_rank":      default_rank,
                        "columns":           [],
                        "aliases":           [],
                        "example_questions": [],
                    }

                objects[obj_name]["columns"].append({
                    "column_name":       col_name,
                    "business_name":     col_biz_name,
                    "is_human_readable": is_human_readable,
                    "is_identifier":     is_identifier,
                    "is_default_select": is_default_select,
                    "is_filterable":     is_filterable,
                    "display_rank":      display_rank,
                })

            # --- Aliases ---
            cursor.execute("""
                SELECT object_name, alias_term, alias_weight
                FROM t_semantic_object_alias
                ORDER BY object_name, alias_weight DESC
            """)

            for obj_name, alias_term, _ in cursor.fetchall():
                if obj_name in objects:
                    objects[obj_name]["aliases"].append(alias_term)

            # --- Example questions ---
            cursor.execute("""
                SELECT question_text, preferred_object_name, exemplar_sql
                FROM t_semantic_example_question
                WHERE is_enabled = 'Y'
                ORDER BY preferred_object_name
            """)

            for question_text, preferred_object_name, exemplar_sql in cursor.fetchall():
                if preferred_object_name in objects:
                    objects[preferred_object_name]["example_questions"].append({
                        "question": question_text,
                        "sql": exemplar_sql.read() if exemplar_sql else None,
                    })

            object_count = len(objects)
            column_count = sum(len(obj["columns"]) for obj in objects.values())
            logger.info("schema_loaded", extra={
                "event": "schema_loaded",
                "object_count": object_count,
                "column_count": column_count,
            })
            return objects
