package kr.co.matpam.admin.user.service;

import java.util.List;

/**
 * 사용자 관리 서비스 인터페이스
 */
public interface UserService {

    List<UserVO> selectUserList(UserVO vo) throws Exception;

    int selectUserListTotCnt(UserVO vo) throws Exception;

    UserVO selectUserDetail(UserVO vo) throws Exception;

    void insertUser(UserVO vo) throws Exception;

    void updateUser(UserVO vo) throws Exception;

    void updateUserStatus(UserVO vo) throws Exception;

    UserVO selectUserByLoginId(String loginId) throws Exception;
}
