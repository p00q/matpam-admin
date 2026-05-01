package kr.co.matpam.admin.member.service;

import java.util.List;

/**
 * 회원 관리 서비스 인터페이스 (matpam_new 전용)
 */
public interface MemberService {

    /** 회원 목록 조회 */
    List<MemberVO> selectMemberList(MemberDefaultVO searchVO) throws Exception;

    /** 회원 총 갯수 조회 */
    int selectMemberListTotCnt(MemberDefaultVO searchVO) throws Exception;

    /** 회원 상세 정보 조회 (자산 및 연락처 포함) */
    MemberVO selectMemberDetail(long memberId) throws Exception;

    /** 신규 회원 등록 */
    void insertMember(MemberVO memberVO) throws Exception;

    /** 회원 정보 수정 */
    void updateMember(MemberVO memberVO) throws Exception;

    /** 판매자 목록 조회 */
    List<MemberVO> selectSellerList() throws Exception;

    /** 로그인 아이디로 회원 조회 */
    MemberVO selectMemberById(String loginId) throws Exception;
}
