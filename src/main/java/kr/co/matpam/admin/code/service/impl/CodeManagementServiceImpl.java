package kr.co.matpam.admin.code.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.matpam.admin.code.service.CodeManagementService;
import kr.co.matpam.admin.code.service.CodeVO;
import kr.co.matpam.admin.code.service.DetailCodeVO;
import kr.co.matpam.admin.code.service.GroupCodeVO;

/**
 * 코드관리 서비스 구현체
 */
@Service("codeManagementService")
public class CodeManagementServiceImpl implements CodeManagementService {

    @Resource(name = "codeManagementMapper")
    private CodeManagementMapper codeManagementMapper;

    // ========== 그룹코드 ==========
    @Override
    public List<GroupCodeVO> selectGroupCodeList(GroupCodeVO searchVO) throws Exception {
        return codeManagementMapper.selectGroupCodeList(searchVO);
    }

    @Override
    public void saveGroupCode(GroupCodeVO vo) throws Exception {
        GroupCodeVO existing = codeManagementMapper.selectGroupCode(vo.getGroupCode());
        if (existing == null) {
            codeManagementMapper.insertGroupCode(vo);
        } else {
            codeManagementMapper.updateGroupCode(vo);
        }
    }

    @Override
    public void deleteGroupCode(String groupCode) throws Exception {
        codeManagementMapper.deleteGroupCode(groupCode);
    }

    // ========== 코드 ==========
    @Override
    public List<CodeVO> selectCodeList(String groupCode) throws Exception {
        return codeManagementMapper.selectCodeList(groupCode);
    }

    @Override
    public List<CodeVO> searchCodeList(CodeVO searchVO) throws Exception {
        return codeManagementMapper.searchCodeList(searchVO);
    }

    @Override
    public void saveCode(CodeVO vo) throws Exception {
        CodeVO existing = codeManagementMapper.selectCode(vo.getGroupCode(), vo.getCode());
        if (existing == null) {
            codeManagementMapper.insertCode(vo);
        } else {
            codeManagementMapper.updateCode(vo);
        }
    }

    @Override
    public void deleteCode(String groupCode, String code) throws Exception {
        codeManagementMapper.deleteCode(groupCode, code);
    }

    // ========== 상세코드 ==========
    @Override
    public List<DetailCodeVO> selectDetailCodeList(String groupCode, String code) throws Exception {
        return codeManagementMapper.selectDetailCodeList(groupCode, code);
    }

    @Override
    public List<DetailCodeVO> searchDetailCodeList(DetailCodeVO searchVO) throws Exception {
        return codeManagementMapper.searchDetailCodeList(searchVO);
    }

    @Override
    public void saveDetailCode(DetailCodeVO vo) throws Exception {
        DetailCodeVO existing = codeManagementMapper.selectDetailCode(
                vo.getGroupCode(), vo.getCode(), vo.getDetailCode());
        if (existing == null) {
            codeManagementMapper.insertDetailCode(vo);
        } else {
            codeManagementMapper.updateDetailCode(vo);
        }
    }

    @Override
    public void deleteDetailCode(String groupCode, String code, String detailCode) throws Exception {
        codeManagementMapper.deleteDetailCode(groupCode, code, detailCode);
    }
}
