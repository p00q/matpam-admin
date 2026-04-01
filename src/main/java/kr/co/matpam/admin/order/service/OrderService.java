package kr.co.matpam.admin.order.service;

import java.util.List;

/**
 * 주문 서비스 인터페이스
 */
public interface OrderService {

    /**
     * 주문서 생성 및 결제 처리 (Transaction)
     */
    String processOrder(OrderVO orderVO) throws Exception;

    /**
     * 주문 상세 조회
     */
    OrderVO selectOrder(Long orderId) throws Exception;

    /**
     * 주문 목록 조회
     */
    List<OrderVO> selectOrderList(OrderVO orderVO) throws Exception;

    /**
     * 주문 목록 총 건수
     */
    int selectOrderListTotCnt(OrderVO orderVO) throws Exception;

    /**
     * 주문 취소
     */
    void cancelOrder(Long orderId) throws Exception;
}
