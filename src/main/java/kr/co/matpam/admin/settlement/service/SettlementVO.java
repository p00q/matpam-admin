package kr.co.matpam.admin.settlement.service;

import java.math.BigDecimal;
import java.util.Date;
import kr.co.matpam.common.service.MatpamBaseVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 정산 정보 VO
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class SettlementVO extends MatpamBaseVO {
    private static final long serialVersionUID = 1L;

    private Long settleId;
    private String settleDate; // yyyy-MM-dd
    
    // opType is inherited from MatpamBaseVO, but we can redeclare it for explicit mapping if desired,
    // or just rely on inherited. We will explicitly define it for clarity in mapper results.
    private String opType; // NATIONAL, LOCAL, FACTORY
    
    // 집계 지표
    private Long orderCount;                  // 총 주문 건수
    private BigDecimal totalSalesAmt;         // 총 매출액 (상품가 + 배송비)
    private BigDecimal totalGoodsAmt;         // 총 상품액 (할인 전 순수 상품가)
    private BigDecimal totalDiscountAmt;      // 총 할인액
    private BigDecimal totalVatAmt;           // 총 부가세액
    private BigDecimal totalPayAmt;           // 총 실결제액(머니 차감액)
    
    // 추가 분석 지표 (면세 비율 계산 등)
    private BigDecimal rawMaterialRatio;      // 원물 비중 (0~100)
    private BigDecimal processedRatio;        // 가공품 비중 (0~100)
    
    private Date regDt;
    private Date modDt;
}
