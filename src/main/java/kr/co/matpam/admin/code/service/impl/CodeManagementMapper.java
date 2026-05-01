package kr.co.matpam.admin.code.service.impl;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import org.apache.ibatis.annotations.Param;

import kr.co.matpam.admin.code.service.CodeVO;
import kr.co.matpam.admin.code.service.DetailCodeVO;
import kr.co.matpam.admin.code.service.GroupCodeVO;

/**
 * 코드관리 Mapper 인터페이스
 */
@Mapper("codeManagementMapper")
public interface CodeManagementMapper {

    // ========== 그룹코드 ==========
    List<GroupCodeVO> selectGroupCodeList(GroupCodeVO searchVO) throws Exception;

    GroupCodeVO selectGroupCode(String groupCode) throws Exception;

    void insertGroupCode(GroupCodeVO vo) throws Exception;

    void updateGroupCode(GroupCodeVO vo) throws Exception;

    void deleteGroupCode(String groupCode) throws Exception;

    void deleteCodesByGroup(String groupCode) throws Exception;

    void deleteDetailCodesByGroup(String groupCode) throws Exception;

    // ========== 코드 ==========
    List<CodeVO> selectCodeList(String groupCode) throws Exception;

    List<CodeVO> searchCodeList(CodeVO searchVO) throws Exception;

    CodeVO selectCode(@Param("groupCode") String groupCode, @Param("code") String code) throws Exception;

    void insertCode(CodeVO vo) throws Exception;

    void updateCode(CodeVO vo) throws Exception;

    void deleteCode(@Param("groupCode") String groupCode, @Param("code") String code) throws Exception;

    void deleteDetailCodesByCode(@Param("groupCode") String groupCode, @Param("code") String code) throws Exception;

    // ========== 상세코드 ==========
    List<DetailCodeVO> selectDetailCodeList(@Param("groupCode") String groupCode, @Param("code") String code) throws Exception;

    List<DetailCodeVO> searchDetailCodeList(DetailCodeVO searchVO) throws Exception;

    DetailCodeVO selectDetailCode(@Param("groupCode") String groupCode, @Param("code") String code, @Param("detailCode") String detailCode) throws Exception;

    void insertDetailCode(DetailCodeVO vo) throws Exception;

    void updateDetailCode(DetailCodeVO vo) throws Exception;

    void deleteDetailCode(@Param("groupCode") String groupCode, @Param("code") String code, @Param("detailCode") String detailCode) throws Exception;

    void reorderCodeSortOrder() throws Exception;

    void reorderDetailCodeSortOrder() throws Exception;
}
