package kr.co.matpam.admin.member.service.impl;

import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.matpam.admin.member.service.MemberDefaultVO;
import kr.co.matpam.admin.member.service.MemberService;
import kr.co.matpam.admin.member.service.MemberVO;
import kr.co.matpam.admin.member.service.MemberContactVO;

@Service("memberService")
public class MemberServiceImpl extends EgovAbstractServiceImpl implements MemberService {

    @Resource(name = "memberDAO")
    private MemberDAO memberDAO;

    @Override
    public List<MemberVO> selectMemberList(MemberDefaultVO searchVO) throws Exception {
        return memberDAO.selectMemberList(searchVO);
    }

    @Override
    public int selectMemberListTotCnt(MemberDefaultVO searchVO) throws Exception {
        return memberDAO.selectMemberListTotCnt(searchVO);
    }

    @Override
    public MemberVO selectMemberDetail(long memberId) throws Exception {
        MemberVO member = memberDAO.selectMemberDetail(memberId);
        if (member != null) {
            member.setContacts(memberDAO.selectMemberContacts(memberId));
        }
        return member;
    }

    @Override
    @Transactional
    public void insertMember(MemberVO memberVO) throws Exception {
        // 데이터 기본값 보정
        if (memberVO.getMemberName() == null || memberVO.getMemberName().isEmpty()) {
            memberVO.setMemberName(memberVO.getCeoName());
        }
        if (memberVO.getMobileNo() == null || memberVO.getMobileNo().isEmpty()) {
            memberVO.setMobileNo(memberVO.getCeoMobileNo());
        }

        // 1. 업체 마스터 저장 (새로운 업체 생성 시)
        if (memberVO.getCompanyId() == null && memberVO.getCompanyName() != null && !memberVO.getCompanyName().isEmpty()) {
            memberDAO.insertCompanyMaster(memberVO);
        }

        // 2. 회원 마스터 저장
        memberDAO.insertMemberMaster(memberVO);
        long memberId = memberVO.getMemberId();

        // 3. 권한 및 프로필 저장
        String type = memberVO.getMemberTypeCd();
        if (type != null) {
            if (type.contains("SUPER_ADMIN")) {
                memberVO.setChannelCd("SUPER");
                memberVO.setAdminRoleCd("SUPER_ADMIN");
                memberDAO.insertMemberChannelRole(memberVO);
            } else if (type.contains("COMPANY_ADMIN")) {
                memberVO.setChannelCd("SUPER");
                memberVO.setAdminRoleCd("COMPANY_ADMIN");
                memberDAO.insertMemberChannelRole(memberVO);
            } else if (type.contains("CHANNEL_ADMIN") || type.contains("ADMIN")) { // 채널 관리자
                // channelCd는 UI에서 넘어온 값 사용
                memberVO.setAdminRoleCd("CHANNEL_ADMIN");
                memberDAO.insertMemberChannelRole(memberVO);
            } else if (type.contains("BUYER")) {
                // 구매자 프로필 저장 (managingChannelCd 등)
                memberDAO.insertBuyerProfile(memberVO);
            } else if (type.contains("SELLER")) {
                memberDAO.insertSellerProfile(memberVO);
                memberDAO.insertSellerSettleAccount(memberVO);
            }
        }

        // 4. 담당자 정보 저장
        saveContacts(memberId, memberVO.getContacts());
    }

    @Override
    @Transactional
    public void updateMember(MemberVO memberVO) throws Exception {
        long memberId = memberVO.getMemberId();

        // 1. 마스터 정보 수정
        memberDAO.updateMemberMaster(memberVO);

        // 2. 타입별 프로필 수정
        String type = memberVO.getMemberTypeCd();
        if (type != null) {
            if (type.contains("BUYER")) {
                memberDAO.updateBuyerProfile(memberVO);
            } else if (type.contains("SELLER")) {
                memberDAO.updateSellerProfile(memberVO);
                memberDAO.updateSellerSettleAccount(memberVO);
            }
        }

        // 3. 담당자 정보 수정 (전체 삭제 후 재등록)
        memberDAO.deleteMemberContacts(memberId);
        saveContacts(memberId, memberVO.getContacts());
    }

    private void saveContacts(long memberId, List<MemberContactVO> contacts) {
        if (!CollectionUtils.isEmpty(contacts)) {
            int idx = 1;
            for (MemberContactVO contact : contacts) {
                if (contact.getName() != null && !contact.getName().isEmpty()) {
                    contact.setMemberId(memberId);
                    contact.setContactTypeCd(idx == 1 ? "MAIN" : "SUB");
                    memberDAO.insertMemberContact(contact);
                    idx++;
                }
            }
        }
    }
    @Override
    public List<MemberVO> selectSellerList() throws Exception {
        return memberDAO.selectSellerList();
    }

    @Override
    public MemberVO selectMemberById(String loginId) throws Exception {
        return memberDAO.selectMemberById(loginId);
    }
}
