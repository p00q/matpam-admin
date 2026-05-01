package kr.co.matpam.admin.user.service;

import kr.co.matpam.common.service.MatpamBaseVO;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 구매업체 금융정보 (tb_buyer_financial) VO
 */
public class BuyerFinancialVO extends MatpamBaseVO {

    private Long buyerFinancialId;
    private Long buyerCompanyId;
    private BigDecimal creditLimitAmount;
    private String meatMoneyEnabled;
    private String status;
    private Date createdAt;
    private Date updatedAt;
    private Long updatedBy;

    // Getter & Setter
    public Long getBuyerFinancialId() { return buyerFinancialId; }
    public void setBuyerFinancialId(Long buyerFinancialId) { this.buyerFinancialId = buyerFinancialId; }

    public Long getBuyerCompanyId() { return buyerCompanyId; }
    public void setBuyerCompanyId(Long buyerCompanyId) { this.buyerCompanyId = buyerCompanyId; }

    public BigDecimal getCreditLimitAmount() { return creditLimitAmount; }
    public void setCreditLimitAmount(BigDecimal creditLimitAmount) { this.creditLimitAmount = creditLimitAmount; }

    public String getMeatMoneyEnabled() { return meatMoneyEnabled; }
    public void setMeatMoneyEnabled(String meatMoneyEnabled) { this.meatMoneyEnabled = meatMoneyEnabled; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public Long getUpdatedBy() { return updatedBy; }
    public void setUpdatedBy(Long updatedBy) { this.updatedBy = updatedBy; }
}
