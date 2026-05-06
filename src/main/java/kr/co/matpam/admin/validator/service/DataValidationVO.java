package kr.co.matpam.admin.validator.service;

import kr.co.matpam.common.service.MatpamBaseVO;

/**
 * 데이터 정합성 검증 VO
 */
public class DataValidationVO extends MatpamBaseVO {

    private static final long serialVersionUID = 1L;

    /** 검색 시작일 */
    private String searchBgnDe;

    /** 검색 종료일 */
    private String searchEndDe;

    public String getSearchBgnDe() {
        return searchBgnDe;
    }

    public void setSearchBgnDe(String searchBgnDe) {
        this.searchBgnDe = searchBgnDe;
    }

    public String getSearchEndDe() {
        return searchEndDe;
    }

    public void setSearchEndDe(String searchEndDe) {
        this.searchEndDe = searchEndDe;
    }
}
