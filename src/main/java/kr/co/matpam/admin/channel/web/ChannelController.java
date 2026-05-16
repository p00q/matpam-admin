package kr.co.matpam.admin.channel.web;

import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.matpam.admin.common.service.LoginVO;
import kr.co.matpam.admin.tenant.service.ChannelVO;
import kr.co.matpam.admin.tenant.service.SysChannelService;
import kr.co.matpam.admin.user.service.UserService;
import kr.co.matpam.admin.user.service.UserVO;

/**
 * Operational channel management.
 */
@Controller
@RequestMapping("/admin/sysChannel")
public class ChannelController {

    @Resource(name = "sysChannelService")
    private SysChannelService sysChannelService;

    @Resource(name = "userService")
    private UserService userService;

    @RequestMapping("/channelList.do")
    public String selectChannelList(@ModelAttribute("searchVO") ChannelVO searchVO,
            HttpServletRequest request, ModelMap model) throws Exception {

        applyCompanyScope(searchVO, getLoginVO(request));

        searchVO.setPageUnit(10);
        searchVO.setPageSize(10);

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
        paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
        paginationInfo.setPageSize(searchVO.getPageSize());

        searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        List<ChannelVO> channelList = sysChannelService.selectChannelList(searchVO);
        model.addAttribute("resultList", channelList);

        int totCnt = sysChannelService.selectChannelListTotCnt(searchVO);
        paginationInfo.setTotalRecordCount(totCnt);
        model.addAttribute("paginationInfo", paginationInfo);

        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/tenant/SysChannelList.jsp");
        model.addAttribute("currentMenu", "op_channel");
        model.addAttribute("pageTitle", "채널 관리");

        return "layout/main";
    }

    @RequestMapping("/channelForm.do")
    public String channelForm(@RequestParam(value = "channelId", required = false) Long channelId,
            @RequestParam(value = "companyId", required = false) Long companyId,
            HttpServletRequest request, ModelMap model) throws Exception {

        LoginVO loginVO = getLoginVO(request);
        ChannelVO channel = null;
        if (channelId != null) {
            channel = sysChannelService.selectChannelDetail(channelId);
            if (!isAccessibleCompany(channel, request)) {
                throw new IllegalArgumentException("접근 권한이 없는 채널입니다.");
            }
        }
        if (channel == null) {
            channel = new ChannelVO();
            channel.setCompanyId(resolveCompanyId(companyId, loginVO));
            channel.setStatus("ACTIVE");
        }
        if (channel.getCompanyId() == null) {
            channel.setCompanyId(resolveCompanyId(companyId, loginVO));
        }

        model.addAttribute("channel", channel);
        model.addAttribute("managerList", selectManagerList(channel.getCompanyId(), channel.getChannelId()));
        model.addAttribute("existingTypes", selectExistingTypes(channel.getCompanyId()));

        if ("Y".equals(request.getParameter("isModal"))) {
            return "admin/tenant/SysChannelForm";
        }

        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/tenant/SysChannelForm.jsp");
        model.addAttribute("currentMenu", "op_channel");
        model.addAttribute("pageTitle", "채널 정보 관리");
        return "layout/main";
    }

    @RequestMapping("/saveChannel.ajax")
    @ResponseBody
    public Map<String, Object> saveChannel(@ModelAttribute("channel") ChannelVO channel,
            HttpServletRequest request) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            LoginVO loginVO = getLoginVO(request);
            if (loginVO != null && "CHANNEL_ADMIN".equals(loginVO.getMemberType())) {
                result.put("status", "FAIL");
                result.put("message", "채널 담당자는 채널 정보를 저장할 권한이 없습니다.");
                return result;
            }

            applyCompanyScope(channel, loginVO);
            if (channel.getCompanyId() == null) {
                channel.setCompanyId(1L);
            }
            validateChannel(channel);
            validateChannelManager(channel);

