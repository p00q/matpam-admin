package kr.co.matpam.admin.member.service.impl;

import java.util.List;
import javax.annotation.Resource;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;
import kr.co.matpam.admin.member.service.MemberService;
import kr.co.matpam.admin.member.service.MemberVO;

@Service("memberService")
public class MemberServiceImpl extends EgovAbstractServiceImpl implements MemberService {

    @Resource(name = "memberMapper")
    private MemberMapper memberMapper;

    @Override
    public List<MemberVO> selectMemberList(MemberVO vo) throws Exception {
        return memberMapper.selectMemberList(vo);
    }

    @Override
    public int selectMemberListTotCnt(MemberVO vo) throws Exception {
        return memberMapper.selectMemberListTotCnt(vo);
    }
}
