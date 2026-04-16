package kr.co.matpam.admin;

import org.junit.Test;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;

public class DbCodeAuditTest {
    @Test
    public void auditCodeTables() throws Exception {
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";

        String[] tables = {"TB_GROUP_CODE", "TB_CODE", "TB_DETAIL_CODE"};

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             Statement stmt = conn.createStatement()) {
            
            for (String table : tables) {
                System.out.println("\n--- Table: " + table + " ---");
                try (ResultSet rs = stmt.executeQuery("SELECT * FROM " + table + " LIMIT 1")) {
                    ResultSetMetaData md = rs.getMetaData();
                    int colCount = md.getColumnCount();
                    for (int i = 1; i <= colCount; i++) {
                        System.out.println("Column: " + md.getColumnName(i));
                    }
                    
                    // Check if there's any data
                    try (ResultSet rsCount = stmt.executeQuery("SELECT COUNT(*) FROM " + table)) {
                        if (rsCount.next()) {
                            System.out.println("Row Count: " + rsCount.getInt(1));
                        }
                    }
                } catch (Exception e) {
                    System.out.println("Error reading table " + table + ": " + e.getMessage());
                }
            }
        }
    }
}
