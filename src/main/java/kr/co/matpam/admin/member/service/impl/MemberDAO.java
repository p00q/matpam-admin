package kr.co.matpam.admin.member.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
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
}
