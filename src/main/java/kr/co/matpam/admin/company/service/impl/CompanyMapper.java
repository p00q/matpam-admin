package kr.co.matpam.admin.company.service.impl;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import kr.co.matpam.admin.company.service.CompanyVO;
import kr.co.matpam.admin.company.service.CompanyContactVO;

/**
 * 업체 관리 Mapper
 */
@Mapper("companyMapper")
public interface CompanyMapper {

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
