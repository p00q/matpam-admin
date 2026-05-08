import mysql.connector

try:
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="root",
        database="matpam_new"
    )
    cursor = conn.cursor()
    statements = [
        "ALTER TABLE tb_channel ADD COLUMN sort_order INT DEFAULT 0;",
        "ALTER TABLE tb_channel ADD COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP;",
        "ALTER TABLE tb_channel ADD COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;"
    ]
    
    for statement in statements:
        try:
            cursor.execute(statement)
            print(f"Executed: {statement[:50]}...")
        except Exception as e:
            print(f"Error executing statement: {e}")
    
    conn.commit()
    cursor.close()
    conn.close()
    print("Success!")
except Exception as e:
    print(f"Failed: {e}")
