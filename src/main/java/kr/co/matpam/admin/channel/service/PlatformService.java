package kr.co.matpam.admin.channel.service;

import java.util.List;

public interface PlatformService {
    List<PlatformVO> selectPlatformList(PlatformVO vo) throws Exception;
    void insertPlatform(PlatformVO vo) throws Exception;
    void updatePlatform(PlatformVO vo) throws Exception;
}
