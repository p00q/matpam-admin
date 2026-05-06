package kr.co.matpam.admin.logistics.service.impl;

import java.util.List;
import kr.co.matpam.admin.logistics.service.ShipmentVO;
import kr.co.matpam.admin.logistics.service.ShipmentLineVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

@Mapper("shipmentMapper")
public interface ShipmentMapper {
    
    void insertShipment(ShipmentVO vo);
    
    void insertShipmentLine(ShipmentLineVO vo);
    
    void updateShipmentStatus(ShipmentVO vo);
    
    List<ShipmentVO> selectShipmentListByOrderId(Long orderId);
    
    List<ShipmentLineVO> selectShipmentLinesByShipmentId(Long shipmentId);
}
