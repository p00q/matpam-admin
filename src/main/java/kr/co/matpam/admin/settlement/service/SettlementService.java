package kr.co.matpam.admin.settlement.service;

import java.util.Date;
import java.util.List;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

public interface SettlementService {
    
    /**
     * 주간 정산 데이터 생성
     */
    void generateWeeklySettlement(Long tenantId, Date targetDate) throws Exception;

    List<SettlementVO> selectSettlementList(SettlementVO searchVO) throws Exception;

    int selectSettlementListTotCnt(SettlementVO searchVO) throws Exception;

    EgovMap selectSettlementSummary(SettlementVO searchVO) throws Exception;

    void executeDailySettlement(SettlementVO vo) throws Exception;
}
