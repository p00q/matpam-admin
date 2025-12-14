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

import kr.co.matpam.admin.code.service.CodeManagementService;
import kr.co.matpam.admin.member.service.MemberService;
import kr.co.matpam.admin.product.service.BundleProductService;
import kr.co.matpam.admin.product.service.BundleProductVO;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 구성상품 전용 컨트롤러
 */
@Controller
public class BundleProductController {

    private static final Logger LOGGER = LoggerFactory.getLogger(BundleProductController.class);

    @Resource(name = "codeManagementService")
    private CodeManagementService codeManagementService;

    @Resource(name = "memberService")
    private MemberService memberService;

    @Resource(name = "bundleProductService")
    private BundleProductService bundleProductService;

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
    @RequestMapping(value = "/admin/product/bundleProductList.do")
    public String bundleProductList(@ModelAttribute("searchVO") BundleProductVO searchVO, ModelMap model)
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

        int totalCount = bundleProductService.selectBundleProductListTotCnt(searchVO);
        paginationInfo.setTotalRecordCount(totalCount);

        model.addAttribute("bundleList", bundleProductService.selectBundleProductList(searchVO));
        model.addAttribute("paginationInfo", paginationInfo);

        addBundleDropdowns(model);

        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/BundleProductList.jsp");

        return "layout/main";
    }

    /**
     * 구성상품 등록 화면
     */
    @RequestMapping(value = "/admin/product/bundleRegist.do")
    public String bundleRegistForm(ModelMap model) throws Exception {

        Date today = new Date();
        Calendar nextYear = Calendar.getInstance();
        nextYear.setTime(today);
        nextYear.add(Calendar.YEAR, 1);

        BundleProductVO bundle = new BundleProductVO();
        bundle.setSaleStartDate(today);
        bundle.setSaleEndDate(nextYear.getTime());

        model.addAttribute("bundle", bundle);
        addBundleDropdowns(model);

        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/BundleProductRegister.jsp");

        return "layout/main";
    }

    /**
     * 구성상품 등록 처리
     */
    @RequestMapping(value = "/admin/product/insertBundleProduct.do", method = RequestMethod.POST)
    public String insertBundleProduct(BundleProductVO bundleProductVO,
            @RequestParam(value = "displayStatus", required = false) String displayStatus,
            @RequestParam(value = "autoVat", required = false) String autoVat) throws Exception {

        LOGGER.debug("Insert Bundle Product (component code): {}", bundleProductVO.getComponentCompCd());
        LOGGER.debug("autoVat flag: {}", autoVat);

        bundleProductVO.setComponentCompCd(bundleProductVO.getComponentCompCd() != null ? bundleProductVO.getComponentCompCd()
                : bundleProductVO.getProductNo());
        bundleProductVO.setAutoVatCalYn(autoVat != null ? "Y" : "N");
        bundleProductVO.setAutoVatYn(bundleProductVO.getAutoVatCalYn());

        bundleProductService.insertBundleProduct(bundleProductVO);

        return "redirect:/admin/product/bundleProductList.do?menu=bundle";
    }

    /**
     * 구성상품 상세/수정 화면
     */
    @RequestMapping(value = "/admin/product/bundleDetail.do")
    public String bundleDetailForm(@RequestParam("productNo") Long productNo, ModelMap model) throws Exception {

        BundleProductVO bundle = bundleProductService.selectBundleProduct(productNo);
        model.addAttribute("bundle", bundle);

        addBundleDropdowns(model);

        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/BundleProductRegister.jsp");

        return "layout/main";
    }

    /**
     * 구성상품 수정 처리
     */
    @RequestMapping(value = "/admin/product/updateBundleProduct.do", method = RequestMethod.POST)
    public String updateBundleProduct(BundleProductVO bundleProductVO,
            @RequestParam(value = "displayStatus", required = false) String displayStatus,
            @RequestParam(value = "autoVat", required = false) String autoVat) throws Exception {

        bundleProductVO.setComponentCompCd(bundleProductVO.getComponentCompCd() != null ? bundleProductVO.getComponentCompCd()
                : bundleProductVO.getProductNo());
        bundleProductVO.setAutoVatCalYn(autoVat != null ? "Y" : "N");
        bundleProductVO.setAutoVatYn(bundleProductVO.getAutoVatCalYn());

        bundleProductService.updateBundleProduct(bundleProductVO);

        return "redirect:/admin/product/bundleProductList.do?menu=bundle";
    }

    /**
     * 구성상품 삭제 처리
     */
    @RequestMapping(value = "/admin/product/deleteBundleProduct.do")
    public String deleteBundleProduct(@RequestParam("productNo") Long productNo) throws Exception {
        bundleProductService.deleteBundleProduct(productNo);
        return "redirect:/admin/product/bundleProductList.do?menu=bundle";
    }

    private void addBundleDropdowns(ModelMap model) throws Exception {
        model.addAttribute("saleTypes", codeManagementService.selectDetailCodeList("007", "007002"));
        model.addAttribute("storageTypes", codeManagementService.selectDetailCodeList("001", "001001"));
        model.addAttribute("processTypes", codeManagementService.selectDetailCodeList("001", "001003"));
        model.addAttribute("unitTypes", codeManagementService.selectDetailCodeList("001", "001004"));
        model.addAttribute("sellers", memberService.selectSellerList());
    }

    /**
     * 구성상품 조회 팝업
     */
    @RequestMapping(value = "/admin/product/popup/bundleList.do")
    public String bundleProductPopup(@ModelAttribute("searchVO") BundleProductVO searchVO, ModelMap model)
            throws Exception {

        /* Pagination Info settings */
        int currentPage = searchVO.getPageIndex() != null ? searchVO.getPageIndex() : 1;
        int recordsPerPage = searchVO.getPageUnit() != null ? searchVO.getPageUnit() : 10;
        int pageSize = searchVO.getPageSize() != null ? searchVO.getPageSize() : 5; // 팝업은 작게

        org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo paginationInfo = new org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo();
        paginationInfo.setCurrentPageNo(currentPage);
        paginationInfo.setRecordCountPerPage(recordsPerPage);
        paginationInfo.setPageSize(pageSize);

        searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
        searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
        searchVO.setPageIndex(currentPage);
        searchVO.setPageUnit(recordsPerPage);
        searchVO.setPageSize(pageSize);

        int totCnt = bundleProductService.selectBundleProductListTotCnt(searchVO);
        paginationInfo.setTotalRecordCount(totCnt);
        model.addAttribute("paginationInfo", paginationInfo);

        model.addAttribute("bundleList", bundleProductService.selectBundleProductList(searchVO));

        addBundleDropdowns(model);

        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/popup/BundleProductPopup.jsp"); // 팝업용 jsp
                                                                                                      // (layout/main을
                                                                                                      // 안탈수도 있음. 보통 팝업은
                                                                                                      // 별도 레이아웃)

        // 팝업은 보통 레이아웃 없이 가거나 팝업용 레이아웃 사용. 여기서는 contentPage 방식이 layout/main을 타게 되므로,
        // layout/popup 을 만들거나 그냥 main 안에서 띄우는 방식인지 확인 필요.
        // 기존 코드 패턴상 layout/main 리턴하고 contentPage를 끼워넣는 방식이므로 일단 따름.
        // 하지만 팝업창은 헤더/푸터가 없어야 하므로 별도 처리 필요.
        // 여기서는 jsp 자체를 리턴하거나 layout/popup을 리턴해야 함.
        // 우선 기존보단 jsp 직접 리턴 시도 (layout/popup이 없으므로)
        // return "admin/product/popup/BundleProductPopup";

        // 하지만 기존 Controller들이 모두 "layout/main"을 리턴하고 있음.
        // 팝업은 "layout/popup" (미존재시 생성 필요) 혹은 그냥 JSP 경로 리턴 (InternalResourceViewResolver
        // 설정에 따라 다름).
        // 안전하게 tiles/layout 없는 jsp 직접 호출 경로가 있다면 그걸 써야함.
        // 일단 layout/simple 또는 layout/popup이 있는지 확인 불가하므로,
        // viewResolver 설정을 모르니 "admin/product/popup/BundleProductPopup" 로 리턴하고
        // WEB-INF/jsp 아래에 배치를 가정.
        return "admin/product/popup/BundleProductPopup";
    }
}
