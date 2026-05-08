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
        
        out.println("--- DUMPING ALL tb_buyer_credit_policy records ---");
        ResultSet rs = stmt.executeQuery("SELECT * FROM tb_buyer_credit_policy");
        ResultSetMetaData rsmd = rs.getMetaData();
        int cols = rsmd.getColumnCount();
        while(rs.next()) {
            for(int i=1; i<=cols; i++) {
                out.print(rsmd.getColumnName(i) + ": " + rs.getObject(i) + " | ");
            }
            out.println();
        }
        
        out.println("\n--- DUMPING ALL tb_buyer_credit_ledger records ---");
        rs = stmt.executeQuery("SELECT * FROM tb_buyer_credit_ledger");
        rsmd = rs.getMetaData();
        cols = rsmd.getColumnCount();
        while(rs.next()) {
            for(int i=1; i<=cols; i++) {
                out.print(rsmd.getColumnName(i) + ": " + rs.getObject(i) + " | ");
            }
            out.println();
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
