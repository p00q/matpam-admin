package kr.co.matpam.admin.company.service.impl;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import kr.co.matpam.admin.company.service.CompanyContactVO;
import kr.co.matpam.admin.company.service.CompanyVO;

/**
 * 업체 관리 Mapper
 */
@Mapper("companyMapper")
public interface CompanyMapper {

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
    void clearPrimaryContact(CompanyContactVO vo) throws Exception;

    /* ── 중복 체크 및 채널 매핑 ── */
    int selectBusinessNoCount(CompanyVO vo) throws Exception;
    void insertCompanyChannelMap(java.util.Map<String, Object> map) throws Exception;
    void deleteCompanyChannelMap(Long companyId) throws Exception;
    List<java.util.Map<String, Object>> selectCompanyChannelList(Long companyId) throws Exception;

    /* ── 계좌 ── */
    List<kr.co.matpam.admin.company.service.CompanyBankAccountVO> selectCompanyBankAccountList(Long companyId) throws Exception;
    void insertCompanyBankAccount(kr.co.matpam.admin.company.service.CompanyBankAccountVO vo) throws Exception;
    void updateCompanyBankAccount(kr.co.matpam.admin.company.service.CompanyBankAccountVO vo) throws Exception;
    void deleteCompanyBankAccount(Long bankAccountId) throws Exception;
}
