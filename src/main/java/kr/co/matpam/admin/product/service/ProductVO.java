package kr.co.matpam.admin.product.service;

import java.math.BigDecimal;
import java.io.Serializable;
import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;
import kr.co.matpam.common.service.MatpamBaseVO;

/**
 * 통합 상품 관리 VO
 * tb_product 테이블 대응
 */
public class ProductVO extends MatpamBaseVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long productId;
    private Long tenantId;
    private Long channelId;
    private Long sellerCompanyId;
    private String productCode;
    private String productName;
    private String itemKind;         // GOODS, SERVICE
    private String processingType;   // RAW_GOODS, FINISHED_GOODS, PROCESSED_GOODS, PROCESS_SERVICE
    private String taxCategory;      // TAX_FREE, TAXABLE
    private String unitName;
    private String independentSaleYn; // Y, N
    private String stockManagedYn;    // Y, N
    private String saleStatus;        // ON_SALE, STOPPED, HIDDEN
    private String description;
    private String imageUrl;
    private BigDecimal supplyPrice;
    private BigDecimal vatAmount;
    private BigDecimal salePrice;
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private Date saleStartAt;
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private Date saleEndAt;
    private Integer displayOrder;
    private String mdComment;
    private String summary;
    private String isNew;
    private String isMonthly;
    private String isHidden;
    private String stockManageYn;
    private BigDecimal safetyStockQty;
    private BigDecimal deliveryFee;
    private String mainImageUrl;
    private String subImageUrl1;
    private String subImageUrl2;
    private String subImageUrl3;
    private Long[] recommendedProcessIdArray;
    private Long createdBy;
    private Date createdAt;
    private Date updatedAt;
    private Long codeBase;

    // 조인용 필드
    private String sellerCompanyName;

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }

    public Long getChannelId() { return channelId; }
    public void setChannelId(Long channelId) { this.channelId = channelId; }

    public Long getSellerCompanyId() { return sellerCompanyId; }
    public void setSellerCompanyId(Long sellerCompanyId) { this.sellerCompanyId = sellerCompanyId; }

    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getItemKind() { return itemKind; }
    public void setItemKind(String itemKind) { this.itemKind = itemKind; }

    public String getProcessingType() { return processingType; }
    public void setProcessingType(String processingType) { this.processingType = processingType; }

    public String getTaxCategory() { return taxCategory; }
    public void setTaxCategory(String taxCategory) { this.taxCategory = taxCategory; }

    public String getUnitName() { return unitName; }
    public void setUnitName(String unitName) { this.unitName = unitName; }

    public String getIndependentSaleYn() { return independentSaleYn; }
    public void setIndependentSaleYn(String independentSaleYn) { this.independentSaleYn = independentSaleYn; }

    public String getStockManagedYn() { return stockManagedYn; }
    public void setStockManagedYn(String stockManagedYn) { this.stockManagedYn = stockManagedYn; }

    public String getSaleStatus() { return saleStatus; }
    public void setSaleStatus(String saleStatus) { this.saleStatus = saleStatus; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public BigDecimal getSupplyPrice() { return supplyPrice; }
    public void setSupplyPrice(BigDecimal supplyPrice) { this.supplyPrice = supplyPrice; }

    public BigDecimal getVatAmount() { return vatAmount; }
    public void setVatAmount(BigDecimal vatAmount) { this.vatAmount = vatAmount; }

    public BigDecimal getSalePrice() { return salePrice; }
    public void setSalePrice(BigDecimal salePrice) { this.salePrice = salePrice; }

    public Date getSaleStartAt() { return saleStartAt; }
    public void setSaleStartAt(Date saleStartAt) { this.saleStartAt = saleStartAt; }

    public Date getSaleEndAt() { return saleEndAt; }
    public void setSaleEndAt(Date saleEndAt) { this.saleEndAt = saleEndAt; }

    public Integer getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(Integer displayOrder) { this.displayOrder = displayOrder; }

    public String getMdComment() { return mdComment; }
    public void setMdComment(String mdComment) { this.mdComment = mdComment; }

    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }

    public String getIsNew() { return isNew; }
    public void setIsNew(String isNew) { this.isNew = isNew; }

    public String getIsMonthly() { return isMonthly; }
    public void setIsMonthly(String isMonthly) { this.isMonthly = isMonthly; }

    public String getIsHidden() { return isHidden; }
    public void setIsHidden(String isHidden) { this.isHidden = isHidden; }

    public String getStockManageYn() { return stockManageYn; }
    public void setStockManageYn(String stockManageYn) { this.stockManageYn = stockManageYn; }

    public BigDecimal getSafetyStockQty() { return safetyStockQty; }
    public void setSafetyStockQty(BigDecimal safetyStockQty) { this.safetyStockQty = safetyStockQty; }

    public BigDecimal getDeliveryFee() { return deliveryFee; }
    public void setDeliveryFee(BigDecimal deliveryFee) { this.deliveryFee = deliveryFee; }

    public String getMainImageUrl() { return mainImageUrl; }
    public void setMainImageUrl(String mainImageUrl) { this.mainImageUrl = mainImageUrl; }

    public String getSubImageUrl1() { return subImageUrl1; }
    public void setSubImageUrl1(String subImageUrl1) { this.subImageUrl1 = subImageUrl1; }

    public String getSubImageUrl2() { return subImageUrl2; }
    public void setSubImageUrl2(String subImageUrl2) { this.subImageUrl2 = subImageUrl2; }

    public String getSubImageUrl3() { return subImageUrl3; }
    public void setSubImageUrl3(String subImageUrl3) { this.subImageUrl3 = subImageUrl3; }

    public Long[] getRecommendedProcessIdArray() { return recommendedProcessIdArray; }
    public void setRecommendedProcessIdArray(Long[] recommendedProcessIdArray) { this.recommendedProcessIdArray = recommendedProcessIdArray; }

    public String getRecommendedProcessIdCsv() {
        if (recommendedProcessIdArray == null || recommendedProcessIdArray.length == 0) {
            return ",";
        }
        StringBuilder sb = new StringBuilder(",");
        for (Long id : recommendedProcessIdArray) {
            if (id != null) {
                sb.append(id).append(",");
            }
        }
        return sb.toString();
    }

    public Long getCreatedBy() { return createdBy; }
    public void setCreatedBy(Long createdBy) { this.createdBy = createdBy; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public Long getCodeBase() { return codeBase; }
    public void setCodeBase(Long codeBase) { this.codeBase = codeBase; }

    public String getSellerCompanyName() { return sellerCompanyName; }
    public void setSellerCompanyName(String sellerCompanyName) { this.sellerCompanyName = sellerCompanyName; }
}
