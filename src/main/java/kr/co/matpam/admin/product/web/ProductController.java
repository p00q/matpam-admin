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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.matpam.admin.code.service.CodeManagementService;
import kr.co.matpam.admin.member.service.MemberService;
import kr.co.matpam.admin.product.service.BundleProductService;
import kr.co.matpam.admin.product.service.BundleProductVO;

@Controller
public class ProductController {

    private static final Logger LOGGER = LoggerFactory.getLogger(ProductController.class);

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
    public String bundleProductList(ModelMap model) throws Exception {

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

        LOGGER.debug("Insert Bundle Product: {}", bundleProductVO.getProductName());
        LOGGER.debug("sellerId: {}", bundleProductVO.getSellerId());
        LOGGER.debug("displayStatus: {}, autoVat: {}", displayStatus, autoVat);

        // === 체크박스 처리 ===
        // 노출상태: 체크 시 'Y', 미체크 시 'N'
        bundleProductVO.setDisplayYn("Y".equals(displayStatus) ? "Y" : "N");

        // 부가세 자동계산: 체크 시 'Y', 미체크 시 'N'
        bundleProductVO.setAutoVatYn(autoVat != null ? "Y" : "N");

        // === 기본값 처리 ===
        // 원가가 null이면 0으로 설정
        if (bundleProductVO.getCostPrice() == null) {
            bundleProductVO.setCostPrice(0);
        }

        // 부가세가 null이면 0으로 설정
        if (bundleProductVO.getVatAmount() == null) {
            bundleProductVO.setVatAmount(0);
        }

        // 판매가격이 null이거나 0이면 원가 + 부가세로 계산
        if (bundleProductVO.getSalePrice() == null || bundleProductVO.getSalePrice() == 0) {
            bundleProductVO.setSalePrice(bundleProductVO.getCostPrice() + bundleProductVO.getVatAmount());
        }

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

        // 체크박스 처리
        bundleProductVO.setDisplayYn("Y".equals(displayStatus) ? "Y" : "N");
        bundleProductVO.setAutoVatYn(autoVat != null ? "Y" : "N");

        // 기본값 처리
        if (bundleProductVO.getCostPrice() == null) {
            bundleProductVO.setCostPrice(0);
        }
        if (bundleProductVO.getVatAmount() == null) {
            bundleProductVO.setVatAmount(0);
        }
        if (bundleProductVO.getSalePrice() == null || bundleProductVO.getSalePrice() == 0) {
            bundleProductVO.setSalePrice(bundleProductVO.getCostPrice() + bundleProductVO.getVatAmount());
        }

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
        model.addAttribute("divisionTypes", codeManagementService.selectDetailCodeList("001", "001002"));
        model.addAttribute("processTypes", codeManagementService.selectDetailCodeList("001", "001003"));
        model.addAttribute("unitTypes", codeManagementService.selectDetailCodeList("001", "001004"));
        model.addAttribute("saleStatuses", codeManagementService.selectDetailCodeList("007", "007001"));
        model.addAttribute("sellers", memberService.selectSellerList());
    }
}
