package kr.co.matpam.admin.product.web;

import java.util.Date;
import java.util.List;
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
import org.springframework.web.multipart.MultipartFile;

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
            ProductVO product,
            @RequestParam(value = "files", required = false) List<MultipartFile> files,
            HttpServletRequest request) throws Exception {

        LOGGER.info("== saveProduct() 진입 ==");
        LOGGER.info("상품명: {}", product.getProductName());
        LOGGER.info("판매가격: {}", product.getSalePrice());
        LOGGER.info("원가: {}", product.getCostPrice());
        LOGGER.info("부가세: {}", product.getVatAmount());
        LOGGER.info("판매 시작일: {}", product.getSaleStartDate());
        LOGGER.info("판매 종료일: {}", product.getSaleEndDate());
        LOGGER.info("판매자ID: {}", product.getSellerId());
        LOGGER.info("노출여부: {}", product.getDisplayYn());
        
        // 파일 로깅
        if (files != null && !files.isEmpty()) {
            LOGGER.info("업로드된 파일 개수: {}", files.size());
            for (int i = 0; i < files.size(); i++) {
                MultipartFile file = files.get(i);
                if (file != null && !file.isEmpty()) {
                    LOGGER.info("파일[{}]: {}, size: {}", i, file.getOriginalFilename(), file.getSize());
                }
            }
        } else {
            LOGGER.info("업로드된 파일 없음");
        }
        
        // compositionList 로깅
        if (product.getCompositionList() != null) {
            LOGGER.info("구성상품 개수: {}", product.getCompositionList().size());
            for (int i = 0; i < product.getCompositionList().size(); i++) {
                LOGGER.info("구성상품[{}] bundleId: {}", i, product.getCompositionList().get(i).getBundleId());
            }
        } else {
            LOGGER.info("구성상품 목록: null");
        }

        try {
            if (product.getProductNo() == null) {
                LOGGER.info("신규 상품 등록 시작");
                productService.insertProduct(product);
                LOGGER.info("신규 상품 등록 완료");
            } else {
                LOGGER.info("상품 수정 시작 - productNo: {}", product.getProductNo());
                productService.updateProduct(product);
                LOGGER.info("상품 수정 완료");
            }
        } catch (Exception e) {
            LOGGER.error("상품 저장 중 오류 발생", e);
            throw e;
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
