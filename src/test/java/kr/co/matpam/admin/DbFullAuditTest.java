package kr.co.matpam.admin;

import java.sql.*;
import java.io.*;
import java.util.*;
import org.junit.Test;

public class DbFullAuditTest {
    @Test
    public void dumpSchema() throws Exception {
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";
        
        File outFile = new File("d:/antigravity/matpam-admin/full_schema_audit.txt");
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PrintWriter writer = new PrintWriter(new FileWriter(outFile))) {
            
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet tables = metaData.getTables("matpam", null, "tb_%", new String[]{"TABLE"});
            
            writer.println("=== FULL DATABASE SCHEMA AUDIT ===");
            while (tables.next()) {
                String tableName = tables.getString("TABLE_NAME");
                writer.println("\n[TABLE: " + tableName + "]");
                
                ResultSet columns = metaData.getColumns("matpam", null, tableName, "%");
                while (columns.next()) {
                    String colName = columns.getString("COLUMN_NAME");
                    String typeName = columns.getString("TYPE_NAME");
                    int size = columns.getInt("COLUMN_SIZE");
                    String nullable = columns.getString("IS_NULLABLE");
                    writer.printf("  - %-25s %-15s (size:%d, null:%s)%n", colName, typeName, size, nullable);
                }
            }
            writer.flush();
            System.out.println("Audit report written to " + outFile.getAbsolutePath());
        }
    }
}
