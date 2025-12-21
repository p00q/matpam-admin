package kr.co.matpam.admin.order.service;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 주문상품 (아이템) VO
 * - 주문 상세 화면의 상품 목록 행 데이터
 */
public class OrderItemVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long orderItemId;
    private Long orderId;
    private Long salesProdId;

    private String salesProdName;
    private String salesProdMainImgPath; // 상품 이미지 경로

    private BigDecimal salesPrice; // 판매단가
    private BigDecimal orderQty; // 주문수량

    private BigDecimal supplyAmt; // 공급가 (단가 * 수량)
    private BigDecimal vatAmt; // 부가세
    private BigDecimal totalAmt; // 판매가 합계

    /* 할인/배송비 (아이템 단위) */
    private BigDecimal itemDiscountAmt;
    private BigDecimal itemDeliveryAmt;

    /* Composition Info (For bundles) */
    private String compositionInfo; // 구성상품 정보 (HTML or Text)

    /*
     * =========================================================
     * Getter / Setter
     * =========================================================
     */
    public Long getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(Long orderItemId) {
        this.orderItemId = orderItemId;
    }

    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public Long getSalesProdId() {
        return salesProdId;
    }

    public void setSalesProdId(Long salesProdId) {
        this.salesProdId = salesProdId;
    }

    public String getSalesProdName() {
        return salesProdName;
    }

    public void setSalesProdName(String salesProdName) {
        this.salesProdName = salesProdName;
    }

    public String getSalesProdMainImgPath() {
        return salesProdMainImgPath;
    }

    public void setSalesProdMainImgPath(String salesProdMainImgPath) {
        this.salesProdMainImgPath = salesProdMainImgPath;
    }

    public BigDecimal getSalesPrice() {
        return salesPrice;
    }

    public void setSalesPrice(BigDecimal salesPrice) {
        this.salesPrice = salesPrice;
    }

    public BigDecimal getOrderQty() {
        return orderQty;
    }

    public void setOrderQty(BigDecimal orderQty) {
        this.orderQty = orderQty;
    }

    public BigDecimal getSupplyAmt() {
        return supplyAmt;
    }

    public void setSupplyAmt(BigDecimal supplyAmt) {
        this.supplyAmt = supplyAmt;
    }

    public BigDecimal getVatAmt() {
        return vatAmt;
    }

    public void setVatAmt(BigDecimal vatAmt) {
        this.vatAmt = vatAmt;
    }

    public BigDecimal getTotalAmt() {
        return totalAmt;
    }

    public void setTotalAmt(BigDecimal totalAmt) {
        this.totalAmt = totalAmt;
    }

    public BigDecimal getItemDiscountAmt() {
        return itemDiscountAmt;
    }

    public void setItemDiscountAmt(BigDecimal itemDiscountAmt) {
        this.itemDiscountAmt = itemDiscountAmt;
    }

    public BigDecimal getItemDeliveryAmt() {
        return itemDeliveryAmt;
    }

    public void setItemDeliveryAmt(BigDecimal itemDeliveryAmt) {
        this.itemDeliveryAmt = itemDeliveryAmt;
    }

    public String getCompositionInfo() {
        return compositionInfo;
    }

    public void setCompositionInfo(String compositionInfo) {
        this.compositionInfo = compositionInfo;
    }
}
