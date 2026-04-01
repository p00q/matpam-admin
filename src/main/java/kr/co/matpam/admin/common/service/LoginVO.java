package kr.co.matpam.admin.common.service;

import java.io.Serializable;
import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

/**
 * 로그인 세션 정보를 담는 VO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LoginVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long memberPk;
    private String loginId;
    private String memberName;
    private String memberType; // NATIONAL, LOCAL, FACTORY (디자인 문서 상의 opType)
    
    /**
     * opType 별칭 반환 (디자인 문서 호환성)
     */
    public String getOpType() {
        return this.memberType;
    }
}
