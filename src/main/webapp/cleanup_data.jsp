<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Data Cleanup - Company Type</title>
</head>
<body>
<%
    String url = "jdbc:mysql://localhost:3306/matpam_new?serverTimezone=Asia/Seoul&useUniCode=true&characterEncoding=utf8&allowMultiQueries=true";
    String user = "root";
    String pass = "root";
    
    Connection conn = null;
    Statement stmt = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);
        stmt = conn.createStatement();
        
        out.println("<h3>Cleaning up corrupted company_type data...</h3>");
        
        // 'BUYER,BUYER' 또는 'SELLER,SELLER' 등으로 저장된 데이터 복구
        String sql = "UPDATE tb_company SET company_type = 'BUYER' WHERE company_type LIKE 'BUYER,%' OR company_type LIKE '%,BUYER'";
        int updated = stmt.executeUpdate(sql);
        out.println("<p style='color:green;'>Fixed BUYER records: " + updated + "</p>");
        
        sql = "UPDATE tb_company SET company_type = 'SELLER' WHERE company_type LIKE 'SELLER,%' OR company_type LIKE '%,SELLER'";
        updated = stmt.executeUpdate(sql);
        out.println("<p style='color:green;'>Fixed SELLER records: " + updated + "</p>");
        
    } catch (Exception e) {
        out.println("<h2 style='color:red;'>Error: " + e.getMessage() + "</h2>");
    } finally {
        if (stmt != null) try { stmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
</body>
</html>
