import os
import oracledb
from dotenv import load_dotenv

load_dotenv()

print("DB_USER =", os.getenv("DB_USER"))
print("DB_DSN  =", os.getenv("DB_DSN"))

try:
    conn = oracledb.connect(
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        dsn=os.getenv("DB_DSN"),
    )
    print("CONNECTED OK")
    conn.close()
except Exception as e:
    print("CONNECT FAILED")
    print(repr(e))
