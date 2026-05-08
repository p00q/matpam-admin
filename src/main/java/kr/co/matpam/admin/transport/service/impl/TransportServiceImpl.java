package kr.co.matpam.admin.transport.service.impl;

import java.util.List;
import javax.annotation.Resource;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.matpam.admin.transport.service.DriverVO;
import kr.co.matpam.admin.transport.service.VehicleVO;
import kr.co.matpam.admin.transport.service.DriverVehicleVO;
import kr.co.matpam.admin.transport.service.TransportService;
import kr.co.matpam.admin.common.service.AuditService;
import kr.co.matpam.admin.common.service.AuditVO;

@Service("transportService")
public class TransportServiceImpl extends EgovAbstractServiceImpl implements TransportService {

    @Resource(name = "transportMapper")
    private TransportMapper transportMapper;

    @Resource(name = "auditService")
    private AuditService auditService;

    @Override
    public List<DriverVO> selectDriverList(DriverVO vo) throws Exception {
        return transportMapper.selectDriverList(vo);
    }

    @Override
    public int selectDriverListTotCnt(DriverVO vo) throws Exception {
        return transportMapper.selectDriverListTotCnt(vo);
    }

    @Override
    public DriverVO selectDriverDetail(DriverVO vo) throws Exception {
        return transportMapper.selectDriverDetail(vo);
    }

    @Override
    @Transactional
    public void registDriver(DriverVO vo) throws Exception {
        transportMapper.insertDriver(vo);
        logAudit(vo.getTenantId(), "DRIVER", vo.getDriverId(), "INSERT", null, "New driver registered");
    }

    @Override
    @Transactional
    public void modifyDriver(DriverVO vo) throws Exception {
        transportMapper.updateDriver(vo);
        logAudit(vo.getTenantId(), "DRIVER", vo.getDriverId(), "UPDATE", null, "Driver information updated");
    }

    @Override
    @Transactional
    public void modifyDriverStatus(DriverVO vo) throws Exception {
        transportMapper.updateDriverStatus(vo);
        logAudit(vo.getTenantId(), "DRIVER", vo.getDriverId(), "UPDATE", null, "Driver status changed to " + vo.getStatus());
    }

    @Override
    public List<VehicleVO> selectVehicleList(VehicleVO vo) throws Exception {
        return transportMapper.selectVehicleList(vo);
    }

    @Override
    public int selectVehicleListTotCnt(VehicleVO vo) throws Exception {
        return transportMapper.selectVehicleListTotCnt(vo);
    }

    @Override
    public VehicleVO selectVehicleDetail(VehicleVO vo) throws Exception {
        return transportMapper.selectVehicleDetail(vo);
    }

    @Override
    @Transactional
    public void registVehicle(VehicleVO vo) throws Exception {
        transportMapper.insertVehicle(vo);
        logAudit(vo.getTenantId(), "VEHICLE", vo.getVehicleId(), "INSERT", null, "New vehicle registered");
    }

    @Override
    @Transactional
    public void modifyVehicle(VehicleVO vo) throws Exception {
        transportMapper.updateVehicle(vo);
        logAudit(vo.getTenantId(), "VEHICLE", vo.getVehicleId(), "UPDATE", null, "Vehicle information updated");
    }

    @Override
    @Transactional
    public void modifyVehicleStatus(VehicleVO vo) throws Exception {
        transportMapper.updateVehicleStatus(vo);
        logAudit(vo.getTenantId(), "VEHICLE", vo.getVehicleId(), "UPDATE", null, "Vehicle status changed to " + vo.getStatus());
    }

    @Override
    public List<DriverVehicleVO> selectDriverVehicleHistory(DriverVehicleVO vo) throws Exception {
        return transportMapper.selectDriverVehicleHistory(vo);
    }

    @Override
    @Transactional
    public void assignDriverToVehicle(Long driverId, Long vehicleId) throws Exception {
        DriverVehicleVO vo = new DriverVehicleVO();
        vo.setDriverId(driverId);
        vo.setVehicleId(vehicleId);
        
        // End current mappings
        transportMapper.endDriverVehicleMapping(vo);
        
        // Create new mapping
        transportMapper.insertDriverVehicle(vo);
        
        logAudit(null, "DRIVER_VEHICLE", vo.getMappingId(), "INSERT", null, "Driver assigned to vehicle");
    }

    private void logAudit(Long tenantId, String entityName, Long entityId, String action, String before, String after) {
        try {
            AuditVO audit = new AuditVO();
            audit.setTenantId(tenantId);
            audit.setEntityName(entityName);
            audit.setEntityId(entityId);
            audit.setActionType(action);
            audit.setBeforeJson(before);
            audit.setAfterJson("{\"message\":\"" + after + "\"}");
            auditService.log(audit);
        } catch (Exception e) {
            // Log error but don't fail business logic
            e.printStackTrace();
        }
    }
}
