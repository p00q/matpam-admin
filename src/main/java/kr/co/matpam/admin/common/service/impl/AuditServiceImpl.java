package kr.co.matpam.admin.common.service.impl;

import kr.co.matpam.admin.common.service.AuditService;
import kr.co.matpam.admin.common.service.AuditVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service("auditService")
public class AuditServiceImpl extends EgovAbstractServiceImpl implements AuditService {

    @Resource(name = "auditMapper")
    private AuditMapper auditMapper;

    @Override
    public void log(AuditVO vo) throws Exception {
        auditMapper.insertAuditLog(vo);
    }
}
