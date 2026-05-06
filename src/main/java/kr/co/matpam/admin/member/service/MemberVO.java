package kr.co.matpam.admin.member.service;

import java.io.Serializable;
import java.util.Date;
import kr.co.matpam.common.service.MatpamBaseVO;

public class MemberVO extends MatpamBaseVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long companyId;
    private Long tenantId;
    private String companyType;
    private String companyName;
    private String businessNo;
    private String ceoName;
    private String postalCode;
    private String address1;
    private String address2;
    private String phone;
    private String email;
    private String status;
    private Date createdAt;
    
    // 검색용
    private String searchKeyword;

    public Long getCompanyId() { return companyId; }
    public void setCompanyId(Long companyId) { this.companyId = companyId; }
    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }
    public String getCompanyType() { return companyType; }
    public void setCompanyType(String companyType) { this.companyType = companyType; }
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }
    public String getBusinessNo() { return businessNo; }
    public void setBusinessNo(String businessNo) { this.businessNo = businessNo; }
    public String getCeoName() { return ceoName; }
    public void setCeoName(String ceoName) { this.ceoName = ceoName; }
    public String getPostalCode() { return postalCode; }
    public void setPostalCode(String postalCode) { this.postalCode = postalCode; }
    public String getAddress1() { return address1; }
    public void setAddress1(String address1) { this.address1 = address1; }
    public String getAddress2() { return address2; }
    public void setAddress2(String address2) { this.address2 = address2; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    // Masked Getters for Security
    public String getMaskedCeoName() { return kr.co.matpam.common.util.SecurityUtil.maskName(ceoName); }
    public String getMaskedPhone() { return kr.co.matpam.common.util.SecurityUtil.maskMobile(phone); }
    public String getMaskedEmail() { return kr.co.matpam.common.util.SecurityUtil.maskEmail(email); }
    public String getMaskedBusinessNo() { return kr.co.matpam.common.util.SecurityUtil.maskBusinessNo(businessNo); }

    public String getSearchKeyword() { return searchKeyword; }
    public void setSearchKeyword(String searchKeyword) { this.searchKeyword = searchKeyword; }
}
