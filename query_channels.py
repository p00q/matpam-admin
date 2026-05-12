import mysql.connector

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
    for row in rows:
        print(f"ID: {row[0]}, Name: {row[1]}")
    cursor.close()
    conn.close()
except Exception as e:
    print(f"Error: {e}")
