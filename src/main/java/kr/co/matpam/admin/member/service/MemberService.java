package kr.co.matpam.admin.member.service;

import java.util.List;

public interface MemberService {

    List<MemberVO> selectMemberList(MemberDefaultVO searchVO) throws Exception;

    int selectMemberListTotCnt(MemberDefaultVO searchVO) throws Exception;

    void insertMember(MemberVO member) throws Exception;
}
