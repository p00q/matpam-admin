package kr.co.matpam.admin.tenant.service.impl;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import kr.co.matpam.admin.tenant.service.TenantVO;

/**
 * 테넌트 관리 Mapper
 */
@Mapper("tenantMapper")
public interface TenantMapper {

    List<TenantVO> selectTenantList(TenantVO vo) throws Exception;

    int selectTenantListTotCnt(TenantVO vo) throws Exception;

    TenantVO selectTenantDetail(TenantVO vo) throws Exception;

    void insertTenant(TenantVO vo) throws Exception;

    void updateTenant(TenantVO vo) throws Exception;
}
