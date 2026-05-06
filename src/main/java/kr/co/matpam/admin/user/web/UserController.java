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
        binder.registerCustomEditor(Long.class, new CustomNumberEditor(Long.class, true));
        binder.registerCustomEditor(Integer.class, new CustomNumberEditor(Integer.class, true));
    }

    /**
     * 사용자 목록 조회
     */
    @RequestMapping("/admin/user/userList.do")
    public String userList(@ModelAttribute("searchVO") UserVO searchVO, ModelMap model, HttpServletRequest request) throws Exception {
        
        int currentPage = searchVO.getPageIndex() != null ? searchVO.getPageIndex() : 1;
        int recordsPerPage = searchVO.getPageUnit() != null ? searchVO.getPageUnit() : 10;
        
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(currentPage);
        paginationInfo.setRecordCountPerPage(recordsPerPage);
        paginationInfo.setPageSize(10);

        searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        int totalCount = userService.selectUserListTotCnt(searchVO);
        paginationInfo.setTotalRecordCount(totalCount);

        model.addAttribute("userList", userService.selectUserList(searchVO));
        model.addAttribute("paginationInfo", paginationInfo);
        
        model.addAttribute("pageTitle", "운영 계정 관리");
        model.addAttribute("currentMenu", "user");
        
        // 검색 필터용 업체 목록
        model.addAttribute("companies", companyService.selectCompanyListAll(new CompanyVO()));
        
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/user/UserList.jsp");

        return "layout/main";
    }

    /**
     * 사용자 등록/수정 폼
     */
    @RequestMapping("/admin/user/userForm.do")
    public String userForm(@RequestParam(value = "userId", required = false) Long userId, ModelMap model) throws Exception {
        
        UserVO user;
        if (userId == null) {
            user = new UserVO();
            user.setStatus("ACTIVE");
        } else {
            UserVO param = new UserVO();
            param.setUserId(userId);
            user = userService.selectUserDetail(param);
        }

        model.addAttribute("user", user);
        model.addAttribute("companies", companyService.selectCompanyListAll(new CompanyVO()));
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/user/UserForm.jsp");

        return "layout/main";
    }

    /**
     * 사용자 저장 (AJAX)
     */
    @RequestMapping("/admin/user/saveUser.ajax")
    @ResponseBody
    public Map<String, Object> saveUser(UserVO userVO) {
        Map<String, Object> result = new HashMap<>();
        try {
            if (userVO.getUserId() == null) {
                // 아이디 중복 체크 로직 추가 권장
                userService.insertUser(userVO);
            } else {
                userService.updateUser(userVO);
            }
            result.put("success", true);
            result.put("message", "저장되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
        }
        return result;
    }

    /**
     * 아이디 중복 체크
     */
    @RequestMapping("/admin/user/checkLoginId.ajax")
    @ResponseBody
    public Map<String, Object> checkLoginId(@RequestParam String loginId) {
        Map<String, Object> result = new HashMap<>();
        try {
            UserVO user = userService.selectUserByLoginId(loginId);
            result.put("duplicated", user != null);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }
}
