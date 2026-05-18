package kr.co.matpam.admin.product.service;

import java.util.List;

/**
 * 통합 상품 관리 서비스 인터페이스
 */
public interface ProductService {

    /**
     * 상품 목록 조회
     */
    List<ProductVO> selectProductList(ProductVO vo) throws Exception;

    /**
     * 상품 목록 총 갯수 조회
     */
    int selectProductListTotCnt(ProductVO vo);

    /**
     * 상품 상세 조회
     */
    ProductVO selectProductDetail(Long productId) throws Exception;

    /**
     * 추천가공 후보 상품 목록 조회
     */
    List<ProductVO> selectRecommendedProcessCandidateList(ProductVO vo) throws Exception;

    /**
     * 상품 등록
     */
    void insertProduct(ProductVO vo) throws Exception;

    /**
     * 상품 수정
     */
    void updateProduct(ProductVO vo) throws Exception;

    /**
     * 상품 가격 정책 목록 조회
     */
    List<ProductPriceVO> selectProductPriceList(Long productId) throws Exception;

    /**
     * 상품 가격 정책 저장
     */
    void saveProductPrice(ProductPriceVO vo) throws Exception;
}
