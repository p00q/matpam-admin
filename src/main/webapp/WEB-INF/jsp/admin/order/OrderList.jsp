<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<div class="container-fluid px-4">
    <h1 class="mt-4">주문 통합 관리</h1>
    <ol class="breadcrumb mb-4">
        <li class="breadcrumb-item"><a href="<c:url value='/admin/dashboard/main.do'/>">대시보드</a></li>
        <li class="breadcrumb-item active">주문 현황</li>
    </ol>

    <!-- 검색 필터 -->
    <div class="card mb-4 shadow-sm border-0">
        <div class="card-body bg-light rounded">
            <form:form modelAttribute="searchVO" action="/admin/order/orderList.do" method="get" class="row g-3">
                <div class="col-md-4">
                    <label class="form-label fw-bold small text-muted">주문번호 검색</label>
                    <form:input path="searchKeyword" class="form-control" placeholder="주문번호를 입력하세요" />
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold small text-muted">주문 상태</label>
                    <form:select path="orderStatus" class="form-select">
                        <form:option value="" label="전체 상태" />
                        <form:option value="RECEIVED" label="주문접수" />
                        <form:option value="CONFIRMED" label="주문확정" />
                        <form:option value="COMPLETED" label="거래완료" />
                        <form:option value="CANCELLED" label="주문취소" />
                    </form:select>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100 shadow-sm">
                        <i class="fas fa-search me-1"></i> 검색
                    </button>
                </div>
            </form:form>
        </div>
    </div>

    <!-- 목록 테이블 -->
    <div class="card mb-4 shadow-sm border-0">
        <div class="card-header bg-white py-3 border-bottom-0 d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-list me-1"></i> 주문 목록</h6>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light">
                        <tr>
                            <th class="ps-4" style="width: 180px;">주문번호</th>
                            <th>구매사 / 판매사</th>
                            <th class="text-end">총 결제금액</th>
                            <th class="text-center">주문상태</th>
                            <th class="text-center">결제상태</th>
                            <th class="text-center">주문일자</th>
                            <th class="text-center pe-4">상세</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="result" items="${resultList}">
                            <tr>
                                <td class="ps-4 fw-bold text-dark">${result.orderNo}</td>
                                <td>
                                    <div class="fw-bold">${result.buyerCompanyName}</div>
                                    <div class="small text-muted"><i class="fas fa-arrow-right me-1"></i> ${result.sellerCompanyName}</div>
                                </td>
                                <td class="text-end fw-bold text-primary">
                                    <fmt:formatNumber value="${result.totalOrderAmount}" pattern="#,###" /> 원
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${result.orderStatus == 'RECEIVED'}"><span class="badge bg-info text-white px-3 py-2">주문접수</span></c:when>
                                        <c:when test="${result.orderStatus == 'CONFIRMED'}"><span class="badge bg-primary text-white px-3 py-2">주문확정</span></c:when>
                                        <c:when test="${result.orderStatus == 'COMPLETED'}"><span class="badge bg-success text-white px-3 py-2">거래완료</span></c:when>
                                        <c:when test="${result.orderStatus == 'CANCELLED'}"><span class="badge bg-danger text-white px-3 py-2">주문취소</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary text-white px-3 py-2">${result.orderStatus}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <span class="small fw-bold ${result.paymentStatus == 'PAID' ? 'text-success' : 'text-warning'}">
                                        <i class="fas fa-circle me-1" style="font-size: 8px;"></i>${result.paymentStatus}
                                    </span>
                                </td>
                                <td class="text-center text-muted">
                                    <fmt:formatDate value="${result.orderDate}" pattern="yyyy-MM-dd" />
                                </td>
                                <td class="text-center pe-4">
                                    <a href="<c:url value='/admin/order/orderDetail.do?orderId=${result.orderId}'/>" class="btn btn-outline-secondary btn-sm rounded-pill px-3">
                                        보기
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty resultList}">
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted">주문 내역이 없습니다.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="card-footer bg-white py-3 border-top-0">
            <div class="d-flex justify-content-center">
                <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_egov_link_page" />
            </div>
        </div>
    </div>
</div>

<script>
function fn_egov_link_page(pageNo){
    location.href = "<c:url value='/admin/order/orderList.do'/>?pageIndex=" + pageNo + "&searchKeyword=${searchVO.searchKeyword}&orderStatus=${searchVO.orderStatus}";
}
</script>
