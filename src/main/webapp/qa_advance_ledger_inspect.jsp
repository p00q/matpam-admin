<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<html>
<body>
<h3>Advance Ledger for Buyer 3</h3>
<table border="1">
<tr>
    <th>ID</th><th>Seller ID</th><th>Txn Type</th><th>Amount</th><th>Balance After</th><th>Memo</th><th>Created At</th>
</tr>
<%
    WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());
    DataSource ds = (DataSource) wac.getBean("dataSource");
    Connection conn = null;
    try {
        conn = ds.getConnection();
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT advance_ledger_id, seller_company_id, txn_type, amount, balance_after, memo, created_at FROM tb_buyer_advance_ledger WHERE buyer_company_id = 3 ORDER BY advance_ledger_id DESC");
        while(rs.next()) {
%>
<tr>
    <td><%= rs.getLong(1) %></td>
    <td><%= rs.getLong(2) %></td>
    <td><%= rs.getString(3) %></td>
    <td><%= rs.getBigDecimal(4) %></td>
    <td><%= rs.getBigDecimal(5) %></td>
    <td><%= rs.getString(6) %></td>
    <td><%= rs.getTimestamp(7) %></td>
</tr>
<%
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if(conn != null) conn.close();
    }
%>
</table>
</body>
</html>
