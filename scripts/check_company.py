import mysql.connector

def check_company():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="root",
            database="matpam_new"
        )
        cursor = conn.cursor()
        cursor.execute("SELECT company_id, company_name, ceo_name, updated_at FROM tb_company WHERE company_id = 2")
        row = cursor.fetchone()
        if row:
            print(f"ID: {row[0]}, Name: {row[1]}, CEO: {row[2]}, UpdatedAt: {row[3]}")
        else:
            print("Company not found")
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_company()
