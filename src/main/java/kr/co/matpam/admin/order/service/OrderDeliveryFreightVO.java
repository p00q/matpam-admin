package kr.co.matpam.admin.order.service;

import java.io.Serializable;
import java.util.Date;

/**
 * 화물/직배송 배송정보 VO
 * - TABLE: tb_order_delivery_freight
 */
public class OrderDeliveryFreightVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 주문ID (PK, FK) */
    private Long orderId;

    /** 배송방법코드 */
    private String shippingMethodCd;

    /** 운송업체명 */
    private String freightCompanyName;

    /** 기사명 */
    private String driverName;

    /** 기사 연락처 */
    private String driverMobile;

    /** 차량번호 */
    private String truckNo;

    /** 배송지역코드 */
    private String deliveryRegionCd;

    /** 출차일시 */
    private Date shippedDt;

    /** 도착일시 */
    private Date arrivedDt;

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

    public String getShippingMethodCd() {
        return shippingMethodCd;
    }

    public void setShippingMethodCd(String shippingMethodCd) {
        this.shippingMethodCd = shippingMethodCd;
    }

    public String getFreightCompanyName() {
        return freightCompanyName;
    }

    public void setFreightCompanyName(String freightCompanyName) {
        this.freightCompanyName = freightCompanyName;
    }

    public String getDriverName() {
        return driverName;
    }

    public void setDriverName(String driverName) {
        this.driverName = driverName;
    }

    public String getDriverMobile() {
        return driverMobile;
    }

    public void setDriverMobile(String driverMobile) {
        this.driverMobile = driverMobile;
    }

    public String getTruckNo() {
        return truckNo;
    }

    public void setTruckNo(String truckNo) {
        this.truckNo = truckNo;
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

    public Date getArrivedDt() {
        return arrivedDt;
    }

    public void setArrivedDt(Date arrivedDt) {
        this.arrivedDt = arrivedDt;
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
