<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<section class="shop-main py-5">
    <div class="container">
        <!-- 헤더 -->
        <div class="row align-items-center mb-5">
            <div class="col-md-6 mb-3 mb-md-0">
                <h2 class="section-title h1">맛팜 <span class="text-danger">프리미엄</span> 셀렉션</h2>
                <p class="section-subtitle mb-0">엄선된 고품질 신선육을 미트 머니로 만나보세요.</p>
            </div>
            <div class="col-md-6 d-flex justify-content-md-end gap-3">
                <div class="input-group input-group-lg shadow-sm rounded-pill overflow-hidden" style="max-width:350px;">
                    <select id="filterVat" class="form-select border-0 px-3 bg-light" style="max-width:120px; font-size:0.9rem;">
                        <option value="">전체 상품</option>
                        <option value="N">면세 세트</option>
                        <option value="Y">과세 상품</option>
                    </select>
                    <input type="text" id="searchKeyword" class="form-control border-0 px-3 bg-light" placeholder="상품 검색..." style="font-size:0.9rem;">
                    <button class="btn btn-danger px-4" onclick="fn_search(1)">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- 상품 그리드 -->
        <div class="product-grid" id="product-grid"></div>

        <!-- 페이지네이션 -->
        <div id="pagination" class="d-flex justify-content-center gap-2 mt-5"></div>
    </div>
</section>

<script>
let currentPage = 1;
const pageUnit = 12;

$(document).ready(function() {
    fn_search(1);

    $('#filterVat').on('change', () => fn_search(1));
    $('#searchKeyword').on('keypress', function(e) {
        if (e.key === 'Enter') fn_search(1);
    });
});

function fn_search(page) {
    currentPage = page;
    const $grid = $('#product-grid');
    $grid.html('<div class="text-center py-5 w-100 text-muted" style="grid-column: 1/-1"><div class="spinner-border text-danger mb-3" style="width: 3rem; height: 3rem;"></div><br><h5 class="fw-bold">상품을 엄선하는 중...</h5></div>');

    $.ajax({
        url: '<c:url value="/front/api/productList.ajax"/>',
        type: 'GET',
        data: {
            pageIndex: page,
            pageUnit: pageUnit,
            vatYn: $('#filterVat').val(),
            keyword: $('#searchKeyword').val()
        },
        dataType: 'json',
        success: function(res) {
            $grid.empty();
            if (!res.data || res.data.length === 0) {
                $grid.html('<div class="empty-state w-100" style="grid-column:1/-1"><div class="icon text-danger opacity-25"><i class="bi bi-box-seam" style="font-size: 5rem"></i></div><h3 class="fw-bold mt-4">준비된 상품이 없습니다</h3><p class="text-muted">다른 검색어나 필터를 사용해 보세요.</p></div>');
                return;
            }
            res.data.forEach((p, idx) => {
                const taxBadge = p.vatYn === 'N'
                    ? '<span class="product-badge badge-tax">면세</span>'
                    : '<span class="product-badge badge-vat">과세</span>';
                
                const img = p.imgUrl1
                    ? `<div class="product-card-img-wrap"><img src="${p.imgUrl1}" class="product-card-img" alt="${p.salesProdName}"></div>`
                    : '<div class="product-card-img-wrap d-flex align-items-center justify-content-center bg-light"><i class="bi bi-box-seam text-secondary opacity-25" style="font-size:3rem"></i></div>';

                const discountTag = p.discountAmt > 0 
                    ? `<span class="discount-tag">-${Math.round((p.discountAmt / (p.salesPrice + p.discountAmt)) * 100)}%</span>`
                    : '';

                $grid.append(`
                    <div class="product-card fade-in-up" style="animation-delay:${idx * 0.04}s"
                         onclick="location.href='<c:url value='/front/product/detail.do'/>?prodId=${p.salesProdId}'">
                        ${img}
                        ${discountTag}
                        <div class="product-card-body">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                ${taxBadge}
                                <span class="small text-muted fw-semi">${p.categoryNm || '신선식품'}</span>
                            </div>
                            <div class="product-name font-pretendard h6 fw-bold mb-2">${p.salesProdName}</div>
                            <div class="product-price-row mb-3">
                                ${p.discountAmt > 0 ? `<del class="text-muted small me-2">${Number(p.salesPrice + p.discountAmt).toLocaleString()}</del>` : ''}
                                <span class="product-price h5 fw-black text-danger mb-0">${Number(p.salesPrice).toLocaleString()}</span>
                                <span class="fw-bold small ms-1">원</span>
                                <span class="text-muted small fw-normal ms-2"> / ${p.unitNm || '개'}</span>
                            </div>
                            <button class="btn-add-cart-premium w-100 rounded-3 border-0 py-2" onclick="event.stopPropagation(); addToCart(${p.salesProdId}, '${p.salesProdName}', ${p.salesPrice})">
                                <i class="bi bi-bag-plus"></i> 담기
                            </button>
                        </div>
                    </div>
                `);
            });

            renderPagination(res.totalCount, page);
        }
    });
}

function renderPagination(total, current) {
    const totalPages = Math.ceil(total / pageUnit);
    const $pg = $('#pagination').empty();
    if (totalPages <= 1) return;

    const start = Math.max(1, current - 2);
    const end = Math.min(totalPages, current + 2);

    if (start > 1) {
        $pg.append(`<button class="btn btn-sm btn-light rounded-pill px-3" onclick="fn_search(1)">1</button>`);
        if (start > 2) $pg.append(`<span class="text-muted">...</span>`);
    }
    
    for (let i = start; i <= end; i++) {
        const active = i === current ? 'btn-danger shadow' : 'btn-light';
        $pg.append(`<button class="btn btn-sm ${active} rounded-pill px-3 fw-bold" onclick="fn_search(${i})">${i}</button>`);
    }
    
    if (end < totalPages) {
        if (end < totalPages - 1) $pg.append(`<span class="text-muted">...</span>`);
        $pg.append(`<button class="btn btn-sm btn-light rounded-pill px-3" onclick="fn_search(${totalPages})">${totalPages}</button>`);
    }
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
                showToast(res.message || '실패', 'danger');
            }
        }
    });
}
</script>

<style>
    .product-card-img-wrap { width: 100%; aspect-ratio: 1.1/1; overflow: hidden; }
    .product-card-img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.6s cubic-bezier(0.33, 1, 0.68, 1); }
    .product-card:hover .product-card-img { transform: scale(1.1); }
    .discount-tag { position: absolute; top: 12px; left: 12px; background: #e94560; color: #fff; font-size: 0.75rem; font-weight: 800; padding: 4px 10px; border-radius: 4px; z-index: 2; }
    .btn-add-cart-premium { background: var(--shop-primary); color: #fff; font-weight: 700; font-size: 0.85rem; transition: var(--transition); }
    .btn-add-cart-premium:hover { background: var(--shop-accent); box-shadow: 0 4px 12px rgba(233,69,96,0.3); }
    .fw-semi { font-weight: 500; }
    .fw-black { font-weight: 900; }
</style>
