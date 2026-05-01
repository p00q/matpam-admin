<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.DataSource, org.springframework.web.context.support.WebApplicationContextUtils, org.springframework.context.ApplicationContext"%>
<!DOCTYPE html>
<html>
<head>
    <title>DB Cleanup - Trim Spaces</title>
</head>
<body>
    <h3>Cleaning up Trailing Spaces in Code Tables</h3>
    <%
        try {
            ApplicationContext ac = WebApplicationContextUtils.getWebApplicationContext(config.getServletContext());
            DataSource ds = ac.getBean(DataSource.class);
            try (Connection conn = ds.getConnection()) {
                conn.setAutoCommit(false);
                try {
                    String[] tables = {"tb_group_code", "tb_code", "tb_detail_code"};
                    String[][] columns = {
                        {"CODE_GROUP_ID"},
                        {"CODE_GROUP_ID", "CODE_ID"},
                        {"CODE_GROUP_ID", "CODE_ID", "DETAIL_CODE_ID"}
                    };

                    for (int i = 0; i < tables.length; i++) {
                        String table = tables[i];
                        for (String col : columns[i]) {
                            String sql = "UPDATE " + table + " SET " + col + " = TRIM(" + col + ") WHERE " + col + " LIKE ' %' OR " + col + " LIKE '% '";
                            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                                int affected = ps.executeUpdate();
                                out.println("<p>Updated <b>" + table + "." + col + "</b>: " + affected + " rows trimmed.</p>");
                            }
                        }
                    }
                    conn.commit();
                    out.println("<h4>Cleanup Completed Successfully!</h4>");
                } catch (Exception e) {
                    conn.rollback();
                    throw e;
                }
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    %>
    <p><a href="admin/code/codeManagement.do">Return to Code Management</a></p>
</body>
</html>
