package kr.co.matpam.admin.product.service;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 판매상품-구성상품 매핑 VO
 * - TABLE : tb_sales_product_comp
 * - PK : (salesProdId, componentProdId)
 */
public class SalesProductCompositionVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 판매상품ID (PK/FK) */
    private Long salesProdId;

    /** 구성상품ID (PK/FK) */
    private Long componentProdId;

    /** 구성수량 (DECIMAL(12,3)) */
    private BigDecimal compQty = new BigDecimal("1.000");

    /** 표시순서 */
    private Integer sortOrder = 1;

    /** 공통 */
    private String useYn = "Y";
    private String delYn = "N";
    private String regId;
    private Date regDt;
    private String modId;
    private Date modDt;

    /* ====== (선택) 조인/표시용 ====== */
    private String componentProdCode;
    private String componentProdName;

    private Long sellerMemberId;
    private String sellerName;

    private BigDecimal listPrice;
    private BigDecimal costPrice;
    private BigDecimal vatRate;
    private BigDecimal vatAmount;

    private String exposureStatusCd;
    private String saleStatusCd;
    private Date saleStartDt;
    private Date saleEndDt;

    /* ====== getter/setter ====== */

    public Long getSalesProdId() {
        return salesProdId;
    }

    public void setSalesProdId(Long salesProdId) {
        this.salesProdId = salesProdId;
    }

    public Long getComponentProdId() {
        return componentProdId;
    }

    public void setComponentProdId(Long componentProdId) {
        this.componentProdId = componentProdId;
    }

    public BigDecimal getCompQty() {
        return compQty;
    }

    public void setCompQty(BigDecimal compQty) {
        this.compQty = compQty;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public String getDelYn() {
        return delYn;
    }

    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public String getRegId() {
        return regId;
    }

    public void setRegId(String regId) {
        this.regId = regId;
    }

    public Date getRegDt() {
        return regDt;
    }

    public void setRegDt(Date regDt) {
        this.regDt = regDt;
    }

    public String getModId() {
        return modId;
    }

    public void setModId(String modId) {
        this.modId = modId;
    }

    public Date getModDt() {
        return modDt;
    }

    public void setModDt(Date modDt) {
        this.modDt = modDt;
    }

    public String getComponentProdCode() {
        return componentProdCode;
    }

    public void setComponentProdCode(String componentProdCode) {
        this.componentProdCode = componentProdCode;
    }

    public String getComponentProdName() {
        return componentProdName;
    }

    public void setComponentProdName(String componentProdName) {
        this.componentProdName = componentProdName;
    }

    public Long getSellerMemberId() {
        return sellerMemberId;
    }

    public void setSellerMemberId(Long sellerMemberId) {
        this.sellerMemberId = sellerMemberId;
    }

    public String getSellerName() {
        return sellerName;
    }

    public void setSellerName(String sellerName) {
        this.sellerName = sellerName;
    }

    public BigDecimal getListPrice() {
        return listPrice;
    }

    public void setListPrice(BigDecimal listPrice) {
        this.listPrice = listPrice;
    }

    public BigDecimal getCostPrice() {
        return costPrice;
    }

    public void setCostPrice(BigDecimal costPrice) {
        this.costPrice = costPrice;
    }

    public BigDecimal getVatRate() {
        return vatRate;
    }

    public void setVatRate(BigDecimal vatRate) {
        this.vatRate = vatRate;
    }

    public BigDecimal getVatAmount() {
        return vatAmount;
    }

    public void setVatAmount(BigDecimal vatAmount) {
        this.vatAmount = vatAmount;
    }

    public String getExposureStatusCd() {
        return exposureStatusCd;
    }

    public void setExposureStatusCd(String exposureStatusCd) {
        this.exposureStatusCd = exposureStatusCd;
    }

    public String getSaleStatusCd() {
        return saleStatusCd;
    }

    public void setSaleStatusCd(String saleStatusCd) {
        this.saleStatusCd = saleStatusCd;
    }

    public Date getSaleStartDt() {
        return saleStartDt;
    }

    public void setSaleStartDt(Date saleStartDt) {
        this.saleStartDt = saleStartDt;
    }

    public Date getSaleEndDt() {
        return saleEndDt;
    }

    public void setSaleEndDt(Date saleEndDt) {
        this.saleEndDt = saleEndDt;
    }
}
