package kr.co.matpam.admin.order.web;

import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import kr.co.matpam.admin.order.service.OrderService;
import kr.co.matpam.admin.order.service.OrderVO;

/**
 * 통합 주문 관리 컨트롤러
 */
@Controller
public class OrderController {

    @Resource(name = "orderManageService")
    private kr.co.matpam.admin.order.service.OrderManageService orderManageService;

    /**
     * 주문 목록 페이지 (Layout)
     */
    @RequestMapping("/admin/order/orderList.do")
    public String orderList(@ModelAttribute("searchVO") kr.co.matpam.admin.order.service.OrderSearchVO searchVO, ModelMap model) throws Exception {
        model.addAttribute("currentMenu", "order");
        model.addAttribute("pageTitle", "주문 통합 관리");
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/order/OrderManageList.jsp");
        return "layout/main";
    }

    /**
     * 주문 목록 데이터 조회 (AJAX)
     */
    @RequestMapping("/admin/order/selectOrderList.do")
    @org.springframework.web.bind.annotation.ResponseBody
    public java.util.Map<String, Object> selectOrderList(@ModelAttribute kr.co.matpam.admin.order.service.OrderSearchVO searchVO) throws Exception {
        java.util.Map<String, Object> resultMap = new java.util.HashMap<>();
        try {
            org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo paginationInfo = new org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo();
            paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
            paginationInfo.setRecordCountPerPage(searchVO.getRecordCountPerPage());
            paginationInfo.setPageSize(10);

            searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
            searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

            List<kr.co.matpam.admin.order.service.OrderListVO> list = orderManageService.selectOrderList(searchVO);
            int totCnt = orderManageService.selectOrderListTotCnt(searchVO);
            paginationInfo.setTotalRecordCount(totCnt);

            resultMap.put("success", true);
            resultMap.put("orderList", list);
            resultMap.put("totalCount", totCnt);
            resultMap.put("paginationInfo", paginationInfo);
        } catch (Exception e) {
            resultMap.put("success", false);
            resultMap.put("message", e.getMessage());
        }
        return resultMap;
    }

    /**
     * 주문 요약 정보 조회 (AJAX)
     */
    @RequestMapping("/admin/order/selectOrderSummary.do")
    @org.springframework.web.bind.annotation.ResponseBody
    public java.util.Map<String, Object> selectOrderSummary(@ModelAttribute kr.co.matpam.admin.order.service.OrderSearchVO searchVO) throws Exception {
        java.util.Map<String, Object> resultMap = new java.util.HashMap<>();
        try {
            kr.co.matpam.admin.order.service.OrderSummaryVO summary = orderManageService.selectOrderSummary(searchVO);
            resultMap.put("success", true);
            resultMap.put("summary", summary);
        } catch (Exception e) {
            resultMap.put("success", false);
            resultMap.put("message", e.getMessage());
        }
        return resultMap;
    }

    /**
     * 주문 상태 일괄 변경 (AJAX)
     */
    @RequestMapping("/admin/order/updateOrderStatusBatch.do")
    @org.springframework.web.bind.annotation.ResponseBody
    public java.util.Map<String, Object> updateOrderStatusBatch(
            @RequestParam("orderIds") String orderIds, 
            @RequestParam("orderStatusCd") String orderStatusCd,
            javax.servlet.http.HttpSession session) throws Exception {
        java.util.Map<String, Object> resultMap = new java.util.HashMap<>();
        try {
            kr.co.matpam.admin.common.service.LoginVO loginVO = (kr.co.matpam.admin.common.service.LoginVO) session.getAttribute("loginVO");
            String modId = loginVO != null ? loginVO.getLoginId() : "admin";
            String opType = loginVO != null ? loginVO.getOpType() : "ADMIN";

            java.util.List<Long> idList = new java.util.ArrayList<>();
            for (String id : orderIds.split(",")) {
                idList.add(Long.parseLong(id));
            }

            int cnt = orderManageService.updateOrderStatusBatch(idList, orderStatusCd, modId, opType);
            resultMap.put("success", true);
            resultMap.put("message", cnt + "건의 주문 상태가 변경되었습니다.");
        } catch (Exception e) {
            resultMap.put("success", false);
            resultMap.put("message", e.getMessage());
        }
        return resultMap;
    }

