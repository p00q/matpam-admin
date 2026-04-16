package kr.co.matpam.admin;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;

public class DbCodeAudit {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";

        String[] tables = {"to_group_code", "to_code", "tb_detail_code"};

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 Statement stmt = conn.createStatement()) {
                
                for (String table : tables) {
                    System.out.println("\n--- Table: " + table + " ---");
                    try (ResultSet rs = stmt.executeQuery("SELECT * FROM " + table + " LIMIT 1")) {
                        ResultSetMetaData md = rs.getMetaData();
                        int colCount = md.getColumnCount();
                        for (int i = 1; i <= colCount; i++) {
                            System.out.println("Column: " + md.getColumnName(i) + " (" + md.getColumnTypeName(i) + ")");
                        }
                    } catch (Exception e) {
                        System.out.println("Error reading table " + table + ": " + e.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
