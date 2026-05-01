package kr.co.matpam.admin.member.service.impl;

import java.util.List;
import org.springframework.stereotype.Repository;
import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import kr.co.matpam.admin.member.service.MemberDefaultVO;
import kr.co.matpam.admin.member.service.MemberVO;
import kr.co.matpam.admin.member.service.MemberContactVO;

@Repository("memberDAO")
public class MemberDAO extends EgovAbstractMapper {

    private static final String NAMESPACE = "matpam.member.MemberMapper.";

    public List<MemberVO> selectMemberList(MemberDefaultVO searchVO) {
        return selectList(NAMESPACE + "selectMemberList", searchVO);
    }

    public int selectMemberListTotCnt(MemberDefaultVO searchVO) {
        return selectOne(NAMESPACE + "selectMemberListTotCnt", searchVO);
    }

    public void insertCompanyMaster(MemberVO memberVO) {
        insert(NAMESPACE + "insertCompanyMaster", memberVO);
    }

    public void insertMemberMaster(MemberVO memberVO) {
        insert(NAMESPACE + "insertMemberMaster", memberVO);
    }

    public void updateMemberMaster(MemberVO memberVO) {
        update(NAMESPACE + "updateMemberMaster", memberVO);
    }

    public void insertMemberChannelRole(MemberVO memberVO) {
        insert(NAMESPACE + "insertMemberChannelRole", memberVO);
    }

    public void insertBuyerProfile(MemberVO memberVO) {
        insert(NAMESPACE + "insertBuyerProfile", memberVO);
    }

    public void updateBuyerProfile(MemberVO memberVO) {
        update(NAMESPACE + "updateBuyerProfile", memberVO);
    }

    public void insertSellerProfile(MemberVO memberVO) {
        insert(NAMESPACE + "insertSellerProfile", memberVO);
    }

    public void updateSellerProfile(MemberVO memberVO) {
        update(NAMESPACE + "updateSellerProfile", memberVO);
    }

    public void insertAdminProfile(MemberVO memberVO) {
        insert(NAMESPACE + "insertAdminProfile", memberVO);
    }

    public void updateAdminProfile(MemberVO memberVO) {
        update(NAMESPACE + "updateAdminProfile", memberVO);
    }

    public void insertSellerSettleAccount(MemberVO memberVO) {
        insert(NAMESPACE + "insertSellerSettleAccount", memberVO);
    }

    public void updateSellerSettleAccount(MemberVO memberVO) {
        update(NAMESPACE + "updateSellerSettleAccount", memberVO);
    }

    public MemberVO selectMemberDetail(long memberId) {
        return selectOne(NAMESPACE + "selectMemberDetail", memberId);
    }

    public List<MemberContactVO> selectMemberContacts(long memberId) {
        return selectList(NAMESPACE + "selectMemberContacts", memberId);
    }

    public void insertMemberContact(MemberContactVO contact) {
        insert(NAMESPACE + "insertMemberContact", contact);
    }

    public void deleteMemberContacts(long memberId) {
        delete(NAMESPACE + "deleteMemberContacts", memberId);
    }

    public List<MemberVO> selectSellerList() {
        return selectList(NAMESPACE + "selectSellerList");
    }

    public MemberVO selectMemberById(String loginId) {
        return selectOne(NAMESPACE + "selectMemberById", loginId);
    }
}
