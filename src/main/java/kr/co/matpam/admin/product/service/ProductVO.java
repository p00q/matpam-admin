package kr.co.matpam.admin.product.service;

import java.io.Serializable;
import java.util.Date;
import kr.co.matpam.common.service.MatpamBaseVO;

/**
 * 통합 상품 관리 VO
 * tb_product 테이블 대응
 */
public class ProductVO extends MatpamBaseVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long productId;
    private Long tenantId;
    private Long sellerCompanyId;
    private String productCode;
    private String productName;
    private String itemKind;         // GOODS, SERVICE
    private String processingType;   // RAW_GOODS, PROCESSED_GOODS, PROCESS_SERVICE
    private String taxCategory;      // TAX_FREE, TAXABLE
    private String unitName;
    private String independentSaleYn; // Y, N
    private String stockManagedYn;    // Y, N
    private String saleStatus;        // ON_SALE, STOPPED, HIDDEN
    private String description;
    private String imageUrl;
    private Long createdBy;
    private Date createdAt;
    private Date updatedAt;

    // 조인용 필드
    private String sellerCompanyName;

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }

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

    public Long getCreatedBy() { return createdBy; }
    public void setCreatedBy(Long createdBy) { this.createdBy = createdBy; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public String getSellerCompanyName() { return sellerCompanyName; }
    public void setSellerCompanyName(String sellerCompanyName) { this.sellerCompanyName = sellerCompanyName; }
}
