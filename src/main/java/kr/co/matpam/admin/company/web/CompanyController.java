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

import kr.co.matpam.admin.common.service.LoginVO;
import kr.co.matpam.admin.company.service.CompanyContactVO;
import kr.co.matpam.admin.company.service.CompanyService;
import kr.co.matpam.admin.company.service.CompanyVO;
import kr.co.matpam.admin.tenant.service.SysChannelService;
import kr.co.matpam.admin.tenant.service.ChannelVO;

/**
 * 업체 관리 컨트롤러
 */
@Controller
public class CompanyController {

    @Resource(name = "companyService")
    private CompanyService companyService;

    @Resource(name = "sysChannelService")
    private SysChannelService sysChannelService;

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

        LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
        applyCompanyScope(searchVO, loginVO);

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
        model.addAttribute("currentMenu", "SELLER".equals(type) ? "comp_seller" : ("BUYER".equals(type) ? "comp_buyer" : "comp_company"));
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
            HttpServletRequest request,
            ModelMap model) throws Exception {

        CompanyVO company;
        List<CompanyContactVO> contactList = null;
        LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");

        if (companyId == null) {
            // 신규 등록
            company = new CompanyVO();
            company.setTenantId(resolveTenantId(loginVO));
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
            // 담당자 목록 조회 (업체 유형 기반 필터 적용)
            CompanyVO contactParam = new CompanyVO();
            contactParam.setCompanyId(companyId);
            contactParam.setCompanyType(company.getCompanyType());
            contactList = companyService.selectCompanyContactList(contactParam);
            
            // 소속 채널 목록 조회 (기존 매핑 정보)
            List<Map<String, Object>> mappedChannelList = companyService.selectCompanyChannelList(companyId);
            model.addAttribute("mappedChannelList", mappedChannelList);
            if (mappedChannelList != null && !mappedChannelList.isEmpty()) {
                // 단일 채널 원칙에 따라 첫 번째 채널 ID를 VO에 세팅
                Object chId = mappedChannelList.get(0).get("channel_id");
                if (chId != null) {
                    company.setChannelId(Long.parseLong(chId.toString()));
                }
            }
        }

        // 전체 채널 목록 조회 (셀렉트 박스용)
        ChannelVO channelParam = new ChannelVO();
        channelParam.setRecordCountPerPage(100);
        channelParam.setFirstIndex(0);
        if (loginVO != null && !isSuperAdmin(loginVO)) {
            channelParam.setCompanyId(loginVO.getCompanyId());
        }
        model.addAttribute("allChannelList", sysChannelService.selectChannelList(channelParam));

        // 로그인 세션 정보 전달
        model.addAttribute("loginVO", loginVO);

        model.addAttribute("company",     company);
        model.addAttribute("contactList", contactList);
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/company/CompanyForm.jsp");

        // 사이드바 활성화 및 페이지 타이틀 결정
        String mode = (companyType != null && !companyType.isEmpty()) ? companyType : (company != null ? company.getCompanyType() : "");

        if ("SELLER".equals(mode)) {
            model.addAttribute("currentMenu", "comp_seller");
            model.addAttribute("pageTitle", "판매업체 등록/수정");
        } else if ("BUYER".equals(mode)) {
            model.addAttribute("currentMenu", "comp_buyer");
            model.addAttribute("pageTitle", "구매업체 등록/수정");
        } else {
            // companyId가 1이거나 타입 정보가 없는 경우 몰 기본정보(운영관리)로 처리
            model.addAttribute("currentMenu", "op_mall");
            model.addAttribute("pageTitle", "몰 기본정보");
        }

        return "layout/main";
    }

    /* ════════════════════════════════════════════
       업체 저장 (AJAX)
    ════════════════════════════════════════════ */
    @RequestMapping("/admin/company/saveCompany.ajax")
    @ResponseBody
    public Map<String, Object> saveCompany(CompanyVO companyVO,
                                           javax.servlet.http.HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            // CHANNEL_ADMIN 권한 차단: 몰 기본정보(BOTH) 저장 불가
            LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
            companyVO.setTenantId(resolveTenantId(loginVO));
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
       업체 통계 (KPI 카드용 AJAX)
    ════════════════════════════════════════════ */
    @RequestMapping("/admin/company/companyStats.ajax")
    @ResponseBody
    public Map<String, Object> companyStats(
            @RequestParam(required = false) String companyType,
            HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
            Long channelId = loginVO != null && "CHANNEL_ADMIN".equals(loginVO.getMemberType())
                    ? loginVO.getChannelId() : null;

            // 전체
            CompanyVO total = new CompanyVO();
            total.setCompanyType(companyType);
            total.setTenantId(resolveTenantId(loginVO));
            total.setChannelId(channelId);
            int totalCount = companyService.selectCompanyListTotCnt(total);

            // 정상(ACTIVE)
            CompanyVO active = new CompanyVO();
            active.setCompanyType(companyType);
            active.setStatus("ACTIVE");
            active.setTenantId(resolveTenantId(loginVO));
            active.setChannelId(channelId);
            int activeCount = companyService.selectCompanyListTotCnt(active);

            result.put("success",      true);
            result.put("total",        totalCount);
            result.put("activeCount",  activeCount);
            result.put("lockedCount",  totalCount - activeCount);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /* ════════════════════════════════════════════
       업체 검색 (AJAX – 회원 등록 시 사용)
    ════════════════════════════════════════════ */
    @RequestMapping("/admin/company/search.ajax")
    @ResponseBody
    public Map<String, Object> searchCompanies(
            @RequestParam(required = false) String searchKeyword,
            @RequestParam(required = false) String companyType,
            HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
            CompanyVO searchVO = new CompanyVO();
            searchVO.setSearchKeyword(searchKeyword);
            searchVO.setCompanyType(companyType);
            
            // 권한 기반 필터링
            if (loginVO != null && !isSuperAdmin(loginVO)) {
                searchVO.setTenantId(resolveTenantId(loginVO));
                if ("CHANNEL_ADMIN".equals(loginVO.getMemberType())) {
                    // 채널 관리자: 해당 채널에 소속된 업체만 조회
                    searchVO.setChannelId(loginVO.getChannelId());
                }
            }
            
            List<CompanyVO> list = companyService.selectCompanySearch(searchVO);
            result.put("success", true);
            result.put("list",    list);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /* ════════════════════════════════════════════
       대표 담당자 설정 (AJAX)
    ════════════════════════════════════════════ */
    @RequestMapping("/admin/company/setPrimaryContact.ajax")
    @ResponseBody
    public Map<String, Object> setPrimaryContact(
            @RequestParam Long companyId,
            @RequestParam Long contactId) {
        Map<String, Object> result = new HashMap<>();
        try {
            companyService.updatePrimaryContact(companyId, contactId);
            result.put("success", true);
            result.put("message", "대표 담당자로 설정되었습니다.");
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
    public Map<String, Object> contactList(
            @RequestParam Long companyId,
            @RequestParam(required = false) String companyType) {
        Map<String, Object> result = new HashMap<>();
        try {
            // companyType이 없으면 DB에서 조회
            if (companyType == null || companyType.isEmpty()) {
                CompanyVO detail = new CompanyVO();
                detail.setCompanyId(companyId);
                CompanyVO loaded = companyService.selectCompanyDetail(detail);
                if (loaded != null) companyType = loaded.getCompanyType();
            }
            CompanyVO param = new CompanyVO();
            param.setCompanyId(companyId);
            param.setCompanyType(companyType);
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

    /* ════════════════════════════════════════════
       사업자번호 중복 체크 (AJAX)
    ════════════════════════════════════════════ */
    @RequestMapping("/admin/company/checkBusinessNo.ajax")
    @ResponseBody
    public Map<String, Object> checkBusinessNo(
            @RequestParam String businessNo,
            @RequestParam(required = false) Long companyId,
            HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
            Long tenantId = resolveTenantId(loginVO);
            
            boolean isDuplicate = companyService.checkBusinessNoDuplicate(tenantId, businessNo, companyId);
            result.put("success", true);
            result.put("isDuplicate", isDuplicate);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /* ════════════════════════════════════════════
       업체 소속 채널 저장 (AJAX)
    ════════════════════════════════════════════ */
    @RequestMapping("/admin/company/saveChannels.ajax")
    @ResponseBody
    public Map<String, Object> saveChannels(
            @RequestParam Long companyId,
            @RequestParam(value = "channelIds[]", required = false) List<Long> channelIds,
            @RequestParam(value = "roles[]",      required = false) List<String> roles,
            HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
            Long tenantId = resolveTenantId(loginVO);

            java.util.List<java.util.Map<String, Object>> channels = new java.util.ArrayList<>();
            if (channelIds != null && roles != null) {
                for (int i = 0; i < channelIds.size(); i++) {
                    validateChannelMappingScope(channelIds.get(i), loginVO);
                    java.util.Map<String, Object> m = new java.util.HashMap<>();
                    m.put("channelId",     channelIds.get(i));
                    m.put("companyRoleCd", roles.get(i));
                    channels.add(m);
                }
            }
            
            companyService.saveCompanyChannelMappings(tenantId, companyId, channels);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    private void applyCompanyScope(CompanyVO searchVO, LoginVO loginVO) {
        if (searchVO == null || loginVO == null || isSuperAdmin(loginVO)) {
            return;
        }
        searchVO.setTenantId(resolveTenantId(loginVO));
        if ("CHANNEL_ADMIN".equals(loginVO.getMemberType())) {
            searchVO.setChannelId(loginVO.getChannelId());
        }
    }

    private void validateChannelMappingScope(Long channelId, LoginVO loginVO) throws Exception {
        if (channelId == null || loginVO == null || isSuperAdmin(loginVO)) {
            return;
        }
        if ("CHANNEL_ADMIN".equals(loginVO.getMemberType()) && !channelId.equals(loginVO.getChannelId())) {
            throw new IllegalArgumentException("소속 채널만 지정할 수 있습니다.");
        }
        ChannelVO channel = sysChannelService.selectChannelDetail(channelId);
        if (channel == null || channel.getCompanyId() == null || !channel.getCompanyId().equals(loginVO.getCompanyId())) {
            throw new IllegalArgumentException("운영업체에 속하지 않은 채널입니다.");
        }
    }

    private Long resolveTenantId(LoginVO loginVO) {
        if (loginVO == null) {
            return 1L;
        }
        return loginVO.getTenantId() != null ? loginVO.getTenantId() : 1L;
    }

    private boolean isSuperAdmin(LoginVO loginVO) {
        return "SUPER_ADMIN".equals(loginVO.getMemberType()) || "SUPER".equals(loginVO.getMemberType())
                || "SUPER".equals(loginVO.getRoleCd());
    }
}
