package kr.co.matpam.admin.member.service.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.matpam.admin.member.service.MeatMoneyService;
import kr.co.matpam.admin.member.service.MemberService;
import kr.co.matpam.admin.member.service.MemberVO;

/**
 * 맛팜 머니(Meat Money) 서비스 구현체
 */
@Service("meatMoneyService")
public class MeatMoneyServiceImpl extends EgovAbstractServiceImpl implements MeatMoneyService {

    @Resource(name = "moneyDAO")
    private MoneyDAO moneyDAO;

    @Resource(name = "memberService")
    private MemberService memberService;

    @Override
    public BigDecimal getBalance(Long memberId) throws Exception {
        MemberVO vo = memberService.selectMemberDetail(memberId);
        if (vo == null) return BigDecimal.ZERO;
        return vo.getMeatmoneyBalanceAmt() != null ? vo.getMeatmoneyBalanceAmt() : BigDecimal.ZERO;
    }

    @Override
    @Transactional
    public void deductMoney(Long memberId, BigDecimal amount, String refOrderNo) throws Exception {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("차감할 금액이 0보다 커야 합니다.");
        }

        Map<String, Object> params = new HashMap<>();
        params.put("memberId", memberId);
        params.put("changeAmt", amount.negate()); // 음수로 전달
        params.put("isDeduct", "Y");
        params.put("trxType", "PAYMENT");
        params.put("refOrderNo", refOrderNo);
        params.put("remark", "주문 결제 (" + refOrderNo + ")");
        params.put("regId", "SYSTEM");

        int updated = moneyDAO.updateMeatMoneyBalance(params);
        if (updated == 0) {
            throw new RuntimeException("잔액이 부족하거나 회원 정보가 올바르지 않습니다.");
        }

        moneyDAO.insertMoneyHistory(params);
    }

    @Override
    @Transactional
    public void chargeMoney(Long memberId, BigDecimal amount, String regId) throws Exception {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("충전할 금액이 0보다 커야 합니다.");
        }

        Map<String, Object> params = new HashMap<>();
        params.put("memberId", memberId);
        params.put("changeAmt", amount);
        params.put("isDeduct", "N");
        params.put("trxType", "CHARGE");
        params.put("remark", "머니 충전");
        params.put("regId", regId != null ? regId : "SYSTEM");

        moneyDAO.updateMeatMoneyBalance(params);
        moneyDAO.insertMoneyHistory(params);
    }

    @Override
    public List<Map<String, Object>> selectMoneyHistoryList(Map<String, Object> params) throws Exception {
        return moneyDAO.selectMoneyHistoryList(params);
    }
}
