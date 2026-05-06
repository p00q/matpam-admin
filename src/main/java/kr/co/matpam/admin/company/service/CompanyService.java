package kr.co.matpam.admin.company.service;

import java.util.List;

/**
 * 업체 관리 서비스 인터페이스
 */
public interface CompanyService {

    List<CompanyVO> selectCompanyList(CompanyVO vo) throws Exception;

    List<CompanyVO> selectCompanyListAll(CompanyVO vo) throws Exception;

    int selectCompanyListTotCnt(CompanyVO vo) throws Exception;

    CompanyVO selectCompanyDetail(CompanyVO vo) throws Exception;

    void insertCompany(CompanyVO vo) throws Exception;

    void updateCompany(CompanyVO vo) throws Exception;

    void updateCompanyStatus(CompanyVO vo) throws Exception;
    List<CompanyContactVO> selectCompanyContactList(CompanyVO vo) throws Exception;
    void insertCompanyContact(CompanyContactVO vo) throws Exception;
    void deleteCompanyContact(Long contactId) throws Exception;
}
