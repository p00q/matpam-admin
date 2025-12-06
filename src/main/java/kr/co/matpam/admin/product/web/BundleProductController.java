package kr.co.matpam.admin.product.web;

import java.util.Collections;

import javax.annotation.Resource;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.co.matpam.admin.code.service.CodeManagementService;
import kr.co.matpam.admin.member.service.MemberService;
import kr.co.matpam.admin.product.service.BundleProductVO;

@Controller
public class BundleProductController {

    @Resource(name = "codeManagementService")
    private CodeManagementService codeManagementService;

    @Resource(name = "memberService")
    private MemberService memberService;

    @RequestMapping(value = "/admin/product/bundleList.do")
    public String bundleList(ModelMap model) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(1);
        paginationInfo.setRecordCountPerPage(20);
        paginationInfo.setPageSize(10);
        paginationInfo.setTotalRecordCount(0);

        model.addAttribute("bundleList", Collections.emptyList());
        model.addAttribute("paginationInfo", paginationInfo);
        setCodeLists(model);
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/BundleProductList.jsp");
        model.addAttribute("menu", "config");
        return "layout/main";
    }

    @RequestMapping(value = "/admin/product/bundleRegist.do", method = RequestMethod.GET)
    public String bundleRegisterForm(ModelMap model) throws Exception {
        model.addAttribute("bundle", new BundleProductVO());
        setCodeLists(model);
        model.addAttribute("mode", "insert");
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/BundleProductRegister.jsp");
        model.addAttribute("menu", "config");
        return "layout/main";
    }

    @RequestMapping(value = "/admin/product/bundleRegist.do", method = RequestMethod.POST)
    public String saveBundle(@ModelAttribute("bundle") BundleProductVO bundle,
            RedirectAttributes redirectAttributes) throws Exception {
        redirectAttributes.addFlashAttribute("message", "구성상품이 임시로 저장되었습니다.");
        return "redirect:/admin/product/bundleList.do?menu=config";
    }

    @RequestMapping(value = "/admin/product/bundleView.do")
    public String bundleView(@RequestParam("bundleId") Long bundleId, ModelMap model) throws Exception {
        BundleProductVO bundle = new BundleProductVO();
        bundle.setBundleId(bundleId);
        model.addAttribute("bundle", bundle);
        setCodeLists(model);
        model.addAttribute("mode", "view");
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/BundleProductRegister.jsp");
        model.addAttribute("menu", "config");
        return "layout/main";
    }

    private void setCodeLists(ModelMap model) throws Exception {
        model.addAttribute("saleTypes", codeManagementService.selectDetailCodeList("007", "007002"));
        model.addAttribute("storageTypes", codeManagementService.selectDetailCodeList("001", "001001"));
        model.addAttribute("divisionTypes", codeManagementService.selectDetailCodeList("001", "001002"));
        model.addAttribute("processTypes", codeManagementService.selectDetailCodeList("001", "001003"));
        model.addAttribute("unitTypes", codeManagementService.selectDetailCodeList("001", "001004"));
        model.addAttribute("saleStatuses", codeManagementService.selectDetailCodeList("007", "007001"));
        model.addAttribute("sellers", memberService.selectSellerList());
    }
}
