package kr.co.matpam.admin.logistics.service;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class ShipmentVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long shipmentId;
    private Long orderId;
    private String shipmentNo;
    private String trackingNo;
    private String courierName;
    private String shipmentStatus; // PREPARING, SHIPPED, DELIVERED, CANCELLED
    private Date shippedAt;
    private Date deliveredAt;
    private Date createdAt;

    private List<ShipmentLineVO> shipmentLines;

    // Getters and Setters
    public Long getShipmentId() { return shipmentId; }
    public void setShipmentId(Long shipmentId) { this.shipmentId = shipmentId; }
    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }
    public String getShipmentNo() { return shipmentNo; }
    public void setShipmentNo(String shipmentNo) { this.shipmentNo = shipmentNo; }
    public String getTrackingNo() { return trackingNo; }
    public void setTrackingNo(String trackingNo) { this.trackingNo = trackingNo; }
    public String getCourierName() { return courierName; }
    public void setCourierName(String courierName) { this.courierName = courierName; }
    public String getShipmentStatus() { return shipmentStatus; }
    public void setShipmentStatus(String shipmentStatus) { this.shipmentStatus = shipmentStatus; }
    public Date getShippedAt() { return shippedAt; }
    public void setShippedAt(Date shippedAt) { this.shippedAt = shippedAt; }
    public Date getDeliveredAt() { return deliveredAt; }
    public void setDeliveredAt(Date deliveredAt) { this.deliveredAt = deliveredAt; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public List<ShipmentLineVO> getShipmentLines() { return shipmentLines; }
    public void setShipmentLines(List<ShipmentLineVO> shipmentLines) { this.shipmentLines = shipmentLines; }
}
