package kr.co.matpam.admin.dashboard.service;

import java.io.Serializable;

public class DashboardSummaryVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private long todaySales;
    private int todayOrderCount;
    private int readyShippingCount;
    private int todayNewMemberCount;

    public long getTodaySales() {
        return todaySales;
    }

    public void setTodaySales(long todaySales) {
        this.todaySales = todaySales;
    }

    public int getTodayOrderCount() {
        return todayOrderCount;
    }

    public void setTodayOrderCount(int todayOrderCount) {
        this.todayOrderCount = todayOrderCount;
    }

    public int getReadyShippingCount() {
        return readyShippingCount;
    }

    public void setReadyShippingCount(int readyShippingCount) {
        this.readyShippingCount = readyShippingCount;
    }

    public int getTodayNewMemberCount() {
        return todayNewMemberCount;
    }

    public void setTodayNewMemberCount(int todayNewMemberCount) {
        this.todayNewMemberCount = todayNewMemberCount;
    }
}
