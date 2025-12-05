package kr.co.matpam.admin.product.service;

import java.util.List;

/**
 * 구성상품 Service Interface
 */
public interface BundleProductService {

    /**
     * 구성상품 목록 조회
     */
    List<BundleProductVO> selectBundleProductList(BundleProductVO searchVO) throws Exception;

    /**
     * 구성상품 목록 총 건수 조회
     */
    int selectBundleProductListTotCnt(BundleProductVO searchVO) throws Exception;

    /**
     * 구성상품 상세 조회
     */
    BundleProductVO selectBundleProduct(Long productNo) throws Exception;

    /**
     * 구성상품 등록
     */
    void insertBundleProduct(BundleProductVO bundleProductVO) throws Exception;

    /**
     * 구성상품 수정
     */
    void updateBundleProduct(BundleProductVO bundleProductVO) throws Exception;

    /**
     * 구성상품 삭제
     */
    void deleteBundleProduct(Long productNo) throws Exception;
}
