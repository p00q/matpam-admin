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
        
        long tId = 1L;
        long sId = 2L;
        long bId = 3L;
        
        out.println("Testing SELECT for policy (1, 2, 3)...");
        String sql = "SELECT buyer_company_id FROM tb_buyer_credit_policy WHERE tenant_id = ? AND seller_company_id = ? AND buyer_company_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setLong(1, tId);
        pstmt.setLong(2, sId);
        pstmt.setLong(3, bId);
        
        ResultSet rs = pstmt.executeQuery();
        if(rs.next()) {
            out.println("FOUND! ID: " + rs.getLong(1));
        } else {
            out.println("NOT FOUND!");
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
