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
        
        long companyId = 3;
        
        out.println("--- EMERGENCY CLEANUP FOR COMPANY 3 ---");
        
        // 1. 잘못 적재된 원장 데이터 삭제
        int deletedLedger1 = stmt.executeUpdate("DELETE FROM tb_buyer_credit_ledger WHERE buyer_company_id = " + companyId);
        int deletedLedger2 = stmt.executeUpdate("DELETE FROM tb_buyer_advance_ledger WHERE buyer_company_id = " + companyId);
        
        // 2. 정책 초기화 (0원)
        int updatedPolicy = stmt.executeUpdate("UPDATE tb_buyer_credit_policy SET credit_limit_amount = 0 WHERE buyer_company_id = " + companyId);
        
        out.println("Deleted Credit Ledger: " + deletedLedger1);
        out.println("Deleted Advance Ledger: " + deletedLedger2);
        out.println("Reset Policy: " + updatedPolicy);
        
    } catch (Exception e) {
        out.println("ERROR: " + e.getMessage());
    } finally {
        if (stmt != null) try { stmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
