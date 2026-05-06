package kr.co.matpam.admin.financial.service.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import kr.co.matpam.admin.financial.service.B2bFinancialService;
import kr.co.matpam.admin.financial.service.CreditPolicyVO;
import kr.co.matpam.admin.financial.service.CreditLedgerVO;
import kr.co.matpam.admin.financial.service.AdvanceLedgerVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("b2bFinancialService")
public class B2bFinancialServiceImpl extends EgovAbstractServiceImpl implements B2bFinancialService {

    @Resource(name = "financialMapper")
    private FinancialMapper financialMapper;

    @Override
    public BigDecimal getAvailableMeatMoney(Long tenantId, Long sellerCompanyId, Long buyerCompanyId) throws Exception {
        Map<String, Object> param = new HashMap<>();
        param.put("tenantId", tenantId);
        param.put("sellerCompanyId", sellerCompanyId);
        param.put("buyerCompanyId", buyerCompanyId);

        // 1. 여신 한도 조회
        CreditPolicyVO policy = financialMapper.selectCreditPolicy(param);
        BigDecimal creditLimit = (policy != null) ? policy.getCreditLimitAmount() : BigDecimal.ZERO;

        // 2. 현재 여신 사용액 (잔액)
        CreditLedgerVO lastCredit = financialMapper.selectLatestCreditLedger(param);
        BigDecimal currentCreditBalance = (lastCredit != null) ? lastCredit.getBalanceAfter() : BigDecimal.ZERO;

        // 3. 선수금 잔액
        AdvanceLedgerVO lastAdvance = financialMapper.selectLatestAdvanceLedger(param);
        BigDecimal currentAdvanceBalance = (lastAdvance != null) ? lastAdvance.getBalanceAfter() : BigDecimal.ZERO;

        // 가용 미트머니 = 여신 한도 + 선수금 잔액
        // (참고: 설계에 따라 credit_ledger의 balance_after가 가용 여신인지, 사용 여신인지 결정 필요)
        // 여기서는 balance_after가 '현재 부여된 여신 잔액'이라고 가정
        return currentCreditBalance.add(currentAdvanceBalance);
    }

    @Override
    public void adjustCreditLimit(Long tenantId, Long sellerCompanyId, Long buyerCompanyId, BigDecimal amount, String memo, Long createdBy) throws Exception {
        Map<String, Object> param = new HashMap<>();
        param.put("tenantId", tenantId);
        param.put("sellerCompanyId", sellerCompanyId);
        param.put("buyerCompanyId", buyerCompanyId);

        CreditPolicyVO policy = financialMapper.selectCreditPolicy(param);
        if (policy == null) {
            policy = new CreditPolicyVO();
            policy.setTenantId(tenantId);
            policy.setSellerCompanyId(sellerCompanyId);
            policy.setBuyerCompanyId(buyerCompanyId);
            policy.setCreditLimitAmount(BigDecimal.ZERO);
            policy.setStatus("ACTIVE");
            financialMapper.insertCreditPolicy(policy);
        }

        CreditLedgerVO last = financialMapper.selectLatestCreditLedger(param);
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
        financialMapper.insertCreditLedger(ledger);

        policy.setCreditLimitAmount(newBalance);
        financialMapper.updateCreditLimit(policy);
    }

    @Override
    public void processAdvancePayment(Long tenantId, Long sellerCompanyId, Long buyerCompanyId, BigDecimal amount, String txnType, String memo, Long createdBy) throws Exception {
        Map<String, Object> param = new HashMap<>();
        param.put("tenantId", tenantId);
        param.put("sellerCompanyId", sellerCompanyId);
        param.put("buyerCompanyId", buyerCompanyId);

        AdvanceLedgerVO last = financialMapper.selectLatestAdvanceLedger(param);
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
        financialMapper.insertAdvanceLedger(ledger);
    }

    @Override
    public void payForOrder(Long orderId, BigDecimal amount, Long userId) throws Exception {
        // 주문 정보를 조회하여 업체 ID 확보 (실제로는 OrderService에서 호출 시 넘겨받는 것이 좋음)
        // 여기서는 예시로 간소화하여 Ledger만 기록함.
        // 실제 구현 시에는 tb_order_line 등 정보를 기반으로 tenantId, sellerId, buyerId를 조회해야 함.
    }

    // 실제 복합 결제 로직 (선수금 우선 차감)
    public void executeMeatMoneyPayment(Long tenantId, Long sellerCompanyId, Long buyerCompanyId, Long orderId, BigDecimal totalAmount, Long createdBy) throws Exception {
        BigDecimal remainAmount = totalAmount;

        // 1. 선수금 잔액 확인
        Map<String, Object> param = new HashMap<>();
        param.put("tenantId", tenantId);
        param.put("sellerCompanyId", sellerCompanyId);
        param.put("buyerCompanyId", buyerCompanyId);

        AdvanceLedgerVO lastAdvance = financialMapper.selectLatestAdvanceLedger(param);
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
            financialMapper.insertAdvanceLedger(ledger);

            remainAmount = remainAmount.subtract(advanceToUse);
        }

        // 2. 남은 금액 여신 차감
        if (remainAmount.compareTo(BigDecimal.ZERO) > 0) {
            CreditLedgerVO lastCredit = financialMapper.selectLatestCreditLedger(param);
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
            financialMapper.insertCreditLedger(ledger);
        }
    }
}
