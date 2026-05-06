package kr.co.matpam.admin.logistics.service;

public interface ShipmentService {
    
    /**
     * 배송 시작 (운송장 번호 입력 및 SHIPPED 처리)
     */
    void processShipping(ShipmentVO shipmentVO) throws Exception;
}
