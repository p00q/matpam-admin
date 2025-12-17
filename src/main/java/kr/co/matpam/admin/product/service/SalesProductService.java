package kr.co.matpam.admin.product.service;

import java.util.List;

/**
 * 판매상품 Service
 * - TABLE : tb_sales_product
 */
public interface SalesProductService {

    /** 판매상품 목록 */
    List<SalesProductVO> selectSalesProductList(SalesProductVO searchVO) throws Exception;

    /** 판매상품 목록 총 건수 */
    int selectSalesProductListTotCnt(SalesProductVO searchVO) throws Exception;

    /** 판매상품 상세 */
    SalesProductVO selectSalesProduct(Long salesProdId) throws Exception;

    /** 판매상품 등록 */
    void insertSalesProduct(SalesProductVO vo) throws Exception;

    /** 판매상품 수정 */
    void updateSalesProduct(SalesProductVO vo) throws Exception;

    /** 판매상품 삭제(논리삭제) */
    void deleteSalesProduct(Long salesProdId) throws Exception;
}
