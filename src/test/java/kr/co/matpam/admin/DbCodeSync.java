package kr.co.matpam.admin;

import org.junit.Test;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class DbCodeSync {
    @Test
    public void syncCodeTables() throws Exception {
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Renaming code tables to match Mapper's TB_... pattern.");
            
            // 1. rename to_group_code to TB_GROUP_CODE
            try {
                stmt.execute("RENAME TABLE to_group_code TO TB_GROUP_CODE");
                System.out.println("- Renamed to_group_code to TB_GROUP_CODE");
            } catch (Exception e) {
                System.out.println("- RENAME to_group_code failed: " + e.getMessage());
            }

            // 2. rename to_code to TB_CODE
            try {
                stmt.execute("RENAME TABLE to_code TO TB_CODE");
                System.out.println("- Renamed to_code to TB_CODE");
            } catch (Exception e) {
                System.out.println("- RENAME to_code failed: " + e.getMessage());
            }
            
            // tb_detail_code might already be correct if case-insensitive, but let's be sure.
            try {
                stmt.execute("RENAME TABLE tb_detail_code TO TB_DETAIL_CODE");
                System.out.println("- Renamed tb_detail_code to TB_DETAIL_CODE");
            } catch (Exception e) {
                System.out.println("- RENAME tb_detail_code failed: " + e.getMessage());
            }
            
            System.out.println("Code table alignment complete.");
        }
    }
}
