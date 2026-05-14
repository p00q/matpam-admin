package kr.co.matpam.admin.financial.web;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.matpam.admin.common.service.LoginVO;

@Controller
public class FinancialController {

    @Resource(name = "dataSource")
    private DataSource dataSource;

    @RequestMapping("/admin/financial/getMeatMoney.ajax")
    @ResponseBody
    public Map<String, Object> getMeatMoney(@RequestParam Long companyId, HttpServletRequest request) {
        Map<String, Object> res = new HashMap<>();
        try (Connection conn = dataSource.getConnection()) {
            FinancialScope scope = resolveScope(request);

            BigDecimal credit = selectLatestBalance(conn,
                    "SELECT balance_after FROM tb_buyer_credit_ledger "
                            + "WHERE tenant_id = ? AND seller_company_id = ? AND buyer_company_id = ? "
                            + "ORDER BY created_at DESC, credit_ledger_id DESC LIMIT 1",
                    scope, companyId);
            BigDecimal advance = selectLatestBalance(conn,
                    "SELECT balance_after FROM tb_buyer_advance_ledger "
                            + "WHERE tenant_id = ? AND seller_company_id = ? AND buyer_company_id = ? "
                            + "ORDER BY created_at DESC, advance_ledger_id DESC LIMIT 1",
                    scope, companyId);

            res.put("success", true);
            res.put("total", credit.add(advance));
            res.put("credit", credit);
            res.put("advance", advance);
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", e.getMessage());
        }
        return res;
    }

    @RequestMapping("/admin/financial/adjustCredit.ajax")
    @ResponseBody
    public Map<String, Object> adjustCredit(@RequestParam Long companyId,
                                            @RequestParam BigDecimal amount,
                                            @RequestParam String memo,
                                            HttpServletRequest request) {
        Map<String, Object> res = new HashMap<>();
        Connection conn = null;
        try {
            FinancialScope scope = resolveScope(request);
            conn = dataSource.getConnection();
            conn.setAutoCommit(false);

            BigDecimal prevBalance = selectLatestBalance(conn,
                    "SELECT balance_after FROM tb_buyer_credit_ledger "
                            + "WHERE tenant_id = ? AND seller_company_id = ? AND buyer_company_id = ? "
                            + "ORDER BY created_at DESC, credit_ledger_id DESC LIMIT 1",
                    scope, companyId);
            BigDecimal newBalance = prevBalance.add(amount);

            try (PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO tb_buyer_credit_ledger "
                            + "(tenant_id, seller_company_id, buyer_company_id, txn_type, amount, balance_after, memo, created_by) "
                            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {
                pstmt.setLong(1, scope.tenantId);
                pstmt.setLong(2, scope.sellerCompanyId);
                pstmt.setLong(3, companyId);
                pstmt.setString(4, amount.compareTo(BigDecimal.ZERO) >= 0 ? "GRANT" : "REVOKE");
                pstmt.setBigDecimal(5, amount);
                pstmt.setBigDecimal(6, newBalance);
                pstmt.setString(7, memo);
                pstmt.setLong(8, scope.creatorId);
                pstmt.executeUpdate();
            }

            try (PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO tb_buyer_credit_policy "
                            + "(tenant_id, seller_company_id, buyer_company_id, credit_limit_amount, status) "
                            + "VALUES (?, ?, ?, ?, 'ACTIVE') "
                            + "ON DUPLICATE KEY UPDATE credit_limit_amount = ?")) {
                pstmt.setLong(1, scope.tenantId);
                pstmt.setLong(2, scope.sellerCompanyId);
                pstmt.setLong(3, companyId);
                pstmt.setBigDecimal(4, newBalance);
                pstmt.setBigDecimal(5, newBalance);
                pstmt.executeUpdate();
            }

            conn.commit();
            res.put("success", true);
        } catch (Exception e) {
            rollbackQuietly(conn);
            res.put("success", false);
            res.put("message", e.getMessage());
        } finally {
            closeQuietly(conn);
        }
        return res;
    }

    @RequestMapping("/admin/financial/depositAdvance.ajax")
    @ResponseBody
    public Map<String, Object> depositAdvance(@RequestParam Long companyId,
                                              @RequestParam BigDecimal amount,
                                              @RequestParam String memo,
                                              HttpServletRequest request) {
        Map<String, Object> res = new HashMap<>();
        Connection conn = null;
        try {
            FinancialScope scope = resolveScope(request);
            conn = dataSource.getConnection();
            conn.setAutoCommit(false);

            BigDecimal prevBalance = selectLatestBalance(conn,
                    "SELECT balance_after FROM tb_buyer_advance_ledger "
                            + "WHERE tenant_id = ? AND seller_company_id = ? AND buyer_company_id = ? "
                            + "ORDER BY created_at DESC, advance_ledger_id DESC LIMIT 1",
                    scope, companyId);
            BigDecimal newBalance = prevBalance.add(amount);

            try (PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO tb_buyer_advance_ledger "
                            + "(tenant_id, seller_company_id, buyer_company_id, txn_type, amount, balance_after, memo, created_by) "
                            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {
                pstmt.setLong(1, scope.tenantId);
                pstmt.setLong(2, scope.sellerCompanyId);
                pstmt.setLong(3, companyId);
                pstmt.setString(4, "DEPOSIT");
                pstmt.setBigDecimal(5, amount);
                pstmt.setBigDecimal(6, newBalance);
                pstmt.setString(7, memo);
                pstmt.setLong(8, scope.creatorId);
                pstmt.executeUpdate();
            }

            conn.commit();
            res.put("success", true);
        } catch (Exception e) {
            rollbackQuietly(conn);
            res.put("success", false);
            res.put("message", e.getMessage());
        } finally {
            closeQuietly(conn);
        }
        return res;
    }

    private BigDecimal selectLatestBalance(Connection conn, String sql, FinancialScope scope, Long buyerCompanyId)
            throws Exception {
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, scope.tenantId);
            pstmt.setLong(2, scope.sellerCompanyId);
            pstmt.setLong(3, buyerCompanyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    BigDecimal balance = rs.getBigDecimal(1);
                    return balance != null ? balance : BigDecimal.ZERO;
                }
            }
        }
        return BigDecimal.ZERO;
    }

    private FinancialScope resolveScope(HttpServletRequest request) throws Exception {
        LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
        if (loginVO == null) {
            throw new Exception("로그인이 필요합니다.");
        }

        FinancialScope scope = new FinancialScope();
        scope.tenantId = loginVO.getTenantId() != null ? loginVO.getTenantId() : 1L;
        scope.sellerCompanyId = loginVO.getCompanyId();
        scope.creatorId = loginVO.getMemberPk();

        if ("SUPER_ADMIN".equals(loginVO.getMemberType())) {
            scope.sellerCompanyId = 2L;
            scope.creatorId = 1L;
        }
        return scope;
    }

    private void rollbackQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (Exception ignored) {
            }
        }
    }

    private void closeQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (Exception ignored) {
            }
        }
    }

    private static class FinancialScope {
        private Long tenantId;
        private Long sellerCompanyId;
        private Long creatorId;
    }
}
