package kr.co.matpam.admin.product.web;

import java.io.File;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

import javax.annotation.Resource;
import javax.json.bind.Jsonb;
import javax.json.bind.JsonbBuilder;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.co.matpam.admin.code.service.CodeManagementService;
import kr.co.matpam.admin.member.service.MemberService;
import kr.co.matpam.admin.product.service.SalesProductCompositionVO;
import kr.co.matpam.admin.product.service.SalesProductService;
import kr.co.matpam.admin.product.service.SalesProductVO;
import kr.co.matpam.admin.product.service.SalesProductImageVO;

/**
 * 판매상품 컨트롤러 (tb_sales_product)
 * - 구성상품 매핑(tb_sales_product_comp)은 compositionList로만 저장 처리
 * - componentList(List<?>)는 화면/임시용으로 두더라도 Service로는 절대 전달하지 않음
 */
@Controller
public class SalesProductController {

    private static final Logger LOGGER = LoggerFactory.getLogger(SalesProductController.class);

    @Resource(name = "codeManagementService")
    private CodeManagementService codeManagementService;

    @Resource(name = "memberService")
    private MemberService memberService;

    @Resource(name = "salesProductService")
    private SalesProductService salesProductService;

    /**
     * 판매상품 등록/수정 화면 (GET)
     */
    @RequestMapping(value = "/admin/product/salesProductRegister.do", method = RequestMethod.GET)
    public String salesProductRegister(@RequestParam(value = "salesProdId", required = false) Long salesProdId,
            ModelMap model) throws Exception {

        if (salesProdId != null) {
            salesProductService.increaseViewCount(salesProdId);
        }

        SalesProductVO salesProduct = (salesProdId != null)
                ? salesProductService.selectSalesProduct(salesProdId)
                : new SalesProductVO();

        // 기본값
        if (salesProduct.getExposureStatusCd() == null || salesProduct.getExposureStatusCd().trim().isEmpty()) {
            salesProduct.setExposureStatusCd("Y");
        }
        if (salesProduct.getSaleStatusCd() == null || salesProduct.getSaleStatusCd().trim().isEmpty()) {
            salesProduct.setSaleStatusCd("LIVE");
        }

        // 구성 JSON (화면 로딩용)
        model.addAttribute("salesProduct", salesProduct);
        model.addAttribute("sellers", memberService.selectSellerList());
        model.addAttribute("saleStatuses", codeManagementService.selectDetailCodeList("SALE_STATUS", "SALE_STATUS"));
        model.addAttribute("compositionJson", buildCompositionJson(salesProduct.getCompositionList()));

        // 화면 경로
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/SalesProductRegister.jsp");
        return "layout/main";
    }

    private String buildCompositionJson(List<SalesProductCompositionVO> compositions) {
        try (Jsonb jsonb = JsonbBuilder.create()) {
            return jsonb.toJson(compositions != null ? compositions : Collections.emptyList());
        } catch (Exception e) {
            LOGGER.warn("Failed to serialize composition list", e);
            return "[]";
        }
    }

    /**
     * 판매상품 저장 (POST)
     * - SalesProductRegister.jsp에서 구성상품은 hidden input으로:
     * compositionList[0].componentProdId, compositionList[1].componentProdId ...
     */
    @RequestMapping(value = "/admin/product/salesProductRegister.do", method = RequestMethod.POST)
    public String saveSalesProduct(
            @ModelAttribute("salesProduct") SalesProductVO salesProduct,
            @RequestParam(value = "files", required = false) List<MultipartFile> files,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) throws Exception {

        // 1) 자동 데이터 세팅 (인터셉터에서 주입된 값 활용)
        String opType = (String) request.getAttribute("opType");
        String loginId = (String) request.getAttribute("loginId");
        salesProduct.setOpType(opType);
        salesProduct.setRegId(loginId);
        salesProduct.setModId(loginId);

        if (salesProduct.getSaleStatusCd() == null || salesProduct.getSaleStatusCd().trim().isEmpty()) {
            salesProduct.setSaleStatusCd("LIVE");
        }

        // 1) 이미지 처리 (기존 SalesProductImageVO 재사용 - 프로젝트에 맞게 클래스명 변경 가능)
        List<SalesProductImageVO> imageList = new ArrayList<>();
        if (files != null && !files.isEmpty()) {
            String uploadPath = request.getSession().getServletContext().getRealPath("/images/product/");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            for (int i = 0; i < files.size(); i++) {
                MultipartFile file = files.get(i);
                if (file == null || file.isEmpty())
                    continue;

                String originalFileName = file.getOriginalFilename();
                String ext = "";
                if (originalFileName != null && originalFileName.contains(".")) {
                    ext = originalFileName.substring(originalFileName.lastIndexOf("."));
                }

                String savedFileName = UUID.randomUUID().toString() + ext;
                File dest = new File(uploadPath, savedFileName);
                file.transferTo(dest);

                SalesProductImageVO imageVO = new SalesProductImageVO();
                imageVO.setImgUrl("/images/product/" + savedFileName);
                imageVO.setSortOrder(i + 1);
                imageVO.setIsMainYn(i == 0 ? "Y" : "N");
                imageList.add(imageVO);

                LOGGER.info("파일 저장 완료: {}", dest.getAbsolutePath());
            }
        }

        // 3) 구성상품 목록 추출
        List<SalesProductCompositionVO> compositionList = extractCompositionList(request);
        salesProduct.setCompositionList(compositionList);

        // 4) 이미지 목록 설정
        salesProduct.setImageList(imageList);

        LOGGER.info("저장 요청 - salesProdId={}, name={}, opType={}, compositions={}",
                salesProduct.getSalesProdId(), salesProduct.getSalesProdName(), salesProduct.getOpType(),
                (compositionList != null ? compositionList.size() : 0));

        // 5) 저장/수정
        try {
            if (salesProduct.getSalesProdId() == null) {
                salesProductService.insertSalesProduct(salesProduct);
                redirectAttributes.addFlashAttribute("message", "판매상품이 정상적으로 등록되었습니다.");
            } else {
                salesProductService.updateSalesProduct(salesProduct);
                redirectAttributes.addFlashAttribute("message", "판매상품이 정상적으로 수정되었습니다.");
            }
        } catch (Exception e) {
            LOGGER.error("판매상품 저장 중 오류 발생", e);
            redirectAttributes.addFlashAttribute("errorMessage", "판매상품 저장 중 오류: " + e.getMessage());
            throw e;
        }

        return "redirect:/admin/product/salesProductList.do";
    }

