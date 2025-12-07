package kr.co.matpam.admin.product.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import kr.co.matpam.admin.product.service.ProductVO;

@Repository("productDAO")
public class ProductDAO extends EgovAbstractMapper {

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
}
