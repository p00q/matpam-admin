<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<section class="shop-main py-5" id="cart-section">
    <div class="container overflow-hidden">
        <div class="row mb-5 align-items-end">
            <div class="col-6">
                <a href="<c:url value='/front/product/list.do'/>" class="text-decoration-none text-muted small fw-bold">
                    <i class="bi bi-chevron-left me-1"></i> 쇼핑 계속하기
                </a>
                <h2 class="display-6 fw-extrabold mt-3" style="letter-spacing:-2px;">나의 <span class="text-danger">장바구니</span></h2>
            </div>
            <div class="col-6 text-end">
                <span class="badge bg-light text-dark border p-2 px-3 rounded-pill fw-bold" id="cart-item-count-badge">0개 상품</span>
            </div>
        </div>

        <div class="row g-5">
            <!-- 장바구니 목록 -->
            <div class="col-lg-8">
                <div class="cart-card-container" id="cart-list"></div>
            </div>

            <!-- 결제 요약 -->
            <div class="col-lg-4">
                <div class="cart-summary-card shadow-lg p-4 rounded-4 sticky-top" style="top: 100px;">
                    <h5 class="fw-bold mb-4 opacity-75">결제 상세 요약</h5>
                    
                    <div class="summary-rows mb-4">
                        <div class="d-flex justify-content-between mb-3 text-white-50 small">
                            <span>과세 대상 금액</span>
                            <span id="summary-taxable" class="text-white fw-bold">0원</span>
                        </div>
                        <div class="d-flex justify-content-between mb-3 text-white-50 small">
                            <span>면세 대상 금액</span>
                            <span id="summary-free" class="text-white fw-bold">0원</span>
                        </div>
                        <div class="d-flex justify-content-between mb-3 text-white-50 small">
                            <span>부가세 (VAT 10%)</span>
                            <span id="summary-vat" class="text-white fw-bold">0원</span>
                        </div>
                        <div class="d-flex justify-content-between mb-3 text-white-50 small">
                            <span>배송비</span>
                            <span class="text-success fw-bold">무료</span>
                        </div>
                    </div>
                    
                    <hr class="border-white opacity-25 mb-4">
                    
                    <div class="d-flex justify-content-between align-items-center mb-5">
                        <span class="fw-bold">최종 결제 금액</span>
                        <div class="text-end">
                            <div class="display-5 fw-extrabold text-danger mb-0" id="summary-total" style="letter-spacing:-1px;">0원</div>
                            <small class="opacity-50">(부가세 포함)</small>
                        </div>
                    </div>

                    <div class="wallet-info p-3 rounded-3 mb-4" style="background: rgba(255,255,255,0.05);">
                        <div class="d-flex justify-content-between mb-2 small text-white-50">
                            <span>내 미트 머니 잔액</span>
                            <span id="summary-balance" class="text-warning fw-bold">...</span>
                        </div>
                        <div class="d-flex justify-content-between small text-white-50">
                            <span>결제 후 잔액</span>
                            <span id="summary-after" class="fw-bold">...</span>
                        </div>
                    </div>

                    <button class="btn btn-danger btn-lg w-100 py-3 rounded-3 fw-black shadow-lg" id="btn-checkout" onclick="fn_checkout()" disabled>
                        결제하기
                    </button>
                    
                    <div class="mt-4 p-3 rounded-3 border border-white border-opacity-10 text-center small text-white-50">
                        <i class="bi bi-shield-lock-fill me-1"></i> 
                        미트 머니로 안전하게 결제가 진행됩니다.
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 주문 완료 성공 모달 (Phase 3 Premium Ver.) -->
<div class="modal fade" id="orderCompleteModal" data-bs-backdrop="static" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 rounded-5 overflow-hidden shadow-2xl">
            <div class="modal-body p-5 text-center">
                <div class="display-1 text-danger mb-4 bounce-in">
                    <i class="bi bi-check-circle-fill"></i>
                </div>
                <h2 class="fw-extrabold mb-3">주문의 성공적으로<br>완료되었습니다!</h2>
                <p class="text-muted mb-4 lead" id="orderCompleteMsg"></p>
                <div class="row g-2">
                    <div class="col-6">
                        <a href="<c:url value='/front/mypage.do'/>" class="btn btn-outline-danger w-100 py-3 rounded-pill fw-bold">내역 보기</a>
                    </div>
                    <div class="col-6">
                        <a href="<c:url value='/front/product/list.do'/>" class="btn btn-danger w-100 py-3 rounded-pill fw-bold shadow">홈으로</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
let cartData = [];
let myBalance = 0;

$(document).ready(function() {
    loadCart();
    loadBalance();
});

function loadBalance() {
    $.ajax({
        url: '<c:url value="/front/api/myMoney.ajax"/>',
        type: 'GET',
        dataType: 'json',
        success: function(res) {
            myBalance = res.balance || 0;
            $('#summary-balance').text(Number(myBalance).toLocaleString() + '원');
            updateSummary();
        }
    });
}

function loadCart() {
    $.ajax({
        url: '<c:url value="/front/api/cartList.ajax"/>',
        type: 'GET',
        dataType: 'json',
        success: function(res) {
            cartData = res.items || [];
            renderCart();
        }
    });
}

