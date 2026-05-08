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
    
    Connection conn = null;
    try {
        if(companyIdStr == null) throw new Exception("Required parameters missing");
        Long companyId = Long.parseLong(companyIdStr);
        
        conn = dataSource.getConnection();
        Long tenantId = 1L;
        Long sellerId = 2L; // [EXPERT] Enforce Seller 2 for Truth Consistency
        
        // 1. Credit
        BigDecimal credit = BigDecimal.ZERO;
        String sqlC = "SELECT balance_after FROM tb_buyer_credit_ledger WHERE tenant_id = ? AND seller_company_id = ? AND buyer_company_id = ? ORDER BY credit_ledger_id DESC LIMIT 1";
        PreparedStatement pstmt = conn.prepareStatement(sqlC);
        pstmt.setLong(1, tenantId);
        pstmt.setLong(2, sellerId);
        pstmt.setLong(3, companyId);
        ResultSet rs = pstmt.executeQuery();
        if(rs.next()) credit = rs.getBigDecimal(1);
        
        // 2. Advance
        BigDecimal advance = BigDecimal.ZERO;
        String sqlA = "SELECT balance_after FROM tb_buyer_advance_ledger WHERE tenant_id = ? AND seller_company_id = ? AND buyer_company_id = ? ORDER BY advance_ledger_id DESC LIMIT 1";
        pstmt = conn.prepareStatement(sqlA);
        pstmt.setLong(1, tenantId);
        pstmt.setLong(2, sellerId);
        pstmt.setLong(3, companyId);
        rs = pstmt.executeQuery();
        if(rs.next()) advance = rs.getBigDecimal(1);
        
        res.put("success", true);
        res.put("total", credit.add(advance));
        res.put("credit", credit);
        res.put("advance", advance);
        res.put("usedSellerId", sellerId);
        res.put("timestamp", new java.util.Date().toString());
    } catch (Exception e) {
        res.put("success", false);
        res.put("message", e.getMessage());
    } finally {
        if(conn != null) try { conn.close(); } catch (Exception e) {}
    }
    
    ObjectMapper mapper = new ObjectMapper();
    response.getWriter().write(mapper.writeValueAsString(res));
%>
