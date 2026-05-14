import mysql.connector
conn = mysql.connector.connect(host='localhost', user='root', password='root', database='matpam_new')
cur = conn.cursor(dictionary=True)

print('=== tb_user (운영자급 역할) ===')
cur.execute("SELECT user_id, login_id, user_name, role, company_id, status FROM tb_user WHERE role IN ('OPERATOR','CHANNEL_ADMIN','SUPER_ADMIN') ORDER BY role, user_id")
for r in cur.fetchall(): print(r)

print()
print('=== tb_company_contact (company_id=1, 몰 기본정보) ===')
cur.execute("""
SELECT cc.contact_id, cc.company_id, cc.contact_name, cc.contact_role,
       cc.linked_user_id, cc.status,
       u.role as user_role, u.login_id
FROM tb_company_contact cc
LEFT JOIN tb_user u ON cc.linked_user_id = u.user_id
WHERE cc.company_id = 1
ORDER BY cc.contact_id
""")
rows = cur.fetchall()
if rows:
    for r in rows: print(r)
else:
    print('>> 데이터 없음 - company_id=1 담당자 미등록')

print()
print('=== selectCompanyContactList 실제 실행 (companyType 없는 경우) ===')
cur.execute("""
SELECT cc.*
FROM tb_company_contact cc
INNER JOIN tb_user u ON cc.linked_user_id = u.user_id
WHERE cc.company_id = 1
  AND cc.status = 'ACTIVE'
ORDER BY cc.is_primary DESC, cc.created_at ASC
""")
rows = cur.fetchall()
if rows:
    for r in rows: print(r)
else:
    print('>> 담당자 없음 또는 INNER JOIN 불일치')

conn.close()
