<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<div class="container-fluid px-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="mt-4 fw-bold text-dark">구매업체(회원) 관리</h1>
            <p class="text-muted">B2B 구매 고객사 정보를 통합 관리합니다.</p>
        </div>
    </div>

    <!-- 검색 필터 -->
    <div class="card mb-4 border-0 shadow-sm overflow-hidden" style="border-radius: 15px;">
        <div class="card-header bg-white py-3 border-0">
            <h6 class="m-0 fw-bold text-primary"><i class="bi bi-search me-2"></i>검색 조건</h6>
        </div>
        <div class="card-body bg-light bg-opacity-50">
            <form:form modelAttribute="searchVO" id="searchForm" name="searchForm" method="get" action="${pageContext.request.contextPath}/admin/member/memberList.do" class="row g-3">
                <form:hidden path="pageIndex" id="pageIndex" />
                
                <div class="col-md-8">
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="bi bi-building"></i></span>
                        <form:input path="searchKeyword" class="form-control border-start-0" placeholder="업체명 또는 사업자번호로 검색하세요" />
                    </div>
                </div>
                <div class="col-md-4">
                    <button type="submit" class="btn btn-primary w-100 fw-bold">
                        조회하기
                    </button>
                </div>
            </form:form>
        </div>
    </div>

    <!-- 목록 테이블 -->
    <div class="card mb-4 border-0 shadow-sm" style="border-radius: 15px;">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-primary bg-opacity-10">
                        <tr>
                            <th class="ps-4" style="width: 100px;">ID</th>
                            <th>업체명</th>
                            <th>사업자번호</th>
                            <th>대표자</th>
                            <th>연락처</th>
                            <th class="text-center">등록일</th>
                            <th class="text-center">상태</th>
                            <th class="pe-4 text-center" style="width: 100px;">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${memberList}" varStatus="status">
                            <tr>
                                <td class="ps-4 text-muted small">${item.companyId}</td>
                                <td class="fw-bold text-primary">${item.companyName}</td>
                                <td class="fw-semibold">${item.businessNo}</td>
                                <td>${item.ceoName}</td>
                                <td>${item.phone}</td>
                                <td class="text-center text-muted">
                                    <fmt:formatDate value="${item.createdAt}" pattern="yyyy-MM-dd" />
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${item.status == 'ACTIVE'}">
                                            <span class="badge bg-success rounded-pill px-3">정상</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger rounded-pill px-3">중지</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="pe-4 text-center">
                                    <button class="btn btn-sm btn-outline-primary rounded-pill">
                                        상세
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty memberList}">
                            <tr>
                                <td colspan="8" class="text-center py-5">
                                    <div class="py-5">
                                        <i class="bi bi-inbox text-muted" style="font-size: 3rem;"></i>
                                        <p class="mt-3 text-muted">조회된 구매업체 정보가 없습니다.</p>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="card-footer bg-white border-0 py-4" style="border-bottom-left-radius: 15px; border-bottom-right-radius: 15px;">
            <div class="d-flex justify-content-center">
                <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_egov_link_page" />
            </div>
        </div>
    </div>
</div>

<script>
function fn_egov_link_page(pageNo) {
    document.searchForm.pageIndex.value = pageNo;
    document.searchForm.submit();
}
</script>
