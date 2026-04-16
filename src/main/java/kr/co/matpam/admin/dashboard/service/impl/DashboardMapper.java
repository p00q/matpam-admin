package kr.co.matpam.admin.dashboard.service.impl;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import kr.co.matpam.admin.dashboard.service.DashboardSummaryVO;
import kr.co.matpam.admin.dashboard.service.DashboardChartVO;
import kr.co.matpam.admin.order.service.OrderVO;

@Mapper("dashboardMapper")
public interface DashboardMapper {

    DashboardSummaryVO selectDashboardSummary(@Param("opType") String opType) throws Exception;

    List<DashboardChartVO> selectDashboardChart(@Param("opType") String opType) throws Exception;

    List<OrderVO> selectRecentOrderList(@Param("opType") String opType) throws Exception;
}
