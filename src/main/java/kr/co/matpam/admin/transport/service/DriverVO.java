package kr.co.matpam.admin.transport.service;

import java.io.Serializable;
import java.util.Date;
import kr.co.matpam.common.service.MatpamBaseVO;

/**
 * 운송기사 VO
 */
public class DriverVO extends MatpamBaseVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long driverId;
    private Long tenantId;
    private Long channelId;
    private String driverName;
    private String licenseNo;
    private String mobile;
    private String status;
    private Date createdAt;
    private Date updatedAt;

    // Getters and Setters
    public Long getDriverId() { return driverId; }
    public void setDriverId(Long driverId) { this.driverId = driverId; }
    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }
    public Long getChannelId() { return channelId; }
    public void setChannelId(Long channelId) { this.channelId = channelId; }
    public String getDriverName() { return driverName; }
    public void setDriverName(String driverName) { this.driverName = driverName; }
    public String getLicenseNo() { return licenseNo; }
    public void setLicenseNo(String licenseNo) { this.licenseNo = licenseNo; }
    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}
