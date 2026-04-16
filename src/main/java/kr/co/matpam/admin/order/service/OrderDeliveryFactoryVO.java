package kr.co.matpam.admin.order.service;

import java.io.Serializable;
import java.util.Date;

/**
 * 공장수령 배송정보 VO
 * - TABLE: tb_order_delivery_factory
 */
public class OrderDeliveryFactoryVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 주문ID (PK, FK) */
    private Long orderId;

    /** 수령장소 코드 */
    private String pickupPlaceCd;

    /** 수령장소명 (조인) */
    private String pickupPlaceName;

    /** 수령예정일시 */
    private Date pickupDt;

    /** 담당자명 */
    private String contactName;

    /** 담당자 연락처 */
    private String contactMobile;

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

    /** 운영구분 (NATIONAL, LOCAL, FACTORY) */
    private String opType;

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

    public String getPickupPlaceCd() {
        return pickupPlaceCd;
    }

    public void setPickupPlaceCd(String pickupPlaceCd) {
        this.pickupPlaceCd = pickupPlaceCd;
    }

    public String getPickupPlaceName() {
        return pickupPlaceName;
    }

    public void setPickupPlaceName(String pickupPlaceName) {
        this.pickupPlaceName = pickupPlaceName;
    }

    public Date getPickupDt() {
        return pickupDt;
    }

    public void setPickupDt(Date pickupDt) {
        this.pickupDt = pickupDt;
    }

    public String getContactName() {
        return contactName;
    }

    public void setContactName(String contactName) {
        this.contactName = contactName;
    }

    public String getContactMobile() {
        return contactMobile;
    }

    public void setContactMobile(String contactMobile) {
        this.contactMobile = contactMobile;
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

    public String getOpType() {
        return opType;
    }

    public void setOpType(String opType) {
        this.opType = opType;
    }
}
