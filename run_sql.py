import mysql.connector
import sys

def run_sql(sql):
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="root",
            database="matpam_new"
        )
        cursor = conn.cursor()
        cursor.execute(sql)
        conn.commit()
        print(f"Executed: {sql}")
        cursor.close()
        conn.close()
        print("Success!")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        run_sql(sys.argv[1])
    else:
        print("Usage: python run_sql.py \"SQL_STATEMENT\"")
