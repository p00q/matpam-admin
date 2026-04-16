package kr.co.matpam.admin.dashboard.service;

import java.util.List;
import java.util.Map;
import kr.co.matpam.admin.order.service.OrderVO;

public interface DashboardService {

    DashboardSummaryVO selectDashboardSummary(String opType) throws Exception;

    List<DashboardChartVO> selectDashboardChart(String opType) throws Exception;

    List<OrderVO> selectRecentOrderList(String opType) throws Exception;
}
