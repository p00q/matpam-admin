package kr.co.matpam.admin.channel.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringJoiner;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.matpam.admin.common.service.LoginVO;
import kr.co.matpam.admin.tenant.service.ChannelVO;
import kr.co.matpam.admin.tenant.service.SysChannelService;
import kr.co.matpam.admin.user.service.UserService;
import kr.co.matpam.admin.user.service.UserVO;

@Controller
@RequestMapping("/admin/sysChannel")
public class ChannelController {

    @Resource(name = "sysChannelService")
    private SysChannelService sysChannelService;

    @Resource(name = "userService")
    private UserService userService;

    @RequestMapping("/channelList.do")
    public String selectChannelList(@ModelAttribute("searchVO") ChannelVO searchVO,
                                    HttpServletRequest request,
                                    ModelMap model) throws Exception {

        searchVO.setPageUnit(10);
        searchVO.setPageSize(10);
        applyOperatorScope(searchVO, request);

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
        paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
        paginationInfo.setPageSize(searchVO.getPageSize());

        searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        List<ChannelVO> channelList = sysChannelService.selectChannelList(searchVO);
        int totalCount = sysChannelService.selectChannelListTotCnt(searchVO);
        paginationInfo.setTotalRecordCount(totalCount);

        model.addAttribute("resultList", channelList);
        model.addAttribute("paginationInfo", paginationInfo);
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/tenant/SysChannelList.jsp");
        model.addAttribute("currentMenu", "op_channel");
        model.addAttribute("pageTitle", "채널 관리");

        return "layout/main";
    }

    @RequestMapping("/channelForm.do")
    public String channelForm(@ModelAttribute("searchVO") ChannelVO searchVO,
                              HttpServletRequest request,
                              ModelMap model) throws Exception {

        applyOperatorScope(searchVO, request);

        ChannelVO channel;
        if (searchVO.getChannelId() != null) {
            channel = sysChannelService.selectChannelDetail(searchVO.getChannelId());
            if (!isAccessibleCompany(channel, request)) {
                throw new IllegalArgumentException("접근 권한이 없는 채널입니다.");
            }
        } else {
            channel = new ChannelVO();
            channel.setCompanyId(searchVO.getCompanyId());
            channel.setStatus("ACTIVE");
        }

        if (channel != null && channel.getCompanyId() == null) {
            channel.setCompanyId(searchVO.getCompanyId());
        }

        model.addAttribute("channel", channel);
        model.addAttribute("managerList", selectManagerList(request, channel != null ? channel.getChannelId() : null));
        model.addAttribute("existingTypes", selectExistingTypes(searchVO, channel));
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/tenant/SysChannelForm.jsp");
        model.addAttribute("currentMenu", "op_channel");
        model.addAttribute("pageTitle", "채널 관리");

        return isModal(request) ? "admin/tenant/SysChannelForm" : "layout/main";
    }

