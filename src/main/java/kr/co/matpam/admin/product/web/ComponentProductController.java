package kr.co.matpam.admin.product.web;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.beans.propertyeditors.CustomNumberEditor;
import org.springframework.beans.propertyeditors.StringTrimmerEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import kr.co.matpam.admin.code.service.CodeManagementService;
import kr.co.matpam.admin.member.service.MemberService;
import kr.co.matpam.admin.product.service.ComponentProductService;
import kr.co.matpam.admin.product.service.ComponentProductVO;

/**
 * 구성상품(컴포넌트상품) 전용 컨트롤러
 * - 대상 테이블: TB_COMPONENT_PRODUCT
 * - PK: COMPONENT_PROD_ID
 */
@Controller
public class ComponentProductController {

    private static final Logger LOGGER = LoggerFactory.getLogger(ComponentProductController.class);

    @Resource(name = "codeManagementService")
    private CodeManagementService codeManagementService;

    @Resource(name = "memberService")
    private MemberService memberService;

    @Resource(name = "componentProductService")
    private ComponentProductService componentProductService;

    /**
     * 빈 문자열을 null로 변환 (날짜/숫자 필드 바인딩 문제 해결)
     */
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
        binder.registerCustomEditor(Long.class, new CustomNumberEditor(Long.class, true));
        binder.registerCustomEditor(Integer.class, new CustomNumberEditor(Integer.class, true));
        binder.registerCustomEditor(Date.class, new CustomDateEditor(new SimpleDateFormat("yyyy-MM-dd"), true));
    }

    /**
     * 구성상품 목록 화면
     */
    @RequestMapping(value = "/admin/product/componentProductList.do")
    public String componentProductList(@ModelAttribute("searchVO") ComponentProductVO searchVO, ModelMap model)
            throws Exception {

        int currentPage = searchVO.getPageIndex() != null ? searchVO.getPageIndex() : 1;
        int recordsPerPage = searchVO.getPageUnit() != null ? searchVO.getPageUnit() : 10;
        int pageSize = searchVO.getPageSize() != null ? searchVO.getPageSize() : 10;

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(currentPage);
        paginationInfo.setRecordCountPerPage(recordsPerPage);
        paginationInfo.setPageSize(pageSize);

        searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
        searchVO.setPageIndex(currentPage);
        searchVO.setPageUnit(recordsPerPage);
        searchVO.setPageSize(pageSize);

        int totalCount = componentProductService.selectComponentProductListTotCnt(searchVO);
        paginationInfo.setTotalRecordCount(totalCount);

        model.addAttribute("componentList", componentProductService.selectComponentProductList(searchVO));
        model.addAttribute("paginationInfo", paginationInfo);

        addComponentDropdowns(model);

        // JSP 파일명도 Component로 바꿀 경우
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/ComponentProductList.jsp");

        return "layout/main";
    }

    /**
     * 구성상품 등록 화면
     */
    @RequestMapping(value = "/admin/product/componentRegist.do")
    public String componentRegistForm(ModelMap model) throws Exception {

        Date today = new Date();
        Calendar nextYear = Calendar.getInstance();
        nextYear.setTime(today);
        nextYear.add(Calendar.YEAR, 1);

        ComponentProductVO component = new ComponentProductVO();
        component.setSaleStartDate(today);
        component.setSaleEndDate(nextYear.getTime());

        // 기본값(화면에서 체크박스 기본 선택 등)
        component.setDisplayYn("Y");

        model.addAttribute("component", component);
        addComponentDropdowns(model);

        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/ComponentProductRegister.jsp");
        return "layout/main";
    }

    /**
     * 구성상품 등록 처리
     */
    @RequestMapping(value = "/admin/product/insertComponentProduct.do", method = RequestMethod.POST)
    public String insertComponentProduct(ComponentProductVO componentProductVO) throws Exception {

        LOGGER.debug("Insert Component Product (name): {}", componentProductVO.getProductName());

        // 등록자/수정자 세팅은 로그인 연동 후 표준 방식으로 세팅하는게 정석
        // (현재는 기존 코드 패턴을 유지한다고 가정)

        componentProductService.insertComponentProduct(componentProductVO);

        return "redirect:/admin/product/componentProductList.do?menu=component";
    }

    /**
     * 구성상품 상세/수정 화면
     */
    @RequestMapping(value = "/admin/product/componentDetail.do")
    public String componentDetailForm(@RequestParam("componentProdId") Long componentProdId, ModelMap model)
            throws Exception {

        ComponentProductVO component = componentProductService.selectComponentProduct(componentProdId);
        model.addAttribute("component", component);

        addComponentDropdowns(model);

        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/ComponentProductRegister.jsp");
        return "layout/main";
    }

    /**
     * 구성상품 수정 처리
     */
    @RequestMapping(value = "/admin/product/updateComponentProduct.do", method = RequestMethod.POST)
    public String updateComponentProduct(ComponentProductVO componentProductVO) throws Exception {

        componentProductService.updateComponentProduct(componentProductVO);

        return "redirect:/admin/product/componentProductList.do?menu=component";
    }

    /**
     * 구성상품 삭제 처리
     */
    @RequestMapping(value = "/admin/product/deleteComponentProduct.do")
    public String deleteComponentProduct(@RequestParam("componentProdId") Long componentProdId) throws Exception {

        componentProductService.deleteComponentProduct(componentProdId);

        return "redirect:/admin/product/componentProductList.do?menu=component";
    }

    private void addComponentDropdowns(ModelMap model) throws Exception {
        // 공통 코드 (신규 코드 테이블 기준)
        model.addAttribute("saleTypes", codeManagementService.selectDetailCodeList("SALE_STATUS", "SALE_TYPE"));
        model.addAttribute("saleStatuses", codeManagementService.selectDetailCodeList("SALE_STATUS", "SALE_STATUS"));
        model.addAttribute("storageTypes", codeManagementService.selectDetailCodeList("PRODUCT_TYPE", "STORAGE_TYPE"));
        model.addAttribute("processTypes", codeManagementService.selectDetailCodeList("PRODUCT_TYPE", "PROCESS_TYPE"));
        model.addAttribute("unitTypes", codeManagementService.selectDetailCodeList("PRODUCT_TYPE", "UNIT_TYPE"));

        // 판매자 목록
        model.addAttribute("sellers", memberService.selectSellerList());
    }

    /**
     * 구성상품 조회 팝업
     */
    @RequestMapping(value = "/admin/product/popup/componentList.do")
    public String componentProductPopup(@ModelAttribute("searchVO") ComponentProductVO searchVO, ModelMap model)
            throws Exception {

        int currentPage = searchVO.getPageIndex() != null ? searchVO.getPageIndex() : 1;
        int recordsPerPage = searchVO.getPageUnit() != null ? searchVO.getPageUnit() : 10;
        int pageSize = searchVO.getPageSize() != null ? searchVO.getPageSize() : 5;

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(currentPage);
        paginationInfo.setRecordCountPerPage(recordsPerPage);
        paginationInfo.setPageSize(pageSize);

        searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
        searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
        searchVO.setPageIndex(currentPage);
        searchVO.setPageUnit(recordsPerPage);
        searchVO.setPageSize(pageSize);

        int totCnt = componentProductService.selectComponentProductListTotCnt(searchVO);
        paginationInfo.setTotalRecordCount(totCnt);

        model.addAttribute("paginationInfo", paginationInfo);
        model.addAttribute("componentList", componentProductService.selectComponentProductList(searchVO));

        addComponentDropdowns(model);

        // 팝업은 레이아웃 정책에 따라 다르므로 기존 리턴 패턴 유지
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/popup/ComponentProductPopup.jsp");
        return "admin/product/popup/ComponentProductPopup";
    }
}
