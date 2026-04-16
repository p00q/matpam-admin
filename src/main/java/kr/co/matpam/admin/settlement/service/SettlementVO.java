package kr.co.matpam.admin.settlement.service;

import java.math.BigDecimal;
import java.util.Date;
import java.math.BigDecimal;
import java.util.Date;
import kr.co.matpam.common.service.MatpamBaseVO;

/**
 * 정산 정보 VO
 */
public class SettlementVO extends MatpamBaseVO {
    private static final long serialVersionUID = 1L;

    private Long settleId;
    private String settleDate; // yyyy-MM-dd
    
    // opType is inherited from MatpamBaseVO
    
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

    public Long getSettleId() { return settleId; }
    public void setSettleId(Long settleId) { this.settleId = settleId; }
    public String getSettleDate() { return settleDate; }
    public void setSettleDate(String settleDate) { this.settleDate = settleDate; }
    public Long getOrderCount() { return orderCount; }
    public void setOrderCount(Long orderCount) { this.orderCount = orderCount; }
    public BigDecimal getTotalSalesAmt() { return totalSalesAmt; }
    public void setTotalSalesAmt(BigDecimal totalSalesAmt) { this.totalSalesAmt = totalSalesAmt; }
    public BigDecimal getTotalGoodsAmt() { return totalGoodsAmt; }
    public void setTotalGoodsAmt(BigDecimal totalGoodsAmt) { this.totalGoodsAmt = totalGoodsAmt; }
    public BigDecimal getTotalDiscountAmt() { return totalDiscountAmt; }
    public void setTotalDiscountAmt(BigDecimal totalDiscountAmt) { this.totalDiscountAmt = totalDiscountAmt; }
    public BigDecimal getTotalVatAmt() { return totalVatAmt; }
    public void setTotalVatAmt(BigDecimal totalVatAmt) { this.totalVatAmt = totalVatAmt; }
    public BigDecimal getTotalPayAmt() { return totalPayAmt; }
    public void setTotalPayAmt(BigDecimal totalPayAmt) { this.totalPayAmt = totalPayAmt; }
    public BigDecimal getRawMaterialRatio() { return rawMaterialRatio; }
    public void setRawMaterialRatio(BigDecimal rawMaterialRatio) { this.rawMaterialRatio = rawMaterialRatio; }
    public BigDecimal getProcessedRatio() { return processedRatio; }
    public void setProcessedRatio(BigDecimal processedRatio) { this.processedRatio = processedRatio; }
    public Date getRegDt() { return regDt; }
    public void setRegDt(Date regDt) { this.regDt = regDt; }
    public Date getModDt() { return modDt; }
    public void setModDt(Date modDt) { this.modDt = modDt; }
}
