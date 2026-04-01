package kr.co.matpam.admin.product.service.impl;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.matpam.admin.settlement.service.SettlementService;

/**
 * 일 단위 정산 배치 서비스
 * - 매일 00:05 실행 (전일 데이터 집계)
 */
@Service("settlementBatchService")
public class SettlementBatchService {

    private static final Logger LOGGER = LoggerFactory.getLogger(SettlementBatchService.class);

    @Resource(name = "settlementService")
    private SettlementService settlementService;

    /**
     * 매일 00시 05분 자동 실행
     * - Cron: Second Minute Hour Day Month DayOfWeek
     */
    @Scheduled(cron = "0 5 0 * * *")
    @Transactional
    public void runDailySettlement() {
        LOGGER.info("[SettlementBatch] Batch started.");

        // 1. 전일(Yesterday) 날짜 산정
        LocalDate yesterday = LocalDate.now().minusDays(1);
        String settleDateStr = yesterday.format(DateTimeFormatter.ofPattern("yyyyMMdd"));

        try {
            // 전일 정산 실행 (판매자별 집계 및 저장)
            LOGGER.info("[SettlementBatch] Executing settlement for {}", settleDateStr);
            settlementService.executeDailySettlement(settleDateStr);
            
            LOGGER.info("[SettlementBatch] Batch completed successfully for {}.", settleDateStr);

        } catch (Exception e) {
            LOGGER.error("[SettlementBatch] Batch failed for {}!", settleDateStr, e);
        }
    }
}
