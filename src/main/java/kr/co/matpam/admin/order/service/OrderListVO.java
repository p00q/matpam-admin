package kr.co.matpam.admin.order.service;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import kr.co.matpam.common.service.MatpamBaseVO;

/**
 * 주문관리 목록 VO
 * - 주문건별 목록 1행 데이터
 */
public class OrderListVO extends MatpamBaseVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /*
     * =========================================================
     * tb_order 기본 컬럼
     * =========================================================
     */
    private Long orderId;
    private String orderNo;
    private Date orderDt;

    private String orderStatusCd;
    private String orderStatusName;

    private String deliveryTypeCd;
    private String deliveryTypeName;

    private String deliveryStatusCd;
    private String deliveryStatusName;

    /*
     * =========================================================
     * 금액 정보
     * =========================================================
     */
    private BigDecimal goodsTotalAmt;
    private BigDecimal deliveryTotalAmt;
    private BigDecimal discountTotalAmt;
    private BigDecimal vatTotalAmt;
    private BigDecimal payTotalAmt;

    /*
     * =========================================================
     * 구매자 정보 (조인)
     * =========================================================
     */
    private Long buyerMemberId;
    private String buyerCompanyName;

    /*
     * =========================================================
     * 주문상품 집계 (서브쿼리)
     * =========================================================
     */
    /** 대표 상품명 (첫 라인) */
    private String firstSalesProdName;

    /** 주문라인 수 */
    private Integer itemCount;

    /** 총 주문수량 */
    private BigDecimal totalOrderQty;

    /*
     * =========================================================
     * 지역 정보
     * =========================================================
     */
    private String regionSidoCd;
    private String regionSigunguCd;

    /*
     * =========================================================
     * 수취인 정보
     * =========================================================
     */
    private String receiverName;
    private String receiverMobile;

    /*
     * =========================================================
     * Getter / Setter
     * =========================================================
     */

    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public Date getOrderDt() {
        return orderDt;
    }

    public void setOrderDt(Date orderDt) {
        this.orderDt = orderDt;
    }

    public String getOrderStatusCd() {
        return orderStatusCd;
    }

    public void setOrderStatusCd(String orderStatusCd) {
        this.orderStatusCd = orderStatusCd;
    }

    public String getOrderStatusName() {
        return orderStatusName;
    }

    public void setOrderStatusName(String orderStatusName) {
        this.orderStatusName = orderStatusName;
    }

    public String getDeliveryTypeCd() {
        return deliveryTypeCd;
    }

    public void setDeliveryTypeCd(String deliveryTypeCd) {
        this.deliveryTypeCd = deliveryTypeCd;
    }

    public String getDeliveryTypeName() {
        return deliveryTypeName;
    }

    public void setDeliveryTypeName(String deliveryTypeName) {
        this.deliveryTypeName = deliveryTypeName;
    }

    public String getDeliveryStatusCd() {
        return deliveryStatusCd;
    }

    public void setDeliveryStatusCd(String deliveryStatusCd) {
        this.deliveryStatusCd = deliveryStatusCd;
    }

    public String getDeliveryStatusName() {
        return deliveryStatusName;
    }

    public void setDeliveryStatusName(String deliveryStatusName) {
        this.deliveryStatusName = deliveryStatusName;
    }

    public BigDecimal getGoodsTotalAmt() {
        return goodsTotalAmt;
    }

    public void setGoodsTotalAmt(BigDecimal goodsTotalAmt) {
        this.goodsTotalAmt = goodsTotalAmt;
    }

    public BigDecimal getDeliveryTotalAmt() {
        return deliveryTotalAmt;
    }

    public void setDeliveryTotalAmt(BigDecimal deliveryTotalAmt) {
        this.deliveryTotalAmt = deliveryTotalAmt;
    }

    public BigDecimal getDiscountTotalAmt() {
        return discountTotalAmt;
    }

    public void setDiscountTotalAmt(BigDecimal discountTotalAmt) {
        this.discountTotalAmt = discountTotalAmt;
    }

    public BigDecimal getVatTotalAmt() {
        return vatTotalAmt;
    }

    public void setVatTotalAmt(BigDecimal vatTotalAmt) {
        this.vatTotalAmt = vatTotalAmt;
    }

    public BigDecimal getPayTotalAmt() {
        return payTotalAmt;
    }

    public void setPayTotalAmt(BigDecimal payTotalAmt) {
        this.payTotalAmt = payTotalAmt;
    }

    public Long getBuyerMemberId() {
        return buyerMemberId;
    }

    public void setBuyerMemberId(Long buyerMemberId) {
        this.buyerMemberId = buyerMemberId;
    }

    public String getBuyerCompanyName() {
        return buyerCompanyName;
    }

    public void setBuyerCompanyName(String buyerCompanyName) {
        this.buyerCompanyName = buyerCompanyName;
    }

    public String getFirstSalesProdName() {
        return firstSalesProdName;
    }

    public void setFirstSalesProdName(String firstSalesProdName) {
        this.firstSalesProdName = firstSalesProdName;
    }

    public Integer getItemCount() {
        return itemCount;
    }

    public void setItemCount(Integer itemCount) {
        this.itemCount = itemCount;
    }

    public BigDecimal getTotalOrderQty() {
        return totalOrderQty;
    }

    public void setTotalOrderQty(BigDecimal totalOrderQty) {
        this.totalOrderQty = totalOrderQty;
    }

    public String getRegionSidoCd() {
        return regionSidoCd;
    }

    public void setRegionSidoCd(String regionSidoCd) {
        this.regionSidoCd = regionSidoCd;
    }

    public String getRegionSigunguCd() {
        return regionSigunguCd;
    }

    public void setRegionSigunguCd(String regionSigunguCd) {
        this.regionSigunguCd = regionSigunguCd;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getReceiverMobile() {
        return receiverMobile;
    }

    public void setReceiverMobile(String receiverMobile) {
        this.receiverMobile = receiverMobile;
    }
}
