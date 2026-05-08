import mysql.connector

def check_tables():
    try:
        conn = mysql.connector.connect(host="localhost", user="root", password="root", database="matpam_new")
        cursor = conn.cursor()
        cursor.execute("SHOW TABLES")
        tables = [t[0] for t in cursor.fetchall()]
        print("Existing tables:", tables)
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_tables()
