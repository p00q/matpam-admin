package kr.co.matpam.admin.transport.service;

import java.util.List;

/**
 * 운송 관리 Service
 */
public interface TransportService {

    /* ── 운송기사 ── */
    List<DriverVO> selectDriverList(DriverVO vo) throws Exception;
    int selectDriverListTotCnt(DriverVO vo) throws Exception;
    DriverVO selectDriverDetail(DriverVO vo) throws Exception;
    void registDriver(DriverVO vo) throws Exception;
    void modifyDriver(DriverVO vo) throws Exception;
    void modifyDriverStatus(DriverVO vo) throws Exception;

    /* ── 차량 ── */
    List<VehicleVO> selectVehicleList(VehicleVO vo) throws Exception;
    int selectVehicleListTotCnt(VehicleVO vo) throws Exception;
    VehicleVO selectVehicleDetail(VehicleVO vo) throws Exception;
    void registVehicle(VehicleVO vo) throws Exception;
    void modifyVehicle(VehicleVO vo) throws Exception;
    void modifyVehicleStatus(VehicleVO vo) throws Exception;

    /* ── 배정 ── */
    List<DriverVehicleVO> selectDriverVehicleHistory(DriverVehicleVO vo) throws Exception;
    void assignDriverToVehicle(Long driverId, Long vehicleId) throws Exception;
}
