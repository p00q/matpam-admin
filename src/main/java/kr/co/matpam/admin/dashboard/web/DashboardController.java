package kr.co.matpam.admin.dashboard.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import kr.co.matpam.admin.dashboard.service.DashboardService;

@Controller
@RequestMapping("/admin/dashboard")
public class DashboardController {

    @Resource(name = "dashboardService")
    private DashboardService dashboardService;

    @RequestMapping("/main.do")
    public ModelAndView main(HttpServletRequest request) throws Exception {
        ModelAndView mv = new ModelAndView("layout/main");
        
        String opType = (String) request.getAttribute("opType");
        
        mv.addObject("summary", dashboardService.selectDashboardSummary(opType));
        mv.addObject("chartData", dashboardService.selectDashboardChart(opType));
        mv.addObject("recentOrders", dashboardService.selectRecentOrderList(opType));
        
        mv.addObject("menu", "dashboard");
        mv.addObject("contentPage", "/WEB-INF/jsp/admin/dashboard/MainDashboard.jsp");
        return mv;
    }
}
