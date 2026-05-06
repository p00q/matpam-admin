import java.sql.*;

public class CheckDb {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/matpam_new?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        String user = "root";
        String pass = "root";
        
        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            System.out.println("--- TB_COMPANY ---");
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT company_id, company_name, company_type FROM tb_company")) {
                while (rs.next()) {
                    System.out.println(rs.getLong("company_id") + " | " + rs.getString("company_name") + " | " + rs.getString("company_type"));
                }
            }
            
            System.out.println("--- TB_BUYER_CREDIT_POLICY ---");
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT * FROM tb_buyer_credit_policy")) {
                while (rs.next()) {
                    System.out.println(rs.getLong("buyer_company_id") + " | Limit: " + rs.getBigDecimal("credit_limit_amount"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
