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
        
        out.println("--- THE TRUTH: tb_buyer_credit_policy ---");
        ResultSet rs = stmt.executeQuery("SELECT * FROM tb_buyer_credit_policy WHERE buyer_company_id = 3");
        if(rs.next()) {
            out.println("RECORD FOUND! Balance: " + rs.getBigDecimal("credit_limit_amount"));
        } else {
            out.println("RECORD NOT FOUND!");
        }

        out.println("\n--- THE TRUTH: tb_buyer_credit_ledger ---");
        rs = stmt.executeQuery("SELECT COUNT(*) FROM tb_buyer_credit_ledger WHERE buyer_company_id = 3");
        if(rs.next()) out.println("Ledger Count: " + rs.getInt(1));
        
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if(conn != null) conn.close();
    }
%>
</pre>
</body>
</html>
