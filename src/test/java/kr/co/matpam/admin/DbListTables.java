package kr.co.matpam.admin;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;

public class DbListTables {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass)) {
                DatabaseMetaData meta = conn.getMetaData();
                try (ResultSet rs = meta.getTables("matpam", null, "%", new String[]{"TABLE"})) {
                    System.out.println("--- TABLES IN matpam DB ---");
                    while (rs.next()) {
                        System.out.println("Table: " + rs.getString("TABLE_NAME"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
