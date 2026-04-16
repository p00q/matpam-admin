package kr.co.matpam.admin;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * QA Verifier Tool: DB Migration and Schema Verification
 */
public class DbFinalVerify {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";

        String[] migrationSqls = {
            // v3 patches
            "ALTER TABLE tb_order_delivery_parcel ADD COLUMN op_type VARCHAR(20) DEFAULT 'NATIONAL' COMMENT '운영타입'",
            "ALTER TABLE tb_order_delivery_freight ADD COLUMN op_type VARCHAR(20) DEFAULT 'NATIONAL' COMMENT '운영타입'",
            "ALTER TABLE tb_order_delivery_factory ADD COLUMN op_type VARCHAR(20) DEFAULT 'NATIONAL' COMMENT '운영타입'"
        };

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("--- QA Phase 1: DB Migration ---");
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 Statement stmt = conn.createStatement()) {
                
                for (String sql : migrationSqls) {
                    try {
                        System.out.println("Executing: " + sql);
                        stmt.execute(sql);
                        System.out.println("SUCCESS.");
                    } catch (Exception e) {
                        System.out.println("SKIPPED (Probably already exists): " + e.getMessage());
                    }
                }

                System.out.println("\n--- QA Phase 2: Schema Verification ---");
                String[] deliveryTables = {"tb_order_delivery_parcel", "tb_order_delivery_freight", "tb_order_delivery_factory"};
                for (String table : deliveryTables) {
                    try (ResultSet rs = stmt.executeQuery("DESC " + table)) {
                        boolean found = false;
                        while(rs.next()) {
                            if ("op_type".equalsIgnoreCase(rs.getString("Field"))) {
                                found = true;
                                break;
                            }
                        }
                        System.out.println("Table [" + table + "] op_type found: " + found);
                    }
                }

                System.out.println("\n--- QA Phase 3: Data I/O Validation (Logic Audit) ---");
                // Check if any record has 'admin' in REG_ID for new items (Audit)
                try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM tb_order WHERE reg_id = 'admin'")) {
                    if (rs.next()) {
                        System.out.println("Total orders with 'admin' reg_id: " + rs.getInt(1));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
