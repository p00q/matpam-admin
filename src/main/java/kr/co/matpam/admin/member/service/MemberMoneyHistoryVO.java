package kr.co.matpam.admin.member.service;

import java.io.Serializable;
import java.util.Date;
import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

/**
 * 맛팜 머니(meatMoney) 변동 이력 VO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MemberMoneyHistoryVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long historyId;
    private Long memberPk;
    
    private String changeType; // CHARGE(충전), PAY(결제), CANCEL(취소), ADMIN(관리자조정)
    private Long changeAmt;    // 변동 금액 (+ 또는 -)
    private Long balanceAmt;   // 변동 후 잔액
    
    private String reason;     // 변동 사유 (예: 주문번호 #1234 결제)
    private Long refId;        // 관련 식별자 (주문번호 등)

    private String regId;
    private Date regDt;
}
