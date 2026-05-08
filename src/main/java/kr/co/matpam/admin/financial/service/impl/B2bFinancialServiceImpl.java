package kr.co.matpam.admin.financial.service.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import kr.co.matpam.admin.financial.service.B2bFinancialService;
import kr.co.matpam.admin.financial.service.CreditPolicyVO;
import kr.co.matpam.admin.financial.service.CreditLedgerVO;
import kr.co.matpam.admin.financial.service.AdvanceLedgerVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("b2bFinancialService")
@Transactional(rollbackFor = Exception.class)
public class B2bFinancialServiceImpl extends EgovAbstractServiceImpl implements B2bFinancialService {

    @Resource(name = "b2bFinancialMapper")
    private B2bFinancialMapper b2bFinancialMapper;

    @Override
    @Transactional(readOnly = true)
    public Map<String, BigDecimal> getFinancialSummary(Long tenantId, Long sellerCompanyId, Long buyerCompanyId) throws Exception {
        Map<String, Object> param = new HashMap<>();
        param.put("tenantId", tenantId);
        param.put("sellerCompanyId", sellerCompanyId);
        param.put("buyerCompanyId", buyerCompanyId);

        CreditLedgerVO lastCredit = b2bFinancialMapper.selectLatestB2bCreditLedger(param);
        BigDecimal credit = (lastCredit != null) ? lastCredit.getBalanceAfter() : BigDecimal.ZERO;

        AdvanceLedgerVO lastAdvance = b2bFinancialMapper.selectLatestB2bAdvanceLedger(param);
        BigDecimal advance = (lastAdvance != null) ? lastAdvance.getBalanceAfter() : BigDecimal.ZERO;

        Map<String, BigDecimal> summary = new HashMap<>();
        summary.put("credit", credit);
        summary.put("advance", advance);
        summary.put("total", credit.add(advance));
        
        return summary;
    }

    @Override
    @Transactional(readOnly = true)
    public BigDecimal getAvailableMeatMoney(Long tenantId, Long sellerCompanyId, Long buyerCompanyId) throws Exception {
        Map<String, BigDecimal> summary = getFinancialSummary(tenantId, sellerCompanyId, buyerCompanyId);
        return summary.get("total");
    }

    @Override
    public void adjustCreditLimit(Long tenantId, Long sellerCompanyId, Long buyerCompanyId, BigDecimal amount, String memo, Long createdBy) throws Exception {
        Map<String, Object> param = new HashMap<>();
        param.put("tenantId", tenantId);
        param.put("sellerCompanyId", sellerCompanyId);
        param.put("buyerCompanyId", buyerCompanyId);

        CreditPolicyVO policy = b2bFinancialMapper.selectB2bCreditPolicy(param);
        if (policy == null) {
            policy = new CreditPolicyVO();
            policy.setTenantId(tenantId);
            policy.setSellerCompanyId(sellerCompanyId);
            policy.setBuyerCompanyId(buyerCompanyId);
            policy.setCreditLimitAmount(BigDecimal.ZERO);
            policy.setStatus("ACTIVE");
            b2bFinancialMapper.insertB2bCreditPolicy(policy);
        }

        CreditLedgerVO last = b2bFinancialMapper.selectLatestB2bCreditLedger(param);
        BigDecimal prevBalance = (last != null) ? last.getBalanceAfter() : BigDecimal.ZERO;
        BigDecimal newBalance = prevBalance.add(amount);

        CreditLedgerVO ledger = new CreditLedgerVO();
        ledger.setTenantId(tenantId);
        ledger.setSellerCompanyId(sellerCompanyId);
        ledger.setBuyerCompanyId(buyerCompanyId);
        ledger.setTxnType(amount.compareTo(BigDecimal.ZERO) >= 0 ? "GRANT" : "REVOKE");
        ledger.setAmount(amount);
        ledger.setBalanceAfter(newBalance);
        ledger.setMemo(memo);
        ledger.setCreatedBy(createdBy);
        b2bFinancialMapper.insertB2bCreditLedger(ledger);

        policy.setCreditLimitAmount(newBalance);
        b2bFinancialMapper.updateB2bCreditLimit(policy);
    }

