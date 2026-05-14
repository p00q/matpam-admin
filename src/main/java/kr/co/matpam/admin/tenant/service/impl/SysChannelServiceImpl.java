package kr.co.matpam.admin.tenant.service.impl;

import java.util.List;
import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import kr.co.matpam.admin.tenant.service.ChannelVO;
import kr.co.matpam.admin.tenant.service.SysChannelService;
import kr.co.matpam.admin.user.service.UserVO;
import kr.co.matpam.admin.user.service.impl.UserMapper;

@Service("sysChannelService")
public class SysChannelServiceImpl extends EgovAbstractServiceImpl implements SysChannelService {

    @Resource(name = "sysChannelMapper")
    private SysChannelMapper sysChannelMapper;

    @Resource(name = "userMapper")
    private UserMapper userMapper;

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
        validateDuplicateType(vo);
        sysChannelMapper.insertChannel(vo);
        syncChannelManager(vo);
    }

    @Override
    public void updateChannel(ChannelVO vo) throws Exception {
        validateDuplicateType(vo);
        userMapper.resetChannelManagerRole(vo.getChannelId());
        sysChannelMapper.updateChannel(vo);
        syncChannelManager(vo);
    }

    @Override
    public void deleteChannel(Long channelId) throws Exception {
        userMapper.resetChannelManagerRole(channelId);
        sysChannelMapper.deleteChannel(channelId);
    }

    private void validateDuplicateType(ChannelVO vo) throws Exception {
        int count = sysChannelMapper.checkDuplicateChannelType(vo);
        if (count > 0) {
            throw new DuplicateKeyException("이미 동일한 채널 유형이 존재합니다.");
        }
    }

    private void syncChannelManager(ChannelVO vo) throws Exception {
        if (vo.getManagerId() == null) {
            return;
        }

        UserVO userVO = new UserVO();
        userVO.setUserId(vo.getManagerId());
        userVO.setUserRole("CHANNEL_ADMIN");
        userVO.setChannelId(vo.getChannelId());
        userMapper.updateUserRoleAndChannel(userVO);
    }
}
