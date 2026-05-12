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
        "ALTER TABLE tb_company ADD COLUMN IF NOT EXISTS fax VARCHAR(20) NULL COMMENT '팩스번호' AFTER phone;",
        "ALTER TABLE tb_company ADD COLUMN IF NOT EXISTS contact_phone VARCHAR(20) NULL COMMENT '연락처(추가)' AFTER fax;",
        "ALTER TABLE tb_company ADD COLUMN IF NOT EXISTS ecommerce_reg_no VARCHAR(100) NULL COMMENT '통신판매업신고번호' AFTER contact_phone;",
        "ALTER TABLE tb_company ADD COLUMN IF NOT EXISTS factory_postal_code VARCHAR(10) NULL COMMENT '공장 우편번호' AFTER ecommerce_reg_no;",
        "ALTER TABLE tb_company ADD COLUMN IF NOT EXISTS factory_address1 VARCHAR(200) NULL COMMENT '공장 기본주소' AFTER factory_postal_code;",
        "ALTER TABLE tb_company ADD COLUMN IF NOT EXISTS factory_address2 VARCHAR(200) NULL COMMENT '공장 상세주소' AFTER factory_address1;",
    ]

    for stmt in statements:
        try:
            cursor.execute(stmt)
            print(f"OK: {stmt[:70]}...")
        except Exception as e:
            print(f"SKIP/ERR: {e}")

    conn.commit()
    cursor.close()
    conn.close()
    print("\n=== 완료: tb_company 컬럼 추가 성공 ===")

except Exception as e:
    print(f"연결 실패: {e}")
