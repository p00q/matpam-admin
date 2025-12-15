package kr.co.matpam.admin.product.service;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

/**
 * 구성상품 VO.
 */
public class BundleProductVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** UI에서 사용하던 번들 식별자 (productNo와 동일하게 사용 가능). */
    private Long bundleId;

    /** 상품번호 (PK) */
    private Long productNo;

    /** 페이지번호 */
    private Integer pageIndex = 1;

    /** 페이지사이즈 */
    private Integer pageSize = 10;

    /** firstIndex */
    private Integer firstIndex = 0;

    /** lastIndex */
    private Integer lastIndex = 1;

    /** recordCountPerPage */
    private Integer recordCountPerPage = 10;

    /** 페이지 유닛 */
    private Integer pageUnit = 10;

    /** 구성업체코드 */
    private Long componentCompCd;

    /** 구성상품코드 */
    private String componentGoodsCd;

    /** 상품코드 */
    private String goodsCd;

    /** 판매회원번호 */
    private Long saleMemberNo;

    /** 기존 로직 호환용 판매자 식별자 */
    private Long sellerId;

    /** 검색 및 표시용 판매자명 */
    private String sellerName;

    /** 상품명 (구성상품코드 대체 표시용) */
    private String productName;

    /** 저장유형 코드 */
    private String storageTypeCd;
    private String storageTypeName;

    /** 처리구분 코드 */
    private String processDivCd;
    private String processDivName;

    /** 재고단위 코드 */
    private String stockUnitCd;
    private String stockUnitName;

    /** 판매구분 코드 */
    private String saleDivCd;
    private String saleDivName;

    /** 기준수량 */
    private BigDecimal stdrQty;

    /** 구매정보 */
    private String poHubPurcCmpnyCd;
    private String poHubPurcSuplrDlvPlcCd;
    private String poHubPurcSuplrCd;
    private BigDecimal poHubPurcUnitCost;
    private String poHubPurcVatIncldYn;

    /** 부가세 자동 계산 여부 */
    private String autoVatCalYn;

    /** 기존 화면 호환용 부가세 자동 계산 여부 */
    private String autoVatYn;

    /** 가격 및 상태 (기존 화면 호환용) */
    private Integer costPrice;
    private Integer vatAmount;
    private Integer salePrice;
    private String saleStatus;
    private String saleStatusName;
    private String cutTypeCd;
    private String cutTypeName;
    private String exposureStatusCd;
    private String exposureStatusName;
    private String displayYn;
    private Integer totalSalesQty;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date saleStartDate;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date saleEndDate;

    /** 등록/수정자 및 일시 */
    private String regId;
    private String modId;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date regDt;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date modDt;

    /** 기존 호환용 수정 일시 */
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date updDt;

    /** 페이징 */

    public Long getBundleId() {
        return bundleId;
    }

    public void setBundleId(Long bundleId) {
        this.bundleId = bundleId;
    }

    public Long getProductNo() {
        return productNo;
    }

    public void setProductNo(Long productNo) {
        this.productNo = productNo;
    }

    public Long getComponentCompCd() {
        return componentCompCd;
    }

    public void setComponentCompCd(Long componentCompCd) {
        this.componentCompCd = componentCompCd;
    }

    public String getComponentGoodsCd() {
        return componentGoodsCd;
    }

    public void setComponentGoodsCd(String componentGoodsCd) {
        this.componentGoodsCd = componentGoodsCd;
    }

    public String getGoodsCd() {
        return goodsCd;
    }

    public void setGoodsCd(String goodsCd) {
        this.goodsCd = goodsCd;
    }

    public Long getSaleMemberNo() {
        return saleMemberNo;
    }

    public void setSaleMemberNo(Long saleMemberNo) {
        this.saleMemberNo = saleMemberNo;
    }

    public Long getSellerId() {
        return sellerId;
    }

    public void setSellerId(Long sellerId) {
        this.sellerId = sellerId;
    }

    public String getSellerName() {
        return sellerName;
    }

    public void setSellerName(String sellerName) {
        this.sellerName = sellerName;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
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

    public String getProcessDivCd() {
        return processDivCd;
    }

    public void setProcessDivCd(String processDivCd) {
        this.processDivCd = processDivCd;
    }

    public String getProcessDivName() {
        return processDivName;
    }

    public void setProcessDivName(String processDivName) {
        this.processDivName = processDivName;
    }

    public String getStockUnitCd() {
        return stockUnitCd;
    }

    public void setStockUnitCd(String stockUnitCd) {
        this.stockUnitCd = stockUnitCd;
    }

    public String getStockUnitName() {
        return stockUnitName;
    }

    public void setStockUnitName(String stockUnitName) {
        this.stockUnitName = stockUnitName;
    }

    public String getSaleDivCd() {
        return saleDivCd;
    }

    public void setSaleDivCd(String saleDivCd) {
        this.saleDivCd = saleDivCd;
    }

    public String getSaleDivName() {
        return saleDivName;
    }

    public void setSaleDivName(String saleDivName) {
        this.saleDivName = saleDivName;
    }

    public BigDecimal getStdrQty() {
        return stdrQty;
    }

    public void setStdrQty(BigDecimal stdrQty) {
        this.stdrQty = stdrQty;
    }

    public String getPoHubPurcCmpnyCd() {
        return poHubPurcCmpnyCd;
    }

    public void setPoHubPurcCmpnyCd(String poHubPurcCmpnyCd) {
        this.poHubPurcCmpnyCd = poHubPurcCmpnyCd;
    }

    public String getPoHubPurcSuplrDlvPlcCd() {
        return poHubPurcSuplrDlvPlcCd;
    }

    public void setPoHubPurcSuplrDlvPlcCd(String poHubPurcSuplrDlvPlcCd) {
        this.poHubPurcSuplrDlvPlcCd = poHubPurcSuplrDlvPlcCd;
    }

    public String getPoHubPurcSuplrCd() {
        return poHubPurcSuplrCd;
    }

    public void setPoHubPurcSuplrCd(String poHubPurcSuplrCd) {
        this.poHubPurcSuplrCd = poHubPurcSuplrCd;
    }

    public BigDecimal getPoHubPurcUnitCost() {
        return poHubPurcUnitCost;
    }

    public void setPoHubPurcUnitCost(BigDecimal poHubPurcUnitCost) {
        this.poHubPurcUnitCost = poHubPurcUnitCost;
    }

    public String getPoHubPurcVatIncldYn() {
        return poHubPurcVatIncldYn;
    }

    public void setPoHubPurcVatIncldYn(String poHubPurcVatIncldYn) {
        this.poHubPurcVatIncldYn = poHubPurcVatIncldYn;
    }

    public String getAutoVatCalYn() {
        return autoVatCalYn;
    }

    public void setAutoVatCalYn(String autoVatCalYn) {
        this.autoVatCalYn = autoVatCalYn;
    }

    public String getAutoVatYn() {
        return autoVatYn;
    }

    public void setAutoVatYn(String autoVatYn) {
        this.autoVatYn = autoVatYn;
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

    public Integer getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(Integer salePrice) {
        this.salePrice = salePrice;
    }

    public String getSaleStatus() {
        return saleStatus;
    }

    public void setSaleStatus(String saleStatus) {
        this.saleStatus = saleStatus;
    }

    public String getSaleStatusName() {
        return saleStatusName;
    }

    public void setSaleStatusName(String saleStatusName) {
        this.saleStatusName = saleStatusName;
    }

    public String getCutTypeCd() {
        return cutTypeCd;
    }

    public void setCutTypeCd(String cutTypeCd) {
        this.cutTypeCd = cutTypeCd;
    }

    public String getCutTypeName() {
        return cutTypeName;
    }

    public void setCutTypeName(String cutTypeName) {
        this.cutTypeName = cutTypeName;
    }

    public String getExposureStatusCd() {
        return exposureStatusCd;
    }

    public void setExposureStatusCd(String exposureStatusCd) {
        this.exposureStatusCd = exposureStatusCd;
    }

    public String getExposureStatusName() {
        return exposureStatusName;
    }

    public void setExposureStatusName(String exposureStatusName) {
        this.exposureStatusName = exposureStatusName;
    }

    public String getDisplayYn() {
        return displayYn;
    }

    public void setDisplayYn(String displayYn) {
        this.displayYn = displayYn;
    }

    public Integer getTotalSalesQty() {
        return totalSalesQty;
    }

    public void setTotalSalesQty(Integer totalSalesQty) {
        this.totalSalesQty = totalSalesQty;
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

    public String getRegId() {
        return regId;
    }

    public void setRegId(String regId) {
        this.regId = regId;
    }

    public String getModId() {
        return modId;
    }

    public void setModId(String modId) {
        this.modId = modId;
    }

    public Date getRegDt() {
        return regDt;
    }

    public void setRegDt(Date regDt) {
        this.regDt = regDt;
    }

    public Date getUpdDt() {
        return updDt;
    }

    public void setUpdDt(Date updDt) {
        this.updDt = updDt;
    }

    public Date getModDt() {
        return modDt;
    }

    public void setModDt(Date modDt) {
        this.modDt = modDt;
    }

    public Date getUpdDt() {
        return updDt;
    }

    public void setUpdDt(Date updDt) {
        this.updDt = updDt;
    }

    public Integer getRecordCountPerPage() {
        return recordCountPerPage;
    }

    public void setRecordCountPerPage(Integer recordCountPerPage) {
        this.recordCountPerPage = recordCountPerPage;
    }

    public Integer getFirstIndex() {
        return firstIndex;
    }

    public void setFirstIndex(Integer firstIndex) {
        this.firstIndex = firstIndex;
    }

    public Integer getPageIndex() {
        return pageIndex;
    }

    public void setPageIndex(Integer pageIndex) {
        this.pageIndex = pageIndex;
    }

    public Integer getPageUnit() {
        return pageUnit;
    }

    public void setPageUnit(Integer pageUnit) {
        this.pageUnit = pageUnit;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }

    public void setLastIndex(Integer lastIndex) {
        this.lastIndex = lastIndex;
    }

    public Integer getLastIndex() {
        return lastIndex;
    }

    public String getCutTypeCd() {
        return cutTypeCd;
    }

    public void setCutTypeCd(String cutTypeCd) {
        this.cutTypeCd = cutTypeCd;
    }

    public String getCutTypeName() {
        return cutTypeName;
    }

    public void setCutTypeName(String cutTypeName) {
        this.cutTypeName = cutTypeName;
    }

    public String getExposureStatusCd() {
        return exposureStatusCd;
    }

    public void setExposureStatusCd(String exposureStatusCd) {
        this.exposureStatusCd = exposureStatusCd;
    }

    public String getExposureStatusName() {
        return exposureStatusName;
    }

    public void setExposureStatusName(String exposureStatusName) {
        this.exposureStatusName = exposureStatusName;
    }
}
