package kr.co.matpam.admin.channel.service.impl;

import java.util.List;
import javax.annotation.Resource;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import kr.co.matpam.admin.channel.service.PlatformService;
import kr.co.matpam.admin.channel.service.PlatformVO;

@Service("platformService")
public class PlatformServiceImpl extends EgovAbstractServiceImpl implements PlatformService {

    @Resource(name = "platformMapper")
    private PlatformMapper platformMapper;

    @Override
    public List<PlatformVO> selectPlatformList(PlatformVO vo) throws Exception {
        return platformMapper.selectPlatformList(vo);
    }

    @Override
    @Transactional
    public void insertPlatform(PlatformVO vo) throws Exception {
        platformMapper.insertPlatform(vo);
    }

    @Override
    @Transactional
    public void updatePlatform(PlatformVO vo) throws Exception {
        platformMapper.updatePlatform(vo);
    }
}
