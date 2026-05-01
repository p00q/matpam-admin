package kr.co.matpam.admin.member.service;

import java.io.Serializable;
import java.util.Date;
/**
 * 맛팜 머니(meatMoney) 변동 이력 VO
 */
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

    public Long getHistoryId() { return historyId; }
    public void setHistoryId(Long historyId) { this.historyId = historyId; }
    public Long getMemberPk() { return memberPk; }
    public void setMemberPk(Long memberPk) { this.memberPk = memberPk; }
    public String getChangeType() { return changeType; }
    public void setChangeType(String changeType) { this.changeType = changeType; }
    public Long getChangeAmt() { return changeAmt; }
    public void setChangeAmt(Long changeAmt) { this.changeAmt = changeAmt; }
    public Long getBalanceAmt() { return balanceAmt; }
    public void setBalanceAmt(Long balanceAmt) { this.balanceAmt = balanceAmt; }
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    public Long getRefId() { return refId; }
    public void setRefId(Long refId) { this.refId = refId; }
    public String getRegId() { return regId; }
    public void setRegId(String regId) { this.regId = regId; }
    public Date getRegDt() { return regDt; }
    public void setRegDt(Date regDt) { this.regDt = regDt; }
}
