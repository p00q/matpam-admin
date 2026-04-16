package kr.co.matpam.admin;

import java.sql.*;
import java.util.*;

public class DbFullAudit {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC";
        String user = "root";
        String password = "root"; // context-datasource.xml 확인 필요

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            DatabaseMetaData metaData = conn.getMetaData();
            
            // 1. 테이블 목록 조회
            ResultSet tables = metaData.getTables("matpam", null, "tb_%", new String[]{"TABLE"});
            List<String> tableNames = new ArrayList<>();
            while (tables.next()) {
                tableNames.add(tables.getString("TABLE_NAME"));
            }
            
            System.out.println("=== Matpam DB Full Schema Audit ===");
            for (String tableName : tableNames) {
                System.out.println("\n[Table: " + tableName + "]");
                ResultSet columns = metaData.getColumns("matpam", null, tableName, "%");
                while (columns.next()) {
                    String colName = columns.getString("COLUMN_NAME");
                    String typeName = columns.getString("TYPE_NAME");
                    int size = columns.getInt("COLUMN_SIZE");
                    String isNullable = columns.getString("IS_NULLABLE");
                    System.out.printf("  - %-25s %-15s (size:%d, null:%s)%n", colName, typeName, size, isNullable);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
