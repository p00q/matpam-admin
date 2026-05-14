package kr.co.matpam.admin.common.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * 어드민 로그인 컨트롤러 (개발용 자동 세션 생성)
 *
 * 사용법:
 *   /admin/login.do              → 기본값 (TestUser01, CHANNEL_ADMIN)
 *   /admin/login.do?role=SUPER   → 슈퍼관리자 (admin, user_id=1)
 *   /admin/login.do?role=OP      → 몰 운영자  (operator01, user_id=2)
 *   /admin/login.do?role=CH      → 채널관리자 (tester01, user_id=3)
 */
@Controller
public class AdminLoginController {

    @RequestMapping("/admin/login.do")
    public String loginForm(
            javax.servlet.http.HttpSession session,
            @RequestParam(value = "role", required = false, defaultValue = "CH") String role) {

        kr.co.matpam.admin.common.service.LoginVO loginVO =
                new kr.co.matpam.admin.common.service.LoginVO();

        switch (role.toUpperCase()) {
            case "SUPER":
                // 슈퍼관리자: 몰 기본정보 등록 + 운영자 등록 권한
                loginVO.setMemberPk(1L);
                loginVO.setLoginId("admin");
                loginVO.setMemberName("슈퍼관리자");
                loginVO.setMemberType("SUPER_ADMIN");
                loginVO.setRoleCd("SUPER_ADMIN");
                loginVO.setOpType("SUPER_ADMIN");
                loginVO.setCompanyId(1L);
                loginVO.setChannelCd("1");
                break;

            case "OP":
                // 몰 운영자: 채널 등록 + 채널 운영자 등록 권한 / 운영관리 메뉴 접근 가능
                loginVO.setMemberPk(2L);
                loginVO.setLoginId("operator01");
                loginVO.setMemberName("몰운영자");
                loginVO.setMemberType("OPERATOR");
                loginVO.setRoleCd("OPERATOR");
                loginVO.setOpType("OPERATOR");
                loginVO.setCompanyId(1L);
                loginVO.setChannelCd("1");
                break;

            case "CH3":
                loginVO.setMemberPk(3L);
                loginVO.setLoginId("tester01");
                loginVO.setMemberName("전국택배관리자");
                loginVO.setMemberType("CHANNEL_ADMIN");
                loginVO.setRoleCd("CHANNEL_ADMIN");
                loginVO.setOpType("CHANNEL_ADMIN");
                loginVO.setCompanyId(2L);
                loginVO.setChannelCd("3"); // 전국택배 (COURIER)
                break;
                
            case "CH4":
                loginVO.setMemberPk(2L);
                loginVO.setLoginId("optest99");
                loginVO.setMemberName("화물직송관리자");
                loginVO.setMemberType("CHANNEL_ADMIN");
                loginVO.setRoleCd("CHANNEL_ADMIN");
                loginVO.setOpType("CHANNEL_ADMIN");
                loginVO.setCompanyId(2L);
                loginVO.setChannelCd("4"); // 화물직송 (DIRECT)
                break;
                
            case "CH5":
                loginVO.setMemberPk(8L);
                loginVO.setLoginId("sync_test_002");
                loginVO.setMemberName("공장수령관리자");
                loginVO.setMemberType("CHANNEL_ADMIN");
                loginVO.setRoleCd("CHANNEL_ADMIN");
                loginVO.setOpType("CHANNEL_ADMIN");
                loginVO.setCompanyId(2L);
                loginVO.setChannelCd("5"); // 공장수령 (COLLECT)
                break;
                
            default:
                // 기본값
                loginVO.setMemberPk(3L);
                loginVO.setLoginId("tester01");
                loginVO.setMemberName("전국택배관리자");
                loginVO.setMemberType("CHANNEL_ADMIN");
                loginVO.setRoleCd("CHANNEL_ADMIN");
                loginVO.setOpType("CHANNEL_ADMIN");
                loginVO.setCompanyId(2L);
                loginVO.setChannelCd("3");
                break;
        }

        session.setAttribute("loginVO", loginVO);
        return "redirect:/admin/dashboard/main.do";
    }
}
