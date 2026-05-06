<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="container-fluid px-4">
    <div class="d-flex justify-content-between align-items-center mt-4 mb-4">
        <h1 class="h3 mb-0 text-gray-800">주문 상세 내역</h1>
        <a href="<c:url value='/admin/order/orderList.do'/>" class="btn btn-light border btn-sm shadow-sm">
            <i class="fas fa-chevron-left me-1"></i> 목록으로
        </a>
    </div>

    <div class="row">
        <!-- 좌측: 주문 정보 요약 -->
        <div class="col-xl-4 col-md-5">
            <div class="card shadow-sm border-0 mb-4">
                <div class="card-header bg-white py-3 border-bottom-0">
                    <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-info-circle me-1"></i> 주문 요약</h6>
                </div>
                <div class="card-body">
                    <div class="mb-4">
                        <div class="small text-muted mb-1">주문번호</div>
                        <div class="h5 fw-bold text-dark">${order.orderNo}</div>
                    </div>
                    <div class="mb-4">
                        <div class="small text-muted mb-1">진행 상태</div>
                        <div>
                            <c:choose>
                                <c:when test="${order.orderStatus == 'RECEIVED'}"><span class="badge bg-info text-white">주문접수</span></c:when>
                                <c:when test="${order.orderStatus == 'CONFIRMED'}"><span class="badge bg-primary text-white">주문확정</span></c:when>
                                <c:when test="${order.orderStatus == 'COMPLETED'}"><span class="badge bg-success text-white">거래완료</span></c:when>
                                <c:when test="${order.orderStatus == 'CANCELLED'}"><span class="badge bg-danger text-white">주문취소</span></c:when>
                                <c:otherwise><span class="badge bg-secondary text-white">${order.orderStatus}</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <hr class="my-4">
                    <div class="row mb-3">
                        <div class="col-6 small text-muted">구매사</div>
                        <div class="col-6 text-end fw-bold">${order.buyerCompanyName}</div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-6 small text-muted">판매사</div>
                        <div class="col-6 text-end fw-bold">${order.sellerCompanyName}</div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-6 small text-muted">주문일자</div>
                        <div class="col-6 text-end"><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm" /></div>
                    </div>
                    <hr class="my-4">
                    <div class="row mb-2">
                        <div class="col-6 text-muted">공급가액</div>
                        <div class="col-6 text-end"><fmt:formatNumber value="${order.totalSupplyAmount}" pattern="#,###" /> 원</div>
                    </div>
                    <div class="row mb-2">
                        <div class="col-6 text-muted">부가세</div>
                        <div class="col-6 text-end"><fmt:formatNumber value="${order.totalVatAmount}" pattern="#,###" /> 원</div>
                    </div>
                    <div class="row mt-3 pt-3 border-top">
                        <div class="col-6 fw-bold text-dark">최종 결제액</div>
                        <div class="col-6 text-end h5 fw-bold text-primary mb-0">
                            <fmt:formatNumber value="${order.totalOrderAmount}" pattern="#,###" /> 원
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 우측: 주문 상품 상세 -->
        <div class="col-xl-8 col-md-7">
            <div class="card shadow-sm border-0 mb-4">
                <div class="card-header bg-white py-3 border-bottom-0">
                    <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-box-open me-1"></i> 주문 상품 상세 (${order.orderLines.size()})</h6>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light">
                                <tr>
                                    <th class="ps-4" style="width: 50px;">#</th>
                                    <th>상품명 / 유형</th>
                                    <th class="text-center">단가</th>
                                    <th class="text-center">수량</th>
                                    <th class="text-end pe-4">합계 (VAT포함)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="line" items="${order.orderLines}">
                                    <tr>
                                        <td class="ps-4 text-muted small">${line.lineNo}</td>
                                        <td>
                                            <div class="fw-bold">${line.productNameSnapshot}</div>
                                            <div class="small text-muted">${line.itemKindSnapshot} | ${line.unitNameSnapshot}</div>
                                        </td>
                                        <td class="text-center">
                                            <fmt:formatNumber value="${line.unitPrice}" pattern="#,###" />
                                        </td>
                                        <td class="text-center fw-bold">${line.qty}</td>
                                        <td class="text-end pe-4 fw-bold">
                                            <fmt:formatNumber value="${line.totalAmount}" pattern="#,###" /> 원
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty order.orderLines}">
                                    <tr>
                                        <td colspan="5" class="text-center py-5 text-muted">주문 상품 정보가 없습니다.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- 하단 메모/기타 정보 -->
            <div class="card shadow-sm border-0">
                <div class="card-body">
                    <h6 class="font-weight-bold text-dark mb-3"><i class="fas fa-sticky-note me-1"></i> 주문 관리자 메모</h6>
                    <div class="p-3 bg-light rounded text-muted">
                        ${empty order.description ? '등록된 메모가 없습니다.' : order.description}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
