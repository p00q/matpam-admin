package kr.co.matpam.admin.transport.service.impl;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import kr.co.matpam.admin.transport.service.DriverVO;
import kr.co.matpam.admin.transport.service.VehicleVO;
import kr.co.matpam.admin.transport.service.DriverVehicleVO;

/**
 * 운송 관리 Mapper
 */
@Mapper("transportMapper")
public interface TransportMapper {

    /* ── 운송기사 ── */
    List<DriverVO> selectDriverList(DriverVO vo) throws Exception;
    int selectDriverListTotCnt(DriverVO vo) throws Exception;
    DriverVO selectDriverDetail(DriverVO vo) throws Exception;
    void insertDriver(DriverVO vo) throws Exception;
    void updateDriver(DriverVO vo) throws Exception;
    void updateDriverStatus(DriverVO vo) throws Exception;

    /* ── 차량 ── */
    List<VehicleVO> selectVehicleList(VehicleVO vo) throws Exception;
    int selectVehicleListTotCnt(VehicleVO vo) throws Exception;
    VehicleVO selectVehicleDetail(VehicleVO vo) throws Exception;
    void insertVehicle(VehicleVO vo) throws Exception;
    void updateVehicle(VehicleVO vo) throws Exception;
    void updateVehicleStatus(VehicleVO vo) throws Exception;

    /* ── 배정 ── */
    List<DriverVehicleVO> selectDriverVehicleHistory(DriverVehicleVO vo) throws Exception;
    void insertDriverVehicle(DriverVehicleVO vo) throws Exception;
    void endDriverVehicleMapping(DriverVehicleVO vo) throws Exception;
}
