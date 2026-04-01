package kr.co.matpam.admin.common.util;

import static org.junit.Assert.assertEquals;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import org.junit.Test;

/**
 * 부가세 계산 로직(VatCalculator) 단위 테스트
 */
public class VatCalculatorTest {

    @Test
    public void testCalculateVat_Truncation() {
        // Given: 1,555원짜리 가공품(과세) 1개
        // VAT = 1555 * 0.1 = 155.5 -> 절사 시 155원 예상
        List<VatCalculator.ComponentInfo> components = new ArrayList<>();
        components.add(new VatCalculator.ComponentInfo(
            new BigDecimal("1555"), 
            new BigDecimal("1"), 
            "TAXABLE"
        ));

        // When
        VatCalculator.CalculationResult result = VatCalculator.calculate(components);

        // Then
        // Supply = 1555
        // VAT = 155
        // Total = 1710
        assertEquals(new BigDecimal("1555"), result.getSupplyAmount());
        assertEquals(new BigDecimal("155"), result.getVatAmount());
        assertEquals(new BigDecimal("1710"), result.getTotalPrice());
    }

    @Test
    public void testCalculateMixedProducts() {
        // Given: 가공품(과세) 1,000원 + 농축산물(면세) 2,000원
        List<VatCalculator.ComponentInfo> components = new ArrayList<>();
        components.add(new VatCalculator.ComponentInfo(new BigDecimal("1000"), new BigDecimal("1"), "TAXABLE"));
        components.add(new VatCalculator.ComponentInfo(new BigDecimal("2000"), new BigDecimal("1"), "FREE"));

        // When
        VatCalculator.CalculationResult result = VatCalculator.calculate(components);

        // Then
        // Supply = 3000 (1000 + 2000)
        // VAT = 100 (1000 * 0.1)
        // Total = 3100
        assertEquals(new BigDecimal("3000"), result.getSupplyAmount());
        assertEquals(new BigDecimal("100"), result.getVatAmount());
        assertEquals(new BigDecimal("3100"), result.getTotalPrice());
    }

    @Test
    public void testDiscountLogic() {
        // Given: 10,000원에서 1,500원 할인
        BigDecimal total = new BigDecimal("10000");
        BigDecimal discount = new BigDecimal("1500");

        // When
        BigDecimal result = VatCalculator.calculateDiscountedPrice(total, discount);

        // Then
        assertEquals(new BigDecimal("8500"), result);
    }
}
