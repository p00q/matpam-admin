package kr.co.matpam.admin.order.web;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import kr.co.matpam.admin.code.service.CodeManagementService;
import kr.co.matpam.admin.order.service.OrderDeliveryFactoryVO;
import kr.co.matpam.admin.order.service.OrderDeliveryFreightVO;
import kr.co.matpam.admin.order.service.OrderDeliveryParcelVO;
import kr.co.matpam.admin.order.service.OrderDetailVO;
import kr.co.matpam.admin.order.service.OrderItemVO;
import kr.co.matpam.admin.order.service.OrderListVO;
import kr.co.matpam.admin.order.service.OrderManageService;
import kr.co.matpam.admin.order.service.OrderSearchVO;
import kr.co.matpam.admin.order.service.OrderSummaryVO;

/**
 * 주문관리 Controller
 */
@Controller
public class OrderManageController {

    private static final Logger LOGGER = LoggerFactory.getLogger(OrderManageController.class);

    @Resource(name = "orderManageService")
    private OrderManageService orderManageService;

    @Resource(name = "orderService")
    private kr.co.matpam.admin.order.service.OrderService orderService;

    @Resource(name = "codeManagementService")
    private CodeManagementService codeManagementService;

    /**
     * 주문관리 목록 화면
     */
    @RequestMapping(value = "/admin/order/orderList.do", method = RequestMethod.GET)
    public String orderList(@ModelAttribute("searchVO") OrderSearchVO searchVO,
            ModelMap model) throws Exception {

        // 공통코드 조회 (주문상태, 배송유형)
        model.addAttribute("orderStatusList",
                codeManagementService.selectDetailCodeList("ORDER_STATUS", "ORDER_STATUS"));
        model.addAttribute("deliveryTypeList",
                codeManagementService.selectDetailCodeList("DELIVERY_TYPE", "DELIVERY_TYPE"));

        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/order/OrderManageList.jsp");
        return "layout/main";
    }

    /**
     * 주문 상세 화면
     */
    @RequestMapping(value = "/admin/order/orderDetail.do", method = RequestMethod.GET)
    public String orderDetail(@ModelAttribute("searchVO") OrderSearchVO searchVO, ModelMap model, HttpServletRequest request) throws Exception {

        // 운영권한 격리
        searchVO.setOpType((String) request.getAttribute("opType"));

        // 1. 주문 상세 정보 조회
        OrderDetailVO orderDetail = orderManageService.selectOrderDetail(searchVO);
        model.addAttribute("orderDetail", orderDetail);

        // 2. 주문 아이템 목록 조회
        List<OrderItemVO> orderItemList = orderManageService.selectOrderItemList(searchVO);
        model.addAttribute("orderItemList", orderItemList);

        // 3. 공통코드 및 배송정보 조회
        model.addAttribute("deliveryTypeList",
                codeManagementService.selectDetailCodeList("DELIVERY_TYPE", "DELIVERY_TYPE"));
        // 필요시 추가 코드 조회

        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/order/OrderManageDetail.jsp");
        return "layout/main";
    }

