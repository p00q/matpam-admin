package kr.co.matpam.admin.channel.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.matpam.admin.channel.service.ChannelService;
import kr.co.matpam.admin.channel.service.ChannelVO;
import kr.co.matpam.admin.company.service.CompanyService;
import kr.co.matpam.admin.company.service.CompanyVO;
import kr.co.matpam.admin.common.service.LoginVO;

/**
 * [CRITICAL-OVERRIDE] 
 * 라이브러리 내부의 SysChannelController를 대체하기 위한 소스 기반 컨트롤러입니다.
 * 컴파일 에러 방지를 위해 외부 라이브러리 의존성(PlatformService)을 제거했습니다.
 */
@Controller
@RequestMapping("/admin/sysChannel")
public class ChannelController {

    @Resource(name = "channelService")
    private ChannelService channelService;

    @Resource(name = "companyService")
    private CompanyService companyService;

    /**
     * 채널 목록 조회
     */
    @RequestMapping("/channelList.do")
    public String selectChannelList(@ModelAttribute("searchVO") ChannelVO searchVO, ModelMap model) throws Exception {
        
        searchVO.setPageUnit(10);
        searchVO.setPageSize(10);

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
        paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
        paginationInfo.setPageSize(searchVO.getPageSize());

        searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        // 테넌트 정보는 인터셉터/AOP에서 처리됨

        List<ChannelVO> channelList = channelService.selectChannelList(searchVO);
        model.addAttribute("resultList", channelList);

        int totCnt = channelService.selectChannelListTotCnt(searchVO);
        paginationInfo.setTotalRecordCount(totCnt);
        model.addAttribute("paginationInfo", paginationInfo);
        
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/channel/ChannelList.jsp");
        model.addAttribute("currentMenu", "op_channel");
        model.addAttribute("pageTitle",   "채널 관리");

        return "layout/main";
    }

    @RequestMapping("/channelForm.do")
    public String channelForm(@ModelAttribute("searchVO") ChannelVO searchVO, ModelMap model) throws Exception {
        
        // Platform 리스트는 일단 빈 리스트로 처리 (컴파일 에러 방지)
        // model.addAttribute("platformList", platformService.selectPlatformList(new PlatformVO()));

        List<CompanyVO> companyList = companyService.selectCompanyListAll(new CompanyVO());
        model.addAttribute("companyList", companyList);

        if (searchVO.getChannelId() != null) {
            ChannelVO detail = channelService.selectChannelDetail(searchVO);
            model.addAttribute("channelVO", detail);
        } else {
            model.addAttribute("channelVO", new ChannelVO());
        }

        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/channel/ChannelForm.jsp");
        model.addAttribute("currentMenu", "op_channel");
        model.addAttribute("pageTitle",   "채널 관리");

        return "layout/main";
    }

    @RequestMapping("/saveChannel.ajax")
    @ResponseBody
    public Map<String, Object> saveChannel(@ModelAttribute("channelVO") ChannelVO channelVO,
                                           HttpServletRequest request) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
            if (loginVO != null && "CHANNEL_ADMIN".equals(loginVO.getMemberType())) {
                result.put("status", "FAIL");
                result.put("message", "소속 채널 담당자는 권한이 없습니다.");
                return result;
            }
            if (channelVO.getChannelId() != null && channelVO.getChannelId() > 0) {
                channelService.updateChannel(channelVO);
            } else {
                channelService.insertChannel(channelVO);
            }
            result.put("status", "SUCCESS");
        } catch (Exception e) {
            result.put("status", "FAIL");
            result.put("message", e.getMessage());
        }
        return result;
    }

    @RequestMapping("/deleteChannel.ajax")
    @ResponseBody
    public Map<String, Object> deleteChannel(@ModelAttribute("channelVO") ChannelVO channelVO,
                                              HttpServletRequest request) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            channelService.deleteChannel(channelVO);
            result.put("status", "SUCCESS");
        } catch (Exception e) {
            result.put("status", "FAIL");
            result.put("message", e.getMessage());
        }
        return result;
    }
}
