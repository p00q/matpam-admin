package kr.co.matpam.admin.financial.service;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

public class CreditLedgerVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long creditLedgerId;
    private Long tenantId;
    private Long sellerCompanyId;
    private Long buyerCompanyId;
    private String txnType; // GRANT, REVOKE, ORDER_PAY, ORDER_CANCEL, ADJUST
    private BigDecimal amount;
    private BigDecimal balanceAfter;
    private String refTable;
    private Long refId;
    private String memo;
    private Long createdBy;
    private Date createdAt;

    // Getters and Setters
    public Long getCreditLedgerId() { return creditLedgerId; }
    public void setCreditLedgerId(Long creditLedgerId) { this.creditLedgerId = creditLedgerId; }
    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }
    public Long getSellerCompanyId() { return sellerCompanyId; }
    public void setSellerCompanyId(Long sellerCompanyId) { this.sellerCompanyId = sellerCompanyId; }
    public Long getBuyerCompanyId() { return buyerCompanyId; }
    public void setBuyerCompanyId(Long buyerCompanyId) { this.buyerCompanyId = buyerCompanyId; }
    public String getTxnType() { return txnType; }
    public void setTxnType(String txnType) { this.txnType = txnType; }
    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
    public BigDecimal getBalanceAfter() { return balanceAfter; }
    public void setBalanceAfter(BigDecimal balanceAfter) { this.balanceAfter = balanceAfter; }
    public String getRefTable() { return refTable; }
    public void setRefTable(String refTable) { this.refTable = refTable; }
    public Long getRefId() { return refId; }
    public void setRefId(Long refId) { this.refId = refId; }
    public String getMemo() { return memo; }
    public void setMemo(String memo) { this.memo = memo; }
    public Long getCreatedBy() { return createdBy; }
    public void setCreatedBy(Long createdBy) { this.createdBy = createdBy; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
