package kr.co.matpam.admin.product.web;

import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import javax.servlet.http.HttpServletRequest;
import kr.co.matpam.admin.common.service.LoginVO;
import kr.co.matpam.admin.product.service.ProductService;
import kr.co.matpam.admin.product.service.ProductVO;
import kr.co.matpam.admin.product.service.ProductPriceVO;

/**
 * 통합 상품 관리 컨트롤러
 */
@Controller
public class ProductController {

    @Resource(name = "productService")
    private ProductService productService;

    /**
     * 상품 목록 조회
     */
    @RequestMapping("/admin/product/productList.do")
    public String productList(@ModelAttribute("searchVO") ProductVO searchVO, ModelMap model) throws Exception {
        
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
        paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
        paginationInfo.setPageSize(searchVO.getPageSize());

        searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
        searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        List<ProductVO> list = productService.selectProductList(searchVO);
        model.addAttribute("resultList", list);

        int totCnt = productService.selectProductListTotCnt(searchVO);
        paginationInfo.setTotalRecordCount(totCnt);
        model.addAttribute("paginationInfo", paginationInfo);

        model.addAttribute("currentMenu", "product");
        model.addAttribute("pageTitle", "상품 마스터 관리");
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/ProductList.jsp");
        return "layout/main";
    }

    /**
     * 상품 등록/수정 폼
     */
    @RequestMapping("/admin/product/productForm.do")
    public String productForm(@RequestParam(value = "productId", required = false) Long productId, 
                               HttpServletRequest request,
                               ModelMap model) throws Exception {
        
        ProductVO product;
        if (productId == null) {
            product = new ProductVO();
            LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
            if (loginVO != null && !"SUPER_ADMIN".equals(loginVO.getMemberType())) {
                product.setTenantId(loginVO.getCompanyId());
            } else {
                product.setTenantId(1L); // 기본 테넌트
            }
            product.setIndependentSaleYn("Y");
            product.setStockManagedYn("Y");
            product.setSaleStatus("ON_SALE");
        } else {
            product = productService.selectProductDetail(productId);
            // 가격 정책 목록 추가 조회
            List<ProductPriceVO> priceList = productService.selectProductPriceList(productId);
            model.addAttribute("priceList", priceList);
        }
        
        model.addAttribute("product", product);
        model.addAttribute("currentMenu", "product");
        model.addAttribute("pageTitle", "상품 상세 정보");
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/product/ProductForm.jsp");
        return "layout/main";
    }

    /**
     * 상품 정보 저장
     */
    @RequestMapping("/admin/product/saveProduct.do")
    public String saveProduct(@ModelAttribute("product") ProductVO product) throws Exception {
        if (product.getProductId() == null) {
            productService.insertProduct(product);
        } else {
            productService.updateProduct(product);
        }
        return "redirect:/admin/product/productList.do";
    }
}
