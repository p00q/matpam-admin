package kr.co.matpam.admin.product.service;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 상품 가격 정책 VO
 * tb_product_price 테이블 대응
 */
public class ProductPriceVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long priceId;
    private Long productId;
    private Long tenantId;
    private Long channelId;
    private Long buyerCompanyId;
    private BigDecimal unitPrice;
    private String currencyCode;
    private Date effectiveFrom;
    private Date effectiveTo;
    private String status;        // ACTIVE, INACTIVE
    private Long approvedBy;
    private Date createdAt;

    // 조인용 필드
    private String channelName;
    private String buyerCompanyName;

    public Long getPriceId() { return priceId; }
    public void setPriceId(Long priceId) { this.priceId = priceId; }

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }

    public Long getChannelId() { return channelId; }
    public void setChannelId(Long channelId) { this.channelId = channelId; }

    public Long getBuyerCompanyId() { return buyerCompanyId; }
    public void setBuyerCompanyId(Long buyerCompanyId) { this.buyerCompanyId = buyerCompanyId; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public String getCurrencyCode() { return currencyCode; }
    public void setCurrencyCode(String currencyCode) { this.currencyCode = currencyCode; }

    public Date getEffectiveFrom() { return effectiveFrom; }
    public void setEffectiveFrom(Date effectiveFrom) { this.effectiveFrom = effectiveFrom; }

    public Date getEffectiveTo() { return effectiveTo; }
    public void setEffectiveTo(Date effectiveTo) { this.effectiveTo = effectiveTo; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Long getApprovedBy() { return approvedBy; }
    public void setApprovedBy(Long approvedBy) { this.approvedBy = approvedBy; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getChannelName() { return channelName; }
    public void setChannelName(String channelName) { this.channelName = channelName; }

    public String getBuyerCompanyName() { return buyerCompanyName; }
    public void setBuyerCompanyName(String buyerCompanyName) { this.buyerCompanyName = buyerCompanyName; }
}
