package kr.co.matpam.admin.member.service.impl;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.matpam.admin.member.service.MemberDefaultVO;
import kr.co.matpam.admin.member.service.MemberService;
import kr.co.matpam.admin.member.service.MemberVO;
import kr.co.matpam.admin.member.service.manager.MemberManagerVO;

@Service("memberService")
public class MemberServiceImpl extends EgovAbstractServiceImpl implements MemberService {

    private static final Logger LOGGER = LoggerFactory.getLogger(MemberServiceImpl.class);

    @Resource(name = "memberDAO")
    private MemberDAO memberDAO;

    @Resource(name = "memberManagerDAO")
    private MemberManagerDAO memberManagerDAO;

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
    @Transactional
    public void insertMember(MemberVO memberVO) throws Exception {
        LOGGER.debug("Insert member: {}", memberVO.getMemberId());
        if (!StringUtils.hasText(memberVO.getUseYn())) {
            memberVO.setUseYn("Y");
        }
        memberVO.setAgreeYn("Y".equalsIgnoreCase(memberVO.getAgreeMarketing())
                || "Y".equalsIgnoreCase(memberVO.getAgreeSms()) ? "Y" : "N");
        memberDAO.insertMember(memberVO);
        memberDAO.insertMemberCredit(memberVO);
        createAgreementRecord(memberVO, "MARKETING", memberVO.getAgreeMarketing());
        createAgreementRecord(memberVO, "SMS", memberVO.getAgreeSms());

        List<MemberManagerVO> managers = sanitizeManagers(memberVO.getMemberManagers());
        if (!managers.isEmpty()) {
            ensureSingleMainManager(managers);
            managers.forEach(manager -> {
                manager.setMemberNo(memberVO.getMemberNo());
                if (!StringUtils.hasText(manager.getUseYn())) {
                    manager.setUseYn("Y");
                }
            });
            memberManagerDAO.insertMemberManagers(managers);
        }
    }

    @Override
    public List<MemberManagerVO> selectMemberManagers(Long memberNo) throws Exception {
        return memberManagerDAO.selectMemberManagers(memberNo);
    }

    @Override
    public MemberVO selectMember(Long memberNo) throws Exception {
        return memberDAO.selectMember(memberNo);
    }

    @Override
    public MemberVO selectMemberById(String memberId) throws Exception {
        return memberDAO.selectMemberById(memberId);
    }

    @Override
    public List<MemberVO> selectSellerList() throws Exception {
        return memberDAO.selectSellerList();
    }

    private List<MemberManagerVO> sanitizeManagers(List<MemberManagerVO> memberManagers) {
        if (memberManagers == null) {
            return Collections.emptyList();
        }
        return memberManagers.stream()
                .filter(manager -> StringUtils.hasText(manager.getManagerName())
                        || StringUtils.hasText(manager.getMobileNumber())
                        || StringUtils.hasText(manager.getPhoneNumber())
                        || StringUtils.hasText(manager.getEmail()))
                .collect(Collectors.toList());
    }

    private void ensureSingleMainManager(List<MemberManagerVO> managers) {
        boolean mainAssigned = false;
        for (MemberManagerVO manager : managers) {
            if (!mainAssigned && "Y".equalsIgnoreCase(manager.getMainYn())) {
                mainAssigned = true;
                manager.setMainYn("Y");
            } else {
                manager.setMainYn("N");
            }
        }

        if (!mainAssigned && !managers.isEmpty()) {
            managers.get(0).setMainYn("Y");
        }
    }

    private void createAgreementRecord(MemberVO memberVO, String agreeType, String agreeYn) {
        if (!StringUtils.hasText(agreeYn)) {
            return;
        }

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("memberId", memberVO.getMemberNo());
        paramMap.put("agreeType", agreeType);
        paramMap.put("agreeYn", agreeYn);
        paramMap.put("agreeDt", memberVO.getJoinDate());

        memberDAO.insertMemberAgreement(paramMap);
    }
}
