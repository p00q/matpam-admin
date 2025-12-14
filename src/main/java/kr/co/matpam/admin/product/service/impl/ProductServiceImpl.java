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

        // 0. 등록자 ID 설정
        vo.setRegId(vo.getRegId() != null ? vo.getRegId() : "SYSTEM");

        // 1. 상품 마스터 등록
        productDAO.insertProduct(vo); // vo.productNo 생성됨 (Long)
        LOGGER.info("[Service] 상품 마스터 등록 완료 - productNo: {}", vo.getProductNo());

        // 2. 상품 상세 등록 (description, paymentInfo, etc)
        vo.setRegId(vo.getRegId() != null ? vo.getRegId() : "SYSTEM");
        productDAO.insertProductDetail(vo);
        LOGGER.info("[Service] 상품 상세 등록 완료");

        // 3. 구성상품 등록 (compositionList)
        if (vo.getCompositionList() != null && !vo.getCompositionList().isEmpty()) {
            LOGGER.info("[Service] 구성상품 {} 개 저장 시작", vo.getCompositionList().size());
            for (ProductCompositionVO comp : vo.getCompositionList()) {
                comp.setProductNo(vo.getProductNo()); // Long -> Long
                productDAO.insertProductComposition(comp);
            }
            LOGGER.info("[Service] 구성상품 저장 완료");
        } else {
            LOGGER.info("[Service] 구성상품 목록 없음");
        }

        // 4. 상품 이미지 저장
        if (vo.getImageList() != null && !vo.getImageList().isEmpty()) {
            LOGGER.info("[Service] 상품 이미지 {} 개 저장 시작", vo.getImageList().size());
            for (kr.co.matpam.admin.product.service.ProductImageVO img : vo.getImageList()) {
                img.setSalesProdId(vo.getProductNo());
                img.setRegId(vo.getRegId() != null ? vo.getRegId() : "SYSTEM");
                productDAO.insertProductImage(img);
            }
            LOGGER.info("[Service] 상품 이미지 저장 완료");
        }
    }

    @Override
    @Transactional
    public void updateProduct(ProductVO vo) throws Exception {
        LOGGER.info("[Service] updateProduct 시작 - productNo: {}", vo.getProductNo());

        // 1. 상품 마스터 수정
        productDAO.updateProduct(vo);

        // 2. 상품 상세 수정
        productDAO.updateProductDetail(vo);
        LOGGER.info("[Service] 상품 마스터/상세 수정 완료");

        // 3. 기존 구성상품 삭제
        productDAO.deleteProductCompositionsByProductNo(vo.getProductNo());

        // 4. 새로운 구성상품 저장
        if (vo.getCompositionList() != null && !vo.getCompositionList().isEmpty()) {
            LOGGER.info("[Service] 새로운 구성상품 {} 개 저장 시작", vo.getCompositionList().size());
            for (ProductCompositionVO comp : vo.getCompositionList()) {
                comp.setProductNo(vo.getProductNo());
                productDAO.insertProductComposition(comp);
            }
            LOGGER.info("[Service] 새로운 구성상품 저장 완료");
        }
    }
}
