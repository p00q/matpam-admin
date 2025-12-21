package kr.co.matpam.admin.order.service;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 주문상세 VO
 * - 주문 상세 정보 (배송지, 메모 등 포함)
 */
public class OrderDetailVO extends OrderListVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /*
     * =========================================================
     * 상세 배송/수취인 정보
     * =========================================================
     */
    private String receiverZipCode;
    private String receiverAddr1;
    private String receiverAddr2;
    private String deliveryMemo;

    /*
     * =========================================================
     * 주문자 정보 (상세)
     * =========================================================
     */
    private String buyerName;
    private String buyerMobile;
    private String buyerEmail;

    /*
     * =========================================================
     * Getter / Setter
     * =========================================================
     */
    public String getReceiverZipCode() {
        return receiverZipCode;
    }

    public void setReceiverZipCode(String receiverZipCode) {
        this.receiverZipCode = receiverZipCode;
    }

    public String getReceiverAddr1() {
        return receiverAddr1;
    }

    public void setReceiverAddr1(String receiverAddr1) {
        this.receiverAddr1 = receiverAddr1;
    }

    public String getReceiverAddr2() {
        return receiverAddr2;
    }

    public void setReceiverAddr2(String receiverAddr2) {
        this.receiverAddr2 = receiverAddr2;
    }

    public String getDeliveryMemo() {
        return deliveryMemo;
    }

    public void setDeliveryMemo(String deliveryMemo) {
        this.deliveryMemo = deliveryMemo;
    }

    public String getBuyerName() {
        return buyerName;
    }

    public void setBuyerName(String buyerName) {
        this.buyerName = buyerName;
    }

    public String getBuyerMobile() {
        return buyerMobile;
    }

    public void setBuyerMobile(String buyerMobile) {
        this.buyerMobile = buyerMobile;
    }

    public String getBuyerEmail() {
        return buyerEmail;
    }

    public void setBuyerEmail(String buyerEmail) {
        this.buyerEmail = buyerEmail;
    }
}
