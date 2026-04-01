package kr.co.matpam.admin.order.service.impl;

import java.util.List;
import java.util.Date;
import java.text.SimpleDateFormat;
import javax.annotation.Resource;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import kr.co.matpam.admin.order.service.OrderService;
import kr.co.matpam.admin.order.service.OrderVO;
import kr.co.matpam.admin.order.service.OrderItemVO;
import kr.co.matpam.admin.member.service.MeatMoneyService;

/**
 * 주문 서비스 구현체
 */
@Service("orderService")
public class OrderServiceImpl extends EgovAbstractServiceImpl implements OrderService {

    @Resource(name = "orderDAO")
    private OrderDAO orderDAO;

    @Resource(name = "meatMoneyService")
    private MeatMoneyService meatMoneyService;

    @Override
    @Transactional
    public String processOrder(OrderVO orderVO) throws Exception {
        // 1. 주문번호 생성
        String orderNo = generateOrderNo();
        orderVO.setOrderNo(orderNo);
        orderVO.setOrderStatusCd("ORDER");
        orderVO.setPaymentStatusCd("PAID");

        // 2. 주문 마스터 저장
        orderDAO.insertOrder(orderVO);

        // 3. 주문 상세 저장
        if (orderVO.getOrderItems() != null) {
            for (OrderItemVO item : orderVO.getOrderItems()) {
                item.setOrderId(orderVO.getOrderId());
                item.setOpType(orderVO.getOpType());
                orderDAO.insertOrderItem(item);
            }
        }

        // 4. 맛팜 머니 차감 (결제)
        // 결제 금액이 있을 경우에만 실행
        if (orderVO.getTotalPayAmt() != null && orderVO.getTotalPayAmt().longValue() > 0) {
            meatMoneyService.deductMoney(
                orderVO.getBuyerMemberId(), 
                orderVO.getTotalPayAmt(), 
                orderNo
            );
        }

        return orderNo;
    }

    private String generateOrderNo() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        return "ORD" + sdf.format(new Date()) + (int)(Math.random() * 1000);
    }

    @Override
    public OrderVO selectOrder(Long orderId) throws Exception {
        OrderVO order = orderDAO.selectOrder(orderId);
        if (order != null) {
            order.setOrderItems(orderDAO.selectOrderItemList(orderId));
        }
        return order;
    }

    @Override
    public List<OrderVO> selectOrderList(OrderVO orderVO) throws Exception {
        return orderDAO.selectOrderList(orderVO);
    }

    @Override
    public int selectOrderListTotCnt(OrderVO orderVO) throws Exception {
        return orderDAO.selectOrderListTotCnt(orderVO);
    }

    @Override
    @Transactional
    public void cancelOrder(Long orderId) throws Exception {
        OrderVO order = orderDAO.selectOrder(orderId);
        if (order == null) throw new Exception("주문 정보를 찾을 수 없습니다.");
        
        if ("CANCEL".equals(order.getOrderStatusCd())) {
             throw new Exception("이미 취소된 주문입니다.");
        }

        // 상태 변경
        order.setOrderStatusCd("CANCEL");
        orderDAO.updateOrderStatus(order);

        // 머니 환불 (결제되었던 경우)
        if ("PAID".equals(order.getPaymentStatusCd())) {
            meatMoneyService.chargeMoney(
                order.getBuyerMemberId(), 
                order.getTotalPayAmt(), 
                "SYSTEM_CANCEL"
            );
        }
    }
}
