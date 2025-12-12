package kr.co.matpam.admin.member.service;

import java.util.List;

import kr.co.matpam.admin.member.service.manager.MemberManagerVO;

public interface MemberService {

    List<MemberVO> selectMemberList(MemberDefaultVO searchVO) throws Exception;

    int selectMemberListTotCnt(MemberDefaultVO searchVO) throws Exception;

    void insertMember(MemberVO memberVO) throws Exception;

    void updateMember(MemberVO memberVO) throws Exception;

    List<MemberManagerVO> selectMemberManagers(Long memberNo) throws Exception;

    MemberVO selectMember(Long memberNo) throws Exception;

    MemberVO selectMemberById(String memberId) throws Exception;

    List<MemberVO> selectSellerList() throws Exception;
}
