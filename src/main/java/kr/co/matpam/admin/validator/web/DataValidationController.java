package kr.co.matpam.admin.validator.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.matpam.admin.validator.service.DataValidationService;
import kr.co.matpam.admin.validator.service.DataValidationVO;

/**
 * 데이터 정합성 검증 컨트롤러
 */
@Controller
public class DataValidationController {

    @Resource(name = "dataValidationService")
    private DataValidationService dataValidationService;

    /**
     * 데이터 정합성 검증 메인 화면 (목록)
     */
    @RequestMapping("/validator/dataValidationList.do")
    public String dataValidationList(@ModelAttribute("searchVO") DataValidationVO searchVO, ModelMap model) throws Exception {
        
        // 메인 레이아웃에 태울 페이지 경로
        model.addAttribute("contentPage", "/WEB-INF/jsp/egovframework/validator/dataValidationList.jsp");
        model.addAttribute("pageTitle", "데이터 정합성 검증");
        
        return "layout/main";
    }

    /**
     * 데이터 정합성 검증 결과 조회 (Ajax 전용)
     */
    @RequestMapping("/validator/selectDataValidationList.do")
    public String selectDataValidationList(@ModelAttribute("searchVO") DataValidationVO searchVO, ModelMap model) throws Exception {
        
        /** 페이징 설정 */
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
        paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
        paginationInfo.setPageSize(searchVO.getPageSize());

        searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
        searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        /** 목록 및 총 건수 조회 */
        int totalCount = dataValidationService.selectMismatchedOrderListCnt(searchVO);
        paginationInfo.setTotalRecordCount(totalCount);

        model.addAttribute("resultList", dataValidationService.selectMismatchedOrderList(searchVO));
        model.addAttribute("paginationInfo", paginationInfo);
        
        // 결과를 표시할 JSP Fragment 반환
        return "egovframework/validator/dataValidationResult";
    }
}
