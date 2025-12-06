package kr.co.matpam.admin.product.service;

import java.io.Serializable;
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

    /** 상품명 */
    private String productName;

    /** 저장유형 (냉장/냉동/상온 등) */
    private String storageType;
    private String storageTypeName;

    /** 처리유형 (세척/전처리 등) */
    private String processType;
    private String processTypeName;

    /** 분리유형 (부위/손질 등) */
    private String divisionType;
    private String divisionTypeName;

    /** 단위구분 (kg/팩/EA 등) */
    private String unitType;
    private String unitTypeName;

    /** 판매유형 (원물/가공 등) */
    private String saleType;
    private String saleTypeName;

    /** 판매자 회원번호 (FK: TB_MEMBER.MEMBER_NO) */
    private Long sellerId;
    private String sellerName;

    /** 원가 */
    private Integer costPrice;

    /** 부가세 */
    private Integer vatAmount;

    /** 부가세 자동 계산 여부 (Y/N) */
    private String autoVatYn;

    /** 판매가격 (원가 + 부가세) */
    private Integer salePrice;

    /** 판매상태 (판매중/중지/삭제 등) */
    private String saleStatus;
    private String saleStatusName;

    /** 노출상태 (Y/N) */
    private String displayYn;

    /** 판매 시작/종료일 */
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date saleStartDate;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date saleEndDate;

    /** 등록/수정일 */
    private Date regDt;
    private Date modDt;

    /** 페이징 */
    private Integer recordCountPerPage;
    private Integer firstIndex;
    private Integer pageIndex = 1;
    private Integer pageUnit = 10;
    private Integer pageSize = 10;

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

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getStorageType() {
        return storageType;
    }

    public void setStorageType(String storageType) {
        this.storageType = storageType;
    }

    public String getStorageTypeName() {
        return storageTypeName;
    }

    public void setStorageTypeName(String storageTypeName) {
        this.storageTypeName = storageTypeName;
    }

    public String getProcessType() {
        return processType;
    }

    public void setProcessType(String processType) {
        this.processType = processType;
    }

    public String getProcessTypeName() {
        return processTypeName;
    }

    public void setProcessTypeName(String processTypeName) {
        this.processTypeName = processTypeName;
    }

    public String getDivisionType() {
        return divisionType;
    }

    public void setDivisionType(String divisionType) {
        this.divisionType = divisionType;
    }

    public String getDivisionTypeName() {
        return divisionTypeName;
    }

    public void setDivisionTypeName(String divisionTypeName) {
        this.divisionTypeName = divisionTypeName;
    }

    public String getUnitType() {
        return unitType;
    }

    public void setUnitType(String unitType) {
        this.unitType = unitType;
    }

    public String getUnitTypeName() {
        return unitTypeName;
    }

    public void setUnitTypeName(String unitTypeName) {
        this.unitTypeName = unitTypeName;
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

    public String getAutoVatYn() {
        return autoVatYn;
    }

    public void setAutoVatYn(String autoVatYn) {
        this.autoVatYn = autoVatYn;
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

    public String getDisplayYn() {
        return displayYn;
    }

    public void setDisplayYn(String displayYn) {
        this.displayYn = displayYn;
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
}
