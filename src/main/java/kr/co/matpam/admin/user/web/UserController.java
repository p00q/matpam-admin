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
import kr.co.matpam.admin.tenant.service.ChannelVO;
import kr.co.matpam.admin.tenant.service.SysChannelService;
import kr.co.matpam.admin.common.service.LoginVO;

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

    @Resource(name = "sysChannelService")
    private SysChannelService sysChannelService;

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
                           HttpServletRequest request,
                           ModelMap model) throws Exception {

        // 일반 회원 조회 모드 설정 (운영자 제외)
        searchVO.setSearchCondition("MEMBER");
        LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
        applyUserScope(searchVO, loginVO);

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
        model.addAttribute("companies",      companyService.selectCompanyListAll(buildCompanySearch(loginVO)));
        model.addAttribute("contentPage",    "/WEB-INF/jsp/admin/user/UserList.jsp");
        
        // 역할별 메뉴 및 제목 처리
        String role = searchVO.getUserRole();
        if ("SELLER_ADMIN".equals(role)) {
            model.addAttribute("currentMenu", "user_seller");
            model.addAttribute("pageTitle",   "판매회원 관리");
        } else if ("BUYER_ADMIN".equals(role)) {
            model.addAttribute("currentMenu", "user_buyer");
            model.addAttribute("pageTitle",   "구매회원 관리");
        } else {
            model.addAttribute("currentMenu", "user_list");
            model.addAttribute("pageTitle",   "회원관리");
        }

        return "layout/main";
    }

    // ─────────────────────────────────────────────────────────────────
    // 운영자 목록 (운영관리 > 운영자관리 전용)
    // ─────────────────────────────────────────────────────────────────

    @RequestMapping("/admin/user/operatorList.do")
    public String operatorList(@ModelAttribute("searchVO") UserVO searchVO,
                               HttpServletRequest request,
                               ModelMap model) throws Exception {

        try {
            System.out.println("[DEBUG] Entering operatorList.do");
            
            // 운영자 조회 모드 설정 (OPERATOR, CHANNEL_ADMIN만 포함)
            searchVO.setSearchCondition("OPERATOR");
            
            // 운영자·채널운영자만 필터
            if (searchVO.getUserRole() == null || searchVO.getUserRole().isEmpty()) {
                searchVO.setUserRole(null); 
            }

            int currentPage    = searchVO.getPageIndex()  != null ? searchVO.getPageIndex()  : 1;
            int recordsPerPage = searchVO.getPageUnit()   != null ? searchVO.getPageUnit()   : 10;

            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(currentPage);
            paginationInfo.setRecordCountPerPage(recordsPerPage);
            paginationInfo.setPageSize(10);

            searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
            searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
            
            // 운영자 계정 조회: 본인 테넌트 기준 (SUPER_ADMIN 제외)
            LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
            if (loginVO != null) {
                System.out.println("[DEBUG] LoginVO found: " + loginVO.getLoginId() + " | Role: " + loginVO.getRoleCd());
                if (!"SUPER_ADMIN".equals(loginVO.getMemberType())) {
                    searchVO.setTenantId(resolveTenantId(loginVO));
                    searchVO.setCompanyId(loginVO.getCompanyId());
                }
            } else {
                System.out.println("[DEBUG] LoginVO is NULL in session!");
            }

            int totalCount = userService.selectUserListTotCnt(searchVO);
            paginationInfo.setTotalRecordCount(totalCount);

            // 채널 목록 (역할 필터 드롭다운용)
            ChannelVO chParam = new ChannelVO();
            if (loginVO != null && !isSuperAdmin(loginVO)) {
                chParam.setCompanyId(loginVO.getCompanyId());
            }
            java.util.List<ChannelVO> channelList = sysChannelService.selectChannelList(chParam);

            model.addAttribute("operatorList",   userService.selectUserList(searchVO));
            model.addAttribute("paginationInfo", paginationInfo);
            model.addAttribute("channelList",    channelList);
            model.addAttribute("contentPage",    "/WEB-INF/jsp/admin/user/OperatorList.jsp");
            model.addAttribute("currentMenu",    "op_operator");
            model.addAttribute("pageTitle",      "운영자관리");

        } catch (Exception e) {
            System.err.println("[ERROR] Error in operatorList: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("errorMessage", "데이터 로딩 중 오류가 발생했습니다: " + e.getMessage());
            model.addAttribute("contentPage",  "/WEB-INF/jsp/common/error.jsp"); 
        }

        return "layout/main";
    }


    // ─────────────────────────────────────────────────────────────────
    // 사용자 등록/수정 폼
    // ─────────────────────────────────────────────────────────────────

    @RequestMapping("/admin/user/userForm.do")
    public String userForm(@RequestParam(value = "userId", required = false) Long userId,
                           HttpServletRequest request,
                           ModelMap model) throws Exception {

        LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
        UserVO user;
        if (userId == null) {
            user = new UserVO();
            user.setStatus("ACTIVE");
            user.setCreateContactYn("N");
            user.setIsPrimaryContact("N");
            
            // 관리자 권한 또는 파라미터에 따른 기본 역할 세팅
            String reqRole = request.getParameter("userRole");
            if (reqRole != null && !reqRole.isEmpty()) {
                user.setUserRole(reqRole);
            } else if (loginVO != null && !"SUPER_ADMIN".equals(loginVO.getMemberType())) {
                user.setCompanyId(loginVO.getCompanyId());
                user.setUserRole("SELLER".equals(loginVO.getMemberType()) ? "SELLER_ADMIN" : "BUYER_ADMIN");
            } else {
                user.setUserRole("SELLER_ADMIN"); // 운영자일 경우 기본값
            }
            if (loginVO != null && !isSuperAdmin(loginVO)) {
                user.setTenantId(resolveTenantId(loginVO));
                if ("CHANNEL_ADMIN".equals(loginVO.getMemberType())) {
                    user.setChannelId(loginVO.getChannelId());
                }
            }
        } else {
            UserVO param = new UserVO();
            param.setUserId(userId);
            user = userService.selectUserDetail(param);
        }
        // 폼 공통 옵션: 테넌트 목록 (화면 로딩 시 초기 노출)
        model.addAttribute("user",         user);
        model.addAttribute("tenants",      userService.selectActiveTenantList());
        
        String jspView = "admin/user/UserForm";
        if ("Y".equalsIgnoreCase(request.getParameter("isModal"))) {
            return jspView;
        }
        
        model.addAttribute("contentPage",  "/WEB-INF/jsp/" + jspView + ".jsp");
        model.addAttribute("currentMenu",  "user_form");
        model.addAttribute("pageTitle",    "회원등록");

        return "layout/main";
    }

    // ─────────────────────────────────────────────────────────────────
    // 운영자 등록/수정 폼 (운영자관리 전용 화면)
    // ─────────────────────────────────────────────────────────────────

    @RequestMapping("/admin/user/operatorForm.do")
    public String operatorForm(@RequestParam(value = "userId", required = false) Long userId,
                               HttpServletRequest request,
                               ModelMap model) throws Exception {

        UserVO user;
        if (userId == null) {
            user = new UserVO();
            user.setStatus("ACTIVE");
            user.setUserRole("OPERATOR");     // 기본: 운영자
            LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
            if (loginVO != null && !isSuperAdmin(loginVO)) {
                user.setTenantId(resolveTenantId(loginVO));
                user.setCompanyId(loginVO.getCompanyId());
            }
        } else {
            UserVO param = new UserVO();
            param.setUserId(userId);
            user = userService.selectUserDetail(param);
        }

        // 체널 목록 (채널운영자 선택 용)
        ChannelVO managedChannel = null;
        boolean channelAssignmentLocked = false;
        if (user != null && user.getUserId() != null) {
            managedChannel = sysChannelService.selectActiveChannelByManagerId(user.getUserId());
            channelAssignmentLocked = managedChannel != null;
            if (managedChannel != null) {
                user.setUserRole("CHANNEL_ADMIN");
                user.setChannelId(managedChannel.getChannelId());
            }
        }

        ChannelVO chParam = new ChannelVO();
        LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
        if (loginVO != null && !isSuperAdmin(loginVO)) {
            chParam.setCompanyId(loginVO.getCompanyId());
        }
        java.util.List<ChannelVO> channelList = sysChannelService.selectChannelList(chParam);

        model.addAttribute("user",        user);
        model.addAttribute("channelList", channelList);
        model.addAttribute("tenants",     userService.selectActiveTenantList());
        model.addAttribute("managedChannel", managedChannel);
        model.addAttribute("channelAssignmentLocked", channelAssignmentLocked);
        
        String jspView = "admin/user/OperatorForm";
        if ("Y".equalsIgnoreCase(request.getParameter("isModal"))) {
            return jspView;
        }

        model.addAttribute("contentPage", "/WEB-INF/jsp/" + jspView + ".jsp");
        model.addAttribute("currentMenu", "op_operator");
        model.addAttribute("pageTitle",   "운영자관리");

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
    // 사용자 상세 조회 AJAX (모달 연동용)
    // ─────────────────────────────────────────────────────────────────
    @RequestMapping("/admin/user/getUser.ajax")
    @ResponseBody
    public Map<String, Object> getUser(@RequestParam("userId") Long userId) {
        Map<String, Object> result = new HashMap<>();
        try {
            UserVO param = new UserVO();
            param.setUserId(userId);
            UserVO user = userService.selectUserDetail(param);
            result.put("success", true);
            result.put("user",    user);
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
            // CHANNEL_ADMIN 권한 차단: 운영자 등록/수정 불가
            LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
            if (loginVO != null && "CHANNEL_ADMIN".equals(loginVO.getMemberType())) {
                String targetRole = userVO.getUserRole();
                if ("OPERATOR".equals(targetRole) || "CHANNEL_ADMIN".equals(targetRole)) {
                    result.put("success", false);
                    result.put("message", "소속 채널 담당자는 운영자를 등록/수정할 권한이 없습니다.");
                    return result;
                }
            }
            validateManagedChannelChange(userVO);
            applyUserMutationScope(userVO, loginVO);
            if (userVO.getStatus() == null || userVO.getStatus().isEmpty()) {
                userVO.setStatus("ACTIVE");
            }
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
    public Map<String, Object> userStats(@RequestParam(value = "userRole", required = false) String userRole,
                                         @RequestParam(value = "searchCondition", required = false) String searchCondition,
                                         HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
            // 역할별 필터 반영
            UserVO base = new UserVO();
            base.setUserRole(userRole);
            base.setSearchCondition(searchCondition != null ? searchCondition : "MEMBER");
            applyUserScope(base, loginVO);
            int total = userService.selectUserListTotCnt(base);

            UserVO activeVO = new UserVO(); 
            activeVO.setStatus("ACTIVE");
            activeVO.setUserRole(userRole);
            activeVO.setSearchCondition(base.getSearchCondition());
            applyUserScope(activeVO, loginVO);
            int activeCount = userService.selectUserListTotCnt(activeVO);

            UserVO lockedVO = new UserVO(); 
            lockedVO.setStatus("LOCKED");
            lockedVO.setUserRole(userRole);
            lockedVO.setSearchCondition(base.getSearchCondition());
            applyUserScope(lockedVO, loginVO);
            int lockedCount = userService.selectUserListTotCnt(lockedVO);

            UserVO superVO = new UserVO(); superVO.setUserRole("SUPER_ADMIN");
            applyUserScope(superVO, loginVO);
            int superCount = userService.selectUserListTotCnt(superVO);

            UserVO sellerVO = new UserVO(); sellerVO.setUserRole("SELLER_ADMIN");
            applyUserScope(sellerVO, loginVO);
            int sellerCount = userService.selectUserListTotCnt(sellerVO);

            UserVO channelVO = new UserVO(); channelVO.setUserRole("CHANNEL_ADMIN");
            applyUserScope(channelVO, loginVO);
            int channelCount = userService.selectUserListTotCnt(channelVO);

            UserVO buyerVO = new UserVO(); buyerVO.setUserRole("BUYER_ADMIN");
            applyUserScope(buyerVO, loginVO);
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

    private void validateManagedChannelChange(UserVO userVO) throws Exception {
        if (userVO == null || userVO.getUserId() == null) {
            return;
        }

        ChannelVO managedChannel = sysChannelService.selectActiveChannelByManagerId(userVO.getUserId());
        if (managedChannel == null) {
            return;
        }

        if (!"CHANNEL_ADMIN".equals(userVO.getUserRole())) {
            throw new IllegalArgumentException("USER_ERR:채널에 배정된 담당자는 채널관리에서 해제 후 역할을 변경하세요.");
        }

        userVO.setChannelId(managedChannel.getChannelId());
    }

    private void applyUserScope(UserVO userVO, LoginVO loginVO) {
        if (userVO == null || loginVO == null || isSuperAdmin(loginVO)) {
            return;
        }
        userVO.setTenantId(resolveTenantId(loginVO));
        if ("CHANNEL_ADMIN".equals(loginVO.getMemberType())) {
            userVO.setChannelId(loginVO.getChannelId());
        }
    }

    private void applyUserMutationScope(UserVO userVO, LoginVO loginVO) {
        if (userVO == null || loginVO == null || isSuperAdmin(loginVO)) {
            return;
        }
        userVO.setTenantId(resolveTenantId(loginVO));
        if ("CHANNEL_ADMIN".equals(loginVO.getMemberType())) {
            userVO.setChannelId(loginVO.getChannelId());
        } else if ("OPERATOR".equals(loginVO.getMemberType()) && userVO.getCompanyId() == null) {
            userVO.setCompanyId(loginVO.getCompanyId());
        }
    }

    private CompanyVO buildCompanySearch(LoginVO loginVO) {
        CompanyVO companyVO = new CompanyVO();
        if (loginVO != null && !isSuperAdmin(loginVO)) {
            companyVO.setTenantId(resolveTenantId(loginVO));
            if ("CHANNEL_ADMIN".equals(loginVO.getMemberType())) {
                companyVO.setChannelId(loginVO.getChannelId());
            }
        }
        return companyVO;
    }

    private Long resolveTenantId(LoginVO loginVO) {
        if (loginVO == null) {
            return 1L;
        }
        return loginVO.getTenantId() != null ? loginVO.getTenantId() : 1L;
    }

    private boolean isSuperAdmin(LoginVO loginVO) {
        return "SUPER_ADMIN".equals(loginVO.getMemberType()) || "SUPER".equals(loginVO.getMemberType())
                || "SUPER".equals(loginVO.getRoleCd());
    }
}
