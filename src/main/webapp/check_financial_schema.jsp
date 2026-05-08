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
        
        String[] tables = {"tb_buyer_credit_policy", "tb_buyer_credit_ledger", "tb_buyer_advance_ledger"};
        for(String table : tables) {
            out.println("--- DESC " + table + " ---");
            ResultSet rs = stmt.executeQuery("DESC " + table);
            while(rs.next()) {
                out.println(rs.getString(1) + " | " + rs.getString(2));
            }
            out.println();
        }
        
    } catch (Exception e) {
        out.println("ERROR: " + e.getMessage());
    } finally {
        if (stmt != null) try { stmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
