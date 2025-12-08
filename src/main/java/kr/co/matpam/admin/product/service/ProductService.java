package kr.co.matpam.admin.product.service;

import java.util.List;

public interface ProductService {

    List<ProductVO> selectProductList(ProductVO vo) throws Exception;

    int selectProductListTotCnt(ProductVO vo) throws Exception;

    ProductVO selectProduct(Long productNo) throws Exception;

    /** 상품 등록 */
    void insertProduct(ProductVO vo) throws Exception;

    /** 상품 수정 */
    void updateProduct(ProductVO vo) throws Exception;
}
