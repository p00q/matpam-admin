package kr.co.matpam.admin.dashboard.service;

import java.io.Serializable;

public class DashboardChartVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private String saleDate;
    private long dailySales;

    public String getSaleDate() {
        return saleDate;
    }

    public void setSaleDate(String saleDate) {
        this.saleDate = saleDate;
    }

    public long getDailySales() {
        return dailySales;
    }

    public void setDailySales(long dailySales) {
        this.dailySales = dailySales;
    }
}
