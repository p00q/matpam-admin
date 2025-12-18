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
    public SalesProductVO selectSalesProduct(Long salesProdId) {
        return selectOne(NAMESPACE + ".selectSalesProduct", salesProdId);
    }

    public void increaseViewCount(Long salesProdId) {
        update(NAMESPACE + ".increaseViewCount", salesProdId);
    }

    /** 판매상품 등록 */
    public int insertSalesProduct(SalesProductVO vo) {
        // useGeneratedKeys="true" keyProperty="salesProdId" 이므로 vo.salesProdId에 PK 세팅됨
        return insert(NAMESPACE + ".insertSalesProduct", vo);
    }

    /** 판매상품 상세 upsert */
    public int upsertSalesProductDetail(SalesProductVO vo) {
        return insert(NAMESPACE + ".upsertSalesProductDetail", vo);
    }

    /** 판매상품 수정 */
    public int updateSalesProduct(SalesProductVO vo) {
        return update(NAMESPACE + ".updateSalesProduct", vo);
    }

    /** 판매상품 삭제(논리삭제) */
    public int deleteSalesProduct(Long salesProdId) {
        return update(NAMESPACE + ".deleteSalesProduct", salesProdId);
    }
}
