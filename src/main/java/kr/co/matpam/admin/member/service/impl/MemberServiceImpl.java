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

    @Override
    public MemberVO selectMemberDetail(MemberVO vo) throws Exception {
        return memberMapper.selectMemberDetail(vo);
    }

    @Override
    public List<kr.co.matpam.admin.user.service.UserVO> selectMemberUserList(MemberVO vo) throws Exception {
        return memberMapper.selectMemberUserList(vo);
    }

    @Override
    public List<java.util.Map<String, Object>> selectTenantList() throws Exception {
        return memberMapper.selectTenantList();
    }

    @Override
    public List<java.util.Map<String, Object>> selectChannelList(Long tenantId) throws Exception {
        return memberMapper.selectChannelList(tenantId);
    }

    @Override
    public List<java.util.Map<String, Object>> selectBuyerCompanyList(Long tenantId) throws Exception {
        return memberMapper.selectBuyerCompanyList(tenantId);
    }

    @Override
    @org.springframework.transaction.annotation.Transactional
    public void insertUser(kr.co.matpam.admin.user.service.UserVO vo) throws Exception {
        // 비밀번호 암호화
        org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder encoder = new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder();
        vo.setPasswordHash(encoder.encode(vo.getPasswordHash()));
        
        // company_id 필수 제약조건 대응 (마스터 계정 등)
        if (vo.getCompanyId() == null && !"SUPER_ADMIN".equals(vo.getUserRole())) {
             // FIXME: 필요 시 여기서 테넌트 HQ를 조회하여 세팅하는 로직 추가 가능
             // throw new IllegalArgumentException("소속 업체 정보가 누락되었습니다.");
        }
        
        memberMapper.insertUser(vo);
        
        // 추가: 업체 담당자로 자동 등록 옵션 처리 (필요시)
        // if ("Y".equals(vo.getCreateContact())) { ... }
    }
}
