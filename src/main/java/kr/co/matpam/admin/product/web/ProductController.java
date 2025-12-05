package kr.co.matpam.admin.product.web;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.matpam.admin.code.service.CodeManagementService;

@Controller
public class ProductController {

    @Resource(name = "codeManagementService")
    private CodeManagementService codeManagementService;

    @RequestMapping(value = "/admin/product/bundleProductList.do")
    public String bundleProductList(ModelMap model) throws Exception {

        // 검색 필터용 코드 조회 (TB_DETAIL_CODE에서 가져옴)
        // 판매유형 (원물/가공 등)
        model.addAttribute("saleTypes", codeManagementService.selectDetailCodeList("007", "007002"));
        // 저장유형 (냉장/냉동)
        model.addAttribute("storageTypes", codeManagementService.selectDetailCodeList("001", "001001"));
        // 분리유형
        model.addAttribute("divisionTypes", codeManagementService.selectDetailCodeList("001", "001002"));
        // 처리유형
        model.addAttribute("processTypes", codeManagementService.selectDetailCodeList("001", "001003"));
        // 판매상태 (판매중/판매중지)
        model.addAttribute("saleStatuses", codeManagementService.selectDetailCodeList("007", "007001"));

        // Set content page for layout
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/BundleProductList.jsp");

        return "layout/main";
    }
}
