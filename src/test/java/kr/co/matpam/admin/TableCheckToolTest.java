package kr.co.matpam.admin;

import java.sql.*;
import org.junit.Test;

public class TableCheckToolTest {
    @Test
    public void checkTables() throws Exception {
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";
        
        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            DatabaseMetaData meta = conn.getMetaData();
            ResultSet rs = meta.getTables("matpam", null, "%", new String[] {"TABLE"});
            
            System.out.println("Existing Tables in 'matpam' database:");
            while (rs.next()) {
                System.out.println("- " + rs.getString("TABLE_NAME"));
            }
        }
    }
}
