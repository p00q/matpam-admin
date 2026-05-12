import mysql.connector

def check_all_mappings():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="root",
            database="matpam_new"
        )
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM tb_company_channel_map LIMIT 10")
        rows = cursor.fetchall()
        if rows:
            for row in rows:
                print(row)
        else:
            print("No mappings found in tb_company_channel_map")
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_all_mappings()
