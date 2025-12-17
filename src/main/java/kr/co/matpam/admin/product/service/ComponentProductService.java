package kr.co.matpam.admin.product.service;

import java.util.List;

/**
 * 구성상품(컴포넌트상품) Service Interface
 * - 대상 테이블: TB_COMPONENT_PRODUCT
 * - PK: COMPONENT_PROD_ID
 */
public interface ComponentProductService {

    /**
     * 구성상품(컴포넌트상품) 목록 조회
     */
    List<ComponentProductVO> selectComponentProductList(ComponentProductVO searchVO) throws Exception;

    /**
     * 구성상품(컴포넌트상품) 목록 총 건수 조회
     */
    int selectComponentProductListTotCnt(ComponentProductVO searchVO) throws Exception;

    /**
     * 구성상품(컴포넌트상품) 상세 조회
     */
    ComponentProductVO selectComponentProduct(Long componentProdId) throws Exception;

    /**
     * 구성상품(컴포넌트상품) 등록
     */
    void insertComponentProduct(ComponentProductVO componentProductVO) throws Exception;

    /**
     * 구성상품(컴포넌트상품) 수정
     */
    void updateComponentProduct(ComponentProductVO componentProductVO) throws Exception;

    /**
     * 구성상품(컴포넌트상품) 삭제
     */
    void deleteComponentProduct(Long componentProdId) throws Exception;
}
