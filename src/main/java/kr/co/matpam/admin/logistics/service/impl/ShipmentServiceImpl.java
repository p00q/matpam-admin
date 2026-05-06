package kr.co.matpam.admin.logistics.service.impl;

import java.util.Date;
import java.text.SimpleDateFormat;
import javax.annotation.Resource;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import kr.co.matpam.admin.logistics.service.ShipmentService;
import kr.co.matpam.admin.logistics.service.ShipmentVO;
import kr.co.matpam.admin.logistics.service.ShipmentLineVO;
import kr.co.matpam.admin.order.service.OrderVO;
import kr.co.matpam.admin.order.service.impl.OrderDAO;

@Service("shipmentService")
public class ShipmentServiceImpl extends EgovAbstractServiceImpl implements ShipmentService {

    @Resource(name = "shipmentMapper")
    private ShipmentMapper shipmentMapper;

    @Resource(name = "orderDAO")
    private OrderDAO orderDAO;

    @Override
    @Transactional
    public void processShipping(ShipmentVO shipmentVO) throws Exception {
        // 1. 배송 번호 생성
        shipmentVO.setShipmentNo("SHP" + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()));
        shipmentVO.setShipmentStatus("SHIPPED");
        shipmentVO.setShippedAt(new Date());

        // 2. 배송 마스터 저장
        shipmentMapper.insertShipment(shipmentVO);

        // 3. 배송 상세 저장 (주문 수량 전체 배송 가정 - 간소화)
        // 실제로는 UI에서 넘겨받은 수량으로 처리해야 함.

        // 4. 주문 상태 변경
        OrderVO order = new OrderVO();
        order.setOrderId(shipmentVO.getOrderId());
        order.setShipmentStatus("SHIPPED");
        order.setOrderStatus("CONFIRMED"); // 배송 시작 시 '주문 확인/진행' 상태로 고정
        orderDAO.updateOrderStatus(order);
    }
}
