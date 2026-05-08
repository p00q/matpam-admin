package kr.co.matpam.admin.company.service.impl;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import javax.annotation.Resource;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.matpam.admin.company.service.CompanyBankAccountVO;
import kr.co.matpam.admin.company.service.CompanyContactVO;
import kr.co.matpam.admin.company.service.CompanyService;
import kr.co.matpam.admin.company.service.CompanyVO;
import kr.co.matpam.admin.common.service.AuditService;
import kr.co.matpam.admin.common.service.AuditVO;
import kr.co.matpam.common.util.EncryptionUtil;

/**
 * 업체 관리 서비스 구현체
 */
@Service("companyService")
public class CompanyServiceImpl extends EgovAbstractServiceImpl implements CompanyService {

    @Resource(name = "companyMapper")
    private CompanyMapper companyMapper;

    @Resource(name = "auditService")
    private AuditService auditService;

    /* ── 업체 ── */

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
    @Transactional
    public void insertCompany(CompanyVO vo) throws Exception {
        companyMapper.insertCompany(vo);
        logAudit(vo.getTenantId(), "COMPANY", vo.getCompanyId(), "INSERT", null, "New company registered: " + vo.getCompanyName());
    }

    @Override
    @Transactional
    public void updateCompany(CompanyVO vo) throws Exception {
        companyMapper.updateCompany(vo);
        logAudit(vo.getTenantId(), "COMPANY", vo.getCompanyId(), "UPDATE", null, "Company info updated: " + vo.getCompanyName());
    }

    @Override
    @Transactional
    public void updateCompanyStatus(CompanyVO vo) throws Exception {
        companyMapper.updateCompanyStatus(vo);
        logAudit(vo.getTenantId(), "COMPANY", vo.getCompanyId(), "UPDATE", null, "Company status changed to " + vo.getStatus());
    }

    @Override
    public List<CompanyVO> selectCompanySearch(CompanyVO vo) throws Exception {
        return companyMapper.selectCompanySearch(vo);
    }

    /* ── 담당자 ── */

    @Override
    public List<CompanyContactVO> selectCompanyContactList(CompanyVO vo) throws Exception {
        return companyMapper.selectCompanyContactList(vo);
    }

    @Override
    public CompanyContactVO selectCompanyContact(CompanyContactVO vo) throws Exception {
        return companyMapper.selectCompanyContact(vo);
    }

    @Override
    @Transactional
    public void insertCompanyContact(CompanyContactVO vo) throws Exception {
        if ("Y".equals(vo.getIsPrimary())) {
            CompanyContactVO clearParam = new CompanyContactVO();
            clearParam.setCompanyId(vo.getCompanyId());
            companyMapper.clearPrimaryContact(clearParam);
        }
        companyMapper.insertCompanyContact(vo);
        logAudit(null, "COMPANY_CONTACT", vo.getContactId(), "INSERT", null, "New contact registered: " + vo.getContactName());
    }

    @Override
    @Transactional
    public void updateCompanyContact(CompanyContactVO vo) throws Exception {
        if ("Y".equals(vo.getIsPrimary())) {
            CompanyContactVO clearParam = new CompanyContactVO();
            clearParam.setCompanyId(vo.getCompanyId());
            companyMapper.clearPrimaryContact(clearParam);
        }
        companyMapper.updateCompanyContact(vo);
        logAudit(null, "COMPANY_CONTACT", vo.getContactId(), "UPDATE", null, "Contact info updated: " + vo.getContactName());
    }

    @Override
    @Transactional
    public void deleteCompanyContact(CompanyContactVO vo) throws Exception {
        companyMapper.deleteCompanyContact(vo);
        logAudit(null, "COMPANY_CONTACT", vo.getContactId(), "DELETE", null, "Contact deleted (Inactivated)");
    }

    /* ── 계좌 ── */

    @Override
    public List<CompanyBankAccountVO> selectCompanyBankAccountList(Long companyId) throws Exception {
        List<CompanyBankAccountVO> list = companyMapper.selectCompanyBankAccountList(companyId);
        // 복호화는 필요 시점에 수행 (보안상 리스트 조회 시에는 마스킹된 정보만 보여주는 것이 좋음)
        return list;
    }

    @Override
    @Transactional
    public void saveCompanyBankAccount(CompanyBankAccountVO vo) throws Exception {
        String plainAccountNo = vo.getAccountNoEnc();
        
        // 보안 처리
        vo.setAccountNoEnc(EncryptionUtil.encrypt(plainAccountNo));
        vo.setAccountNoHash(EncryptionUtil.hash(plainAccountNo));
        if (plainAccountNo.length() >= 4) {
            vo.setAccountNoLast4(plainAccountNo.substring(plainAccountNo.length() - 4));
        } else {
            vo.setAccountNoLast4(plainAccountNo);
        }
        vo.setEncKeyVersion(EncryptionUtil.getKeyVersion());

        if (vo.getBankAccountId() == null || vo.getBankAccountId() == 0) {
            companyMapper.insertCompanyBankAccount(vo);
            logAudit(null, "COMPANY_BANK_ACCOUNT", vo.getBankAccountId(), "INSERT", null, "New bank account registered");
        } else {
            companyMapper.updateCompanyBankAccount(vo);
            logAudit(null, "COMPANY_BANK_ACCOUNT", vo.getBankAccountId(), "UPDATE", null, "Bank account info updated");
        }
    }

    @Override
    @Transactional
    public void deleteCompanyBankAccount(Long bankAccountId) throws Exception {
        companyMapper.deleteCompanyBankAccount(bankAccountId);
        logAudit(null, "COMPANY_BANK_ACCOUNT", bankAccountId, "DELETE", null, "Bank account deleted (Inactivated)");
    }

    /* ── 중복 체크 및 채널 매핑 ── */

    @Override
    public boolean checkBusinessNoDuplicate(Long tenantId, String businessNo, Long excludeCompanyId) throws Exception {
        CompanyVO vo = new CompanyVO();
        vo.setTenantId(tenantId);
        vo.setBusinessNo(businessNo);
        vo.setCompanyId(excludeCompanyId);
        return companyMapper.selectBusinessNoCount(vo) > 0;
    }

    @Override
    @Transactional
    public void saveCompanyChannelMappings(Long tenantId, Long companyId, List<Map<String, Object>> channels) throws Exception {
        companyMapper.deleteCompanyChannelMap(companyId);
        for (Map<String, Object> channel : channels) {
            Map<String, Object> param = new HashMap<>();
            param.put("tenantId", tenantId);
            param.put("companyId", companyId);
            param.put("channelId", channel.get("channelId"));
            param.put("companyRoleCd", channel.get("companyRoleCd"));
            companyMapper.insertCompanyChannelMap(param);
        }
        logAudit(tenantId, "COMPANY_CHANNEL_MAP", companyId, "UPDATE", null, "Channel mappings updated");
    }

    @Override
    public List<Map<String, Object>> selectCompanyChannelList(Long companyId) throws Exception {
        return companyMapper.selectCompanyChannelList(companyId);
    }

    private void logAudit(Long tenantId, String entityName, Long entityId, String action, String before, String after) {
        try {
            AuditVO audit = new AuditVO();
            audit.setTenantId(tenantId);
            audit.setEntityName(entityName);
            audit.setEntityId(entityId);
            audit.setActionType(action);
            audit.setBeforeJson(before);
            audit.setAfterJson("{\"message\":\"" + after + "\"}");
            auditService.log(audit);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
