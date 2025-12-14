package kr.co.matpam.admin.product.service;

import java.io.Serializable;
import java.util.Date;

/**
 * 판매상품 구성 VO
 */
public class ProductCompositionVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 구성ID */
    private Long compositionId;

    /** 판매상품번호 */
    private Long productNo;

    /** 구성상품번호 (Bundle) */
    private Long bundleId;

    /** 구성상품 정보 (Join용) */
    private String productName;
    private String saleType;
    private String saleTypeName;
    private String saleStatusName;
    private String storageTypeCd;
    private String storageTypeName;
    private Integer salePrice;
    private Integer costPrice;
    private Integer vatAmount;
    private Date saleStartDate;
    private Date saleEndDate;
    private String displayYn;
    private String sellerName;
    private String processTypeName;
    private String divisionTypeName; // cutType
    private Date regDt;
    private Date modDt;

    /** 정렬순서 */
    private Integer sortOrder;

    // Getters and Setters

    public Long getCompositionId() {
        return compositionId;
    }

    public void setCompositionId(Long compositionId) {
        this.compositionId = compositionId;
    }

    public Long getProductNo() {
        return productNo;
    }

    public void setProductNo(Long productNo) {
        this.productNo = productNo;
    }

    public Long getBundleId() {
        return bundleId;
    }

    public void setBundleId(Long bundleId) {
        this.bundleId = bundleId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getSaleType() {
        return saleType;
    }

    public void setSaleType(String saleType) {
        this.saleType = saleType;
    }

    public String getSaleTypeName() {
        return saleTypeName;
    }

    public void setSaleTypeName(String saleTypeName) {
        this.saleTypeName = saleTypeName;
    }

    public String getSaleStatusName() {
        return saleStatusName;
    }

    public void setSaleStatusName(String saleStatusName) {
        this.saleStatusName = saleStatusName;
    }

    public String getStorageTypeCd() {
        return storageTypeCd;
    }

    public void setStorageTypeCd(String storageTypeCd) {
        this.storageTypeCd = storageTypeCd;
    }

    public String getStorageTypeName() {
        return storageTypeName;
    }

    public void setStorageTypeName(String storageTypeName) {
        this.storageTypeName = storageTypeName;
    }

    public Integer getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(Integer salePrice) {
        this.salePrice = salePrice;
    }

    public Integer getCostPrice() {
        return costPrice;
    }

    public void setCostPrice(Integer costPrice) {
        this.costPrice = costPrice;
    }

    public Integer getVatAmount() {
        return vatAmount;
    }

    public void setVatAmount(Integer vatAmount) {
        this.vatAmount = vatAmount;
    }

    public Date getSaleStartDate() {
        return saleStartDate;
    }

    public void setSaleStartDate(Date saleStartDate) {
        this.saleStartDate = saleStartDate;
    }

    public Date getSaleEndDate() {
        return saleEndDate;
    }

    public void setSaleEndDate(Date saleEndDate) {
        this.saleEndDate = saleEndDate;
    }

    public String getDisplayYn() {
        return displayYn;
    }

    public void setDisplayYn(String displayYn) {
        this.displayYn = displayYn;
    }

    public String getSellerName() {
        return sellerName;
    }

    public void setSellerName(String sellerName) {
        this.sellerName = sellerName;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }

    public String getProcessTypeName() {
        return processTypeName;
    }

    public void setProcessTypeName(String processTypeName) {
        this.processTypeName = processTypeName;
    }

    public String getDivisionTypeName() {
        return divisionTypeName;
    }

    public void setDivisionTypeName(String divisionTypeName) {
        this.divisionTypeName = divisionTypeName;
    }

    public Date getRegDt() {
        return regDt;
    }

    public void setRegDt(Date regDt) {
        this.regDt = regDt;
    }

    public Date getModDt() {
        return modDt;
    }

    public void setModDt(Date modDt) {
        this.modDt = modDt;
    }
}
