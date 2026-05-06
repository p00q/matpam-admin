package kr.co.matpam.admin.order.service.impl;

import java.util.List;
import kr.co.matpam.admin.order.service.OrderVO;
import kr.co.matpam.admin.order.service.OrderLineVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * 주문 관리 Mapper 인터페이스 (tb_order, tb_order_line)
 */
@Mapper("orderDAO")
public interface OrderDAO {

    /**
     * 주문 마스터 등록
     */
    void insertOrder(OrderVO vo);

    /**
     * 주문 상세 품목 등록
     */
    void insertOrderLine(OrderLineVO vo);

    /**
     * 주문 목록 조회
     */
    List<OrderVO> selectOrderList(OrderVO vo);

    /**
     * 주문 목록 총 건수
     */
    int selectOrderListTotCnt(OrderVO vo);

    /**
     * 주문 상세 정보 조회
     */
    OrderVO selectOrder(OrderVO vo);

    /**
     * 주문 품목 목록 조회
     */
    List<OrderLineVO> selectOrderLineList(Long orderId);

    /**
     * 주문 상태 업데이트
     */
    void updateOrderStatus(OrderVO vo);

    /**
     * 스키마 보정 실행
     */
    void fixOrderSchema();
}
