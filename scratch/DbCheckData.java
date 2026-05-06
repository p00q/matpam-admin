import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class DbCheckData {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/matpam_new?serverTimezone=UTC&useSSL=false";
        String user = "root";
        String password = "root"; // Verified from context-common.xml

        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement()) {
            
            System.out.println("--- tb_user table ---");
            ResultSet rs = stmt.executeQuery("SELECT login_id, role, password_hash FROM tb_user WHERE login_id = 'admin'");
            while (rs.next()) {
                System.out.println("Login ID: " + rs.getString("login_id"));
                System.out.println("Role: " + rs.getString("role"));
                System.out.println("Password Hash: " + rs.getString("password_hash"));
            }
            
            System.out.println("--- tb_company table ---");
            rs = stmt.executeQuery("SELECT company_id, company_name, company_type FROM tb_company");
            while (rs.next()) {
                System.out.println("ID: " + rs.getLong("company_id") + " | Name: " + rs.getString("company_name") + " | Type: " + rs.getString("company_type"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
