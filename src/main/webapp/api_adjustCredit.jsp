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
        BigDecimal amount = new BigDecimal(amountStr.replace(",", ""));
        
        conn = dataSource.getConnection();
        conn.setAutoCommit(false);
        
        Long tenantId = 1L;
        
        // [EXPERT] 판매자 우선순위 조정: 1번(본사)이 아닌 2번(실제 판매업체)을 우선 조회
        Long sellerId = null;
        String sqlGetSeller = "SELECT company_id FROM tb_company WHERE tenant_id = ? AND company_type = 'SELLER' AND company_id = 2 LIMIT 1";
        PreparedStatement pstmtSeller = conn.prepareStatement(sqlGetSeller);
        pstmtSeller.setLong(1, tenantId);
        ResultSet rsSeller = pstmtSeller.executeQuery();
        if(rsSeller.next()) {
            sellerId = rsSeller.getLong(1);
        } else {
            // 2번이 없으면 다른 SELLER 탐색
            sqlGetSeller = "SELECT company_id FROM tb_company WHERE tenant_id = ? AND company_type = 'SELLER' LIMIT 1";
            pstmtSeller = conn.prepareStatement(sqlGetSeller);
            pstmtSeller.setLong(1, tenantId);
            rsSeller = pstmtSeller.executeQuery();
            if(rsSeller.next()) sellerId = rsSeller.getLong(1);
            else sellerId = 1L; // 마지막 수단
        }

        // 1. Get current balance
        BigDecimal prevBalance = BigDecimal.ZERO;
        String sqlLast = "SELECT balance_after FROM tb_buyer_credit_ledger WHERE tenant_id = ? AND seller_company_id = ? AND buyer_company_id = ? ORDER BY created_at DESC, credit_ledger_id DESC LIMIT 1";
        PreparedStatement pstmt = conn.prepareStatement(sqlLast);
        pstmt.setLong(1, tenantId);
        pstmt.setLong(2, sellerId);
        pstmt.setLong(3, companyId);
        ResultSet rs = pstmt.executeQuery();
        if(rs.next()) prevBalance = rs.getBigDecimal(1);
        
        BigDecimal newBalance = prevBalance.add(amount);
        
        // 2. Insert Ledger
        String sqlInsert = "INSERT INTO tb_buyer_credit_ledger (tenant_id, seller_company_id, buyer_company_id, txn_type, amount, balance_after, memo, created_by, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        pstmt = conn.prepareStatement(sqlInsert);
        pstmt.setLong(1, tenantId);
        pstmt.setLong(2, sellerId);
        pstmt.setLong(3, companyId);
        pstmt.setString(4, amount.compareTo(BigDecimal.ZERO) >= 0 ? "GRANT" : "REVOKE");
        pstmt.setBigDecimal(5, amount);
        pstmt.setBigDecimal(6, newBalance);
        pstmt.setString(7, (memo == null || memo.isEmpty()) ? "EXPERT_ADJUST" : memo);
        pstmt.setLong(8, 1L);
        pstmt.executeUpdate();
        
        // 3. Update Policy
        String sqlPolicyCheck = "SELECT buyer_company_id FROM tb_buyer_credit_policy WHERE tenant_id = ? AND seller_company_id = ? AND buyer_company_id = ?";
        pstmt = conn.prepareStatement(sqlPolicyCheck);
        pstmt.setLong(1, tenantId);
        pstmt.setLong(2, sellerId);
        pstmt.setLong(3, companyId);
        if(pstmt.executeQuery().next()) {
            String sqlUpdate = "UPDATE tb_buyer_credit_policy SET credit_limit_amount = ?, updated_at = NOW() WHERE tenant_id = ? AND seller_company_id = ? AND buyer_company_id = ?";
            pstmt = conn.prepareStatement(sqlUpdate);
            pstmt.setBigDecimal(1, newBalance);
            pstmt.setLong(2, tenantId);
            pstmt.setLong(3, sellerId);
            pstmt.setLong(4, companyId);
            pstmt.executeUpdate();
        } else {
            String sqlInsertPolicy = "INSERT INTO tb_buyer_credit_policy (tenant_id, seller_company_id, buyer_company_id, credit_limit_amount, status, updated_at) VALUES (?, ?, ?, ?, 'ACTIVE', NOW())";
            pstmt = conn.prepareStatement(sqlInsertPolicy);
            pstmt.setLong(1, tenantId);
            pstmt.setLong(2, sellerId);
            pstmt.setLong(3, companyId);
            pstmt.setBigDecimal(4, newBalance);
            pstmt.executeUpdate();
        }
        
        conn.commit();
        
        res.put("success", true);
        res.put("credit", newBalance);
        res.put("usedSellerId", sellerId);
        
        // [EXPERT] Also return latest advance for total sync
        BigDecimal currentAdvance = BigDecimal.ZERO;
        String sqlAdvance = "SELECT balance_after FROM tb_buyer_advance_ledger WHERE tenant_id = ? AND seller_company_id = ? AND buyer_company_id = ? ORDER BY advance_ledger_id DESC LIMIT 1";
        pstmt = conn.prepareStatement(sqlAdvance);
        pstmt.setLong(1, tenantId);
        pstmt.setLong(2, sellerId);
        pstmt.setLong(3, companyId);
        rs = pstmt.executeQuery();
        if(rs.next()) currentAdvance = rs.getBigDecimal(1);
        
        res.put("advance", currentAdvance);
        res.put("total", newBalance.add(currentAdvance));
        
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
