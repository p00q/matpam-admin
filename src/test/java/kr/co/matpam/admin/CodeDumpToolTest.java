package kr.co.matpam.admin;

import java.sql.*;
import org.junit.Test;

public class CodeDumpToolTest {
    @Test
    public void dumpCodes() throws Exception {
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";
        
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Dumping TB_DETAIL_CODE for verification...");
            
            ResultSet rs = stmt.executeQuery("SELECT CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME FROM tb_detail_code ORDER BY CODE_GROUP_ID, DETAIL_CODE_ID");
            
            System.out.printf("%-15s | %-15s | %-20s | %-20s\n", "GROUP", "CODE", "DETAIL_ID", "NAME");
            System.out.println("-----------------------------------------------------------------------------------------");
            while (rs.next()) {
                System.out.printf("%-15s | %-15s | %-20s | %-20s\n", 
                    rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4));
            }
        }
    }
}
