import sqlite3
import os

db_path = r'd:\antigravity\matpam-admin\db\matpam.db'
if not os.path.exists(db_path):
    print(f"DB not found at {db_path}")
    exit(1)

conn = sqlite3.connect(db_path)
conn.row_factory = sqlite3.Row
cursor = conn.cursor()

try:
    cursor.execute("SELECT user_id, login_id, user_nm, user_role FROM tb_user")
    users = cursor.fetchall()
    print("--- User List ---")
    for u in users:
        print(dict(u))
except Exception as e:
    print(f"Error: {e}")
finally:
    conn.close()
