package kr.co.matpam.admin.order.service;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 주문 개별 상품 VO
 */
public class OrderItemVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long orderItemId;
    private Long orderId;
    
    private Long salesProdId;
    private String salesProdName;
    private String salesProdCode;
    
    private BigDecimal unitPrice;
    private Long qty;
    
    private BigDecimal itemOrderAmt;
    private BigDecimal itemVatAmt;
    private BigDecimal itemPayAmt;
    
    private String opType;

    public Long getOrderItemId() { return orderItemId; }
    public void setOrderItemId(Long orderItemId) { this.orderItemId = orderItemId; }
    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }
    public Long getSalesProdId() { return salesProdId; }
    public void setSalesProdId(Long salesProdId) { this.salesProdId = salesProdId; }
    public String getSalesProdName() { return salesProdName; }
    public void setSalesProdName(String salesProdName) { this.salesProdName = salesProdName; }
    public String getSalesProdCode() { return salesProdCode; }
    public void setSalesProdCode(String salesProdCode) { this.salesProdCode = salesProdCode; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
    public Long getQty() { return qty; }
    public void setQty(Long qty) { this.qty = qty; }
    public BigDecimal getItemOrderAmt() { return itemOrderAmt; }
    public void setItemOrderAmt(BigDecimal itemOrderAmt) { this.itemOrderAmt = itemOrderAmt; }
    public BigDecimal getItemVatAmt() { return itemVatAmt; }
    public void setItemVatAmt(BigDecimal itemVatAmt) { this.itemVatAmt = itemVatAmt; }
    public BigDecimal getItemPayAmt() { return itemPayAmt; }
    public void setItemPayAmt(BigDecimal itemPayAmt) { this.itemPayAmt = itemPayAmt; }
    public String getOpType() { return opType; }
    public void setOpType(String opType) { this.opType = opType; }
}
