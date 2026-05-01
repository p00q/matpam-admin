<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<div class="container-fluid px-4">
    <h1 class="mt-4">사용자 관리</h1>
    <ol class="breadcrumb mb-4">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard/main.do">대시보드</a></li>
        <li class="breadcrumb-item active">사용자 관리</li>
    </ol>

    <!-- 검색 필터 -->
    <div class="card mb-4 shadow-sm">
        <div class="card-header bg-light text-dark">
            <i class="fas fa-search me-1"></i> 검색 조건
        </div>
        <div class="card-body">
            <form:form modelAttribute="searchVO" id="searchForm" name="searchForm" method="get" action="${pageContext.request.contextPath}/admin/user/userList.do" class="row g-3">
                <form:hidden path="pageIndex" id="pageIndex" />
                
                <div class="col-md-3">
                    <label class="form-label">소속 업체</label>
                    <form:select path="companyId" class="form-select">
                        <form:option value="" label="-- 전체 --" />
                        <c:forEach var="comp" items="${companies}">
                            <form:option value="${comp.companyId}" label="${comp.companyName}" />
                        </c:forEach>
                    </form:select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">권한</label>
                    <form:select path="userRole" class="form-select">
                        <form:option value="" label="-- 전체 --" />
                        <form:option value="SUPER_ADMIN" label="슈퍼관리자" />
                        <form:option value="SELLER_ADMIN" label="판매처관리자" />
                        <form:option value="BUYER_ADMIN" label="구매처관리자" />
                    </form:select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">검색어 (ID/이름)</label>
                    <form:input path="searchKeyword" class="form-control" placeholder="검색어를 입력하세요" />
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-search"></i> 검색
                    </button>
                </div>
            </form:form>
        </div>
    </div>

    <!-- 목록 테이블 -->
    <div class="card mb-4 shadow-sm border-0">
        <div class="card-header d-flex justify-content-between align-items-center bg-white py-3 border-bottom">
            <h6 class="m-0 font-weight-bold text-primary">사용자 목록</h6>
            <a href="${pageContext.request.contextPath}/admin/user/userForm.do" class="btn btn-success btn-sm shadow-sm">
                <i class="fas fa-user-plus me-1"></i> 신규 사용자 등록
            </a>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light text-secondary">
                        <tr>
                            <th class="text-center" style="width: 60px;">ID</th>
                            <th>로그인 ID</th>
                            <th>사용자명</th>
                            <th>소속 업체</th>
                            <th class="text-center">권한</th>
                            <th class="text-center">연락처</th>
                            <th class="text-center">상태</th>
                            <th class="text-center">최근 로그인</th>
                            <th class="text-center" style="width: 120px;">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${userList}" varStatus="status">
                            <tr>
                                <td class="text-center text-muted small">${item.userId}</td>
                                <td class="fw-bold">${item.loginId}</td>
                                <td>${item.userName}</td>
                                <td>
                                    <c:forEach var="comp" items="${companies}">
                                        <c:if test="${comp.companyId == item.companyId}">
                                            <span class="text-info font-weight-bold">${comp.companyName}</span>
                                        </c:if>
                                    </c:forEach>
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${item.userRole == 'SUPER_ADMIN'}"><span class="badge bg-dark">슈퍼관리자</span></c:when>
                                        <c:when test="${item.userRole == 'SELLER_ADMIN'}"><span class="badge bg-primary">판매처관리자</span></c:when>
                                        <c:when test="${item.userRole == 'BUYER_ADMIN'}"><span class="badge bg-info">구매처관리자</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">${item.userRole}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center small">${item.mobile}</td>
                                <td class="text-center">
                                    <span class="badge rounded-pill ${item.status == 'ACTIVE' ? 'bg-success' : 'bg-danger'}">
                                        ${item.status == 'ACTIVE' ? '활성' : '중지'}
                                    </span>
                                </td>
                                <td class="text-center text-muted x-small">
                                    <fmt:formatDate value="${item.lastLoginAt}" pattern="yyyy-MM-dd HH:mm" />
                                </td>
                                <td class="text-center">
                                    <a href="${pageContext.request.contextPath}/admin/user/userForm.do?userId=${item.userId}" class="btn btn-sm btn-outline-primary" title="수정">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty userList}">
                            <tr>
                                <td colspan="9" class="text-center py-5 text-muted">
                                    등록된 사용자 정보가 없습니다.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="card-footer bg-white border-top-0 py-3">
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
<style>
    .x-small { font-size: 0.75rem; }
</style>
