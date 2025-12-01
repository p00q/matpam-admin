package kr.co.matpam.admin.member.web;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import kr.co.matpam.admin.member.service.MemberDefaultVO;
import kr.co.matpam.admin.member.service.MemberService;
import kr.co.matpam.admin.member.service.MemberVO;

@Controller
public class MemberController {

    @Resource(name = "memberService")
    private MemberService memberService;

    @RequestMapping(value = "/admin/member/memberList.do")
    public String selectMemberList(@ModelAttribute("searchVO") MemberDefaultVO searchVO, ModelMap model)
            throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
        paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
        paginationInfo.setPageSize(searchVO.getPageSize());

        searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
        searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        int totCnt = memberService.selectMemberListTotCnt(searchVO);
        paginationInfo.setTotalRecordCount(totCnt);

        List<MemberVO> resultList = memberService.selectMemberList(searchVO);
        model.addAttribute("resultList", resultList);
        model.addAttribute("paginationInfo", paginationInfo);

        // Set content page for layout
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/member/MemberList.jsp");

        return "layout/main";
    }

    @RequestMapping(value = "/admin/member/memberRegisterForm.do")
    public String memberRegisterForm(ModelMap model) throws Exception {
        // Set content page for layout
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/member/MemberRegister.jsp");
        return "layout/main";
    }

    @RequestMapping(value = "/admin/member/insertMember.do")
    public String insertMember(@ModelAttribute("memberVO") MemberVO memberVO) throws Exception {
        memberService.insertMember(memberVO);
        return "redirect:/admin/member/memberList.do?menu=member";
    }
}
