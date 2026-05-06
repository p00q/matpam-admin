package kr.co.matpam.admin.user.service;

import kr.co.matpam.common.service.MatpamBaseVO;
import java.util.Date;

/**
 * 사용자 (tb_user) VO
 * USER_REG.md 기준 동적 폼 지원 필드 포함
 */
public class UserVO extends MatpamBaseVO {

    /* ── tb_user 컬럼 ── */
    private Long userId;
    private Long tenantId;
    private Long companyId;
    private String loginId;
    private String passwordHash;
    private String userName;
    private String mobile;
    private String email;
    private String userRole;
    private Long channelId;
    private String status;
    private Date lastLoginAt;
    private Date createdAt;
    private Date updatedAt;

    /* ── 화면/저장 보조 필드 ── */
    /** 비밀번호 확인용 (화면 전용, DB 미저장) */
    private String passwordConfirm;

    /** 담당자 동시 생성 여부 Y/N */
    private String createContactYn;

    /** 담당자 역할 (ADMIN/SALES/TAX/SETTLEMENT/SHIPPING/PURCHASE) */
    private String contactRole;

    /** 대표 담당자 여부 Y/N */
    private String isPrimaryContact;

    /* ── 조회 조인용 ── */
    private String companyName;
    private String tenantName;
    private String channelName;
    private String channelCode;

    // ── Getter / Setter ──────────────────────────────────────────────

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }

    public Long getCompanyId() { return companyId; }
    public void setCompanyId(Long companyId) { this.companyId = companyId; }

    public String getLoginId() { return loginId; }
    public void setLoginId(String loginId) { this.loginId = loginId; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getUserRole() { return userRole; }
    public void setUserRole(String userRole) { this.userRole = userRole; }

    public Long getChannelId() { return channelId; }
    public void setChannelId(Long channelId) { this.channelId = channelId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getLastLoginAt() { return lastLoginAt; }
    public void setLastLoginAt(Date lastLoginAt) { this.lastLoginAt = lastLoginAt; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public String getPasswordConfirm() { return passwordConfirm; }
    public void setPasswordConfirm(String passwordConfirm) { this.passwordConfirm = passwordConfirm; }

    public String getCreateContactYn() { return createContactYn; }
    public void setCreateContactYn(String createContactYn) { this.createContactYn = createContactYn; }

    public String getContactRole() { return contactRole; }
    public void setContactRole(String contactRole) { this.contactRole = contactRole; }

    public String getIsPrimaryContact() { return isPrimaryContact; }
    public void setIsPrimaryContact(String isPrimaryContact) { this.isPrimaryContact = isPrimaryContact; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getTenantName() { return tenantName; }
    public void setTenantName(String tenantName) { this.tenantName = tenantName; }

    public String getChannelName() { return channelName; }
    public void setChannelName(String channelName) { this.channelName = channelName; }

    public String getChannelCode() { return channelCode; }
    public void setChannelCode(String channelCode) { this.channelCode = channelCode; }
}
