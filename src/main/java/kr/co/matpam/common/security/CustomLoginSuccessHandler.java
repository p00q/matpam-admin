package kr.co.matpam.common.security;

import java.io.IOException;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import kr.co.matpam.admin.common.service.LoginVO;
import kr.co.matpam.admin.user.service.UserService;
import kr.co.matpam.admin.user.service.UserVO;

/**
 * 로그인 성공 시 세션에 LoginVO를 바인딩하는 핸들러
 */
@Component("customLoginSuccessHandler")
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

    @Resource(name = "userService")
    private UserService userService;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
        
        String loginId = authentication.getName();
        
        try {
            UserVO userVO = userService.selectUserByLoginId(loginId);
            
            if (userVO != null) {
                LoginVO loginVO = new LoginVO();
                loginVO.setMemberPk(userVO.getUserId());
                loginVO.setLoginId(userVO.getLoginId());
                loginVO.setMemberName(userVO.getUserName());
                loginVO.setMemberType(userVO.getUserRole());
                loginVO.setCompanyId(userVO.getCompanyId());
                
                HttpSession session = request.getSession();
                session.setAttribute("loginVO", loginVO);
            }
            
            // 대시보드로 이동
            response.sendRedirect(request.getContextPath() + "/admin/dashboard/main.do");
            
        } catch (Exception e) {
            throw new ServletException("Login success processing failed", e);
        }
    }
}
