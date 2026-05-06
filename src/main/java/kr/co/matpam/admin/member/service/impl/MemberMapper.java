package kr.co.matpam.admin.member.service.impl;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import kr.co.matpam.admin.member.service.MemberVO;

@Mapper("memberMapper")
public interface MemberMapper {
    List<MemberVO> selectMemberList(MemberVO vo) throws Exception;
    int selectMemberListTotCnt(MemberVO vo) throws Exception;

    MemberVO selectMemberDetail(MemberVO vo) throws Exception;

    List<kr.co.matpam.admin.user.service.UserVO> selectMemberUserList(MemberVO vo) throws Exception;

    List<java.util.Map<String, Object>> selectTenantList() throws Exception;
    List<java.util.Map<String, Object>> selectChannelList(Long tenantId) throws Exception;
    List<java.util.Map<String, Object>> selectBuyerCompanyList(Long tenantId) throws Exception;
    void insertUser(kr.co.matpam.admin.user.service.UserVO vo) throws Exception;
    void insertCompanyContact(kr.co.matpam.admin.company.service.CompanyContactVO vo) throws Exception;
}
