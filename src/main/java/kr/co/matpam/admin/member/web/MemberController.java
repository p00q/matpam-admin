package kr.co.matpam.admin.member.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

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
        model.addAttribute("currentMenu", "member");
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/member/MemberList.jsp");

        return "layout/main";
    }
}
