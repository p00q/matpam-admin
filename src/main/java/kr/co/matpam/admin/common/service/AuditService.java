package kr.co.matpam.admin.common.service;

/**
 * 감사 로그(Audit Log) Service
 */
public interface AuditService {
    void log(AuditVO vo) throws Exception;
}
