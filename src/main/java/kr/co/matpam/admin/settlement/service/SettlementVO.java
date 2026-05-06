package kr.co.matpam.admin.settlement.service;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

public class SettlementVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long settlementId;
    private Long tenantId;
    private Long sellerCompanyId;
    private Long buyerCompanyId;
    private Date periodFrom;
    private Date periodTo;
    private BigDecimal salesAmount;
    private BigDecimal vatAmount;
    private String settlementStatus; // OPEN, CLOSED, CONFIRMED
    private Date createdAt;

    // Paging & Search
    private int pageIndex = 1;
    private int pageUnit = 10;
    private int pageSize = 10;
    private int firstIndex = 1;
    private int lastIndex = 1;
    private int recordCountPerPage = 10;
    private String opType;
    private String settleDate;

    // Getters and Setters
    public int getPageIndex() { return pageIndex; }
    public void setPageIndex(int pageIndex) { this.pageIndex = pageIndex; }
    public int getPageUnit() { return pageUnit; }
    public void setPageUnit(int pageUnit) { this.pageUnit = pageUnit; }
    public int getPageSize() { return pageSize; }
    public void setPageSize(int pageSize) { this.pageSize = pageSize; }
    public int getFirstIndex() { return firstIndex; }
    public void setFirstIndex(int firstIndex) { this.firstIndex = firstIndex; }
    public int getLastIndex() { return lastIndex; }
    public void setLastIndex(int lastIndex) { this.lastIndex = lastIndex; }
    public int getRecordCountPerPage() { return recordCountPerPage; }
    public void setRecordCountPerPage(int recordCountPerPage) { this.recordCountPerPage = recordCountPerPage; }
    public String getOpType() { return opType; }
    public void setOpType(String opType) { this.opType = opType; }
    public String getSettleDate() { return settleDate; }
    public void setSettleDate(String settleDate) { this.settleDate = settleDate; }
    public Long getSettlementId() { return settlementId; }
    public void setSettlementId(Long settlementId) { this.settlementId = settlementId; }
    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }
    public Long getSellerCompanyId() { return sellerCompanyId; }
    public void setSellerCompanyId(Long sellerCompanyId) { this.sellerCompanyId = sellerCompanyId; }
    public Long getBuyerCompanyId() { return buyerCompanyId; }
    public void setBuyerCompanyId(Long buyerCompanyId) { this.buyerCompanyId = buyerCompanyId; }
    public Date getPeriodFrom() { return periodFrom; }
    public void setPeriodFrom(Date periodFrom) { this.periodFrom = periodFrom; }
    public Date getPeriodTo() { return periodTo; }
    public void setPeriodTo(Date periodTo) { this.periodTo = periodTo; }
    public BigDecimal getSalesAmount() { return salesAmount; }
    public void setSalesAmount(BigDecimal salesAmount) { this.salesAmount = salesAmount; }
    public BigDecimal getVatAmount() { return vatAmount; }
    public void setVatAmount(BigDecimal vatAmount) { this.vatAmount = vatAmount; }
    public String getSettlementStatus() { return settlementStatus; }
    public void setSettlementStatus(String settlementStatus) { this.settlementStatus = settlementStatus; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
