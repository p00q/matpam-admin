import mysql.connector

def check_company_data():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="root",
            database="matpam_new"
        )
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT company_id, company_name, company_type, status FROM tb_company")
        rows = cursor.fetchall()
        for row in rows:
            print(row)
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_company_data()
