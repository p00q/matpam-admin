package kr.co.matpam.admin.logistics.service;

import java.io.Serializable;
import java.math.BigDecimal;

public class ShipmentLineVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long shipmentLineId;
    private Long shipmentId;
    private Long orderLineId;
    private BigDecimal shippedQty;

    // Getters and Setters
    public Long getShipmentLineId() { return shipmentLineId; }
    public void setShipmentLineId(Long shipmentLineId) { this.shipmentLineId = shipmentLineId; }
    public Long getShipmentId() { return shipmentId; }
    public void setShipmentId(Long shipmentId) { this.shipmentId = shipmentId; }
    public Long getOrderLineId() { return orderLineId; }
    public void setOrderLineId(Long orderLineId) { this.orderLineId = orderLineId; }
    public BigDecimal getShippedQty() { return shippedQty; }
    public void setShippedQty(BigDecimal shippedQty) { this.shippedQty = shippedQty; }
}
