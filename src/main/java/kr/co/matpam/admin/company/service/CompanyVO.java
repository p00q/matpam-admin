package kr.co.matpam.admin.company.service;

import kr.co.matpam.common.service.MatpamBaseVO;
import java.util.Date;

/**
 * 업체 (tb_company) VO
 */
public class CompanyVO extends MatpamBaseVO {

    private Long companyId;
    private Long tenantId;
    private String companyType;
    private String sellerType;
    private java.util.List<CompanyContactVO> contactList;
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

    // 추가된 필드 (Join 및 상세 정보용)
    private String channelName;
    private String bankName;
    private String accountNo;
    private String accountHolder;
    private String memberGrade;
    private Date creditAgreementDt;
    private java.math.BigDecimal creditLimitAmount;
    private java.math.BigDecimal advanceBalance;
    private java.math.BigDecimal meatMoneyBalance;

    // Getter & Setter
    public Long getCompanyId() { return companyId; }
    public void setCompanyId(Long companyId) { this.companyId = companyId; }

    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }

    public java.util.List<CompanyContactVO> getContactList() { return contactList; }
    public void setContactList(java.util.List<CompanyContactVO> contactList) { this.contactList = contactList; }


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

    public String getChannelName() { return channelName; }
    public void setChannelName(String channelName) { this.channelName = channelName; }

    public String getBankName() { return bankName; }
    public void setBankName(String bankName) { this.bankName = bankName; }

    public String getAccountNo() { return accountNo; }
    public void setAccountNo(String accountNo) { this.accountNo = accountNo; }

    public String getAccountHolder() { return accountHolder; }
    public void setAccountHolder(String accountHolder) { this.accountHolder = accountHolder; }

    public String getMemberGrade() { return memberGrade; }
    public void setMemberGrade(String memberGrade) { this.memberGrade = memberGrade; }

    public Date getCreditAgreementDt() { return creditAgreementDt; }
    public void setCreditAgreementDt(Date creditAgreementDt) { this.creditAgreementDt = creditAgreementDt; }

    public java.math.BigDecimal getCreditLimitAmount() { return creditLimitAmount; }
    public void setCreditLimitAmount(java.math.BigDecimal creditLimitAmount) { this.creditLimitAmount = creditLimitAmount; }

    public java.math.BigDecimal getAdvanceBalance() { return advanceBalance; }
    public void setAdvanceBalance(java.math.BigDecimal advanceBalance) { this.advanceBalance = advanceBalance; }

    public java.math.BigDecimal getMeatMoneyBalance() { return meatMoneyBalance; }
    public void setMeatMoneyBalance(java.math.BigDecimal meatMoneyBalance) { this.meatMoneyBalance = meatMoneyBalance; }
}
