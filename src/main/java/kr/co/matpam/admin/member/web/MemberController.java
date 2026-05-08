package kr.co.matpam.admin.member.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.matpam.admin.member.service.MemberService;
import kr.co.matpam.admin.member.service.MemberVO;

@Controller
public class MemberController {

    @Resource(name = "memberService")
    private MemberService memberService;

    @RequestMapping("/admin/member/memberList.do")
    public String memberList(@ModelAttribute("searchVO") MemberVO searchVO, ModelMap model, HttpServletRequest request) throws Exception {
        
        int currentPage = searchVO.getPageIndex() != null ? searchVO.getPageIndex() : 1;
        int recordsPerPage = searchVO.getPageUnit() != null ? searchVO.getPageUnit() : 10;
        
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(currentPage);
        paginationInfo.setRecordCountPerPage(recordsPerPage);
        paginationInfo.setPageSize(10);

        searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        int totalCount = memberService.selectMemberListTotCnt(searchVO);
        paginationInfo.setTotalRecordCount(totalCount);

        model.addAttribute("memberList", memberService.selectMemberList(searchVO));
        model.addAttribute("paginationInfo", paginationInfo);
        
        model.addAttribute("pageTitle", "회원 관리");
        model.addAttribute("currentMenu", "op_admin");
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/member/MemberList.jsp");

        return "layout/main";
    }

    /**
     * 구매업체 상세 정보 조회
     */
    @RequestMapping("/admin/member/memberDetail.do")
    public String memberDetail(@RequestParam("companyId") Long companyId, ModelMap model) throws Exception {
        
        MemberVO param = new MemberVO();
        param.setCompanyId(companyId);
        
        MemberVO member = memberService.selectMemberDetail(param);
        model.addAttribute("memberVO", member);
        model.addAttribute("userList", memberService.selectMemberUserList(param));
        
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/member/MemberDetail.jsp");

        return "layout/main";
    }

    /**
     * 회원 등록 화면
     */
    @RequestMapping("/admin/member/userReg.do")
    public String userReg(ModelMap model) throws Exception {
        model.addAttribute("tenantList", memberService.selectTenantList());
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/member/UserReg.jsp");
        return "layout/main";
    }

    /**
     * 채널/업체 목록 조회 (AJAX)
     */
    @RequestMapping("/admin/member/getOptions.do")
    @org.springframework.web.bind.annotation.ResponseBody
    public java.util.Map<String, Object> getOptions(@RequestParam("tenantId") Long tenantId) throws Exception {
        java.util.Map<String, Object> resultMap = new java.util.HashMap<>();
        resultMap.put("channelList", memberService.selectChannelList(tenantId));
        resultMap.put("buyerList", memberService.selectBuyerCompanyList(tenantId));
        return resultMap;
    }

    /**
     * 회원 등록 처리 (AJAX)
     */
    @RequestMapping("/admin/member/insertUser.do")
    @org.springframework.web.bind.annotation.ResponseBody
    public java.util.Map<String, Object> insertUser(@ModelAttribute kr.co.matpam.admin.user.service.UserVO vo) throws Exception {
        java.util.Map<String, Object> resultMap = new java.util.HashMap<>();
        try {
            memberService.insertUser(vo);
            resultMap.put("success", true);
        } catch (Exception e) {
            resultMap.put("success", false);
            resultMap.put("message", e.getMessage());
        }
        return resultMap;
    }

    /**
     * 회원(사용자) 목록 검색 (AJAX)
     */
    @RequestMapping("/admin/member/selectMemberList.do")
    @org.springframework.web.bind.annotation.ResponseBody
    public java.util.Map<String, Object> selectMemberList(@ModelAttribute MemberVO searchVO) throws Exception {
        java.util.Map<String, Object> resultMap = new java.util.HashMap<>();
        try {
            searchVO.setFirstIndex(0);
            searchVO.setRecordCountPerPage(100);
            resultMap.put("success", true);
            resultMap.put("memberList", memberService.selectMemberList(searchVO));
        } catch (Exception e) {
            resultMap.put("success", false);
            resultMap.put("message", e.getMessage());
        }
        return resultMap;
    }
}
