package kr.co.matpam.admin.validator.service;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

/**
 * 데이터 정합성 검증 Service 인터페이스
 */
public interface DataValidationService {

    /**
     * 불일치 데이터 목록 조회
     */
    List<EgovMap> selectMismatchedOrderList(DataValidationVO searchVO) throws Exception;

    /**
     * 불일치 데이터 총 건수 조회
     */
    int selectMismatchedOrderListCnt(DataValidationVO searchVO) throws Exception;
}
