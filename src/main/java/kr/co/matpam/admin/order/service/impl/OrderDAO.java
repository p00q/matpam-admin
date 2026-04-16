package kr.co.matpam.admin.order.service.impl;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;
import kr.co.matpam.admin.order.service.OrderVO;
import kr.co.matpam.admin.order.service.OrderItemVO;

/**
 * 주문 정보 DAO (MyBatis Mapper 연동)
 */
@Repository("orderDAO")
public class OrderDAO extends EgovAbstractMapper {

    /**
     * 주문 마스터 등록
     */
    public int insertOrder(OrderVO orderVO) {
        return insert("matpam.order.OrderMapper.insertOrder", orderVO);
    }

    /**
     * 주문 상품 상세 등록
     */
    public void insertOrderItem(OrderItemVO itemVO) {
        insert("matpam.order.OrderMapper.insertOrderItem", itemVO);
    }

    /**
     * 주문 목록 조회
     */
    public List<OrderVO> selectOrderList(OrderVO orderVO) {
        return selectList("matpam.order.OrderMapper.selectOrderList", orderVO);
    }

    /**
     * 주문 목록 총 건수
     */
    public int selectOrderListTotCnt(OrderVO orderVO) {
        return (Integer) selectOne("matpam.order.OrderMapper.selectOrderListTotCnt", orderVO);
    }

    /**
     * 주문 상세 조회
     */
    public OrderVO selectOrder(OrderVO orderVO) {
        return (OrderVO) selectOne("matpam.order.OrderMapper.selectOrder", orderVO);
    }

    /**
     * 주문 상품 상세 조회
     */
    public List<OrderItemVO> selectOrderItemList(OrderItemVO itemVO) {
        return selectList("matpam.order.OrderMapper.selectOrderItemList", itemVO);
    }

    /**
     * 주문 상태 업데이트
     */
    public int updateOrderStatus(OrderVO orderVO) {
        return update("matpam.order.OrderMapper.updateOrderStatus", orderVO);
    }
}
