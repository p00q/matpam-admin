package kr.co.matpam.admin.validator.service.impl;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import kr.co.matpam.admin.validator.service.DataValidationVO;

/**
 * 데이터 정합성 검증 Mapper 인터페이스
 */
@Mapper("dataValidationMapper")
public interface DataValidationMapper {

    /**
     * 불일치 데이터 목록 조회
     */
    List<EgovMap> selectMismatchedOrderList(DataValidationVO searchVO);

    /**
     * 불일치 데이터 총 건수 조회
     */
    int selectMismatchedOrderListCnt(DataValidationVO searchVO);
}
