package kr.co.matpam.admin.member.service;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import kr.co.matpam.common.service.MatpamBaseVO;

/**
 * 회원 통합 VO (member_master + profiles)
 */
public class MemberVO extends MatpamBaseVO implements Serializable {

    private static final long serialVersionUID = 1L;

    // member_master fields
    private Long memberId;
    private Long companyId;
    private Long createdByMemberId;
    private String memberTypeCd;
    private String channelCd;    // 전국택배, 직배송, 공장수령
    private String loginId;
    private String loginPwd;
    private String loginPwdConfirm; // UI용 비밀번호 확인
    
    private String memberName;
    private String mobileNo;

    private String companyName;
    private String ceoName;
    private String bizRegNo;
    private String companyTelNo;
    private String ceoMobileNo;
    private String email;
    private String zipCode;
    private String addr1;
    private String addr2;
    private Date lastLoginDt;
    private String joinStatusCd;
    private Date joinDt;
    private Date withdrawDt;
    private String remark;
    private String useYn;
    private String delYn;

    // buyer_profile fields
    private String managingChannelCd;
    private String memberGradeCd;
    private BigDecimal meatmoneyBalanceAmt;
    private BigDecimal creditBalanceAmt;
    private BigDecimal totalAvailableAmt;
    private BigDecimal monthOrderAmt;
    private BigDecimal yearOrderAmt;
    private BigDecimal totalOrderAmt;
    
    // seller_profile fields
    private String sellerTypeCd; // 원물, 가공
    private String taxTypeCd;    // 과세유형
    
    // seller_settlement_account fields
    private String bankCd;
    private String accountNo;
    private String accountName;

    // admin_profile fields
    private String adminRoleCd;

    // Contacts
    private List<MemberContactVO> contacts = new java.util.ArrayList<>();

    // Helper for UI
    private String memberTypeName;
    private String memberGradeName;
    private String joinStatusName;
    private String channelName;
    private String sellerTypeName;

