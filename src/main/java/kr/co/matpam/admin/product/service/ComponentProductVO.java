package kr.co.matpam.admin.product.service;

import java.math.BigDecimal;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import kr.co.matpam.common.service.MatpamBaseVO;

/**
 * 구성상품 VO (tb_component_product 기준)
 * - MatpamBaseVO 상속 (opType, 페이징, 공통메타데이터)
 */
public class ComponentProductVO extends MatpamBaseVO {

    private static final long serialVersionUID = 1L;

    /*
     * =========================================================
     * tb_component_product (PK/기본정보)
     * =========================================================
     */
    private Long componentProdId;
    private String componentProdCode;
    private String componentProdName;
    private Long sellerMemberId;

    /*
     * =========================================================
     * tb_component_product (상품 속성 코드)
     * =========================================================
     */
    private String saleTypeCd;
    private String storageTypeCd;
    private String cutTypeCd;
    private String processTypeCd;
    private String unitTypeCd;

    /*
     * =========================================================
     * tb_component_product (금액/상태/기간)
     * =========================================================
     */
    private BigDecimal listPrice;
    private BigDecimal costPrice;

    /** 운영 타입 (NATIONAL, LOCAL, FACTORY) */
    private String opType;

    /** 과세 여부 (TAXABLE, FREE) */
    private String taxType;
    private String exposureStatusCd;
    private String saleStatusCd;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date saleStartDt;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date saleEndDt;

    private Long totalSaleQty;
    private String useYn;
    private String delYn;

    /*
     * =========================================================
     * 화면 표시용(조인/계산/코드명) - DB컬럼 아님
     * =========================================================
     */
    private String sellerName;
    private String saleTypeName;
    private String storageTypeName;
    private String cutTypeName;
    private String processTypeName;
    private String unitTypeName;
    private String exposureStatusName;
    private String saleStatusName;
    private BigDecimal vatAmount;

    /*
     * =========================================================
     * tb_sales_product_comp 연동용(선택)
     * =========================================================
     */
    private Long salesProdId;
    private BigDecimal compQty;
    private Integer sortOrder;

    // Getter / Setter
    public Long getComponentProdId() { return componentProdId; }
    public void setComponentProdId(Long componentProdId) { this.componentProdId = componentProdId; }

    public String getComponentProdCode() { return componentProdCode; }
    public void setComponentProdCode(String componentProdCode) { this.componentProdCode = componentProdCode; }

    public String getComponentProdName() { return componentProdName; }
    public void setComponentProdName(String componentProdName) { this.componentProdName = componentProdName; }

    public Long getSellerMemberId() { return sellerMemberId; }
    public void setSellerMemberId(Long sellerMemberId) { this.sellerMemberId = sellerMemberId; }

    public String getSaleTypeCd() { return saleTypeCd; }
    public void setSaleTypeCd(String saleTypeCd) { this.saleTypeCd = saleTypeCd; }

    public String getStorageTypeCd() { return storageTypeCd; }
    public void setStorageTypeCd(String storageTypeCd) { this.storageTypeCd = storageTypeCd; }

    public String getCutTypeCd() { return cutTypeCd; }
    public void setCutTypeCd(String cutTypeCd) { this.cutTypeCd = cutTypeCd; }

    public String getProcessTypeCd() { return processTypeCd; }
    public void setProcessTypeCd(String processTypeCd) { this.processTypeCd = processTypeCd; }

    public String getUnitTypeCd() { return unitTypeCd; }
    public void setUnitTypeCd(String unitTypeCd) { this.unitTypeCd = unitTypeCd; }

    public BigDecimal getListPrice() { return listPrice; }
    public void setListPrice(BigDecimal listPrice) { this.listPrice = listPrice; }

    public BigDecimal getCostPrice() { return costPrice; }
    public void setCostPrice(BigDecimal costPrice) { this.costPrice = costPrice; }

    public String getExposureStatusCd() { return exposureStatusCd; }
    public void setExposureStatusCd(String exposureStatusCd) { this.exposureStatusCd = exposureStatusCd; }

    public String getSaleStatusCd() { return saleStatusCd; }
    public void setSaleStatusCd(String saleStatusCd) { this.saleStatusCd = saleStatusCd; }

    public Date getSaleStartDt() { return saleStartDt; }
    public void setSaleStartDt(Date saleStartDt) { this.saleStartDt = saleStartDt; }

    public Date getSaleEndDt() { return saleEndDt; }
    public void setSaleEndDt(Date saleEndDt) { this.saleEndDt = saleEndDt; }

    public Long getTotalSaleQty() { return totalSaleQty; }
    public void setTotalSaleQty(Long totalSaleQty) { this.totalSaleQty = totalSaleQty; }

    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }

    public String getDelYn() { return delYn; }
    public void setDelYn(String delYn) { this.delYn = delYn; }

    public String getOpType() { return opType; }
    public void setOpType(String opType) { this.opType = opType; }

    public String getTaxType() { return taxType; }
    public void setTaxType(String taxType) { this.taxType = taxType; }

    public String getSellerName() { return sellerName; }
    public void setSellerName(String sellerName) { this.sellerName = sellerName; }

    public String getSaleTypeName() { return saleTypeName; }
    public void setSaleTypeName(String saleTypeName) { this.saleTypeName = saleTypeName; }

    public String getStorageTypeName() { return storageTypeName; }
    public void setStorageTypeName(String storageTypeName) { this.storageTypeName = storageTypeName; }

    public String getCutTypeName() { return cutTypeName; }
    public void setCutTypeName(String cutTypeName) { this.cutTypeName = cutTypeName; }

    public String getProcessTypeName() { return processTypeName; }
    public void setProcessTypeName(String processTypeName) { this.processTypeName = processTypeName; }

    public String getUnitTypeName() { return unitTypeName; }
    public void setUnitTypeName(String unitTypeName) { this.unitTypeName = unitTypeName; }

    public String getExposureStatusName() { return exposureStatusName; }
    public void setExposureStatusName(String exposureStatusName) { this.exposureStatusName = exposureStatusName; }

    public String getSaleStatusName() { return saleStatusName; }
    public void setSaleStatusName(String saleStatusName) { this.saleStatusName = saleStatusName; }

    public BigDecimal getVatAmount() { return vatAmount; }
    public void setVatAmount(BigDecimal vatAmount) { this.vatAmount = vatAmount; }

    public Long getSalesProdId() { return salesProdId; }
    public void setSalesProdId(Long salesProdId) { this.salesProdId = salesProdId; }

    public BigDecimal getCompQty() { return compQty; }
    public void setCompQty(BigDecimal compQty) { this.compQty = compQty; }

    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }

    // Legacy Aliases
    public Date getSaleStartDate() { return this.saleStartDt; }
    public void setSaleStartDate(Date d) { this.saleStartDt = d; }
    public Date getSaleEndDate() { return this.saleEndDt; }
    public void setSaleEndDate(Date d) { this.saleEndDt = d; }
    public String getDisplayYn() { return this.exposureStatusCd; }
    public void setDisplayYn(String yn) { this.exposureStatusCd = yn; }
    public String getProductName() { return this.componentProdName; }
    public void setProductName(String name) { this.componentProdName = name; }
}
