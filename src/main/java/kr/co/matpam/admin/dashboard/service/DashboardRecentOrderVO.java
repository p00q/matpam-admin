package kr.co.matpam.admin.dashboard.service;

import java.io.Serializable;

public class DashboardRecentOrderVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private String orderId;
    private String orderTitle;
    private long totalAmt;
    private long payAmt;
    private String orderStatus;
    private String regDt;
    private String memberId;
    private String ordererName;

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getOrderTitle() {
        return orderTitle;
    }

    public void setOrderTitle(String orderTitle) {
        this.orderTitle = orderTitle;
    }

    public long getTotalAmt() {
        return totalAmt;
    }

    public void setTotalAmt(long totalAmt) {
        this.totalAmt = totalAmt;
    }

    public long getPayAmt() {
        return payAmt;
    }

    public void setPayAmt(long payAmt) {
        this.payAmt = payAmt;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getRegDt() {
        return regDt;
    }

    public void setRegDt(String regDt) {
        this.regDt = regDt;
    }

    public String getMemberId() {
        return memberId;
    }

    public void setMemberId(String memberId) {
        this.memberId = memberId;
    }

    public String getOrdererName() {
        return ordererName;
    }

    public void setOrdererName(String ordererName) {
        this.ordererName = ordererName;
    }
}
