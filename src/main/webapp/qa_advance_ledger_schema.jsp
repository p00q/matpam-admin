<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<html>
<body>
<pre>
<%
    WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());
    DataSource ds = (DataSource) wac.getBean("dataSource");
    Connection conn = null;
    try {
        conn = ds.getConnection();
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SHOW CREATE TABLE tb_buyer_advance_ledger");
        if(rs.next()) {
            out.println(rs.getString(2));
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if(conn != null) conn.close();
    }
%>
</pre>
</body>
</html>
