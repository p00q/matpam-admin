<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<div class="container-fluid px-4">
    <h1 class="mt-4">상품 관리</h1>
    <ol class="breadcrumb mb-4">
        <li class="breadcrumb-item"><a href="<c:url value='/admin/dashboard/main.do'/>">대시보드</a></li>
        <li class="breadcrumb-item active">상품 관리</li>
    </ol>

    <div class="card mb-4 shadow-sm">
        <div class="card-body bg-light">
            <form:form modelAttribute="searchVO" action="/admin/product/productList.do" method="get" class="row g-3">
                <div class="col-md-4">
                    <label class="form-label fw-bold">상품 검색</label>
                    <form:input path="searchKeyword" class="form-control" placeholder="상품명 또는 상품번호" />
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold">품목상태</label>
                    <form:select path="saleStatus" class="form-select">
                        <form:option value="" label="전체" />
                        <form:option value="ON_SALE" label="판매중" />
                        <form:option value="STOPPED" label="판매중지" />
                        <form:option value="SOLD_OUT" label="품절" />
                        <form:option value="APPROVAL_WAIT" label="승인대기" />
                        <form:option value="TEMP_SAVE" label="임시저장" />
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

    <div class="card mb-4 shadow-sm">
        <div class="card-header d-flex justify-content-between align-items-center bg-white py-3">
            <div>
                <i class="fas fa-box me-1"></i> 상품 목록
            </div>
            <a href="<c:url value='/admin/product/productForm.do'/>" class="btn btn-success btn-sm">
                <i class="fas fa-plus"></i> 상품 등록
            </a>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="text-center" style="width: 80px;">ID</th>
                            <th>상품번호</th>
                            <th>상품명</th>
                            <th>판매자명</th>
                            <th>상품유형</th>
                            <th>과세여부</th>
                            <th class="text-end">판매가격</th>
                            <th class="text-center">전시순번</th>
                            <th class="text-center">옵션</th>
                            <th class="text-center">품목상태</th>
                            <th class="text-center">등록일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="result" items="${resultList}">
                            <tr style="cursor:pointer;" onclick="location.href='<c:url value='/admin/product/productForm.do?productId=${result.productId}'/>'">
                                <td class="text-center text-muted">${result.productId}</td>
                                <td class="fw-bold text-primary">${result.productCode}</td>
                                <td>${result.productName}</td>
                                <td>${empty result.sellerCompanyName ? '-' : result.sellerCompanyName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${result.processingType == 'RAW_GOODS'}"><span class="badge bg-success">원물</span></c:when>
                                        <c:when test="${result.processingType == 'FINISHED_GOODS'}"><span class="badge bg-primary">완제품</span></c:when>
                                        <c:when test="${result.processingType == 'PROCESSED_GOODS'}"><span class="badge bg-warning text-dark">가공</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">${result.processingType}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${result.taxCategory == 'TAXABLE' ? '과세' : '면세'}</td>
                                <td class="text-end">
                                    <c:choose>
                                        <c:when test="${not empty result.salePrice}">
                                            <fmt:formatNumber value="${result.salePrice}" pattern="#,##0.##" /> 원
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">${empty result.displayOrder ? '-' : result.displayOrder}</td>
                                <td class="text-center">
                                    <c:if test="${result.isNew == 'Y'}"><span class="badge bg-info text-dark">신</span></c:if>
                                    <c:if test="${result.isMonthly == 'Y'}"><span class="badge bg-primary">월</span></c:if>
                                    <c:if test="${result.isHidden == 'Y'}"><span class="badge bg-secondary">숨김</span></c:if>
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${result.saleStatus == 'ON_SALE'}"><span class="badge bg-success">판매중</span></c:when>
                                        <c:when test="${result.saleStatus == 'STOPPED'}"><span class="badge bg-danger">판매중지</span></c:when>
                                        <c:when test="${result.saleStatus == 'SOLD_OUT'}"><span class="badge bg-secondary">품절</span></c:when>
                                        <c:when test="${result.saleStatus == 'APPROVAL_WAIT'}"><span class="badge bg-info text-dark">승인대기</span></c:when>
                                        <c:when test="${result.saleStatus == 'TEMP_SAVE'}"><span class="badge bg-light text-dark">임시저장</span></c:when>
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
                                <td colspan="11" class="text-center py-5 text-muted">등록된 상품이 없습니다.</td>
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
