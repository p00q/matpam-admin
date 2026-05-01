import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

public class DBRestorer {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/matpam_new?serverTimezone=Asia/Seoul&useUniCode=true&characterEncoding=utf8";
        String user = "root";
        String password = "root";

        String[] sqlFiles = {
            "USER_MANAGER_SQL_FINAL.sql",
            "src/main/resources/sql/matpam_update.sql"
        };

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            conn.setAutoCommit(false);
            Statement stmt = conn.createStatement();

            for (String filePath : sqlFiles) {
                System.out.println("Executing: " + filePath);
                String content = new String(Files.readAllBytes(Paths.get("d:/antigravity/matpam-admin/" + filePath)), "UTF-8");
                
                // Remove comments and split by semicolon
                String[] commands = content.split(";");
                for (String cmd : commands) {
                    String trimmedCmd = cmd.trim();
                    if (!trimmedCmd.isEmpty() && !trimmedCmd.startsWith("--") && !trimmedCmd.startsWith("/*")) {
                        try {
                            stmt.execute(trimmedCmd);
                        } catch (Exception e) {
                            System.err.println("Error executing command: " + trimmedCmd);
                            System.err.println(e.getMessage());
                        }
                    }
                }
            }
            conn.commit();
            System.out.println("Restoration completed successfully.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
