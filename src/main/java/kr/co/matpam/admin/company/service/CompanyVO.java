package kr.co.matpam.admin.company.service;

import kr.co.matpam.common.service.MatpamBaseVO;
import java.util.Date;

/**
 * 업체 (tb_company) VO
 */
public class CompanyVO extends MatpamBaseVO {

    private Long companyId;
    private String companyType;
    private String sellerType;
    private String companyName;
    private String businessNo;
    private String ceoName;
    private String postalCode;
    private String address1;
    private String address2;
    private String phone;
    private String email;
    private String defaultTaxType;
    private String bizStatus;
    private Date bizCheckedAt;
    private String bizCheckedResult;
    private String status;
    private Date createdAt;
    private Date updatedAt;

    // Getter & Setter
    public Long getCompanyId() { return companyId; }
    public void setCompanyId(Long companyId) { this.companyId = companyId; }


    public String getCompanyType() { return companyType; }
    public void setCompanyType(String companyType) { this.companyType = companyType; }

    public String getSellerType() { return sellerType; }
    public void setSellerType(String sellerType) { this.sellerType = sellerType; }

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

    public String getDefaultTaxType() { return defaultTaxType; }
    public void setDefaultTaxType(String defaultTaxType) { this.defaultTaxType = defaultTaxType; }

    public String getBizStatus() { return bizStatus; }
    public void setBizStatus(String bizStatus) { this.bizStatus = bizStatus; }

    public Date getBizCheckedAt() { return bizCheckedAt; }
    public void setBizCheckedAt(Date bizCheckedAt) { this.bizCheckedAt = bizCheckedAt; }

    public String getBizCheckedResult() { return bizCheckedResult; }
    public void setBizCheckedResult(String bizCheckedResult) { this.bizCheckedResult = bizCheckedResult; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}
