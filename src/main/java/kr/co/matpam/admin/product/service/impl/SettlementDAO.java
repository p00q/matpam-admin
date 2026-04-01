package kr.co.matpam.admin.product.service.impl;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import kr.co.matpam.admin.settlement.service.SettlementVO;
import org.springframework.stereotype.Repository;

/**
 * 정산 업무용 DAO (MyBatis Mapper 연동)
 */
@Repository("settlementDAO")
public class SettlementDAO extends EgovAbstractMapper {

    /**
     * 정산 목록 조회
     */
    public List<SettlementVO> selectSettlementList(SettlementVO vo) {
        return selectList("matpam.settlement.SettlementMapper.selectSettlementList", vo);
    }

    /**
     * 정산 목록 총 건수 조회
     */
    public int selectSettlementListTotCnt(SettlementVO vo) {
        return selectOne("matpam.settlement.SettlementMapper.selectSettlementListTotCnt", vo);
    }

    /**
     * 주문 정보 기반 정산 집계 수행
     */
    public List<SettlementVO> aggregateSettlementData(String settleDate) {
        return selectList("matpam.settlement.SettlementMapper.aggregateSettlementData", settleDate);
    }

    /**
     * 정산 데이터 저장
     */
    public void insertSettlement(SettlementVO vo) {
        insert("matpam.settlement.SettlementMapper.insertSettlement", vo);
    }

    /**
     * 정산 상태 업데이트
     */
    public void updateSettlementStatus(SettlementVO vo) {
        update("matpam.settlement.SettlementMapper.updateSettlementStatus", vo);
    }

    /**
     * 정산 데이터 삭제 (재정산용)
     */
    public void deleteSettlementByDate(String settleDate) {
        delete("matpam.settlement.SettlementMapper.deleteSettlementByDate", settleDate);
    }
 
    /**
     * 정산 KPI 요약 조회
     */
    public org.egovframe.rte.psl.dataaccess.util.EgovMap selectSettlementSummary(SettlementVO vo) {
        return selectOne("matpam.settlement.SettlementMapper.selectSettlementSummary", vo);
    }
}
