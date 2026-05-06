package kr.co.matpam.admin.order.service.impl;

import java.util.List;
import java.util.Map;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import kr.co.matpam.admin.order.service.OrderDeliveryFactoryVO;
import kr.co.matpam.admin.order.service.OrderDeliveryFreightVO;
import kr.co.matpam.admin.order.service.OrderDeliveryParcelVO;
import kr.co.matpam.admin.order.service.OrderListVO;
import kr.co.matpam.admin.order.service.OrderSearchVO;
import kr.co.matpam.admin.order.service.OrderSummaryVO;
import kr.co.matpam.admin.order.service.OrderDetailVO;
import kr.co.matpam.admin.order.service.OrderItemVO;

/**
 * 주문관리 Mapper 인터페이스
 */
@Mapper("orderManageDAO")
public interface OrderManageDAO {

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
    int updateOrderStatusBatch(Map<String, Object> paramMap);

    /**
     * 주문 상세 조회
     */
    OrderDetailVO selectOrderDetail(OrderSearchVO searchVO);

    /**
     * 주문 아이템 목록 조회
     */
    List<OrderItemVO> selectOrderItemList(OrderSearchVO searchVO);

    /**
     * 택배 배송정보 조회
     */
    OrderDeliveryParcelVO selectDeliveryParcel(OrderDeliveryParcelVO vo);

    /**
     * 택배 배송정보 저장
     */
    int upsertDeliveryParcel(OrderDeliveryParcelVO vo);

    /**
     * 화물/직배송 정보 조회
     */
    OrderDeliveryFreightVO selectDeliveryFreight(OrderDeliveryFreightVO vo);

    /**
     * 화물/직배송 정보 저장
     */
    int upsertDeliveryFreight(OrderDeliveryFreightVO vo);

    /**
     * 공장수령 정보 조회
     */
    OrderDeliveryFactoryVO selectDeliveryFactory(OrderDeliveryFactoryVO vo);

    /**
     * 공장수령 정보 저장
     */
    int upsertDeliveryFactory(OrderDeliveryFactoryVO vo);
}
