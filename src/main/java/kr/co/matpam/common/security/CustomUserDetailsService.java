package kr.co.matpam.common.security;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import kr.co.matpam.admin.user.service.UserService;
import kr.co.matpam.admin.user.service.UserVO;

/**
 * Spring Security 인증용 서비스
 */
@Service("customUserDetailsService")
public class CustomUserDetailsService implements UserDetailsService {

    @Resource(name = "userService")
    private UserService userService;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        try {
            UserVO userVO = userService.selectUserByLoginId(username);
            
            if (userVO == null) {
                throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + username);
            }

            if (!"ACTIVE".equals(userVO.getStatus())) {
                throw new UsernameNotFoundException("비활성화된 계정입니다: " + username);
            }

            List<GrantedAuthority> authorities = new ArrayList<>();
            // 기본 권한 부여 (DB 권한 명칭에 ROLE_ 접두어 추가)
            String role = userVO.getUserRole();
            if (role != null) {
                authorities.add(new SimpleGrantedAuthority("ROLE_" + role));
            }

            // MatpamUser 객체 반환 (추가 정보 포함)
            return new MatpamUser(userVO, authorities);
            
        } catch (Exception e) {
            throw new UsernameNotFoundException("인증 처리 중 오류 발생", e);
        }
    }
}
