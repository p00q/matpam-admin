package kr.co.matpam.admin.product.web;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.io.File;
import java.io.IOException;
import java.util.UUID;
import java.util.Base64;
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

import javax.json.bind.Jsonb;
import javax.json.bind.JsonbBuilder;

import kr.co.matpam.admin.code.service.CodeManagementService;
import kr.co.matpam.admin.member.service.MemberService;
import kr.co.matpam.admin.product.service.ProductCompositionVO;
import kr.co.matpam.admin.product.service.ProductService;
import kr.co.matpam.admin.product.service.ProductVO;
import kr.co.matpam.admin.product.service.ProductImageVO;

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
        model.addAttribute("compositionJson", buildCompositionJson(product.getCompositionList()));
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/ProductRegister.jsp");
        return "layout/main";
    }

    private String buildCompositionJson(List<ProductCompositionVO> compositions) {
        try (Jsonb jsonb = JsonbBuilder.create()) {
            return jsonb.toJson(compositions != null ? compositions : Collections.emptyList());
        } catch (Exception e) {
            LOGGER.warn("Failed to serialize composition list", e);
            return "[]";
        }
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
            HttpServletRequest request,
            org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) throws Exception {

        System.out.println("========================================");
        System.out.println("== saveProduct() 진입 ==");
        System.out.println("productNo: " + productNo);
        System.out.println("상품명: " + productName);
        System.out.println("판매가격: " + salePrice);
        System.out.println("원가: " + costPrice);
        System.out.println("부가세: " + vatAmount);
        System.out.println("판매 시작일: " + saleStartDate);
        System.out.println("판매 종료일: " + saleEndDate);
        System.out.println("판매자ID: " + sellerId);
        System.out.println("노출여부: " + displayYn);

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

        // 파일 처리 및 저장
        List<ProductImageVO> imageList = new ArrayList<>();
        if (files != null && !files.isEmpty()) {
            String uploadPath = request.getSession().getServletContext().getRealPath("/images/product/");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            for (int i = 0; i < files.size(); i++) {
                MultipartFile file = files.get(i);
                if (file != null && !file.isEmpty()) {
                    String originalFileName = file.getOriginalFilename();
                    String ext = "";
                    if (originalFileName != null && originalFileName.contains(".")) {
                        ext = originalFileName.substring(originalFileName.lastIndexOf("."));
                    }
                    String savedFileName = UUID.randomUUID().toString() + ext;

                    File dest = new File(uploadPath, savedFileName);
                    file.transferTo(dest);

                    ProductImageVO imageVO = new ProductImageVO();
                    imageVO.setImgUrl("/images/product/" + savedFileName);
                    imageVO.setSortOrder(i + 1);
                    imageVO.setIsMainYn(i == 0 ? "Y" : "N");
                    imageList.add(imageVO);

                    LOGGER.info("파일 저장 완료: {}", dest.getAbsolutePath());
                }
            }
        }

        // ProductVO 수동 생성
        ProductVO product = new ProductVO();
        product.setProductNo(productNo);
        product.setProductName(productName);
        product.setSalePrice(salePrice);
        product.setCostPrice(costPrice);
        product.setVatAmount(vatAmount);

        // 부가세율 설정 (10% 고정 혹은 계산)
        if (vatAmount != null && vatAmount > 0) {
            product.setVatRate(10.0);
        } else {
            product.setVatRate(0.0);
        }

        product.setDisplayYn(displayYn);
        product.setSellerId(sellerId);
        product.setProductSummary(productSummary);
        product.setMdComment(mdComment);
        product.setDescription(description);
        product.setPaymentInfo(paymentInfo);
        product.setShippingInfo(shippingInfo);
        product.setExchangeReturnInfo(exchangeReturnInfo);
        product.setRefundInfo(refundInfo);
        product.setImageList(imageList); // 이미지 목록 설정

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
                    comp.setCompQty(1);
                    comp.setSortOrder(index + 1);
                    compositionList.add(comp);
                    LOGGER.info("구성상품[{}] bundleId: {}", index, bundleId);
                }
            } catch (NumberFormatException e) {
                LOGGER.warn("Invalid bundleId format: {}", bundleIdStr);
            }

            index++;
        }

        System.out.println("총 구성상품 개수: " + compositionList.size());
        System.out.println("========================================");

        LOGGER.info("총 구성상품 개수: {}", compositionList.size());
        product.setCompositionList(compositionList);

        try {
            if (product.getProductNo() == null) {
                LOGGER.info("신규 상품 등록 시작");
                productService.insertProduct(product);
                LOGGER.info("신규 상품 등록 완료");
                redirectAttributes.addFlashAttribute("message", "상품이 정상적으로 등록되었습니다.");
            } else {
                LOGGER.info("상품 수정 시작 - productNo: {}", product.getProductNo());
                productService.updateProduct(product);
                LOGGER.info("상품 수정 완료");
                redirectAttributes.addFlashAttribute("message", "상품이 정상적으로 수정되었습니다.");
            }
        } catch (Exception e) {
            LOGGER.error("상품 저장 중 오류 발생", e);
            redirectAttributes.addFlashAttribute("errorMessage", "상품 저장 중 오류가 발생했습니다: " + e.getMessage());
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

    /**
     * 상품 미리보기 (POPUP)
     */
    @RequestMapping(value = "/admin/product/preview.do", method = RequestMethod.POST)
    public String previewProduct(
            @ModelAttribute("product") ProductVO product,
            @RequestParam(value = "files", required = false) List<MultipartFile> files,
            ModelMap model,
            HttpServletRequest request) throws Exception {

        // 이미지 미리보기 처리 (Base64)
        List<ProductImageVO> imageList = new ArrayList<>();
        if (files != null && !files.isEmpty()) {
            for (int i = 0; i < files.size(); i++) {
                MultipartFile file = files.get(i);
                if (file != null && !file.isEmpty()) {
                    byte[] bytes = file.getBytes();
                    String base64 = Base64.getEncoder().encodeToString(bytes);
                    String mimeType = file.getContentType();

                    ProductImageVO imageVO = new ProductImageVO();
                    imageVO.setImgUrl("data:" + mimeType + ";base64," + base64);
                    imageVO.setSortOrder(i + 1);
                    imageVO.setIsMainYn(i == 0 ? "Y" : "N");
                    imageList.add(imageVO);
                }
            }
        }
        product.setImageList(imageList);

        // 날짜 바인딩 보완 (ModelAttribtue가 자동으로 못 잡을 경우를 대비)
        String saleStartDate = request.getParameter("saleStartDate");
        if (saleStartDate != null)
            product.setSaleStartDate(saleStartDate);

        String saleEndDate = request.getParameter("saleEndDate");
        if (saleEndDate != null)
            product.setSaleEndDate(saleEndDate);

        model.addAttribute("product", product);

        return "admin/product/popup/ProductPreview";
    }
}
