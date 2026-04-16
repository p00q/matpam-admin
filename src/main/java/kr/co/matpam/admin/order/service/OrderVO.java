package kr.co.matpam.admin.order.service;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * 주문 정보 VO
 */
public class OrderVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long orderId;
    private String orderNo;
    
    private Long buyerMemberId;
    private String buyerName;
    
    private BigDecimal totalOrderAmt;
    private BigDecimal totalVatAmt;
    private BigDecimal totalDiscountAmt;
    private BigDecimal totalPayAmt;
    
    private String orderStatusCd; // ORDER(주문완료), CANCEL(주문취소), DELIVERY(배송중), COMPLETE(배송완료)
    private String paymentStatusCd; // WAIT(대기), PAID(결제완료), REFUND(환불)
    
    private String receiverName;
    private String receiverHp;
    private String receiverZip;
    private String receiverAddr;
    private String receiverAddrDetail;
    
    private String opType; // NATIONAL, LOCAL, FACTORY
    
    private String regId;
    private Date regDt;
    private String modId;
    private Date modDt;
    
    // 주문 상품 상세 리스트
    private List<OrderItemVO> orderItems;

    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }
    public String getOrderNo() { return orderNo; }
    public void setOrderNo(String orderNo) { this.orderNo = orderNo; }
    public Long getBuyerMemberId() { return buyerMemberId; }
    public void setBuyerMemberId(Long buyerMemberId) { this.buyerMemberId = buyerMemberId; }
    public String getBuyerName() { return buyerName; }
    public void setBuyerName(String buyerName) { this.buyerName = buyerName; }
    public BigDecimal getTotalOrderAmt() { return totalOrderAmt; }
    public void setTotalOrderAmt(BigDecimal totalOrderAmt) { this.totalOrderAmt = totalOrderAmt; }
    public BigDecimal getTotalVatAmt() { return totalVatAmt; }
    public void setTotalVatAmt(BigDecimal totalVatAmt) { this.totalVatAmt = totalVatAmt; }
    public BigDecimal getTotalDiscountAmt() { return totalDiscountAmt; }
    public void setTotalDiscountAmt(BigDecimal totalDiscountAmt) { this.totalDiscountAmt = totalDiscountAmt; }
    public BigDecimal getTotalPayAmt() { return totalPayAmt; }
    public void setTotalPayAmt(BigDecimal totalPayAmt) { this.totalPayAmt = totalPayAmt; }
    public String getOrderStatusCd() { return orderStatusCd; }
    public void setOrderStatusCd(String orderStatusCd) { this.orderStatusCd = orderStatusCd; }
    public String getPaymentStatusCd() { return paymentStatusCd; }
    public void setPaymentStatusCd(String paymentStatusCd) { this.paymentStatusCd = paymentStatusCd; }
    public String getReceiverName() { return receiverName; }
    public void setReceiverName(String receiverName) { this.receiverName = receiverName; }
    public String getReceiverHp() { return receiverHp; }
    public void setReceiverHp(String receiverHp) { this.receiverHp = receiverHp; }
    public String getReceiverZip() { return receiverZip; }
    public void setReceiverZip(String receiverZip) { this.receiverZip = receiverZip; }
    public String getReceiverAddr() { return receiverAddr; }
    public void setReceiverAddr(String receiverAddr) { this.receiverAddr = receiverAddr; }
    public String getReceiverAddrDetail() { return receiverAddrDetail; }
    public void setReceiverAddrDetail(String receiverAddrDetail) { this.receiverAddrDetail = receiverAddrDetail; }
    public String getOpType() { return opType; }
    public void setOpType(String opType) { this.opType = opType; }
    public String getRegId() { return regId; }
    public void setRegId(String regId) { this.regId = regId; }
    public Date getRegDt() { return regDt; }
    public void setRegDt(Date regDt) { this.regDt = regDt; }
    public String getModId() { return modId; }
    public void setModId(String modId) { this.modId = modId; }
    public Date getModDt() { return modDt; }
    public void setModDt(Date modDt) { this.modDt = modDt; }
    public List<OrderItemVO> getOrderItems() { return orderItems; }
    public void setOrderItems(List<OrderItemVO> orderItems) { this.orderItems = orderItems; }
}
