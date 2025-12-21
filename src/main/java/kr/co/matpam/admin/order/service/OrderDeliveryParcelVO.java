package kr.co.matpam.admin.order.service;

import java.io.Serializable;
import java.util.Date;

/**
 * 택배 배송정보 VO
 * - TABLE: tb_order_delivery_parcel
 */
public class OrderDeliveryParcelVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 주문ID (PK, FK) */
    private Long orderId;

    /** 택배사 코드 */
    private String courierCd;

    /** 택배사명 (조인) */
    private String courierName;

    /** 운송장 번호 */
    private String trackingNo;

    /** 배송지역코드 */
    private String deliveryRegionCd;

    /** 발송일시 */
    private Date shippedDt;

    /** 배송완료일시 */
    private Date deliveredDt;

    /** 사용여부 */
    private String useYn = "Y";

    /** 삭제여부 */
    private String delYn = "N";

    /** 등록자ID */
    private String regId;

    /** 등록일시 */
    private Date regDt;

    /** 수정자ID */
    private String modId;

    /** 수정일시 */
    private Date modDt;

    /*
     * =========================================================
     * Getter / Setter
     * =========================================================
     */

    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public String getCourierCd() {
        return courierCd;
    }

    public void setCourierCd(String courierCd) {
        this.courierCd = courierCd;
    }

    public String getCourierName() {
        return courierName;
    }

    public void setCourierName(String courierName) {
        this.courierName = courierName;
    }

    public String getTrackingNo() {
        return trackingNo;
    }

    public void setTrackingNo(String trackingNo) {
        this.trackingNo = trackingNo;
    }

    public String getDeliveryRegionCd() {
        return deliveryRegionCd;
    }

    public void setDeliveryRegionCd(String deliveryRegionCd) {
        this.deliveryRegionCd = deliveryRegionCd;
    }

    public Date getShippedDt() {
        return shippedDt;
    }

    public void setShippedDt(Date shippedDt) {
        this.shippedDt = shippedDt;
    }

    public Date getDeliveredDt() {
        return deliveredDt;
    }

    public void setDeliveredDt(Date deliveredDt) {
        this.deliveredDt = deliveredDt;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public String getDelYn() {
        return delYn;
    }

    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public String getRegId() {
        return regId;
    }

    public void setRegId(String regId) {
        this.regId = regId;
    }

    public Date getRegDt() {
        return regDt;
    }

    public void setRegDt(Date regDt) {
        this.regDt = regDt;
    }

    public String getModId() {
        return modId;
    }

    public void setModId(String modId) {
        this.modId = modId;
    }

    public Date getModDt() {
        return modDt;
    }

    public void setModDt(Date modDt) {
        this.modDt = modDt;
    }
}
