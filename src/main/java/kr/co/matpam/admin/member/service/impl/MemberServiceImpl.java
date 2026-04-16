package kr.co.matpam.admin.member.service.impl;

import java.time.LocalDate;
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

        // 0. 기본값 세팅 (NPE / 제약조건 방어)
        if (!StringUtils.hasText(memberVO.getUseYn())) {
            memberVO.setUseYn("Y");
        }
        if (!StringUtils.hasText(memberVO.getJoinDate())) {
            memberVO.setJoinDate(LocalDate.now().toString());
        }
        if (!StringUtils.hasText(memberVO.getAgreeMarketing())) {
            memberVO.setAgreeMarketing("N");
        }
        if (!StringUtils.hasText(memberVO.getAgreeSms())) {
            memberVO.setAgreeSms("N");
        }

        // 🔥 1) 로그인 아이디 중복 체크 — 여기 추가!
        if (memberDAO.selectMemberCountByLoginId(memberVO.getMemberId()) > 0) {
            throw new IllegalStateException("이미 사용 중인 아이디입니다.");
        }

        LOGGER.debug("Insert member: {}", memberVO.getMemberId());

        // 전체 동의 여부(Y/N) 파생
        memberVO.setAgreeYn(
                ("Y".equalsIgnoreCase(memberVO.getAgreeMarketing())
                        || "Y".equalsIgnoreCase(memberVO.getAgreeSms())) ? "Y" : "N");

        // 1. 회원 기본정보 저장
        memberDAO.insertMember(memberVO); // 여기서 memberNo(PK) 세팅
        Long memberId = memberVO.getMemberNo();

        // 2. (선택) 여신정보 저장 안 함
        // memberDAO.insertMemberCredit(memberVO);

        // 3. 동의 정보 저장 (TB_MEMBER_AGREE)
        createAgreementRecord(memberId, "MARKETING",
                memberVO.getAgreeMarketing(),
                memberVO.getJoinDate());

        createAgreementRecord(memberId, "SMS",
                memberVO.getAgreeSms(),
                memberVO.getJoinDate());

        // 4. 담당자 정보 저장
        List<MemberManagerVO> managers = sanitizeManagers(memberVO.getMemberManagers());
        if (!managers.isEmpty()) {
            ensureSingleMainManager(managers);
            for (MemberManagerVO manager : managers) {
                manager.setMemberNo(memberId);
                if (!StringUtils.hasText(manager.getUseYn())) {
                    manager.setUseYn("Y");
                }
            }
            memberManagerDAO.insertMemberManagers(managers);
        }
    }

    @Override
    @Transactional
    public void updateMember(MemberVO memberVO) throws Exception {
        LOGGER.debug("Update member: {}", memberVO.getMemberId());

        // 1. 회원 기본정보 수정
        memberDAO.updateMember(memberVO);
        Long memberId = memberVO.getMemberNo();

        // 2. 담당자 정보 수정 (All Delete -> Insert)
        memberManagerDAO.deleteMemberManagersByMemberNo(memberId);

        List<MemberManagerVO> managers = sanitizeManagers(memberVO.getMemberManagers());
        if (!managers.isEmpty()) {
            ensureSingleMainManager(managers);
            for (MemberManagerVO manager : managers) {
                manager.setMemberNo(memberId);
                if (!StringUtils.hasText(manager.getUseYn())) {
                    manager.setUseYn("Y");
                }
            }
            memberManagerDAO.insertMemberManagers(managers);
        }
    }

    @Override
    public List<MemberManagerVO> selectMemberManagers(Long memberNo) throws Exception {
        return memberManagerDAO.selectMemberManagers(memberNo);
    }

    @Override
    public MemberVO selectMember(MemberVO memberVO) throws Exception {
        return memberDAO.selectMember(memberVO);
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

    private void createAgreementRecord(Long memberId,
            String agreeTypeCd, // MARKETING / SMS
            String agreeYn, // Y / N / null
            String agreeDt) throws Exception {

        // 동의값이 비어있으면 기본은 N
        if (!StringUtils.hasText(agreeYn)) {
            agreeYn = "N";
        }

        Map<String, Object> param = new HashMap<>();
        param.put("memberId", memberId);
        param.put("agreeTypeCd", agreeTypeCd);
        param.put("agreeYn", "Y".equalsIgnoreCase(agreeYn) ? "Y" : "N");
        param.put("agreeDt", agreeDt); // 가입일자 기준으로 사용

        memberDAO.insertMemberAgreement(param);
    }

}
