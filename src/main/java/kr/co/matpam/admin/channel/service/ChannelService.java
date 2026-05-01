package kr.co.matpam.admin.channel.service;

import java.util.List;
import kr.co.matpam.common.annotation.RequiresTenant;

public interface ChannelService {
    List<ChannelVO> selectChannelList(ChannelVO vo) throws Exception;
    int selectChannelListTotCnt(ChannelVO vo) throws Exception;
    ChannelVO selectChannelDetail(ChannelVO vo) throws Exception;
    
    @RequiresTenant
    void insertChannel(ChannelVO vo) throws Exception;
    
    @RequiresTenant
    void updateChannel(ChannelVO vo) throws Exception;
    
    @RequiresTenant
    void deleteChannel(ChannelVO vo) throws Exception;
}
