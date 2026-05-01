package kr.co.matpam.admin.common.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * 감사 로그(Audit Log) Mapper
 */
@Mapper("auditMapper")
public interface AuditMapper {

    void insertAuditLog(
        @Param("tenantId") Long tenantId,
        @Param("entityName") String entityName,
        @Param("actionType") String actionType,
        @Param("changedData") String changedData,
        @Param("status") String status,
        @Param("userId") Long userId
    ) throws Exception;
}
