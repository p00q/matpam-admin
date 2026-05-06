<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<div class="container-fluid px-4">
    <h1 class="mt-4">업체 관리</h1>
    <ol class="breadcrumb mb-4">
        <li class="breadcrumb-item"><a href="/admin/dashboard/main.do">대시보드</a></li>
        <li class="breadcrumb-item active">업체 관리</li>
    </ol>

    <!-- 검색 필터 -->
    <div class="card mb-4 shadow-sm">
        <div class="card-header bg-light">
            <i class="fas fa-search me-1"></i> 검색 조건
        </div>
        <div class="card-body">
            <form:form modelAttribute="searchVO" id="searchForm" name="searchForm" method="get" action="${pageContext.request.contextPath}/admin/company/companyList.do" class="row g-3">
                <form:hidden path="pageIndex" id="pageIndex" />
                
                <div class="col-md-3">
                    <label class="form-label">업체 타입</label>
                    <form:select path="companyType" class="form-select">
                        <form:option value="" label="-- 전체 --" />
                        <form:option value="SELLER" label="판매업체" />
                        <form:option value="BUYER" label="구매업체" />
                    </form:select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">상태</label>
                    <form:select path="status" class="form-select">
                        <form:option value="" label="-- 전체 --" />
                        <form:option value="ACTIVE" label="활성" />
                        <form:option value="INACTIVE" label="비활성" />
                    </form:select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">검색어 (업체명/사업자번호)</label>
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
    <div class="card mb-4 shadow-sm">
        <div class="card-header d-flex justify-content-between align-items-center bg-white py-3">
            <div>
                <i class="fas fa-table me-1"></i> 업체 목록
            </div>
            <a href="<c:url value='/admin/company/companyForm.do?companyType=${searchVO.companyType}'/>" class="btn btn-success btn-sm">
                <i class="fas fa-plus"></i> 신규 업체 등록
            </a>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="text-center" style="width: 80px;">ID</th>
                            <th>업체명</th>
                            <th>사업자번호</th>
                            <th>대표자</th>
                            <th class="text-center">타입</th>
                            <th class="text-center">과세/유형</th>
                            <th class="text-center">상태</th>
                            <th class="text-center">등록일</th>
                            <th class="text-center" style="width: 150px;">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${companyList}" varStatus="status">
                            <tr>
                                <td class="text-center text-muted">${item.companyId}</td>
                                <td class="fw-bold">${item.companyName}</td>
                                <td>${item.businessNo}</td>
                                <td>${item.ceoName}</td>
                                <td class="text-center">
                                    <span class="badge ${item.companyType == 'SELLER' ? 'bg-primary' : 'bg-info'}">
                                        ${item.companyType}
                                    </span>
                                </td>
                                <td class="text-center">
                                    <c:if test="${item.companyType == 'SELLER'}">
                                        <span class="badge ${item.defaultTaxType == 'TAXABLE' ? 'bg-warning text-dark' : 'bg-success'} mb-1">
                                            ${item.defaultTaxType == 'TAXABLE' ? '과세' : '면세'}
                                        </span>
                                        <br/>
                                        <small class="text-muted">${item.sellerType}</small>
                                    </c:if>
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${item.status == 'ACTIVE'}">
                                            <span class="badge bg-success">활성</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">비활성</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <fmt:formatDate value="${item.createdAt}" pattern="yyyy-MM-dd" />
                                </td>
                                <td class="text-center">
                                    <div class="btn-group btn-group-sm">
                                        <a href="<c:url value='/admin/company/companyForm.do?companyId=${item.companyId}'/>" class="btn btn-outline-primary" title="수정">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <button type="button" class="btn btn-outline-danger btn-toggle-status" data-id="${item.companyId}" data-status="${item.status}" title="상태변경">
                                            <i class="fas ${item.status == 'ACTIVE' ? 'fa-user-slash' : 'fa-user-check'}"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty companyList}">
                            <tr>
                                <td colspan="9" class="text-center py-5 text-muted">
                                    등록된 업체 정보가 없습니다.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
        <!-- 페이징 -->
        <div class="card-footer bg-white py-3">
            <div class="d-flex justify-content-center">
                <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_egov_link_page" />
            </div>
        </div>
    </div>
</div>

<script>
function fn_egov_link_page(pageNo) {
    document.searchForm.pageIndex.value = pageNo;
    document.searchForm.action = "${pageContext.request.contextPath}/admin/company/companyList.do";
    document.searchForm.submit();
}

$(document).ready(function() {
    $('.btn-toggle-status').on('click', function() {
        const companyId = $(this).data('id');
        const currentStatus = $(this).data('status');
        toggleStatus(companyId, currentStatus);
    });
});

function toggleStatus(companyId, currentStatus) {
    const newStat = currentStatus === 'ACTIVE' ? 'INACTIVE' : 'ACTIVE';
    const statusMsg = newStat === 'ACTIVE' ? '활성' : '비활성';
    
    if (!confirm('업체 상태를 ' + statusMsg + '으로 변경하시겠습니까?')) return;

    $.ajax({
        url: '<c:url value="/admin/company/updateStatus.ajax"/>',
        type: 'POST',
        data: { companyId: companyId, status: newStat },
        success: function(res) {
            if (res.success) {
                location.reload();
            } else {
                alert('오류가 발생했습니다: ' + res.message);
            }
        },
        error: function() {
            alert('서버 통신 중 오류가 발생했습니다.');
        }
    });
}
</script>
