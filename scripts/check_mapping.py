import mysql.connector

def check_mapping():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="root",
            database="matpam_new"
        )
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM tb_company_channel_map WHERE company_id = 2")
        rows = cursor.fetchall()
        if rows:
            for row in rows:
                print(row)
        else:
            print("No mapping found for company 2")
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_mapping()
