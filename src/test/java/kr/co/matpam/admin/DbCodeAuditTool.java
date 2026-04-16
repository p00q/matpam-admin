package kr.co.matpam.admin;

import org.junit.Test;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;

public class DbCodeAuditTool {
    @Test
    public void dumpCodeSchema() throws Exception {
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";

        String[] tables = {"TB_GROUP_CODE", "TB_CODE", "TB_DETAIL_CODE"};

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             Statement stmt = conn.createStatement()) {
            
            for (String table : tables) {
                System.out.println("SCHEMA FOR " + table + ":");
                try (ResultSet rs = stmt.executeQuery("SELECT * FROM " + table + " LIMIT 1")) {
                    ResultSetMetaData md = rs.getMetaData();
                    for (int i = 1; i <= md.getColumnCount(); i++) {
                        System.out.println(md.getColumnName(i) + " (" + md.getColumnTypeName(i) + ")");
                    }
                } catch (Exception e) {
                    System.out.println("ERROR: " + e.getMessage());
                }
            }
        }
    }
}
