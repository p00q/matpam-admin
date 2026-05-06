package kr.co.matpam.admin.financial.service;

import java.math.BigDecimal;
import java.util.Map;

public interface B2bFinancialService {
    
    /**
     * 가용 미트머니(여신 한도 + 선수금 잔액) 조회
     */
    BigDecimal getAvailableMeatMoney(Long tenantId, Long sellerCompanyId, Long buyerCompanyId) throws Exception;

    /**
     * 여신 한도 조정 (GRANT, REVOKE 등)
     */
    void adjustCreditLimit(Long tenantId, Long sellerCompanyId, Long buyerCompanyId, BigDecimal amount, String memo, Long createdBy) throws Exception;

    /**
     * 선수금 예치/인출 (DEPOSIT, WITHDRAW 등)
     */
    void processAdvancePayment(Long tenantId, Long sellerCompanyId, Long buyerCompanyId, BigDecimal amount, String txnType, String memo, Long createdBy) throws Exception;

    /**
     * 주문 결제 시 미트머니 차감
     */
    void payForOrder(Long orderId, BigDecimal amount, Long userId) throws Exception;

    /**
     * 복합 결제 실행 (선수금 우선 차감)
     */
    void executeMeatMoneyPayment(Long tenantId, Long sellerCompanyId, Long buyerCompanyId, Long orderId, BigDecimal totalAmount, Long createdBy) throws Exception;
}
