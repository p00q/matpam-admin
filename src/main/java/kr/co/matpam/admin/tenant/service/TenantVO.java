package kr.co.matpam.admin.tenant.service;

import kr.co.matpam.common.service.MatpamBaseVO;
import java.util.Date;

/**
 * 테넌트 (tb_tenant) VO
 */
public class TenantVO extends MatpamBaseVO {

    private Long tenantId;
    private String tenantName;
    private String status;
    private Date createdAt;
    private Date updatedAt;

    // Getter & Setter
    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }

    public String getTenantName() { return tenantName; }
    public void setTenantName(String tenantName) { this.tenantName = tenantName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}
