package kr.co.matpam.admin.product.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.matpam.admin.product.service.ProductService;
import kr.co.matpam.admin.product.service.ProductVO;
import kr.co.matpam.admin.product.service.ProductCompositionVO;

@Service("productService")
public class ProductServiceImpl extends EgovAbstractServiceImpl implements ProductService {

    private static final Logger LOGGER = LoggerFactory.getLogger(ProductServiceImpl.class);

    @Resource(name = "productDAO")
    private ProductDAO productDAO;

    @Override
    public List<ProductVO> selectProductList(ProductVO vo) throws Exception {
        return productDAO.selectProductList(vo);
    }

    @Override
    public int selectProductListTotCnt(ProductVO vo) throws Exception {
        return productDAO.selectProductListTotCnt(vo);
    }

    @Override
    public ProductVO selectProduct(Long productNo) throws Exception {
        return productDAO.selectProduct(productNo);
    }

    @Override
    @Transactional
    public void insertProduct(ProductVO vo) throws Exception {
        LOGGER.info("[Service] insertProduct 시작 - productName: {}", vo.getProductName());
        
        // 1. 상품 등록 (productNo가 자동 생성됨)
        productDAO.insertProduct(vo);
        LOGGER.info("[Service] 상품 등록 완료 - productNo: {}", vo.getProductNo());
        
        // 2. 구성상품 목록 저장
        if (vo.getCompositionList() != null && !vo.getCompositionList().isEmpty()) {
            LOGGER.info("[Service] 구성상품 {} 개 저장 시작", vo.getCompositionList().size());
            for (ProductCompositionVO comp : vo.getCompositionList()) {
                comp.setProductNo(vo.getProductNo().longValue());
                productDAO.insertProductComposition(comp);
            }
            LOGGER.info("[Service] 구성상품 저장 완료");
        } else {
            LOGGER.info("[Service] 구성상품 목록 없음");
        }
    }

    @Override
    @Transactional
    public void updateProduct(ProductVO vo) throws Exception {
        LOGGER.info("[Service] updateProduct 시작 - productNo: {}", vo.getProductNo());
        
        // 1. 상품 기본정보 수정
        productDAO.updateProduct(vo);
        LOGGER.info("[Service] 상품 기본정보 수정 완료");
        
        // 2. 기존 구성상품 삭제
        LOGGER.info("[Service] 기존 구성상품 삭제 시작");
        productDAO.deleteProductCompositionsByProductNo(vo.getProductNo().longValue());
        LOGGER.info("[Service] 기존 구성상품 삭제 완료");
        
        // 3. 새로운 구성상품 저장
        if (vo.getCompositionList() != null && !vo.getCompositionList().isEmpty()) {
            LOGGER.info("[Service] 새로운 구성상품 {} 개 저장 시작", vo.getCompositionList().size());
            for (ProductCompositionVO comp : vo.getCompositionList()) {
                comp.setProductNo(vo.getProductNo().longValue());
                productDAO.insertProductComposition(comp);
            }
            LOGGER.info("[Service] 새로운 구성상품 저장 완료");
        } else {
            LOGGER.info("[Service] 구성상품 목록 없음");
        }
    }
}
