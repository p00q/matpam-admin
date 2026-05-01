package kr.co.matpam.admin.channel.service.impl;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import kr.co.matpam.admin.channel.service.PlatformVO;

@Mapper("platformMapper")
public interface PlatformMapper {
    List<PlatformVO> selectPlatformList(PlatformVO vo);
    void insertPlatform(PlatformVO vo);
    void updatePlatform(PlatformVO vo);
}
