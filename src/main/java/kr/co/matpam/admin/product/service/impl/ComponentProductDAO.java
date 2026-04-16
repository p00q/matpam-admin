package kr.co.matpam.admin.product.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;

import kr.co.matpam.admin.product.service.ComponentProductVO;

/**
 * 구성상품(컴포넌트상품) DAO
 * - 대상 테이블: TB_COMPONENT_PRODUCT
 * - PK: COMPONENT_PROD_ID
 */
@Repository("componentProductDAO")
public class ComponentProductDAO extends EgovAbstractMapper {

    /**
     * 구성상품 목록 조회
     */
    public List<ComponentProductVO> selectComponentProductList(ComponentProductVO searchVO) {
        return selectList("matpam.product.ComponentProductMapper.selectComponentProductList", searchVO);
    }

    /**
     * 구성상품 목록 총 건수 조회
     */
    public int selectComponentProductListTotCnt(ComponentProductVO searchVO) {
        return selectOne("matpam.product.ComponentProductMapper.selectComponentProductListTotCnt", searchVO);
    }

    /**
     * 구성상품 상세 조회
     */
    public ComponentProductVO selectComponentProduct(ComponentProductVO vo) {
        return selectOne("matpam.product.ComponentProductMapper.selectComponentProduct", vo);
    }

    /**
     * 구성상품 등록
     */
    public void insertComponentProduct(ComponentProductVO componentProductVO) {
        insert("matpam.product.ComponentProductMapper.insertComponentProduct", componentProductVO);
    }

    /**
     * 구성상품 수정
     */
    public void updateComponentProduct(ComponentProductVO componentProductVO) {
        update("matpam.product.ComponentProductMapper.updateComponentProduct", componentProductVO);
    }

    /**
     * 구성상품 자동생성 코드 조회
     */
    public String selectNextComponentProdCode() {
        return selectOne("matpam.product.ComponentProductMapper.selectNextComponentProdCode");
    }

    /**
     * 구성상품 삭제
     * - 권장: 논리삭제(DEL_YN='Y') 방식
     */
    public void deleteComponentProduct(ComponentProductVO vo) {
        update("matpam.product.ComponentProductMapper.deleteComponentProduct", vo);
    }
}
