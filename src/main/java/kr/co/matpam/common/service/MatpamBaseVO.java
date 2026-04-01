package kr.co.matpam.common.service;

import java.io.Serializable;
import java.util.Date;

/**
 * 맛팜 공통 Base VO
 * - 모든 VO의 상속 대상
 * - 운영 타입(opType) 및 공통 메타데이터 관리
 */
public class MatpamBaseVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 운영 타입 (NATIONAL, LOCAL, FACTORY) - 데이터 격리용 */
    private String opType;

    /** 페이징: 현재 페이지 번호 */
    private Integer pageIndex = 1;

    /** 페이징: 페이지당 레코드 수 */
    private Integer pageUnit = 10;

    /** 페이징: 페이지 사이즈 */
    private Integer pageSize = 10;

    /** 페이징: 첫번째 인덱스 */
    private Integer firstIndex = 0;

    /** 페이징: 마지막 인덱스 */
    private Integer lastIndex = 1;

    /** 페이징: 페이지당 레코드 수 (eGov 관례) */
    private Integer recordCountPerPage = 10;

    /** 검색: 조건 */
    private String searchCondition = "";

    /** 검색: 키워드 */
    private String searchKeyword = "";

    /** 등록자 ID */
    private String regId;

    /** 등록 일시 */
    private Date regDt;

    /** 수정자 ID */
    private String modId;

    /** 수정 일시 */
    private Date modDt;

    public String getOpType() {
        return opType;
    }

    public void setOpType(String opType) {
        this.opType = opType;
    }

    public Integer getPageIndex() {
        return pageIndex;
    }

    public void setPageIndex(Integer pageIndex) {
        this.pageIndex = pageIndex;
    }

    public Integer getPageUnit() {
        return pageUnit;
    }

    public void setPageUnit(Integer pageUnit) {
        this.pageUnit = pageUnit;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }

    public Integer getFirstIndex() {
        return firstIndex;
    }

    public void setFirstIndex(Integer firstIndex) {
        this.firstIndex = firstIndex;
    }

    public Integer getLastIndex() {
        return lastIndex;
    }

    public void setLastIndex(Integer lastIndex) {
        this.lastIndex = lastIndex;
    }

    public Integer getRecordCountPerPage() {
        return recordCountPerPage;
    }

    public void setRecordCountPerPage(Integer recordCountPerPage) {
        this.recordCountPerPage = recordCountPerPage;
    }

    public String getSearchCondition() {
        return searchCondition;
    }

    public void setSearchCondition(String searchCondition) {
        this.searchCondition = searchCondition;
    }

    public String getSearchKeyword() {
        return searchKeyword;
    }

    public void setSearchKeyword(String searchKeyword) {
        this.searchKeyword = searchKeyword;
    }

    public String getRegId() {
        return regId;
    }

    public void setRegId(String regId) {
        this.regId = regId;
    }

    public Date getRegDt() {
        return regDt;
    }

    public void setRegDt(Date regDt) {
        this.regDt = regDt;
    }

    public String getModId() {
        return modId;
    }

    public void setModId(String modId) {
        this.modId = modId;
    }

    public Date getModDt() {
        return modDt;
    }

    public void setModDt(Date modDt) {
        this.modDt = modDt;
    }
}
