package kr.co.matpam.admin;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class DbPatchTool {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";

        String[] patches = {
            // tb_component_product patches
            "ALTER TABLE tb_component_product ADD COLUMN OP_TYPE VARCHAR(20) DEFAULT 'NATIONAL' COMMENT '운영 타입'",
            "ALTER TABLE tb_component_product ADD COLUMN TAX_TYPE VARCHAR(10) DEFAULT 'PROCESSED' COMMENT '세무 유형 (RAW/PROCESSED)'",
            "ALTER TABLE tb_component_product ADD COLUMN sort_order INT DEFAULT 0 COMMENT '정렬 순서'",
            
            // tb_order patches
            "ALTER TABLE tb_order ADD COLUMN op_type VARCHAR(20) DEFAULT 'NATIONAL' COMMENT '운영 타입'",
            
            // tb_settlement creation (using lowercase for consistency)
            "CREATE TABLE IF NOT EXISTS tb_settlement (settle_id BIGINT AUTO_INCREMENT PRIMARY KEY, settle_date VARCHAR(8) NOT NULL, op_type VARCHAR(20) NOT NULL, order_count INT DEFAULT 0, total_sales_amt DECIMAL(15,2) DEFAULT 0, total_goods_amt DECIMAL(15,2) DEFAULT 0, total_discount_amt DECIMAL(15,2) DEFAULT 0, total_vat_amt DECIMAL(15,2) DEFAULT 0, total_pay_amt DECIMAL(15,2) DEFAULT 0, raw_material_ratio DECIMAL(5,2) DEFAULT 0, processed_ratio DECIMAL(5,2) DEFAULT 0, reg_dt DATETIME DEFAULT CURRENT_TIMESTAMP, mod_dt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, INDEX idx_settle_date (settle_date)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
        };

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Connecting to Database for Final Sync...");
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 Statement stmt = conn.createStatement()) {
                
                for (String sql : patches) {
                    try {
                        System.out.println("Executing: " + sql);
                        stmt.execute(sql);
                        System.out.println("Success.");
                    } catch (Exception e) {
                        System.out.println("Skipped or Error: " + e.getMessage());
                    }
                }
                System.out.println("Database Patch Completed.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
