package kr.co.matpam.admin.order.service;

import kr.co.matpam.common.service.MatpamBaseVO;

/**
 * 주문관리 검색 VO
 * - 주문건별/상품별 목록 조회 조건
 */
public class OrderSearchVO extends MatpamBaseVO {

    private static final long serialVersionUID = 1L;

    /*
     * =========================================================
     * 페이징 (eGov 표준)


    /*
     * =========================================================
     * 검색 조건
     * =========================================================
     */
    /** 주문상태코드 (ORDER_STATUS) */
    private String orderStatusCd;

    /** 배송유형코드 (DELIVERY_TYPE: PARCEL/FREIGHT/FACTORY) */
    private String deliveryTypeCd;

    /** 지역 - 시도 */
    private String regionSidoCd;

    /** 지역 - 시군구 */
    private String regionSigunguCd;

    /** 검색어 - 구매자 업체명 */
    private String buyerCompanyName;

    /** 주문기간 - 시작일 (yyyy-MM-dd) */
    private String orderDtFrom;

    /** 주문기간 - 종료일 (yyyy-MM-dd) */
    private String orderDtTo;

    /** 금일주문건 여부 (Y/N) */
    private String todayOnlyYn;

    /*
     * =========================================================
     * Getter / Setter
     * =========================================================
     */



    public String getOrderStatusCd() {
        return orderStatusCd;
    }

    public void setOrderStatusCd(String orderStatusCd) {
        this.orderStatusCd = orderStatusCd;
    }

    public String getDeliveryTypeCd() {
        return deliveryTypeCd;
    }

    public void setDeliveryTypeCd(String deliveryTypeCd) {
        this.deliveryTypeCd = deliveryTypeCd;
    }

    public String getRegionSidoCd() {
        return regionSidoCd;
    }

    public void setRegionSidoCd(String regionSidoCd) {
        this.regionSidoCd = regionSidoCd;
    }

    public String getRegionSigunguCd() {
        return regionSigunguCd;
    }

    public void setRegionSigunguCd(String regionSigunguCd) {
        this.regionSigunguCd = regionSigunguCd;
    }

    public String getBuyerCompanyName() {
        return buyerCompanyName;
    }

    public void setBuyerCompanyName(String buyerCompanyName) {
        this.buyerCompanyName = buyerCompanyName;
    }

    public String getOrderDtFrom() {
        return orderDtFrom;
    }

    public void setOrderDtFrom(String orderDtFrom) {
        this.orderDtFrom = orderDtFrom;
    }

    public String getOrderDtTo() {
        return orderDtTo;
    }

    public void setOrderDtTo(String orderDtTo) {
        this.orderDtTo = orderDtTo;
    }

    public String getTodayOnlyYn() {
        return todayOnlyYn;
    }

    public void setTodayOnlyYn(String todayOnlyYn) {
        this.todayOnlyYn = todayOnlyYn;
    }
}
