package kr.co.matpam.admin.channel.service.impl;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import kr.co.matpam.admin.channel.service.ChannelVO;

@Mapper("channelMapper")
public interface ChannelMapper {
    List<ChannelVO> selectChannelList(ChannelVO vo);
    int selectChannelListTotCnt(ChannelVO vo);
    ChannelVO selectChannelDetail(ChannelVO vo);
    void insertChannel(ChannelVO vo);
    void updateChannel(ChannelVO vo);
    void deleteChannel(ChannelVO vo);
}
