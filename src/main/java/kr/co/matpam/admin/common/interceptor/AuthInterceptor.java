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
            // [임시 조치] 로그인 없이 바로 관리자 권한 부여
            loginVO = new kr.co.matpam.admin.common.service.LoginVO();
            loginVO.setLoginId("admin");
            loginVO.setMemberName("관리자(자동)");
            loginVO.setRoleCd("SUPER");
            loginVO.setOpType("ADMIN");
            loginVO.setMemberPk(1L);
            loginVO.setCompanyId(1L);
            session.setAttribute("loginVO", loginVO);
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
            currentMenu = "op_admin";
            pageTitle = "관리자/권한관리";
        } else if (uri.contains("/company/")) {
            String type = request.getParameter("companyType");
            if ("SELLER".equals(type)) {
                currentMenu = "comp_seller";
                pageTitle = "판매업체 관리";
            } else if ("BUYER".equals(type)) {
                currentMenu = "comp_buyer";
                pageTitle = "구매업체 관리";
            } else {
                currentMenu = "comp_company";
                pageTitle = "업체 관리";
            }
        } else if (uri.contains("/order/")) {
            currentMenu = "order";
            pageTitle = "주문 관리";
        } else if (uri.contains("/product/")) {
            currentMenu = "product";
            pageTitle = "상품 관리";
        } else if (uri.contains("/settlement/")) {
            currentMenu = "settle";
            pageTitle = "정산 관리";
        } else if (uri.contains("/transport/")) {
            currentMenu = "transport";
            pageTitle = "배송/운송 관리";
        } else if (uri.contains("/code/")) {
            currentMenu = "op_code";
            pageTitle = "공통코드 관리";
        }

        request.setAttribute("currentMenu", currentMenu);
        request.setAttribute("pageTitle", pageTitle);
        
        System.out.println("[DEBUG] URI: " + uri + " | Menu: " + currentMenu + " | Title: " + pageTitle);

        return true;
    }
}
