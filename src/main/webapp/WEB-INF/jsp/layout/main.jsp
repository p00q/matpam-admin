<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <!-- Custom Premium Styles -->
    <link rel="stylesheet" href="<c:url value='/resources/css/admin-premium-v4.css'/>">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>
    <!-- Sidebar Navigation -->
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="logo-container">
                <div class="logo-icon">
                    <i class="bi bi-intersect text-white"></i>
                </div>
                <span class="logo-text">MATPAM ADMIN</span>
            </div>
            <div class="collapse-toggle" id="sidebarToggle">
                <i class="bi bi-chevron-left" id="toggleIcon"></i>
            </div>
        </div>

        <nav class="sidebar-nav">
            <div class="nav-group-title">Menu</div>
            
            <!-- 운영관리 -->
            <div class="nav-group">
                <div class="nav-parent ${fn:startsWith(currentMenu, 'op_') ? '' : 'collapsed'}" data-bs-toggle="collapse" data-bs-target="#menu_op" aria-expanded="${fn:startsWith(currentMenu, 'op_') ? 'true' : 'false'}">
                    <div class="parent-icon"><i class="bi bi-shield-lock"></i></div>
                    <span>운영관리</span>
                    <i class="bi bi-chevron-down toggle-arrow"></i>
                </div>
                <div class="collapse ${fn:startsWith(currentMenu, 'op_') ? 'show' : ''}" id="menu_op">
                    <ul class="nav-child-list">
                        <li><a href="<c:url value='/admin/company/companyForm.do?companyId=1'/>" class="nav-child-item ${currentMenu eq 'op_mall' ? 'active' : ''}">몰 기본정보</a></li>
                        <li><a href="<c:url value='/admin/sysChannel/channelList.do'/>" class="nav-child-item ${currentMenu eq 'op_channel' ? 'active' : ''}">채널관리</a></li>
                        <li><a href="<c:url value='/admin/user/userList.do'/>" class="nav-child-item ${currentMenu eq 'op_admin' ? 'active' : ''}">관리자/권한관리</a></li>
                        <li><a href="#" class="nav-child-item">약관정보</a></li>
                    </ul>
                </div>
            </div>

            <!-- 업체관리 -->
            <div class="nav-group">
                <div class="nav-parent ${fn:startsWith(currentMenu, 'comp_') ? '' : 'collapsed'}" data-bs-toggle="collapse" data-bs-target="#menu_comp" aria-expanded="${fn:startsWith(currentMenu, 'comp_') ? 'true' : 'false'}">
                    <div class="parent-icon"><i class="bi bi-building"></i></div>
                    <span>업체관리</span>
                    <i class="bi bi-chevron-down toggle-arrow"></i>
                </div>
                <div class="collapse ${fn:startsWith(currentMenu, 'comp_') ? 'show' : ''}" id="menu_comp">
                    <ul class="nav-child-list">
                        <li><a href="<c:url value='/admin/company/companyList.do?companyType=SELLER'/>" class="nav-child-item ${currentMenu eq 'comp_seller' ? 'active' : ''}">판매업체</a></li>
                        <li><a href="<c:url value='/admin/company/companyList.do?companyType=BUYER'/>" class="nav-child-item ${currentMenu eq 'comp_buyer' ? 'active' : ''}">구매업체</a></li>
                    </ul>
                </div>
            </div>

            <div class="nav-group-title">Operations</div>

            <!-- 상품관리 -->
            <div class="nav-group">
                <div class="nav-parent ${fn:startsWith(currentMenu, 'product') ? '' : 'collapsed'}" data-bs-toggle="collapse" data-bs-target="#menu_prod" aria-expanded="${fn:startsWith(currentMenu, 'product') ? 'true' : 'false'}">
                    <div class="parent-icon"><i class="bi bi-box-seam"></i></div>
                    <span>상품관리</span>
                    <i class="bi bi-chevron-down toggle-arrow"></i>
                </div>
                <div class="collapse ${fn:startsWith(currentMenu, 'product') ? 'show' : ''}" id="menu_prod">
                    <ul class="nav-child-list">
                        <li><a href="<c:url value='/admin/product/productList.do'/>" class="nav-child-item ${currentMenu eq 'product' ? 'active' : ''}">상품목록</a></li>
                        <li><a href="<c:url value='/admin/product/productForm.do'/>" class="nav-child-item">상품등록</a></li>
                    </ul>
                </div>
            </div>

            <!-- 주문관리 -->
            <div class="nav-group">
                <div class="nav-parent ${fn:startsWith(currentMenu, 'order') ? '' : 'collapsed'}" data-bs-toggle="collapse" data-bs-target="#menu_order" aria-expanded="${fn:startsWith(currentMenu, 'order') ? 'true' : 'false'}">
                    <div class="parent-icon"><i class="bi bi-cart3"></i></div>
                    <span>주문관리</span>
                    <i class="bi bi-chevron-down toggle-arrow"></i>
                </div>
                <div class="collapse ${fn:startsWith(currentMenu, 'order') ? 'show' : ''}" id="menu_order">
                    <ul class="nav-child-list">
                        <li><a href="<c:url value='/admin/order/orderList.do'/>" class="nav-child-item ${currentMenu eq 'order' ? 'active' : ''}">주문목록</a></li>
                        <li><a href="#" class="nav-child-item">배송관리</a></li>
                    </ul>
                </div>
            </div>

            <div class="nav-group-title">Finance</div>

            <!-- 정산관리 -->
            <div class="nav-group">
                <div class="nav-parent ${fn:startsWith(currentMenu, 'settle') ? '' : 'collapsed'}" data-bs-toggle="collapse" data-bs-target="#menu_settle" aria-expanded="${fn:startsWith(currentMenu, 'settle') ? 'true' : 'false'}">
                    <div class="parent-icon"><i class="bi bi-wallet2"></i></div>
                    <span>정산관리</span>
                    <i class="bi bi-chevron-down toggle-arrow"></i>
                </div>
                <div class="collapse ${fn:startsWith(currentMenu, 'settle') ? 'show' : ''}" id="menu_settle">
                    <ul class="nav-child-list">
                        <li><a href="<c:url value='/admin/settlement/settlementList.do'/>" class="nav-child-item ${currentMenu eq 'settlement' ? 'active' : ''}">판매정산</a></li>
                        <li><a href="#" class="nav-child-item">입출금내역</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Sidebar Footer -->
        <div class="sidebar-footer">
            <div class="user-widget">
                <div class="user-avatar">
                    <c:out value="${fn:substring(sessionScope.loginVO.userNm, 0, 1)}" default="A" />
                </div>
                <div class="user-info">
                    <span class="user-name">${sessionScope.loginVO.userNm}</span>
                    <span class="user-role">${sessionScope.loginVO.opType}</span>
                </div>
                <a href="<c:url value='/admin/login/actionLogout.do'/>" class="logout-btn" title="로그아웃">
                    <i class="bi bi-power"></i>
                </a>
            </div>
        </div>
    </aside>

    <!-- Top Bar -->
    <div class="top-bar">
        <div class="d-flex align-items-center">
            <h5 class="mb-0 fw-bold" style="color: var(--accent); letter-spacing: -0.5px;">
                <c:out value="${pageTitle}" default="대시보드" />
            </h5>
        </div>
        <div class="d-flex align-items-center gap-3">
            <div class="badge px-3 py-2 border shadow-sm" style="background: rgba(255,255,255,0.05); color: var(--accent); border-color: var(--glass-border) !important;">
                <i class="bi bi-shield-check me-2"></i>운영자 권한: <strong>${sessionScope.loginVO.opType}</strong>
            </div>
        </div>
    </div>

    <!-- Main Content Wrapper -->
    <main class="main-wrapper">
        <div class="container-fluid">
            <jsp:include page="${contentPage}" />
        </div>
    </main>

    <!-- Global Loading Overlay -->
    <div id="global-loader">
        <div class="loader-spinner mb-3"></div>
        <div class="fw-bold text-primary animate-pulse">시스템 처리 중...</div>
    </div>

    <!-- Global Toast Notifications -->
    <div class="toast-container position-fixed bottom-0 end-0 p-4">
        <div id="premiumToast" class="toast premium-toast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header">
                <strong class="me-auto" id="toastTitle">시스템 알림</strong>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body d-flex align-items-center">
                <i id="toastIcon" class="bi"></i>
                <span id="toastMessage"></span>
            </div>
        </div>
    </div>

    <!-- Core Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<c:url value='/resources/js/admin-premium.js'/>"></script>

    <script>
        $(document).ready(function() {
            // Global AJAX Loader
            $(document).ajaxStart(function() {
                $('#global-loader').css('display', 'flex');
            }).ajaxStop(function() {
                $('#global-loader').hide();
            });

            // Toast Utility
            window.fn_toast = function(message, type = 'info') {
                const toastEl = document.getElementById('premiumToast');
                const toast = new bootstrap.Toast(toastEl, { delay: 3000 });
                const $toast = $('#premiumToast');
                const $icon = $('#toastIcon');
                
                $toast.removeClass('toast-success toast-danger toast-info');
                $icon.removeClass('bi-check-circle-fill bi-exclamation-triangle-fill bi-info-circle-fill');
                
                if (type === 'success') { $toast.addClass('toast-success'); $icon.addClass('bi-check-circle-fill text-success'); }
                else if (type === 'danger') { $toast.addClass('toast-danger'); $icon.addClass('bi-exclamation-triangle-fill text-danger'); }
                else { $toast.addClass('toast-info'); $icon.addClass('bi-info-circle-fill text-primary'); }
                
                $('#toastMessage').text(message);
                toast.show();
            };

            // Absolutely Bulletproof Menu Persistence (Expansion + Active Highlight)
            const forceMenuExpand = () => {
                const path = window.location.href;
                let targetId = null;

                // 1. Force Active Class based on URL (Exact match with query params)
                let matchedItem = null;
                const currentUrl = new URL(window.location.href);
                
                document.querySelectorAll('.nav-child-item').forEach(item => {
                    const itemHref = item.getAttribute('href');
                    if (itemHref && itemHref !== '#') {
                        try {
                            const linkUrl = new URL(itemHref, window.location.origin);
                            // Exact match including query params (e.g. ?companyType=SELLER)
                            if (linkUrl.pathname === currentUrl.pathname && linkUrl.search === currentUrl.search) {
                                matchedItem = item;
                            } 
                            // Fallback match (Path matches, but we don't overwrite an exact match)
                            else if (linkUrl.pathname === currentUrl.pathname && !matchedItem) {
                                matchedItem = item;
                            }
                        } catch(e) {}
                    }
                });

                if (matchedItem) {
                    // Remove existing active classes to prevent multiple highlights
                    document.querySelectorAll('.nav-child-item.active').forEach(i => i.classList.remove('active'));
                    matchedItem.classList.add('active');
                }

                // 2. Detect target group from active item
                const activeItem = document.querySelector('.nav-child-item.active');
                if (activeItem) {
                    const collapseEl = activeItem.closest('.collapse');
                    if (collapseEl) targetId = collapseEl.id;
                }

                // 3. Fallback: Detect by URL patterns
                if (!targetId) {
                    if (path.includes('/company/')) targetId = 'menu_comp';
                    else if (path.includes('/member/') || path.includes('/user/') || path.includes('/code/')) targetId = 'menu_op';
                    else if (path.includes('/product/')) targetId = 'menu_prod';
                    else if (path.includes('/order/')) targetId = 'menu_order';
                    else if (path.includes('/settle/')) targetId = 'menu_settle';
                }

                // 4. Force Expand
                if (targetId) {
                    const el = document.getElementById(targetId);
                    if (el) {
                        el.classList.add('show');
                        const trigger = document.querySelector(`[data-bs-target="#${targetId}"]`);
                        if (trigger) {
                            trigger.classList.remove('collapsed');
                            trigger.setAttribute('aria-expanded', 'true');
                        }
                    }
                }
            };

            // Aggressive execution
            forceMenuExpand();
            setTimeout(forceMenuExpand, 100);
            setTimeout(forceMenuExpand, 500);
            setTimeout(forceMenuExpand, 2000);
        });
    </script>
</body>
</html>