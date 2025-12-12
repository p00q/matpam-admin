package kr.co.matpam.admin.member.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import kr.co.matpam.admin.member.service.MemberDefaultVO;
import kr.co.matpam.admin.member.service.MemberVO;

@Repository("memberDAO")
public class MemberDAO extends EgovAbstractMapper {

    public List<MemberVO> selectMemberList(MemberDefaultVO searchVO) {
        return selectList("matpam.member.MemberMapper.selectMemberList", searchVO);
    }

    public int selectMemberListTotCnt(MemberDefaultVO searchVO) {
        return selectOne("matpam.member.MemberMapper.selectMemberListTotCnt", searchVO);
    }

    public void insertMember(MemberVO memberVO) {
        insert("matpam.member.MemberMapper.insertMember", memberVO);
    }

    public void insertMemberCredit(MemberVO memberVO) {
        insert("matpam.member.MemberMapper.insertMemberCredit", memberVO);
    }

    public void insertMemberAgreement(Map<String, Object> paramMap) {
        insert("matpam.member.MemberMapper.insertMemberAgreement", paramMap);
    }

    public MemberVO selectMember(Long memberNo) {
        return selectOne("matpam.member.MemberMapper.selectMember", memberNo);
    }

    public MemberVO selectMemberById(String memberId) {
        return selectOne("matpam.member.MemberMapper.selectMemberById", memberId);
    }

    public List<MemberVO> selectSellerList() {
        return selectList("matpam.member.MemberMapper.selectSellerList", null);
    }

    public int selectMemberCountByLoginId(String loginId) {
        return selectOne("matpam.member.MemberMapper.selectMemberCountByLoginId", loginId);
    }

    public void updateMember(MemberVO memberVO) {
        update("matpam.member.MemberMapper.updateMember", memberVO);
    }
}
