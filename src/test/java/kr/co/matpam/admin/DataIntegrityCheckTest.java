package kr.co.matpam.admin;

import java.sql.*;
import org.junit.Test;

public class DataIntegrityCheckTest {
    @Test
    public void checkCounts() throws Exception {
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";
        
        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            Statement stmt = conn.createStatement();
            
            System.out.println("--- TB_MEMBER Status ---");
            ResultSet rs1 = stmt.executeQuery("SELECT op_type, del_yn, use_yn, COUNT(*) FROM tb_member GROUP BY op_type, del_yn, use_yn");
            while (rs1.next()) {
                System.out.println(String.format("OpType: %s, Del: %s, Use: %s -> Count: %d", 
                    rs1.getString(1), rs1.getString(2), rs1.getString(3), rs1.getInt(4)));
            }

            System.out.println("--- TB_ORDER Status ---");
            ResultSet rs2 = stmt.executeQuery("SELECT op_type, del_yn, use_yn, COUNT(*) FROM tb_order GROUP BY op_type, del_yn, use_yn");
            while (rs2.next()) {
                System.out.println(String.format("OpType: %s, Del: %s, Use: %s -> Count: %d", 
                    rs2.getString(1), rs2.getString(2), rs2.getString(3), rs2.getInt(4)));
            }
        }
    }
}
