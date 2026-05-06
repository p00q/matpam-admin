package kr.co.matpam.admin.user.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.matpam.admin.tenant.service.ChannelVO;
import kr.co.matpam.admin.tenant.service.TenantVO;
import kr.co.matpam.admin.user.service.UserService;
import kr.co.matpam.admin.user.service.UserVO;

/**
 * 사용자 관리 서비스 구현체
 * - USER_REG.md 기준 역할별 검증 로직 포함
 * - 담당자(tb_company_contact) 동시 생성 지원
 */
@Service("userService")
public class UserServiceImpl extends EgovAbstractServiceImpl implements UserService {

    @Resource(name = "userMapper")
    private UserMapper userMapper;

    @Resource(name = "bcryptPasswordEncoder")
    private BCryptPasswordEncoder passwordEncoder;

    // ─────────────────────────────────────────────────────────────────
    // 사용자 CRUD
    // ─────────────────────────────────────────────────────────────────

    @Override
    public List<UserVO> selectUserList(UserVO vo) throws Exception {
        return userMapper.selectUserList(vo);
    }

    @Override
    public int selectUserListTotCnt(UserVO vo) throws Exception {
        return userMapper.selectUserListTotCnt(vo);
    }

    @Override
    public UserVO selectUserDetail(UserVO vo) throws Exception {
        return userMapper.selectUserDetail(vo);
    }

    /**
     * 사용자 등록
     * USER_REG.md §9 저장 로직:
     *   1. 역할별 tenant/company/channel 조합 강제 세팅
     *   2. 로그인ID 중복 확인
     *   3. 비밀번호 해시 후 저장
     *   4. 담당자 동시 생성 옵션 처리
     */
    @Override
    @Transactional
    public void insertUser(UserVO vo) throws Exception {

        // ── 1. 역할별 조합 강제 세팅 ─────────────────────────────────
        applyRoleConstraints(vo);

        // ── 2. 로그인ID 중복 확인 ────────────────────────────────────
        if (userMapper.selectUserByLoginId(vo.getLoginId()) != null) {
            throw new IllegalArgumentException("USER_001:이미 사용 중인 로그인 ID입니다.");
        }

        // ── 3. 비밀번호 해시 ────────────────────────────────────────
        if (vo.getPasswordHash() == null || vo.getPasswordHash().isEmpty()) {
            throw new IllegalArgumentException("USER_002:비밀번호는 필수입니다.");
        }
        vo.setPasswordHash(passwordEncoder.encode(vo.getPasswordHash()));

        // ── 4. 사용자 저장 ──────────────────────────────────────────
        userMapper.insertUser(vo);

        // ── 5. 담당자 동시 생성 ──────────────────────────────────────
        if ("Y".equals(vo.getCreateContactYn()) && vo.getCompanyId() != null) {
            Map<String, Object> contactParam = new HashMap<>();
            contactParam.put("companyId",    vo.getCompanyId());
            contactParam.put("contactName",  vo.getUserName());
            contactParam.put("contactRole",  defaultContactRole(vo.getUserRole(), vo.getContactRole()));
            contactParam.put("mobile",       vo.getMobile());
            contactParam.put("email",        vo.getEmail());
            contactParam.put("isPrimary",    "Y".equals(vo.getIsPrimaryContact()) ? "Y" : "N");
            contactParam.put("linkedUserId", vo.getUserId());
            userMapper.insertCompanyContact(contactParam);
        }
    }

    /**
     * 사용자 수정
     * - 비밀번호는 입력된 경우에만 변경
     * - 역할 변경 시 조합 재검증
     */
    @Override
    @Transactional
    public void updateUser(UserVO vo) throws Exception {
        // 역할 변경이 포함될 수 있으므로 조합 재세팅
        applyRoleConstraints(vo);

        if (vo.getPasswordHash() != null && !vo.getPasswordHash().isEmpty()) {
            vo.setPasswordHash(passwordEncoder.encode(vo.getPasswordHash()));
        } else {
            vo.setPasswordHash(null); // XML update 에서 skip
        }
        userMapper.updateUser(vo);
    }

    @Override
    public void updateUserStatus(UserVO vo) throws Exception {
        userMapper.updateUserStatus(vo);
    }

    @Override
    public UserVO selectUserByLoginId(String loginId) throws Exception {
        return userMapper.selectUserByLoginId(loginId);
    }

