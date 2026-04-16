package kr.co.matpam.admin;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class DbCheckData {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 Statement stmt = conn.createStatement()) {
                
                String[] tables = {"TB_CODE_GROUP", "TB_DETAIL_CODE", "TB_COMPONENT_PRODUCT"};
                for (String table : tables) {
                    try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM " + table)) {
                        if (rs.next()) {
                            System.out.println("--- Table: " + table + " --- Count: " + rs.getInt(1));
                        }
                    } catch (Exception e) {
                        System.out.println("--- Table: " + table + " --- ERROR: " + e.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
