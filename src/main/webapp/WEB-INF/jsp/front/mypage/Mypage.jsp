<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<section class="shop-main py-5">
    <div class="container overflow-hidden">
        <!-- 프로필 헤더 -->
        <div class="profile-header mb-5 p-4 p-md-5 rounded-5 shadow-lg bg-dark text-white position-relative overflow-hidden">
            <div class="position-absolute top-0 end-0 p-5 opacity-10">
                <i class="bi bi-person-badge" style="font-size: 15rem;"></i>
            </div>
            <div class="row align-items-center position-relative">
                <div class="col-md-8 mb-4 mb-md-0">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div class="rounded-circle bg-danger p-1">
                            <div class="bg-white rounded-circle d-flex align-items-center justify-content-center" style="width:60px; height:60px;">
                                <i class="bi bi-person-fill text-danger fs-3"></i>
                            </div>
                        </div>
                        <div>
                            <h2 class="fw-black mb-0">${loginVO.memberName} 님</h2>
                            <p class="text-white-50 mb-0">프리미엄 미트 멤버십</p>
                        </div>
                    </div>
                    <div class="d-flex gap-4">
                        <div>
                            <small class="text-white-50 d-block mb-1">아이디</small>
                            <span class="fw-bold">${loginVO.loginId}</span>
                        </div>
                        <div>
                            <small class="text-white-50 d-block mb-1">회원등급</small>
                            <span class="badge bg-danger rounded-pill px-3">VIP MEMBER</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 text-md-end">
                    <div class="wallet-card p-4 rounded-4 bg-white bg-opacity-10 border border-white border-opacity-10 shadow-sm">
                        <small class="text-white-50 d-block mb-2">사용 가능한 <span class="text-warning fw-bold">미트 머니</span></small>
                        <div class="display-5 fw-black text-warning mb-0" id="my-balance">0원</div>
                        <button class="btn btn-sm btn-outline-warning rounded-pill px-4 mt-3 fw-bold" onclick="loadBalance()">
                            <i class="bi bi-arrow-clockwise me-1"></i> 새로고침
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 탭 메뉴 -->
        <ul class="nav nav-pills custom-pills mb-4 gap-2" id="mypageTab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="orders-tab" data-bs-toggle="pill" data-bs-target="#orders-pane" type="button" role="tab">
                    <i class="bi bi-receipt me-2"></i>최근 주문 내역
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="money-tab" data-bs-toggle="pill" data-bs-target="#money-pane" type="button" role="tab">
                    <i class="bi bi-coin me-2"></i>머니 거래 내역
                </button>
            </li>
        </ul>

        <!-- 탭 컨텐츠 -->
        <div class="tab-content" id="mypageTabContent">
            <!-- 주문 내역 탭 -->
            <div class="tab-pane fade show active" id="orders-pane" role="tabpanel">
                <div class="card border-0 rounded-4 shadow-sm overflow-hidden">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light">
                                <tr>
                                    <th class="ps-4 py-3">주문번호 / 일시</th>
                                    <th>상품 정보</th>
                                    <th class="text-end">결제 금액</th>
                                    <th class="text-center">상태</th>
                                    <th class="pe-4"></th>
                                </tr>
                            </thead>
                            <tbody id="order-list-body">
                                <!-- AJAX Load -->
                            </tbody>
                        </table>
                    </div>
                    <div id="order-empty" class="p-5 text-center d-none">
                        <div class="fs-1 opacity-25 mb-3"><i class="bi bi-receipt-cutoff"></i></div>
                        <h5 class="text-muted">최근 주문 내역이 없습니다.</h5>
                    </div>
                </div>
            </div>

            <!-- 머니 내역 탭 -->
            <div class="tab-pane fade" id="money-pane" role="tabpanel">
                <div class="card border-0 rounded-4 shadow-sm overflow-hidden">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light">
                                <tr>
                                    <th class="ps-4 py-3">일시</th>
                                    <th>유형</th>
                                    <th>내용</th>
                                    <th class="text-end pe-4">금액</th>
                                </tr>
                            </thead>
                            <tbody id="money-list-body">
                                <!-- AJAX Load -->
                            </tbody>
                        </table>
                    </div>
                    <div id="money-empty" class="p-5 text-center d-none">
                        <div class="fs-1 opacity-25 mb-3"><i class="bi bi-coin"></i></div>
                        <h5 class="text-muted">거래 내역이 없습니다.</h5>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
