package kr.co.matpam.admin.company.service;

import kr.co.matpam.common.service.MatpamBaseVO;
import java.util.Date;

/**
 * 업체 담당자 (tb_company_contact) VO
 */
public class CompanyContactVO extends MatpamBaseVO {

    private Long contactId;
    private Long companyId;
    private String contactName;
    private String contactRole;
    private String mobile;
    private String email;
    private String isPrimary;
    private Long linkedUserId;
    private String status;
    private Date createdAt;
    private Date updatedAt;

    // Getter & Setter
    public Long getContactId() { return contactId; }
    public void setContactId(Long contactId) { this.contactId = contactId; }

    public Long getCompanyId() { return companyId; }
    public void setCompanyId(Long companyId) { this.companyId = companyId; }

    public String getContactName() { return contactName; }
    public void setContactName(String contactName) { this.contactName = contactName; }

    public String getContactRole() { return contactRole; }
    public void setContactRole(String contactRole) { this.contactRole = contactRole; }

    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getIsPrimary() { return isPrimary; }
    public void setIsPrimary(String isPrimary) { this.isPrimary = isPrimary; }

    public Long getLinkedUserId() { return linkedUserId; }
    public void setLinkedUserId(Long linkedUserId) { this.linkedUserId = linkedUserId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}
