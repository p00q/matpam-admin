package kr.co.matpam.admin.common.web;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.Statement;
import javax.annotation.Resource;
import javax.sql.DataSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class InitController {

    @Resource(name = "dataSource")
    private DataSource dataSource;

    @RequestMapping("/admin/init/db.do")
    @ResponseBody
    public String initDb() {
        StringBuilder result = new StringBuilder();
        String sqlPath = "D:/antigravity/matpam-admin/full_b2b_init.sql";
        
        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement();
             BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(sqlPath), "UTF-8"))) {
            
            conn.setAutoCommit(false);
            stmt.execute("SET FOREIGN_KEY_CHECKS = 0");
            
            StringBuilder sql = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().startsWith("--") || line.trim().isEmpty()) continue;
                sql.append(line).append(" ");
                if (line.trim().endsWith(";")) {
                    try {
                        stmt.execute(sql.toString());
                        sql.setLength(0);
                    } catch (Exception e) {
                        result.append("Error executing: ").append(sql).append(" -> ").append(e.getMessage()).append("<br>");
                        sql.setLength(0);
                    }
                }
            }
            
            stmt.execute("SET FOREIGN_KEY_CHECKS = 1");
            conn.commit();
            result.append("<h1>System Initialization Complete</h1>");
            result.append("<p>All tables recreated and initial data inserted based on full_b2b_init.sql</p>");
            
        } catch (Exception e) {
            e.printStackTrace();
            return "Critical Error: " + e.getMessage();
        }
        
        return result.toString();
    }
}
