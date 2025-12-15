package kr.co.matpam.admin.member.web;

import java.time.LocalDate;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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

        // ✅ 코드값 세팅
        // 회원타입
        model.addAttribute("memberTypes", codeManagementService.selectDetailCodeList("MEMBER_TYPE", "MEMBER_ROLE"));
        // 가입상태
        model.addAttribute("statusCodes", codeManagementService.selectDetailCodeList("JOIN_STATUS", "JOIN_STATUS"));
        // ✅ 회원등급
        model.addAttribute("memberGrades", codeManagementService.selectDetailCodeList("MEMBER_GRADE", "MEMBER_GRADE"));

        // Set content page for layout
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/member/MemberList.jsp");

        return "layout/main";
    }

    @RequestMapping(value = "/admin/member/memberRegisterForm.do")
    public String memberRegisterForm(ModelMap model) throws Exception {
        // Load codes for dropdowns
        model.addAttribute("memberTypes", codeManagementService.selectDetailCodeList("MEMBER_TYPE", "MEMBER_ROLE"));
        model.addAttribute("memberGrades", codeManagementService.selectDetailCodeList("MEMBER_GRADE", "MEMBER_GRADE"));
        model.addAttribute("statusCodes", codeManagementService.selectDetailCodeList("JOIN_STATUS", "JOIN_STATUS"));

        model.addAttribute("mode", "insert");

        // Set content page for layout
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/member/MemberRegister.jsp");
        return "layout/main";
    }

    @RequestMapping(value = "/admin/member/insertMember.do")
    public String insertMember(@ModelAttribute("memberVO") MemberVO memberVO,
            org.springframework.validation.BindingResult bindingResult,
            ModelMap model) throws Exception {

        // 1) 스프링 바인딩 에러 체크
        if (bindingResult.hasErrors()) {
            return returnFormWithError("입력값 오류가 있습니다.", memberVO, model, "insert");
        }

        // 2) 기본값 세팅
        // 가입일
        if (memberVO.getJoinDate() == null || memberVO.getJoinDate().isEmpty()) {
            memberVO.setJoinDate(LocalDate.now().toString());
        }
        // 여신/미트머니
        if (memberVO.getCreditLimit() == null) {
            memberVO.setCreditLimit(0L);
        }
        if (memberVO.getMeatMoney() == null) {
            memberVO.setMeatMoney(0L);
        }
        // 마케팅/SMS 동의
        if (memberVO.getAgreeMarketing() == null || memberVO.getAgreeMarketing().isEmpty()) {
            memberVO.setAgreeMarketing("N");
        }
        if (memberVO.getAgreeSms() == null || memberVO.getAgreeSms().isEmpty()) {
            memberVO.setAgreeSms("N");
        }
        // 회원등급
        if (memberVO.getMemberGrade() == null || memberVO.getMemberGrade().isEmpty()) {
            memberVO.setMemberGrade("GRADE_NORMAL");
        }

        try {
            // 3) 실제 저장
            memberService.insertMember(memberVO);

        } catch (IllegalStateException e) {
            // ServiceImpl에서 중복 ID / 사업자번호 등으로 던진 예외
            return returnFormWithError(e.getMessage(), memberVO, model, "insert");

        } catch (org.springframework.dao.DataIntegrityViolationException e) {
            // 혹시라도 DB Unique 제약으로 직접 터지는 경우 처리
            String msg = "회원 등록 중 오류가 발생했습니다.";

            String lower = e.getMostSpecificCause().getMessage().toLowerCase();
            if (lower.contains("uq_tb_member_login_id")) {
                msg = "이미 사용 중인 아이디입니다.";
            } else if (lower.contains("uq_tb_member_biz_reg_no")) {
                msg = "이미 등록된 사업자등록번호입니다.";
            }

            return returnFormWithError(msg, memberVO, model, "insert");
        }

        // 4) 정상 등록
        return "redirect:/admin/member/memberList.do?menu=member";
    }

    @RequestMapping(value = "/admin/member/memberDetail.do")
    public String selectMember(@RequestParam("memberId") String memberId, ModelMap model) throws Exception {
        MemberVO member = memberService.selectMemberById(memberId);
        if (member == null) {
            return "redirect:/admin/member/memberList.do?menu=member";
        }

        List<kr.co.matpam.admin.member.service.manager.MemberManagerVO> managerList = memberService
                .selectMemberManagers(member.getMemberNo());
        member.setMemberManagers(managerList);

        model.addAttribute("member", member);
        model.addAttribute("memberManagers", managerList);
        model.addAttribute("managers", managerList);

        model.addAttribute("mode", "update");
        model.addAttribute("memberTypes", codeManagementService.selectDetailCodeList("MEMBER_TYPE", "MEMBER_ROLE"));
        model.addAttribute("memberGrades", codeManagementService.selectDetailCodeList("MEMBER_GRADE", "MEMBER_GRADE"));
        model.addAttribute("statusCodes", codeManagementService.selectDetailCodeList("JOIN_STATUS", "JOIN_STATUS"));

        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/member/MemberRegister.jsp");
        return "layout/main";
    }

    @RequestMapping(value = "/admin/member/updateMember.do")
    public String updateMember(@ModelAttribute("memberVO") MemberVO memberVO,
            org.springframework.validation.BindingResult bindingResult,
            ModelMap model) throws Exception {

        if (bindingResult.hasErrors()) {
            return returnFormWithError("입력값 오류가 있습니다.", memberVO, model, "update");
        }

        try {
            memberService.updateMember(memberVO);
        } catch (Exception e) {
            return returnFormWithError("회원 수정 중 오류가 발생했습니다: " + e.getMessage(), memberVO, model, "update");
        }

        return "redirect:/admin/member/memberList.do?menu=member";
    }

    private String returnFormWithError(String message, MemberVO memberVO, ModelMap model, String mode)
            throws Exception {
        // 에러 메시지
        model.addAttribute("errorMessage", message);

        // 셀렉트박스 코드 다시 세팅
        model.addAttribute("memberTypes",
                codeManagementService.selectDetailCodeList("003", "003001")); // 회원타입
        model.addAttribute("memberGrades",
                codeManagementService.selectDetailCodeList("005", "005001")); // 회원등급
        model.addAttribute("statusCodes",
                codeManagementService.selectDetailCodeList("004", "004001")); // 가입상태

        // 기존 입력값 그대로 다시 내려줌
        model.addAttribute("member", memberVO);
        model.addAttribute("mode", mode);

        // 레이아웃용
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/member/MemberRegister.jsp");
        return "layout/main";
    }
}
