package kr.co.matpam.admin.user.service;

import java.util.List;
import java.util.Map;

import kr.co.matpam.admin.tenant.service.ChannelVO;
import kr.co.matpam.admin.tenant.service.TenantVO;

/**
 * 사용자 관리 서비스 인터페이스
 */
public interface UserService {

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

    /** 테넌트별 활성 채널 목록 */
    List<ChannelVO> selectChannelListByTenant(Long tenantId) throws Exception;

    /** 테넌트별 구매업체 목록 */
    List<Map<String, Object>> selectBuyerCompanyListByTenant(Long tenantId) throws Exception;

    /**
     * 회원 타입 + 테넌트 기준으로 폼 옵션을 한 번에 조회
     * 반환 맵 키: tenants, channels, buyerCompanies, sellerCompanyId
     */
    Map<String, Object> selectFormOptions(String userRole, Long tenantId) throws Exception;
}
