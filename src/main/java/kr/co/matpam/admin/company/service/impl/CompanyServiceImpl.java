package kr.co.matpam.admin.company.service.impl;

import java.util.List;
import javax.annotation.Resource;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;
import kr.co.matpam.admin.company.service.CompanyService;
import kr.co.matpam.admin.company.service.CompanyVO;
import kr.co.matpam.admin.company.service.CompanyContactVO;

/**
 * 업체 관리 서비스 구현체
 */
@Service("companyService")
public class CompanyServiceImpl extends EgovAbstractServiceImpl implements CompanyService {

    @Resource(name = "companyMapper")
    private CompanyMapper companyMapper;

    @Override
    public List<CompanyVO> selectCompanyList(CompanyVO vo) throws Exception {
        return companyMapper.selectCompanyList(vo);
    }

    @Override
    public List<CompanyVO> selectCompanyListAll(CompanyVO vo) throws Exception {
        return companyMapper.selectCompanyListAll(vo);
    }

    @Override
    public int selectCompanyListTotCnt(CompanyVO vo) throws Exception {
        return companyMapper.selectCompanyListTotCnt(vo);
    }

    @Override
    public CompanyVO selectCompanyDetail(CompanyVO vo) throws Exception {
        return companyMapper.selectCompanyDetail(vo);
    }

    @Override
    public void insertCompany(CompanyVO vo) throws Exception {
        companyMapper.insertCompany(vo);
    }

    @Override
    public void updateCompany(CompanyVO vo) throws Exception {
        companyMapper.updateCompany(vo);
    }

    @Override
    public void updateCompanyStatus(CompanyVO vo) throws Exception {
        companyMapper.updateCompanyStatus(vo);
    }

    @Override
    public List<CompanyContactVO> selectCompanyContactList(CompanyVO vo) throws Exception {
        return companyMapper.selectCompanyContactList(vo);
    }

    @Override
    public void insertCompanyContact(CompanyContactVO vo) throws Exception {
        companyMapper.insertCompanyContact(vo);
    }

    @Override
    public void deleteCompanyContact(Long contactId) throws Exception {
        companyMapper.deleteCompanyContact(contactId);
    }
}
