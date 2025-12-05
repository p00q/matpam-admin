package kr.co.matpam.admin.product.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import kr.co.matpam.admin.product.service.BundleProductVO;

/**
 * 구성상품 DAO
 */
@Repository("bundleProductDAO")
public class BundleProductDAO extends EgovAbstractMapper {

    /**
     * 구성상품 목록 조회
     */
    public List<BundleProductVO> selectBundleProductList(BundleProductVO searchVO) {
        return selectList("matpam.product.BundleProductMapper.selectBundleProductList", searchVO);
    }

    /**
     * 구성상품 목록 총 건수 조회
     */
    public int selectBundleProductListTotCnt(BundleProductVO searchVO) {
        return selectOne("matpam.product.BundleProductMapper.selectBundleProductListTotCnt", searchVO);
    }

    /**
     * 구성상품 상세 조회
     */
    public BundleProductVO selectBundleProduct(Long productNo) {
        return selectOne("matpam.product.BundleProductMapper.selectBundleProduct", productNo);
    }

    /**
     * 구성상품 등록
     */
    public void insertBundleProduct(BundleProductVO bundleProductVO) {
        insert("matpam.product.BundleProductMapper.insertBundleProduct", bundleProductVO);
    }

    /**
     * 구성상품 수정
     */
    public void updateBundleProduct(BundleProductVO bundleProductVO) {
        update("matpam.product.BundleProductMapper.updateBundleProduct", bundleProductVO);
    }

    /**
     * 구성상품 삭제
     */
    public void deleteBundleProduct(Long productNo) {
        delete("matpam.product.BundleProductMapper.deleteBundleProduct", productNo);
    }
}
