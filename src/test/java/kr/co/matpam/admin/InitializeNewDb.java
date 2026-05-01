package kr.co.matpam.admin;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class InitializeNewDb {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/?serverTimezone=Asia/Seoul&useUniCode=true&characterEncoding=utf8";
        String user = "root";
        String password = "root";

        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement()) {

            System.out.println("Creating database matpam_new...");
            stmt.execute("CREATE DATABASE IF NOT EXISTS matpam_new CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
            stmt.execute("USE matpam_new");

            String sqlPath = "src/main/resources/sql/matpam_new.sql";
            System.out.println("Executing " + sqlPath + "...");
            String content = new String(Files.readAllBytes(Paths.get(sqlPath)));
            
            // Basic SQL splitter (might need improvement for complex triggers, but okay for standard DDL)
            String[] commands = content.split(";");
            for (String cmd : commands) {
                if (!cmd.trim().isEmpty()) {
                    try {
                        stmt.execute(cmd.trim());
                    } catch (Exception e) {
                        System.err.println("Error executing: " + cmd.substring(0, Math.min(50, cmd.length())) + "... : " + e.getMessage());
                    }
                }
            }

            System.out.println("Database initialization complete.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
