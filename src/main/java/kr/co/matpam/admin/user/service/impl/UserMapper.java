package kr.co.matpam.admin.user.service.impl;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import kr.co.matpam.admin.user.service.UserVO;

/**
 * 사용자 관리 Mapper
 */
@Mapper("userMapper")
public interface UserMapper {

    /**
     * 사용자 목록 조회
     */
    List<UserVO> selectUserList(UserVO vo) throws Exception;

    /**
     * 사용자 목록 총 갯수 조회
     */
    int selectUserListTotCnt(UserVO vo) throws Exception;

    /**
     * 사용자 상세 조회
     */
    UserVO selectUserDetail(UserVO vo) throws Exception;

    /**
     * 사용자 등록
     */
    void insertUser(UserVO vo) throws Exception;

    /**
     * 사용자 수정
     */
    void updateUser(UserVO vo) throws Exception;

    /**
     * 사용자 상태 변경
     */
    void updateUserStatus(UserVO vo) throws Exception;

    /**
     * 로그인 아이디로 사용자 조회
     */
    UserVO selectUserByLoginId(String loginId) throws Exception;
}
