package kr.co.matpam.admin.member.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 맛팜 머니(Meat Money) 서비스 인터페이스
 */
public interface MeatMoneyService {

    /**
     * 잔액 조회
     */
    BigDecimal getBalance(Long memberId) throws Exception;

    /**
     * 머니 차감 (결제)
     */
    void deductMoney(Long memberId, BigDecimal amount, String refOrderNo) throws Exception;

    /**
     * 머니 충전
     */
    void chargeMoney(Long memberId, BigDecimal amount, String regId) throws Exception;

    /**
     * 머니 이력 조회
     */
    List<Map<String, Object>> selectMoneyHistoryList(Map<String, Object> params) throws Exception;
}
