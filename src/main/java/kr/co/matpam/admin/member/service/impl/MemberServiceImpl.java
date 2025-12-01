package kr.co.matpam.admin.member.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.matpam.admin.member.service.MemberDefaultVO;
import kr.co.matpam.admin.member.service.MemberService;
import kr.co.matpam.admin.member.service.MemberVO;

@Service("memberService")
public class MemberServiceImpl extends EgovAbstractServiceImpl implements MemberService {

    private static final Logger LOGGER = LoggerFactory.getLogger(MemberServiceImpl.class);

    @Resource(name = "memberDAO")
    private MemberDAO memberDAO;

    @Override
    public List<MemberVO> selectMemberList(MemberDefaultVO searchVO) throws Exception {
        LOGGER.debug("Select member list with condition: {}", searchVO.getSearchCondition());
        return memberDAO.selectMemberList(searchVO);
    }

    @Override
    public int selectMemberListTotCnt(MemberDefaultVO searchVO) throws Exception {
        return memberDAO.selectMemberListTotCnt(searchVO);
    }

    @Override
    public void insertMember(MemberVO memberVO) throws Exception {
        LOGGER.debug("Insert member: {}", memberVO.getMemberId());
        memberDAO.insertMember(memberVO);
    }
}
