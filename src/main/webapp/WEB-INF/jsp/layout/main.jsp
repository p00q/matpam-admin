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
    <style>
        /* 모달 활성화 시 상단 바 및 사이드바 겹침 방지 (투명화 대신 z-index 조정) */
        body.modal-open .top-bar,
        body.modal-open .sidebar {
            z-index: 900 !important;
            pointer-events: none;
            filter: blur(2px) grayscale(0.5);
            transition: all 0.3s ease;
        }
        /* 사이드바 스크롤 절대 금지 (초강력 전역 패치) */
        ::-webkit-scrollbar { display: none !important; }
        * { scrollbar-width: none !important; -ms-overflow-style: none !important; }
        
        .sidebar { 
            overflow: hidden !important; 
            height: calc(100vh - 3rem) !important;
        }
        .sidebar-nav { 
            height: 100% !important; 
            overflow: hidden !important;
        }
        .modal-backdrop.show {
            z-index: 1500 !important;
        }
        /* 공통 모달 헤더 스타일 */
        .modal-premium-header {
            background: #0f172a; 
            border-bottom: 1px solid rgba(255,255,255,0.1) !important;
            padding: 1.25rem 1.75rem !important;
        }

        /* ── 전역 Premium Toast 스타일 ── */
        .premium-toast {
            position: fixed; top: 20px; left: 50%; transform: translateX(-50%);
            z-index: 10550; min-width: 300px; padding: 12px 20px;
            border-radius: 12px; background: #fff; box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            display: flex; align-items: center; gap: 12px;
            opacity: 0; visibility: hidden; transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }
        .premium-toast.show { opacity: 1; visibility: visible; top: 40px; }
        .premium-toast.success { border-left: 5px solid #22c55e; }
        .premium-toast.error, .premium-toast.danger { border-left: 5px solid #ef4444; }
        .premium-toast.warning { border-left: 5px solid #f59e0b; }
        .premium-toast.info { border-left: 5px solid #3b82f6; }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>
    <!-- 전역 Premium Toast Container -->
    <div id="premiumToast" class="premium-toast">
        <div id="toastIcon" style="font-size: 1.2rem;"></div>
        <div id="toastMsg" class="fw-semibold text-dark small"></div>
    </div>

    <!-- Sidebar Navigation -->
    <aside class="sidebar" id="sidebar" style="overflow:hidden !important;">
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

            <%-- 현재 로그인 역할 (JSP EL용) --%>
            <c:set var="loginRole"  value="${sessionScope.loginVO.roleCd}"/>
            <c:set var="uriLower"   value="${fn:toLowerCase(pageContext.request.requestURI)}"/>

            <%-- 운영관리: SUPER_ADMIN, OPERATOR만 표시 / CHANNEL_ADMIN 숨김 --%>
            <c:if test="${loginRole ne 'CHANNEL_ADMIN'}">
            <div class="nav-group">
                <c:set var="isOpPage" value="${fn:startsWith(currentMenu, 'op_') or fn:contains(uriLower, 'operator') or fn:contains(uriLower, 'syschannel')}"/>
                <div class="nav-parent ${isOpPage ? '' : 'collapsed'}" data-bs-toggle="collapse" data-bs-target="#menu_op" aria-expanded="${isOpPage ? 'true' : 'false'}">
                    <div class="parent-icon"><i class="bi bi-shield-lock"></i></div>
                    <span>운영관리</span>
                    <i class="bi bi-chevron-down toggle-arrow"></i>
                </div>
                <div class="collapse ${isOpPage ? 'show' : ''}" id="menu_op" data-bs-parent=".sidebar-nav">
                    <ul class="nav-child-list">
                        <%-- 몰 기본정보: 전체 허용 (OPERATOR·SUPER_ADMIN) --%>
                        <li><a href="<c:url value='/admin/company/companyForm.do?companyId=1'/>" class="nav-child-item ${currentMenu eq 'op_mall' ? 'active' : ''}">몰 기본정보</a></li>
                        <%-- 채널관리: OPERATOR 이상만 허용 --%>
                        <li><a href="<c:url value='/admin/sysChannel/channelList.do'/>" class="nav-child-item ${currentMenu eq 'op_channel' ? 'active' : ''}">채널관리</a></li>
                        <%-- 운영자관리: SUPER_ADMIN만 허용 --%>
                        <c:if test="${loginRole eq 'SUPER_ADMIN' or loginRole eq 'OPERATOR'}">
                        <li><a href="<c:url value='/admin/user/operatorList.do'/>" class="nav-child-item ${currentMenu eq 'op_operator' ? 'active' : ''}">운영자관리</a></li>
                        </c:if>
                        <li><a href="#" class="nav-child-item">약관정보</a></li>
                    </ul>
                </div>
            </div>
            </c:if>

            <!-- 업체관리 -->
            <div class="nav-group">
                <c:set var="isCompPage" value="${fn:startsWith(currentMenu, 'comp_') or fn:contains(uriLower, 'companylist')}"/>
                <div class="nav-parent ${isCompPage ? '' : 'collapsed'}" data-bs-toggle="collapse" data-bs-target="#menu_comp" aria-expanded="${isCompPage ? 'true' : 'false'}">
                    <div class="parent-icon"><i class="bi bi-building"></i></div>
                    <span>업체관리</span>
                    <i class="bi bi-chevron-down toggle-arrow"></i>
                </div>
                <div class="collapse ${isCompPage ? 'show' : ''}" id="menu_comp" data-bs-parent=".sidebar-nav">
                    <ul class="nav-child-list">
                        <li><a href="<c:url value='/admin/company/companyList.do?companyType=SELLER'/>" class="nav-child-item ${currentMenu eq 'comp_seller' ? 'active' : ''}">판매업체</a></li>
                        <li><a href="<c:url value='/admin/company/companyList.do?companyType=BUYER'/>" class="nav-child-item ${currentMenu eq 'comp_buyer' ? 'active' : ''}">구매업체</a></li>
                    </ul>
                </div>
            </div>

            <!-- 회원관리 -->
            <div class="nav-group">
                <c:set var="isUserPage" value="${fn:startsWith(currentMenu, 'user_') or (fn:contains(uriLower, '/user/') and not fn:contains(uriLower, 'operator'))}"/>
                <div class="nav-parent ${isUserPage ? '' : 'collapsed'}" data-bs-toggle="collapse" data-bs-target="#menu_user" aria-expanded="${isUserPage ? 'true' : 'false'}">
                    <div class="parent-icon"><i class="bi bi-people"></i></div>
                    <span>회원관리</span>
                    <i class="bi bi-chevron-down toggle-arrow"></i>
                </div>
                <div class="collapse ${isUserPage ? 'show' : ''}" id="menu_user" data-bs-parent=".sidebar-nav">

                    <ul class="nav-child-list">
                        <li><a href="<c:url value='/admin/user/userList.do?userRole=SELLER_ADMIN'/>" class="nav-child-item ${currentMenu eq 'user_seller' ? 'active' : ''}">판매회원</a></li>
                        <li><a href="<c:url value='/admin/user/userList.do?userRole=BUYER_ADMIN'/>" class="nav-child-item ${currentMenu eq 'user_buyer' ? 'active' : ''}">구매회원</a></li>
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
                <div class="collapse ${fn:startsWith(currentMenu, 'product') ? 'show' : ''}" id="menu_prod" data-bs-parent=".sidebar-nav">
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
                <div class="collapse ${fn:startsWith(currentMenu, 'order') ? 'show' : ''}" id="menu_order" data-bs-parent=".sidebar-nav">
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
                <div class="collapse ${fn:startsWith(currentMenu, 'settle') ? 'show' : ''}" id="menu_settle" data-bs-parent=".sidebar-nav">
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
                    <%-- 역할명 한국어 표시 --%>
                    <c:choose>
                        <c:when test="${sessionScope.loginVO.roleCd eq 'SUPER_ADMIN'}">
                            <span class="user-role" style="color:#f59e0b;">슈퍼관리자</span>
                        </c:when>
                        <c:when test="${sessionScope.loginVO.roleCd eq 'OPERATOR'}">
                            <span class="user-role" style="color:#60a5fa;">몰 운영자</span>
                        </c:when>
                        <c:when test="${sessionScope.loginVO.roleCd eq 'CHANNEL_ADMIN'}">
                            <span class="user-role" style="color:#34d399;">채널관리자</span>
                        </c:when>
                        <c:otherwise>
                            <span class="user-role">${sessionScope.loginVO.opType}</span>
                        </c:otherwise>
                    </c:choose>
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
            <%-- 개발용 역할 전환 버튼 --%>
            <div class="dropdown">
                <button class="btn btn-sm btn-outline-warning dropdown-toggle py-1 px-3 shadow-sm" type="button" id="roleDropdown" data-bs-toggle="dropdown" aria-expanded="false" style="border-radius:20px; font-weight:600; font-size:0.75rem; border-color: rgba(245, 158, 11, 0.3);">
                    <i class="bi bi-person-badge me-1"></i> 권한 변경 (테스트)
                </button>
                <ul class="dropdown-menu dropdown-menu-end shadow border-0" aria-labelledby="roleDropdown">
                    <li><h6 class="dropdown-header">관리자 계정</h6></li>
                    <li><a class="dropdown-item small" href="<c:url value='/admin/login.do?role=SUPER'/>"><i class="bi bi-shield-lock me-2 text-warning"></i>수퍼관리자 (admin)</a></li>
                    <li><a class="dropdown-item small" href="<c:url value='/admin/login.do?role=OP'/>"><i class="bi bi-gear me-2 text-primary"></i>몰운영자 (operator01)</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><h6 class="dropdown-header">채널관리자 계정</h6></li>
                    <li><a class="dropdown-item small" href="<c:url value='/admin/login.do?role=CH3'/>"><i class="bi bi-truck me-2 text-success"></i>전국택배 (new_op_arch_01)</a></li>
                    <li><a class="dropdown-item small" href="<c:url value='/admin/login.do?role=CH4'/>"><i class="bi bi-box-seam me-2 text-info"></i>화물직송 (optest99)</a></li>
                    <li><a class="dropdown-item small" href="<c:url value='/admin/login.do?role=CH5'/>"><i class="bi bi-shop me-2 text-secondary"></i>공장수령 (sync_test_002)</a></li>
                </ul>
            </div>
            <div class="badge px-3 py-2 border shadow-sm" style="background: rgba(255,255,255,0.05); color: var(--accent); border-color: var(--glass-border) !important;">
                <i class="bi bi-shield-check me-2"></i>
                <c:choose>
                    <c:when test="${sessionScope.loginVO.roleCd eq 'SUPER_ADMIN'}">슈퍼관리자</c:when>
                    <c:when test="${sessionScope.loginVO.roleCd eq 'OPERATOR'}">몰 운영자</c:when>
                    <c:when test="${sessionScope.loginVO.roleCd eq 'CHANNEL_ADMIN'}">채널관리자</c:when>
                    <c:otherwise>${sessionScope.loginVO.opType}</c:otherwise>
                </c:choose>
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



    <!-- ── [공통] 통합 관리 팝업 ── -->
    <div class="modal fade" id="adminCommonModal" tabindex="-1" aria-hidden="true" style="z-index: 2000 !important;">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 24px; overflow: hidden; background: #fff;">
                <div class="modal-header modal-premium-header border-0">
                    <h5 class="modal-title fw-bold text-white" id="adminCommonModalTitle" style="letter-spacing: -0.5px;">
                        <i class="bi bi-window-stack me-2 text-warning"></i>상세 정보
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-0" id="adminCommonModalBody" style="min-height: 500px; background: #f8fafc;">
                    <!-- AJAX 로딩 영역 -->
                    <div class="d-flex justify-content-center align-items-center" style="height:500px;">
                        <div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<c:url value='/resources/js/admin-premium.js'/>"></script>

    <script>
        /**
         * 통합 모달 오픈 함수
         * @param url 로드할 JSP URL
         * @param title 모달 상단 타이틀 (옵션)
         */
        var adminModalRequest = null;

        function fn_openAdminModal(url, title) {
            if (title) $('#adminCommonModalTitle').html('<i class="bi bi-window-stack me-2 text-warning"></i>' + title);

            if (adminModalRequest && adminModalRequest.readyState !== 4) {
                adminModalRequest.abort();
            }
             
            // 로딩 표시
            $('#adminCommonModalBody').html('<div class="d-flex justify-content-center align-items-center" style="height:500px;"><div class="spinner-border text-primary" role="status"></div></div>');
            
            const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('adminCommonModal'));
            modal.show();

            adminModalRequest = $.ajax({
                url: url,
                type: 'GET',
                cache: false,
                timeout: 15000,
                success: function(html) {
                    $('#adminCommonModalBody').html(html);

                    /*
                    // jQuery .html()은 <script> 블록을 자동 실행하지 않으므로 수동 재실행
                    $('#adminCommonModalBody').find('script').each(function() {
                    $('#adminCommonModalBody').find('script').each(function() {
                        try {
                            if (this.src) {
                                $.getScript(this.src);
                            } else {
                                $.globalEval(this.text || this.textContent || this.innerHTML || '');
                            }
                        } catch(e) {
                            console.warn('[Modal Script Eval Error]', e);
                        }
                    });
                    */
                    $('#adminCommonModalBody').find('script').each(function() {
                        try {
                            if (this.src) {
                                $.getScript(this.src);
                            } else {
                                $.globalEval(this.text || this.textContent || this.innerHTML || '');
                            }
                        } catch(e) {
                            console.warn('[Modal Script Eval Error]', e);
                        }
                    });
                },
                error: function(xhr, status) {
                    if (status === 'abort') return;
                    const code = status === 'timeout' ? 'timeout' : xhr.status;
                    $('#adminCommonModalBody').html('<div class="p-5 text-center text-danger"><i class="bi bi-exclamation-triangle fs-1"></i><br>데이터를 불러오지 못했습니다. (' + code + ')</div>');
                },
                complete: function() {
                    adminModalRequest = null;
                }
            });
        }

        /**
         * 저장 성공 시 호출되는 전역 콜백 (각 List 페이지에서 재정의 가능)
         */
        var fn_onSaveSuccess = function() {
            const modalEl = document.getElementById('adminCommonModal');
            const modal = bootstrap.Modal.getInstance(modalEl);
            if (modal) modal.hide();
            
            // 강제 정리 (Bootstrap 버그 방지)
            $('body').removeClass('modal-open').css('overflow', '');
            $('.modal-backdrop').remove();

            fn_toast('정상적으로 처리되었습니다.', 'success');
            setTimeout(() => {
                if (typeof fn_link_page === 'function') fn_link_page(1);
                else location.reload();
            }, 800);
        };

        // 모달이 닫힐 때 상태 강제 복구 (회귀 방지)
        $(document).on('hidden.bs.modal', '#adminCommonModal', function () {
            if (adminModalRequest && adminModalRequest.readyState !== 4) {
                adminModalRequest.abort();
                adminModalRequest = null;
            }
            $('body').removeClass('modal-open').css('overflow', '');
            $('.modal-backdrop').remove();
        });
    </script>

    <script>
        $(document).ready(function() {
            // Global AJAX Loader
            $(document).ajaxStart(function() {
                $('#global-loader').css('display', 'flex');
            }).ajaxStop(function() {
                $('#global-loader').hide();
            });

            // Premium Toast Utility (Custom CSS Animation)
            window.fn_toast = function(message, type = 'info') {
                const $toast = $('#premiumToast');
                if ($toast.length === 0) {
                    alert(message);
                    return;
                }
                const $msgArea = $('#toastMsg');
                const $icon = $('#toastIcon');

                let iconHtml = '';
                if(type === 'success') iconHtml = '<i class="bi bi-check-circle-fill text-success"></i>';
                else if(type === 'error' || type === 'danger') iconHtml = '<i class="bi bi-x-circle-fill text-danger"></i>';
                else if(type === 'warning') iconHtml = '<i class="bi bi-exclamation-triangle-fill text-warning"></i>';
                else iconHtml = '<i class="bi bi-info-circle-fill text-primary"></i>';

                $icon.html(iconHtml);
                $msgArea.text(message);
                
                $toast.removeClass('success error danger warning info show')
                      .addClass(type || 'info')
                      .addClass('show');

                if (window._toastTimeout) clearTimeout(window._toastTimeout);
                window._toastTimeout = setTimeout(function() { 
                    $toast.removeClass('show'); 
                }, 3000);
            };

            // Absolutely Bulletproof Menu Persistence (Expansion + Active Highlight)
            const forceMenuExpand = () => {
                const path = window.location.href.toLowerCase();
                
                // Sidebar highlight synchronization based on active items
                $('.nav-child-item.active').each(function() {
                    const $collapse = $(this).closest('.collapse');
                    if ($collapse.length) {
                        $collapse.addClass('show');
                        $collapse.prev('.nav-parent').removeClass('collapsed').attr('aria-expanded', 'true');
                    }
                });
            };

            forceMenuExpand();
        });

    </script>
</body>
</html>
