package kr.co.matpam.admin.tenant.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import kr.co.matpam.admin.tenant.service.ChannelVO;
import java.util.List;

@Mapper("sysChannelMapper")
public interface SysChannelMapper {
    
    List<ChannelVO> selectChannelList(ChannelVO vo) throws Exception;
    
    int selectChannelListTotCnt(ChannelVO vo) throws Exception;
    
    ChannelVO selectChannelDetail(Long channelId) throws Exception;
    
    void insertChannel(ChannelVO vo) throws Exception;
    
    void updateChannel(ChannelVO vo) throws Exception;
    
    void deleteChannel(Long channelId) throws Exception;
}
