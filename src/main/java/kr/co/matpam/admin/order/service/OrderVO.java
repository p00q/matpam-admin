package kr.co.matpam.admin.order.service;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import kr.co.matpam.common.service.MatpamBaseVO;

/**
 * 주문 원장 VO
 * tb_order 테이블 대응
 */
public class OrderVO extends MatpamBaseVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long orderId;
    private Long tenantId;
    private String orderNo;
    private Long buyerCompanyId;
    private Long sellerCompanyId;
    private Date orderDate;
    private String orderStatus;      // RECEIVED, CONFIRMED, CANCELLED, COMPLETED
    private BigDecimal totalSupplyAmount;
    private BigDecimal totalVatAmount;
    private BigDecimal totalOrderAmount;
    private String paymentStatus;    // UNPAID, PARTIAL, PAID, OVERPAID
    private String shipmentStatus;   // NOT_STARTED, PARTIAL, SHIPPED, DELIVERED
    private String description;
    private Long createdBy;
    private Date createdAt;
    private Date updatedAt;

    // --- 레거시 호환용 필드 ---
    private String receiverAddrDetail;
    private List<OrderItemVO> orderItems; // 기존 OrderItemVO 참조
    private String orderStatusCd;         // 기존 상태 코드
    private String paymentStatusCd;        // 기존 결제 상태 코드

    // 조인용 필드
    private String buyerCompanyName;
    private String sellerCompanyName;
    private List<OrderLineVO> orderLines;

    public String getReceiverAddrDetail() { return receiverAddrDetail; }
    public void setReceiverAddrDetail(String receiverAddrDetail) { this.receiverAddrDetail = receiverAddrDetail; }

    public List<OrderItemVO> getOrderItems() { return orderItems; }
    public void setOrderItems(List<OrderItemVO> orderItems) { this.orderItems = orderItems; }

    public String getOrderStatusCd() { return orderStatusCd; }
    public void setOrderStatusCd(String orderStatusCd) { this.orderStatusCd = orderStatusCd; }

    public String getPaymentStatusCd() { return paymentStatusCd; }
    public void setPaymentStatusCd(String paymentStatusCd) { this.paymentStatusCd = paymentStatusCd; }

    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }

    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }

    public String getOrderNo() { return orderNo; }
    public void setOrderNo(String orderNo) { this.orderNo = orderNo; }

    public Long getBuyerCompanyId() { return buyerCompanyId; }
    public void setBuyerCompanyId(Long buyerCompanyId) { this.buyerCompanyId = buyerCompanyId; }

    public Long getSellerCompanyId() { return sellerCompanyId; }
    public void setSellerCompanyId(Long sellerCompanyId) { this.sellerCompanyId = sellerCompanyId; }

    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }

    public String getOrderStatus() { return orderStatus; }
    public void setOrderStatus(String orderStatus) { this.orderStatus = orderStatus; }

    public BigDecimal getTotalSupplyAmount() { return totalSupplyAmount; }
    public void setTotalSupplyAmount(BigDecimal totalSupplyAmount) { this.totalSupplyAmount = totalSupplyAmount; }

    public BigDecimal getTotalVatAmount() { return totalVatAmount; }
    public void setTotalVatAmount(BigDecimal totalVatAmount) { this.totalVatAmount = totalVatAmount; }

    public BigDecimal getTotalOrderAmount() { return totalOrderAmount; }
    public void setTotalOrderAmount(BigDecimal totalOrderAmount) { this.totalOrderAmount = totalOrderAmount; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getShipmentStatus() { return shipmentStatus; }
    public void setShipmentStatus(String shipmentStatus) { this.shipmentStatus = shipmentStatus; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Long getCreatedBy() { return createdBy; }
    public void setCreatedBy(Long createdBy) { this.createdBy = createdBy; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public String getBuyerCompanyName() { return buyerCompanyName; }
    public void setBuyerCompanyName(String buyerCompanyName) { this.buyerCompanyName = buyerCompanyName; }

    public String getSellerCompanyName() { return sellerCompanyName; }
    public void setSellerCompanyName(String sellerCompanyName) { this.sellerCompanyName = sellerCompanyName; }

    public List<OrderLineVO> getOrderLines() { return orderLines; }
    public void setOrderLines(List<OrderLineVO> orderLines) { this.orderLines = orderLines; }
}
