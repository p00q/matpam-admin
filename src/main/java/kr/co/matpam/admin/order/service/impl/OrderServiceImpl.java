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
import kr.co.matpam.admin.order.service.OrderLineVO;
import kr.co.matpam.admin.financial.service.B2bFinancialService;

/**
 * 통합 주문 관리 서비스 구현체
 */
@Service("orderService")
public class OrderServiceImpl extends EgovAbstractServiceImpl implements OrderService {

    @Resource(name = "orderDAO")
    private OrderDAO orderDAO;

    @Resource(name = "b2bFinancialService")
    private B2bFinancialService b2bFinancialService;

    @Override
    @Transactional
    public String processOrder(OrderVO orderVO) throws Exception {
        // 1. 가용 미트머니 확인
        java.math.BigDecimal totalAmount = orderVO.getTotalOrderAmount();
        java.math.BigDecimal available = b2bFinancialService.getAvailableMeatMoney(orderVO.getTenantId(), orderVO.getSellerCompanyId(), orderVO.getBuyerCompanyId());
        
        if (available.compareTo(totalAmount) < 0) {
            throw new Exception("미트머니 잔액이 부족합니다. (가용: " + available + ", 주문: " + totalAmount + ")");
        }

        // 2. 주문번호 생성
        String orderNo = generateOrderNo();
        orderVO.setOrderNo(orderNo);
        orderVO.setOrderDate(new Date());
        orderVO.setOrderStatus("RECEIVED");
        orderVO.setPaymentStatus("PAID"); // 미트머니로 결제되므로 PAID 처리
        orderVO.setShipmentStatus("NOT_STARTED");

        // 3. 주문 마스터 저장
        orderDAO.insertOrder(orderVO);

        // 4. 주문 상세 저장
        if (orderVO.getOrderLines() != null) {
            int lineNo = 1;
            for (OrderLineVO line : orderVO.getOrderLines()) {
                line.setOrderId(orderVO.getOrderId());
                line.setLineNo(lineNo++);
                orderDAO.insertOrderLine(line);
            }
        }

        // 5. 미트머니 차감 (Ledger 기록)
        b2bFinancialService.executeMeatMoneyPayment(orderVO.getTenantId(), orderVO.getSellerCompanyId(), orderVO.getBuyerCompanyId(), 
                                                   orderVO.getOrderId(), totalAmount, orderVO.getCreatedBy());

        return orderNo;
    }

    private String generateOrderNo() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
        return "ORD" + sdf.format(new Date()) + String.format("%03d", (int)(Math.random() * 1000));
    }

    @Override
    public OrderVO selectOrder(OrderVO orderVO) throws Exception {
        OrderVO order = orderDAO.selectOrder(orderVO);
        if (order != null) {
            order.setOrderLines(orderDAO.selectOrderLineList(order.getOrderId()));
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
    public void cancelOrder(OrderVO orderVO) throws Exception {
        OrderVO order = orderDAO.selectOrder(orderVO);
        if (order == null) throw new Exception("주문 정보를 찾을 수 없습니다.");
        
        if ("CANCELLED".equals(order.getOrderStatus())) {
             throw new Exception("이미 취소된 주문입니다.");
        }

        // 상태 변경
        order.setOrderStatus("CANCELLED");
        // order.setUpdatedBy(...) // 필요한 경우 세션 관리자 ID 설정
        orderDAO.updateOrderStatus(order);
    }
}
