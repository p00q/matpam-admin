package kr.co.matpam.admin.financial.service;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

public class CreditPolicyVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long tenantId;
    private Long sellerCompanyId;
    private Long buyerCompanyId;
    private BigDecimal creditLimitAmount;
    private String status;
    private Date updatedAt;

    // Getters and Setters
    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }
    public Long getSellerCompanyId() { return sellerCompanyId; }
    public void setSellerCompanyId(Long sellerCompanyId) { this.sellerCompanyId = sellerCompanyId; }
    public Long getBuyerCompanyId() { return buyerCompanyId; }
    public void setBuyerCompanyId(Long buyerCompanyId) { this.buyerCompanyId = buyerCompanyId; }
    public BigDecimal getCreditLimitAmount() { return creditLimitAmount; }
    public void setCreditLimitAmount(BigDecimal creditLimitAmount) { this.creditLimitAmount = creditLimitAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}
