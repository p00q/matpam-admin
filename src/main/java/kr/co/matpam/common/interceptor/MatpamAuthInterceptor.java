package kr.co.matpam.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import kr.co.matpam.admin.common.service.LoginVO;

/**
 * 맛팜 인증 및 운영 권한 인터셉터
 */
public class MatpamAuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(@NonNull HttpServletRequest request, @NonNull HttpServletResponse response, @NonNull Object handler) throws Exception {
        
        HttpSession session = request.getSession();
        LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");

        // 1. 로그인 체크 (실운영시 주석 해제)
        /*
        if (loginVO == null) {
            response.sendRedirect(request.getContextPath() + "/login.do");
            return false;
        }
        */

        // 2. 운영 타입(opType) 설정
        // 임시 로직: 세션에 없으면 기본 NATIONAL로 설정 (개발 편의성)
        String opType = "NATIONAL"; 
        if (loginVO != null && loginVO.getChannelCd() != null) {
            String deliveryType = loginVO.getChannelCd();
            if ("FREIGHT".equals(deliveryType)) {
                opType = "LOCAL";
            } else if ("PICKUP".equals(deliveryType)) {
                opType = "FACTORY";
            }
        }
        
        // Request Attribute에 보관 (Controller에서 사용 가능)
        request.setAttribute("opType", opType);
        if (loginVO != null) {
            request.setAttribute("loginId", loginVO.getLoginId());
            request.setAttribute("tenantId", loginVO.getCompanyId()); // 임시로 companyId를 tenantId처럼 사용하거나 필드 추가 필요
        }

        return true;
    }

    @Override
    public void postHandle(@NonNull HttpServletRequest request, @NonNull HttpServletResponse response, @NonNull Object handler, @Nullable ModelAndView modelAndView) throws Exception {
        // 필요 시 공통 모델 데이터 추가
    }

    @Override
    public void afterCompletion(@NonNull HttpServletRequest request, @NonNull HttpServletResponse response, @NonNull Object handler, @Nullable Exception ex) throws Exception {
    }
}
