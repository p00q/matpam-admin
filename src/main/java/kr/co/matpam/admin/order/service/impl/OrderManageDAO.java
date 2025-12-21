package kr.co.matpam.admin.order.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import kr.co.matpam.admin.order.service.OrderDeliveryFactoryVO;
import kr.co.matpam.admin.order.service.OrderDeliveryFreightVO;
import kr.co.matpam.admin.order.service.OrderDeliveryParcelVO;
import kr.co.matpam.admin.order.service.OrderListVO;
import kr.co.matpam.admin.order.service.OrderSearchVO;
import kr.co.matpam.admin.order.service.OrderSummaryVO;

/**
 * 주문관리 DAO
 */
@Repository("orderManageDAO")
public class OrderManageDAO extends EgovAbstractMapper {

    /**
     * 주문건별 목록 조회
     */
    public List<OrderListVO> selectOrderList(OrderSearchVO searchVO) {
        return selectList("selectOrderList", searchVO);
    }

    /**
     * 주문건별 목록 총 건수
     */
    public int selectOrderListTotCnt(OrderSearchVO searchVO) {
        return selectOne("selectOrderListTotCnt", searchVO);
    }

    /**
     * KPI 합계 조회
     */
    public OrderSummaryVO selectOrderSummary(OrderSearchVO searchVO) {
        return selectOne("selectOrderSummary", searchVO);
    }

    /**
     * 주문상태 일괄 변경
     */
    public int updateOrderStatusBatch(Map<String, Object> paramMap) {
        return update("updateOrderStatusBatch", paramMap);
    }

    /**
     * 주문 상세 조회
     */
    public kr.co.matpam.admin.order.service.OrderDetailVO selectOrderDetail(OrderSearchVO searchVO) {
        return selectOne("selectOrderDetail", searchVO);
    }

    /**
     * 주문 아이템 목록 조회
     */
    public List<kr.co.matpam.admin.order.service.OrderItemVO> selectOrderItemList(OrderSearchVO searchVO) {
        return selectList("selectOrderItemList", searchVO);
    }

    /*
     * =========================================================
     * 배송정보 (택배)
     * =========================================================
     */
    public OrderDeliveryParcelVO selectDeliveryParcel(Long orderId) {
        return selectOne("selectDeliveryParcel", orderId);
    }

    public int upsertDeliveryParcel(OrderDeliveryParcelVO vo) {
        return insert("upsertDeliveryParcel", vo);
    }

    /*
     * =========================================================
     * 배송정보 (화물/직배송)
     * =========================================================
     */
    public OrderDeliveryFreightVO selectDeliveryFreight(Long orderId) {
        return selectOne("selectDeliveryFreight", orderId);
    }

    public int upsertDeliveryFreight(OrderDeliveryFreightVO vo) {
        return insert("upsertDeliveryFreight", vo);
    }

    /*
     * =========================================================
     * 배송정보 (공장수령)
     * =========================================================
     */
    public OrderDeliveryFactoryVO selectDeliveryFactory(Long orderId) {
        return selectOne("selectDeliveryFactory", orderId);
    }

    public int upsertDeliveryFactory(OrderDeliveryFactoryVO vo) {
        return insert("upsertDeliveryFactory", vo);
    }
}
