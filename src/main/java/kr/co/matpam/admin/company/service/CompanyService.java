package kr.co.matpam.admin.company.service;

import java.util.List;

/**
 * 업체 관리 서비스 인터페이스
 */
public interface CompanyService {

    /* ── 업체 ── */
    List<CompanyVO> selectCompanyList(CompanyVO vo) throws Exception;
    List<CompanyVO> selectCompanyListAll(CompanyVO vo) throws Exception;
    int selectCompanyListTotCnt(CompanyVO vo) throws Exception;
    CompanyVO selectCompanyDetail(CompanyVO vo) throws Exception;
    void insertCompany(CompanyVO vo) throws Exception;
    void updateCompany(CompanyVO vo) throws Exception;
    void updateCompanyStatus(CompanyVO vo) throws Exception;
    List<CompanyVO> selectCompanySearch(CompanyVO vo) throws Exception;

    /* ── 담당자 ── */
    List<CompanyContactVO> selectCompanyContactList(CompanyVO vo) throws Exception;
    CompanyContactVO selectCompanyContact(CompanyContactVO vo) throws Exception;
    void insertCompanyContact(CompanyContactVO vo) throws Exception;
    void updateCompanyContact(CompanyContactVO vo) throws Exception;
    void deleteCompanyContact(CompanyContactVO vo) throws Exception;
    void updatePrimaryContact(Long companyId, Long contactId) throws Exception;
    
    /** 사용자 정보를 업체 담당자로 동기화 */
    void syncContactFromUser(CompanyContactVO vo) throws Exception;

    /* ── 계좌 ── */
    List<CompanyBankAccountVO> selectCompanyBankAccountList(Long companyId) throws Exception;
    void saveCompanyBankAccount(CompanyBankAccountVO vo) throws Exception;
    void deleteCompanyBankAccount(Long bankAccountId) throws Exception;

    /* ── 중복 체크 및 채널 매핑 ── */
    boolean checkBusinessNoDuplicate(Long tenantId, String businessNo, Long excludeCompanyId) throws Exception;
    void saveCompanyChannelMappings(Long tenantId, Long companyId, java.util.List<java.util.Map<String, Object>> channels) throws Exception;
    List<java.util.Map<String, Object>> selectCompanyChannelList(Long companyId) throws Exception;
}
