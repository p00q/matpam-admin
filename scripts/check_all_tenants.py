import mysql.connector

try:
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="root",
        database="matpam_new"
    )
    cursor = conn.cursor()
    cursor.execute("SELECT company_id, company_name, company_type, tenant_id FROM tb_company")
    rows = cursor.fetchall()
    for row in rows:
        print(f"ID: {row[0]}, Name: {row[1]}, Type: {row[2]}, Tenant: {row[3]}")
    conn.close()
except Exception as e:
    print(f"Error: {e}")
