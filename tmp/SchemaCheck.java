
import java.sql.*;

public class SchemaCheck {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/matpam?serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";
        
        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            checkTable(conn, "tb_sales_product");
            checkTable(conn, "tb_component_product");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private static void checkTable(Connection conn, String tableName) throws SQLException {
        System.out.println("Checking table: " + tableName);
        DatabaseMetaData meta = conn.getMetaData();
        try (ResultSet rs = meta.getColumns(null, null, tableName, null)) {
            while (rs.next()) {
                System.out.println(rs.getString("COLUMN_NAME") + " - " + rs.getString("TYPE_NAME"));
            }
        }
    }
}