$(document).ready(function() {
    loadBalance();
    loadOrders();
    loadMoneyHistory();
});

function loadBalance() {
    $.ajax({
        url: '<c:url value="/front/api/myMoney.ajax"/>',
        type: 'GET',
        dataType: 'json',
        success: function(res) {
            $('#my-balance').text(Number(res.balance || 0).toLocaleString() + '원');
        }
    });
}

function loadOrders() {
    const $body = $('#order-list-body');
    $body.html('<tr><td colspan="5" class="py-5 text-center"><div class="spinner-border text-danger"></div></td></tr>');

    $.ajax({
        url: '<c:url value="/front/api/myOrders.ajax"/>',
        type: 'GET',
        dataType: 'json',
        success: function(res) {
            $body.empty();
            if (!res.orders || res.orders.length === 0) {
                $('#order-empty').removeClass('d-none');
                return;
            }
            $('#order-empty').addClass('d-none');

            res.orders.forEach(o => {
                const statusBadge = o.orderStatusCd === 'ORDER' 
                    ? '<span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 rounded-pill px-3">주문완료</span>'
                    : `<span class="badge bg-secondary rounded-pill px-3">${o.orderStatusCd}</span>`;

                $body.append(`
                    <tr>
                        <td class="ps-4 py-4">
                            <div class="fw-bold text-danger mb-1">#${o.orderId}</div>
                            <small class="text-muted">${o.orderDt || '2026-03-27'}</small>
                        </td>
                        <td>
                            <div class="fw-bold">${o.salesProdName || '상품 외'}</div>
                            <small class="text-muted">${o.totalOrderAmt > 0 ? "외 품목" : ""}</small>
                        </td>
                        <td class="text-end fw-black fs-5">
                            ${Number(o.totalPayAmt).toLocaleString()} <small class="fw-normal">원</small>
                        </td>
                        <td class="text-center">
                            ${statusBadge}
                        </td>
                        <td class="pe-4 text-end">
                            <button class="btn btn-sm btn-light rounded-pill border px-3">상세보기</button>
                        </td>
                    </tr>
                `);
            });
        }
    });
}

function loadMoneyHistory() {
    const $body = $('#money-list-body');
    
    $.ajax({
        url: '<c:url value="/front/api/moneyHistory.ajax"/>',
        type: 'GET',
        dataType: 'json',
        success: function(res) {
            $body.empty();
            if (!res.history || res.history.length === 0) {
                $('#money-empty').removeClass('d-none');
                return;
            }
            $('#money-empty').addClass('d-none');

            res.history.forEach(h => {
                const isDeduction = h.transType === 'DEDUCT' || h.transType === 'USE';
                const typeLabel = isDeduction 
                    ? '<span class="text-danger fw-bold"><i class="bi bi-dash-circle me-1"></i>지급/사용</span>'
                    : '<span class="text-primary fw-bold"><i class="bi bi-plus-circle me-1"></i>적립/충전</span>';
                
                $body.append(`
                    <tr>
                        <td class="ps-4 py-3 text-muted small">${h.regDt || h.transDt || ''}</td>
                        <td>${typeLabel}</td>
                        <td class="fw-bold">${h.remark || '미트 머니 거래'}</td>
                        <td class="text-end pe-4 fw-black fs-5 ${isDeduction ? 'text-danger' : 'text-primary'}">
                            ${isDeduction ? '-' : '+'}${Number(h.amount).toLocaleString()}
                        </td>
                    </tr>
                `);
            });
        }
    });
}
</script>

<style>
    .fw-black { font-weight: 900; }
    .custom-pills .nav-link { background: #f8fafc; color: #64748b; font-weight: 700; border-radius: 12px; padding: 12px 24px; transition: all 0.3s; }
    .custom-pills .nav-link.active { background: #e94560 !important; color: #fff !important; box-shadow: 0 10px 20px rgba(233, 69, 96, 0.2); transform: translateY(-2px); }
    .profile-header { background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%) !important; }
    .table thead th { font-weight: 700; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 1px; color: #94a3b8; border-bottom: none; }
    .table tbody td { border-bottom: 1px solid #f1f5f9; }
</style>
