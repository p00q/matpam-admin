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
    private String memberType; // NATIONAL, LOCAL, FACTORY (디자인 문서 상의 opType)
    
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
