package kr.co.matpam.admin.product.service;

import java.util.List;

public interface ProductService {

    /**
     * 상품 목록 조회
     */
    List<ProductVO> selectProductList(ProductVO vo) throws Exception;

    /**
     * 상품 목록 총 개수 조회
     */
    int selectProductListTotCnt(ProductVO vo) throws Exception;

    /**
     * 단일 상품 조회
     */
    ProductVO selectProduct(Long productNo) throws Exception;
}
