package kr.co.matpam.admin;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;

public class DbCheckTool {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 Statement stmt = conn.createStatement()) {
                
                String[] tables = {"TB_MEMBER", "TB_ORDER", "TB_SALES_PRODUCT", "TB_COMPONENT_PRODUCT"};
                for (String table : tables) {
                    try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM " + table)) {
                        if (rs.next()) {
                            System.out.println(table + " count: " + rs.getInt(1));
                        }
                    } catch(Exception e) {
                        System.out.println(table + " error: " + e.getMessage());
                    }
                }
                
                System.out.println("\nChecking a few TB_MEMBER rows:");
                try (ResultSet rs = stmt.executeQuery("SELECT MEMBER_ID, LOGIN_ID, COMPANY_NAME FROM TB_MEMBER LIMIT 3")) {
                    while (rs.next()) {
                        System.out.println(rs.getString("MEMBER_ID") + " | " + rs.getString("LOGIN_ID") + " | " + rs.getString("COMPANY_NAME"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