    // Getters and Setters
    public Long getMemberId() { return memberId; }
    public void setMemberId(Long memberId) { this.memberId = memberId; }
    public Long getCompanyId() { return companyId; }
    public void setCompanyId(Long companyId) { this.companyId = companyId; }
    public Long getCreatedByMemberId() { return createdByMemberId; }
    public void setCreatedByMemberId(Long createdByMemberId) { this.createdByMemberId = createdByMemberId; }
    public String getMemberTypeCd() { return memberTypeCd; }
    public void setMemberTypeCd(String memberTypeCd) { this.memberTypeCd = memberTypeCd; }
    public String getChannelCd() { return channelCd; }
    public void setChannelCd(String channelCd) { this.channelCd = channelCd; }
    public String getLoginId() { return loginId; }
    public void setLoginId(String loginId) { this.loginId = loginId; }
    public String getLoginPwd() { return loginPwd; }
    public void setLoginPwd(String loginPwd) { this.loginPwd = loginPwd; }
    public String getLoginPwdConfirm() { return loginPwdConfirm; }
    public void setLoginPwdConfirm(String loginPwdConfirm) { this.loginPwdConfirm = loginPwdConfirm; }
    public String getMemberName() { return memberName; }
    public void setMemberName(String memberName) { this.memberName = memberName; }
    public String getMobileNo() { return mobileNo; }
    public void setMobileNo(String mobileNo) { this.mobileNo = mobileNo; }
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }
    public String getCeoName() { return ceoName; }
    public void setCeoName(String ceoName) { this.ceoName = ceoName; }
    public String getBizRegNo() { return bizRegNo; }
    public void setBizRegNo(String bizRegNo) { this.bizRegNo = bizRegNo; }
    public String getCompanyTelNo() { return companyTelNo; }
    public void setCompanyTelNo(String companyTelNo) { this.companyTelNo = companyTelNo; }
    public String getCeoMobileNo() { return ceoMobileNo; }
    public void setCeoMobileNo(String ceoMobileNo) { this.ceoMobileNo = ceoMobileNo; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getZipCode() { return zipCode; }
    public void setZipCode(String zipCode) { this.zipCode = zipCode; }
    public String getAddr1() { return addr1; }
    public void setAddr1(String addr1) { this.addr1 = addr1; }
    public String getAddr2() { return addr2; }
    public void setAddr2(String addr2) { this.addr2 = addr2; }
    public Date getLastLoginDt() { return lastLoginDt; }
    public void setLastLoginDt(Date lastLoginDt) { this.lastLoginDt = lastLoginDt; }
    public String getJoinStatusCd() { return joinStatusCd; }
    public void setJoinStatusCd(String joinStatusCd) { this.joinStatusCd = joinStatusCd; }
    public Date getJoinDt() { return joinDt; }
    public void setJoinDt(Date joinDt) { this.joinDt = joinDt; }
    public Date getWithdrawDt() { return withdrawDt; }
    public void setWithdrawDt(Date withdrawDt) { this.withdrawDt = withdrawDt; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }
    public String getDelYn() { return delYn; }
    public void setDelYn(String delYn) { this.delYn = delYn; }

    public String getMemberGradeCd() { return memberGradeCd; }
    public void setMemberGradeCd(String memberGradeCd) { this.memberGradeCd = memberGradeCd; }
    public String getManagingChannelCd() { return managingChannelCd; }
    public void setManagingChannelCd(String managingChannelCd) { this.managingChannelCd = managingChannelCd; }
    public BigDecimal getMeatmoneyBalanceAmt() { return meatmoneyBalanceAmt; }
    public void setMeatmoneyBalanceAmt(BigDecimal meatmoneyBalanceAmt) { this.meatmoneyBalanceAmt = meatmoneyBalanceAmt; }
    public BigDecimal getCreditBalanceAmt() { return creditBalanceAmt; }
    public void setCreditBalanceAmt(BigDecimal creditBalanceAmt) { this.creditBalanceAmt = creditBalanceAmt; }
    public BigDecimal getTotalAvailableAmt() { return totalAvailableAmt; }
    public void setTotalAvailableAmt(BigDecimal totalAvailableAmt) { this.totalAvailableAmt = totalAvailableAmt; }
    public BigDecimal getMonthOrderAmt() { return monthOrderAmt; }
    public void setMonthOrderAmt(BigDecimal monthOrderAmt) { this.monthOrderAmt = monthOrderAmt; }
    public BigDecimal getYearOrderAmt() { return yearOrderAmt; }
    public void setYearOrderAmt(BigDecimal yearOrderAmt) { this.yearOrderAmt = yearOrderAmt; }
    public BigDecimal getTotalOrderAmt() { return totalOrderAmt; }
    public void setTotalOrderAmt(BigDecimal totalOrderAmt) { this.totalOrderAmt = totalOrderAmt; }

    public String getSellerTypeCd() { return sellerTypeCd; }
    public void setSellerTypeCd(String sellerTypeCd) { this.sellerTypeCd = sellerTypeCd; }
    public String getTaxTypeCd() { return taxTypeCd; }
    public void setTaxTypeCd(String taxTypeCd) { this.taxTypeCd = taxTypeCd; }

    public String getBankCd() { return bankCd; }
    public void setBankCd(String bankCd) { this.bankCd = bankCd; }
    public String getAccountNo() { return accountNo; }
    public void setAccountNo(String accountNo) { this.accountNo = accountNo; }
    public String getAccountName() { return accountName; }
    public void setAccountName(String accountName) { this.accountName = accountName; }

    public String getAdminRoleCd() { return adminRoleCd; }
    public void setAdminRoleCd(String adminRoleCd) { this.adminRoleCd = adminRoleCd; }

    public List<MemberContactVO> getContacts() { return contacts; }
    public void setContacts(List<MemberContactVO> contacts) { this.contacts = contacts; }

    public String getMemberTypeName() { return memberTypeName; }
    public void setMemberTypeName(String memberTypeName) { this.memberTypeName = memberTypeName; }
    public String getMemberGradeName() { return memberGradeName; }
    public void setMemberGradeName(String memberGradeName) { this.memberGradeName = memberGradeName; }
    public String getJoinStatusName() { return joinStatusName; }
    public void setJoinStatusName(String joinStatusName) { this.joinStatusName = joinStatusName; }
    public String getChannelName() { return channelName; }
    public void setChannelName(String channelName) { this.channelName = channelName; }
    public String getSellerTypeName() { return sellerTypeName; }
    public void setSellerTypeName(String sellerTypeName) { this.sellerTypeName = sellerTypeName; }
}
