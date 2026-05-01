package kr.co.matpam.common;
import java.sql.*;

public class DbChecker {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/matpam_new?serverTimezone=Asia/Seoul&useUniCode=true&characterEncoding=utf8";
        String user = "root";
        String pass = "root";
        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            System.out.println("Connected to matpam_new");
            Statement stmt = conn.createStatement();
            
            System.out.println("\n--- tb_group_code ---");
            ResultSet rs = stmt.executeQuery("SELECT CODE_GROUP_ID, CODE_GROUP_NAME FROM tb_group_code");
            while(rs.next()) {
                System.out.println(rs.getString(1) + " | " + rs.getString(2));
            }

            System.out.println("\n--- tb_code ---");
            rs = stmt.executeQuery("SELECT CODE_GROUP_ID, CODE_ID, CODE_NAME FROM tb_code");
            while(rs.next()) {
                System.out.println(rs.getString(1) + " | " + rs.getString(2) + " | " + rs.getString(3));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
