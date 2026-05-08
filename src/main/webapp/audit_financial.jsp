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
        
        long companyId = 3; // PM님 테스트 업체
        
        out.println("=== [DEBUG] CREDIT LEDGER (ID: 3) ===");
        ResultSet rs = stmt.executeQuery("SELECT credit_ledger_id, txn_type, amount, balance_after, memo, created_at FROM tb_buyer_credit_ledger WHERE buyer_company_id = " + companyId + " ORDER BY created_at DESC");
        while(rs.next()) {
            out.println(String.format("[%d] %s | %f | Balance: %f | %s | %s", 
                rs.getLong(1), rs.getString(2), rs.getDouble(3), rs.getDouble(4), rs.getString(5), rs.getString(6)));
        }
        
        out.println("\n=== [DEBUG] ADVANCE LEDGER (ID: 3) ===");
        rs = stmt.executeQuery("SELECT advance_ledger_id, txn_type, amount, balance_after, memo, created_at FROM tb_buyer_advance_ledger WHERE buyer_company_id = " + companyId + " ORDER BY created_at DESC");
        while(rs.next()) {
            out.println(String.format("[%d] %s | %f | Balance: %f | %s | %s", 
                rs.getLong(1), rs.getString(2), rs.getDouble(3), rs.getDouble(4), rs.getString(5), rs.getString(6)));
        }
        
    } catch (Exception e) {
        out.println("ERROR: " + e.getMessage());
    } finally {
        if (stmt != null) try { stmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
