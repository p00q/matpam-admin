package kr.co.matpam.admin.transport.service;

import java.io.Serializable;
import java.util.Date;
import kr.co.matpam.common.service.MatpamBaseVO;

/**
 * 운송차량 VO
 */
public class VehicleVO extends MatpamBaseVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long vehicleId;
    private Long tenantId;
    private Long channelId;
    private String plateNo;
    private String vehicleType;
    private String status;
    private Date createdAt;
    private Date updatedAt;

    // Getters and Setters
    public Long getVehicleId() { return vehicleId; }
    public void setVehicleId(Long vehicleId) { this.vehicleId = vehicleId; }
    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }
    public Long getChannelId() { return channelId; }
    public void setChannelId(Long channelId) { this.channelId = channelId; }
    public String getPlateNo() { return plateNo; }
    public void setPlateNo(String plateNo) { this.plateNo = plateNo; }
    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}
