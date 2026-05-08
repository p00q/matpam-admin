package kr.co.matpam.admin.common.service;

import java.io.Serializable;
import java.util.Date;

/**
 * 감사 로그(Audit Log) VO
 */
public class AuditVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long auditId;
    private Long tenantId;
    private String entityName;
    private Long entityId;
    private String actionType;
    private String beforeJson;
    private String afterJson;
    private Long actorUserId;
    private Date actedAt;
    private String ipAddress;
    private String reasonCode;
    private Long approvalRequestId;
    private String traceId;

    // Getters and Setters
    public Long getAuditId() { return auditId; }
    public void setAuditId(Long auditId) { this.auditId = auditId; }
    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }
    public String getEntityName() { return entityName; }
    public void setEntityName(String entityName) { this.entityName = entityName; }
    public Long getEntityId() { return entityId; }
    public void setEntityId(Long entityId) { this.entityId = entityId; }
    public String getActionType() { return actionType; }
    public void setActionType(String actionType) { this.actionType = actionType; }
    public String getBeforeJson() { return beforeJson; }
    public void setBeforeJson(String beforeJson) { this.beforeJson = beforeJson; }
    public String getAfterJson() { return afterJson; }
    public void setAfterJson(String afterJson) { this.afterJson = afterJson; }
    public Long getActorUserId() { return actorUserId; }
    public void setActorUserId(Long actorUserId) { this.actorUserId = actorUserId; }
    public Date getActedAt() { return actedAt; }
    public void setActedAt(Date actedAt) { this.actedAt = actedAt; }
    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }
    public String getReasonCode() { return reasonCode; }
    public void setReasonCode(String reasonCode) { this.reasonCode = reasonCode; }
    public Long getApprovalRequestId() { return approvalRequestId; }
    public void setApprovalRequestId(Long approvalRequestId) { this.approvalRequestId = approvalRequestId; }
    public String getTraceId() { return traceId; }
    public void setTraceId(String traceId) { this.traceId = traceId; }
}
