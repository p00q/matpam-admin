package kr.co.matpam.admin.product.service;

import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

/**
 * 판매상품 VO
 */
public class ProductVO implements Serializable {

    private static final long serialVersionUID = 1L;

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

    /** 검색조건 */
    private String searchCondition = "";

    /** 검색Keyword */
    private String searchKeyword = "";

    /** 검색 시작일 */
    private String searchStartDate;

    /** 검색 종료일 */
    private String searchEndDate;

    /** 상품번호 (PK) */
    private Long productNo;

    /** 상품명 */
    private String productName;

    /** 판매가격 */
    private Integer salePrice;

    /** 원가 */
    private Integer costPrice;

    /** 부가세 */
    private Integer vatAmount;

    /** 부가세율 */
    private Double vatRate;

    /** 판매 시작/종료일 */
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date saleStartDate;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date saleEndDate;

    /** 노출여부 (Y/N) */
    private String displayYn;

    /** 판매자ID */
    private Long sellerId;
    private String sellerName;

    /** 상품요약 */
    private String productSummary;

    /** MD 코멘트 */
    private String mdComment;

    /** 상품상세설명 */
    private String description;

    /** 안내 정보 */
    private String paymentInfo;
    private String shippingInfo;
    private String exchangeReturnInfo;
    private String refundInfo;

    /** 등록/수정일 */
    private String regId;
    private String modId;
    private Date regDt;
    private Date modDt;

    /** 구성상품 목록 */
    private List<ProductCompositionVO> compositionList;

    /** 상품 이미지 목록 */
    private List<ProductImageVO> imageList;

    // Getters and Setters

    public Integer getPageIndex() {
        return pageIndex;
    }

    public void setPageIndex(Integer pageIndex) {
        this.pageIndex = pageIndex;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }

    public Integer getFirstIndex() {
        return firstIndex;
    }

    public void setFirstIndex(Integer firstIndex) {
        this.firstIndex = firstIndex;
    }

    public Integer getLastIndex() {
        return lastIndex;
    }

    public void setLastIndex(Integer lastIndex) {
        this.lastIndex = lastIndex;
    }

    public Integer getRecordCountPerPage() {
        return recordCountPerPage;
    }

    public void setRecordCountPerPage(Integer recordCountPerPage) {
        this.recordCountPerPage = recordCountPerPage;
    }

    public Integer getPageUnit() {
        return pageUnit;
    }

    public void setPageUnit(Integer pageUnit) {
        this.pageUnit = pageUnit;
    }

    public String getSearchCondition() {
        return searchCondition;
    }

    public void setSearchCondition(String searchCondition) {
        this.searchCondition = searchCondition;
    }

    public String getSearchKeyword() {
        return searchKeyword;
    }

    public void setSearchKeyword(String searchKeyword) {
        this.searchKeyword = searchKeyword;
    }

    public String getSearchStartDate() {
        return searchStartDate;
    }

    public void setSearchStartDate(String searchStartDate) {
        this.searchStartDate = searchStartDate;
    }

    public String getSearchEndDate() {
        return searchEndDate;
    }

    public void setSearchEndDate(String searchEndDate) {
        this.searchEndDate = searchEndDate;
    }

    public Long getProductNo() {
        return productNo;
    }

    public void setProductNo(Long productNo) {
        this.productNo = productNo;
    }

    public void setProductNo(Integer productNo) {
        if (productNo != null) {
            this.productNo = productNo.longValue();
        } else {
            this.productNo = null;
        }
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
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

    public Double getVatRate() {
        return vatRate;
    }

    public void setVatRate(Double vatRate) {
        this.vatRate = vatRate;
    }

    public Date getSaleStartDate() {
        return saleStartDate;
    }

    public void setSaleStartDate(Date saleStartDate) {
        this.saleStartDate = saleStartDate;
    }

    // 문자열로 날짜를 받을 수 있는 setter 추가
    public void setSaleStartDate(String dateString) {
        if (dateString != null && !dateString.trim().isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                this.saleStartDate = sdf.parse(dateString);
            } catch (ParseException e) {
                // 파싱 실패 시 null로 유지
                this.saleStartDate = null;
            }
        }
    }

    public Date getSaleEndDate() {
        return saleEndDate;
    }

    public void setSaleEndDate(Date saleEndDate) {
        this.saleEndDate = saleEndDate;
    }

    // 문자열로 날짜를 받을 수 있는 setter 추가
    public void setSaleEndDate(String dateString) {
        if (dateString != null && !dateString.trim().isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                this.saleEndDate = sdf.parse(dateString);
            } catch (ParseException e) {
                // 파싱 실패 시 null로 유지
                this.saleEndDate = null;
            }
        }
    }

    public String getDisplayYn() {
        return displayYn;
    }

    public void setDisplayYn(String displayYn) {
        this.displayYn = displayYn;
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

    public String getProductSummary() {
        return productSummary;
    }

    public void setProductSummary(String productSummary) {
        this.productSummary = productSummary;
    }

    public String getMdComment() {
        return mdComment;
    }

    public void setMdComment(String mdComment) {
        this.mdComment = mdComment;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPaymentInfo() {
        return paymentInfo;
    }

    public void setPaymentInfo(String paymentInfo) {
        this.paymentInfo = paymentInfo;
    }

    public String getShippingInfo() {
        return shippingInfo;
    }

    public void setShippingInfo(String shippingInfo) {
        this.shippingInfo = shippingInfo;
    }

    public String getExchangeReturnInfo() {
        return exchangeReturnInfo;
    }

    public void setExchangeReturnInfo(String exchangeReturnInfo) {
        this.exchangeReturnInfo = exchangeReturnInfo;
    }

    public String getRefundInfo() {
        return refundInfo;
    }

    public void setRefundInfo(String refundInfo) {
        this.refundInfo = refundInfo;
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

    public Date getModDt() {
        return modDt;
    }

    public void setModDt(Date modDt) {
        this.modDt = modDt;
    }

    public List<ProductCompositionVO> getCompositionList() {
        return compositionList;
    }

    public void setCompositionList(List<ProductCompositionVO> compositionList) {
        this.compositionList = compositionList;
    }

    public List<ProductImageVO> getImageList() {
        return imageList;
    }

    public void setImageList(List<ProductImageVO> imageList) {
        this.imageList = imageList;
    }
}
