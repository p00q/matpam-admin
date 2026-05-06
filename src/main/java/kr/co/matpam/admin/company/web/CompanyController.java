package kr.co.matpam.admin.company.web;

import java.util.HashMap;
import java.util.List;
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

import kr.co.matpam.admin.company.service.CompanyContactVO;
import kr.co.matpam.admin.company.service.CompanyService;
import kr.co.matpam.admin.company.service.CompanyVO;

/**
 * 업체 관리 컨트롤러
 */
@Controller
public class CompanyController {

    @Resource(name = "companyService")
    private CompanyService companyService;

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
        binder.registerCustomEditor(Long.class,    new CustomNumberEditor(Long.class,    true));
        binder.registerCustomEditor(Integer.class, new CustomNumberEditor(Integer.class, true));
    }

    /* ════════════════════════════════════════════
       업체 목록
    ════════════════════════════════════════════ */
    @RequestMapping("/admin/company/companyList.do")
    public String companyList(
            @ModelAttribute("searchVO") CompanyVO searchVO,
            ModelMap model,
            HttpServletRequest request) throws Exception {

        int currentPage    = searchVO.getPageIndex() != null ? searchVO.getPageIndex() : 1;
        int recordsPerPage = searchVO.getPageUnit()  != null ? searchVO.getPageUnit()  : 10;

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(currentPage);
        paginationInfo.setRecordCountPerPage(recordsPerPage);
        paginationInfo.setPageSize(10);

        searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        int totalCount = companyService.selectCompanyListTotCnt(searchVO);
        paginationInfo.setTotalRecordCount(totalCount);

        String type = searchVO.getCompanyType();
        model.addAttribute("companyList",    companyService.selectCompanyList(searchVO));
        model.addAttribute("paginationInfo", paginationInfo);
        model.addAttribute("currentMenu",    "SELLER".equals(type) ? "seller" : ("BUYER".equals(type) ? "buyer" : "company"));
        model.addAttribute("pageTitle",      "SELLER".equals(type) ? "판매업체 관리" : ("BUYER".equals(type) ? "구매업체 관리" : "업체 관리"));
        model.addAttribute("contentPage",    "/WEB-INF/jsp/admin/company/CompanyList.jsp");

        return "layout/main";
    }

    /* ════════════════════════════════════════════
       업체 등록/수정 폼
    ════════════════════════════════════════════ */
    @RequestMapping("/admin/company/companyForm.do")
    public String companyForm(
            @RequestParam(value = "companyId",   required = false) Long   companyId,
            @RequestParam(value = "companyType", required = false) String companyType,
            ModelMap model) throws Exception {

        CompanyVO company;
        List<CompanyContactVO> contactList = null;

        if (companyId == null) {
            // 신규 등록
            company = new CompanyVO();
            company.setTenantId(1L);
            company.setCompanyType(companyType);
            company.setStatus("ACTIVE");
        } else {
            // 수정
            CompanyVO param = new CompanyVO();
            param.setCompanyId(companyId);
            company = companyService.selectCompanyDetail(param);
            if (company == null) {
                return "redirect:/admin/company/companyList.do";
            }
            // 담당자 목록 조회 → 별도 model attribute로 전달
            contactList = companyService.selectCompanyContactList(param);
        }

        model.addAttribute("company",     company);
        model.addAttribute("contactList", contactList);   // JSP에서 ${contactList} 사용
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/company/CompanyForm.jsp");

        return "layout/main";
    }

    /* ════════════════════════════════════════════
       업체 저장 (AJAX)
    ════════════════════════════════════════════ */
    @RequestMapping("/admin/company/saveCompany.ajax")
    @ResponseBody
    public Map<String, Object> saveCompany(CompanyVO companyVO) {
        Map<String, Object> result = new HashMap<>();
        try {
            companyVO.setTenantId(1L); // 임시 고정
            if (companyVO.getCompanyId() == null || companyVO.getCompanyId() == 0) {
                companyService.insertCompany(companyVO);
            } else {
                companyService.updateCompany(companyVO);
            }
            result.put("success",   true);
            result.put("companyId", companyVO.getCompanyId());
            result.put("message",   "저장되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
        }
        return result;
    }

    /* ════════════════════════════════════════════
       업체 상태 변경 (AJAX)
    ════════════════════════════════════════════ */
    @RequestMapping("/admin/company/updateStatus.ajax")
    @ResponseBody
    public Map<String, Object> updateStatus(
            @RequestParam Long companyId,
            @RequestParam String status) {
        Map<String, Object> result = new HashMap<>();
        try {
            CompanyVO vo = new CompanyVO();
            vo.setCompanyId(companyId);
            vo.setStatus(status);
            companyService.updateCompanyStatus(vo);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /* ════════════════════════════════════════════
       담당자 목록 조회 (AJAX – 저장 후 새로고침용)
    ════════════════════════════════════════════ */
    @RequestMapping("/admin/company/contactList.ajax")
    @ResponseBody
    public Map<String, Object> contactList(@RequestParam Long companyId) {
        Map<String, Object> result = new HashMap<>();
        try {
            CompanyVO param = new CompanyVO();
            param.setCompanyId(companyId);
            List<CompanyContactVO> list = companyService.selectCompanyContactList(param);
            result.put("success", true);
            result.put("list",    list);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /* ════════════════════════════════════════════
       담당자 저장 – 추가/수정 통합 (AJAX)
       contactId 있으면 update, 없으면 insert
    ════════════════════════════════════════════ */
    @RequestMapping("/admin/company/saveContact.ajax")
    @ResponseBody
    public Map<String, Object> saveContact(CompanyContactVO vo) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 필수값 검증
            if (vo.getCompanyId() == null) {
                result.put("success", false);
                result.put("message", "업체 ID가 없습니다.");
                return result;
            }
            if (vo.getContactName() == null || vo.getContactName().isEmpty()) {
                result.put("success", false);
                result.put("message", "성명을 입력하세요.");
                return result;
            }
            if (vo.getContactRole() == null || vo.getContactRole().isEmpty()) {
                result.put("success", false);
                result.put("message", "역할을 선택하세요.");
                return result;
            }
            if (vo.getIsPrimary() == null) {
                vo.setIsPrimary("N");
            }

            if (vo.getContactId() == null || vo.getContactId() == 0) {
                // 신규 등록
                companyService.insertCompanyContact(vo);
            } else {
                // 수정
                companyService.updateCompanyContact(vo);
            }
            result.put("success",   true);
            result.put("contactId", vo.getContactId());
            result.put("message",   "담당자가 저장되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
        }
        return result;
    }

    /* ════════════════════════════════════════════
       담당자 삭제 (AJAX)
    ════════════════════════════════════════════ */
    @RequestMapping("/admin/company/deleteContact.ajax")
    @ResponseBody
    public Map<String, Object> deleteContact(@RequestParam Long contactId) {
        Map<String, Object> result = new HashMap<>();
        try {
            CompanyContactVO vo = new CompanyContactVO();
            vo.setContactId(contactId);
            companyService.deleteCompanyContact(vo);
            result.put("success", true);
            result.put("message", "담당자가 삭제되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }
}
