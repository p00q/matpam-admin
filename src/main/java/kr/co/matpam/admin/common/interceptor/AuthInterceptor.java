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
        kr.co.matpam.admin.common.service.LoginVO loginVO = (kr.co.matpam.admin.common.service.LoginVO) session.getAttribute("loginVO");

        if (loginVO == null) {
            // Spring Security가 인증을 처리하므로, 여기서는 단순히 false를 반환하거나 
            // 필요한 경우 로그인 페이지로 리다이렉트합니다.
            // 하지만 Security Filter가 먼저 동작하므로 보통은 여기까지 오지 않습니다.
            return true; 
        }

        // 운영권한 및 로그인ID를 Request Attribute에 설정 (Controller/Mapper용)
        request.setAttribute("opType", loginVO.getOpType());
        request.setAttribute("loginId", loginVO.getLoginId());
        request.setAttribute("adminMemberId", loginVO.getMemberPk());
        request.setAttribute("companyId", loginVO.getCompanyId());
        request.setAttribute("channelCd", loginVO.getChannelCd());
        request.setAttribute("adminRoleCd", loginVO.getRoleCd());

        // 2. URI 분석을 통한 현재 메뉴 및 타이틀 설정
        String uri = request.getRequestURI();
        String currentMenu = "dashboard";
        String pageTitle = "대시보드";

        if (uri.contains("/member/")) {
            currentMenu = "member";
            pageTitle = "회원 관리";
        } else if (uri.contains("/order/")) {
            currentMenu = "order";
            pageTitle = "주문 관리";
        } else if (uri.contains("/product/sales")) {
            currentMenu = "product";
            pageTitle = "판매상품 관리";
        } else if (uri.contains("/product/component")) {
            currentMenu = "component";
            pageTitle = "구성상품 관리";
        } else if (uri.contains("/settlement/")) {
            currentMenu = "settlement";
            pageTitle = "정산 관리";
        } else if (uri.contains("/basic/") || uri.contains("/code/")) {
            currentMenu = "basic";
            pageTitle = "시스템 설정";
        } else if (uri.contains("/dashboard/")) {
            currentMenu = "dashboard";
            pageTitle = "대시보드";
        }

        request.setAttribute("currentMenu", currentMenu);
        request.setAttribute("pageTitle", pageTitle);
        
        System.out.println("[DEBUG] URI: " + uri + " | Menu: " + currentMenu + " | Title: " + pageTitle);

        return true;
    }
}
