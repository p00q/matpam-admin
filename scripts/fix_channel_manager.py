import mysql.connector
conn = mysql.connector.connect(host='localhost', user='root', password='root', database='matpam_new')
cur = conn.cursor(dictionary=True)

# channel_id=4 (화물직송, 전북직배송)의 manager_id를 user_id=2 (optest99, 채널관리자)로 업데이트
cur.execute("UPDATE tb_channel SET manager_id = 2, updated_at = NOW() WHERE channel_id = 4 AND manager_id IS NULL")
conn.commit()
print('업데이트 건수:', cur.rowcount)

# 결과 확인
cur.execute("""
SELECT ch.channel_id, ch.channel_name, ch.channel_type, ch.manager_id,
       u.user_name as manager_name, u.login_id
FROM tb_channel ch
LEFT JOIN tb_user u ON ch.manager_id = u.user_id
ORDER BY ch.channel_id
""")
for r in cur.fetchall(): print(r)
conn.close()
