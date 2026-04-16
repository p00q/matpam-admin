package kr.co.matpam.admin.settlement.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.matpam.admin.common.service.LoginVO;
import kr.co.matpam.admin.settlement.service.SettlementService;
import kr.co.matpam.admin.settlement.service.SettlementVO;

/**
 * 정산관리 Controller (재동기화 버전)
 */
@Controller
public class SettlementController {

    private static final Logger LOGGER = LoggerFactory.getLogger(SettlementController.class);

    @Resource(name = "settlementService")
    private SettlementService settlementService;

    /**
     * 정산관리 목록 화면
     */
    @RequestMapping(value = "/admin/settlement/settlementList.do", method = RequestMethod.GET)
    public String settlementList(@ModelAttribute("searchVO") SettlementVO searchVO, ModelMap model) throws Exception {
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/settlement/SettlementList.jsp");
        return "layout/main";
    }

    /**
     * 정산 목록 데이터 조회 (AJAX)
     */
    @RequestMapping(value = "/admin/settlement/selectSettlementList.ajax", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> selectSettlementList(@ModelAttribute("searchVO") SettlementVO searchVO, HttpServletRequest request) {
        
        Map<String, Object> result = new HashMap<>();
        HttpSession session = request.getSession();
        LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");

        try {
            // 1) 자동 데이터 세팅 (인터셉터에서 주입된 값 활용)
            String opType = (String) request.getAttribute("opType");
            if (opType != null && !"NATIONAL".equals(opType)) {
                searchVO.setOpType(opType);
            }

            // 페이징 설정
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
            paginationInfo.setRecordCountPerPage(searchVO.getRecordCountPerPage());
            paginationInfo.setPageSize(searchVO.getPageUnit());

            searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
            searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

            // 데이터 조회
            List<SettlementVO> settlementList = settlementService.selectSettlementList(searchVO);
            int totalCount = settlementService.selectSettlementListTotCnt(searchVO);
            paginationInfo.setTotalRecordCount(totalCount);

            result.put("success", true);
            result.put("settlementList", settlementList);
            result.put("totalCount", totalCount);
            result.put("paginationInfo", paginationInfo);

        } catch (Exception e) {
            LOGGER.error("정산 목록 조회 오류", e);
            result.put("success", false);
            result.put("message", "데이터 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    /**
     * 정산 KPI 요약 데이터 조회 (AJAX)
     */
    @RequestMapping(value = "/admin/settlement/selectSettlementSummary.ajax", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> selectSettlementSummary(@ModelAttribute("searchVO") SettlementVO searchVO, HttpServletRequest request) {
        
        Map<String, Object> result = new HashMap<>();
        HttpSession session = request.getSession();
        LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");

        try {
            // 1) 자동 데이터 세팅 (인터셉터에서 주입된 값 활용)
            String opType = (String) request.getAttribute("opType");
            searchVO.setOpType(opType);

            EgovMap summary = settlementService.selectSettlementSummary(searchVO);
            result.put("success", true);
            result.put("summary", summary);

        } catch (Exception e) {
            LOGGER.error("정산 요약 조회 오류", e);
            result.put("success", false);
        }

        return result;
    }

    /**
     * 수동 정산 실행 (AJAX)
     */
    @RequestMapping(value = "/admin/settlement/executeSettlement.ajax", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> executeSettlement(@RequestParam("settleDate") String settleDate, HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            String opType = (String) request.getAttribute("opType");
            
            SettlementVO vo = new SettlementVO();
            vo.setSettleDate(settleDate.replace("-", ""));
            vo.setOpType(opType);

            settlementService.executeDailySettlement(vo);
            
            result.put("success", true);
            result.put("message", "정산이 성공적으로 수행되었습니다.");
        } catch (Exception e) {
            LOGGER.error("정산 실행 오류", e);
            result.put("success", false);
            result.put("message", "정산 실행 중 오류가 발생했습니다.");
        }
        return result;
    }
}
