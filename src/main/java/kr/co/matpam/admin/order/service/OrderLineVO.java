package kr.co.matpam.admin.order.service;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 주문 상세(품목) VO
 * tb_order_line 테이블 대응
 */
public class OrderLineVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long orderLineId;
    private Long orderId;
    private Integer lineNo;
    private Long productId;
    private String relationGroupId;
    private String productNameSnapshot;
    private String itemKindSnapshot;
    private String processingTypeSnapshot;
    private String taxCategorySnapshot;
    private Long taxRuleIdSnapshot;
    private String unitNameSnapshot;
    private BigDecimal qty;
    private BigDecimal unitPrice;
    private BigDecimal supplyAmount;
    private BigDecimal vatAmount;
    private BigDecimal totalAmount;
    private String shipmentStatus;   // WAITING, PARTIAL, DONE, NOT_APPLICABLE
    private Date createdAt;

    public Long getOrderLineId() { return orderLineId; }
    public void setOrderLineId(Long orderLineId) { this.orderLineId = orderLineId; }

    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }

    public Integer getLineNo() { return lineNo; }
    public void setLineNo(Integer lineNo) { this.lineNo = lineNo; }

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public String getRelationGroupId() { return relationGroupId; }
    public void setRelationGroupId(String relationGroupId) { this.relationGroupId = relationGroupId; }

    public String getProductNameSnapshot() { return productNameSnapshot; }
    public void setProductNameSnapshot(String productNameSnapshot) { this.productNameSnapshot = productNameSnapshot; }

    public String getItemKindSnapshot() { return itemKindSnapshot; }
    public void setItemKindSnapshot(String itemKindSnapshot) { this.itemKindSnapshot = itemKindSnapshot; }

    public String getProcessingTypeSnapshot() { return processingTypeSnapshot; }
    public void setProcessingTypeSnapshot(String processingTypeSnapshot) { this.processingTypeSnapshot = processingTypeSnapshot; }

    public String getTaxCategorySnapshot() { return taxCategorySnapshot; }
    public void setTaxCategorySnapshot(String taxCategorySnapshot) { this.taxCategorySnapshot = taxCategorySnapshot; }

    public Long getTaxRuleIdSnapshot() { return taxRuleIdSnapshot; }
    public void setTaxRuleIdSnapshot(Long taxRuleIdSnapshot) { this.taxRuleIdSnapshot = taxRuleIdSnapshot; }

    public String getUnitNameSnapshot() { return unitNameSnapshot; }
    public void setUnitNameSnapshot(String unitNameSnapshot) { this.unitNameSnapshot = unitNameSnapshot; }

    public BigDecimal getQty() { return qty; }
    public void setQty(BigDecimal qty) { this.qty = qty; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public BigDecimal getSupplyAmount() { return supplyAmount; }
    public void setSupplyAmount(BigDecimal supplyAmount) { this.supplyAmount = supplyAmount; }

    public BigDecimal getVatAmount() { return vatAmount; }
    public void setVatAmount(BigDecimal vatAmount) { this.vatAmount = vatAmount; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getShipmentStatus() { return shipmentStatus; }
    public void setShipmentStatus(String shipmentStatus) { this.shipmentStatus = shipmentStatus; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
