import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import java.sql.*;

public class DbDump {
    public static void main(String[] args) throws Exception {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String hash = encoder.encode("admin1234");
        System.out.println("Generated Hash: " + hash);

        String url = "jdbc:mysql://localhost:3306/matpam_new?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";

        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            try (PreparedStatement pstmt = conn.prepareStatement("UPDATE tb_user SET password_hash = ? WHERE login_id = 'superadmin'")) {
                pstmt.setString(1, hash);
                int rows = pstmt.executeUpdate();
                System.out.println("Updated " + rows + " rows for superadmin");
            }
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
