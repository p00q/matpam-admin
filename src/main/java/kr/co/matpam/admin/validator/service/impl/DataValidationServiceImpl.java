package kr.co.matpam.admin.validator.service.impl;

import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import kr.co.matpam.admin.validator.service.DataValidationService;
import kr.co.matpam.admin.validator.service.DataValidationVO;

/**
 * 데이터 정합성 검증 Service 구현체
 */
@Service("dataValidationService")
public class DataValidationServiceImpl extends EgovAbstractServiceImpl implements DataValidationService {

    @Resource(name = "dataValidationMapper")
    private DataValidationMapper dataValidationMapper;

    @Override
    public List<EgovMap> selectMismatchedOrderList(DataValidationVO searchVO) throws Exception {
        return dataValidationMapper.selectMismatchedOrderList(searchVO);
    }

    @Override
    public int selectMismatchedOrderListCnt(DataValidationVO searchVO) throws Exception {
        return dataValidationMapper.selectMismatchedOrderListCnt(searchVO);
    }
}