    // ─────────────────────────────────────────────────────────────────
    // 폼 옵션 조회
    // ─────────────────────────────────────────────────────────────────

    @Override
    public List<TenantVO> selectActiveTenantList() throws Exception {
        return userMapper.selectActiveTenantList();
    }

    @Override
    public List<ChannelVO> selectChannelListByTenant(Long tenantId) throws Exception {
        return userMapper.selectChannelListByTenant(tenantId);
    }

    @Override
    public List<Map<String, Object>> selectBuyerCompanyListByTenant(Long tenantId) throws Exception {
        return userMapper.selectBuyerCompanyListByTenant(tenantId);
    }

    /**
     * 회원 타입 + 테넌트 기준 폼 옵션 한 번에 조회
     * 반환 키: tenants, channels, buyerCompanies, sellerCompanyId
     */
    @Override
    public Map<String, Object> selectFormOptions(String userRole, Long tenantId) throws Exception {
        Map<String, Object> result = new HashMap<>();

        // 항상 테넌트 목록 포함
        result.put("tenants", userMapper.selectActiveTenantList());

        if (tenantId != null) {
            // CHANNEL_ADMIN: 채널 목록 필요
            if ("CHANNEL_ADMIN".equals(userRole) || "SELLER_ADMIN".equals(userRole)) {
                result.put("channels", userMapper.selectChannelListByTenant(tenantId));
                result.put("sellerCompanyId", userMapper.selectSellerCompanyIdByTenant(tenantId));
            }
            // BUYER_ADMIN: 구매업체 목록 필요
            if ("BUYER_ADMIN".equals(userRole)) {
                result.put("buyerCompanies", userMapper.selectBuyerCompanyListByTenant(tenantId));
            }
        }
        return result;
    }

    // ─────────────────────────────────────────────────────────────────
    // 내부 헬퍼
    // ─────────────────────────────────────────────────────────────────

    /**
     * USER_REG.md §9 역할별 tenant/company/channel 강제 세팅
     */
    private void applyRoleConstraints(UserVO vo) throws Exception {
        String role = vo.getUserRole();
        if (role == null) {
            throw new IllegalArgumentException("USER_002:회원 타입은 필수입니다.");
        }

        switch (role) {
            case "SUPER_ADMIN":
                vo.setTenantId(null);
                vo.setCompanyId(null);
                vo.setChannelId(null);
                break;

            case "SELLER_ADMIN":
                require(vo.getTenantId() != null, "USER_002:테넌트는 필수입니다.");
                Long sellerIdForSeller = userMapper.selectSellerCompanyIdByTenant(vo.getTenantId());
                require(sellerIdForSeller != null, "USER_004:해당 테넌트에 대표 판매업체가 지정되지 않았습니다.");
                vo.setCompanyId(sellerIdForSeller);
                vo.setChannelId(null);
                break;

            case "CHANNEL_ADMIN":
                require(vo.getTenantId() != null, "USER_002:테넌트는 필수입니다.");
                require(vo.getChannelId() != null, "USER_002:담당 채널은 필수입니다.");
                Long sellerIdForChannel = userMapper.selectSellerCompanyIdByTenant(vo.getTenantId());
                require(sellerIdForChannel != null, "USER_004:해당 테넌트에 대표 판매업체가 지정되지 않았습니다.");
                vo.setCompanyId(sellerIdForChannel);
                break;

            case "BUYER_ADMIN":
                require(vo.getTenantId() != null, "USER_002:테넌트는 필수입니다.");
                require(vo.getCompanyId() != null, "USER_002:구매업체는 필수입니다.");
                vo.setChannelId(null);
                break;

            default:
                throw new IllegalArgumentException("USER_002:지원하지 않는 회원 타입입니다.");
        }
    }

    /** 역할 기본 담당자 역할 (USER_REG.md §5 업체 담당자 동시 생성 옵션) */
    private String defaultContactRole(String userRole, String inputRole) {
        if (inputRole != null && !inputRole.isEmpty()) {
            return inputRole;
        }
        switch (userRole != null ? userRole : "") {
            case "SELLER_ADMIN":  return "ADMIN";
            case "CHANNEL_ADMIN": return "ADMIN";
            case "BUYER_ADMIN":   return "PURCHASE";
            default:              return "ADMIN";
        }
    }

    private void require(boolean condition, String errorMsg) {
        if (!condition) throw new IllegalArgumentException(errorMsg);
    }
}
