package kr.co.matpam.admin.common.interceptor;

import java.util.Collections;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.servlet.HandlerInterceptor;

import kr.co.matpam.admin.common.service.LoginVO;
import kr.co.matpam.admin.user.service.UserVO;
import kr.co.matpam.common.security.MatpamUser;

/**
 * 인증 및 역할(roleCd) 기반 메뉴 접근 제어 인터셉터
 */
public class AuthInterceptor implements HandlerInterceptor {

    private static final String[] CHANNEL_ADMIN_BLOCKED = {
        "/admin/sysChannel/",
        "/admin/user/operatorList",
        "/admin/user/operatorForm"
    };

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        // 1. 세션 체크 및 제외 URL 처리
        String uri = request.getRequestURI();
        if (uri.contains("/admin/login.do") || uri.contains("/admin/actionLogin.do") || uri.contains("/admin/logout.do")) {
            return true;
        }

        HttpSession session = request.getSession();
        LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");

        if (loginVO == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.do?reason=SESSION_EXPIRED");
            return false;
        }

        // 2. 테넌트 정보(channelCd) 필수 체크
        String channelCd = loginVO.getChannelCd();
        if (channelCd == null || channelCd.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/login.do?reason=INVALID_TENANT");
            return false;
        }

        String roleCd = loginVO.getRoleCd() != null ? loginVO.getRoleCd() : "SUPER_ADMIN";

        // 3. Request Attributes 설정
        request.setAttribute("loginId",       loginVO.getLoginId());
        request.setAttribute("adminMemberId", loginVO.getMemberPk());
        request.setAttribute("companyId",     loginVO.getCompanyId());
        request.setAttribute("channelCd",     channelCd);
        request.setAttribute("adminRoleCd",   roleCd);

        // 4. SecurityContextHolder 동기화 (TenantAspect용)
        if (SecurityContextHolder.getContext().getAuthentication() == null) {
            UserVO uvo = new UserVO();
            uvo.setUserId(loginVO.getMemberPk());
            uvo.setLoginId(loginVO.getLoginId());
            uvo.setUserName(loginVO.getMemberName());
            
            // 테넌트 ID 파싱
            Long tId = Long.parseLong(channelCd);
            uvo.setTenantId(tId);
            uvo.setCompanyId(loginVO.getCompanyId());

            List<SimpleGrantedAuthority> authorities = 
                Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + roleCd));
            
            MatpamUser mUser = new MatpamUser(uvo, authorities);
            Authentication auth = new UsernamePasswordAuthenticationToken(mUser, null, authorities);
            SecurityContextHolder.getContext().setAuthentication(auth);
        }

        // 5. 역할별 접근 제어
        if ("CHANNEL_ADMIN".equals(roleCd)) {
            for (String blocked : CHANNEL_ADMIN_BLOCKED) {
                if (uri.contains(blocked)) {
                    if (isAjax(request)) {
                        response.setContentType("application/json;charset=UTF-8");
                        response.getWriter().write("{\"status\":\"FORBIDDEN\",\"message\":\"접근 권한이 없습니다.\"}");
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        return false;
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/dashboard/main.do?accessDenied=Y");
                        return false;
                    }
                }
            }
        }

        // 5. 메뉴 및 타이틀 설정
        String currentMenu = detectMenu(uri, request);
        if (request.getAttribute("currentMenu") == null) {
            request.setAttribute("currentMenu", currentMenu);
        }

        return true;
    }

    private String detectMenu(String uri, HttpServletRequest request) {
        if (uri.contains("/sysChannel/")) return "op_channel";
        if (uri.contains("/user/operator")) return "op_operator";
        if (uri.contains("/company/")) {
            if ("1".equals(request.getParameter("companyId"))) return "op_mall";
            String type = request.getParameter("companyType");
            if ("SELLER".equals(type)) return "comp_seller";
            if ("BUYER".equals(type)) return "comp_buyer";
            return "comp_company";
        }
        if (uri.contains("/order/")) return "order";
        if (uri.contains("/product/")) return "product";
        return "dashboard";
    }

    private boolean isAjax(HttpServletRequest request) {
        String xReq = request.getHeader("X-Requested-With");
        return "XMLHttpRequest".equals(xReq) || request.getRequestURI().contains(".ajax");
    }
}
