package kr.co.matpam.admin;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import org.junit.Test;

public class DbForceSync {
    @Test
    public void forceSync() {
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 Statement stmt = conn.createStatement()) {
                
                String table = "tb_component_product";
                System.out.println("--- FORCING SYNC ON " + table + " ---");
                
                boolean hasOpType = false;
                try (ResultSet rs = stmt.executeQuery("DESCRIBE " + table)) {
                    while (rs.next()) {
                        if ("OP_TYPE".equalsIgnoreCase(rs.getString(1))) hasOpType = true;
                    }
                }
                
                if (!hasOpType) {
                    System.out.println("OP_TYPE missing. Adding...");
                    stmt.execute("ALTER TABLE " + table + " ADD COLUMN OP_TYPE VARCHAR(20) DEFAULT 'NATIONAL'");
                    System.out.println("OP_TYPE added.");
                } else {
                    System.out.println("OP_TYPE already exists.");
                }

                boolean hasTaxType = false;
                try (ResultSet rs = stmt.executeQuery("DESCRIBE " + table)) {
                    while (rs.next()) {
                        if ("TAX_TYPE".equalsIgnoreCase(rs.getString(1))) hasTaxType = true;
                    }
                }
                
                if (!hasTaxType) {
                    System.out.println("TAX_TYPE missing. Adding...");
                    stmt.execute("ALTER TABLE " + table + " ADD COLUMN TAX_TYPE VARCHAR(10) DEFAULT 'PROCESSED'");
                    System.out.println("TAX_TYPE added.");
                } else {
                    System.out.println("TAX_TYPE already exists.");
                }

                // Audit: Common Code Tables
                String[] commonTables = {"TB_GROUP_CODE", "TB_CODE", "TB_DETAIL_CODE"};
                try (java.io.PrintWriter pw = new java.io.PrintWriter(new java.io.FileWriter("code_schema_dump.txt"))) {
                    for (String t : commonTables) {
                        pw.println("TABLE_NAME: " + t);
                        try (ResultSet rs = stmt.executeQuery("DESCRIBE " + t)) {
                            while (rs.next()) {
                                pw.println("COLUMN: " + rs.getString(1) + " (TYPE: " + rs.getString(2) + ")");
                            }
                        } catch (Exception e) {
                            pw.println("ERROR DESC: " + e.getMessage());
                        }
                        try (ResultSet rsCount = stmt.executeQuery("SELECT COUNT(*) FROM " + t)) {
                            if (rsCount.next()) {
                                pw.println("ROW_COUNT: " + rsCount.getInt(1));
                            }
                        } catch (Exception e) {
                            pw.println("ERROR COUNT: " + e.getMessage());
                        }
                        pw.println("--- END " + t + " ---\n");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
