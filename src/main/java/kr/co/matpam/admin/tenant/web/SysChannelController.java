package kr.co.matpam.admin.tenant.web;

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

import kr.co.matpam.admin.tenant.service.ChannelVO;
import kr.co.matpam.admin.tenant.service.SysChannelService;
import kr.co.matpam.admin.user.service.UserService;
import kr.co.matpam.admin.user.service.UserVO;
import kr.co.matpam.admin.common.service.LoginVO;
import kr.co.matpam.admin.company.service.CompanyService;
import kr.co.matpam.admin.company.service.CompanyVO;

@Controller
@RequestMapping("/admin/sysChannel")
public class SysChannelController {

    @Resource(name = "sysChannelService")
    private SysChannelService sysChannelService;

    @Resource(name = "userService")
    private UserService userService;

    @Resource(name = "companyService")
    private CompanyService companyService;

    @RequestMapping("/channelList.do")
    public String channelList(@ModelAttribute("searchVO") ChannelVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
        LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
        if (loginVO != null) {
            if (!"SUPER_ADMIN".equals(loginVO.getMemberType())) {
                searchVO.setCompanyId(loginVO.getCompanyId());
            }
        }

        searchVO.setPageUnit(10);
        searchVO.setPageSize(10);

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
        paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
        paginationInfo.setPageSize(searchVO.getPageSize());

        searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        List<ChannelVO> resultList = sysChannelService.selectChannelList(searchVO);
        model.addAttribute("resultList", resultList);

        int totCnt = sysChannelService.selectChannelListTotCnt(searchVO);
        paginationInfo.setTotalRecordCount(totCnt);
        model.addAttribute("paginationInfo", paginationInfo);
        
        // 담당자 콤보박스용 유저 목록 (해당 업체의 운영자 등)
        UserVO userVO = new UserVO();
        userVO.setCompanyId(searchVO.getCompanyId());
        userVO.setFirstIndex(0);
        userVO.setRecordCountPerPage(100); // 100명까지만 가져온다고 가정
        List<UserVO> managerList = userService.selectUserList(userVO);
        model.addAttribute("managerList", managerList);

        if (loginVO != null && ("SUPER_ADMIN".equals(loginVO.getMemberType()) || "SUPER".equals(loginVO.getMemberType()) || "SUPER".equals(loginVO.getRoleCd()))) {
            CompanyVO compVO = new CompanyVO();
            compVO.setFirstIndex(0);
            compVO.setRecordCountPerPage(1000); // 1000명까지만
            List<CompanyVO> companyList = companyService.selectCompanyList(compVO);
            model.addAttribute("companyList", companyList);
        }
        model.addAttribute("currentMenu", "op_channel");
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/tenant/SysChannelList.jsp");

        return "layout/main";
    }

    @RequestMapping("/saveChannel.ajax")
    @ResponseBody
    public Map<String, Object> saveChannel(@ModelAttribute("channelVO") ChannelVO channelVO, HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            LoginVO loginVO = (LoginVO) request.getSession().getAttribute("loginVO");
            if (loginVO != null) {
                if (!("SUPER_ADMIN".equals(loginVO.getMemberType()) || "SUPER".equals(loginVO.getMemberType()) || "SUPER".equals(loginVO.getRoleCd()))) {
                    channelVO.setCompanyId(loginVO.getCompanyId());
                }
            }

            if (channelVO.getChannelId() != null && channelVO.getChannelId() > 0) {
                sysChannelService.updateChannel(channelVO);
            } else {
                sysChannelService.insertChannel(channelVO);
            }
            result.put("status", "SUCCESS");
        } catch (org.springframework.dao.DuplicateKeyException e) {
            result.put("status", "FAIL");
            result.put("message", "해당 업체에 이미 동일한 채널 유형이 등록되어 있습니다.");
        } catch (Exception e) {
            result.put("status", "FAIL");
            result.put("message", e.getMessage());
        }
        return result;
    }

    @RequestMapping("/deleteChannel.ajax")
    @ResponseBody
    public Map<String, Object> deleteChannel(@ModelAttribute("channelVO") ChannelVO channelVO) {
        Map<String, Object> result = new HashMap<>();
        try {
            sysChannelService.deleteChannel(channelVO.getChannelId());
            result.put("status", "SUCCESS");
        } catch (Exception e) {
            result.put("status", "FAIL");
            result.put("message", e.getMessage());
        }
        return result;
    }
}
