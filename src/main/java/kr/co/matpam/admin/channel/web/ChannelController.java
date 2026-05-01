package kr.co.matpam.admin.channel.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import kr.co.matpam.admin.channel.service.ChannelService;
import kr.co.matpam.admin.channel.service.ChannelVO;
import kr.co.matpam.admin.channel.service.PlatformService;
import kr.co.matpam.admin.channel.service.PlatformVO;
import kr.co.matpam.admin.company.service.CompanyService;
import kr.co.matpam.admin.company.service.CompanyVO;

@Controller
@RequestMapping("/admin/channel")
public class ChannelController {

    @Resource(name = "channelService")
    private ChannelService channelService;

    @Resource(name = "platformService")
    private PlatformService platformService;

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

        List<ChannelVO> channelList = channelService.selectChannelList(searchVO);
        model.addAttribute("resultList", channelList);

        int totCnt = channelService.selectChannelListTotCnt(searchVO);
        paginationInfo.setTotalRecordCount(totCnt);
        model.addAttribute("paginationInfo", paginationInfo);

        return "admin/channel/ChannelList";
    }

    /**
     * 채널 등록/수정 폼
     */
    @RequestMapping("/channelForm.do")
    public String channelForm(@ModelAttribute("searchVO") ChannelVO searchVO, ModelMap model) throws Exception {
        
        // 플랫폼 목록 (공통)
        List<PlatformVO> platformList = platformService.selectPlatformList(new PlatformVO());
        model.addAttribute("platformList", platformList);

        // 업체 목록 (본인 테넌트 소속)
        List<CompanyVO> companyList = companyService.selectCompanyListAll(new CompanyVO());
        model.addAttribute("companyList", companyList);

        if (searchVO.getChannelId() != null) {
            ChannelVO detail = channelService.selectChannelDetail(searchVO);
            model.addAttribute("channelVO", detail);
        } else {
            model.addAttribute("channelVO", new ChannelVO());
        }

        return "admin/channel/ChannelForm";
    }

    /**
     * 채널 저장 (AJAX)
     */
    @RequestMapping("/saveChannel.ajax")
    @ResponseBody
    public Map<String, Object> saveChannel(@ModelAttribute("channelVO") ChannelVO channelVO) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
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

    /**
     * 채널 삭제 (AJAX)
     */
    @RequestMapping("/deleteChannel.ajax")
    @ResponseBody
    public Map<String, Object> deleteChannel(@ModelAttribute("channelVO") ChannelVO channelVO) throws Exception {
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
