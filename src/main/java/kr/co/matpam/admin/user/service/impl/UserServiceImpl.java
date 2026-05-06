package kr.co.matpam.admin.user.service.impl;

import java.util.List;
import javax.annotation.Resource;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;
import kr.co.matpam.admin.user.service.UserService;
import kr.co.matpam.admin.user.service.UserVO;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * 사용자 관리 서비스 구현체
 */
@Service("userService")
public class UserServiceImpl extends EgovAbstractServiceImpl implements UserService {

    @Resource(name = "userMapper")
    private UserMapper userMapper;

    @Resource(name = "bcryptPasswordEncoder")
    private BCryptPasswordEncoder passwordEncoder;

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

    @Override
    public void insertUser(UserVO vo) throws Exception {
        validateUserRole(vo);
        if (vo.getPasswordHash() != null) {
            vo.setPasswordHash(passwordEncoder.encode(vo.getPasswordHash()));
        }
        userMapper.insertUser(vo);
    }

    @Override
    public void updateUser(UserVO vo) throws Exception {
        validateUserRole(vo);
        if (vo.getPasswordHash() != null && !vo.getPasswordHash().isEmpty()) {
            vo.setPasswordHash(passwordEncoder.encode(vo.getPasswordHash()));
        }
        userMapper.updateUser(vo);
    }

    private void validateUserRole(UserVO vo) throws Exception {
        String role = vo.getUserRole();
        if (role == null) return;

        switch (role) {
            case "SUPER_ADMIN":
                vo.setTenantId(null);
                vo.setCompanyId(null);
                vo.setChannelId(null);
                break;
            case "SELLER_ADMIN":
                if (vo.getTenantId() == null) throw new Exception("SELLER_ADMIN must have a Tenant.");
                vo.setChannelId(null);
                break;
            case "CHANNEL_ADMIN":
                if (vo.getTenantId() == null) throw new Exception("CHANNEL_ADMIN must have a Tenant.");
                if (vo.getChannelId() == null) throw new Exception("CHANNEL_ADMIN must have a Channel.");
                break;
            case "BUYER_ADMIN":
                if (vo.getTenantId() == null) throw new Exception("BUYER_ADMIN must have a Tenant.");
                if (vo.getCompanyId() == null) throw new Exception("BUYER_ADMIN must have a Company.");
                vo.setChannelId(null);
                break;
        }
    }

    @Override
    public void updateUserStatus(UserVO vo) throws Exception {
        userMapper.updateUserStatus(vo);
    }

    @Override
    public UserVO selectUserByLoginId(String loginId) throws Exception {
        return userMapper.selectUserByLoginId(loginId);
    }
}
