package kr.co.matpam.admin.member.web;

import java.time.LocalDate;
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

    @Resource(name = "codeManagementService")
    private kr.co.matpam.admin.code.service.CodeManagementService codeManagementService;

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

        // Load codes for search filters
        model.addAttribute("memberTypes", codeManagementService.selectDetailCodeList("003", "003001"));
        model.addAttribute("statusCodes", codeManagementService.selectDetailCodeList("004", "004001"));

        // Set content page for layout
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/member/MemberList.jsp");

        return "layout/main";
    }

    @RequestMapping(value = "/admin/member/memberRegisterForm.do")
    public String memberRegisterForm(ModelMap model) throws Exception {
        // Load codes for dropdowns
        model.addAttribute("memberTypes", codeManagementService.selectDetailCodeList("003", "003001"));
        model.addAttribute("memberGrades", codeManagementService.selectDetailCodeList("005", "005001"));
        model.addAttribute("statusCodes", codeManagementService.selectDetailCodeList("004", "004001"));

        // Set content page for layout
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/member/MemberRegister.jsp");
        return "layout/main";
    }

    @RequestMapping(value = "/admin/member/insertMember.do")
    public String insertMember(@ModelAttribute("memberVO") MemberVO memberVO,
            org.springframework.validation.BindingResult bindingResult, ModelMap model) throws Exception {
        if (bindingResult.hasErrors()) {
            System.out.println("Binding Errors: " + bindingResult.getAllErrors());
            for (org.springframework.validation.ObjectError error : bindingResult.getAllErrors()) {
                System.out.println(error.getDefaultMessage());
            }
            return "admin/member/MemberRegister"; // Return to form if errors
        }

        if (memberVO.getJoinDate() == null || memberVO.getJoinDate().isEmpty()) {
            memberVO.setJoinDate(LocalDate.now().toString());
        }
        if (memberVO.getCreditLimit() == null) {
            memberVO.setCreditLimit(0L);
        }
        if (memberVO.getMeatMoney() == null) {
            memberVO.setMeatMoney(0L);
        }
        if (memberVO.getAgreeMarketing() == null || memberVO.getAgreeMarketing().isEmpty()) {
            memberVO.setAgreeMarketing("N");
        }
        if (memberVO.getAgreeSms() == null || memberVO.getAgreeSms().isEmpty()) {
            memberVO.setAgreeSms("N");
        }
        memberService.insertMember(memberVO);
        return "redirect:/admin/member/memberList.do?menu=member";
    }
}
