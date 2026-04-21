import os
import oracledb
from dotenv import load_dotenv

load_dotenv()


def get_connection():
    return oracledb.connect(
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        dsn=os.getenv("DB_DSN"),
    )


def run_query(sql: str) -> list[dict]:
    conn = get_connection()
    cursor = conn.cursor()

    try:
        cursor.execute(sql)

        columns = [col[0].lower() for col in cursor.description]

        rows = []
        for row in cursor.fetchall():
            rows.append(dict(zip(columns, row)))

        return rows

    finally:
        cursor.close()
        conn.close()

def get_semantic_schema() -> dict:
    """
    Query the semantic layer and return structured schema data
    for use in prompt construction.
    """
    conn = get_connection()
    cursor = conn.cursor()

    try:
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
            FROM semantic_object so
            JOIN semantic_column sc ON sc.object_name = so.object_name
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
                    "object_name":      obj_name,
                    "object_type":      obj_type,
                    "business_name":    obj_biz_name,
                    "short_description": short_desc,
                    "preferred_for_ai": preferred,
                    "default_rank":     default_rank,
                    "columns":          [],
                    "aliases":          [],
                    "example_questions": [],
                }

            objects[obj_name]["columns"].append({
                "column_name":      col_name,
                "business_name":    col_biz_name,
                "is_human_readable": is_human_readable,
                "is_identifier":    is_identifier,
                "is_default_select": is_default_select,
                "is_filterable":    is_filterable,
                "display_rank":     display_rank,
            })

        # --- Aliases ---
        cursor.execute("""
            SELECT object_name, alias_term, alias_weight
            FROM semantic_object_alias
            ORDER BY object_name, alias_weight DESC
        """)

        for obj_name, alias_term, alias_weight in cursor.fetchall():
            if obj_name in objects:
                objects[obj_name]["aliases"].append(alias_term)

        # --- Example questions ---
        cursor.execute("""
            SELECT question_text, preferred_object_name, exemplar_sql
            FROM semantic_example_question
            WHERE is_enabled = 'Y'
            ORDER BY preferred_object_name
        """)

        for question_text, preferred_object_name, exemplar_sql in cursor.fetchall():
            if preferred_object_name in objects:
                objects[preferred_object_name]["example_questions"].append({
                    "question": question_text,
                    "sql": exemplar_sql.read() if exemplar_sql else None,
                })

        return objects

    finally:
        cursor.close()
        conn.close()
