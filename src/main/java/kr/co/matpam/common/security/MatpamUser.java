package kr.co.matpam.common.security;

import java.util.Collection;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;
import kr.co.matpam.admin.user.service.UserVO;
import lombok.Getter;

/**
 * Spring Security 인증 사용자 확장 객체
 */
@Getter
public class MatpamUser extends User {

    private final Long userId;
    private final Long tenantId;
    private final Long companyId;
    private final String userName;

    public MatpamUser(UserVO userVO, Collection<? extends GrantedAuthority> authorities) {
        super(userVO.getLoginId(), userVO.getPasswordHash(), authorities);
        this.userId = userVO.getUserId();
        this.tenantId = userVO.getTenantId();
        this.companyId = userVO.getCompanyId();
        this.userName = userVO.getUserName();
    }
}
