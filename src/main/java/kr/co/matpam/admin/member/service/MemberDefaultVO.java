package kr.co.matpam.admin.member.service;

import java.io.Serializable;

public class MemberDefaultVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 가입상태 */
    private String status;

    /** 지역 */
    private String region;

    /** 가입일 From */
    private String joinDateFrom;

    /** 가입일 To */
    private String joinDateTo;

    /** 회원등급 */
    private String memberGrade;

    /** 검색구분 */
    private String searchCondition;

    /** 검색어 */
    private String searchKeyword;

    /** 현재 페이지 번호 */
    private int pageIndex = 1;

    /** 페이지 크기 */
    private int pageUnit = 10;

    /** 페이지 목록 사이즈 */
    private int pageSize = 10;

    /** 첫 페이지 인덱스 */
    private int firstIndex = 0;

    /** 마지막 페이지 인덱스 */
    private int lastIndex = 1;

    /** 페이지 당 레코드 수 */
    private int recordCountPerPage = 10;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public String getJoinDateFrom() {
        return joinDateFrom;
    }

    public void setJoinDateFrom(String joinDateFrom) {
        this.joinDateFrom = joinDateFrom;
    }

    public String getJoinDateTo() {
        return joinDateTo;
    }

    public void setJoinDateTo(String joinDateTo) {
        this.joinDateTo = joinDateTo;
    }

    public String getMemberGrade() {
        return memberGrade;
    }

    public void setMemberGrade(String memberGrade) {
        this.memberGrade = memberGrade;
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

    public int getPageIndex() {
        return pageIndex;
    }

    public void setPageIndex(int pageIndex) {
        this.pageIndex = pageIndex;
    }

    public int getPageUnit() {
        return pageUnit;
    }

    public void setPageUnit(int pageUnit) {
        this.pageUnit = pageUnit;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public int getFirstIndex() {
        return firstIndex;
    }

    public void setFirstIndex(int firstIndex) {
        this.firstIndex = firstIndex;
    }

    public int getLastIndex() {
        return lastIndex;
    }

    public void setLastIndex(int lastIndex) {
        this.lastIndex = lastIndex;
    }

    public int getRecordCountPerPage() {
        return recordCountPerPage;
    }

    public void setRecordCountPerPage(int recordCountPerPage) {
        this.recordCountPerPage = recordCountPerPage;
    }
}
