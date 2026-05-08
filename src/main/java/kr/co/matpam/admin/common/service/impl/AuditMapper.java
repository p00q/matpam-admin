package kr.co.matpam.admin.common.service.impl;

import kr.co.matpam.admin.common.service.AuditVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * 감사 로그(Audit Log) Mapper
 */
@Mapper("auditMapper")
public interface AuditMapper {
    void insertAuditLog(AuditVO vo) throws Exception;
}
