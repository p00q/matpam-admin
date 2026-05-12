import mysql.connector
import sys

def check_schema(table_name):
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="root",
            database="matpam_new"
        )
        cursor = conn.cursor()
        cursor.execute(f"DESC {table_name}")
        for row in cursor.fetchall():
            print(row)
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    table = sys.argv[1] if len(sys.argv) > 1 else "tb_company"
    check_schema(table)
