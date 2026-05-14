package kr.co.matpam.admin.common.service;

import java.io.Serializable;

/**
 * 로그인 세션 정보를 담는 VO
 */
public class LoginVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long memberPk;
    private String loginId;
    private String memberName;
    private String memberType; // SUPER_ADMIN, COMPANY_ADMIN, BUYER, RAW_SELLER, PROCESS_SELLER
    
    // 추가 계층 구조 권한 필드
    private Long tenantId;
    private Long companyId;
    private Long channelId;
    private String channelCd;
    private String roleCd;
    
    public LoginVO() {}
    
    public LoginVO(Long memberPk, String loginId, String memberName, String memberType) {
        this.memberPk = memberPk;
        this.loginId = loginId;
        this.memberName = memberName;
        this.memberType = memberType;
    }

    public Long getMemberPk() { return memberPk; }
    public void setMemberPk(Long memberPk) { this.memberPk = memberPk; }
    public String getLoginId() { return loginId; }
    public void setLoginId(String loginId) { this.loginId = loginId; }
    public String getMemberName() { return memberName; }
    public void setMemberName(String memberName) { this.memberName = memberName; }
    public String getMemberType() { return memberType; }
    public void setMemberType(String memberType) { this.memberType = memberType; }
    
    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }

    public Long getCompanyId() { return companyId; }
    public void setCompanyId(Long companyId) { this.companyId = companyId; }

    public Long getChannelId() {
        if (channelId != null) {
            return channelId;
        }
        if (channelCd == null || channelCd.isEmpty()) {
            return null;
        }
        try {
            return Long.valueOf(channelCd);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    public void setChannelId(Long channelId) {
        this.channelId = channelId;
        this.channelCd = channelId != null ? String.valueOf(channelId) : null;
    }
    
    public String getChannelCd() { return channelCd; }
    public void setChannelCd(String channelCd) {
        this.channelCd = channelCd;
        if (channelCd == null || channelCd.isEmpty()) {
            this.channelId = null;
            return;
        }
        try {
            this.channelId = Long.valueOf(channelCd);
        } catch (NumberFormatException e) {
            this.channelId = null;
        }
    }
    
    public String getRoleCd() { return roleCd; }
    public void setRoleCd(String roleCd) { this.roleCd = roleCd; }

    /**
     * opType 별칭 (디자인 문서 호환성)
     */
    public String getOpType() {
        return this.memberType;
    }
    public void setOpType(String opType) {
        this.memberType = opType;
    }

    /**
     * userNm 별칭 (디자인 문서 호환성)
     */
    public String getUserNm() {
        return this.memberName;
    }
    public void setUserNm(String userNm) {
        this.memberName = userNm;
    }
}
