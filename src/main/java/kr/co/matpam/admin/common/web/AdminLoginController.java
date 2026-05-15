package kr.co.matpam.admin.common.web;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.matpam.admin.common.service.LoginVO;

@Controller
public class AdminLoginController {

    @RequestMapping("/admin/login.do")
    public String loginForm(
            HttpSession session,
            @RequestParam(value = "role", required = false, defaultValue = "CH") String role) {

        LoginVO loginVO = new LoginVO();

        switch (role.toUpperCase()) {
            case "SUPER":
                setLogin(loginVO, 1L, "admin", "super admin", "SUPER_ADMIN", 1L, 1L, null);
                break;

            case "OP":
                setLogin(loginVO, 2L, "operator01", "mall operator", "OPERATOR", 1L, 1L, null);
                break;

            case "CH4":
                setLogin(loginVO, 4L, "optest99", "direct channel manager", "CHANNEL_ADMIN", 1L, 1L, 4L);
                break;

            case "CH5":
                setLogin(loginVO, 8L, "sync_test_002", "collect channel manager", "CHANNEL_ADMIN", 1L, 1L, 5L);
                break;

            case "CH3":
            case "CH":
            default:
                setLogin(loginVO, 19L, "new_op_arch_01", "courier channel manager", "CHANNEL_ADMIN", 1L, 1L, 3L);
                break;
        }

        session.setAttribute("loginVO", loginVO);
        return "redirect:/admin/dashboard/main.do";
    }

    private void setLogin(LoginVO loginVO,
                          Long memberPk,
                          String loginId,
                          String memberName,
                          String role,
                          Long tenantId,
                          Long companyId,
                          Long channelId) {
        loginVO.setMemberPk(memberPk);
        loginVO.setLoginId(loginId);
        loginVO.setMemberName(memberName);
        loginVO.setMemberType(role);
        loginVO.setRoleCd(role);
        loginVO.setOpType(role);
        loginVO.setTenantId(tenantId);
        loginVO.setCompanyId(companyId);
        loginVO.setChannelId(channelId);
    }
}
