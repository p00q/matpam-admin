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
        sysChannelMapper.insertChannel(vo);
    }

    @Override
    public void updateChannel(ChannelVO vo) throws Exception {
        sysChannelMapper.updateChannel(vo);
    }

    @Override
    public void deleteChannel(Long channelId) throws Exception {
        sysChannelMapper.deleteChannel(channelId);
    }
}
