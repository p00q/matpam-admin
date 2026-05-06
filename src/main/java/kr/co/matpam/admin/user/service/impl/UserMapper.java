package kr.co.matpam.admin.user.service.impl;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import kr.co.matpam.admin.tenant.service.ChannelVO;
import kr.co.matpam.admin.tenant.service.TenantVO;
import kr.co.matpam.admin.user.service.UserVO;

/**
 * 사용자 관리 Mapper
 */
@Mapper("userMapper")
public interface UserMapper {

    // ── 사용자 CRUD ──────────────────────────────────────────────────

    List<UserVO> selectUserList(UserVO vo) throws Exception;

    int selectUserListTotCnt(UserVO vo) throws Exception;

    UserVO selectUserDetail(UserVO vo) throws Exception;

    void insertUser(UserVO vo) throws Exception;

    void updateUser(UserVO vo) throws Exception;

    void updateUserStatus(UserVO vo) throws Exception;

    UserVO selectUserByLoginId(String loginId) throws Exception;

    // ── 폼 옵션 조회 ──────────────────────────────────────────────────

    /** 활성 테넌트 목록 */
    List<TenantVO> selectActiveTenantList() throws Exception;

    /** 특정 테넌트의 활성 채널 목록 */
    List<ChannelVO> selectChannelListByTenant(Long tenantId) throws Exception;

    /** 특정 테넌트의 구매업체 목록 (company_type = BUYER) */
    List<Map<String, Object>> selectBuyerCompanyListByTenant(Long tenantId) throws Exception;

    /** 테넌트의 대표 판매업체 ID 조회 (seller_company_id) */
    Long selectSellerCompanyIdByTenant(Long tenantId) throws Exception;

    // ── 담당자 동시 생성 ──────────────────────────────────────────────

    /** 업체 담당자(tb_company_contact) 등록 */
    void insertCompanyContact(Map<String, Object> param) throws Exception;
}
