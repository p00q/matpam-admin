package kr.co.matpam.admin.tenant.service;

import kr.co.matpam.common.service.MatpamBaseVO;
import java.util.Date;

/**
 * 채널 (tb_channel) VO
 */
public class ChannelVO extends MatpamBaseVO {

    private Long channelId;
    private Long tenantId;
    private String channelCode;
    private String channelName;
    private String status;
    private Integer sortOrder;
    private Date createdAt;
    private Date updatedAt;

    // Getter & Setter
    public Long getChannelId() { return channelId; }
    public void setChannelId(Long channelId) { this.channelId = channelId; }

    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }

    public String getChannelCode() { return channelCode; }
    public void setChannelCode(String channelCode) { this.channelCode = channelCode; }

    public String getChannelName() { return channelName; }
    public void setChannelName(String channelName) { this.channelName = channelName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}
