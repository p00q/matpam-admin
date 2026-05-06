<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"    uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui"   uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<style>
/* ════════════════════════════════════════════
   KPI 통계 카드
════════════════════════════════════════════ */
.kpi-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 14px;
    margin-bottom: 22px;
}
@media (max-width: 1100px) { .kpi-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 600px)  { .kpi-grid { grid-template-columns: 1fr; } }

.kpi-card {
    background: #fff;
    border: 1px solid #e9ecef;
    border-radius: 14px;
    padding: 18px 20px;
    display: flex;
    align-items: center;
    gap: 16px;
    box-shadow: 0 1px 4px rgba(0,0,0,.05);
    transition: box-shadow .2s, transform .2s;
    cursor: default;
}
.kpi-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,.10); transform: translateY(-2px); }

.kpi-icon {
    width: 48px; height: 48px;
    border-radius: 12px;
    display: flex; align-items: center; justify-content: center;
    font-size: 1.4rem;
    flex-shrink: 0;
}
.kpi-icon.total    { background: #eef2ff; }
.kpi-icon.active   { background: #d1fae5; }
.kpi-icon.locked   { background: #fef3c7; }
.kpi-icon.role     { background: #ede9fe; }

.kpi-body { flex: 1; min-width: 0; }
.kpi-label { font-size: .75rem; color: #6c757d; font-weight: 600; text-transform: uppercase; letter-spacing: .5px; margin-bottom: 2px; }
.kpi-value { font-size: 1.65rem; font-weight: 800; color: #1e293b; line-height: 1; }
.kpi-sub   { font-size: .72rem; color: #94a3b8; margin-top: 3px; }

/* ════════════════════════════════════════════
   검색 패널
════════════════════════════════════════════ */
.search-panel {
    background: #fff;
    border: 1px solid #e9ecef;
    border-radius: 14px;
    padding: 18px 22px;
    margin-bottom: 18px;
    box-shadow: 0 1px 4px rgba(0,0,0,.04);
}
.search-panel .panel-title {
    font-size: .82rem;
    font-weight: 700;
    color: #64748b;
    text-transform: uppercase;
    letter-spacing: .6px;
    margin-bottom: 14px;
    display: flex;
    align-items: center;
    gap: 6px;
}

/* ════════════════════════════════════════════
   목록 카드
════════════════════════════════════════════ */
.list-card {
    background: #fff;
    border: 1px solid #e9ecef;
    border-radius: 14px;
    overflow: hidden;
    box-shadow: 0 1px 4px rgba(0,0,0,.05);
}
.list-card-header {
    padding: 14px 20px;
    border-bottom: 1px solid #f1f5f9;
    display: flex;
    align-items: center;
    justify-content: space-between;
    background: #fff;
}
.list-card-header .title-block {
    display: flex; align-items: center; gap: 10px;
}
.list-card-header .title-text {
    font-weight: 700; font-size: .95rem; color: #1e293b;
}
.list-card-header .count-badge {
    background: #f1f5f9;
    color: #64748b;
    border-radius: 20px;
    padding: 2px 10px;
    font-size: .75rem;
    font-weight: 600;
}

/* ════════════════════════════════════════════
   테이블
════════════════════════════════════════════ */
.user-table { width: 100%; border-collapse: collapse; }
.user-table thead tr {
    background: #f8fafc;
    border-bottom: 2px solid #e9ecef;
}
.user-table thead th {
    padding: 11px 14px;
    font-size: .75rem;
    font-weight: 700;
    color: #64748b;
    text-transform: uppercase;
    letter-spacing: .5px;
    white-space: nowrap;
}
.user-table tbody tr {
    border-bottom: 1px solid #f1f5f9;
    transition: background .15s;
}
.user-table tbody tr:hover { background: #fafbff; }
.user-table tbody tr:last-child { border-bottom: none; }
.user-table td { padding: 13px 14px; vertical-align: middle; font-size: .88rem; }

/* 사용자 아이덴티티 셀 */
.user-identity { display: flex; align-items: center; gap: 10px; }
.user-avatar {
    width: 36px; height: 36px;
    border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    font-size: .85rem; font-weight: 700;
    flex-shrink: 0;
    color: #fff;
}
.avatar-SUPER_ADMIN   { background: linear-gradient(135deg,#1e293b,#475569); }
.avatar-SELLER_ADMIN  { background: linear-gradient(135deg,#4361ee,#3a86ff); }
.avatar-CHANNEL_ADMIN { background: linear-gradient(135deg,#7c3aed,#a855f7); }
.avatar-BUYER_ADMIN   { background: linear-gradient(135deg,#059669,#34d399); }

.user-id-text   { font-weight: 700; color: #1e293b; font-size: .88rem; }
.user-name-text { font-size: .77rem; color: #64748b; }

/* 역할 뱃지 */
.role-badge {
    display: inline-flex; align-items: center; gap: 5px;
    padding: 4px 10px;
    border-radius: 20px;
    font-size: .73rem;
    font-weight: 700;
    white-space: nowrap;
}
.role-SUPER_ADMIN   { background: #1e293b; color: #fff; }
.role-SELLER_ADMIN  { background: #dbeafe; color: #1d4ed8; }
.role-CHANNEL_ADMIN { background: #ede9fe; color: #6d28d9; }
.role-BUYER_ADMIN   { background: #d1fae5; color: #065f46; }

/* 상태 뱃지 */
.status-badge {
    display: inline-flex; align-items: center; gap: 5px;
    padding: 4px 10px;
    border-radius: 20px;
    font-size: .73rem;
    font-weight: 700;
}
.status-ACTIVE   { background: #d1fae5; color: #065f46; }
.status-LOCKED   { background: #fef3c7; color: #92400e; }
.status-INACTIVE { background: #f1f5f9; color: #64748b; }
.status-dot {
    width: 6px; height: 6px; border-radius: 50%; flex-shrink: 0;
}
.dot-ACTIVE   { background: #10b981; }
.dot-LOCKED   { background: #f59e0b; }
.dot-INACTIVE { background: #94a3b8; }

/* 소속 정보 셀 */
.affil-company { font-weight: 600; color: #1e293b; font-size: .83rem; }
.affil-tenant  { font-size: .72rem; color: #94a3b8; margin-top: 1px; }
.affil-channel {
    display: inline-block;
    margin-top: 3px;
    padding: 1px 7px;
    background: #f0f4ff;
    color: #4361ee;
    border-radius: 4px;
    font-size: .68rem;
    font-weight: 600;
}

/* 연락처 셀 */
.contact-mobile { font-size: .82rem; color: #374151; }
.contact-email  { font-size: .72rem; color: #94a3b8; }

/* 날짜 셀 */
.date-main { font-size: .82rem; color: #374151; }
.date-sub  { font-size: .7rem;  color: #94a3b8; }

/* 관리 버튼 */
.action-btn-group { display: flex; gap: 5px; justify-content: center; flex-wrap: nowrap; }
.btn-action {
    width: 30px; height: 30px;
    border-radius: 7px;
    border: 1px solid #e2e8f0;
    background: #fff;
    display: flex; align-items: center; justify-content: center;
    font-size: .78rem;
    cursor: pointer;
    transition: all .15s;
    text-decoration: none;
    color: #475569;
}
.btn-action:hover { background: #f0f4ff; border-color: #4361ee; color: #4361ee; }
.btn-action.danger:hover { background: #fff1f2; border-color: #ef4444; color: #ef4444; }
.btn-action.warn:hover   { background: #fffbeb; border-color: #f59e0b; color: #f59e0b; }
.btn-action.success:hover{ background: #f0fdf4; border-color: #10b981; color: #10b981; }

/* 빈 상태 */
.empty-state {
    padding: 60px 0;
    text-align: center;
    color: #94a3b8;
}
.empty-icon { font-size: 3rem; margin-bottom: 12px; }
.empty-text { font-size: .9rem; }

/* 페이지네이션 */
.pagination-wrap {
    padding: 14px 20px;
    border-top: 1px solid #f1f5f9;
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 10px;
    background: #fff;
}
.pagination-info { font-size: .78rem; color: #94a3b8; }
.pagination .page-link {
    border-radius: 7px !important;
    margin: 0 2px;
    font-size: .82rem;
    color: #475569;
    border-color: #e9ecef;
    padding: 5px 10px;
}
.pagination .page-item.active .page-link {
    background: #4361ee; border-color: #4361ee; color: #fff;
}
.pagination .page-link:hover {
    background: #f0f4ff; color: #4361ee; border-color: #c7d2fe;
}

/* 상태변경 드롭다운 */
.status-dropdown .dropdown-item {
    font-size: .82rem; padding: 7px 14px; display: flex; align-items: center; gap: 7px;
}
.status-dropdown .dropdown-item:active { background: #f0f4ff; color: #4361ee; }
</style>

<div class="container-fluid px-0">

    <!-- ── 페이지 헤더 ── -->
    <div class="px-4 pt-3 pb-1">
        <div class="d-flex align-items-center justify-content-between mb-1">
            <div>
                <h4 class="fw-bold mb-0" style="color:#1e293b;">사용자 관리</h4>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0" style="font-size:.78rem;">
                        <li class="breadcrumb-item"><a href="/admin/dashboard/main.do" class="text-decoration-none text-muted">대시보드</a></li>
                        <li class="breadcrumb-item active text-muted">사용자 관리</li>
                    </ol>
                </nav>
            </div>
            <a href="/admin/user/userForm.do" class="btn btn-primary px-4 shadow-sm"
               style="border-radius:10px; font-weight:600; font-size:.85rem;">
                <i class="bi bi-person-plus-fill me-2"></i>신규 등록
            </a>
        </div>
    </div>

    <div class="px-4 py-3">

        <!-- ══════════════════════════════════════════
             KPI 통계 카드
        ══════════════════════════════════════════ -->
        <div class="kpi-grid" id="kpiGrid">
            <div class="kpi-card">
                <div class="kpi-icon total"><i class="bi bi-people-fill" style="color:#4361ee;"></i></div>
                <div class="kpi-body">
                    <div class="kpi-label">전체 사용자</div>
                    <div class="kpi-value" id="kpiTotal">-</div>
                    <div class="kpi-sub">등록된 모든 계정</div>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon active"><i class="bi bi-person-check-fill" style="color:#10b981;"></i></div>
                <div class="kpi-body">
                    <div class="kpi-label">활성 계정</div>
                    <div class="kpi-value" id="kpiActive">-</div>
                    <div class="kpi-sub" id="kpiActiveSub">로그인 가능</div>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon locked"><i class="bi bi-lock-fill" style="color:#f59e0b;"></i></div>
                <div class="kpi-body">
                    <div class="kpi-label">잠금 / 비활성</div>
                    <div class="kpi-value" id="kpiLocked">-</div>
                    <div class="kpi-sub">LOCKED + INACTIVE</div>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon role"><i class="bi bi-diagram-3-fill" style="color:#7c3aed;"></i></div>
                <div class="kpi-body">
                    <div class="kpi-label">역할 분포</div>
                    <div class="kpi-value" id="kpiRoleSummary" style="font-size:1rem; padding-top:4px;">-</div>
                    <div class="kpi-sub">판매처 / 채널 / 구매처</div>
                </div>
            </div>
        </div>

        <!-- ══════════════════════════════════════════
             검색 패널
        ══════════════════════════════════════════ -->
        <div class="search-panel">
            <div class="panel-title">
                <i class="bi bi-funnel-fill"></i> 검색 조건
            </div>
            <form:form modelAttribute="searchVO" id="searchForm" name="searchForm"
                       method="get" action="/admin/user/userList.do">
                <form:hidden path="pageIndex" id="pageIndex"/>

                <div class="row g-3 align-items-end">

                    <!-- 테넌트 -->
                    <div class="col-xl-2 col-md-4 col-sm-6">
                        <label class="form-label fw-semibold" style="font-size:.8rem;">테넌트</label>
                        <form:select path="tenantId" class="form-select form-select-sm">
                            <form:option value="" label="-- 전체 --"/>
                            <c:forEach var="t" items="${tenants}">
                                <form:option value="${t.tenantId}" label="${t.tenantName}"/>
                            </c:forEach>
                        </form:select>
                    </div>

                    <!-- 역할 -->
                    <div class="col-xl-2 col-md-4 col-sm-6">
                        <label class="form-label fw-semibold" style="font-size:.8rem;">역할</label>
                        <form:select path="userRole" class="form-select form-select-sm">
                            <form:option value="" label="-- 전체 --"/>
                            <form:option value="SUPER_ADMIN"   label="🛡 수퍼관리자"/>
                            <form:option value="SELLER_ADMIN"  label="🏭 판매처관리자"/>
                            <form:option value="CHANNEL_ADMIN" label="📦 채널관리자"/>
                            <form:option value="BUYER_ADMIN"   label="🛒 구매처관리자"/>
                        </form:select>
                    </div>

                    <!-- 상태 -->
                    <div class="col-xl-2 col-md-4 col-sm-6">
                        <label class="form-label fw-semibold" style="font-size:.8rem;">상태</label>
                        <form:select path="status" class="form-select form-select-sm">
                            <form:option value="" label="-- 전체 --"/>
                            <form:option value="ACTIVE"   label="활성"/>
                            <form:option value="LOCKED"   label="잠금"/>
                            <form:option value="INACTIVE" label="비활성"/>
                        </form:select>
                    </div>

                    <!-- 검색어 -->
                    <div class="col-xl-4 col-md-8 col-sm-9">
                        <label class="form-label fw-semibold" style="font-size:.8rem;">검색어 (ID / 이름)</label>
                        <div class="input-group input-group-sm">
                            <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                            <form:input path="searchKeyword" class="form-control"
                                        placeholder="로그인 ID 또는 사용자 이름"/>
                        </div>
                    </div>

                    <!-- 버튼 -->
                    <div class="col-xl-2 col-md-4 col-sm-3">
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary btn-sm flex-fill fw-semibold">
                                <i class="bi bi-search me-1"></i>검색
                            </button>
                            <a href="/admin/user/userList.do" class="btn btn-outline-secondary btn-sm"
                               title="초기화">
                                <i class="bi bi-arrow-counterclockwise"></i>
                            </a>
                        </div>
                    </div>

                </div>
            </form:form>
        </div>

        <!-- ══════════════════════════════════════════
             목록 테이블
        ══════════════════════════════════════════ -->
        <div class="list-card">

            <!-- 카드 헤더 -->
            <div class="list-card-header">
                <div class="title-block">
                    <i class="bi bi-table" style="color:#4361ee; font-size:1.1rem;"></i>
                    <span class="title-text">사용자 목록</span>
                    <span class="count-badge">총 ${paginationInfo.totalRecordCount}명</span>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <!-- 페이지당 건수 -->
                    <select class="form-select form-select-sm" style="width:auto;"
                            onchange="fn_changePageUnit(this.value)">
                        <option value="10"  ${searchVO.pageUnit == 10  || searchVO.pageUnit == null ? 'selected' : ''}>10건</option>
                        <option value="20"  ${searchVO.pageUnit == 20  ? 'selected' : ''}>20건</option>
                        <option value="50"  ${searchVO.pageUnit == 50  ? 'selected' : ''}>50건</option>
                        <option value="100" ${searchVO.pageUnit == 100 ? 'selected' : ''}>100건</option>
                    </select>
                </div>
            </div>

            <!-- 테이블 -->
            <div class="table-responsive">
                <table class="user-table">
                    <thead>
                        <tr>
                            <th class="text-center" style="width:44px;">No</th>
                            <th style="min-width:160px;">사용자</th>
                            <th class="text-center" style="min-width:120px;">역할</th>
                            <th style="min-width:160px;">소속 정보</th>
                            <th style="min-width:130px;">연락처</th>
                            <th class="text-center" style="min-width:100px;">상태</th>
                            <th class="text-center" style="min-width:110px;">최근 로그인</th>
                            <th class="text-center" style="min-width:80px;">등록일</th>
                            <th class="text-center" style="width:100px;">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty userList}">
                                <c:forEach var="item" items="${userList}" varStatus="st">
                                    <tr id="row-${item.userId}">

                                        <!-- No -->
                                        <td class="text-center" style="color:#94a3b8; font-size:.75rem;">
                                            ${paginationInfo.totalRecordCount - paginationInfo.firstRecordIndex - st.index}
                                        </td>

                                        <!-- 사용자 (아바타 + ID + 이름) -->
                                        <td>
                                            <div class="user-identity">
                                                <div class="user-avatar avatar-${item.userRole}">
                                                    ${fn:substring(item.userName, 0, 1)}
                                                </div>
                                                <div>
                                                    <div class="user-id-text">${item.loginId}</div>
                                                    <div class="user-name-text">${item.userName}</div>
                                                </div>
                                            </div>
                                        </td>

                                        <!-- 역할 -->
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${item.userRole == 'SUPER_ADMIN'}">
                                                    <span class="role-badge role-SUPER_ADMIN">
                                                        <i class="bi bi-shield-fill-check"></i> 수퍼관리자
                                                    </span>
                                                </c:when>
                                                <c:when test="${item.userRole == 'SELLER_ADMIN'}">
                                                    <span class="role-badge role-SELLER_ADMIN">
                                                        <i class="bi bi-building"></i> 판매처관리자
                                                    </span>
                                                </c:when>
                                                <c:when test="${item.userRole == 'CHANNEL_ADMIN'}">
                                                    <span class="role-badge role-CHANNEL_ADMIN">
                                                        <i class="bi bi-box-seam"></i> 채널관리자
                                                    </span>
                                                </c:when>
                                                <c:when test="${item.userRole == 'BUYER_ADMIN'}">
                                                    <span class="role-badge role-BUYER_ADMIN">
                                                        <i class="bi bi-cart3"></i> 구매처관리자
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="role-badge" style="background:#f1f5f9;color:#64748b;">
                                                        ${item.userRole}
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- 소속 정보 -->
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.userRole == 'SUPER_ADMIN'}">
                                                    <span style="font-size:.75rem; color:#94a3b8; font-style:italic;">전체 플랫폼</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="affil-company">
                                                        <c:choose>
                                                            <c:when test="${not empty item.companyName}">${item.companyName}</c:when>
                                                            <c:otherwise><span style="color:#94a3b8;">-</span></c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="affil-tenant">
                                                        <c:choose>
                                                            <c:when test="${not empty item.tenantName}">${item.tenantName}</c:when>
                                                            <c:otherwise>-</c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <c:if test="${item.userRole == 'CHANNEL_ADMIN' and not empty item.channelName}">
                                                        <span class="affil-channel">
                                                            <i class="bi bi-box-seam"></i> ${item.channelName}
                                                        </span>
                                                    </c:if>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- 연락처 -->
                                        <td>
                                            <div class="contact-mobile">
                                                <c:choose>
                                                    <c:when test="${not empty item.mobile}">
                                                        <i class="bi bi-phone" style="font-size:.7rem; color:#94a3b8;"></i>
                                                        ${item.mobile}
                                                    </c:when>
                                                    <c:otherwise><span style="color:#cbd5e1;">-</span></c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="contact-email">
                                                <c:if test="${not empty item.email}">
                                                    <i class="bi bi-envelope" style="font-size:.68rem;"></i>
                                                    ${item.email}
                                                </c:if>
                                            </div>
                                        </td>

                                        <!-- 상태 -->
                                        <td class="text-center" id="status-cell-${item.userId}">
                                            <span class="status-badge status-${item.status}">
                                                <span class="status-dot dot-${item.status}"></span>
                                                <c:choose>
                                                    <c:when test="${item.status == 'ACTIVE'}">활성</c:when>
                                                    <c:when test="${item.status == 'LOCKED'}">잠금</c:when>
                                                    <c:otherwise>비활성</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>

                                        <!-- 최근 로그인 -->
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${not empty item.lastLoginAt}">
                                                    <div class="date-main">
                                                        <fmt:formatDate value="${item.lastLoginAt}" pattern="MM-dd HH:mm"/>
                                                    </div>
                                                    <div class="date-sub">
                                                        <fmt:formatDate value="${item.lastLoginAt}" pattern="yyyy"/>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color:#cbd5e1; font-size:.75rem;">미로그인</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- 등록일 -->
                                        <td class="text-center">
                                            <div class="date-main">
                                                <fmt:formatDate value="${item.createdAt}" pattern="MM-dd"/>
                                            </div>
                                            <div class="date-sub">
                                                <fmt:formatDate value="${item.createdAt}" pattern="yyyy"/>
                                            </div>
                                        </td>

                                        <!-- 관리 -->
                                        <td class="text-center">
                                            <div class="action-btn-group">

                                                <!-- 수정 -->
                                                <a href="/admin/user/userForm.do?userId=${item.userId}"
                                                   class="btn-action" title="수정">
                                                    <i class="bi bi-pencil-fill"></i>
                                                </a>

                                                <!-- 상태 변경 드롭다운 -->
                                                <div class="dropdown">
                                                    <button class="btn-action" type="button"
                                                            data-bs-toggle="dropdown"
                                                            title="상태 변경">
                                                        <i class="bi bi-three-dots-vertical"></i>
                                                    </button>
                                                    <ul class="dropdown-menu dropdown-menu-end shadow-sm status-dropdown"
                                                        style="min-width:160px; border-radius:10px; font-size:.82rem;">
                                                        <li><h6 class="dropdown-header" style="font-size:.7rem;">상태 변경</h6></li>
                                                        <c:if test="${item.status != 'ACTIVE'}">
                                                            <li>
                                                                <a class="dropdown-item" href="javascript:;"
                                                                   onclick="fn_changeStatus(${item.userId},'ACTIVE')">
                                                                    <span class="status-dot dot-ACTIVE"
                                                                          style="display:inline-block;"></span>
                                                                    활성으로 변경
                                                                </a>
                                                            </li>
                                                        </c:if>
                                                        <c:if test="${item.status != 'LOCKED'}">
                                                            <li>
                                                                <a class="dropdown-item" href="javascript:;"
                                                                   onclick="fn_changeStatus(${item.userId},'LOCKED')">
                                                                    <span class="status-dot dot-LOCKED"
                                                                          style="display:inline-block;"></span>
                                                                    잠금으로 변경
                                                                </a>
                                                            </li>
                                                        </c:if>
                                                        <c:if test="${item.status != 'INACTIVE'}">
                                                            <li>
                                                                <a class="dropdown-item" href="javascript:;"
                                                                   onclick="fn_changeStatus(${item.userId},'INACTIVE')">
                                                                    <span class="status-dot dot-INACTIVE"
                                                                          style="display:inline-block;"></span>
                                                                    비활성으로 변경
                                                                </a>
                                                            </li>
                                                        </c:if>
                                                    </ul>
                                                </div>

                                            </div>
                                        </td>

                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="9">
                                        <div class="empty-state">
                                            <div class="empty-icon">👤</div>
                                            <div class="empty-text fw-semibold" style="color:#475569;">
                                                검색 결과가 없습니다.
                                            </div>
                                            <div class="mt-2" style="font-size:.8rem; color:#94a3b8;">
                                                검색 조건을 변경하거나
                                                <a href="/admin/user/userForm.do" class="text-primary text-decoration-none fw-semibold">
                                                    신규 사용자를 등록
                                                </a>
                                                해 주세요.
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- 페이지네이션 -->
            <div class="pagination-wrap">
                <div class="pagination-info">
                    전체 <strong>${paginationInfo.totalRecordCount}</strong>건 중
                    <strong>${paginationInfo.firstRecordIndex + 1}</strong> ~
                    <c:choose>
                        <c:when test="${paginationInfo.firstRecordIndex + paginationInfo.recordCountPerPage > paginationInfo.totalRecordCount}">
                            <strong>${paginationInfo.totalRecordCount}</strong>
                        </c:when>
                        <c:otherwise>
                            <strong>${paginationInfo.firstRecordIndex + paginationInfo.recordCountPerPage}</strong>
                        </c:otherwise>
                    </c:choose>
                    건 표시
                </div>
                <nav>
                    <ul class="pagination mb-0">
                        <!-- 첫 페이지 -->
                        <c:if test="${paginationInfo.currentPageNo > 1}">
                            <li class="page-item">
                                <a class="page-link" href="javascript:fn_egov_link_page(1);" title="처음">
                                    <i class="bi bi-chevron-double-left"></i>
                                </a>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="javascript:fn_egov_link_page(${paginationInfo.currentPageNo - 1});">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                        </c:if>

                        <!-- 페이지 번호 -->
                        <c:forEach var="i"
                                   begin="${paginationInfo.firstPageNoOnPageList}"
                                   end="${paginationInfo.lastPageNoOnPageList}">
                            <c:choose>
                                <c:when test="${i == paginationInfo.currentPageNo}">
                                    <li class="page-item active"><span class="page-link">${i}</span></li>
                                </c:when>
                                <c:otherwise>
                                    <li class="page-item">
                                        <a class="page-link" href="javascript:fn_egov_link_page(${i});">${i}</a>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <!-- 마지막 페이지 -->
                        <c:if test="${paginationInfo.currentPageNo < paginationInfo.totalPageCount}">
                            <li class="page-item">
                                <a class="page-link" href="javascript:fn_egov_link_page(${paginationInfo.currentPageNo + 1});">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="javascript:fn_egov_link_page(${paginationInfo.totalPageCount});" title="마지막">
                                    <i class="bi bi-chevron-double-right"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </div>

        </div><!-- /list-card -->
    </div><!-- /px-4 -->
</div>

<!-- ════════════════════════════════════════════
     JavaScript
════════════════════════════════════════════ -->
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script>
/* ── 페이지 이동 ── */
function fn_egov_link_page(pageNo) {
    document.getElementById('pageIndex').value = pageNo;
    document.getElementById('searchForm').submit();
}

/* ── 페이지당 건수 변경 ── */
function fn_changePageUnit(unit) {
    var form = document.getElementById('searchForm');
    var inp  = document.createElement('input');
    inp.type  = 'hidden';
    inp.name  = 'pageUnit';
    inp.value = unit;
    form.appendChild(inp);
    document.getElementById('pageIndex').value = 1;
    form.submit();
}

/* ── 상태 변경 ── */
function fn_changeStatus(userId, newStatus) {
    const labelMap = { ACTIVE: '활성', LOCKED: '잠금', INACTIVE: '비활성' };
    if (!confirm('[' + labelMap[newStatus] + ']으로 상태를 변경하시겠습니까?')) return;

    $.ajax({
        url:  '/admin/user/updateStatus.ajax',
        type: 'POST',
        data: { userId: userId, status: newStatus },
        success: function(res) {
            if (res.success) {
                fn_updateStatusCell(userId, newStatus);
                if (typeof fn_toast === 'function') {
                    fn_toast('상태가 [' + labelMap[newStatus] + ']으로 변경되었습니다.', 'success');
                }
            } else {
                alert('변경 실패: ' + res.message);
            }
        },
        error: function() {
            alert('통신 오류가 발생했습니다.');
        }
    });
}

/* ── 상태 셀 인라인 갱신 (페이지 새로고침 없이) ── */
function fn_updateStatusCell(userId, status) {
    const labelMap = { ACTIVE: '활성', LOCKED: '잠금', INACTIVE: '비활성' };
    const cell = document.getElementById('status-cell-' + userId);
    if (!cell) return;

    cell.innerHTML =
        '<span class="status-badge status-' + status + '">' +
            '<span class="status-dot dot-' + status + '"></span>' +
            labelMap[status] +
        '</span>';

    // 드롭다운 메뉴도 현재 상태 제외하도록 재구성
    const allStatuses = ['ACTIVE','LOCKED','INACTIVE'];
    const row = document.getElementById('row-' + userId);
    if (!row) return;
    const menu = row.querySelector('.status-dropdown .dropdown-menu');
    if (!menu) return;

    let html = '<li><h6 class="dropdown-header" style="font-size:.7rem;">상태 변경</h6></li>';
    allStatuses.forEach(function(s) {
        if (s !== status) {
            html += '<li><a class="dropdown-item" href="javascript:;" onclick="fn_changeStatus(' + userId + ',\'' + s + '\')">'
                  + '<span class="status-dot dot-' + s + '" style="display:inline-block;"></span>'
                  + labelMap[s] + '으로 변경'
                  + '</a></li>';
        }
    });
    menu.innerHTML = html;
}

/* ── KPI 통계 로드 ── */
function fn_loadStats() {
    $.ajax({
        url:  '/admin/user/userStats.ajax',
        type: 'GET',
        success: function(res) {
            if (!res.success) return;

            $('#kpiTotal').text(res.total.toLocaleString());
            $('#kpiActive').text(res.activeCount.toLocaleString());
            $('#kpiActiveSub').text('잠금 ' + res.lockedCount + '명 포함');
            $('#kpiLocked').text((res.lockedCount + (res.total - res.activeCount - res.lockedCount)).toLocaleString());

            // 역할 분포 요약
            const roleSummary = res.sellerCount + ' / ' + res.channelCount + ' / ' + res.buyerCount;
            $('#kpiRoleSummary').html(
                '<span style="color:#1d4ed8;">' + res.sellerCount + '</span>' +
                ' <span style="color:#94a3b8;font-size:.75rem;font-weight:400;">판매</span> · ' +
                '<span style="color:#6d28d9;">' + res.channelCount + '</span>' +
                ' <span style="color:#94a3b8;font-size:.75rem;font-weight:400;">채널</span> · ' +
                '<span style="color:#065f46;">' + res.buyerCount + '</span>' +
                ' <span style="color:#94a3b8;font-size:.75rem;font-weight:400;">구매</span>'
            );
        }
    });
}

/* ── 초기화 ── */
$(function() {
    fn_loadStats();
});
</script>
