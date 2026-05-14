package kr.co.matpam.admin.financial.web;

import java.math.BigDecimal;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import javax.annotation.Resource;
import javax.sql.DataSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.http.HttpServletRequest;
import kr.co.matpam.admin.common.service.LoginVO;

@Controller
public class FinancialController {

    @Resource(name = "dataSource")
    private DataSource dataSource;

    @RequestMapping("/admin/financial/getMeatMoney.ajax")
    @ResponseBody
    public Map<String, Object> getMeatMoney(@RequestParam Long companyId, HttpServletRequest request) {
        Map<String, Object> res = new HashMap<>();
        Connection conn = null;
        try {
            LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
            if (loginVO == null) throw new Exception("로그인이 필요합니다.");

            conn = dataSource.getConnection();
            Long tenantId = loginVO.getCompanyId(); // 현재 LoginVO.companyId가 테넌트 ID 역할을 수행 중
            Long sellerId = loginVO.getCompanyId(); // 판매사 입장에서 조회 시 본인 ID
            
            if ("SUPER_ADMIN".equals(loginVO.getMemberType())) {
                tenantId = 1L; // 슈퍼관리자 기본값
                sellerId = 2L; // 기본 판매사 (맛팜)
            }
            
            // 1. 여신 잔액 조회
            BigDecimal credit = BigDecimal.ZERO;
            String sqlCredit = "SELECT balance_after FROM tb_buyer_credit_ledger WHERE tenant_id = ? AND seller_company_id = ? AND buyer_company_id = ? ORDER BY created_at DESC, credit_ledger_id DESC LIMIT 1";
            PreparedStatement pstmt = conn.prepareStatement(sqlCredit);
            pstmt.setLong(1, tenantId);
            pstmt.setLong(2, sellerId);
            pstmt.setLong(3, companyId);
            ResultSet rs = pstmt.executeQuery();
            if(rs.next()) credit = rs.getBigDecimal(1);
            
            // 2. 선수금 잔액 조회
            BigDecimal advance = BigDecimal.ZERO;
            String sqlAdvance = "SELECT balance_after FROM tb_buyer_advance_ledger WHERE tenant_id = ? AND seller_company_id = ? AND buyer_company_id = ? ORDER BY created_at DESC, advance_ledger_id DESC LIMIT 1";
            pstmt = conn.prepareStatement(sqlAdvance);
            pstmt.setLong(1, tenantId);
            pstmt.setLong(2, sellerId);
            pstmt.setLong(3, companyId);
            rs = pstmt.executeQuery();
            if(rs.next()) advance = rs.getBigDecimal(1);
            
            res.put("success", true);
            res.put("total", credit.add(advance));
            res.put("credit", credit);
            res.put("advance", advance);
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", e.getMessage());
        } finally {
            if(conn != null) try { conn.close(); } catch(Exception e) {}
        }
        return res;
    }

