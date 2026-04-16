package kr.co.matpam.admin.product.service.impl;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;

import kr.co.matpam.admin.product.service.SalesProductVO;

/**
 * 판매상품 DAO
 * - Mapper: kr.co.matpam.admin.product.service.impl.SalesProductMapper
 * (SalesProductMapper.xml)
 */
@Repository("salesProductDAO")
public class SalesProductDAO extends EgovAbstractMapper {

    private static final String NAMESPACE = "kr.co.matpam.admin.product.service.impl.SalesProductMapper";

    /** 판매상품 목록 */
    public List<SalesProductVO> selectSalesProductList(SalesProductVO searchVO) {
        return selectList(NAMESPACE + ".selectSalesProductList", searchVO);
    }

    /** 판매상품 목록 총 건수 */
    public int selectSalesProductListTotCnt(SalesProductVO searchVO) {
        return selectOne(NAMESPACE + ".selectSalesProductListTotCnt", searchVO);
    }

    /** 판매상품 상세 */
    public SalesProductVO selectSalesProduct(SalesProductVO vo) {
        return selectOne(NAMESPACE + ".selectSalesProduct", vo);
    }

    public void increaseViewCount(SalesProductVO vo) {
        update(NAMESPACE + ".increaseViewCount", vo);
    }

    /** 판매상품 등록 */
    public int insertSalesProduct(SalesProductVO vo) {
        // useGeneratedKeys="true" keyProperty="salesProdId" 이므로 vo.salesProdId에 PK 세팅됨
        return insert(NAMESPACE + ".insertSalesProduct", vo);
    }

    /** 판매상품 상세(설명/정책) UPSERT */
    public int upsertSalesProductDetail(SalesProductVO vo) {
        return insert(NAMESPACE + ".upsertSalesProductDetail", vo);
    }

    /** 판매상품 수정 */
    public int updateSalesProduct(SalesProductVO vo) {
        return update(NAMESPACE + ".updateSalesProduct", vo);
    }

    public int deleteSalesProduct(SalesProductVO vo) {
        return update(NAMESPACE + ".deleteSalesProduct", vo);
    }

    /** 판매상품 이미지 등록 */
    public int insertSalesProductImage(kr.co.matpam.admin.product.service.SalesProductImageVO vo) {
        return insert(NAMESPACE + ".insertSalesProductImage", vo);
    }

    /** 판매상품 이미지 삭제(관리용) */
    public int deleteSalesProductImages(SalesProductVO vo) {
        return delete(NAMESPACE + ".deleteSalesProductImages", vo);
    }

    /** 판매상품 이미지 목록 조회 */
    public List<kr.co.matpam.admin.product.service.SalesProductImageVO> selectSalesProductImageList(SalesProductVO vo) {
        return selectList(NAMESPACE + ".selectSalesProductImageList", vo);
    }
}