            if (channel.getChannelId() != null && channel.getChannelId() > 0) {
                ChannelVO saved = sysChannelService.selectChannelDetail(channel.getChannelId());
                if (!isAccessibleCompany(saved, request)) {
                    throw new IllegalArgumentException("접근 권한이 없는 채널입니다.");
                }
                sysChannelService.updateChannel(channel);
            } else {
                sysChannelService.insertChannel(channel);
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
    public Map<String, Object> deleteChannel(@RequestParam("channelId") Long channelId,
            HttpServletRequest request) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            LoginVO loginVO = getLoginVO(request);
            if (loginVO != null && "CHANNEL_ADMIN".equals(loginVO.getMemberType())) {
                result.put("status", "FAIL");
                result.put("message", "채널 담당자는 채널 정보를 삭제할 권한이 없습니다.");
                return result;
            }
            ChannelVO saved = sysChannelService.selectChannelDetail(channelId);
            if (!isAccessibleCompany(saved, request)) {
                throw new IllegalArgumentException("접근 권한이 없는 채널입니다.");
            }
            sysChannelService.deleteChannel(channelId);
            result.put("status", "SUCCESS");
        } catch (Exception e) {
            result.put("status", "FAIL");
            result.put("message", e.getMessage());
        }
        return result;
    }

    private List<UserVO> selectManagerList(Long companyId, Long currentChannelId) throws Exception {
        UserVO search = new UserVO();
        search.setSearchCondition("OPERATOR");
        search.setUserRole("CHANNEL_ADMIN");
        search.setCompanyId(companyId);
        search.setFirstIndex(0);
        search.setRecordCountPerPage(1000);

        List<UserVO> users = userService.selectUserList(search);
        List<UserVO> result = new ArrayList<>();
        for (UserVO user : users) {
            Long assignedChannelId = user.getChannelId();
            if (assignedChannelId == null || assignedChannelId.equals(currentChannelId)) {
                result.add(user);
            }
        }
        return result;
    }

    private String selectExistingTypes(Long companyId) throws Exception {
        if (companyId == null) {
            return "";
        }
        ChannelVO search = new ChannelVO();
        search.setCompanyId(companyId);
        search.setFirstIndex(0);
        search.setRecordCountPerPage(1000);

        List<ChannelVO> channels = sysChannelService.selectChannelList(search);
        List<String> types = new ArrayList<>();
        for (ChannelVO item : channels) {
            if (item.getChannelType() != null && !types.contains(item.getChannelType())) {
                types.add(item.getChannelType());
            }
        }
        return String.join(",", types);
    }

    private void applyCompanyScope(ChannelVO vo, LoginVO loginVO) {
        if (loginVO != null && !isSuperAdmin(loginVO) && loginVO.getCompanyId() != null) {
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

    private void validateChannel(ChannelVO channel) {
        if (channel.getCompanyId() == null) {
            throw new IllegalArgumentException("운영업체 정보가 없습니다.");
        }
        if (channel.getChannelType() == null || channel.getChannelType().isEmpty()) {
            throw new IllegalArgumentException("채널 유형을 선택해 주세요.");
        }
        if (channel.getChannelName() == null || channel.getChannelName().trim().isEmpty()) {
            throw new IllegalArgumentException("채널명을 입력해 주세요.");
        }
        if (channel.getStatus() == null || channel.getStatus().isEmpty()) {
            channel.setStatus("ACTIVE");
        }
    }

    private void validateChannelManager(ChannelVO channel) throws Exception {
        if (channel.getManagerId() == null) {
            return;
        }

        UserVO param = new UserVO();
        param.setUserId(channel.getManagerId());
        UserVO manager = userService.selectUserDetail(param);
        if (manager == null) {
            throw new IllegalArgumentException("담당자 정보를 찾을 수 없습니다.");
        }
        if (!"CHANNEL_ADMIN".equals(manager.getUserRole())) {
            throw new IllegalArgumentException("채널 담당자는 채널 운영자만 지정할 수 있습니다.");
        }
        if (channel.getCompanyId() != null && manager.getCompanyId() != null
                && !channel.getCompanyId().equals(manager.getCompanyId())) {
            throw new IllegalArgumentException("다른 운영업체의 담당자는 지정할 수 없습니다.");
        }
        if (manager.getChannelId() != null) {
            Long currentChannelId = channel.getChannelId();
            if (currentChannelId == null || !manager.getChannelId().equals(currentChannelId)) {
                throw new IllegalArgumentException("이미 다른 채널에 배정된 담당자입니다.");
            }
        }
    }

    /**
     * 채널 담당자 신규 생성 (CHANNEL_ADMIN 계정)
     * - 채널 수정 폼에서 인라인으로 호출
     * - 계정 생성 후 userId/userName/loginId를 반환하여 드롭다운에 추가
     */
    @RequestMapping("/createChannelAdmin.ajax")
    @ResponseBody
    public Map<String, Object> createChannelAdmin(
            @RequestParam("companyId") Long companyId,
            @RequestParam("loginId") String loginId,
            @RequestParam("userName") String userName,
            @RequestParam(value = "password") String password,
            @RequestParam(value = "mobile", required = false) String mobile,
            @RequestParam(value = "email", required = false) String email,
            HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            LoginVO loginVO = getLoginVO(request);
            if (loginVO != null && "CHANNEL_ADMIN".equals(loginVO.getMemberType())) {
                result.put("status", "FAIL");
                result.put("message", "채널 담당자는 계정 생성 권한이 없습니다.");
                return result;
            }

            // 필수값 검증
            if (loginId == null || loginId.trim().isEmpty()) {
                throw new IllegalArgumentException("로그인 ID를 입력해 주세요.");
            }
            if (userName == null || userName.trim().isEmpty()) {
                throw new IllegalArgumentException("이름을 입력해 주세요.");
            }
            if (password == null || password.trim().isEmpty()) {
                throw new IllegalArgumentException("비밀번호를 입력해 주세요.");
            }

            // 로그인ID 중복 검사
            UserVO dup = userService.selectUserByLoginId(loginId.trim());
            if (dup != null) {
                throw new IllegalArgumentException("이미 사용 중인 로그인 ID입니다: " + loginId);
            }

            // CHANNEL_ADMIN 계정 생성
            UserVO newUser = new UserVO();
            newUser.setCompanyId(companyId);
            newUser.setLoginId(loginId.trim());
            newUser.setUserName(userName.trim());
            newUser.setMobile(mobile != null ? mobile.trim() : "");
            newUser.setEmail(email != null ? email.trim() : "");
            newUser.setPasswordHash(password.trim());
            newUser.setUserRole("CHANNEL_ADMIN");
            newUser.setStatus("ACTIVE");
            newUser.setTenantId(loginVO != null ? loginVO.getTenantId() : 1L);

            userService.insertUser(newUser);

            // 프론트엔드에서 드롭다운 옵션 추가에 사용할 정보 반환
            result.put("status", "SUCCESS");
            result.put("userId", newUser.getUserId());
            result.put("userName", newUser.getUserName());
            result.put("loginId", newUser.getLoginId());
        } catch (Exception e) {
            result.put("status", "FAIL");
            result.put("message", e.getMessage());
        }
        return result;
    }

    private Long resolveCompanyId(Long requestCompanyId, LoginVO loginVO) {
        if (loginVO != null && !isSuperAdmin(loginVO) && loginVO.getCompanyId() != null) {
            return loginVO.getCompanyId();
        }
        if (requestCompanyId != null) {
            return requestCompanyId;
        }
        return 1L;
    }

    private LoginVO getLoginVO(HttpServletRequest request) {
        return (LoginVO) request.getSession().getAttribute("loginVO");
    }

    private boolean isSuperAdmin(LoginVO loginVO) {
        return "SUPER_ADMIN".equals(loginVO.getMemberType())
                || "SUPER".equals(loginVO.getMemberType())
                || "SUPER".equals(loginVO.getRoleCd());
    }
}
