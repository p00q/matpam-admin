package kr.co.matpam.admin.common.util;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

/**
 * 부가세 및 금액 계산 유틸리티
 */
public class VatCalculator {

    private static final BigDecimal VAT_RATE = new BigDecimal("0.1");

    /**
     * 구성상품 목록을 기반으로 판매상품의 총액/부가세/공급가액 계산
     * 
     * @param components 구성 정보 리스트 (price, qty, saleType 포함 필요)
     * @return 계산 결과 [Total, Supply, Vat]
     */
    public static CalculationResult calculate(List<ComponentInfo> components) {
        BigDecimal totalSupplyAmt = BigDecimal.ZERO;
        BigDecimal totalVatAmt = BigDecimal.ZERO;

        if (components != null) {
            for (ComponentInfo comp : components) {
                BigDecimal compPrice = comp.getPrice() != null ? comp.getPrice() : BigDecimal.ZERO;
                BigDecimal compQty = comp.getQty() != null ? comp.getQty() : BigDecimal.ONE;
                BigDecimal linePrice = compPrice.multiply(compQty);

                totalSupplyAmt = totalSupplyAmt.add(linePrice);

                // 가공품(PROCESS)일 경우에만 부가세 10% 가산
                if ("TAXABLE".equals(comp.getTaxType())) {
                    BigDecimal lineVat = linePrice.multiply(VAT_RATE).setScale(0, RoundingMode.DOWN);
                    totalVatAmt = totalVatAmt.add(lineVat);
                }
            }
        }

        BigDecimal totalPrice = totalSupplyAmt.add(totalVatAmt);

        return new CalculationResult(totalPrice, totalSupplyAmt, totalVatAmt);
    }

    /**
     * 할인 적용 후 최종 금액 계산 (부가세 포함가 기준 할인)
     */
    public static BigDecimal calculateDiscountedPrice(BigDecimal totalPrice, BigDecimal discountAmt) {
        if (totalPrice == null) return BigDecimal.ZERO;
        BigDecimal result = totalPrice.subtract(discountAmt != null ? discountAmt : BigDecimal.ZERO);
        return result.compareTo(BigDecimal.ZERO) < 0 ? BigDecimal.ZERO : result;
    }

    // Helper classes
    public static class ComponentInfo {
        private BigDecimal price;
        private BigDecimal qty;
        private String taxType;

        public ComponentInfo(BigDecimal price, BigDecimal qty, String taxType) {
            this.price = price;
            this.qty = qty;
            this.taxType = taxType;
        }
        public BigDecimal getPrice() { return price; }
        public BigDecimal getQty() { return qty; }
        public String getTaxType() { return taxType; }
    }

    public static class CalculationResult {
        private final BigDecimal totalPrice;
        private final BigDecimal supplyAmount;
        private final BigDecimal vatAmount;

        public CalculationResult(BigDecimal totalPrice, BigDecimal supplyAmount, BigDecimal vatAmount) {
            this.totalPrice = totalPrice;
            this.supplyAmount = supplyAmount;
            this.vatAmount = vatAmount;
        }
        public BigDecimal getTotalPrice() { return totalPrice; }
        public BigDecimal getSupplyAmount() { return supplyAmount; }
        public BigDecimal getVatAmount() { return vatAmount; }
    }
}