    /**
     * 판매상품 목록 화면
     */
    @RequestMapping(value = "/admin/product/salesProductList.do")
    public String salesProductList(@ModelAttribute("searchVO") SalesProductVO searchVO, 
            HttpServletRequest request, ModelMap model) throws Exception {

        // 1) 자동 데이터 격리 (인터셉터에서 주입된 opType 사용)
        String opType = (String) request.getAttribute("opType");
        searchVO.setOpType(opType);

        // 2) 페이징 설정
        int recordsPerPage = (searchVO.getPageUnit() != null) ? searchVO.getPageUnit() : 10;
        org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo paginationInfo = new org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo();
        paginationInfo.setCurrentPageNo(searchVO.getPageIndex() != null ? searchVO.getPageIndex() : 1);
        paginationInfo.setRecordCountPerPage(recordsPerPage);
        paginationInfo.setPageSize(10);

        searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        // 3) 조회
        List<SalesProductVO> list = salesProductService.selectSalesProductList(searchVO);
        int totCnt = salesProductService.selectSalesProductListTotCnt(searchVO);
        paginationInfo.setTotalRecordCount(totCnt);

        model.addAttribute("salesProductList", list);
        model.addAttribute("paginationInfo", paginationInfo);
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/SalesProductList.jsp");
        return "layout/main";
    }

    /**
     * 상품 미리보기 (POPUP) - 파일 업로드를 Base64로 보여주는 기존 방식 유지
     */
    @RequestMapping(value = "/admin/product/preview.do", method = RequestMethod.POST)
    public String previewSalesProduct(
            @ModelAttribute("salesProduct") SalesProductVO salesProduct,
            @RequestParam(value = "files", required = false) List<MultipartFile> files,
            ModelMap model) throws Exception {

        List<SalesProductImageVO> imageList = new ArrayList<>();
        if (files != null && !files.isEmpty()) {
            for (int i = 0; i < files.size(); i++) {
                MultipartFile file = files.get(i);
                if (file == null || file.isEmpty())
                    continue;

                byte[] bytes = file.getBytes();
                String base64 = Base64.getEncoder().encodeToString(bytes);
                String mimeType = file.getContentType();

                SalesProductImageVO imageVO = new SalesProductImageVO();
                imageVO.setImgUrl("data:" + mimeType + ";base64," + base64);
                imageVO.setSortOrder(i + 1);
                imageVO.setIsMainYn(i == 0 ? "Y" : "N");
                imageList.add(imageVO);
            }
        }
        salesProduct.setImageList(imageList);

        model.addAttribute("salesProduct", salesProduct);
        return "admin/product/popup/SalesProductPreview";
    }


    /**
     * SalesProductRegister.jsp는 구성상품을 hidden input으로 componentProdId만 보내도록 되어 있음
     * - compQty는 DB 기본값 1.000으로 가도 되지만, 서비스/업서트 기준으로 명시 세팅
     * - sortOrder는 화면 표시 순서대로 1..N
     */
    private List<SalesProductCompositionVO> extractCompositionList(HttpServletRequest request) {
        List<SalesProductCompositionVO> list = new ArrayList<>();

        int index = 0;
        while (true) {
            String idParam = request.getParameter("compositionList[" + index + "].componentProdId");
            if (idParam == null || idParam.trim().isEmpty()) {
                break;
            }

            try {
                Long componentProdId = Long.parseLong(idParam.trim());
                if (componentProdId > 0) {
                    SalesProductCompositionVO comp = new SalesProductCompositionVO();
                    comp.setComponentProdId(componentProdId);
                    comp.setCompQty(new BigDecimal("1.000"));
                    comp.setSortOrder(index + 1);
                    list.add(comp);
                }
            } catch (NumberFormatException e) {
                LOGGER.warn("Invalid componentProdId: {}", idParam);
            }

            index++;
        }

        return list;
    }
}
