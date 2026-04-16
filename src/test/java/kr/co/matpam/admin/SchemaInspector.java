package kr.co.matpam.admin;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.io.PrintWriter;
import java.io.FileWriter;
import org.junit.Test;

public class SchemaInspector {
    @Test
    public void inspectSchema() {
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";

        try (PrintWriter out = new PrintWriter(new FileWriter("schema_out.txt"))) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 Statement stmt = conn.createStatement()) {
                
                String[] tables = {"tb_component_product", "tb_order", "tb_settlement"};
                for (String table : tables) {
                    out.println("--- Table: " + table + " ---");
                    try (ResultSet rs = stmt.executeQuery("DESCRIBE " + table)) {
                        while (rs.next()) {
                            out.println("Col: " + rs.getString(1));
                        }
                    } catch (Exception e) {
                        out.println("Table not found or error: " + e.getMessage());
                    }
                }
            }
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
