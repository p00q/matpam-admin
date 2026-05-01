package kr.co.matpam.admin.member.service.manager;

import java.io.Serializable;

public class MemberManagerVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long managerNo;
    private Long memberNo;
    private String managerName;
    private String mobileNumber;
    private String phoneNumber;
    private String email;
    private String mainYn;
    private String useYn;

    public Long getManagerNo() {
        return managerNo;
    }

    public void setManagerNo(Long managerNo) {
        this.managerNo = managerNo;
    }

    public Long getMemberNo() {
        return memberNo;
    }

    public void setMemberNo(Long memberNo) {
        this.memberNo = memberNo;
    }

    public String getManagerName() {
        return managerName;
    }

    public void setManagerName(String managerName) {
        this.managerName = managerName;
    }

    public String getMobileNumber() {
        return mobileNumber;
    }

    public void setMobileNumber(String mobileNumber) {
        this.mobileNumber = mobileNumber;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMainYn() {
        return mainYn;
    }

    public void setMainYn(String mainYn) {
        this.mainYn = mainYn;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }
}
