package kr.co.matpam.admin.settlement.service;

import java.util.List;

/**
 * 정산 서비스 인터페이스
 */
public interface SettlementService {

    /**
     * 일일 정산 수행 (전일 주문 기준)
     */
    void executeDailySettlement(String settleDate) throws Exception;

    /**
     * 정산 목록 조회
     */
    List<SettlementVO> selectSettlementList(SettlementVO settlementVO) throws Exception;

    /**
     * 정산 목록 총 건수
     */
    int selectSettlementListTotCnt(SettlementVO settlementVO) throws Exception;


    /**
     * 정산 KPI 요약 조회
     */
    org.egovframe.rte.psl.dataaccess.util.EgovMap selectSettlementSummary(SettlementVO settlementVO) throws Exception;
}
