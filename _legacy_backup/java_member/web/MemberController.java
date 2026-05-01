package kr.co.matpam.admin.member.web;

import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import kr.co.matpam.admin.member.service.MemberDefaultVO;
import kr.co.matpam.admin.member.service.MemberService;
import kr.co.matpam.admin.member.service.MemberVO;
import kr.co.matpam.admin.code.service.CodeManagementService;
import kr.co.matpam.admin.code.service.DetailCodeVO;



@Controller
public class MemberController {

    @Resource(name = "memberService")
    private MemberService memberService;

    @Resource(name = "codeManagementService")
    private CodeManagementService codeManagementService;

    /** 회원 목록 조회 (Screenshot 1 반영) */
    @RequestMapping(value = "/admin/member/memberList.do")
    public String selectMemberList(@ModelAttribute("searchVO") MemberDefaultVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
        
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
        paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
        paginationInfo.setPageSize(searchVO.getPageSize());

        searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
        searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        int totCnt = memberService.selectMemberListTotCnt(searchVO);
        paginationInfo.setTotalRecordCount(totCnt);

        model.addAttribute("resultList", memberService.selectMemberList(searchVO));
        model.addAttribute("paginationInfo", paginationInfo);

        // 공통 코드 (신규 명세 및 DB 실제 데이터 기준 - 최종 정합성 확인 완료)
        model.addAttribute("memberTypes", codeManagementService.selectDetailCodeList("MEMBER_TYPE", "MEMBER_ROLE"));
        model.addAttribute("statusCodes", codeManagementService.selectDetailCodeList("JOIN_STATUS", "JOIN_STATUS"));
        model.addAttribute("memberGrades", codeManagementService.selectDetailCodeList("MEMBER_GRADE", "MEMBER_GRADE"));
        
        // 채널은 다른 코드와 동일하게 상세코드에서 조회
        model.addAttribute("channels", codeManagementService.selectDetailCodeList("CHANNEL_TYPE", "CHANNEL_TYPE"));

        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/member/MemberList.jsp");
        return "layout/main";
    }

    /** 회원 상세 정보 조회 (등록/수정 폼, Screenshot 2, 3, 4 반영) */
    @RequestMapping(value = "/admin/member/memberDetail.do")
    public String memberDetail(@RequestParam(value = "memberId", required = false) Long memberId, ModelMap model) throws Exception {
        
        if (memberId != null) {
            model.addAttribute("member", memberService.selectMemberDetail(memberId));
            model.addAttribute("mode", "update");
        } else {
            model.addAttribute("member", new MemberVO());
            model.addAttribute("mode", "insert");
        }

        // 공통 코드 로드 (신규 명세 및 DB 실제 데이터 기준 - 최종 정합성 확인 완료)
        model.addAttribute("memberTypes", codeManagementService.selectDetailCodeList("MEMBER_TYPE", "MEMBER_ROLE"));
        model.addAttribute("statusCodes", codeManagementService.selectDetailCodeList("JOIN_STATUS", "JOIN_STATUS"));
        model.addAttribute("memberGrades", codeManagementService.selectDetailCodeList("MEMBER_GRADE", "MEMBER_GRADE"));
        
        // 채널은 다른 코드와 동일하게 상세코드에서 조회
        model.addAttribute("channels", codeManagementService.selectDetailCodeList("CHANNEL_TYPE", "CHANNEL_TYPE"));
        
        model.addAttribute("sellerTypes", codeManagementService.selectDetailCodeList("MEMBER_TYPE", "SELLER_ROLE"));
        model.addAttribute("taxTypes", codeManagementService.selectDetailCodeList("PRODUCT_TYPE", "TAX_TYPE"));
        
        // 판매자 상세 유형 (RAW: 원물, PROC: 가공 - 하드코딩 또는 코드 추가 필요)
        // 여기서는 예시로 로딩 로직만 구성

        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/member/MemberRegister.jsp");
        return "layout/main";
    }

    /** 회원 정보 저장 (등록/수정 통합) */
    @RequestMapping(value = "/admin/member/saveMember.do")
    public String saveMember(@ModelAttribute("memberVO") MemberVO memberVO, HttpServletRequest request, org.springframework.web.servlet.mvc.support.RedirectAttributes rttr) throws Exception {
        
        String adminId = (String) request.getAttribute("loginId");
        if (adminId == null) adminId = "SYSTEM";
        
        Long adminMemberId = (Long) request.getAttribute("adminMemberId");
        Long sessionCompanyId = (Long) request.getAttribute("companyId");
        String sessionChannelCd = (String) request.getAttribute("channelCd");
        
        try {
            if (memberVO.getMemberId() == null || memberVO.getMemberId() == 0) {
                memberVO.setRegId(adminId);
                memberVO.setCreatedByMemberId(adminMemberId);
                
                // 생성자의 소속이 있다면 상속
                if (memberVO.getCompanyId() == null && sessionCompanyId != null) {
                    memberVO.setCompanyId(sessionCompanyId);
                }
                if (memberVO.getManagingChannelCd() == null && sessionChannelCd != null) {
                    memberVO.setManagingChannelCd(sessionChannelCd);
                }
                
                memberService.insertMember(memberVO);
            } else {
                memberVO.setModId(adminId);
                memberService.updateMember(memberVO);
            }
        } catch (org.springframework.dao.DuplicateKeyException e) {
            rttr.addFlashAttribute("errorMessage", "이미 등록된 사업자번호 또는 아이디입니다.");
            if (memberVO.getMemberId() == null || memberVO.getMemberId() == 0) {
                return "redirect:/admin/member/memberDetail.do";
            } else {
                return "redirect:/admin/member/memberDetail.do?memberId=" + memberVO.getMemberId();
            }
        } catch (Exception e) {
            rttr.addFlashAttribute("errorMessage", "저장 중 오류가 발생했습니다. 확인 후 다시 시도해주세요.");
            if (memberVO.getMemberId() == null || memberVO.getMemberId() == 0) {
                return "redirect:/admin/member/memberDetail.do";
            } else {
                return "redirect:/admin/member/memberDetail.do?memberId=" + memberVO.getMemberId();
            }
        }

        return "redirect:/admin/member/memberList.do";
    }
}
