package kr.co.matpam.admin.order.service;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 주문관리 KPI 요약 VO
 * - 상단 KPI 합계 데이터
 */
public class OrderSummaryVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 총 주문금액 (상품합계) */
    private BigDecimal sumGoodsTotalAmt;

    /** 총 배송비 */
    private BigDecimal sumDeliveryTotalAmt;

    /** 총 할인금액 */
    private BigDecimal sumDiscountTotalAmt;

    /** 총 결제금액 */
    private BigDecimal sumPayTotalAmt;

    /*
     * =========================================================
     * Getter / Setter
     * =========================================================
     */

    public BigDecimal getSumGoodsTotalAmt() {
        return sumGoodsTotalAmt;
    }

    public void setSumGoodsTotalAmt(BigDecimal sumGoodsTotalAmt) {
        this.sumGoodsTotalAmt = sumGoodsTotalAmt;
    }

    public BigDecimal getSumDeliveryTotalAmt() {
        return sumDeliveryTotalAmt;
    }

    public void setSumDeliveryTotalAmt(BigDecimal sumDeliveryTotalAmt) {
        this.sumDeliveryTotalAmt = sumDeliveryTotalAmt;
    }

    public BigDecimal getSumDiscountTotalAmt() {
        return sumDiscountTotalAmt;
    }

    public void setSumDiscountTotalAmt(BigDecimal sumDiscountTotalAmt) {
        this.sumDiscountTotalAmt = sumDiscountTotalAmt;
    }

    public BigDecimal getSumPayTotalAmt() {
        return sumPayTotalAmt;
    }

    public void setSumPayTotalAmt(BigDecimal sumPayTotalAmt) {
        this.sumPayTotalAmt = sumPayTotalAmt;
    }
}
