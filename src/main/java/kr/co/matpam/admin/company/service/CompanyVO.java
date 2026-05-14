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
    private String fax;
    private String email;
    private String defaultTaxType;
    private String bizStatus;
    private Date bizCheckedAt;
    private String bizCheckedResult;
    private String status;
    private Date createdAt;
    private Date updatedAt;

    // 테넌트 정보 (Join용)
    private String tenantName;

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
    private Long channelId;
    private String primaryContactName;
    private String primaryContactMobile;

    // 몰 기본정보 확장 필드
    private String contactPhone;        // 연락처 (추가 연락수단)
    private String ecommerceRegNo;      // 통신판매업 신고번호
    private String factoryPostalCode;   // 공장 우편번호
    private String factoryAddress1;     // 공장 기본주소
    private String factoryAddress2;     // 공장 상세주소

    // Getter & Setter
    public Long getCompanyId() { return companyId; }
    public void setCompanyId(Long companyId) { this.companyId = companyId; }

    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }

    public String getTenantName() { return tenantName; }
    public void setTenantName(String tenantName) { this.tenantName = tenantName; }

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

    public String getFax() { return fax; }
    public void setFax(String fax) { this.fax = fax; }

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

    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }

    public String getEcommerceRegNo() { return ecommerceRegNo; }
    public void setEcommerceRegNo(String ecommerceRegNo) { this.ecommerceRegNo = ecommerceRegNo; }

    public String getFactoryPostalCode() { return factoryPostalCode; }
    public void setFactoryPostalCode(String factoryPostalCode) { this.factoryPostalCode = factoryPostalCode; }

    public String getFactoryAddress1() { return factoryAddress1; }
    public void setFactoryAddress1(String factoryAddress1) { this.factoryAddress1 = factoryAddress1; }

    public String getFactoryAddress2() { return factoryAddress2; }
    public void setFactoryAddress2(String factoryAddress2) { this.factoryAddress2 = factoryAddress2; }

    public Long getChannelId() { return channelId; }
    public void setChannelId(Long channelId) { this.channelId = channelId; }

    public String getPrimaryContactName() { return primaryContactName; }
    public void setPrimaryContactName(String primaryContactName) { this.primaryContactName = primaryContactName; }

    public String getPrimaryContactMobile() { return primaryContactMobile; }
    public void setPrimaryContactMobile(String primaryContactMobile) { this.primaryContactMobile = primaryContactMobile; }
}