    @Override
    public void processAdvancePayment(Long tenantId, Long sellerCompanyId, Long buyerCompanyId, BigDecimal amount, String txnType, String memo, Long createdBy) throws Exception {
        Map<String, Object> param = new HashMap<>();
        param.put("tenantId", tenantId);
        param.put("sellerCompanyId", sellerCompanyId);
        param.put("buyerCompanyId", buyerCompanyId);

        AdvanceLedgerVO last = b2bFinancialMapper.selectLatestB2bAdvanceLedger(param);
        BigDecimal prevBalance = (last != null) ? last.getBalanceAfter() : BigDecimal.ZERO;
        BigDecimal newBalance = prevBalance.add(amount);

        AdvanceLedgerVO ledger = new AdvanceLedgerVO();
        ledger.setTenantId(tenantId);
        ledger.setSellerCompanyId(sellerCompanyId);
        ledger.setBuyerCompanyId(buyerCompanyId);
        ledger.setTxnType(txnType);
        ledger.setAmount(amount);
        ledger.setBalanceAfter(newBalance);
        ledger.setMemo(memo);
        ledger.setCreatedBy(createdBy);
        b2bFinancialMapper.insertB2bAdvanceLedger(ledger);
    }

    @Override
    public void payForOrder(Long orderId, BigDecimal amount, Long userId) throws Exception {
        // Implementation for order payment (can be added later)
    }

    @Override
    public void executeMeatMoneyPayment(Long tenantId, Long sellerCompanyId, Long buyerCompanyId, Long orderId, BigDecimal totalAmount, Long createdBy) throws Exception {
        BigDecimal remainAmount = totalAmount;
        Map<String, Object> param = new HashMap<>();
        param.put("tenantId", tenantId);
        param.put("sellerCompanyId", sellerCompanyId);
        param.put("buyerCompanyId", buyerCompanyId);

        // 1. Advance payment deduction
        AdvanceLedgerVO lastAdvance = b2bFinancialMapper.selectLatestB2bAdvanceLedger(param);
        BigDecimal currentAdvanceBalance = (lastAdvance != null) ? lastAdvance.getBalanceAfter() : BigDecimal.ZERO;

        if (currentAdvanceBalance.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal advanceToUse = currentAdvanceBalance.min(remainAmount);
            AdvanceLedgerVO ledger = new AdvanceLedgerVO();
            ledger.setTenantId(tenantId);
            ledger.setSellerCompanyId(sellerCompanyId);
            ledger.setBuyerCompanyId(buyerCompanyId);
            ledger.setTxnType("ORDER_PAY");
            ledger.setAmount(advanceToUse.negate());
            ledger.setBalanceAfter(currentAdvanceBalance.subtract(advanceToUse));
            ledger.setRefTable("tb_order");
            ledger.setRefId(orderId);
            ledger.setMemo("주문 결제 (선수금 차감)");
            ledger.setCreatedBy(createdBy);
            b2bFinancialMapper.insertB2bAdvanceLedger(ledger);
            remainAmount = remainAmount.subtract(advanceToUse);
        }

        // 2. Remaining amount credit deduction
        if (remainAmount.compareTo(BigDecimal.ZERO) > 0) {
            CreditLedgerVO lastCredit = b2bFinancialMapper.selectLatestB2bCreditLedger(param);
            BigDecimal currentCreditBalance = (lastCredit != null) ? lastCredit.getBalanceAfter() : BigDecimal.ZERO;

            if (currentCreditBalance.compareTo(remainAmount) < 0) {
                throw new Exception("가용 미트머니(여신)가 부족합니다.");
            }

            CreditLedgerVO ledger = new CreditLedgerVO();
            ledger.setTenantId(tenantId);
            ledger.setSellerCompanyId(sellerCompanyId);
            ledger.setBuyerCompanyId(buyerCompanyId);
            ledger.setTxnType("ORDER_PAY");
            ledger.setAmount(remainAmount.negate());
            ledger.setBalanceAfter(currentCreditBalance.subtract(remainAmount));
            ledger.setRefTable("tb_order");
            ledger.setRefId(orderId);
            ledger.setMemo("주문 결제 (여신 차감)");
            ledger.setCreatedBy(createdBy);
            b2bFinancialMapper.insertB2bCreditLedger(ledger);
        }
    }
}
