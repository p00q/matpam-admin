package kr.co.matpam.admin.common.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * 어드민 로그인 컨트롤러
 */
@Controller
public class AdminLoginController {

    /**
     * 로그인 페이지
     */
    @RequestMapping("/admin/login.do")
    public String loginForm(javax.servlet.http.HttpSession session) {
        // 개발 편의를 위해 로그인 페이지 접근 시 자동 세션 생성 및 대시보드 이동
        kr.co.matpam.admin.common.service.LoginVO loginVO = new kr.co.matpam.admin.common.service.LoginVO();
        loginVO.setMemberPk(1L);
        loginVO.setLoginId("admin");
        loginVO.setMemberName("관리자");
        loginVO.setMemberType("SUPER_ADMIN");
        loginVO.setOpType("SUPER_ADMIN");
        loginVO.setRoleCd("SUPER_ADMIN");
        loginVO.setCompanyId(1L);
        loginVO.setChannelCd("3"); // DB에 존재하는 유효한 채널 ID (공장수령 등)
        session.setAttribute("loginVO", loginVO);

        return "redirect:/admin/dashboard/main.do";
    }
}
