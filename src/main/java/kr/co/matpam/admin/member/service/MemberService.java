package kr.co.matpam.admin.member.service;

import java.util.List;

public interface MemberService {
    List<MemberVO> selectMemberList(MemberVO vo) throws Exception;
    int selectMemberListTotCnt(MemberVO vo) throws Exception;
    
    /**
     * 구매업체 상세 정보 조회
     */
    MemberVO selectMemberDetail(MemberVO vo) throws Exception;
    
    /**
     * 해당 업체에 소속된 사용자 목록 조회
     */
    List<kr.co.matpam.admin.user.service.UserVO> selectMemberUserList(MemberVO vo) throws Exception;

    List<java.util.Map<String, Object>> selectTenantList() throws Exception;
    List<java.util.Map<String, Object>> selectChannelList(Long tenantId) throws Exception;
    List<java.util.Map<String, Object>> selectBuyerCompanyList(Long tenantId) throws Exception;
    void insertUser(kr.co.matpam.admin.user.service.UserVO vo) throws Exception;
}
