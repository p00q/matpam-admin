package kr.co.matpam.common.util;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import kr.co.matpam.common.security.MatpamUser;

/**
 * 현재 로그인한 사용자의 컨텍스트 정보를 제공하는 유틸리티
 */
public class MatpamContextHolder {

    /**
     * 현재 인증된 사용자 정보를 가져옵니다.
     */
    public static MatpamUser getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof MatpamUser) {
            return (MatpamUser) auth.getPrincipal();
        }
        return null;
    }

    /**
     * 현재 테넌트 ID를 가져옵니다.
     */
    public static Long getCurrentTenantId() {
        MatpamUser user = getCurrentUser();
        return (user != null) ? user.getTenantId() : null;
    }

    /**
     * 현재 사용자 PK를 가져옵니다.
     */
    public static Long getCurrentUserId() {
        MatpamUser user = getCurrentUser();
        return (user != null) ? user.getUserId() : null;
    }
}
