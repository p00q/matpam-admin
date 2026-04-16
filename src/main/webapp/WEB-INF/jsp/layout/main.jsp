<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맛팜 관리자 | Premium Admin</title>
    
    <!-- Fonts & Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <!-- Custom Premium Styles -->
    <link rel="stylesheet" href="<c:url value='/resources/css/admin-premium.css'/>">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>
    <!-- Sidebar Navigation -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <a href="<c:url value='/admin/dashboard/main.do'/>" style="text-decoration: none; color: inherit;">
                <span class="logo-text">MATPAM ADMIN</span>
            </a>
        </div>
        <nav class="sidebar-nav">
            <a href="<c:url value='/admin/member/memberList.do'/>"
                class="nav-item ${currentMenu eq 'member' ? 'active' : ''}">
                <i class="bi bi-people-fill"></i>회원 관리
            </a>
            <a href="<c:url value='/admin/order/orderList.do'/>"
                class="nav-item ${currentMenu eq 'order' ? 'active' : ''}">
                <i class="bi bi-cart-fill"></i>주문 관리
            </a>
            <a href="<c:url value='/admin/product/salesProductList.do'/>"
                class="nav-item ${currentMenu eq 'product' ? 'active' : ''}">
                <i class="bi bi-box-seam-fill"></i>판매상품 관리
            </a>
            <a href="<c:url value='/admin/product/componentProductList.do'/>"
                class="nav-item ${currentMenu eq 'component' ? 'active' : ''}">
                <i class="bi bi-gear-fill"></i>구성상품 관리
            </a>
            <a href="<c:url value='/admin/settlement/settlementList.do'/>"
                class="nav-item ${currentMenu eq 'settlement' ? 'active' : ''}">
                <i class="bi bi-currency-exchange"></i>정산관리
            </a>
            <a href="<c:url value='/admin/basic/codeManage.do'/>"
                class="nav-item ${currentMenu eq 'basic' ? 'active' : ''}">
                <i class="bi bi-file-earmark-text-fill"></i>시스템 설정
            </a>
        </nav>
    </aside>

    <!-- Top Bar -->
    <div class="top-bar">
        <div class="d-flex align-items-center">
            <h5 class="mb-0 fw-bold" style="color: var(--primary);">
                <c:out value="${pageTitle}" default="대시보드" />
            </h5>
        </div>
        <div class="d-flex align-items-center gap-3">
            <div class="badge bg-light text-dark px-3 py-2 border shadow-sm">
                <i class="bi bi-person-circle me-2"></i>운영자 권한: <strong>${sessionScope.loginVO.opType}</strong>
            </div>
        </div>
    </div>

    <!-- Main Content Wrapper -->
    <main class="main-wrapper">
        <div class="container-fluid p-4">
            <jsp:include page="${contentPage}" />
        </div>
    </main>

    <!-- Global Loading Overlay -->
    <div id="global-loader">
        <div class="loader-spinner mb-3"></div>
        <div class="fw-bold text-primary animate-pulse">처리 중입니다...</div>
    </div>

    <!-- Global Toast Notifications -->
    <div class="toast-container position-fixed bottom-0 end-0 p-4">
        <div id="premiumToast" class="toast premium-toast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header">
                <strong class="me-auto" id="toastTitle">알림</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body d-flex align-items-center">
                <i id="toastIcon" class="bi"></i>
                <span id="toastMessage"></span>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle & Core Logic -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        $(document).ready(function() {
            // --- 1. Global AJAX Loader ---
            $(document).ajaxStart(function() {
                $('#global-loader').css('display', 'flex');
            }).ajaxStop(function() {
                $('#global-loader').hide();
            });

            // --- 2. Toast Utility ---
            window.fn_toast = function(message, type = 'info') {
                const toastEl = document.getElementById('premiumToast');
                const toast = new bootstrap.Toast(toastEl, { delay: 3000 });
                
                const $toast = $('#premiumToast');
                const $icon = $('#toastIcon');
                
                // Reset classes
                $toast.removeClass('toast-success toast-danger toast-info');
                $icon.removeClass('bi-check-circle-fill bi-exclamation-triangle-fill bi-info-circle-fill');
                
                if (type === 'success') {
                    $toast.addClass('toast-success');
                    $icon.addClass('bi-check-circle-fill text-success');
                    $('#toastTitle').text('성공');
                } else if (type === 'danger') {
                    $toast.addClass('toast-danger');
                    $icon.addClass('bi-check-circle-fill text-danger');
                    $('#toastTitle').text('오류');
                } else {
                    $toast.addClass('toast-info');
                    $icon.addClass('bi-info-circle-fill text-primary');
                    $('#toastTitle').text('알림');
                }
                
                $('#toastMessage').text(message);
                toast.show();
            };
        });
    </script>
</body>

</html>