function renderCart() {
    const $list = $('#cart-list');
    $list.empty();
    $('#cart-item-count-badge').text(cartData.length + '개 상품');

    if (cartData.length === 0) {
        $list.html(`
            <div class="empty-state p-5 bg-white rounded-4 border">
                <div class="display-3 text-muted mb-4 opacity-25"><i class="bi bi-cart-x"></i></div>
                <h3 class="fw-bold">장바구니에 담긴 상품이 없습니다</h3>
                <p class="text-muted mb-4">지금 바로 맛있는 고기를 둘러보세요!</p>
                <a href="<c:url value='/front/product/list.do'/>" class="btn btn-danger btn-lg px-5 rounded-pill shadow">쇼핑 하러 가기</a>
            </div>
        `);
        updateSummary();
        return;
    }

    cartData.forEach((item, idx) => {
        const vatBadge = item.vatYn === 'Y' 
            ? '<span class="badge bg-warning bg-opacity-10 text-warning border-warning border-opacity-25" style="border:1px solid">과세</span>' 
            : '<span class="badge bg-success bg-opacity-10 text-success border-success border-opacity-25" style="border:1px solid">면세</span>';

        $list.append(`
            <div class="cart-item premium-card mb-3 p-3 bg-white border rounded-4 shadow-sm fade-in-up" 
                 style="animation-delay:${idx * 0.05}s">
                <div class="row align-items-center g-3">
                    <div class="col-auto">
                        <div class="cart-item-thumb bg-light rounded-3 shadow-sm d-flex align-items-center justify-content-center" style="width:100px; height:100px; font-size:2rem">
                            <i class="bi bi-box-seam text-secondary opacity-25"></i>
                        </div>
                    </div>
                    <div class="col">
                        <div class="mb-1">${vatBadge}</div>
                        <h5 class="fw-bold mb-1">${item.prodName}</h5>
                        <div class="text-muted small">${Number(item.unitPrice).toLocaleString()}원 / 개</div>
                    </div>
                    <div class="col-auto">
                        <div class="d-flex align-items-center gap-3">
                            <div class="qty-control">
                                <button class="qty-btn" onclick="changeQty(${idx}, -1)">−</button>
                                <span class="qty-value" id="qty-${idx}">${item.qty}</span>
                                <button class="qty-btn" onclick="changeQty(${idx}, +1)">+</button>
                            </div>
                            <div class="fw-black text-danger fs-5" style="min-width:120px;text-align:right">
                                <span id="item-total-${idx}">${Number(item.unitPrice * item.qty).toLocaleString()}</span>원
                            </div>
                            <button class="btn btn-link text-muted p-2" onclick="removeItem(${idx})">
                                <i class="bi bi-trash fs-5"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        `);
    });
    updateSummary();
}

function changeQty(idx, delta) {
    cartData[idx].qty = Math.max(1, cartData[idx].qty + delta);
    renderCart(); // 부가세 계산 등을 위해 전체 다시 렌더링 또는 업데이트 로직 필요
    syncCartServer();
}

function removeItem(idx) {
    cartData.splice(idx, 1);
    renderCart();
    syncCartServer();
}

function syncCartServer() {
    $.ajax({
        url: '<c:url value="/front/api/syncCart.ajax"/>',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(cartData),
        dataType: 'json'
    });
}

function updateSummary() {
    let taxableGoods = 0;
    let freeGoods = 0;
    
    cartData.forEach(item => {
        const lineAmt = item.unitPrice * item.qty;
        if(item.vatYn === 'Y') taxableGoods += lineAmt;
        else freeGoods += lineAmt;
    });

    const vat = Math.round(taxableGoods * 0.1);
    const totalPay = taxableGoods + freeGoods + vat;
    const afterBalance = myBalance - totalPay;

    $('#summary-taxable').text(Number(taxableGoods).toLocaleString() + '원');
    $('#summary-free').text(Number(freeGoods).toLocaleString() + '원');
    $('#summary-vat').text(Number(vat).toLocaleString() + '원');
    $('#summary-total').text(Number(totalPay).toLocaleString() + '원');

    if (myBalance > 0) {
        $('#summary-after').text(Number(afterBalance).toLocaleString() + '원');
        $('#summary-after').attr('class', afterBalance >= 0 ? 'text-success fw-bold' : 'text-danger fw-bold');
    }

    const canCheckout = cartData.length > 0 && afterBalance >= 0;
    $('#btn-checkout').prop('disabled', !canCheckout);
}

function fn_checkout() {
    if (!confirm('미트 머니로 결제를 완료하시겠습니까?')) return;

    $('#btn-checkout').prop('disabled', true).html('<span class="spinner-border spinner-border-sm me-2"></span>처리 중...');

    $.ajax({
        url: '<c:url value="/front/order/checkout.ajax"/>',
        type: 'POST',
        dataType: 'json',
        success: function(res) {
            if (res.success) {
                $('#orderCompleteMsg').html(`주문번호: <strong>${res.orderId}</strong><br>미트 머니 <strong>${Number(res.deductedAmt).toLocaleString()}원</strong>이 결제되었습니다.`);
                const modal = new bootstrap.Modal(document.getElementById('orderCompleteModal'));
                modal.show();
            } else {
                showToast(res.message || '결제에 실패했습니다.', 'danger');
                loadBalance();
            }
        },
        complete: function() {
            $('#btn-checkout').prop('disabled', false).text('결제하기');
        }
    });
}
</script>

<style>
    .fw-black { font-weight: 900; }
    .fw-extrabold { font-weight: 800; }
    .shadow-2xl { box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25); }
    .premium-card { transition: all 0.3s ease; }
    .premium-card:hover { transform: scale(1.01); box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
</style>
