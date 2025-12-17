package kr.co.matpam.admin.product.service.impl;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;

import kr.co.matpam.admin.product.service.SalesProductCompositionVO;

@Repository("salesProductCompositionDAO")
public class SalesProductCompositionDAO extends EgovAbstractMapper {

    private static final String NAMESPACE = "kr.co.matpam.admin.product.service.impl.SalesProductCompositionMapper";

    public List<SalesProductCompositionVO> selectCompListBySalesProdId(Long salesProdId) {
        return selectList(NAMESPACE + ".selectCompListBySalesProdId", salesProdId);
    }

    /** 복합PK 환경에선 insert 대신 upsert가 안전 */
    public int upsertComp(SalesProductCompositionVO vo) {
        return insert(NAMESPACE + ".upsertComp", vo);
    }

    public int deleteCompBySalesProdId(Long salesProdId) {
        return update(NAMESPACE + ".deleteCompBySalesProdId", salesProdId);
    }

    public int deleteComp(SalesProductCompositionVO vo) {
        return update(NAMESPACE + ".deleteComp", vo);
    }
}
