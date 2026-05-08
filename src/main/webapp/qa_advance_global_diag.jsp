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
        
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM tb_buyer_advance_ledger");
        if(rs.next()) out.println("Total Advance Ledger Count: " + rs.getInt(1));
        
        rs = stmt.executeQuery("SELECT buyer_company_id, COUNT(*) FROM tb_buyer_advance_ledger GROUP BY buyer_company_id");
        while(rs.next()) out.println("Buyer ID: " + rs.getLong(1) + " | Count: " + rs.getInt(2));
        
        rs = stmt.executeQuery("SELECT * FROM tb_buyer_advance_ledger ORDER BY advance_ledger_id DESC LIMIT 5");
        ResultSetMetaData rsmd = rs.getMetaData();
        while(rs.next()) {
            for(int i=1; i<=rsmd.getColumnCount(); i++) out.print(rsmd.getColumnName(i) + ":" + rs.getObject(i) + " | ");
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
