package kr.co.matpam.admin.settlement.service.impl;

import java.util.List;
import javax.annotation.Resource;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import kr.co.matpam.admin.settlement.service.SettlementService;
import kr.co.matpam.admin.settlement.service.SettlementVO;

/**
 * 정산 서비스 구현체
 */
@Service("settlementService")
public class SettlementServiceImpl extends EgovAbstractServiceImpl implements SettlementService {

    @Resource(name = "settlementDAO")
    private SettlementDAO settlementDAO;

    @Override
    @Transactional
    public void executeDailySettlement(SettlementVO settlementVO) throws Exception {
        // 1. 해당 일자의 기존 정산 데이터 삭제 (멱등성 보장)
        settlementDAO.deleteSettlementByDate(settlementVO);

        // 2. 주문 정보 기반 정산 집계 수행 (MyBatis aggregation query)
        List<SettlementVO> settlementDataList = settlementDAO.aggregateSettlementData(settlementVO);

        // 3. 집계된 데이터 저장
        if (settlementDataList != null) {
            for (SettlementVO vo : settlementDataList) {
                vo.setSettleDate(settlementVO.getSettleDate());
                // opType은 aggregate 결과에 포함되어 있거나, 파라미터로 받은 것을 사용
                settlementDAO.insertSettlement(vo);
            }
        }
    }

    @Override
    public List<SettlementVO> selectSettlementList(SettlementVO settlementVO) throws Exception {
        return settlementDAO.selectSettlementList(settlementVO);
    }

    @Override
    public int selectSettlementListTotCnt(SettlementVO settlementVO) throws Exception {
        return settlementDAO.selectSettlementListTotCnt(settlementVO);
    }    @Override
    @Transactional
    public void deleteSettlementByDate(SettlementVO settlementVO) throws Exception {
        settlementDAO.deleteSettlementByDate(settlementVO);
    }

    @Override
    public void aggregateSettlementData(SettlementVO settlementVO) throws Exception {
        // 이 메서드는 단독 호출 시 로직 필요
        List<SettlementVO> settlementDataList = settlementDAO.aggregateSettlementData(settlementVO);
        if (settlementDataList != null) {
            for (SettlementVO vo : settlementDataList) {
                vo.setSettleDate(settlementVO.getSettleDate());
                settlementDAO.insertSettlement(vo);
            }
        }
    }

    @Override
    public org.egovframe.rte.psl.dataaccess.util.EgovMap selectSettlementSummary(SettlementVO settlementVO) throws Exception {
        return settlementDAO.selectSettlementSummary(settlementVO);
    }
}
