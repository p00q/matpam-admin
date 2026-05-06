package kr.co.matpam.admin.user.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.beans.propertyeditors.CustomNumberEditor;
import org.springframework.beans.propertyeditors.StringTrimmerEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.matpam.admin.company.service.CompanyService;
import kr.co.matpam.admin.company.service.CompanyVO;
import kr.co.matpam.admin.user.service.UserService;
import kr.co.matpam.admin.user.service.UserVO;

/**
 * 사용자 관리 컨트롤러
 * USER_REG.md 기준 동적 폼(역할별 소속 정보) + 담당자 동시 생성 지원
 */
@Controller
public class UserController {

    @Resource(name = "userService")
    private UserService userService;

    @Resource(name = "companyService")
    private CompanyService companyService;

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
        binder.registerCustomEditor(Long.class,   new CustomNumberEditor(Long.class,   true));
        binder.registerCustomEditor(Integer.class, new CustomNumberEditor(Integer.class, true));
    }

    // ─────────────────────────────────────────────────────────────────
    // 사용자 목록
    // ─────────────────────────────────────────────────────────────────

    @RequestMapping("/admin/user/userList.do")
    public String userList(@ModelAttribute("searchVO") UserVO searchVO,
                           ModelMap model) throws Exception {

        int currentPage      = searchVO.getPageIndex()    != null ? searchVO.getPageIndex()    : 1;
        int recordsPerPage   = searchVO.getPageUnit()     != null ? searchVO.getPageUnit()     : 10;

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(currentPage);
        paginationInfo.setRecordCountPerPage(recordsPerPage);
        paginationInfo.setPageSize(10);

        searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        int totalCount = userService.selectUserListTotCnt(searchVO);
        paginationInfo.setTotalRecordCount(totalCount);

        model.addAttribute("userList",       userService.selectUserList(searchVO));
        model.addAttribute("paginationInfo", paginationInfo);
        model.addAttribute("tenants",        userService.selectActiveTenantList());
        model.addAttribute("companies",      companyService.selectCompanyListAll(new CompanyVO()));
        model.addAttribute("contentPage",    "/WEB-INF/jsp/admin/user/UserList.jsp");

        return "layout/main";
    }

    // ─────────────────────────────────────────────────────────────────
    // 사용자 등록/수정 폼
    // ─────────────────────────────────────────────────────────────────

    @RequestMapping("/admin/user/userForm.do")
    public String userForm(@RequestParam(value = "userId", required = false) Long userId,
                           ModelMap model) throws Exception {

        UserVO user;
        if (userId == null) {
            user = new UserVO();
            user.setStatus("ACTIVE");
            user.setUserRole("SELLER_ADMIN");       // 기본 선택 역할
            user.setCreateContactYn("N");
            user.setIsPrimaryContact("N");
        } else {
            UserVO param = new UserVO();
            param.setUserId(userId);
            user = userService.selectUserDetail(param);
        }

        // 폼 공통 옵션: 테넌트 목록 (화면 로딩 시 초기 노출)
        model.addAttribute("user",         user);
        model.addAttribute("tenants",      userService.selectActiveTenantList());
        model.addAttribute("contentPage",  "/WEB-INF/jsp/admin/user/UserForm.jsp");

        return "layout/main";
    }

    // ─────────────────────────────────────────────────────────────────
    // 폼 옵션 AJAX (역할·테넌트 선택 시 채널/구매업체 동적 로드)
    // GET /admin/user/formOptions.ajax?userRole=CHANNEL_ADMIN&tenantId=1
    // ─────────────────────────────────────────────────────────────────

    @RequestMapping("/admin/user/formOptions.ajax")
    @ResponseBody
    public Map<String, Object> formOptions(
            @RequestParam(value = "userRole",  required = false) String userRole,
            @RequestParam(value = "tenantId",  required = false) Long   tenantId) {

        Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> options = userService.selectFormOptions(userRole, tenantId);
            result.put("success", true);
            result.putAll(options);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // ─────────────────────────────────────────────────────────────────
    // 사용자 저장 (AJAX)
    // ─────────────────────────────────────────────────────────────────

    @RequestMapping("/admin/user/saveUser.ajax")
    @ResponseBody
    public Map<String, Object> saveUser(UserVO userVO,
                                        HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            if (userVO.getUserId() == null) {
                userService.insertUser(userVO);
                result.put("message", "사용자가 등록되었습니다.");
            } else {
                userService.updateUser(userVO);
                result.put("message", "사용자 정보가 수정되었습니다.");
            }
            result.put("success", true);
            result.put("userId",  userVO.getUserId());
        } catch (IllegalArgumentException e) {
            // 서비스에서 "에러코드:메시지" 형식으로 던진 경우 파싱
            String[] parts  = e.getMessage().split(":", 2);
            result.put("success",   false);
            result.put("errorCode", parts.length > 1 ? parts[0] : "USER_ERR");
            result.put("message",   parts.length > 1 ? parts[1] : e.getMessage());
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
        }
        return result;
    }

    // ─────────────────────────────────────────────────────────────────
    // 로그인 ID 중복 확인 AJAX
    // ─────────────────────────────────────────────────────────────────

    @RequestMapping("/admin/user/checkLoginId.ajax")
    @ResponseBody
    public Map<String, Object> checkLoginId(@RequestParam String loginId) {
        Map<String, Object> result = new HashMap<>();
        try {
            UserVO user = userService.selectUserByLoginId(loginId);
            result.put("duplicated", user != null);
            result.put("success",    true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // ─────────────────────────────────────────────────────────────────
    // 사용자 상태 변경 AJAX (목록화면 인라인)
    // POST /admin/user/updateStatus.ajax
    // ─────────────────────────────────────────────────────────────────

    @RequestMapping("/admin/user/updateStatus.ajax")
    @ResponseBody
    public Map<String, Object> updateStatus(
            @RequestParam Long   userId,
            @RequestParam String status) {
        Map<String, Object> result = new HashMap<>();
        try {
            if (!status.matches("ACTIVE|LOCKED|INACTIVE")) {
                throw new IllegalArgumentException("유효하지 않은 상태값입니다.");
            }
            UserVO vo = new UserVO();
            vo.setUserId(userId);
            vo.setStatus(status);
            userService.updateUserStatus(vo);
            result.put("success", true);
            result.put("status",  status);
            result.put("message", "상태가 변경되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // ─────────────────────────────────────────────────────────────────
    // 사용자 목록 통계 AJAX (KPI 카드용)
    // GET /admin/user/userStats.ajax
    // ─────────────────────────────────────────────────────────────────

    @RequestMapping("/admin/user/userStats.ajax")
    @ResponseBody
    public Map<String, Object> userStats() {
        Map<String, Object> result = new HashMap<>();
        try {
            // 전체 / 역할별 / 상태별 카운트
            UserVO base = new UserVO();
            int total = userService.selectUserListTotCnt(base);

            UserVO activeVO = new UserVO(); activeVO.setStatus("ACTIVE");
            int activeCount = userService.selectUserListTotCnt(activeVO);

            UserVO lockedVO = new UserVO(); lockedVO.setStatus("LOCKED");
            int lockedCount = userService.selectUserListTotCnt(lockedVO);

            UserVO superVO = new UserVO(); superVO.setUserRole("SUPER_ADMIN");
            int superCount = userService.selectUserListTotCnt(superVO);

            UserVO sellerVO = new UserVO(); sellerVO.setUserRole("SELLER_ADMIN");
            int sellerCount = userService.selectUserListTotCnt(sellerVO);

            UserVO channelVO = new UserVO(); channelVO.setUserRole("CHANNEL_ADMIN");
            int channelCount = userService.selectUserListTotCnt(channelVO);

            UserVO buyerVO = new UserVO(); buyerVO.setUserRole("BUYER_ADMIN");
            int buyerCount = userService.selectUserListTotCnt(buyerVO);

            result.put("success",      true);
            result.put("total",        total);
            result.put("activeCount",  activeCount);
            result.put("lockedCount",  lockedCount);
            result.put("superCount",   superCount);
            result.put("sellerCount",  sellerCount);
            result.put("channelCount", channelCount);
            result.put("buyerCount",   buyerCount);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }
}
