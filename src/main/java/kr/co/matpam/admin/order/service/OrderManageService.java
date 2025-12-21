package kr.co.matpam.admin.order.service;

import java.util.List;

/**
 * 주문관리 Service 인터페이스
 */
public interface OrderManageService {

    /**
     * 주문건별 목록 조회
     */
    List<OrderListVO> selectOrderList(OrderSearchVO searchVO);

    /**
     * 주문건별 목록 총 건수
     */
    int selectOrderListTotCnt(OrderSearchVO searchVO);

    /**
     * KPI 합계 조회
     */
    OrderSummaryVO selectOrderSummary(OrderSearchVO searchVO);

    /**
     * 주문상태 일괄 변경
     */
    int updateOrderStatusBatch(List<Long> orderIds, String orderStatusCd, String modId);

    /**
     * 주문 상세 조회
     */
    OrderDetailVO selectOrderDetail(OrderSearchVO searchVO);

    /**
     * 주문 아이템 목록 조회
     */
    List<OrderItemVO> selectOrderItemList(OrderSearchVO searchVO);

    /*
     * =========================================================
     * 배송정보 (택배)
     * =========================================================
     */
    OrderDeliveryParcelVO selectDeliveryParcel(Long orderId);

    int saveDeliveryParcel(OrderDeliveryParcelVO vo);

    /*
     * =========================================================
     * 배송정보 (화물/직배송)
     * =========================================================
     */
    OrderDeliveryFreightVO selectDeliveryFreight(Long orderId);

    int saveDeliveryFreight(OrderDeliveryFreightVO vo);

    /*
     * =========================================================
     * 배송정보 (공장수령)
     * =========================================================
     */
    OrderDeliveryFactoryVO selectDeliveryFactory(Long orderId);

    int saveDeliveryFactory(OrderDeliveryFactoryVO vo);
}
