package kr.co.matpam.admin.member.web;

import java.beans.PropertyEditorSupport;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.WebDataBinder;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import kr.co.matpam.admin.member.service.MemberDefaultVO;
import kr.co.matpam.admin.member.service.MemberService;
import kr.co.matpam.admin.member.service.MemberVO;

@Controller
public class MemberController {

    @Resource(name = "memberService")
    private MemberService memberService;

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        dateFormat.setLenient(false);

        binder.registerCustomEditor(java.sql.Date.class, new PropertyEditorSupport() {
            @Override
            public void setAsText(String text) throws IllegalArgumentException {
                if (text == null || text.trim().isEmpty()) {
                    setValue(null);
                    return;
                }

                try {
                    java.util.Date utilDate = dateFormat.parse(text.trim());
                    setValue(new java.sql.Date(utilDate.getTime()));
                } catch (ParseException e) {
                    throw new IllegalArgumentException("Invalid date format. Please use yyyy-MM-dd", e);
                }
            }

            @Override
            public String getAsText() {
                Object value = getValue();
                if (value instanceof java.sql.Date) {
                    return dateFormat.format((java.sql.Date) value);
                }
                return "";
            }
        });
    }

    @RequestMapping(value = "/admin/member/memberForm.do")
    public String memberForm() {
        return "admin/member/MemberRegister";
    }

    @RequestMapping(value = "/admin/member/memberRegister.do")
    public String memberRegister() {
        return "admin/member/MemberRegister";
    }

    @RequestMapping(value = "/admin/member/insertMember.do", method = RequestMethod.POST)
    public String insertMember(@ModelAttribute("member") MemberVO member) throws Exception {
        memberService.insertMember(member);
        return "redirect:/admin/member/memberList.do";
    }

    @RequestMapping(value = "/admin/member/memberList.do")
    public String selectMemberList(@ModelAttribute("searchVO") MemberDefaultVO searchVO, ModelMap model) throws Exception {
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
        return "admin/member/MemberList";
    }
}
