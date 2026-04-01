package kr.co.matpam.admin.order.service;

import java.io.Serializable;
import java.math.BigDecimal;
import lombok.Data;

/**
 * 주문 개별 상품 VO
 */
@Data
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
}
