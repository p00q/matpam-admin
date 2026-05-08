<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="java.util.*" %>
<%
    out.clear();
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    Map<String, Object> res = new HashMap<>();
    WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());
    DataSource dataSource = (DataSource) wac.getBean("dataSource");
    
    String companyIdStr = request.getParameter("companyId");
    String amountStr = request.getParameter("amount");
    String memo = request.getParameter("memo");
    
    Connection conn = null;
    try {
        if(companyIdStr == null || amountStr == null) throw new Exception("Required parameters missing");
        
        Long companyId = Long.parseLong(companyIdStr);
        // Robust numeric parsing
        String cleanAmount = amountStr.replaceAll("[^0-9.\\-]", "");
        if(cleanAmount.isEmpty()) throw new Exception("Invalid amount format");
        BigDecimal amount = new BigDecimal(cleanAmount);
        
        conn = dataSource.getConnection();
        conn.setAutoCommit(false);
        
        Long tenantId = 1L;
        
        // [EXPERT] Seller Priority: ENFORCE 2 for absolute truth
        Long sellerId = 2L; 
        
        // 1. Get current balance with row-level lock for absolute accuracy
        BigDecimal prevBalance = BigDecimal.ZERO;
        String sqlLast = "SELECT balance_after FROM tb_buyer_advance_ledger WHERE tenant_id = ? AND seller_company_id = ? AND buyer_company_id = ? ORDER BY advance_ledger_id DESC LIMIT 1 FOR UPDATE";
        PreparedStatement pstmt = conn.prepareStatement(sqlLast);
        pstmt.setLong(1, tenantId);
        pstmt.setLong(2, sellerId);
        pstmt.setLong(3, companyId);
        ResultSet rs = pstmt.executeQuery();
        if(rs.next()) prevBalance = rs.getBigDecimal(1);
        
        BigDecimal newBalance = prevBalance.add(amount);
        
        // 2. Insert Ledger
        String sqlInsert = "INSERT INTO tb_buyer_advance_ledger (tenant_id, seller_company_id, buyer_company_id, txn_type, amount, balance_after, memo, created_by, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        pstmt = conn.prepareStatement(sqlInsert);
        pstmt.setLong(1, tenantId);
        pstmt.setLong(2, sellerId);
        pstmt.setLong(3, companyId);
        pstmt.setString(4, "DEPOSIT");
        pstmt.setBigDecimal(5, amount);
        pstmt.setBigDecimal(6, newBalance);
        pstmt.setString(7, (memo == null || memo.isEmpty()) ? "HARDENED_DEPOSIT" : memo);
        pstmt.setLong(8, 1L);
        pstmt.executeUpdate();
        
        conn.commit(); // FORCE PHYSICAL WRITE
        
        res.put("success", true);
        res.put("advance", newBalance);
        res.put("usedSellerId", sellerId);
        
        // [EXPERT] Also return latest credit for total sync
        BigDecimal currentCredit = BigDecimal.ZERO;
        String sqlCredit = "SELECT balance_after FROM tb_buyer_credit_ledger WHERE tenant_id = ? AND seller_company_id = ? AND buyer_company_id = ? ORDER BY credit_ledger_id DESC LIMIT 1";
        pstmt = conn.prepareStatement(sqlCredit);
        pstmt.setLong(1, tenantId);
        pstmt.setLong(2, sellerId);
        pstmt.setLong(3, companyId);
        rs = pstmt.executeQuery();
        if(rs.next()) currentCredit = rs.getBigDecimal(1);
        
        res.put("credit", currentCredit);
        res.put("total", newBalance.add(currentCredit));
        
    } catch (Exception e) {
        if(conn != null) try { conn.rollback(); } catch(Exception ex) {}
        res.put("success", false);
        res.put("message", e.getMessage());
    } finally {
        if(conn != null) try { conn.close(); } catch (Exception e) {}
    }
    
    ObjectMapper mapper = new ObjectMapper();
    response.getWriter().write(mapper.writeValueAsString(res));
%>
