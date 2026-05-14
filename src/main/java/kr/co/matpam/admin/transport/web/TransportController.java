package kr.co.matpam.admin.transport.web;

import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.matpam.admin.transport.service.DriverVO;
import kr.co.matpam.admin.transport.service.VehicleVO;
import kr.co.matpam.admin.transport.service.DriverVehicleVO;
import kr.co.matpam.admin.transport.service.TransportService;
import kr.co.matpam.admin.common.service.LoginVO;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping("/admin/transport")
public class TransportController {

    @Resource(name = "transportService")
    private TransportService transportService;

    /**
     * 운송기사 목록
     */
    @RequestMapping("/driverList.do")
    public String driverList(DriverVO vo, HttpServletRequest request, Model model) throws Exception {
        LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
        vo.setTenantId(resolveTenantId(loginVO));
        vo.setChannelId(resolveChannelId(loginVO));
        
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getPageUnit());
        paginationInfo.setPageSize(vo.getPageSize());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        vo.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        List<DriverVO> list = transportService.selectDriverList(vo);
        model.addAttribute("resultList", list);

        int totCnt = transportService.selectDriverListTotCnt(vo);
        paginationInfo.setTotalRecordCount(totCnt);
        model.addAttribute("paginationInfo", paginationInfo);

        return "admin/transport/DriverList";
    }

    /**
     * 차량 목록
     */
    @RequestMapping("/vehicleList.do")
    public String vehicleList(VehicleVO vo, HttpServletRequest request, Model model) throws Exception {
        LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
        vo.setTenantId(resolveTenantId(loginVO));
        vo.setChannelId(resolveChannelId(loginVO));

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getPageUnit());
        paginationInfo.setPageSize(vo.getPageSize());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        vo.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        List<VehicleVO> list = transportService.selectVehicleList(vo);
        model.addAttribute("resultList", list);

        int totCnt = transportService.selectVehicleListTotCnt(vo);
        paginationInfo.setTotalRecordCount(totCnt);
        model.addAttribute("paginationInfo", paginationInfo);

        return "admin/transport/VehicleList";
    }

    /**
     * 기사-차량 배정 처리 (AJAX)
     */
    @RequestMapping("/assignDriver.ajax")
    @ResponseBody
    public String assignDriver(@RequestParam("driverId") Long driverId, @RequestParam("vehicleId") Long vehicleId) throws Exception {
        try {
            transportService.assignDriverToVehicle(driverId, vehicleId);
            return "SUCCESS";
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }

    private Long resolveTenantId(LoginVO loginVO) {
        if (loginVO == null) {
            return 1L;
        }
        return loginVO.getTenantId() != null ? loginVO.getTenantId() : 1L;
    }

    private Long resolveChannelId(LoginVO loginVO) {
        if (loginVO == null || "SUPER_ADMIN".equals(loginVO.getMemberType())) {
            return null;
        }
        return loginVO.getChannelId();
    }
}
