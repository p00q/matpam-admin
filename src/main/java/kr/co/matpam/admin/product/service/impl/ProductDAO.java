package kr.co.matpam.admin.product.service.impl;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import kr.co.matpam.admin.product.service.ProductVO;
import kr.co.matpam.admin.product.service.ProductCompositionVO;

@Repository("productDAO")
public class ProductDAO extends EgovAbstractMapper {

    private static final Logger LOGGER = LoggerFactory.getLogger(ProductDAO.class);

    /**
     * 상품 목록 조회
     */
    public List<ProductVO> selectProductList(ProductVO vo) throws Exception {
        return selectList("kr.co.matpam.admin.product.service.impl.ProductMapper.selectProductList", vo);
    }

    /**
     * 상품 목록 총 개수 조회
     */
    public int selectProductListTotCnt(ProductVO vo) throws Exception {
        return selectOne("kr.co.matpam.admin.product.service.impl.ProductMapper.selectProductListTotCnt", vo);
    }

    /**
     * 단일 상품 조회
     */
    public ProductVO selectProduct(Long productNo) throws Exception {
        return selectOne("kr.co.matpam.admin.product.service.impl.ProductMapper.selectProduct", productNo);
    }

    /**
     * 상품 등록
     */
    public void insertProduct(ProductVO vo) throws Exception {
        LOGGER.info("[DAO] insertProduct 호출 - productName: {}", vo.getProductName());
        insert("kr.co.matpam.admin.product.service.impl.ProductMapper.insertProduct", vo);
        LOGGER.info("[DAO] insertProduct 완료 - 생성된 productNo: {}", vo.getProductNo());
    }

    /**
     * 상품 수정
     */
    public void updateProduct(ProductVO vo) throws Exception {
        update("kr.co.matpam.admin.product.service.impl.ProductMapper.updateProduct", vo);
    }

    /**
     * 구성상품 저장
     */
    public void insertProductComposition(ProductCompositionVO vo) throws Exception {
        LOGGER.info("[DAO] insertProductComposition - productNo: {}, bundleId: {}, sortOrder: {}", 
            vo.getProductNo(), vo.getBundleId(), vo.getSortOrder());
        insert("kr.co.matpam.admin.product.service.impl.ProductMapper.insertProductComposition", vo);
    }

    /**
     * 구성상품 삭제 (상품번호로)
     */
    public void deleteProductCompositionsByProductNo(Long productNo) throws Exception {
        LOGGER.info("[DAO] deleteProductCompositionsByProductNo - productNo: {}", productNo);
        delete("kr.co.matpam.admin.product.service.impl.ProductMapper.deleteProductCompositionsByProductNo", productNo);
    }
}
