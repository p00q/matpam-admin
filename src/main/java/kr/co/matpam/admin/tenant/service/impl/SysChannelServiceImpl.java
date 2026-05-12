package kr.co.matpam.admin.tenant.service.impl;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.matpam.admin.tenant.service.ChannelVO;
import kr.co.matpam.admin.tenant.service.SysChannelService;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.List;

@Service("sysChannelService")
public class SysChannelServiceImpl extends EgovAbstractServiceImpl implements SysChannelService {

    @Resource(name = "sysChannelMapper")
    private SysChannelMapper sysChannelMapper;

    @Resource(name = "userMapper")
    private kr.co.matpam.admin.user.service.impl.UserMapper userMapper;

    @Override
    public List<ChannelVO> selectChannelList(ChannelVO vo) throws Exception {
        return sysChannelMapper.selectChannelList(vo);
    }

    @Override
    public int selectChannelListTotCnt(ChannelVO vo) throws Exception {
        return sysChannelMapper.selectChannelListTotCnt(vo);
    }

    @Override
    public ChannelVO selectChannelDetail(Long channelId) throws Exception {
        return sysChannelMapper.selectChannelDetail(channelId);
    }

    @Override
    public void insertChannel(ChannelVO vo) throws Exception {
        int count = sysChannelMapper.checkDuplicateChannelType(vo);
        if (count > 0) {
            throw new org.springframework.dao.DuplicateKeyException("이미 동일한 채널 유형이 존재합니다.");
        }
        sysChannelMapper.insertChannel(vo);
        
        // 담당자 지정 시 사용자 역할 동기화
        if (vo.getManagerId() != null) {
            kr.co.matpam.admin.user.service.UserVO userVO = new kr.co.matpam.admin.user.service.UserVO();
            userVO.setUserId(vo.getManagerId());
            userVO.setUserRole("CHANNEL_ADMIN");
            userVO.setChannelId(vo.getChannelId());
            userMapper.updateUserRoleAndChannel(userVO);
        }
    }

    @Override
    public void updateChannel(ChannelVO vo) throws Exception {
        int count = sysChannelMapper.checkDuplicateChannelType(vo);
        if (count > 0) {
            throw new org.springframework.dao.DuplicateKeyException("이미 동일한 채널 유형이 존재합니다.");
        }
        
        // 기존 이 채널의 담당자들 역할 초기화
        userMapper.resetChannelManagerRole(vo.getChannelId());
        
        sysChannelMapper.updateChannel(vo);
        
        // 새 담당자 지정 시 사용자 역할 동기화
        if (vo.getManagerId() != null) {
            kr.co.matpam.admin.user.service.UserVO userVO = new kr.co.matpam.admin.user.service.UserVO();
            userVO.setUserId(vo.getManagerId());
            userVO.setUserRole("CHANNEL_ADMIN");
            userVO.setChannelId(vo.getChannelId());
            userMapper.updateUserRoleAndChannel(userVO);
        }
    }

    @Override
    public void deleteChannel(Long channelId) throws Exception {
        // 채널 삭제 전 담당자 역할 초기화
        userMapper.resetChannelManagerRole(channelId);
        sysChannelMapper.deleteChannel(channelId);
    }
}
