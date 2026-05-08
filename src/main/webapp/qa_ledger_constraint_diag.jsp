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
        
        out.println("--- Foreign Key Usage for tb_buyer_credit_ledger ---");
        String sql = "SELECT CONSTRAINT_NAME, COLUMN_NAME, REFERENCED_TABLE_SCHEMA, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME " +
                     "FROM information_schema.KEY_COLUMN_USAGE " +
                     "WHERE TABLE_SCHEMA = 'matpam_new' " +
                     "AND TABLE_NAME = 'tb_buyer_credit_ledger' " +
                     "AND REFERENCED_TABLE_NAME IS NOT NULL";
        
        ResultSet rs = stmt.executeQuery(sql);
        while(rs.next()) {
            out.println("FK: " + rs.getString("CONSTRAINT_NAME") + 
                        " | Column: " + rs.getString("COLUMN_NAME") + 
                        " | Target Schema: " + rs.getString("REFERENCED_TABLE_SCHEMA") + 
                        " | Target Table: " + rs.getString("REFERENCED_TABLE_NAME") + 
                        " | Target Column: " + rs.getString("REFERENCED_COLUMN_NAME"));
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
