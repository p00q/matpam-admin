package kr.co.matpam.admin.member.service.impl;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;

/**
 * 맛팜 머니(Meat Money) DAO (MyBatis Mapper 연동)
 */
@Repository("moneyDAO")
public class MoneyDAO extends EgovAbstractMapper {

    /**
     * 잔액 업데이트 (차감/충전)
     */
    public int updateMeatMoneyBalance(Map<String, Object> params) {
        return update("matpam.member.MoneyMapper.updateMeatMoneyBalance", params);
    }

    /**
     * 이력 저장
     */
    public void insertMoneyHistory(Map<String, Object> params) {
        insert("matpam.member.MoneyMapper.insertMoneyHistory", params);
    }

    /**
     * 머니 이력 조회
     */
    public List<Map<String, Object>> selectMoneyHistoryList(Map<String, Object> params) {
        return selectList("matpam.member.MoneyMapper.selectMoneyHistoryList", params);
    }
}
