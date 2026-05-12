import mysql.connector

def check_channels():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="root",
            database="matpam_new"
        )
        cursor = conn.cursor()
        cursor.execute("SELECT channel_id, channel_name FROM tb_channel")
        rows = cursor.fetchall()
        if rows:
            for row in rows:
                print(row)
        else:
            print("No channels found")
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_channels()
