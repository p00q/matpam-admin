package kr.co.matpam.admin.member.service;

import java.util.List;

public interface MemberService {
    List<MemberVO> selectMemberList(MemberVO vo) throws Exception;
    int selectMemberListTotCnt(MemberVO vo) throws Exception;
}
