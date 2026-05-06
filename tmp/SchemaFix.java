
import java.sql.*;

public class SchemaFix {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/matpam?serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";
        
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             Statement stmt = conn.createStatement()) {
            
            String[] alters = {
                "ALTER TABLE tb_product ADD COLUMN seller_company_id BIGINT NULL AFTER tenant_id",
                "ALTER TABLE tb_product ADD COLUMN tax_category VARCHAR(50) NULL AFTER processing_type",
                "ALTER TABLE tb_product ADD COLUMN unit_name VARCHAR(50) NULL AFTER tax_category",
                "ALTER TABLE tb_product ADD COLUMN description TEXT NULL",
                "ALTER TABLE tb_product ADD COLUMN image_url VARCHAR(500) NULL",
                "ALTER TABLE tb_product ADD COLUMN created_by BIGINT NULL"
            };
            
            for (String sql : alters) {
                try {
                    System.out.println("Executing: " + sql);
                    stmt.execute(sql);
                } catch (Exception e) {
                    System.out.println("Skipped or Error: " + e.getMessage());
                }
            }
            System.out.println("Done.");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
