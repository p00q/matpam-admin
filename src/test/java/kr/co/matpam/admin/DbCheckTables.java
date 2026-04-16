package kr.co.matpam.admin;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class DbCheckTables {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";

        String[] tablesToCheck = {"to_code", "to_group_code", "tb_detail_code", "TB_CODE", "TB_GROUP_CODE", "TB_DETAIL_CODE"};

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 Statement stmt = conn.createStatement()) {
                
                System.out.println("Checking tables...");
                for (String table : tablesToCheck) {
                    try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM " + table)) {
                        if (rs.next()) {
                            System.out.println("Table [" + table + "] exists with " + rs.getInt(1) + " rows.");
                        }
                    } catch (Exception e) {
                        System.out.println("Table [" + table + "] does NOT exist or error: " + e.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
