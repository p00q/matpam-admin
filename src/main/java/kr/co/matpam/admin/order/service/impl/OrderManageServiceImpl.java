package kr.co.matpam.admin.order.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.matpam.admin.order.service.OrderDeliveryFactoryVO;
import kr.co.matpam.admin.order.service.OrderDeliveryFreightVO;
import kr.co.matpam.admin.order.service.OrderDeliveryParcelVO;
import kr.co.matpam.admin.order.service.OrderDetailVO;
import kr.co.matpam.admin.order.service.OrderItemVO;
import kr.co.matpam.admin.order.service.OrderListVO;
import kr.co.matpam.admin.order.service.OrderManageService;
import kr.co.matpam.admin.order.service.OrderSearchVO;
import kr.co.matpam.admin.order.service.OrderSummaryVO;

/**
 * 주문관리 Service 구현체
 */
@Service("orderManageService")
public class OrderManageServiceImpl extends EgovAbstractServiceImpl implements OrderManageService {

    @Resource(name = "orderManageDAO")
    private OrderManageDAO orderManageDAO;

    @Override
    public List<OrderListVO> selectOrderList(OrderSearchVO searchVO) {
        return orderManageDAO.selectOrderList(searchVO);
    }

    @Override
    public int selectOrderListTotCnt(OrderSearchVO searchVO) {
        return orderManageDAO.selectOrderListTotCnt(searchVO);
    }

    @Override
    public OrderSummaryVO selectOrderSummary(OrderSearchVO searchVO) {
        return orderManageDAO.selectOrderSummary(searchVO);
    }

    @Override
    public int updateOrderStatusBatch(List<Long> orderIds, String orderStatusCd, String modId, String opType) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("orderIds", orderIds);
        paramMap.put("orderStatusCd", orderStatusCd);
        paramMap.put("modId", modId);
        paramMap.put("opType", opType);
        return orderManageDAO.updateOrderStatusBatch(paramMap);
    }

    @Override
    public OrderDetailVO selectOrderDetail(OrderSearchVO searchVO) {
        return orderManageDAO.selectOrderDetail(searchVO);
    }

    @Override
    public List<OrderItemVO> selectOrderItemList(OrderSearchVO searchVO) {
        return orderManageDAO.selectOrderItemList(searchVO);
    }

    /*
     * =========================================================
     * 배송정보 (택배)
     * =========================================================
     */
    @Override
    public OrderDeliveryParcelVO selectDeliveryParcel(OrderDeliveryParcelVO vo) {
        return orderManageDAO.selectDeliveryParcel(vo);
    }

    @Override
    public int saveDeliveryParcel(OrderDeliveryParcelVO vo) {
        return orderManageDAO.upsertDeliveryParcel(vo);
    }

    /*
     * =========================================================
     * 배송정보 (화물/직배송)
     * =========================================================
     */
    @Override
    public OrderDeliveryFreightVO selectDeliveryFreight(OrderDeliveryFreightVO vo) {
        return orderManageDAO.selectDeliveryFreight(vo);
    }

    @Override
    public int saveDeliveryFreight(OrderDeliveryFreightVO vo) {
        return orderManageDAO.upsertDeliveryFreight(vo);
    }

    /*
     * =========================================================
     * 배송정보 (공장수령)
     * =========================================================
     */
    @Override
    public OrderDeliveryFactoryVO selectDeliveryFactory(OrderDeliveryFactoryVO vo) {
        return orderManageDAO.selectDeliveryFactory(vo);
    }

    @Override
    public int saveDeliveryFactory(OrderDeliveryFactoryVO vo) {
        return orderManageDAO.upsertDeliveryFactory(vo);
    }
}
