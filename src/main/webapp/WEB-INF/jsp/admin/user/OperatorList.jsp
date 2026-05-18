<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="container-fluid px-0">

    <%-- ── 페이지 헤더 ── --%>
    <div class="px-4 pt-3 pb-1">
        <div class="d-flex align-items-center justify-content-between mb-1">
            <h4 class="fw-bold mb-0" style="color:#1e293b;">
                <i class="bi bi-person-gear me-2"></i>운영자 관리
            </h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0" style="font-size:.78rem;">
                    <li class="breadcrumb-item text-muted">운영관리</li>
                    <li class="breadcrumb-item active text-muted">운영자관리</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="px-4 py-3">

        <%-- ── 검색 패널 ── --%>
        <div class="search-panel">
            <div class="panel-title">
                <i class="bi bi-funnel-fill"></i> 검색 조건
            </div>
            <form id="searchForm" action="<c:url value='/admin/user/operatorList.do'/>" method="get"
                  class="row g-2 align-items-end">
                <div class="col-md-2">
                    <label class="form-label fw-semibold small">역할</label>
                    <select name="userRole" class="form-select form-select-sm">
                        <option value="">-- 전체 --</option>
                        <option value="OPERATOR"     ${searchVO.userRole eq 'OPERATOR'     ? 'selected' : ''}>운영자</option>
                        <option value="CHANNEL_ADMIN" ${searchVO.userRole eq 'CHANNEL_ADMIN' ? 'selected' : ''}>채널 운영자</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold small">상태</label>
                    <select name="status" class="form-select form-select-sm">
                        <option value="">-- 전체 --</option>
                        <option value="ACTIVE"   ${searchVO.status eq 'ACTIVE'   ? 'selected' : ''}>정상</option>
                        <option value="LOCKED"   ${searchVO.status eq 'LOCKED'   ? 'selected' : ''}>잠김</option>
                        <option value="INACTIVE" ${searchVO.status eq 'INACTIVE' ? 'selected' : ''}>중지</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold small">검색어</label>
                    <input type="text" name="searchKeyword" class="form-control form-control-sm"
                           placeholder="이름 또는 로그인 ID" value="${searchVO.searchKeyword}">
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-dark btn-sm px-4 w-100" style="height:31px;">
                        <i class="bi bi-search me-1"></i>검색
                    </button>
                </div>
            </form>
        </div>

        <%-- ── 목록 카드 ── --%>
        <div class="list-card">
            <div class="list-card-header d-flex align-items-center justify-content-between">
                <div class="title-block">
                    <i class="bi bi-table" style="color:#4361ee; font-size:1.1rem;"></i>
                    <span class="title-text">운영자 목록</span>
                    <span class="count-badge">총 ${paginationInfo.totalRecordCount}명</span>
                </div>
                <button type="button" class="btn btn-primary btn-sm px-3" 
                        style="border-radius:8px; font-weight:600;"
                        onclick="fn_openModal()">
                    <i class="bi bi-person-plus-fill me-1"></i>운영자 등록
                </button>
            </div>

            <div class="table-responsive">
                <table class="premium-data-table mb-0">
                    <thead>
                        <tr>
                            <th class="text-center" width="5%">NO</th>
                            <th width="14%">이름</th>
                            <th width="12%">로그인 ID</th>
                            <th class="text-center" width="12%">역할</th>
                            <th width="14%">담당 채널</th>
                            <th width="18%">이메일</th>
                            <th width="12%">연락처</th>
                            <th class="text-center" width="8%">상태</th>
                            <th class="text-center" width="8%">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty operatorList}">
                                <c:forEach var="op" items="${operatorList}" varStatus="status">
                                <tr>
                                    <td class="text-center text-muted small">
                                        ${paginationInfo.totalRecordCount - paginationInfo.firstRecordIndex - status.index}
                                    </td>
                                    <td class="fw-bold" style="color:#334155;">
                                        <a href="javascript:;" class="text-decoration-none text-primary fw-bold"
                                           onclick="fn_openModal('${op.userId}')">${fn:escapeXml(op.userName)}</a>
                                    </td>
                                    <td class="small text-muted">
                                        <a href="javascript:;" class="text-decoration-none text-muted"
                                           onclick="fn_openModal('${op.userId}')">${fn:escapeXml(op.loginId)}</a>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${op.userRole eq 'OPERATOR'}">
                                                <span style="background:#e0f2fe; color:#0369a1; padding:3px 10px; border-radius:20px; font-size:0.73rem; font-weight:700;">
                                                    운영자
                                                </span>
                                            </c:when>
                                            <c:when test="${op.userRole eq 'CHANNEL_ADMIN'}">
                                                <span style="background:#f0fdf4; color:#15803d; padding:3px 10px; border-radius:20px; font-size:0.73rem; font-weight:700;">
                                                    채널 운영자
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="background:#f1f5f9; color:#64748b; padding:3px 10px; border-radius:20px; font-size:0.73rem; font-weight:700;">
                                                    ${fn:escapeXml(op.userRole)}
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="small text-muted">
                                        <c:choose>
                                            <c:when test="${not empty op.channelName}">${fn:escapeXml(op.channelName)}</c:when>
                                            <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="small text-muted">${fn:escapeXml(op.email)}</td>
                                    <td class="small text-muted">${fn:escapeXml(op.mobile)}</td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${op.status eq 'ACTIVE'}">
                                                <span class="status-badge status-ACTIVE">
                                                    <span class="status-dot dot-ACTIVE"></span>정상
                                                </span>
                                            </c:when>
                                            <c:when test="${op.status eq 'LOCKED'}">
                                                <span class="status-badge status-LOCKED">
                                                    <span class="status-dot dot-LOCKED"></span>잠김
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-INACTIVE">
                                                    <span class="status-dot dot-INACTIVE"></span>중지
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                            <div class="action-btn-group">
                                                <button type="button" class="btn-action" title="수정"
                                                        data-user-id="${op.userId}"
                                                        onclick="fn_openModal(this.getAttribute('data-user-id'))">
                                                    <i class="bi bi-pencil-fill"></i>
                                                </button>
                                                <button type="button" class="btn-action danger" title="삭제" 
                                                        onclick="deleteOperator('${op.userId}', '${fn:escapeXml(op.userName)}')">
                                                    <i class="bi bi-trash-fill"></i>
                                                </button>
                                            </div>
                                    </td>
                                </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="9" class="text-center py-5 text-muted">
                                        <i class="bi bi-person-slash me-2" style="font-size:1.5rem;"></i>
                                        <br>등록된 운영자가 없습니다.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <%-- ── 페이지네이션 ── --%>
            <c:if test="${paginationInfo.totalRecordCount > 0}">
            <div class="d-flex justify-content-center py-3">
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <c:if test="${paginationInfo.currentPageNo > 1}">
                        <li class="page-item">
                            <a class="page-link" href="<c:url value='/admin/user/operatorList.do?pageIndex=${paginationInfo.currentPageNo - 1}&userRole=${searchVO.userRole}&status=${searchVO.status}&searchKeyword=${searchVO.searchKeyword}'/>">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                        </c:if>
                        <c:forEach begin="${paginationInfo.firstPageNoOnPageList}"
                                   end="${paginationInfo.lastPageNoOnPageList}" var="pageNo">
                        <li class="page-item ${paginationInfo.currentPageNo eq pageNo ? 'active' : ''}">
                            <a class="page-link" href="<c:url value='/admin/user/operatorList.do?pageIndex=${pageNo}&userRole=${searchVO.userRole}&status=${searchVO.status}&searchKeyword=${searchVO.searchKeyword}'/>">${pageNo}</a>
                        </li>
                        </c:forEach>
                        <c:if test="${paginationInfo.currentPageNo < paginationInfo.totalPageCount}">
                        <li class="page-item">
                            <a class="page-link" href="<c:url value='/admin/user/operatorList.do?pageIndex=${paginationInfo.currentPageNo + 1}&userRole=${searchVO.userRole}&status=${searchVO.status}&searchKeyword=${searchVO.searchKeyword}'/>">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                        </c:if>
                    </ul>
                </nav>
            </div>
            </c:if>
        </div>
    </div>
</div>


<script>
    function fn_openModal(userId) {
        const url = userId ? "<c:url value='/admin/user/operatorForm.do'/>?userId=" + userId + "&isModal=Y" 
                           : "<c:url value='/admin/user/operatorForm.do'/>?isModal=Y";
        const title = userId ? "운영자 정보 수정" : "신규 운영자 등록";
        fn_openAdminModal(url, title);
    }

    function deleteOperator(userId, userName) {
        if (!confirm('[' + userName + '] 운영자를 삭제(비활성화) 처리하시겠습니까?')) return;

        $.ajax({
            url: "<c:url value='/admin/user/updateStatus.ajax'/>",
            type: 'POST',
            data: { userId: userId, status: 'INACTIVE' },
            success: function(res) {
                if (res.success) {
                    fn_toast('운영자가 삭제(비활성) 처리되었습니다.', 'success');
                    setTimeout(() => location.reload(), 1000);
                } else {
                    alert('삭제 실패: ' + res.message);
                }
            },
            error: function() {
                alert('통신 에러가 발생했습니다.');
            }
        });
    }
</script>
