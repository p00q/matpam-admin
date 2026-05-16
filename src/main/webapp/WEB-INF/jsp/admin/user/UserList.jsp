<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"    uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui"   uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%-- Removed Diagnostic Info --%>
<div class="container-fluid px-0">

    <!-- ── 페이지 헤더 ── -->
    <div class="px-4 pt-3 pb-1">
        <div class="d-flex align-items-center justify-content-between mb-1">
            <h4 class="fw-bold mb-0" style="color:#1e293b;"><i class="bi bi-people-fill me-2"></i>${pageTitle}</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0" style="font-size:.78rem;">
                    <li class="breadcrumb-item"><a href="<c:url value='/admin/dashboard/main.do'/>" class="text-decoration-none text-muted">대시보드</a></li>
                    <li class="breadcrumb-item active text-muted">회원 관리</li>
                </ol>
            </nav>
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
                <div class="kpi-icon active"><i class="bi bi-check-circle-fill" style="color:#10b981;"></i></div>
                <div class="kpi-body">
                    <div class="kpi-label">정상 계정</div>
                    <div class="kpi-value" id="kpiActive">-</div>
                    <div class="kpi-sub">로그인 가능 상태</div>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon locked"><i class="bi bi-lock-fill" style="color:#f59e0b;"></i></div>
                <div class="kpi-body">
                    <div class="kpi-label">잠김/중지</div>
                    <div class="kpi-value" id="kpiLocked">-</div>
                    <div class="kpi-sub">관리자 확인 필요</div>
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
                       method="get" action="${pageContext.request.contextPath}/admin/user/userList.do">
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

                    <!-- 역할 (특정 역할 목록일 경우 숨김) -->
                    <c:if test="${empty searchVO.userRole}">
                    <div class="col-xl-2 col-md-4 col-sm-6">
                        <label class="form-label fw-semibold" style="font-size:.8rem;">역할</label>
                        <form:select path="userRole" class="form-select form-select-sm">
                            <form:option value="" label="-- 전체 --"/>
                            <form:option value="SUPER_ADMIN"   label="🛡 수퍼관리자"/>
                            <form:option value="SELLER_ADMIN"  label="🏭 판매처관리자"/>
                            <form:option value="BUYER_ADMIN"   label="🛒 구매처관리자"/>
                        </form:select>
                    </div>
                    </c:if>
                    <c:if test="${not empty searchVO.userRole}">
                        <form:hidden path="userRole"/>
                    </c:if>

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
                            <a href="<c:url value='/admin/user/userList.do'/>" class="btn btn-outline-secondary btn-sm"
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
                    <span class="title-text">회원 목록</span>
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
                    <button type="button" class="btn btn-primary btn-sm px-3 shadow-sm"
                            style="border-radius:8px; font-weight:600;"
                            onclick="fn_openUserModal(null, '${searchVO.userRole}')">
                        <i class="bi bi-person-plus-fill me-1"></i>신규 등록
                    </button>
                </div>
            </div>

            <!-- 테이블 -->
            <div class="table-responsive">
                <table class="premium-data-table">
                    <thead>
                        <tr>
                            <th class="text-center" style="width:44px;">No</th>
                            <th style="min-width:130px;">사용자ID</th>
                            <th style="min-width:100px;">이름</th>
                            <th style="min-width:120px;">대상 채널</th>
                            <th style="min-width:130px;">소속 업체</th>
                            <th style="min-width:120px;">연락처</th>
                            <th class="text-center" style="min-width:90px;">상태</th>
                            <th class="text-center" style="min-width:110px;">최근 로그인</th>
                            <th class="text-center" style="min-width:100px;">등록일</th>
                            <th class="text-center" style="width:100px;">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty userList}">
                                <c:forEach var="item" items="${userList}" varStatus="st">
                                    <c:if test="${item.userRole != 'CHANNEL_ADMIN' and item.userRole != 'OPERATOR'}">
                                    <tr id="row-${item.userId}">

                                        <!-- No -->
                                        <td class="text-center" style="color:#94a3b8; font-size:.75rem;">
                                            ${paginationInfo.totalRecordCount - paginationInfo.firstRecordIndex - st.index}
                                        </td>

                                        <!-- 사용자ID -->
                                        <td style="font-size:.82rem; color:#334155;">${item.loginId}</td>

                                        <!-- 이름 -->
                                        <td style="font-weight:600; color:#1e293b;">${item.userName}</td>




                                        <!-- 대상 채널 -->
                                        <td style="font-size:.82rem; color:#64748b; font-weight:bold; color:#4361ee;">
                                            전국택배 (강제출력)
                                        </td>

                                        <!-- 소속 업체 -->
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.userRole == 'SUPER_ADMIN'}">
                                                    <span style="font-size:.75rem; color:#94a3b8; font-style:italic;">전체 플랫폼</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:choose>
                                                        <c:when test="${not empty item.companyName}">${item.companyName}</c:when>
                                                        <c:otherwise><span style="color:#94a3b8;">-</span></c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- 연락처 -->
                                        <td style="font-size:.82rem;">
                                            <c:choose>
                                                <c:when test="${not empty item.mobile}">${item.mobile}</c:when>
                                                <c:otherwise><span style="color:#cbd5e1;">-</span></c:otherwise>
                                            </c:choose>
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

                                        <!-- 유저최신로그인 -->
                                        <td class="text-center" style="font-size:.82rem; color:#64748b;">
                                            <c:choose>
                                                <c:when test="${not empty item.lastLoginAt}">
                                                    <fmt:formatDate value="${item.lastLoginAt}" pattern="yyyy-MM-dd"/>
                                                </c:when>
                                                <c:otherwise><span style="color:#cbd5e1;">미로그인</span></c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- 등록일 -->
                                        <td class="text-center" style="font-size:.82rem; color:#64748b;">
                                            <fmt:formatDate value="${item.createdAt}" pattern="yyyy-MM-dd"/>
                                        </td>

                                        <!-- 관리 -->
                                        <td class="text-center">
                                            <div class="action-btn-group">

                                                <!-- 수정 -->
                                                 <a href="javascript:;" onclick="fn_openUserModal(${item.userId})"
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
                                    </c:if>
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
        url:  "<c:url value='/admin/user/updateStatus.ajax'/>",
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
        url:  "<c:url value='/admin/user/userStats.ajax'/>",
        type: 'GET',
        data: { 
            userRole: '${searchVO.userRole}', 
            searchCondition: '${searchVO.searchCondition}' 
        },
        success: function(res) {
            if (!res.success) return;

            $('#kpiTotal').text(res.total.toLocaleString());
            $('#kpiActive').text(res.activeCount.toLocaleString());
            $('#kpiLocked').text((res.lockedCount + (res.total - res.activeCount - res.lockedCount)).toLocaleString());

            // 역할 분포 요약
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

/* ── 회원 등록/수정 모달 열기 ── */
function fn_openUserModal(userId, userRole) {
    let url = "<c:url value='/admin/user/userForm.do'/>?isModal=Y";
    if (userId) url += "&userId=" + userId;
    if (userRole) url += "&userRole=" + userRole;
    
    const title = userId ? "회원 정보 수정" : "신규 회원 등록";
    fn_openAdminModal(url, title);
}

/* ── 저장 성공 콜백 (main.jsp 전역 콜백 재정의) ── */
fn_onSaveSuccess = function() {
    const modalEl = document.getElementById('adminCommonModal');
    const modal = bootstrap.Modal.getInstance(modalEl);

    if (modal) {
        // 모달 fade 애니메이션 완료 후 토스트 표시 (body.modal-open 간섭 방지)
        $(modalEl).one('hidden.bs.modal', function() {
            fn_toast('정상적으로 처리되었습니다.', 'success');
            setTimeout(function() {
                fn_egov_link_page(1);
            }, 1500);
        });
        modal.hide();
    } else {
        // 모달이 없는 경우 (직접 페이지 접근 등) 즉시 표시
        fn_toast('정상적으로 처리되었습니다.', 'success');
        setTimeout(function() {
            fn_egov_link_page(1);
        }, 1500);
    }
};

/* ── 초기화 ── */
$(function() {
    fn_loadStats();
});
</script>
