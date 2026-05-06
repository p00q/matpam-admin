package kr.co.matpam.admin;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.nio.file.Files;
import java.nio.file.Paths;

public class FixSchema {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/matpam_new?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass)) {
                String content = new String(Files.readAllBytes(Paths.get("D:/antigravity/matpam-admin/fix_order_schema.sql")), "UTF-8");
                String[] statements = content.split(";");
                try (Statement stmt = conn.createStatement()) {
                    for (String sql : statements) {
                        String trimmedSql = sql.trim();
                        if (!trimmedSql.isEmpty()) {
                            try {
                                stmt.execute(trimmedSql);
                                System.out.println("Success: " + trimmedSql.substring(0, Math.min(trimmedSql.length(), 50)) + "...");
                            } catch (Exception e) {
                                System.err.println("Error: " + e.getMessage());
                            }
                        }
                    }
                }
            }
            System.out.println("--- Schema Fix Completed ---");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
