<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.DataSource, org.springframework.web.context.support.WebApplicationContextUtils, org.springframework.context.ApplicationContext"%>
<!DOCTYPE html>
<html>
<head>
    <title>Code Table Debug</title>
</head>
<body>
    <h3>TB_CODE Contents for CHANNEL_TYPE</h3>
    <table border="1">
        <tr>
            <th>GROUP_ID</th>
            <th>CODE_ID</th>
            <th>NAME</th>
            <th>DEL_YN</th>
            <th>Action</th>
        </tr>
        <%
            ApplicationContext ac = WebApplicationContextUtils.getWebApplicationContext(config.getServletContext());
            DataSource ds = ac.getBean(DataSource.class);
            String action = request.getParameter("action");
            String targetCode = request.getParameter("targetCode");

            if ("delete".equals(action) && targetCode != null) {
                try (Connection conn = ds.getConnection();
                     PreparedStatement ps = conn.prepareStatement("DELETE FROM tb_code WHERE CODE_GROUP_ID = 'CHANNEL_TYPE' AND CODE_ID = ?")) {
                    ps.setString(1, targetCode);
                    int affected = ps.executeUpdate();
                    out.println("<p style='color:blue;'>Deleted Code " + targetCode + ": " + affected + " rows affected.</p>");
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Delete Error: " + e.getMessage() + "</p>");
                }
            }

            try (Connection conn = ds.getConnection();
                 PreparedStatement ps = conn.prepareStatement("SELECT * FROM tb_code WHERE CODE_GROUP_ID = 'CHANNEL_TYPE'")) {
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        String id = rs.getString("CODE_ID");
                        out.println("<tr>");
                        out.println("<td>[" + rs.getString("CODE_GROUP_ID") + "]</td>");
                        out.println("<td>[" + id + "]</td>");
                        out.println("<td>" + rs.getString("CODE_NAME") + "</td>");
                        out.println("<td>" + rs.getString("DEL_YN") + "</td>");
                        out.println("<td><a href='?action=delete&targetCode=" + id + "'>Hard Delete</a></td>");
                        out.println("</tr>");
                    }
                }
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            }
        %>
    </table>
</body>
</html>
