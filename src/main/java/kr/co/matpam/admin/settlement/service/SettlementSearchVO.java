package kr.co.matpam.admin.settlement.service;

import java.io.Serializable;

/**
 * 정산관리 검색 VO
 */
public class SettlementSearchVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /* 페이징 (eGov 표준) */
    private Integer pageIndex = 1;
    private Integer pageSize = 20;
    private Integer firstIndex = 0;
    private Integer lastIndex = 1;
    private Integer recordCountPerPage = 20;
    private Integer pageUnit = 10;

    /* 검색 조건 */
    /** 검색 정산일자 - 시작일 (yyyy-MM-dd) */
    private String searchSettleDtFrom;
    
    /** 검색 정산일자 - 종료일 (yyyy-MM-dd) */
    private String searchSettleDtTo;
    
    /** 검색 운영타입 (NATIONAL, LOCAL, FACTORY) */
    private String searchOpType;

    /* Getter / Setter */
    public Integer getPageIndex() { return pageIndex; }
    public void setPageIndex(Integer pageIndex) { this.pageIndex = pageIndex; }

    public Integer getPageSize() { return pageSize; }
    public void setPageSize(Integer pageSize) { this.pageSize = pageSize; }

    public Integer getFirstIndex() { return firstIndex; }
    public void setFirstIndex(Integer firstIndex) { this.firstIndex = firstIndex; }

    public Integer getLastIndex() { return lastIndex; }
    public void setLastIndex(Integer lastIndex) { this.lastIndex = lastIndex; }

    public Integer getRecordCountPerPage() { return recordCountPerPage; }
    public void setRecordCountPerPage(Integer recordCountPerPage) { this.recordCountPerPage = recordCountPerPage; }

    public Integer getPageUnit() { return pageUnit; }
    public void setPageUnit(Integer pageUnit) { this.pageUnit = pageUnit; }

    public String getSearchSettleDtFrom() { return searchSettleDtFrom; }
    public void setSearchSettleDtFrom(String searchSettleDtFrom) { this.searchSettleDtFrom = searchSettleDtFrom; }

    public String getSearchSettleDtTo() { return searchSettleDtTo; }
    public void setSearchSettleDtTo(String searchSettleDtTo) { this.searchSettleDtTo = searchSettleDtTo; }

    public String getSearchOpType() { return searchOpType; }
    public void setSearchOpType(String searchOpType) { this.searchOpType = searchOpType; }
}
