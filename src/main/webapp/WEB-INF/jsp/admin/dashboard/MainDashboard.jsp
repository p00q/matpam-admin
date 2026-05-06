<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="row align-items-center mb-4">
    <div class="col">
        <h2 class="page-title">대시보드 요약</h2>
    </div>
</div>

<!-- 1. 통계 위젯 4종 -->
<div class="row">
    <!-- 금일 매출액 -->
    <div class="col-md-6 col-xl-3 mb-4">
        <div class="card shadow border-0">
            <div class="card-body">
                <div class="row align-items-center">
                    <div class="col-3 text-center">
                        <span class="circle circle-sm bg-primary text-white">
                            <i class="fe fe-16 fe-dollar-sign"></i>
                        </span>
                    </div>
                    <div class="col pr-0">
                        <p class="small text-muted mb-0">금일 매출액</p>
                        <span class="h3 mb-0"><fmt:formatNumber value="${summary.todaySales}" pattern="#,###"/> 원</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- 오늘 신규 주문 -->
    <div class="col-md-6 col-xl-3 mb-4">
        <div class="card shadow border-0">
            <div class="card-body">
                <div class="row align-items-center">
                    <div class="col-3 text-center">
                        <span class="circle circle-sm bg-success text-white">
                            <i class="fe fe-16 fe-shopping-cart"></i>
                        </span>
                    </div>
                    <div class="col pr-0">
                        <p class="small text-muted mb-0">신규 주문 (오늘)</p>
                        <span class="h3 mb-0">${summary.todayOrderCount} 건</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- 배송 준비중 -->
    <div class="col-md-6 col-xl-3 mb-4">
        <div class="card shadow border-0">
            <div class="card-body">
                <div class="row align-items-center">
                    <div class="col-3 text-center">
                        <span class="circle circle-sm bg-warning text-white">
                            <i class="fe fe-16 fe-truck"></i>
                        </span>
                    </div>
                    <div class="col pr-0">
                        <p class="small text-muted mb-0">배송 준비중</p>
                        <span class="h3 mb-0">${summary.readyShippingCount} 건</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- 신규 가입 회원 -->
    <div class="col-md-6 col-xl-3 mb-4">
        <div class="card shadow border-0">
            <div class="card-body">
                <div class="row align-items-center">
                    <div class="col-3 text-center">
                        <span class="circle circle-sm bg-info text-white">
                            <i class="fe fe-16 fe-users"></i>
                        </span>
                    </div>
                    <div class="col pr-0">
                        <p class="small text-muted mb-0">신규 가입 (오늘)</p>
                        <span class="h3 mb-0">${summary.todayNewMemberCount} 명</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <!-- 2. 최근 7일 매출 차트 -->
    <div class="col-md-12 col-xl-8 mb-4">
        <div class="card shadow border-0 h-100">
            <div class="card-header">
                <strong class="card-title">최근 7일 간 일매출 추이</strong>
            </div>
            <div class="card-body">
                <canvas id="salesChart" style="min-height: 250px; height: 300px; max-height: 300px; max-width: 100%;"></canvas>
            </div>
        </div>
    </div>
    
    <!-- 3. 최근 주문 리스트 -->
    <div class="col-md-12 col-xl-4 mb-4">
        <div class="card shadow border-0 h-100">
            <div class="card-header border-0 pb-0">
                <strong class="card-title">최근 접수 주문</strong>
                <a class="float-right small text-muted" href="/admin/order/orderList.do">전체보기</a>
            </div>
            <div class="card-body custom-scroll" style="overflow-y: auto;">
                <table class="table table-borderless table-striped table-sm mb-0">
                    <thead class="thead-dark">
                        <tr>
                            <th>서머리</th>
                            <th class="text-right">결제액</th>
                            <th class="text-center">상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${recentOrders}">
                            <tr>
                                <td>
                                    <div class="mb-0 text-muted small">${order.regDt}</div>
                                    <strong><c:out value="${order.ordererName}" /></strong>
                                </td>
                                <td class="text-right text-muted"><fmt:formatNumber value="${order.payAmt}" pattern="#,###"/></td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${order.orderStatus eq 'RECEIVED'}">
                                            <span class="badge badge-warning">주문접수</span>
                                        </c:when>
                                        <c:when test="${order.orderStatus eq 'CONFIRMED'}">
                                            <span class="badge badge-primary">주문확인</span>
                                        </c:when>
                                        <c:when test="${order.orderStatus eq 'COMPLETED'}">
                                            <span class="badge badge-success">배송완료</span>
                                        </c:when>
                                        <c:when test="${order.orderStatus eq 'CANCELLED'}">
                                            <span class="badge badge-danger">주문취소</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-secondary">${order.orderStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty recentOrders}">
                            <tr>
                                <td colspan="3" class="text-center text-muted">최근 주문 내역이 없습니다.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Chart.js 로드 -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener("DOMContentLoaded", function() {
    var chartLabels = [];
    var chartData = [];

    <c:forEach var="item" items="${chartData}">
        chartLabels.push('${item.saleDate}');
        chartData.push(${item.dailySales});
    </c:forEach>

    var ctx = document.getElementById('salesChart').getContext('2d');
    var salesChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: chartLabels,
            datasets: [{
                label: '일매출 (원)',
                data: chartData,
                backgroundColor: 'rgba(54, 162, 235, 0.5)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1,
                borderRadius: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return value.toLocaleString() + ' 원';
                        }
                    }
                }
            },
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            var label = context.dataset.label || '';
                            if (label) {
                                label += ': ';
                            }
                            if (context.parsed.y !== null) {
                                label += context.parsed.y.toLocaleString() + ' 원';
                            }
                            return label;
                        }
                    }
                }
            }
        }
    });
});
</script>
