package kr.co.matpam.admin.settlement.service.impl;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.util.Calendar;
import javax.annotation.Resource;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import kr.co.matpam.admin.settlement.service.SettlementService;
import kr.co.matpam.admin.settlement.service.SettlementVO;
import kr.co.matpam.admin.settlement.service.SettlementLineVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

@Service("settlementService")
public class SettlementServiceImpl extends EgovAbstractServiceImpl implements SettlementService {

    @Resource(name = "settlementMapper")
    private SettlementMapper settlementMapper;

    @Override
    @Transactional
    public void generateWeeklySettlement(Long tenantId, Date targetDate) throws Exception {
        // 1. 기간 계산 (7일 전 ~ 오늘)
        Calendar cal = Calendar.getInstance();
        cal.setTime(targetDate);
        Date periodTo = cal.getTime();
        cal.add(Calendar.DATE, -6);
        Date periodFrom = cal.getTime();

        // 2. 해당 기간의 배송 완료된 주문 조회 (OrderDAO 연동 필요)
        // 3. 업체별로 그룹화하여 Settlement 마스터 생성
        // 4. 주문별 상세 내역(Line) 생성
    }

    @Override
    public List<SettlementVO> selectSettlementList(SettlementVO searchVO) throws Exception {
        return new ArrayList<>();
    }

    @Override
    public int selectSettlementListTotCnt(SettlementVO searchVO) throws Exception {
        return 0;
    }

    @Override
    public EgovMap selectSettlementSummary(SettlementVO searchVO) throws Exception {
        return new EgovMap();
    }

    @Override
    public void executeDailySettlement(SettlementVO vo) throws Exception {
        // 주간 정산 로직으로 대체 또는 연동
        generateWeeklySettlement(vo.getTenantId(), new Date());
    }
}
