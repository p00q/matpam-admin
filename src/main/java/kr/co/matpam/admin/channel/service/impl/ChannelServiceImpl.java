package kr.co.matpam.admin.channel.service.impl;

import java.util.List;
import javax.annotation.Resource;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import kr.co.matpam.admin.channel.service.ChannelService;
import kr.co.matpam.admin.channel.service.ChannelVO;
import kr.co.matpam.common.annotation.RequiresTenant;

@Service("channelService")
public class ChannelServiceImpl extends EgovAbstractServiceImpl implements ChannelService {

    @Resource(name = "channelMapper")
    private ChannelMapper channelMapper;

    @Override
    @RequiresTenant
    public List<ChannelVO> selectChannelList(ChannelVO vo) throws Exception {
        return channelMapper.selectChannelList(vo);
    }

    @Override
    @RequiresTenant
    public int selectChannelListTotCnt(ChannelVO vo) throws Exception {
        return channelMapper.selectChannelListTotCnt(vo);
    }

    @Override
    @RequiresTenant
    public ChannelVO selectChannelDetail(ChannelVO vo) throws Exception {
        return channelMapper.selectChannelDetail(vo);
    }

    @Override
    @RequiresTenant
    @Transactional
    public void insertChannel(ChannelVO vo) throws Exception {
        channelMapper.insertChannel(vo);
    }

    @Override
    @RequiresTenant
    @Transactional
    public void updateChannel(ChannelVO vo) throws Exception {
        channelMapper.updateChannel(vo);
    }

    @Override
    @RequiresTenant
    @Transactional
    public void deleteChannel(ChannelVO vo) throws Exception {
        channelMapper.deleteChannel(vo);
    }
}