    /**
     * 주문건별 목록 조회 (AJAX)
     */
    @RequestMapping(value = "/admin/order/selectOrderList.ajax", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> selectOrderList(@ModelAttribute("searchVO") OrderSearchVO searchVO, HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        
        // 운영권한 격리
        String opType = (String) request.getAttribute("opType");
        if (opType != null && !"NATIONAL".equals(opType)) {
            searchVO.setOpType(opType);
        }

        try {
            // 페이징 계산
            if (searchVO.getPageIndex() == null) {
                searchVO.setPageIndex(1);
            }
            if (searchVO.getRecordCountPerPage() == null) {
                searchVO.setRecordCountPerPage(20);
            }

            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
            paginationInfo.setRecordCountPerPage(searchVO.getRecordCountPerPage());
            paginationInfo.setPageSize(10);

            searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
            searchVO.setLastIndex(paginationInfo.getLastRecordIndex());

            // 목록 조회
            List<OrderListVO> orderList = orderManageService.selectOrderList(searchVO);
            int totCnt = orderManageService.selectOrderListTotCnt(searchVO);

            paginationInfo.setTotalRecordCount(totCnt);

            result.put("success", true);
            result.put("orderList", orderList);
            result.put("paginationInfo", paginationInfo);
            result.put("totalCount", totCnt);

        } catch (Exception e) {
            LOGGER.error("주문목록 조회 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return result;
    }

    /**
     * 수기 주문 등록 및 맛팜 머니 차감 (AJAX)
     */
    @RequestMapping(value = "/admin/order/insertManualOrder.ajax", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> insertManualOrder(
            @RequestParam("buyerMemberId") Long buyerMemberId,
            @RequestParam("payTotalAmt") java.math.BigDecimal payTotalAmt,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();

        try {
            kr.co.matpam.admin.order.service.OrderVO orderVO = new kr.co.matpam.admin.order.service.OrderVO();
            orderVO.setBuyerMemberId(buyerMemberId);
            orderVO.setTotalPayAmt(payTotalAmt);
            orderVO.setTotalOrderAmt(payTotalAmt);
            orderVO.setTotalVatAmt(java.math.BigDecimal.ZERO);
            orderVO.setTotalDiscountAmt(java.math.BigDecimal.ZERO);
            orderVO.setReceiverName("수기주문");
            orderVO.setReceiverHp("010-0000-0000");
            orderVO.setReceiverZip("00000");
            orderVO.setReceiverAddr("수기주문");
            orderVO.setReceiverAddrDetail("");
            
            // 운영권한 주입
            String opType = (String) request.getAttribute("opType");
            if (opType != null && !"NATIONAL".equals(opType)) {
                orderVO.setOpType(opType);
            } else {
                orderVO.setOpType("NATIONAL");
            }

            // 단일 가짜 주문 아이템 생성
            kr.co.matpam.admin.order.service.OrderItemVO dummyItem = new kr.co.matpam.admin.order.service.OrderItemVO();
            dummyItem.setSalesProdId(0L); // 수기주문 더미키
            dummyItem.setUnitPrice(payTotalAmt);
            dummyItem.setQty(1L);
            dummyItem.setItemOrderAmt(payTotalAmt);
            dummyItem.setItemVatAmt(java.math.BigDecimal.ZERO);
            dummyItem.setItemPayAmt(payTotalAmt);
            dummyItem.setOpType(orderVO.getOpType());
            
            orderVO.setOrderItems(java.util.Collections.singletonList(dummyItem));
            
            String loginId = (String) request.getAttribute("loginId");
            orderVO.setRegId(loginId != null ? loginId : "admin");

            orderService.processOrder(orderVO);

            result.put("success", true);
            result.put("message", "수기 주문 등록 및 결제 처리가 완료되었습니다.");

        } catch (Exception e) {
            LOGGER.error("수기 주문 등록 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return result;
    }

    /**
     * KPI 합계 조회 (AJAX)
     */
    @RequestMapping(value = "/admin/order/selectOrderSummary.ajax", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> selectOrderSummary(@ModelAttribute("searchVO") OrderSearchVO searchVO, HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        
        // 운영권한 격리
        String opType = (String) request.getAttribute("opType");
        if (opType != null && !"NATIONAL".equals(opType)) {
            searchVO.setOpType(opType);
        }

        try {
            OrderSummaryVO summary = orderManageService.selectOrderSummary(searchVO);
            result.put("success", true);
            result.put("summary", summary);

        } catch (Exception e) {
            LOGGER.error("KPI 합계 조회 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return result;
    }

    /**
     * 주문상태 일괄 변경 (AJAX)
     */
    @RequestMapping(value = "/admin/order/updateOrderStatusBatch.ajax", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> updateOrderStatusBatch(
            @RequestParam("orderIds") String orderIdsStr,
            @RequestParam("orderStatusCd") String orderStatusCd,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();

        try {
            // orderIds 파싱
            List<Long> orderIds = Arrays.stream(orderIdsStr.split(","))
                    .map(String::trim)
                    .filter(s -> !s.isEmpty())
                    .map(Long::parseLong)
                    .collect(Collectors.toList());

            if (orderIds.isEmpty()) {
                result.put("success", false);
                result.put("message", "선택된 주문이 없습니다.");
                return result;
            }

            // 수정자 ID (세션에서 가져오기)
            String loginId = (String) request.getAttribute("loginId");
            String modId = loginId != null ? loginId : "admin";
            String opType = (String) request.getAttribute("opType");

            int updatedCount = orderManageService.updateOrderStatusBatch(orderIds, orderStatusCd, modId, opType);

            result.put("success", true);
            result.put("updatedCount", updatedCount);
            result.put("message", updatedCount + "건의 주문 상태가 변경되었습니다.");

        } catch (Exception e) {
            LOGGER.error("주문상태 일괄변경 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return result;
    }

    /**
     * 택배 배송정보 조회 (AJAX)
     */
    @RequestMapping(value = "/admin/order/selectDeliveryParcel.ajax", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> selectDeliveryParcel(@ModelAttribute OrderDeliveryParcelVO vo, HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();

        try {
            vo.setOpType((String) request.getAttribute("opType"));

            OrderDeliveryParcelVO parcel = orderManageService.selectDeliveryParcel(vo);
            result.put("success", true);
            result.put("parcel", parcel);

        } catch (Exception e) {
            LOGGER.error("택배 배송정보 조회 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return result;
    }

    /**
     * 택배 배송정보 저장 (AJAX)
     */
    @RequestMapping(value = "/admin/order/saveDeliveryParcel.ajax", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveDeliveryParcel(@ModelAttribute OrderDeliveryParcelVO vo, HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();

        try {
            String loginId = (String) request.getAttribute("loginId");
            String opType = (String) request.getAttribute("opType");
            
            vo.setRegId(loginId != null ? loginId : "admin");
            vo.setModId(loginId != null ? loginId : "admin");
            vo.setOpType(opType);

            int cnt = orderManageService.saveDeliveryParcel(vo);

            result.put("success", true);
            result.put("message", "운송장 정보가 저장되었습니다.");

        } catch (Exception e) {
            LOGGER.error("택배 배송정보 저장 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return result;
    }

    /**
     * 화물/직배송 정보 조회 (AJAX)
     */
    @RequestMapping(value = "/admin/order/selectDeliveryFreight.ajax", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> selectDeliveryFreight(@ModelAttribute OrderDeliveryFreightVO vo, HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();

        try {
            vo.setOpType((String) request.getAttribute("opType"));

            OrderDeliveryFreightVO freight = orderManageService.selectDeliveryFreight(vo);
            result.put("success", true);
            result.put("freight", freight);

        } catch (Exception e) {
            LOGGER.error("화물 배송정보 조회 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return result;
    }

    /**
     * 화물/직배송 정보 저장 (AJAX)
     */
    @RequestMapping(value = "/admin/order/saveDeliveryFreight.ajax", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveDeliveryFreight(@ModelAttribute OrderDeliveryFreightVO vo, HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();

        try {
            String loginId = (String) request.getAttribute("loginId");
            String opType = (String) request.getAttribute("opType");

            vo.setRegId(loginId != null ? loginId : "admin");
            vo.setModId(loginId != null ? loginId : "admin");
            vo.setOpType(opType);

            int cnt = orderManageService.saveDeliveryFreight(vo);

            result.put("success", true);
            result.put("message", "배송 정보가 저장되었습니다.");

        } catch (Exception e) {
            LOGGER.error("화물 배송정보 저장 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return result;
    }

    /**
     * 공장수령 정보 조회 (AJAX)
     */
    @RequestMapping(value = "/admin/order/selectDeliveryFactory.ajax", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> selectDeliveryFactory(@ModelAttribute OrderDeliveryFactoryVO vo, HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();

        try {
            vo.setOpType((String) request.getAttribute("opType"));

            OrderDeliveryFactoryVO factory = orderManageService.selectDeliveryFactory(vo);
            result.put("success", true);
            result.put("factory", factory);

        } catch (Exception e) {
            LOGGER.error("공장수령 정보 조회 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return result;
    }

    /**
     * 공장수령 정보 저장 (AJAX)
     */
    @RequestMapping(value = "/admin/order/saveDeliveryFactory.ajax", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveDeliveryFactory(@ModelAttribute OrderDeliveryFactoryVO vo, HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();

        try {
            String loginId = (String) request.getAttribute("loginId");
            String opType = (String) request.getAttribute("opType");

            vo.setRegId(loginId != null ? loginId : "admin");
            vo.setModId(loginId != null ? loginId : "admin");
            vo.setOpType(opType);

            int cnt = orderManageService.saveDeliveryFactory(vo);

            result.put("success", true);
            result.put("message", "수령 정보가 저장되었습니다.");

        } catch (Exception e) {
            LOGGER.error("공장수령 정보 저장 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return result;
    }
}
