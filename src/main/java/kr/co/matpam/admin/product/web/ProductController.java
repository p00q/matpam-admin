package kr.co.matpam.admin.product.web;

import java.util.Date;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.matpam.admin.code.service.CodeManagementService;
import kr.co.matpam.admin.member.service.MemberService;
import kr.co.matpam.admin.product.service.ProductService;
import kr.co.matpam.admin.product.service.ProductVO;

/**
 * 판매상품 컨트롤러
 */
@Controller
public class ProductController {

    private static final Logger LOGGER = LoggerFactory.getLogger(ProductController.class);

    @Resource(name = "codeManagementService")
    private CodeManagementService codeManagementService;

    @Resource(name = "memberService")
    private MemberService memberService;

    @Resource(name = "productService")
    private ProductService productService;

    // ① 등록 화면 (GET)
    @RequestMapping(value = "/admin/product/productRegist.do", method = RequestMethod.GET)
    public String productRegistForm(
            @RequestParam(value = "productNo", required = false) Long productNo,
            ModelMap model) throws Exception {

        ProductVO product = productNo != null
                ? productService.selectProduct(productNo)
                : new ProductVO();

        if (product.getDisplayYn() == null) {
            product.setDisplayYn("Y");
            product.setSaleStartDate(new Date());
        }

        model.addAttribute("product", product);
        model.addAttribute("sellers", memberService.selectSellerList());
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/ProductRegister.jsp");
        return "layout/main";
    }

    // ② 저장 처리 (POST)
    @RequestMapping(value = "/admin/product/productRegist.do", method = RequestMethod.POST)
    public String saveProduct(
            @ModelAttribute("product") ProductVO product,
            HttpServletRequest request) throws Exception {

        LOGGER.debug("== saveProduct() 진입 ==");
        LOGGER.debug("상품명: {}", product.getProductName());
        LOGGER.debug("판매가격: {}", product.getSalePrice());
        LOGGER.debug("판매 시작일: {}", product.getSaleStartDate());
        LOGGER.debug("판매 종료일: {}", product.getSaleEndDate());
        LOGGER.debug("판매자ID: {}", product.getSellerId());
        LOGGER.debug("노출여부: {}", product.getDisplayYn());

        if (product.getProductNo() == null) {
            LOGGER.info("신규 상품 등록 시작");
            productService.insertProduct(product);
            LOGGER.info("신규 상품 등록 완료");
        } else {
            LOGGER.info("상품 수정 시작 - productNo: {}", product.getProductNo());
            productService.updateProduct(product);
            LOGGER.info("상품 수정 완료");
        }

        return "redirect:/admin/product/productList.do";
    }

    /**
     * 판매상품 목록 화면
     */
    @RequestMapping(value = "/admin/product/productList.do")
    public String productList(@ModelAttribute("searchVO") ProductVO searchVO, ModelMap model) throws Exception {

        /* Pagination Info settings */
        int currentPage = searchVO.getPageIndex() != null ? searchVO.getPageIndex() : 1;
        int recordsPerPage = searchVO.getPageUnit() != null ? searchVO.getPageUnit() : 10;
        int pageSize = searchVO.getPageSize() != null ? searchVO.getPageSize() : 10;

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

        java.util.List<ProductVO> productList = productService.selectProductList(searchVO);
        model.addAttribute("productList", productList);

        int totCnt = productService.selectProductListTotCnt(searchVO);
        paginationInfo.setTotalRecordCount(totCnt);
        model.addAttribute("paginationInfo", paginationInfo);

        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/ProductList.jsp");

        return "layout/main";
    }
}
