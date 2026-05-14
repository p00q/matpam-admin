import mysql.connector
conn = mysql.connector.connect(host='localhost', user='root', password='root', database='matpam_new')
cur = conn.cursor(dictionary=True)
print('=== CHANNEL_ADMIN / OPERATOR 사용자 ===')
cur.execute("SELECT user_id, login_id, user_name, role, channel_id FROM tb_user WHERE role IN ('CHANNEL_ADMIN','OPERATOR') ORDER BY user_id")
for r in cur.fetchall(): print(r)
conn.close()
