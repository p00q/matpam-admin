package kr.co.matpam.admin;

import java.sql.*;
import java.io.*;

public class DbCodeExplorer {
    public static void main(String[] args) throws Exception {
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PrintWriter pw = new PrintWriter(new FileWriter("db_code_audit.txt"))) {
            
            String[] tables = {"TB_GROUP_CODE", "TB_CODE", "TB_DETAIL_CODE"};
            for (String table : tables) {
                pw.println("Table: " + table);
                try (Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("DESC " + table)) {
                    while (rs.next()) {
                        pw.println("  Field: " + rs.getString(1) + " | Type: " + rs.getString(2));
                    }
                } catch (Exception e) {
                    pw.println("  Error DESC: " + e.getMessage());
                }
                
                try (Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM " + table)) {
                    if (rs.next()) {
                        pw.println("  Row Count: " + rs.getInt(1));
                    }
                } catch (Exception e) {
                    pw.println("  Error COUNT: " + e.getMessage());
                }
                pw.println();
            }
        }
        System.out.println("Audit completed. Result saved to db_code_audit.txt");
    }
}
