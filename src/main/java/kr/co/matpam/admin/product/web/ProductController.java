package kr.co.matpam.admin.product.web;

import java.util.ArrayList;
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
import kr.co.matpam.admin.product.service.ProductCompositionVO;
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

        // 구성상품 로깅
        if (productNo != null) {
            LOGGER.info("상품 조회 - productNo: {}", productNo);
            if (product.getCompositionList() != null) {
                LOGGER.info("구성상품 개수: {}", product.getCompositionList().size());
                for (int i = 0; i < product.getCompositionList().size(); i++) {
                    LOGGER.info("구성상품[{}]: bundleId={}, productName={}", 
                        i, 
                        product.getCompositionList().get(i).getBundleId(),
                        product.getCompositionList().get(i).getProductName());
                }
            } else {
                LOGGER.warn("구성상품 목록이 null입니다");
            }
        }

        model.addAttribute("product", product);
        model.addAttribute("sellers", memberService.selectSellerList());
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/ProductRegister.jsp");
        return "layout/main";
    }

    // ② 저장 처리 (POST)
    @RequestMapping(value = "/admin/product/productRegist.do", method = RequestMethod.POST)
    public String saveProduct(
            @RequestParam(value = "productNo", required = false) Integer productNo,
            @RequestParam(value = "productName", required = false) String productName,
            @RequestParam(value = "salePrice", required = false) Integer salePrice,
            @RequestParam(value = "costPrice", required = false) Integer costPrice,
            @RequestParam(value = "vatAmount", required = false) Integer vatAmount,
            @RequestParam(value = "saleStartDate", required = false) String saleStartDate,
            @RequestParam(value = "saleEndDate", required = false) String saleEndDate,
            @RequestParam(value = "displayYn", required = false) String displayYn,
            @RequestParam(value = "sellerId", required = false) Long sellerId,
            @RequestParam(value = "productSummary", required = false) String productSummary,
            @RequestParam(value = "mdComment", required = false) String mdComment,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "paymentInfo", required = false) String paymentInfo,
            @RequestParam(value = "shippingInfo", required = false) String shippingInfo,
            @RequestParam(value = "exchangeReturnInfo", required = false) String exchangeReturnInfo,
            @RequestParam(value = "refundInfo", required = false) String refundInfo,
            @RequestParam(value = "files", required = false) List<MultipartFile> files,
            HttpServletRequest request) throws Exception {

        LOGGER.info("== saveProduct() 진입 ==");
        LOGGER.info("productNo: {}", productNo);
        LOGGER.info("상품명: {}", productName);
        LOGGER.info("판매가격: {}", salePrice);
        LOGGER.info("원가: {}", costPrice);
        LOGGER.info("부가세: {}", vatAmount);
        LOGGER.info("판매 시작일: {}", saleStartDate);
        LOGGER.info("판매 종료일: {}", saleEndDate);
        LOGGER.info("판매자ID: {}", sellerId);
        LOGGER.info("노출여부: {}", displayYn);
        
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

        // ProductVO 수동 생성
        ProductVO product = new ProductVO();
        product.setProductNo(productNo);
        product.setProductName(productName);
        product.setSalePrice(salePrice);
        product.setCostPrice(costPrice);
        product.setVatAmount(vatAmount);
        product.setDisplayYn(displayYn);
        product.setSellerId(sellerId);
        product.setProductSummary(productSummary);
        product.setMdComment(mdComment);
        product.setDescription(description);
        product.setPaymentInfo(paymentInfo);
        product.setShippingInfo(shippingInfo);
        product.setExchangeReturnInfo(exchangeReturnInfo);
        product.setRefundInfo(refundInfo);
        
        // 날짜 파싱
        if (saleStartDate != null && !saleStartDate.trim().isEmpty()) {
            product.setSaleStartDate(saleStartDate);
        }
        if (saleEndDate != null && !saleEndDate.trim().isEmpty()) {
            product.setSaleEndDate(saleEndDate);
        }

        // 구성상품 목록 설정 - request에서 직접 파라미터 추출
        List<ProductCompositionVO> compositionList = new ArrayList<>();
        int index = 0;
        while (true) {
            String paramName = "compositionList[" + index + "].bundleId";
            String bundleIdStr = request.getParameter(paramName);
            
            if (bundleIdStr == null || bundleIdStr.trim().isEmpty()) {
                break; // 더 이상 파라미터가 없으면 종료
            }
            
            try {
                Long bundleId = Long.parseLong(bundleIdStr);
                if (bundleId > 0) {
                    ProductCompositionVO comp = new ProductCompositionVO();
                    comp.setBundleId(bundleId);
                    comp.setSortOrder(index + 1);
                    compositionList.add(comp);
                    LOGGER.info("구성상품[{}] bundleId: {}", index, bundleId);
                }
            } catch (NumberFormatException e) {
                LOGGER.warn("Invalid bundleId format: {}", bundleIdStr);
            }
            
            index++;
        }
        
        LOGGER.info("총 구성상품 개수: {}", compositionList.size());
        product.setCompositionList(compositionList);

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
