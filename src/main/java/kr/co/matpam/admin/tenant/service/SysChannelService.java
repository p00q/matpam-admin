package kr.co.matpam.admin.tenant.service;

import java.util.List;

public interface SysChannelService {
    
    List<ChannelVO> selectChannelList(ChannelVO vo) throws Exception;
    
    int selectChannelListTotCnt(ChannelVO vo) throws Exception;
    
    ChannelVO selectChannelDetail(Long channelId) throws Exception;

    ChannelVO selectActiveChannelByManagerId(Long managerId) throws Exception;
    
    void insertChannel(ChannelVO vo) throws Exception;
    
    void updateChannel(ChannelVO vo) throws Exception;
    
    void deleteChannel(Long channelId) throws Exception;
}
