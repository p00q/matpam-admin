package kr.co.matpam.admin.dashboard.service.impl;

import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import kr.co.matpam.admin.dashboard.service.DashboardService;
import kr.co.matpam.admin.dashboard.service.DashboardSummaryVO;
import kr.co.matpam.admin.dashboard.service.DashboardChartVO;
import kr.co.matpam.admin.order.service.OrderVO;

@Service("dashboardService")
public class DashboardServiceImpl implements DashboardService {

    @Resource(name = "dashboardMapper")
    private DashboardMapper dashboardMapper;

    @Override
    public DashboardSummaryVO selectDashboardSummary(String opType) throws Exception {
        return dashboardMapper.selectDashboardSummary(opType);
    }

    @Override
    public List<DashboardChartVO> selectDashboardChart(String opType) throws Exception {
        return dashboardMapper.selectDashboardChart(opType);
    }

    @Override
    public List<OrderVO> selectRecentOrderList(String opType) throws Exception {
        return dashboardMapper.selectRecentOrderList(opType);
    }
}
