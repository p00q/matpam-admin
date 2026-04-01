<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<section class="product-detail-page py-5">
    <div class="container">
        <div class="row g-5">
            <!-- 좌측: 상품 이미지 -->
            <div class="col-lg-6">
                <div class="product-gallery fade-in-up">
                    <c:choose>
                        <c:when test="${not empty product.imgUrl1}">
                            <img src="${product.imgUrl1}" class="img-fluid rounded-4 shadow-sm w-100" alt="${product.salesProdName}">
                        </c:when>
                        <c:otherwise>
                            <div class="bg-light rounded-4 d-flex align-items-center justify-content-center" style="aspect-ratio:1/1;">
                                <i class="bi bi-image text-muted fs-1"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    
                    <c:if test="${not empty product.imgUrl2 or not empty product.imgUrl3}">
                        <div class="row g-2 mt-2">
                            <c:if test="${not empty product.imgUrl2}">
                                <div class="col-3">
                                    <img src="${product.imgUrl2}" class="img-fluid rounded-3 border" style="cursor:pointer;">
                                </div>
                            </c:if>
                            <c:if test="${not empty product.imgUrl3}">
                                <div class="col-3">
                                    <img src="${product.imgUrl3}" class="img-fluid rounded-3 border" style="cursor:pointer;">
                                </div>
                            </c:if>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- 우측: 상품 정보 및 주문 -->
            <div class="col-lg-6">
                <div class="product-info-panel fade-in-up" style="animation-delay: 0.1s">
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb small">
                            <li class="breadcrumb-item"><a href="<c:url value='/front/main.do'/>" class="text-muted">홈</a></li>
                            <li class="breadcrumb-item"><a href="<c:url value='/front/product/list.do'/>" class="text-muted">전체 상품</a></li>
                            <li class="breadcrumb-item active text-danger fw-bold" aria-current="page">${product.salesProdName}</li>
                        </ol>
                    </nav>

                    <h1 class="display-6 fw-extrabold mb-2" style="letter-spacing:-1.5px;">${product.salesProdName}</h1>
                    <p class="lead text-muted mb-4">${product.summary}</p>

                    <div class="price-box p-4 rounded-4 bg-white border shadow-sm mb-4">
                        <div class="d-flex justify-content-between align-items-end mb-2">
                            <span class="text-muted small fw-bold">판매가</span>
                            <div>
                                <c:if test="${product.discountAmt > 0}">
                                    <del class="text-muted small me-2"><fmt:formatNumber value="${product.listPrice}" type="number"/>원</del>
                                </c:if>
                                <span class="fs-2 fw-bold text-danger">
                                    <fmt:formatNumber value="${product.salesPrice}" type="number"/>
                                </span>
                                <span class="fw-bold">원</span>
                            </div>
                        </div>
                        <hr class="my-3 opacity-10">
                        <div class="row g-2 small text-muted">
                            <div class="col-4 fw-bold">과세 구분</div>
                            <div class="col-8">
                                <c:choose>
                                    <c:when test="${product.vatYn eq 'Y'}">과세 상품 (VAT 10% 포함)</c:when>
                                    <c:otherwise>비과세(면세) 상품</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="col-4 fw-bold">원산지/제조사</div>
                            <div class="col-8">${product.sellerName != null ? product.sellerName : '국내산 / 맛팜 협력사'}</div>
                        </div>
                    </div>

                    <!-- 주문 수량 및 버튼 -->
                    <div class="order-action-box">
                        <div class="d-flex align-items-center justify-content-between mb-4">
                            <label class="fw-bold small">주문 수량</label>
                            <div class="qty-control">
                                <button class="qty-btn" onclick="fn_changeQty(-1)"><i class="bi bi-dash"></i></button>
                                <div class="qty-value" id="orderQty">1</div>
                                <button class="qty-btn" onclick="fn_changeQty(1)"><i class="bi bi-plus"></i></button>
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button class="btn btn-lg btn-outline-danger flex-grow-1 py-3 rounded-3 fw-bold" onclick="fn_addCart()">
                                <i class="bi bi-bag-plus me-2"></i>장바구니
                            </button>
                            <button class="btn btn-lg btn-danger flex-grow-1 py-3 rounded-3 fw-bold shadow-sm" onclick="fn_buyNow()">
                                바로 구매하기
                            </button>
                        </div>
                    </div>

                    <div class="mt-5 p-3 rounded-3 bg-light border-start border-danger border-4 small text-muted">
                        <i class="bi bi-info-circle-fill me-2 text-danger"></i>
                        맛팜 머니($MEAT_MONEY)로만 결제가 가능한 상품입니다. <br>
                        충전된 잔액이 부족할 경우 마이페이지에서 충전 후 이용해주세요.
                    </div>
                </div>
            </div>
        </div>

        <!-- 상세 설명 탭 -->
        <div class="row mt-5 pt-5">
            <div class="col-12">
                <ul class="nav nav-tabs border-0 gap-2 mb-4" id="detailTab" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active border-0 px-4 py-2 rounded-pill fw-bold" id="desc-tab" data-bs-toggle="tab" data-bs-target="#desc-pane" type="button" role="tab">상세 정보</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link border-0 px-4 py-2 rounded-pill fw-bold" id="info-tab" data-bs-toggle="tab" data-bs-target="#info-pane" type="button" role="tab">배송/교환/반품</button>
                    </li>
                </ul>
                <div class="tab-content premium-card p-4 p-md-5 bg-white shadow-sm rounded-4" id="detailTabContent">
                    <div class="tab-pane fade show active" id="desc-pane" role="tabpanel" tabindex="0">
                        <div class="product-description-content">
                            ${product.description != null ? product.description : '상품 상세 설명이 등록되지 않았습니다.'}
                        </div>
                    </div>
                    <div class="tab-pane fade" id="info-pane" role="tabpanel" tabindex="0">
                        <h5 class="fw-bold mb-3">배송 및 교환/반품 안내</h5>
                        <div class="table-responsive">
                            <table class="table table-bordered small">
                                <colgroup><col style="width:20%"><col></colgroup>
                                <tbody>
                                    <tr><th class="bg-light">배송 정보</th><td>${product.deliveryInfo != null ? product.deliveryInfo : '기본 배송비 3,000원 (5만원 이상 무료배송)'}</td></tr>
                                    <tr><th class="bg-light">교환/반품</th><td>${product.returnInfo != null ? product.returnInfo : '신선식품의 특성상 단순 변심에 의한 반품은 어려울 수 있습니다.'}</td></tr>
                                    <tr><th class="bg-light">환불 안내</th><td>${product.refundInfo != null ? product.refundInfo : '반품 접수 후 영업일 기준 3~5일 이내 환불 처리됩니다.'}</td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    let currentQty = 1;
    const prodId = '${product.salesProdId}';
    const prodName = '${product.salesProdName}';
    const price = ${product.salesPrice};

    function fn_changeQty(delta) {
        currentQty = Math.max(1, currentQty + delta);
        $('#orderQty').text(currentQty);
    }

    function fn_addCart() {
        $.ajax({
            url: '<c:url value="/front/api/addCart.ajax"/>',
            type: 'POST',
            data: { prodId: prodId, qty: currentQty },
            dataType: 'json',
            success: function(res) {
                if(res.success) {
                    showToast('🛒 ' + prodName + ' 장바구니에 담았습니다.', 'success');
                    updateCartCount();
                } else {
                    alert(res.message || '장바구니 담기에 실패했습니다.');
                }
            }
        });
    }

    function fn_buyNow() {
        // 장바구니에 담고 바로 이동
        $.ajax({
            url: '<c:url value="/front/api/addCart.ajax"/>',
            type: 'POST',
            data: { prodId: prodId, qty: currentQty },
            dataType: 'json',
            success: function(res) {
                if(res.success) {
                    location.href = '<c:url value="/front/cart.do"/>';
                }
            }
        });
    }
</script>

<style>
    .product-description-content img { max-width: 100% !important; height: auto !important; }
    .nav-tabs .nav-link { color: var(--shop-muted); background: #f1f5f9; }
    .nav-tabs .nav-link.active { background: var(--shop-accent) !important; color: #fff !important; }
</style>
