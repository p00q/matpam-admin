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

    private String searchStartDate;
    private String searchEndDate;

    private Long salesProdId;
    private String salesProdCode;
    private String salesProdName;

    private Long sellerMemberId;

    private BigDecimal listPrice = BigDecimal.ZERO;
    private BigDecimal costPrice;
    private BigDecimal vatAmount;
    private BigDecimal vatRate = BigDecimal.ZERO;
    private BigDecimal salePrice = BigDecimal.ZERO;
    private BigDecimal discountAmt = BigDecimal.ZERO;


    private String exposureStatusCd;
    private String saleStatusCd;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date saleStartDt;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date saleEndDt;

    private Long viewCnt = 0L;
    private String summary;
    private String mdComment;

    private String vatYn = "N";
    private String useYn = "Y";
    private String delYn = "N";

    private String sellerName;
    private List<?> componentList;
    private List<?> imageList;

    private List<SalesProductCompositionVO> compositionList;

    private String detailHtml;
    private String paymentInfo;
    private String deliveryInfo;
    private String returnInfo;
    private String refundInfo;

    // 추가 이미지 필드 (JSP 접근용)
    private String imgUrl1;
    private String imgUrl2;
    private String imgUrl3;

    public String getImgUrl1() { return imgUrl1; }
    public void setImgUrl1(String imgUrl1) { this.imgUrl1 = imgUrl1; }
    public String getImgUrl2() { return imgUrl2; }
    public void setImgUrl2(String imgUrl2) { this.imgUrl2 = imgUrl2; }
    public String getImgUrl3() { return imgUrl3; }
    public void setImgUrl3(String imgUrl3) { this.imgUrl3 = imgUrl3; }

    public Long getSalesProdId() { return salesProdId; }
    public void setSalesProdId(Long salesProdId) { this.salesProdId = salesProdId; }
    public String getSalesProdCode() { return salesProdCode; }
    public void setSalesProdCode(String salesProdCode) { this.salesProdCode = salesProdCode; }
    public String getSalesProdName() { return salesProdName; }
    public void setSalesProdName(String salesProdName) { this.salesProdName = salesProdName; }
    public Long getSellerMemberId() { return sellerMemberId; }
    public void setSellerMemberId(Long sellerMemberId) { this.sellerMemberId = sellerMemberId; }
    public BigDecimal getListPrice() { return listPrice; }
    public void setListPrice(BigDecimal listPrice) { this.listPrice = listPrice; }
    public BigDecimal getCostPrice() { return costPrice; }
    public void setCostPrice(BigDecimal costPrice) { this.costPrice = costPrice; }
    public BigDecimal getVatAmount() { return vatAmount; }
    public void setVatAmount(BigDecimal vatAmount) { this.vatAmount = vatAmount; }
    public BigDecimal getVatRate() { return vatRate; }
    public void setVatRate(BigDecimal vatRate) { this.vatRate = vatRate; }
    public BigDecimal getSalePrice() { return salePrice; }
    public void setSalePrice(BigDecimal salePrice) { this.salePrice = salePrice; }
    public String getExposureStatusCd() { return exposureStatusCd; }
    public void setExposureStatusCd(String exposureStatusCd) { this.exposureStatusCd = exposureStatusCd; }
    public String getSaleStatusCd() { return saleStatusCd; }
    public void setSaleStatusCd(String saleStatusCd) { this.saleStatusCd = saleStatusCd; }
    public Date getSaleStartDt() { return saleStartDt; }
    public void setSaleStartDt(Date saleStartDt) { this.saleStartDt = saleStartDt; }
    public void setSaleStartDt(String dateString) { this.saleStartDt = parseYmd(dateString); }
    public Date getSaleEndDt() { return saleEndDt; }
    public void setSaleEndDt(Date saleEndDt) { this.saleEndDt = saleEndDt; }
    public void setSaleEndDt(String dateString) { this.saleEndDt = parseYmd(dateString); }
    public Long getViewCnt() { return viewCnt; }
    public void setViewCnt(Long viewCnt) { this.viewCnt = viewCnt; }
    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }
    public String getMdComment() { return mdComment; }
    public void setMdComment(String mdComment) { this.mdComment = mdComment; }
    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }
    public String getDelYn() { return delYn; }
    public void setDelYn(String delYn) { this.delYn = delYn; }
    public String getVatYn() { return vatYn; }
    public void setVatYn(String vatYn) { this.vatYn = vatYn; }
    public BigDecimal getDiscountAmt() { return discountAmt; }
    public void setDiscountAmt(BigDecimal discountAmt) { this.discountAmt = discountAmt; }
    public String getSellerName() { return sellerName; }
    public void setSellerName(String sellerName) { this.sellerName = sellerName; }
    public List<?> getImageList() { return imageList; }
    public void setImageList(List<?> imageList) { this.imageList = imageList; }
    public List<?> getComponentList() { return componentList; }
    public void setComponentList(List<?> componentList) { this.componentList = componentList; }
    public String getDetailHtml() { return detailHtml; }
    public void setDetailHtml(String detailHtml) { this.detailHtml = detailHtml; }
    public String getPaymentInfo() { return paymentInfo; }
    public void setPaymentInfo(String paymentInfo) { this.paymentInfo = paymentInfo; }
    public String getDeliveryInfo() { return deliveryInfo; }
    public void setDeliveryInfo(String deliveryInfo) { this.deliveryInfo = deliveryInfo; }
    public String getReturnInfo() { return returnInfo; }
    public void setReturnInfo(String returnInfo) { this.returnInfo = returnInfo; }
    public String getRefundInfo() { return refundInfo; }
    public void setRefundInfo(String refundInfo) { this.refundInfo = refundInfo; }
    public List<SalesProductCompositionVO> getCompositionList() { return compositionList; }
    public void setCompositionList(List<SalesProductCompositionVO> compositionList) { this.compositionList = compositionList; }

    public String getSearchStartDate() { return searchStartDate; }
    public void setSearchStartDate(String searchStartDate) { this.searchStartDate = searchStartDate; }
    public String getSearchEndDate() { return searchEndDate; }
    public void setSearchEndDate(String searchEndDate) { this.searchEndDate = searchEndDate; }

    /** 편의 메서드: 실 판매가 (정가 - 할인액) */
    public BigDecimal getSalesPrice() {
        if (listPrice == null) return BigDecimal.ZERO;
        return listPrice.subtract(discountAmt != null ? discountAmt : BigDecimal.ZERO);
    }

    private Date parseYmd(String dateString) {
        if (dateString == null || dateString.trim().isEmpty()) return null;
        try {
            return new SimpleDateFormat("yyyy-MM-dd").parse(dateString.trim());
        } catch (ParseException e) {
            return null;
        }
    }
}
