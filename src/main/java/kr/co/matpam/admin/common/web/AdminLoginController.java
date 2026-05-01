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
    public String loginForm(
            @RequestParam(value = "error", required = false) String error,
            @RequestParam(value = "denied", required = false) String denied,
            ModelMap model) {
        
        if (error != null) {
            model.addAttribute("message", "아이디 또는 비밀번호가 올바르지 않습니다.");
        }
        if (denied != null) {
            model.addAttribute("message", "접근 권한이 없습니다.");
        }
        
        return "admin/login/Login";
    }
}
