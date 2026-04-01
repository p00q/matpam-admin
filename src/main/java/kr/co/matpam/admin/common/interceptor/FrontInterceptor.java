package kr.co.matpam.admin.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

import kr.co.matpam.admin.common.service.LoginVO;

/**
 * 소비자 쇼핑몰(Front) 전용 인터셉터
 * - 세션의 loginVO를 확인하여 미로그인 시 /front/login.do 로 리다이렉트
 * - 로그인 회원 정보를 request attribute에 주입
 */
public class FrontInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");

        if (loginVO == null) {
            // 미로그인 사용자 → 로그인 페이지 리다이렉트
            response.sendRedirect(request.getContextPath() + "/front/login.do");
            return false;
        }

        // 로그인 회원 정보를 JSP request attribute에 주입
        request.setAttribute("frontLoginVO", loginVO);
        request.setAttribute("memberName", loginVO.getMemberName());
        request.setAttribute("memberPk", loginVO.getMemberPk());

        return true;
    }
}
