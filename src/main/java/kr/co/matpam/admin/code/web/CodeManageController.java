package kr.co.matpam.admin.code.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.matpam.admin.code.service.CodeManagementService;
import kr.co.matpam.admin.code.service.CodeVO;
import kr.co.matpam.admin.code.service.DetailCodeVO;
import kr.co.matpam.admin.code.service.GroupCodeVO;

/**
 * 공통코드 관리 Controller
 */
@Controller
public class CodeManageController {

    private static final Logger LOGGER = LoggerFactory.getLogger(CodeManageController.class);

    @Resource(name = "codeManagementService")
    private CodeManagementService codeManagementService;

    /**
     * 공통코드 관리 화면
     */
    @RequestMapping(value = { "/admin/basic/codeManage.do", "/admin/basic/basicList.do" })
    public String codeManage(ModelMap model) throws Exception {
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/code/CodeManage.jsp");
        return "layout/main";
    }

    /**
     * 그룹코드 목록 조회
     */
    @RequestMapping(value = "/admin/basic/selectGroupCodeList.ajax", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public Map<String, Object> selectGroupCodeList(GroupCodeVO searchVO) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<GroupCodeVO> list = codeManagementService.selectGroupCodeList(searchVO);
            result.put("success", true);
            result.put("list", list);
        } catch (Exception e) {
            LOGGER.error("그룹코드 조회 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 그룹코드 저장
     */
    @RequestMapping(value = "/admin/basic/saveGroupCode.ajax", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public Map<String, Object> saveGroupCode(GroupCodeVO vo) {
        Map<String, Object> result = new HashMap<>();
        try {
            codeManagementService.saveGroupCode(vo);
            result.put("success", true);
        } catch (Exception e) {
            LOGGER.error("그룹코드 저장 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 그룹코드 삭제
     */
    @RequestMapping(value = "/admin/basic/deleteGroupCode.ajax", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteGroupCode(@RequestParam("groupCode") String groupCode) {
        Map<String, Object> result = new HashMap<>();
        try {
            codeManagementService.deleteGroupCode(groupCode);
            result.put("success", true);
        } catch (Exception e) {
            LOGGER.error("그룹코드 삭제 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 코드 목록 조회
     */
    @RequestMapping(value = "/admin/basic/selectCodeList.ajax", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public Map<String, Object> selectCodeList(CodeVO searchVO) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<CodeVO> list = codeManagementService.selectCodeList(searchVO.getGroupCode());
            result.put("success", true);
            result.put("list", list);
        } catch (Exception e) {
            LOGGER.error("코드 조회 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 코드 검색 (필터링)
     */
    @RequestMapping(value = "/admin/basic/searchCodeList.ajax", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public Map<String, Object> searchCodeList(CodeVO searchVO) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<CodeVO> list = codeManagementService.searchCodeList(searchVO);
            result.put("success", true);
            result.put("list", list);
        } catch (Exception e) {
            LOGGER.error("코드 검색 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 상세코드 검색 (필터링)
     */
    @RequestMapping(value = "/admin/basic/searchDetailCodeList.ajax", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public Map<String, Object> searchDetailCodeList(DetailCodeVO searchVO) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<DetailCodeVO> list = codeManagementService.searchDetailCodeList(searchVO);
            result.put("success", true);
            result.put("list", list);
        } catch (Exception e) {
            LOGGER.error("상세코드 검색 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 코드 저장
     */
    @RequestMapping(value = "/admin/basic/saveCode.ajax", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public Map<String, Object> saveCode(CodeVO vo) {
        Map<String, Object> result = new HashMap<>();
        try {
            codeManagementService.saveCode(vo);
            result.put("success", true);
        } catch (Exception e) {
            LOGGER.error("코드 저장 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 상세코드 목록 조회
     */
    @RequestMapping(value = "/admin/basic/selectDetailCodeList.ajax", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public Map<String, Object> selectDetailCodeList(DetailCodeVO searchVO) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<DetailCodeVO> list = codeManagementService.selectDetailCodeList(searchVO.getGroupCode(),
                    searchVO.getCode());
            result.put("success", true);
            result.put("list", list);
        } catch (Exception e) {
            LOGGER.error("상세코드 조회 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 상세코드 저장
     */
    @RequestMapping(value = "/admin/basic/saveDetailCode.ajax", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public Map<String, Object> saveDetailCode(DetailCodeVO vo) {
        Map<String, Object> result = new HashMap<>();
        try {
            codeManagementService.saveDetailCode(vo);
            result.put("success", true);
        } catch (Exception e) {
            LOGGER.error("상세코드 저장 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }
}