    @RequestMapping("/saveChannel.ajax")
    @ResponseBody
    public Map<String, Object> saveChannel(@ModelAttribute("channel") ChannelVO channelVO,
                                           HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            LoginVO loginVO = getLoginVO(request);
            if (loginVO != null && "CHANNEL_ADMIN".equals(loginVO.getMemberType())) {
                result.put("status", "FAIL");
                result.put("message", "채널 담당자는 채널을 등록하거나 수정할 수 없습니다.");
                return result;
            }

            applyOperatorScope(channelVO, request);
            validateChannel(channelVO);
            validateChannelManager(channelVO);

            if (channelVO.getChannelId() != null && channelVO.getChannelId() > 0) {
                ChannelVO saved = sysChannelService.selectChannelDetail(channelVO.getChannelId());
                if (!isAccessibleCompany(saved, request)) {
                    throw new IllegalArgumentException("접근 권한이 없는 채널입니다.");
                }
                sysChannelService.updateChannel(channelVO);
            } else {
                sysChannelService.insertChannel(channelVO);
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
    public Map<String, Object> deleteChannel(@ModelAttribute("channel") ChannelVO channelVO,
                                             HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            LoginVO loginVO = getLoginVO(request);
            if (loginVO != null && "CHANNEL_ADMIN".equals(loginVO.getMemberType())) {
                result.put("status", "FAIL");
                result.put("message", "채널 담당자는 채널을 삭제할 수 없습니다.");
                return result;
            }
            if (channelVO.getChannelId() == null) {
                throw new IllegalArgumentException("채널 ID가 없습니다.");
            }

            ChannelVO saved = sysChannelService.selectChannelDetail(channelVO.getChannelId());
            if (!isAccessibleCompany(saved, request)) {
                throw new IllegalArgumentException("접근 권한이 없는 채널입니다.");
            }

            sysChannelService.deleteChannel(channelVO.getChannelId());
            result.put("status", "SUCCESS");
        } catch (Exception e) {
            result.put("status", "FAIL");
            result.put("message", e.getMessage());
        }
        return result;
    }

    private void applyOperatorScope(ChannelVO vo, HttpServletRequest request) {
        LoginVO loginVO = getLoginVO(request);
        if (vo == null || loginVO == null) {
            return;
        }
        if (!isSuperAdmin(loginVO)) {
            vo.setCompanyId(loginVO.getCompanyId());
        }
    }

    private boolean isAccessibleCompany(ChannelVO channel, HttpServletRequest request) {
        if (channel == null) {
            return false;
        }
        LoginVO loginVO = getLoginVO(request);
        return loginVO == null || isSuperAdmin(loginVO)
                || (channel.getCompanyId() != null && channel.getCompanyId().equals(loginVO.getCompanyId()));
    }

    private List<UserVO> selectManagerList(HttpServletRequest request, Long currentChannelId) throws Exception {
        UserVO searchVO = new UserVO();
        searchVO.setSearchCondition("OPERATOR");
        searchVO.setUserRole("CHANNEL_ADMIN");
        searchVO.setFirstIndex(0);
        searchVO.setRecordCountPerPage(1000);

        LoginVO loginVO = getLoginVO(request);
        if (loginVO != null) {
            searchVO.setTenantId(resolveTenantId(loginVO));
            if (!isSuperAdmin(loginVO)) {
                searchVO.setCompanyId(loginVO.getCompanyId());
            }
        }

        List<UserVO> users = userService.selectUserList(searchVO);
        users.removeIf(user -> user.getChannelId() != null && !user.getChannelId().equals(currentChannelId));
        return users;
    }

    private String selectExistingTypes(ChannelVO searchVO, ChannelVO current) throws Exception {
        ChannelVO param = new ChannelVO();
        param.setCompanyId(current != null ? current.getCompanyId() : searchVO.getCompanyId());
        param.setFirstIndex(0);
        param.setRecordCountPerPage(1000);

        List<ChannelVO> channels = sysChannelService.selectChannelList(param);
        StringJoiner joiner = new StringJoiner(",");
        for (ChannelVO channel : channels) {
            if (channel.getChannelType() != null) {
                joiner.add(channel.getChannelType());
            }
        }
        return joiner.toString();
    }

    private void validateChannel(ChannelVO channelVO) {
        if (channelVO.getCompanyId() == null) {
            throw new IllegalArgumentException("운영업체 정보가 없습니다.");
        }
        if (channelVO.getChannelType() == null || channelVO.getChannelType().isEmpty()) {
            throw new IllegalArgumentException("채널 유형을 선택해 주세요.");
        }
        if (channelVO.getChannelName() == null || channelVO.getChannelName().trim().isEmpty()) {
            throw new IllegalArgumentException("채널명을 입력해 주세요.");
        }
        if (channelVO.getStatus() == null || channelVO.getStatus().isEmpty()) {
            channelVO.setStatus("ACTIVE");
        }
    }

    private void validateChannelManager(ChannelVO channelVO) throws Exception {
        if (channelVO.getManagerId() == null) {
            return;
        }

        UserVO param = new UserVO();
        param.setUserId(channelVO.getManagerId());
        UserVO manager = userService.selectUserDetail(param);
        if (manager == null) {
            throw new IllegalArgumentException("담당자 정보를 찾을 수 없습니다.");
        }
        if (!"CHANNEL_ADMIN".equals(manager.getUserRole())) {
            throw new IllegalArgumentException("채널 담당자는 채널 운영자만 지정할 수 있습니다.");
        }
        if (manager.getChannelId() != null) {
            Long currentChannelId = channelVO.getChannelId();
            if (currentChannelId == null || !manager.getChannelId().equals(currentChannelId)) {
                throw new IllegalArgumentException("이미 다른 채널에 배정된 담당자입니다.");
            }
        }
    }

    private LoginVO getLoginVO(HttpServletRequest request) {
        return (LoginVO) request.getSession().getAttribute("loginVO");
    }

    private boolean isSuperAdmin(LoginVO loginVO) {
        return "SUPER_ADMIN".equals(loginVO.getMemberType()) || "SUPER".equals(loginVO.getMemberType())
                || "SUPER".equals(loginVO.getRoleCd());
    }

    private Long resolveTenantId(LoginVO loginVO) {
        return loginVO.getTenantId() != null ? loginVO.getTenantId() : loginVO.getCompanyId();
    }

    private boolean isModal(HttpServletRequest request) {
        return "Y".equalsIgnoreCase(request.getParameter("isModal"));
    }
}