    @RequestMapping("/admin/financial/adjustCredit.ajax")
    @ResponseBody
    public Map<String, Object> adjustCredit(@RequestParam Long companyId, @RequestParam BigDecimal amount, @RequestParam String memo, HttpServletRequest request) {
        Map<String, Object> res = new HashMap<>();
        Connection conn = null;
        try {
            LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
            if (loginVO == null) throw new Exception("로그인이 필요합니다.");

            conn = dataSource.getConnection();
            conn.setAutoCommit(false); // 트랜잭션 수동 제어
            
            Long tenantId = loginVO.getCompanyId();
            Long sellerId = loginVO.getCompanyId();
            Long creatorId = loginVO.getMemberPk();
            
            if ("SUPER_ADMIN".equals(loginVO.getMemberType())) {
                tenantId = 1L;
                sellerId = 2L;
                creatorId = 1L;
            }
            
            // 1. 현재 잔액 조회
            BigDecimal prevBalance = BigDecimal.ZERO;
            String sqlLast = "SELECT balance_after FROM tb_buyer_credit_ledger WHERE tenant_id = ? AND seller_company_id = ? AND buyer_company_id = ? ORDER BY created_at DESC, credit_ledger_id DESC LIMIT 1";
            PreparedStatement pstmt = conn.prepareStatement(sqlLast);
            pstmt.setLong(1, tenantId);
            pstmt.setLong(2, sellerId);
            pstmt.setLong(3, companyId);
            ResultSet rs = pstmt.executeQuery();
            if(rs.next()) prevBalance = rs.getBigDecimal(1);
            
            BigDecimal newBalance = prevBalance.add(amount);
            
            // 2. 원장 기록
            String sqlInsert = "INSERT INTO tb_buyer_credit_ledger (tenant_id, seller_company_id, buyer_company_id, txn_type, amount, balance_after, memo, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sqlInsert);
            pstmt.setLong(1, tenantId);
            pstmt.setLong(2, sellerId);
            pstmt.setLong(3, companyId);
            pstmt.setString(4, amount.compareTo(BigDecimal.ZERO) >= 0 ? "GRANT" : "REVOKE");
            pstmt.setBigDecimal(5, amount);
            pstmt.setBigDecimal(6, newBalance);
            pstmt.setString(7, memo);
            pstmt.setLong(8, creatorId);
            pstmt.executeUpdate();
            
            // 3. 정책 업데이트 (업서트 시뮬레이션)
            String sqlPolicy = "INSERT INTO tb_buyer_credit_policy (tenant_id, seller_company_id, buyer_company_id, credit_limit_amount, status) VALUES (?, ?, ?, ?, 'ACTIVE') "
                             + "ON DUPLICATE KEY UPDATE credit_limit_amount = ?";
            pstmt = conn.prepareStatement(sqlPolicy);
            pstmt.setLong(1, tenantId);
            pstmt.setLong(2, sellerId);
            pstmt.setLong(3, companyId);
            pstmt.setBigDecimal(4, newBalance);
            pstmt.setBigDecimal(5, newBalance);
            pstmt.executeUpdate();
            
            conn.commit();
            res.put("success", true);
        } catch (Exception e) {
            if(conn != null) try { conn.rollback(); } catch(Exception ex) {}
            res.put("success", false);
            res.put("message", e.getMessage());
        } finally {
            if(conn != null) try { conn.close(); } catch(Exception e) {}
        }
        return res;
    }

    @RequestMapping("/admin/financial/depositAdvance.ajax")
    @ResponseBody
    public Map<String, Object> depositAdvance(@RequestParam Long companyId, @RequestParam BigDecimal amount, @RequestParam String memo, HttpServletRequest request) {
        Map<String, Object> res = new HashMap<>();
        Connection conn = null;
        try {
            LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
            if (loginVO == null) throw new Exception("로그인이 필요합니다.");

            conn = dataSource.getConnection();
            conn.setAutoCommit(false);
            
            Long tenantId = loginVO.getCompanyId();
            Long sellerId = loginVO.getCompanyId();
            Long creatorId = loginVO.getMemberPk();

            if ("SUPER_ADMIN".equals(loginVO.getMemberType())) {
                tenantId = 1L;
                sellerId = 2L;
                creatorId = 1L;
            }
            
            // 1. 현재 잔액 조회
            BigDecimal prevBalance = BigDecimal.ZERO;
            String sqlLast = "SELECT balance_after FROM tb_buyer_advance_ledger WHERE tenant_id = ? AND seller_company_id = ? AND buyer_company_id = ? ORDER BY created_at DESC, advance_ledger_id DESC LIMIT 1";
            PreparedStatement pstmt = conn.prepareStatement(sqlLast);
            pstmt.setLong(1, tenantId);
            pstmt.setLong(2, sellerId);
            pstmt.setLong(3, companyId);
            ResultSet rs = pstmt.executeQuery();
            if(rs.next()) prevBalance = rs.getBigDecimal(1);
            
            BigDecimal newBalance = prevBalance.add(amount);
            
            // 2. 원장 기록
            String sqlInsert = "INSERT INTO tb_buyer_advance_ledger (tenant_id, seller_company_id, buyer_company_id, txn_type, amount, balance_after, memo, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sqlInsert);
            pstmt.setLong(1, tenantId);
            pstmt.setLong(2, sellerId);
            pstmt.setLong(3, companyId);
            pstmt.setString(4, "DEPOSIT");
            pstmt.setBigDecimal(5, amount);
            pstmt.setBigDecimal(6, newBalance);
            pstmt.setString(7, memo);
            pstmt.setLong(8, creatorId);
            pstmt.executeUpdate();
            
            conn.commit();
            res.put("success", true);
        } catch (Exception e) {
            if(conn != null) try { conn.rollback(); } catch(Exception ex) {}
            res.put("success", false);
            res.put("message", e.getMessage());
        } finally {
            if(conn != null) try { conn.close(); } catch(Exception e) {}
        }
        return res;
    }
}
