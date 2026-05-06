package kr.co.matpam.admin.settlement.service;

import java.io.Serializable;
import java.math.BigDecimal;

public class SettlementLineVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long settlementLineId;
    private Long settlementId;
    private Long orderId;
    private BigDecimal amount;

    // Getters and Setters
    public Long getSettlementLineId() { return settlementLineId; }
    public void setSettlementLineId(Long settlementLineId) { this.settlementLineId = settlementLineId; }
    public Long getSettlementId() { return settlementId; }
    public void setSettlementId(Long settlementId) { this.settlementId = settlementId; }
    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }
    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
}
