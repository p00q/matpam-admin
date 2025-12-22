package kr.co.matpam.admin.code.service;

import java.util.List;

/**
 * 코드관리 서비스 인터페이스
 */
public interface CodeManagementService {

    // ========== 그룹코드 ==========
    /**
     * 그룹코드 목록 조회
     */
    List<GroupCodeVO> selectGroupCodeList(GroupCodeVO searchVO) throws Exception;

    /**
     * 그룹코드 저장 (INSERT/UPDATE)
     */
    void saveGroupCode(GroupCodeVO vo) throws Exception;

    /**
     * 그룹코드 삭제
     */
    void deleteGroupCode(String groupCode) throws Exception;

    // ========== 코드 ==========
    /**
     * 코드 목록 조회 (그룹코드별)
     */
    List<CodeVO> selectCodeList(String groupCode) throws Exception;

    /**
     * 코드 검색 (필터링)
     */
    List<CodeVO> searchCodeList(CodeVO searchVO) throws Exception;

    /**
     * 코드 저장 (INSERT/UPDATE)
     */
    void saveCode(CodeVO vo) throws Exception;

    /**
     * 코드 삭제
     */
    void deleteCode(String groupCode, String code) throws Exception;

    // ========== 상세코드 ==========
    /**
     * 상세코드 목록 조회 (코드별)
     */
    List<DetailCodeVO> selectDetailCodeList(String groupCode, String code) throws Exception;

    /**
     * 상세코드 검색 (필터링)
     */
    List<DetailCodeVO> searchDetailCodeList(DetailCodeVO searchVO) throws Exception;

    /**
     * 상세코드 저장 (INSERT/UPDATE)
     */
    void saveDetailCode(DetailCodeVO vo) throws Exception;

    /**
     * 상세코드 삭제
     */
    void deleteDetailCode(String groupCode, String code, String detailCode) throws Exception;
}
