<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : '맛팜 쇼핑몰'}</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;800&display=swap" rel="stylesheet">
    <!-- Bootstrap & Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <!-- Shop CSS -->
    <link rel="stylesheet" href="<c:url value='/resources/css/front-shop.css'/>">

    <style>
        /* Pretendard font via CDN */
        @import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css');
    </style>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body class="front-body">

    <!-- ===== HEADER ===== -->
    <header class="shop-header">
        <a class="shop-logo" href="<c:url value='/front/main.do'/>">
            <span>MAT</span>PAM
        </a>
        <nav class="shop-nav">
            <a href="<c:url value='/front/main.do'/>" class="${param.menu eq 'main' ? 'active' : ''}">홈</a>
            <a href="<c:url value='/front/product/list.do'/>" class="${param.menu eq 'product' ? 'active' : ''}">전체 상품</a>
            <a href="<c:url value='/front/mypage.do'/>" class="${param.menu eq 'mypage' ? 'active' : ''}">마이페이지</a>
        </nav>

        <div class="shop-header-actions">
            <!-- 미트 머니 잔액 -->
            <div class="money-badge" onclick="location.href='<c:url value='/front/mypage.do'/>'" title="나의 미트 머니">
                <i class="bi bi-coin"></i>
                <span>머니</span>
                <span class="amount" id="header-money-amount">...</span>
                <span>원</span>
            </div>

            <!-- 장바구니 -->
            <a href="<c:url value='/front/cart.do'/>" class="cart-btn">
                <i class="bi bi-bag"></i>
                <span>장바구니</span>
                <span class="cart-count" id="header-cart-count">0</span>
            </a>

            <!-- 사용자 -->
            <div class="d-flex align-items-center gap-2">
                <span class="badge-optype">
                    <i class="bi bi-person-fill me-1"></i>${memberName}
                </span>
                <a href="<c:url value='/front/logout.do'/>" class="btn btn-sm btn-outline-secondary rounded-pill">로그아웃</a>
            </div>
        </div>
    </header>

    <!-- ===== CONTENT ===== -->
    <jsp:include page="${contentPage}" />

    <!-- ===== FOOTER ===== -->
    <footer class="shop-footer">
        <div class="container">
            <p class="mb-1"><strong style="color:rgba(255,255,255,0.8)">맛팜 (MATPAM)</strong></p>
            <p>전남 담양 | 미트 머니 전용 결제 플랫폼 | 고객센터: 061-000-0000</p>
            <p class="mt-2">© 2025 Matpam. All rights reserved.</p>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // ── 헤더 공통 초기화 ─────────────────────────────────
        $(document).ready(function() {
            // 미트 머니 잔액 조회
            $.ajax({
                url: '<c:url value="/front/api/myMoney.ajax"/>',
                type: 'GET',
                dataType: 'json',
                success: function(res) {
                    if (res.success) {
                        $('#header-money-amount').text(Number(res.balance).toLocaleString());
                    }
                },
                error: function() {
                    $('#header-money-amount').text('-');
                }
            });

            // 장바구니 수량 표시
            updateCartCount();
        });

        function updateCartCount() {
            $.ajax({
                url: '<c:url value="/front/api/cartCount.ajax"/>',
                type: 'GET',
                dataType: 'json',
                success: function(res) {
                    const cnt = res.count || 0;
                    $('#header-cart-count').text(cnt).toggle(cnt > 0);
                }
            });
        }

        // 전역 알림 함수
        window.showToast = function(msg, type='info') {
            const colors = { success: '#27ae60', danger: '#e94560', info: '#3498db', warning: '#f39c12' };
            const toast = $('<div>')
                .css({
                    position:'fixed', bottom:'24px', right:'24px', zIndex:9999,
                    background: colors[type] || colors.info,
                    color:'#fff', borderRadius:'12px', padding:'14px 20px',
                    boxShadow:'0 8px 32px rgba(0,0,0,0.2)', fontWeight:600,
                    opacity:0, transform:'translateY(16px)', transition:'all 0.3s ease'
                })
                .html('<i class="bi bi-check-circle me-2"></i>' + msg);
            $('body').append(toast);
            setTimeout(() => toast.css({opacity:1, transform:'translateY(0)'}), 10);
            setTimeout(() => toast.css({opacity:0}).delay(300).queue(function(){ $(this).remove(); }), 3000);
        };
    </script>
</body>
</html>
