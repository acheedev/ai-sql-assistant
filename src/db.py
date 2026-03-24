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
