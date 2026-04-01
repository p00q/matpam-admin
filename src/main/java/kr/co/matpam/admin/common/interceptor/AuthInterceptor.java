package kr.co.matpam.admin.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;
import kr.co.matpam.admin.common.service.LoginVO;

/**
 * 인증 및 권한(opType) 관리를 위한 인터셉터
 */
public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");

        // 1. 로그인 여부 체크 (필요시 활성화)
        /*
        if (loginVO == null) {
            response.sendRedirect(request.getContextPath() + "/admin/loginForm.do");
            return false;
        }
        */

        // 2. 운영 타입(opType)을 Request Attribute에 설정
        // 모든 JSP 및 컨트롤러에서 ${opType} 으로 접근 가능하도록 함
        if (loginVO != null) {
            request.setAttribute("opType", loginVO.getOpType());
            request.setAttribute("loginVO", loginVO);
        } else {
            // 미로그인 시 임시(개발용) 또는 차단
            // request.setAttribute("opType", "NONE");
        }

        return true;
    }
}
