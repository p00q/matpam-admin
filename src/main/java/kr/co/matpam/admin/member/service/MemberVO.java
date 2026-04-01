package kr.co.matpam.admin.member.service;

import java.io.Serializable;
import java.util.List;

import kr.co.matpam.admin.member.service.manager.MemberManagerVO;

public class MemberVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 회원 PK (tb_member.member_id)
     */
    private Long memberPk;
    private Long memberNo;
    private String memberType;
    private String memberTypeName; // 코드명 표시용
    private String region;
    private String memberId;
    private String loginId;
    private String loginPw;
    private String companyName;
    private String businessNumber;
    private String ceoName;
    private String contactNumber;
    private String agreeYn;
    private String useYn;
    private String email;
    private String companyPhone;
    private String postcode;
    private String address;
    private String addressDetail;
    private String managerName;
    private String managerContact;
    private String managerMobile;
    private String managerPhone;
    private String managerEmail;
    private Long creditLimit;
    private Long meatMoney;
    private String memberGrade;
    private String memberGradeName; // 코드명 표시용
    private String status;
    private String statusName; // 코드명 표시용
    private String agreeMarketing;
    private String agreeSms;
    private String joinDate;
    private String deliveryTypeCd;   // 배송/운영유형코드
    private String deliveryTypeName; // 배송/운영유형명
 
    private List<MemberManagerVO> memberManagers;

    public Long getMemberPk() {
        return memberPk;
    }

    public void setMemberPk(Long memberPk) {
        this.memberPk = memberPk;
    }

    public Long getMemberNo() {
        return memberNo;
    }

    public void setMemberNo(Long memberNo) {
        this.memberNo = memberNo;
    }

    public String getMemberType() {
        return memberType;
    }

    public void setMemberType(String memberType) {
        this.memberType = memberType;
    }

    public String getMemberTypeName() {
        return memberTypeName;
    }

    public void setMemberTypeName(String memberTypeName) {
        this.memberTypeName = memberTypeName;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public String getMemberId() {
        return memberId;
    }

    public void setMemberId(String memberId) {
        this.memberId = memberId;
    }

    public String getLoginId() {
        return loginId;
    }

    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }

    public String getLoginPw() {
        return loginPw;
    }

    public void setLoginPw(String loginPw) {
        this.loginPw = loginPw;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getBusinessNumber() {
        return businessNumber;
    }

    public void setBusinessNumber(String businessNumber) {
        this.businessNumber = businessNumber;
    }

    public String getCeoName() {
        return ceoName;
    }

    public void setCeoName(String ceoName) {
        this.ceoName = ceoName;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public String getAgreeYn() {
        return agreeYn;
    }

    public void setAgreeYn(String agreeYn) {
        this.agreeYn = agreeYn;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public String getManagerName() {
        return managerName;
    }

    public void setManagerName(String managerName) {
        this.managerName = managerName;
    }

    public String getManagerContact() {
        return managerContact;
    }

    public void setManagerContact(String managerContact) {
        this.managerContact = managerContact;
    }

    public Long getCreditLimit() {
        return creditLimit;
    }

    public void setCreditLimit(Long creditLimit) {
        this.creditLimit = creditLimit;
    }

    public Long getMeatMoney() {
        return meatMoney;
    }

    public void setMeatMoney(Long meatMoney) {
        this.meatMoney = meatMoney;
    }

    public String getMemberGrade() {
        return memberGrade;
    }

    public void setMemberGrade(String memberGrade) {
        this.memberGrade = memberGrade;
    }

    public String getMemberGradeName() {
        return memberGradeName;
    }

    public void setMemberGradeName(String memberGradeName) {
        this.memberGradeName = memberGradeName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatusName() {
        return statusName;
    }

    public void setStatusName(String statusName) {
        this.statusName = statusName;
    }

    public String getJoinDate() {
        return joinDate;
    }

    public void setJoinDate(String joinDate) {
        this.joinDate = joinDate;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCompanyPhone() {
        return companyPhone;
    }

    public void setCompanyPhone(String companyPhone) {
        this.companyPhone = companyPhone;
    }

    public String getPostcode() {
        return postcode;
    }

    public void setPostcode(String postcode) {
        this.postcode = postcode;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAddressDetail() {
        return addressDetail;
    }

    public void setAddressDetail(String addressDetail) {
        this.addressDetail = addressDetail;
    }

    public String getManagerMobile() {
        return managerMobile;
    }

    public void setManagerMobile(String managerMobile) {
        this.managerMobile = managerMobile;
    }

    public String getManagerPhone() {
        return managerPhone;
    }

    public void setManagerPhone(String managerPhone) {
        this.managerPhone = managerPhone;
    }

    public String getManagerEmail() {
        return managerEmail;
    }

    public void setManagerEmail(String managerEmail) {
        this.managerEmail = managerEmail;
    }

    public String getAgreeMarketing() {
        return agreeMarketing;
    }

    public void setAgreeMarketing(String agreeMarketing) {
        this.agreeMarketing = agreeMarketing;
    }

    public String getAgreeSms() {
        return agreeSms;
    }

    public void setAgreeSms(String agreeSms) {
        this.agreeSms = agreeSms;
    }

    public List<MemberManagerVO> getMemberManagers() {
        return memberManagers;
    }

    public void setMemberManagers(List<MemberManagerVO> memberManagers) {
        this.memberManagers = memberManagers;
    }

    public String getDeliveryTypeCd() {
        return deliveryTypeCd;
    }

    public void setDeliveryTypeCd(String deliveryTypeCd) {
        this.deliveryTypeCd = deliveryTypeCd;
    }

    public String getDeliveryTypeName() {
        return deliveryTypeName;
    }

    public void setDeliveryTypeName(String deliveryTypeName) {
        this.deliveryTypeName = deliveryTypeName;
    }
}
