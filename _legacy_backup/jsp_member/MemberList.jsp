<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<style>
    .search-box { background: #f8f9fa; border: 1px solid #dee2e6; padding: 20px; border-radius: 4px; margin-bottom: 30px; }
    .search-table { width: 100%; }
    .search-table th { width: 120px; padding: 10px; font-weight: 600; font-size: 13px; color: #444; }
    .search-table td { padding: 5px 10px; }
    .btn-search { background: #6c757d; color: #fff; border: none; padding: 8px 40px; border-radius: 20px; font-weight: 600; }
    .btn-reset { background: #adb5bd; color: #fff; border: none; padding: 8px 40px; border-radius: 20px; font-weight: 600; }
    .member-table thead th { background: #e9ecef; color: #333; font-weight: 600; font-size: 13px; text-align: center; border-bottom: 2px solid #dee2e6; }
    .member-table tbody td { text-align: center; font-size: 13px; vertical-align: middle; }
    .link-company { color: #d9534f; text-decoration: none; font-weight: 600; }
    .text-ceo { color: #d9534f; font-weight: 600; }
    .badge-status-join { color: #2c5f7c; }
    .btn-new { background: #6c757d; color: #fff; padding: 8px 25px; border-radius: 20px; font-size: 13px; }
</style>

<div class="container-fluid p-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="fw-bold">회원관리</h4>
        <div class="text-muted small">홈 > 회원관리</div>
    </div>

    <!-- Search Area (Screenshot 1) -->
    <div class="search-box">
        <form id="searchForm" action="/admin/member/memberList.do" method="get">
            <table class="search-table">
                <tr>
                    <th>가입상태</th>
                    <td>
                        <select name="searchStatus" class="form-select form-select-sm w-75">
                            <option value="">전체</option>
                            <c:forEach var="code" items="${statusCodes}">
                                <option value="${code.detailCode}">${code.detailCodeName}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <th>가입일</th>
                    <td>
                        <div class="d-flex align-items-center gap-2">
                            <input type="date" class="form-control form-control-sm" style="width: 150px;">
                            <span>-</span>
                            <input type="date" class="form-control form-control-sm" style="width: 150px;">
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>지역</th>
                    <td>
                        <select class="form-select form-select-sm w-75">
                            <option value="">전체</option>
                        </select>
                    </td>
                    <th>회원등급</th>
                    <td>
                        <select name="searchGrade" class="form-select form-select-sm w-50">
                            <option value="">전체</option>
                            <c:forEach var="code" items="${memberGrades}">
                                <option value="${code.detailCode}">${code.detailCodeName}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>검색</th>
                    <td colspan="3">
                        <div class="d-flex gap-2">
                            <select name="searchCondition" class="form-select form-select-sm" style="width: 120px;">
                                <option value="1">업체명</option>
                                <option value="2">아이디</option>
                            </select>
                            <input type="text" name="searchKeyword" class="form-control form-control-sm w-50" placeholder="검색어를 입력하세요">
                        </div>
                    </td>
                </tr>
            </table>
            <div class="d-flex justify-content-center gap-2 mt-4">
                <button type="submit" class="btn-search">검색</button>
                <button type="button" class="btn-reset" onclick="location.href='/admin/member/memberList.do'">초기화</button>
            </div>
        </form>
    </div>

    <!-- Table Area -->
    <div class="d-flex justify-content-between align-items-end mb-2">
        <div class="small fw-bold">TOTAL : <span class="text-primary">${paginationInfo.totalRecordCount}</span>건</div>
        <button class="btn btn-secondary btn-sm px-3">엑셀다운로드</button>
    </div>

    <div class="table-responsive border-top">
        <table class="table table-hover member-table">
            <thead>
                <tr>
                    <th>순번</th>
                    <th>채널</th>
                    <th>업체명</th>
                    <th>유형</th>
                    <th>등급</th>
                    <th>대표명</th>
                    <th>휴대폰번호</th>
                    <th>담당자</th>
                    <th>담당자연락처</th>
                    <th>상태</th>
                    <th>최근 접속일</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${resultList}" varStatus="status">
                    <tr>
                        <td>${paginationInfo.totalRecordCount - ((searchVO.getPageIndex()-1) * searchVO.getPageUnit() + status.index)}</td>
                        <td>${item.channelCd}</td>
                        <td><a href="/admin/member/memberDetail.do?memberId=${item.memberId}" class="link-company">${item.companyName}</a></td>
                        <td>
                            <c:choose>
                                <c:when test="${fn:contains(item.memberTypeCd, 'BUYER')}">구매자</c:when>
                                <c:when test="${fn:contains(item.memberTypeCd, 'SELLER')}">판매자</c:when>
                                <c:when test="${fn:contains(item.memberTypeCd, 'COMPANY_ADMIN')}">업체마스터</c:when>
                                <c:when test="${fn:contains(item.memberTypeCd, 'SUPER_ADMIN')}">수퍼관리자</c:when>
                                <c:otherwise>관리자</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${item.memberGradeCd}</td>
                        <td class="text-ceo">${item.ceoName}</td>
                        <td>${item.ceoMobileNo}</td>
                        <td>${not empty item.contacts ? item.contacts[0].name : '-'}</td>
                        <td>${not empty item.contacts ? item.contacts[0].mobileNo : '-'}</td>
                        <td class="badge-status-join">가입완료</td>
                        <td><fmt:formatDate value="${item.lastLoginDt}" pattern="yyyy-MM-dd" /></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty resultList}">
                    <tr>
                        <td colspan="11" class="py-5 text-muted">데이터가 존재하지 않습니다.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <!-- Pagination & New Button -->
    <div class="d-flex justify-content-center mt-4 position-relative">
        <nav>
            <ul class="pagination pagination-sm mb-0">
                <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_pagination" />
            </ul>
        </nav>
        <div class="position-absolute end-0 top-0">
            <button class="btn-new" onclick="location.href='/admin/member/memberDetail.do'">신규등록</button>
        </div>
    </div>
</div>

<script>
    function fn_pagination(pageNo) {
        location.href = "/admin/member/memberList.do?pageIndex=" + pageNo;
    }
</script>