package kr.co.matpam.admin;

import java.sql.*;
import org.junit.Test;

public class DbPatchToolTest {
    @Test
    public void runPatch() throws Exception {
        String url = "jdbc:mysql://localhost:3306/matpam_new?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";
        
        String[] patches = {
            // 1. tb_settlement 테이블 생성
            "CREATE TABLE IF NOT EXISTS tb_settlement (" +
            "  settle_id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
            "  settle_date VARCHAR(8) NOT NULL, " +
            "  op_type VARCHAR(20) NOT NULL, " +
            "  order_count INT DEFAULT 0, " +
            "  total_sales_amt DECIMAL(15,2) DEFAULT 0, " +
            "  total_goods_amt DECIMAL(15,2) DEFAULT 0, " +
            "  total_discount_amt DECIMAL(15,2) DEFAULT 0, " +
            "  total_vat_amt DECIMAL(15,2) DEFAULT 0, " +
            "  total_pay_amt DECIMAL(15,2) DEFAULT 0, " +
            "  raw_material_ratio DECIMAL(5,2) DEFAULT 0, " +
            "  processed_ratio DECIMAL(5,2) DEFAULT 0, " +
            "  reg_dt DATETIME DEFAULT CURRENT_TIMESTAMP, " +
            "  mod_dt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, " +
            "  INDEX idx_settle_date (settle_date)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            
            // 2. tb_order 테이블 op_type 컬럼 추가
            "ALTER TABLE tb_order ADD COLUMN op_type VARCHAR(20) DEFAULT 'NATIONAL' COMMENT '운영 타입' AFTER addr2",
            
            // 3. tb_meatmoney_txn 테이블 인덱스 추가 (조회 성능)
            "CREATE INDEX idx_txn_member ON tb_meatmoney_txn(member_id, txn_dt)",
            
            // 4. tb_member 테이블 op_type 컬럼 추가
            "ALTER TABLE tb_member ADD COLUMN OP_TYPE VARCHAR(20) DEFAULT 'NATIONAL' COMMENT '운영 타입' AFTER delivery_type_cd",
            
            // 5. tb_order_item 테이블 op_type 컬럼 추가 (필요시)
            "ALTER TABLE tb_order_item ADD COLUMN op_type VARCHAR(20) DEFAULT 'NATIONAL' COMMENT '운영 타입'",
            
            // 6. 기존 데이터 op_type 보정 (null 방지)
            "UPDATE tb_order SET op_type = 'NATIONAL' WHERE op_type IS NULL OR op_type = '' OR op_type = 'MATPAM'",
            "UPDATE tb_member SET OP_TYPE = 'NATIONAL' WHERE OP_TYPE IS NULL OR OP_TYPE = '' OR OP_TYPE = 'MATPAM'",
            "UPDATE tb_order_item SET op_type = 'NATIONAL' WHERE op_type IS NULL OR op_type = '' OR op_type = 'MATPAM'",
            
            // 7. tb_product 누락 컬럼 추가
            "ALTER TABLE tb_product ADD COLUMN IF NOT EXISTS seller_company_id BIGINT NULL AFTER tenant_id",
            "ALTER TABLE tb_product ADD COLUMN IF NOT EXISTS tax_category VARCHAR(50) NULL AFTER processing_type",
            "ALTER TABLE tb_product ADD COLUMN IF NOT EXISTS unit_name VARCHAR(50) NULL AFTER tax_category",
            "ALTER TABLE tb_product ADD COLUMN IF NOT EXISTS description TEXT NULL",
            "ALTER TABLE tb_product ADD COLUMN IF NOT EXISTS image_url VARCHAR(500) NULL",
            "ALTER TABLE tb_product ADD COLUMN IF NOT EXISTS created_by BIGINT NULL"
        };
        
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Starting Database Patch...");
            for (String sql : patches) {
                try {
                    System.out.println("Executing: " + sql);
                    stmt.execute(sql);
                    System.out.println(">> Success.");
                } catch (SQLException e) {
                    System.out.println(">> Skipped or Handled: " + e.getMessage());
                }
            }
            System.out.println("Database Patch Completed Successfully.");
        }
    }
}
