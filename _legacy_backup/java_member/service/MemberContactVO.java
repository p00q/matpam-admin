package kr.co.matpam.admin.member.service;

import java.io.Serializable;
import java.util.Date;

/**
 * 회원 담당자 정보 VO (tb_member_contact)
 */
public class MemberContactVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long contactId;
    private Long memberId;
    private String name;
    private String mobileNo;
    private String phoneNo;
    private String email;
    private String contactTypeCd; // MAIN, SUB 등
    private String useYn;
    private Date regDt;
    private Date modDt;

    public Long getContactId() { return contactId; }
    public void setContactId(Long contactId) { this.contactId = contactId; }
    public Long getMemberId() { return memberId; }
    public void setMemberId(Long memberId) { this.memberId = memberId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getMobileNo() { return mobileNo; }
    public void setMobileNo(String mobileNo) { this.mobileNo = mobileNo; }
    public String getPhoneNo() { return phoneNo; }
    public void setPhoneNo(String phoneNo) { this.phoneNo = phoneNo; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getContactTypeCd() { return contactTypeCd; }
    public void setContactTypeCd(String contactTypeCd) { this.contactTypeCd = contactTypeCd; }
    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }
    public Date getRegDt() { return regDt; }
    public void setRegDt(Date regDt) { this.regDt = regDt; }
    public Date getModDt() { return modDt; }
    public void setModDt(Date modDt) { this.modDt = modDt; }
}
