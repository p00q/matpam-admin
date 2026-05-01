package kr.co.matpam.admin.code.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.matpam.admin.code.service.CodeManagementService;
import kr.co.matpam.admin.code.service.CodeVO;
import kr.co.matpam.admin.code.service.DetailCodeVO;
import kr.co.matpam.admin.code.service.GroupCodeVO;

/**
 * 코드관리 컨트롤러
 */
@Controller
public class CodeManagementController {

    @Resource(name = "codeManagementService")
    private CodeManagementService codeManagementService;

    /**
     * 코드관리 화면
     */
    @RequestMapping(value = "/admin/code/codeManagement.do")
    public String codeManagementView(ModelMap model) throws Exception {
        model.addAttribute("pageTitle", "시스템 설정");
        model.addAttribute("currentMenu", "code");
        model.addAttribute("contentPage", "/WEB-INF/jsp/admin/code/CodeManagement.jsp");
        return "layout/main";
    }

    /**
     * 그룹코드 목록 조회 (AJAX)
     */
    @RequestMapping(value = "/admin/code/groupCodeList.do")
    @ResponseBody
    public Map<String, Object> selectGroupCodeList(@ModelAttribute GroupCodeVO searchVO) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            List<GroupCodeVO> list = codeManagementService.selectGroupCodeList(searchVO);
            result.put("success", true);
            result.put("data", list);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 코드 목록 조회 (AJAX)
     */
    @RequestMapping(value = "/admin/code/codeList.do")
    @ResponseBody
    public Map<String, Object> selectCodeList(@RequestParam("groupCode") String groupCode) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            List<CodeVO> list = codeManagementService.selectCodeList(groupCode);
            result.put("success", true);
            result.put("data", list);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 상세코드 목록 조회 (AJAX)
     */
    @RequestMapping(value = "/admin/code/detailCodeList.do")
    @ResponseBody
    public Map<String, Object> selectDetailCodeList(
            @RequestParam("groupCode") String groupCode,
            @RequestParam("code") String code) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            List<DetailCodeVO> list = codeManagementService.selectDetailCodeList(groupCode, code);
            result.put("success", true);
            result.put("data", list);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 그룹코드 저장 (AJAX)
     */
    @RequestMapping(value = "/admin/code/saveGroupCode.do")
    @ResponseBody
    public Map<String, Object> saveGroupCode(@ModelAttribute GroupCodeVO vo) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            codeManagementService.saveGroupCode(vo);
            result.put("success", true);
            result.put("message", "저장되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 코드 저장 (AJAX)
     */
    @RequestMapping(value = "/admin/code/saveCode.do")
    @ResponseBody
    public Map<String, Object> saveCode(@ModelAttribute CodeVO vo) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            codeManagementService.saveCode(vo);
            result.put("success", true);
            result.put("message", "저장되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 상세코드 저장 (AJAX)
     */
    @RequestMapping(value = "/admin/code/saveDetailCode.do")
    @ResponseBody
    public Map<String, Object> saveDetailCode(@ModelAttribute DetailCodeVO vo) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            codeManagementService.saveDetailCode(vo);
            result.put("success", true);
            result.put("message", "저장되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 그룹코드 삭제 (AJAX)
     */
    @RequestMapping(value = "/admin/code/deleteGroupCode.do")
    @ResponseBody
    public Map<String, Object> deleteGroupCode(@RequestParam("groupCode") String groupCode) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            codeManagementService.deleteGroupCode(groupCode);
            result.put("success", true);
            result.put("message", "삭제되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 코드 삭제 (AJAX)
     */
    @RequestMapping(value = "/admin/code/deleteCode.do")
    @ResponseBody
    public Map<String, Object> deleteCode(
            @RequestParam("groupCode") String groupCode,
            @RequestParam("code") String code) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            codeManagementService.deleteCode(groupCode, code);
            result.put("success", true);
            result.put("message", "삭제되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 상세코드 삭제 (AJAX)
     */
    @RequestMapping(value = "/admin/code/deleteDetailCode.do")
    @ResponseBody
    public Map<String, Object> deleteDetailCode(
            @RequestParam("groupCode") String groupCode,
            @RequestParam("code") String code,
            @RequestParam("detailCode") String detailCode) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            codeManagementService.deleteDetailCode(groupCode, code, detailCode);
            result.put("success", true);
            result.put("message", "삭제되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @RequestMapping(value = "/admin/code/reorder.do")
    @ResponseBody
    public Map<String, Object> reorder() throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            codeManagementService.reorderSortOrder(); // Service에 추가해야 함
            result.put("success", true);
            result.put("message", "재정렬이 완료되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }
}
