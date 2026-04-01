package kr.co.matpam.admin.settlement.web;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import javax.annotation.Resource;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import kr.co.matpam.admin.settlement.service.SettlementService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 정산 자동 실행 스케줄러 (Batch)
 */
@Component
public class SettlementScheduler {

    private static final Logger LOGGER = LoggerFactory.getLogger(SettlementScheduler.class);

    @Resource(name = "settlementService")
    private SettlementService settlementService;

    /**
     * 매일 새벽 2시에 전일 정산 수행
     * 0 0 2 * * * (초 분 시 일 월 요일)
     */
    @Scheduled(cron = "0 0 2 * * *")
    public void runDailySettlement() {
        LOGGER.info(">>> Daily Settlement Batch Started >>>");
        
        try {
            // 전일 날짜 구해오기 (yyyyMMdd)
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DATE, -1);
            String settleDate = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());

            LOGGER.info(">>> Target Settle Date: {}", settleDate);
            
            settlementService.executeDailySettlement(settleDate);
            
            LOGGER.info(">>> Daily Settlement Batch Completed Successfully for Date: {}", settleDate);
        } catch (Exception e) {
            LOGGER.error(">>> Daily Settlement Batch Failed: {}", e.getMessage(), e);
        }
    }
}
