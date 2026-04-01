package kr.co.matpam.admin.order.service;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import lombok.Data;

/**
 * 주문 정보 VO
 */
@Data
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
}
