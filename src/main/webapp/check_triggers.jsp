<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
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
        
        out.println("--- CHECKING FOR TRIGGERS ---");
        ResultSet rs = stmt.executeQuery("SHOW TRIGGERS");
        boolean found = false;
        while(rs.next()) {
            out.println("Trigger: " + rs.getString(1) + " | Table: " + rs.getString(3));
            found = true;
        }
        if(!found) out.println("No triggers found.");
        
    } catch (Exception e) {
        out.println("ERROR: " + e.getMessage());
    } finally {
        if (stmt != null) try { stmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
