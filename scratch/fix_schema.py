import mysql.connector

def fix_schema():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="root",
            database="matpam_new"
        )
        cursor = conn.cursor()

        # 1. tb_company_channel_map 생성
        cursor.execute("""
        CREATE TABLE IF NOT EXISTS tb_company_channel_map (
            mapping_id         BIGINT NOT NULL AUTO_INCREMENT,
            tenant_id          BIGINT NOT NULL,
            company_id         BIGINT NOT NULL,
            channel_id         BIGINT NOT NULL,
            company_role_cd    VARCHAR(20) NOT NULL COMMENT '채널 내 역할 (SELLER, BUYER 등)',
            status             ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
            created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (mapping_id),
            UNIQUE KEY uq_company_channel (company_id, channel_id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        """)
        print("Created tb_company_channel_map")

        # 2. tb_company 컬럼 추가
        # 이미 존재하는 경우 무시하기 위해 개별 시도
        cols_to_add = [
            ("bank_name", "VARCHAR(50) NULL"),
            ("account_no", "VARCHAR(100) NULL"),
            ("account_holder", "VARCHAR(50) NULL"),
            ("member_grade", "VARCHAR(20) NULL"),
            ("credit_agreement_dt", "DATE NULL"),
            ("credit_limit_amount", "DECIMAL(18,2) DEFAULT 0"),
            ("advance_balance", "DECIMAL(18,2) DEFAULT 0"),
            ("meat_money_balance", "DECIMAL(18,2) DEFAULT 0")
        ]

        for col_name, col_def in cols_to_add:
            try:
                cursor.execute(f"ALTER TABLE tb_company ADD COLUMN {col_name} {col_def}")
                print(f"Added column {col_name}")
            except Exception as e:
                print(f"Column {col_name} might already exist: {e}")

        conn.commit()
        cursor.close()
        conn.close()
        print("Schema fix completed successfully.")

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    fix_schema()
