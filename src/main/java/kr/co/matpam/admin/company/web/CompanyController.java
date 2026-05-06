package kr.co.matpam.admin.company.web;

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
        binder.registerCustomEditor(Long.class, new CustomNumberEditor(Long.class, true));
        binder.registerCustomEditor(Integer.class, new CustomNumberEditor(Integer.class, true));
    }

    /**
     * 업체 목록 조회
     */
    @RequestMapping("/admin/company/companyList.do")
    public String companyList(@ModelAttribute("searchVO") CompanyVO searchVO, ModelMap model, HttpServletRequest request) throws Exception {
        
        // 페이징 설정
        int currentPage = searchVO.getPageIndex() != null ? searchVO.getPageIndex() : 1;
        int recordsPerPage = searchVO.getPageUnit() != null ? searchVO.getPageUnit() : 10;
        
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(currentPage);
        paginationInfo.setRecordCountPerPage(recordsPerPage);
        paginationInfo.setPageSize(10);

        searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        int totalCount = companyService.selectCompanyListTotCnt(searchVO);
        paginationInfo.setTotalRecordCount(totalCount);

        model.addAttribute("companyList", companyService.selectCompanyList(searchVO));
        model.addAttribute("paginationInfo", paginationInfo);
        
        // 메뉴 활성화 및 타이틀 설정
        String type = searchVO.getCompanyType();
        model.addAttribute("currentMenu", "SELLER".equals(type) ? "seller" : ("BUYER".equals(type) ? "buyer" : "company"));
        model.addAttribute("pageTitle", "SELLER".equals(type) ? "판매업체 관리" : ("BUYER".equals(type) ? "구매업체 관리" : "업체 관리"));
        
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/company/CompanyList.jsp");

        return "layout/main";
    }

    /**
     * 업체 등록/수정 폼
     */
    @RequestMapping("/admin/company/companyForm.do")
    public String companyForm(@RequestParam(value = "companyId", required = false) Long companyId, 
                             @RequestParam(value = "companyType", required = false) String companyType,
                             ModelMap model) throws Exception {
        
        CompanyVO company;
        if (companyId == null) {
            company = new CompanyVO();
            company.setTenantId(1L);
            company.setCompanyType(companyType); // 목록에서 넘어온 타입 설정
            company.setStatus("ACTIVE");
            company.setContactList(new java.util.ArrayList<>());
        } else {
            CompanyVO param = new CompanyVO();
            param.setCompanyId(companyId);
            company = companyService.selectCompanyDetail(param);
            if (company == null) {
                return "redirect:/admin/company/companyList.do";
            }
            // 담당자 목록 조회
            company.setContactList(companyService.selectCompanyContactList(param));
            if (company.getContactList() == null) {
                company.setContactList(new java.util.ArrayList<>());
            }
        }

        model.addAttribute("company", company);
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/company/CompanyForm.jsp");

        return "layout/main";
    }

    /**
     * 업체 저장 (AJAX)
     */
    @RequestMapping("/admin/company/saveCompany.ajax")
    @ResponseBody
    public Map<String, Object> saveCompany(CompanyVO companyVO, HttpServletRequest request) {
        System.out.println("DEBUG: saveCompany.ajax called with " + companyVO.toString());
        Map<String, Object> result = new HashMap<>();
        try {
            // 강제로 테넌트 ID 고정 및 세션 체크 무시
            companyVO.setTenantId(1L);
            
            if (companyVO.getCompanyId() == null || companyVO.getCompanyId() == 0) {
                companyService.insertCompany(companyVO);
            } else {
                companyService.updateCompany(companyVO);
            }
            result.put("success", true);
            result.put("companyId", companyVO.getCompanyId()); // Return ID for redirection
            result.put("message", "저장되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 업체 상태 변경 (AJAX)
     */
    @RequestMapping("/admin/company/updateStatus.ajax")
    @ResponseBody
    public Map<String, Object> updateStatus(@RequestParam Long companyId, @RequestParam String status) {
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

    /**
     * 업체 담당자 저장 (AJAX)
     */
    @RequestMapping("/admin/company/saveContact.ajax")
    @ResponseBody
    public Map<String, Object> saveContact(kr.co.matpam.admin.company.service.CompanyContactVO vo) {
        Map<String, Object> result = new HashMap<>();
        try {
            companyService.insertCompanyContact(vo);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 업체 담당자 삭제 (AJAX)
     */
    @RequestMapping("/admin/company/deleteContact.ajax")
    @ResponseBody
    public Map<String, Object> deleteContact(@RequestParam Long contactId) {
        Map<String, Object> result = new HashMap<>();
        try {
            companyService.deleteCompanyContact(contactId);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }
}
