<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="container-fluid px-0">
    <!-- ── 페이지 헤더 ── -->
    <div class="px-4 pt-3 pb-1">
        <div class="d-flex align-items-center justify-content-between mb-1">
            <h4 class="fw-bold mb-0" style="color:#1e293b;">
                <c:choose>
                    <c:when test="${param.companyType eq 'SELLER'}"><i class="bi bi-factory me-2"></i>판매업체 관리</c:when>
                    <c:when test="${param.companyType eq 'BUYER'}"><i class="bi bi-shop me-2"></i>구매업체 관리</c:when>
                    <c:otherwise><i class="bi bi-building me-2"></i>몰 정보 관리</c:otherwise>
                </c:choose>
            </h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0" style="font-size:.78rem;">
                    <li class="breadcrumb-item"><a href="<c:url value='/admin/dashboard/main.do'/>" class="text-decoration-none text-muted">대시보드</a></li>
                    <li class="breadcrumb-item text-muted">업체관리</li>
                    <li class="breadcrumb-item active text-muted">
                        <c:choose>
                            <c:when test="${param.companyType eq 'SELLER'}">판매업체</c:when>
                            <c:when test="${param.companyType eq 'BUYER'}">구매업체</c:when>
                            <c:otherwise>몰 정보 관리</c:otherwise>
                        </c:choose>
                    </li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="px-4 py-3">

        <!-- ══ KPI 통계 카드 ══ -->
        <div class="kpi-grid" id="kpiGrid">
            <div class="kpi-card">
                <div class="kpi-icon total"><i class="bi bi-building" style="color:#4361ee;"></i></div>
                <div class="kpi-body">
                    <div class="kpi-label">전체 업체</div>
                    <div class="kpi-value" id="kpiTotal">-</div>
                    <div class="kpi-sub">등록된 모든 업체</div>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon active"><i class="bi bi-check-circle-fill" style="color:#10b981;"></i></div>
                <div class="kpi-body">
                    <div class="kpi-label">정상 업체</div>
                    <div class="kpi-value" id="kpiActive">-</div>
                    <div class="kpi-sub">거래 가능 상태</div>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon locked"><i class="bi bi-slash-circle-fill" style="color:#f59e0b;"></i></div>
                <div class="kpi-body">
                    <div class="kpi-label">비활성</div>
                    <div class="kpi-value" id="kpiLocked">-</div>
                    <div class="kpi-sub">관리자 확인 필요</div>
                </div>
            </div>
        </div>

        <!-- Search Area -->
        <div class="search-panel">
            <div class="panel-title">
                <i class="bi bi-funnel-fill"></i> 검색 조건
            </div>
            <form id="searchForm" action="companyList.do" method="get" class="row g-2 align-items-center">
                <input type="hidden" name="companyType" value="${param.companyType}">
                <div class="col-md-4">
                    <label class="form-label fw-semibold small">업체명</label>
                    <div class="input-group input-group-sm">
                        <input type="text" name="searchKeyword" class="form-control" placeholder="업체명 검색" value="${searchVO.searchKeyword}">
                        <button type="submit" class="btn btn-dark px-4">검색</button>
                    </div>
                </div>
            </form>
        </div>

        <!-- List Area -->
        <div class="list-card">
            <div class="list-card-header d-flex justify-content-between align-items-center">
                <div class="title-block">
                    <i class="bi bi-table" style="color:#4361ee; font-size:1.1rem;"></i>
                    <span class="title-text">업체 목록</span>
                    <span class="count-badge">총 ${paginationInfo.totalRecordCount}건</span>
                </div>
                <c:url var="newUrl" value="/admin/company/companyForm.do">
                    <c:param name="companyType" value="${param.companyType}" />
                </c:url>
                <a href="${newUrl}" class="btn btn-primary btn-sm px-3 shadow-sm" style="border-radius:8px; font-weight:600;">
                    <i class="bi bi-plus-lg me-1"></i> 신규 등록
                </a>
            </div>

            <div class="table-responsive">
                <table class="premium-data-table mb-0">
                    <thead>
                        <tr>
                            <th class="text-center">참여채널명</th>
                            <th class="text-center">${param.companyType eq 'BUYER' ? '구매업체명' : '판매업체명'}</th>
                            <th class="text-center">대표자명</th>
                            <th class="text-center">담당자명</th>
                            <th class="text-center">담당자연락처</th>
                            <th class="text-center">등록일</th>
                            <th class="text-center">수정일</th>
                            <th class="text-center">상태</th>
                            <th class="text-center" width="80">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${companyList}" varStatus="status">
                            <tr>
                                <td class="text-center small text-muted">${item.channelName}</td>
                                <td class="fw-bold text-start ps-4" style="color:#1e293b;">${item.companyName}</td>
                                <td class="text-center">${item.ceoName}</td>
                                <td class="text-center">${item.primaryContactName}</td>
                                <td class="text-center small">${item.primaryContactMobile}</td>
                                <td class="text-center x-small text-muted"><fmt:formatDate value="${item.createdAt}" pattern="yyyy-MM-dd"/></td>
                                <td class="text-center x-small text-muted"><fmt:formatDate value="${item.updatedAt}" pattern="yyyy-MM-dd"/></td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${item.status eq 'ACTIVE'}">
                                            <span class="status-badge status-ACTIVE">
                                                <span class="status-dot dot-ACTIVE"></span>정상
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-INACTIVE">
                                                <span class="status-dot dot-INACTIVE"></span>비활성
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <div class="action-btn-group">
                                        <c:url var="detailUrl" value="/admin/company/companyForm.do">
                                            <c:param name="companyId" value="${item.companyId}" />
                                            <c:param name="companyType" value="${empty item.companyType ? param.companyType : item.companyType}" />
                                        </c:url>
                                        <a href="${detailUrl}" class="btn-action" title="수정">
                                            <i class="bi bi-pencil-fill"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty companyList}">
                            <tr>
                                <td colspan="10">
                                    <div class="empty-state">
                                        <div class="empty-icon">🏢</div>
                                        <div class="empty-text fw-semibold">등록된 업체 정보가 없습니다.</div>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            
            <div class="pagination-wrap">
                <div class="pagination-info">
                    총 <strong class="text-primary">${paginationInfo.totalRecordCount}</strong>건의 업체가 등록되어 있습니다.
                </div>
                <nav>
                    <ul class="pagination mb-0">
                        <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_link_page" />
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</div>
<script>
function fn_link_page(pageNo) {
    var form = document.getElementById('searchForm');
    var input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'pageIndex';
    input.value = pageNo;
    form.appendChild(input);
    form.submit();
}

/* ── KPI 통계 로드 ── */
function fn_loadCompanyStats() {
    $.ajax({
        url:  '<c:url value="/admin/company/companyStats.ajax"/>',
        type: 'GET',
        data: { companyType: '${param.companyType}' },
        success: function(res) {
            if (!res.success) return;
            $('#kpiTotal').text(res.total.toLocaleString());
            $('#kpiActive').text(res.activeCount.toLocaleString());
            $('#kpiLocked').text(res.lockedCount.toLocaleString());
        }
    });
}

$(function() {
    fn_loadCompanyStats();
});
</script>

