package kr.co.matpam.admin.member.service.impl;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import kr.co.matpam.admin.member.service.MemberVO;

@Mapper("memberMapper")
public interface MemberMapper {
    List<MemberVO> selectMemberList(MemberVO vo) throws Exception;
    int selectMemberListTotCnt(MemberVO vo) throws Exception;
}
