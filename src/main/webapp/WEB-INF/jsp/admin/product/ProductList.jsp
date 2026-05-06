<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<div class="container-fluid px-4">
    <h1 class="mt-4">상품 마스터 관리</h1>
    <ol class="breadcrumb mb-4">
        <li class="breadcrumb-item"><a href="<c:url value='/admin/dashboard/main.do'/>">대시보드</a></li>
        <li class="breadcrumb-item active">상품 마스터</li>
    </ol>

    <!-- 검색 필터 -->
    <div class="card mb-4 shadow-sm">
        <div class="card-body bg-light">
            <form:form modelAttribute="searchVO" action="/admin/product/productList.do" method="get" class="row g-3">
                <div class="col-md-4">
                    <label class="form-label fw-bold">상품 검색</label>
                    <form:input path="searchKeyword" class="form-control" placeholder="상품명 또는 상품코드를 입력하세요" />
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold">판매 상태</label>
                    <form:select path="saleStatus" class="form-select">
                        <form:option value="" label="전체" />
                        <form:option value="ON_SALE" label="판매중" />
                        <form:option value="STOPPED" label="판매중지" />
                        <form:option value="HIDDEN" label="숨김" />
                    </form:select>
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
                <i class="fas fa-box me-1"></i> 상품 목록
            </div>
            <a href="<c:url value='/admin/product/productForm.do'/>" class="btn btn-success btn-sm">
                <i class="fas fa-plus"></i> 신규 상품 등록
            </a>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="text-center" style="width: 80px;">ID</th>
                            <th>상품코드</th>
                            <th>상품명</th>
                            <th>구분 / 유형</th>
                            <th>과세구분</th>
                            <th>단위</th>
                            <th class="text-center">판매상태</th>
                            <th class="text-center">등록일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="result" items="${resultList}" varStatus="status">
                            <tr style="cursor:pointer;" onclick="location.href='<c:url value='/admin/product/productForm.do?productId=${result.productId}'/>'">
                                <td class="text-center text-muted">${result.productId}</td>
                                <td class="fw-bold text-primary">${result.productCode}</td>
                                <td>${result.productName}</td>
                                <td>
                                    <span class="badge bg-secondary">${result.itemKind}</span>
                                    <small class="text-muted">${result.processingType}</small>
                                </td>
                                <td>${result.taxCategory == 'TAXABLE' ? '과세' : '면세'}</td>
                                <td>${result.unitName}</td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${result.saleStatus == 'ON_SALE'}"><span class="badge bg-success">판매중</span></c:when>
                                        <c:when test="${result.saleStatus == 'STOPPED'}"><span class="badge bg-danger">판매중지</span></c:when>
                                        <c:otherwise><span class="badge bg-warning text-dark">숨김</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <fmt:formatDate value="${result.createdAt}" pattern="yyyy-MM-dd" />
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty resultList}">
                            <tr>
                                <td colspan="8" class="text-center py-5 text-muted">등록된 상품이 없습니다.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="card-footer bg-white py-3">
            <div class="d-flex justify-content-center">
                <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_egov_link_page" />
            </div>
        </div>
    </div>
</div>

<script>
function fn_egov_link_page(pageNo){
    location.href = "<c:url value='/admin/product/productList.do'/>?pageIndex=" + pageNo + "&searchKeyword=${searchVO.searchKeyword}&saleStatus=${searchVO.saleStatus}";
}
</script>
