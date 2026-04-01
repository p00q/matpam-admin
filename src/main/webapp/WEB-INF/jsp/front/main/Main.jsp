<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Hero Banner -->
<section class="hero-banner">
    <div class="container position-relative">
        <h1>신선한 맛팜 제품을<br><span>미트 머니</span>로 만나보세요</h1>
        <p>엄선된 국내산 축산물과 가공품을 미트 머니로 간편하게 구매하세요.</p>
        <a href="<c:url value='/front/product/list.do?menu=product'/>" class="btn-shop-primary">
            <i class="bi bi-grid-3x3-gap-fill"></i> 전체 상품 보기
        </a>
    </div>
</section>

<!-- 추천 상품 섹션 -->
<section class="shop-main">
    <div class="container">
        <div class="d-flex justify-content-between align-items-end mb-3">
            <div>
                <h2 class="section-title">🔥 추천 상품</h2>
                <p class="section-subtitle">미트 머니로 지금 바로 구매할 수 있는 상품들</p>
            </div>
            <a href="<c:url value='/front/product/list.do?menu=product'/>" class="btn btn-outline-secondary rounded-pill btn-sm">전체보기 <i class="bi bi-arrow-right"></i></a>
        </div>

        <!-- 상품 그리드 (AJAX로 채움) -->
        <div class="product-grid" id="recommend-grid">
            <!-- Skeleton loader -->
            <c:forEach var="i" begin="1" end="8">
                <div class="product-card" style="animation: fadeInUp 0.4s ease ${i * 0.05}s both;">
                    <div class="product-card-img"><i class="bi bi-image" style="opacity:0.2"></i></div>
                    <div class="product-card-body">
                        <div class="product-badge badge-tax"><i class="bi bi-leaf-fill"></i> 로딩중...</div>
                        <div class="product-name">상품 정보를 불러오는 중</div>
                        <div class="product-price">- <small>원</small></div>
                        <button class="btn-add-cart" disabled><i class="bi bi-bag-plus"></i> 장바구니 담기</button>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<script>
$(document).ready(function() {
    loadRecommendProducts();
});

function loadRecommendProducts() {
    $.ajax({
        url: '<c:url value="/front/api/productList.ajax"/>',
        type: 'GET',
        data: { pageIndex: 1, pageUnit: 8 },
        dataType: 'json',
        success: function(res) {
            const $grid = $('#recommend-grid');
            $grid.empty();

            if (!res.data || res.data.length === 0) {
                $grid.html('<div class="empty-state"><div class="icon"><i class="bi bi-box-seam"></i></div><h3>등록된 상품이 없습니다</h3></div>');
                return;
            }

            res.data.forEach((p, idx) => {
                const taxBadge = p.vatYn === 'N'
                    ? '<span class="product-badge badge-tax"><i class="bi bi-leaf-fill"></i> 면세</span>'
                    : '<span class="product-badge badge-vat"><i class="bi bi-receipt"></i> 과세</span>';

                const img = p.thumbnailUrl
                    ? `<img src="${p.thumbnailUrl}" class="product-card-img" style="object-fit:cover;" onerror="this.outerHTML='<div class=\\'product-card-img\\'><i class=\\'bi bi-box-seam\\'></i></div>'">`
                    : '<div class="product-card-img"><i class="bi bi-box-seam"></i></div>';

                const html = `
                    <div class="product-card fade-in-up" style="animation-delay:${idx * 0.06}s" onclick="location.href='<c:url value='/front/product/detail.do'/>?prodId=${p.salesProdId}'">
                        ${img}
                        <div class="product-card-body">
                            ${taxBadge}
                            <div class="product-name">${p.salesProdName}</div>
                            <div class="product-price">${Number(p.salesPrice).toLocaleString()} <small>원 / ${p.unitNm || '개'}</small></div>
                            <button class="btn-add-cart" onclick="event.stopPropagation(); addToCart(${p.salesProdId}, '${p.salesProdName}', ${p.salesPrice})">
                                <i class="bi bi-bag-plus"></i> 장바구니 담기
                            </button>
                        </div>
                    </div>
                `;
                $grid.append(html);
            });
        },
        error: function() {
            $('#recommend-grid').html('<div class="empty-state"><div class="icon"><i class="bi bi-exclamation-triangle"></i></div><h3>상품을 불러올 수 없습니다</h3></div>');
        }
    });
}

function addToCart(prodId, prodName, price) {
    $.ajax({
        url: '<c:url value="/front/api/addCart.ajax"/>',
        type: 'POST',
        data: { prodId: prodId, qty: 1 },
        dataType: 'json',
        success: function(res) {
            if (res.success) {
                showToast('🛒 ' + prodName + ' 담았습니다!', 'success');
                updateCartCount();
            } else {
                showToast(res.message || '장바구니 추가에 실패했습니다.', 'danger');
            }
        }
    });
}
</script>
