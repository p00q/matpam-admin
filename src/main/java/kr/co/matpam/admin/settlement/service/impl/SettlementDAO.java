package kr.co.matpam.admin.settlement.service.impl;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;
import kr.co.matpam.admin.settlement.service.SettlementVO;

/**
 * 정산 정보 DAO (MyBatis Mapper 연동)
 */
@Repository("settlementDAO")
public class SettlementDAO extends EgovAbstractMapper {

    /**
     * 일일 정산 데이터 집계
     */
    @SuppressWarnings("unchecked")
    public List<SettlementVO> aggregateSettlementData(SettlementVO vo) {
        return selectList("matpam.settlement.SettlementMapper.aggregateSettlementData", vo);
    }

    /**
     * 정산 정보 등록
     */
    public void insertSettlement(SettlementVO vo) {
        insert("matpam.settlement.SettlementMapper.insertSettlement", vo);
    }

    /**
     * 정산 목록 조회
     */
    @SuppressWarnings("unchecked")
    public List<SettlementVO> selectSettlementList(SettlementVO vo) {
        return selectList("matpam.settlement.SettlementMapper.selectSettlementList", vo);
    }

    /**
     * 정산 목록 총 건수
     */
    public int selectSettlementListTotCnt(SettlementVO vo) {
        return (Integer) selectOne("matpam.settlement.SettlementMapper.selectSettlementListTotCnt", vo);
    }

    /**
     * 특정일 정산 삭제 (재정산용)
     */
    public void deleteSettlementByDate(SettlementVO vo) {
        delete("matpam.settlement.SettlementMapper.deleteSettlementByDate", vo);
    }

    /**
     * 정산 KPI 요약 조회
     */
    public org.egovframe.rte.psl.dataaccess.util.EgovMap selectSettlementSummary(SettlementVO vo) {
        return (org.egovframe.rte.psl.dataaccess.util.EgovMap) selectOne("matpam.settlement.SettlementMapper.selectSettlementSummary", vo);
    }
}