    /* 배송 정보 핸들러 (택배/화물/공장수령) */

    @RequestMapping("/admin/order/selectDeliveryParcel.do")
    @org.springframework.web.bind.annotation.ResponseBody
    public java.util.Map<String, Object> selectDeliveryParcel(@RequestParam("orderId") Long orderId) throws Exception {
        java.util.Map<String, Object> resultMap = new java.util.HashMap<>();
        kr.co.matpam.admin.order.service.OrderDeliveryParcelVO vo = new kr.co.matpam.admin.order.service.OrderDeliveryParcelVO();
        vo.setOrderId(orderId);
        resultMap.put("success", true);
        resultMap.put("parcel", orderManageService.selectDeliveryParcel(vo));
        return resultMap;
    }

    @RequestMapping("/admin/order/saveDeliveryParcel.do")
    @org.springframework.web.bind.annotation.ResponseBody
    public java.util.Map<String, Object> saveDeliveryParcel(@ModelAttribute kr.co.matpam.admin.order.service.OrderDeliveryParcelVO vo) throws Exception {
        java.util.Map<String, Object> resultMap = new java.util.HashMap<>();
        orderManageService.saveDeliveryParcel(vo);
        resultMap.put("success", true);
        resultMap.put("message", "택배 배송 정보가 저장되었습니다.");
        return resultMap;
    }

    @RequestMapping("/admin/order/selectDeliveryFreight.do")
    @org.springframework.web.bind.annotation.ResponseBody
    public java.util.Map<String, Object> selectDeliveryFreight(@RequestParam("orderId") Long orderId) throws Exception {
        java.util.Map<String, Object> resultMap = new java.util.HashMap<>();
        kr.co.matpam.admin.order.service.OrderDeliveryFreightVO vo = new kr.co.matpam.admin.order.service.OrderDeliveryFreightVO();
        vo.setOrderId(orderId);
        resultMap.put("success", true);
        resultMap.put("freight", orderManageService.selectDeliveryFreight(vo));
        return resultMap;
    }

    @RequestMapping("/admin/order/saveDeliveryFreight.do")
    @org.springframework.web.bind.annotation.ResponseBody
    public java.util.Map<String, Object> saveDeliveryFreight(@ModelAttribute kr.co.matpam.admin.order.service.OrderDeliveryFreightVO vo) throws Exception {
        java.util.Map<String, Object> resultMap = new java.util.HashMap<>();
        orderManageService.saveDeliveryFreight(vo);
        resultMap.put("success", true);
        resultMap.put("message", "화물 배송 정보가 저장되었습니다.");
        return resultMap;
    }

    @RequestMapping("/admin/order/selectDeliveryFactory.do")
    @org.springframework.web.bind.annotation.ResponseBody
    public java.util.Map<String, Object> selectDeliveryFactory(@RequestParam("orderId") Long orderId) throws Exception {
        java.util.Map<String, Object> resultMap = new java.util.HashMap<>();
        kr.co.matpam.admin.order.service.OrderDeliveryFactoryVO vo = new kr.co.matpam.admin.order.service.OrderDeliveryFactoryVO();
        vo.setOrderId(orderId);
        resultMap.put("success", true);
        resultMap.put("factory", orderManageService.selectDeliveryFactory(vo));
        return resultMap;
    }

    @RequestMapping("/admin/order/saveDeliveryFactory.do")
    @org.springframework.web.bind.annotation.ResponseBody
    public java.util.Map<String, Object> saveDeliveryFactory(@ModelAttribute kr.co.matpam.admin.order.service.OrderDeliveryFactoryVO vo) throws Exception {
        java.util.Map<String, Object> resultMap = new java.util.HashMap<>();
        orderManageService.saveDeliveryFactory(vo);
        resultMap.put("success", true);
        resultMap.put("message", "공장수령 정보가 저장되었습니다.");
        return resultMap;
    }
}
