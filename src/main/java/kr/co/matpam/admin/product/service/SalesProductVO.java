package kr.co.matpam.admin.product.service;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import kr.co.matpam.common.service.MatpamBaseVO;

/**
 * 판매상품 VO
 * - TABLE : tb_sales_product
 * - NOTE : Lombok 미사용(컴파일 안정성)
 */
public class SalesProductVO extends MatpamBaseVO {

    private static final long serialVersionUID = 1L;

    /*
     * =========================================================
     * [A] 페이징/검색 (eGov 관례) -> MatpamBaseVO로 이동
     * =========================================================
     */
    private String searchStartDate; // yyyy-MM-dd
    private String searchEndDate; // yyyy-MM-dd

    /*
     * =========================================================
     * [B] tb_sales_product 컬럼 매핑
     * =========================================================
     */
    private Long salesProdId; // sales_prod_id (PK)
    private String salesProdCode; // sales_prod_code (UQ)
    private String salesProdName; // sales_prod_name

    private Long sellerMemberId; // seller_member_id (FK)

    private BigDecimal listPrice = BigDecimal.ZERO; // list_price (정가/판매가격)
    private BigDecimal costPrice; // cost_price
    private BigDecimal vatAmount; // vat_amount (상세 금액)
    private BigDecimal discountAmt = BigDecimal.ZERO; // discount_amt (할인 금액)

    private String opType; // op_type (NATIONAL, LOCAL, FACTORY)

    private String exposureStatusCd; // exposure_status_cd
    private String saleStatusCd; // sale_status_cd

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date saleStartDt; // sale_start_dt (date)
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date saleEndDt; // sale_end_dt (date)

    private Long viewCnt = 0L; // view_cnt
    private String summary; // summary
    private String mdComment; // md_comment

    private String vatYn = "N"; // vat_yn (과세여부: Y/N)
    private String useYn = "Y"; // use_yn
    private String delYn = "N"; // del_yn

    /*
     * =========================================================
     * [C] 화면/조인용 확장 필드(선택)
     * - 컴파일 안전하게 List<?>로 둠
     * =========================================================
     */
    private String sellerName;
    private List<?> componentList;
    private List<?> imageList;

    /**
     * 판매상품 구성 목록
     * - tb_sales_product_comp
     */
    private List<SalesProductCompositionVO> compositionList;

    /*
     * =========================================================
     * [D] 판매상품 상세(분리 테이블: tb_sales_product_detail)
     * =========================================================
     */
    private String detailHtml; // detail_html
    private String paymentInfo; // payment_info
    private String deliveryInfo; // delivery_info
    private String returnInfo; // return_info
    private String refundInfo; // refund_info

    /*
     * =========================================================
     * Getter / Setter : tb_sales_product
     * =========================================================
     */

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

    /*
     * =========================================================
     * Getter / Setter : tb_sales_product
     * =========================================================
     */
    public Long getSalesProdId() {
        return salesProdId;
    }

    public void setSalesProdId(Long salesProdId) {
        this.salesProdId = salesProdId;
    }

    public String getSalesProdCode() {
        return salesProdCode;
    }

    public void setSalesProdCode(String salesProdCode) {
        this.salesProdCode = salesProdCode;
    }

    public String getSalesProdName() {
        return salesProdName;
    }

    public void setSalesProdName(String salesProdName) {
        this.salesProdName = salesProdName;
    }

    public Long getSellerMemberId() {
        return sellerMemberId;
    }

    public void setSellerMemberId(Long sellerMemberId) {
        this.sellerMemberId = sellerMemberId;
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

    /** 문자열 바인딩 보조: yyyy-MM-dd */
    public void setSaleStartDt(String dateString) {
        this.saleStartDt = parseYmd(dateString);
    }

    public Date getSaleEndDt() {
        return saleEndDt;
    }

    public void setSaleEndDt(Date saleEndDt) {
        this.saleEndDt = saleEndDt;
    }

    /** 문자열 바인딩 보조: yyyy-MM-dd */
    public void setSaleEndDt(String dateString) {
        this.saleEndDt = parseYmd(dateString);
    }

    public Long getViewCnt() {
        return viewCnt;
    }

    public void setViewCnt(Long viewCnt) {
        this.viewCnt = viewCnt;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public String getMdComment() {
        return mdComment;
    }

    public void setMdComment(String mdComment) {
        this.mdComment = mdComment;
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

    public String getVatYn() {
        return vatYn;
    }

    public void setVatYn(String vatYn) {
        this.vatYn = vatYn;
    }

    /** 편의 메서드: 실 판매가 (정가 - 할인액) */
    public BigDecimal getSalesPrice() {
        if (listPrice == null) return BigDecimal.ZERO;
        return listPrice.subtract(discountAmt != null ? discountAmt : BigDecimal.ZERO);
    }

    public BigDecimal getDiscountAmt() {
        return discountAmt;
    }

    public void setDiscountAmt(BigDecimal discountAmt) {
        this.discountAmt = discountAmt;
    }

    public String getOpType() {
        return opType;
    }

    public void setOpType(String opType) {
        this.opType = opType;
    }


    /*
     * =========================================================
     * Getter / Setter : 확장 필드
     * =========================================================
     */
    public String getSellerName() {
        return sellerName;
    }

    public void setSellerName(String sellerName) {
        this.sellerName = sellerName;
    }

    public List<?> getImageList() {
        return imageList;
    }

    public void setImageList(List<?> imageList) {
        this.imageList = imageList;
    }

    public List<?> getComponentList() {
        return componentList;
    }

    public void setComponentList(List<?> componentList) {
        this.componentList = componentList;
    }

    public String getDetailHtml() {
        return detailHtml;
    }

    public void setDetailHtml(String detailHtml) {
        this.detailHtml = detailHtml;
    }

    public String getPaymentInfo() {
        return paymentInfo;
    }

    public void setPaymentInfo(String paymentInfo) {
        this.paymentInfo = paymentInfo;
    }

    public String getDeliveryInfo() {
        return deliveryInfo;
    }

    public void setDeliveryInfo(String deliveryInfo) {
        this.deliveryInfo = deliveryInfo;
    }

    public String getReturnInfo() {
        return returnInfo;
    }

    public void setReturnInfo(String returnInfo) {
        this.returnInfo = returnInfo;
    }

    public String getRefundInfo() {
        return refundInfo;
    }

    public void setRefundInfo(String refundInfo) {
        this.refundInfo = refundInfo;
    }

    /*
     * =========================================================
     * 내부 유틸
     * =========================================================
     */
    private Date parseYmd(String dateString) {
        if (dateString == null)
            return null;
        String s = dateString.trim();
        if (s.isEmpty())
            return null;
        try {
            return new SimpleDateFormat("yyyy-MM-dd").parse(s);
        } catch (ParseException e) {
            return null;
        }
    }

    // The following code block was provided in the instruction but could not be placed
    // inside parseYmd method as it would result in a syntax error and refers to
    // undefined variables 'product' and 'lineAmt'.
    // It seems to be a snippet for VAT calculation with a specific rounding mode.
    /*
                // 부가세 계산 (별도 합계 방식)
                BigDecimal lineVat = BigDecimal.ZERO;
                if ("Y".equals(product.getVatYn())) {
                    // 10% 별도 합계
                    lineVat = lineAmt.multiply(new BigDecimal("0.1")).setScale(0, java.math.RoundingMode.HALF_UP);
                }
    */

    public List<SalesProductCompositionVO> getCompositionList() {
        return compositionList;
    }

    public void setCompositionList(List<SalesProductCompositionVO> compositionList) {
        this.compositionList = compositionList;
    }
}
