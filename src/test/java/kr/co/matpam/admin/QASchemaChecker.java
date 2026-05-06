import java.sql.*;

public class QASchemaChecker {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/matpam_new?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass)) {
                DatabaseMetaData meta = conn.getMetaData();
                System.out.println("--- TABLES IN DATABASE ---");
                try (ResultSet rs = meta.getTables(null, null, "%", new String[]{"TABLE"})) {
                    while (rs.next()) {
                        System.out.println(rs.getString("TABLE_NAME"));
                    }
                }
                
                System.out.println("\n--- CHECKING FOR ORDERS/PAYMENTS ---");
                try (ResultSet rs = meta.getTables(null, null, "ORDERS", null)) {
                    if (rs.next()) System.out.println("Found table: ORDERS");
                }
                try (ResultSet rs = meta.getTables(null, null, "PAYMENTS", null)) {
                    if (rs.next()) System.out.println("Found table: PAYMENTS");
                }
                try (ResultSet rs = meta.getTables(null, null, "tb_order", null)) {
                    if (rs.next()) System.out.println("Found table: tb_order");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
