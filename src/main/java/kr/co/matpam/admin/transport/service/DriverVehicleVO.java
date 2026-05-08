package kr.co.matpam.admin.transport.service;

import java.io.Serializable;
import java.util.Date;

/**
 * 기사-차량 배정 VO
 */
public class DriverVehicleVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long mappingId;
    private Long driverId;
    private Long vehicleId;
    private Date assignedAt;
    private Date unassignedAt;
    private String isCurrent;
    private String status;
    private Date createdAt;

    // Join Fields
    private String driverName;
    private String plateNo;
    private String vehicleType;

    // Getters and Setters
    public Long getMappingId() { return mappingId; }
    public void setMappingId(Long mappingId) { this.mappingId = mappingId; }
    public Long getDriverId() { return driverId; }
    public void setDriverId(Long driverId) { this.driverId = driverId; }
    public Long getVehicleId() { return vehicleId; }
    public void setVehicleId(Long vehicleId) { this.vehicleId = vehicleId; }
    public Date getAssignedAt() { return assignedAt; }
    public void setAssignedAt(Date assignedAt) { this.assignedAt = assignedAt; }
    public Date getUnassignedAt() { return unassignedAt; }
    public void setUnassignedAt(Date unassignedAt) { this.unassignedAt = unassignedAt; }
    public String getIsCurrent() { return isCurrent; }
    public void setIsCurrent(String isCurrent) { this.isCurrent = isCurrent; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public String getDriverName() { return driverName; }
    public void setDriverName(String driverName) { this.driverName = driverName; }
    public String getPlateNo() { return plateNo; }
    public void setPlateNo(String plateNo) { this.plateNo = plateNo; }
    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }
}
