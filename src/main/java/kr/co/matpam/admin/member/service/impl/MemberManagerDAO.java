package kr.co.matpam.admin.member.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import kr.co.matpam.admin.member.service.manager.MemberManagerVO;

@Repository("memberManagerDAO")
public class MemberManagerDAO extends EgovAbstractMapper {

    public void insertMemberManagers(List<MemberManagerVO> memberManagers) {
        if (memberManagers == null || memberManagers.isEmpty()) {
            return;
        }
        insert("matpam.member.MemberManagerMapper.insertMemberManagers", memberManagers);
    }

    public void deleteMemberManagersByMemberNo(Long memberNo) {
        delete("matpam.member.MemberManagerMapper.deleteMemberManagersByMemberNo", memberNo);
    }

    public List<MemberManagerVO> selectMemberManagers(Long memberNo) {
        return selectList("matpam.member.MemberManagerMapper.selectMemberManagers", memberNo);
    }
}
