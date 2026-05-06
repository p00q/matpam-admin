package kr.co.matpam.admin;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class DbCheckData {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/matpam_new?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 Statement stmt = conn.createStatement()) {
                
                try (Statement stmt0 = conn.createStatement()) {
                    stmt0.execute("SET FOREIGN_KEY_CHECKS = 0");
                }
                
                executeSqlFile(conn, "D:/antigravity/matpam-admin/full_b2b_init.sql");
                
                try (Statement stmt0 = conn.createStatement()) {
                    stmt0.execute("SET FOREIGN_KEY_CHECKS = 1");
                }
                
                // Re-insert admin with BCrypt
                System.out.println("--- Re-inserting admin account ---");
                org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder encoder = new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder();
                String encodedPassword = encoder.encode("admin1234");
                stmt.execute("INSERT INTO tb_user (tenant_id, login_id, password_hash, user_name, user_role, status) " +
                             "VALUES (NULL, 'admin', '" + encodedPassword + "', '슈퍼관리자', 'SUPER_ADMIN', 'ACTIVE') " +
                             "ON DUPLICATE KEY UPDATE password_hash = VALUES(password_hash)");
                
                System.out.println("--- Full Schema Creation Success! ---");
                
                System.out.println("--- Final Table List ---");
                try (ResultSet rs = conn.getMetaData().getTables(null, null, "%", new String[]{"TABLE"})) {
                    while (rs.next()) {
                        System.out.println("Table: " + rs.getString("TABLE_NAME"));
                    }
                }
                System.out.println("--- End of Final List ---");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void executeSqlFile(Connection conn, String filePath) throws Exception {
        System.out.println("--- Executing: " + filePath + " ---");
        String content = new String(java.nio.file.Files.readAllBytes(java.nio.file.Paths.get(filePath)), "UTF-8");
        // Improved split: handle comments better
        String[] statements = content.split(";");
        try (Statement stmt = conn.createStatement()) {
            for (String sql : statements) {
                String trimmedSql = sql.replaceAll("(?m)^--.*", "").replaceAll("(?s)/\\*.*?\\*/", "").trim();
                if (!trimmedSql.isEmpty()) {
                    try {
                        stmt.execute(trimmedSql);
                    } catch (Exception e) {
                        System.err.println("Error executing SQL in " + filePath + ": " + trimmedSql.substring(0, Math.min(trimmedSql.length(), 100)) + "...");
                        System.err.println("Reason: " + e.getMessage());
                    }
                }
            }
        }
    }
}
