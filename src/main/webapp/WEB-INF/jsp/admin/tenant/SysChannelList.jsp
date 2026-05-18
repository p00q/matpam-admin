<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<div class="container-fluid px-0">
    <div class="px-4 pt-3 pb-1">
        <div class="d-flex align-items-center justify-content-between mb-1">
            <h4 class="fw-bold mb-0" style="color:#1e293b;"><i class="bi bi-truck me-2"></i>채널 관리</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0" style="font-size:.78rem;">
                    <li class="breadcrumb-item text-muted">운영관리</li>
                    <li class="breadcrumb-item active text-muted">채널관리</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="px-4 py-3">
        <div class="search-panel">
            <div class="panel-title">
                <i class="bi bi-funnel-fill"></i> 검색 조건
            </div>
            <form id="searchForm" action="<c:url value='/admin/sysChannel/channelList.do'/>" method="get" class="row g-2 align-items-end">
                <input type="hidden" name="companyId" value="${searchVO.companyId}">
                <div class="col-md-2">
                    <label class="form-label fw-semibold small">채널 유형</label>
                    <select name="channelType" class="form-select form-select-sm">
                        <option value="">-- 전체 --</option>
                        <option value="COURIER" ${searchVO.channelType eq 'COURIER' ? 'selected' : ''}>전국택배</option>
                        <option value="DIRECT" ${searchVO.channelType eq 'DIRECT' ? 'selected' : ''}>화물직배송</option>
                        <option value="COLLECT" ${searchVO.channelType eq 'COLLECT' ? 'selected' : ''}>공장수령</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold small">상태</label>
                    <select name="status" class="form-select form-select-sm">
                        <option value="">-- 전체 --</option>
                        <option value="ACTIVE" ${searchVO.status eq 'ACTIVE' ? 'selected' : ''}>정상</option>
                        <option value="INACTIVE" ${searchVO.status eq 'INACTIVE' ? 'selected' : ''}>중지</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold small">검색어</label>
                    <input type="text" name="searchKeyword" class="form-control form-control-sm"
                           placeholder="채널명 검색" value="${searchVO.searchKeyword}">
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-dark btn-sm px-4 w-100" style="height:31px;">
                        <i class="bi bi-search me-1"></i>검색
                    </button>
                </div>
            </form>
        </div>

        <div class="list-card">
            <div class="list-card-header d-flex align-items-center justify-content-between">
                <div class="title-block">
                    <i class="bi bi-table" style="color:#4361ee; font-size:1.1rem;"></i>
                    <span class="title-text">채널 목록</span>
                    <span class="count-badge">총 ${paginationInfo.totalRecordCount}건</span>
                </div>
                <c:if test="${sessionScope.loginVO.memberType ne 'CHANNEL_ADMIN'}">
                    <button class="btn btn-primary btn-sm px-3" style="border-radius:8px; font-weight:600;" onclick="openChannelModal()">
                        <i class="bi bi-plus-lg me-1"></i>신규 채널 등록
                    </button>
                </c:if>
            </div>

            <div class="table-responsive">
                <table class="premium-data-table mb-0">
                    <thead>
                        <tr>
                            <th class="text-center" width="8%">NO</th>
                            <c:if test="${sessionScope.loginVO.memberType eq 'SUPER_ADMIN' or sessionScope.loginVO.memberType eq 'SUPER' or sessionScope.loginVO.roleCd eq 'SUPER'}">
                                <th width="15%">운영업체명</th>
                            </c:if>
                            <th class="text-center" width="15%">채널 유형</th>
                            <th width="25%">채널명</th>
                            <th width="20%">담당자</th>
                            <th class="text-center" width="12%">상태</th>
                            <th width="100px" class="text-center">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${resultList}" varStatus="status">
                            <tr>
                                <td class="text-center" style="color:#94a3b8; font-size:.75rem;">
                                    ${paginationInfo.totalRecordCount - ((searchVO.pageIndex - 1) * searchVO.pageUnit) - status.index}
                                </td>
                                <c:if test="${sessionScope.loginVO.memberType eq 'SUPER_ADMIN' or sessionScope.loginVO.memberType eq 'SUPER' or sessionScope.loginVO.roleCd eq 'SUPER'}">
                                    <td class="fw-bold" style="color:#1e293b;">${item.companyName}</td>
                                </c:if>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${item.channelType eq 'COURIER'}"><span class="badge bg-light text-dark border">전국택배</span></c:when>
                                        <c:when test="${item.channelType eq 'DIRECT'}"><span class="badge bg-light text-dark border">화물직배송</span></c:when>
                                        <c:when test="${item.channelType eq 'COLLECT'}"><span class="badge bg-light text-dark border">공장수령</span></c:when>
                                        <c:otherwise><span class="badge bg-light text-dark border">${item.channelType}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="fw-bold" style="color:#1e293b;">
                                    <a href="javascript:;" class="text-decoration-none text-primary fw-bold"
                                       onclick="editChannel('${item.channelId}')">${item.channelName}</a>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty item.managerName}">
                                            <div class="d-flex align-items-center">
                                                <i class="bi bi-person-circle text-muted me-2"></i>
                                                <div style="font-weight:600; color:#334155;">
                                                    <a href="javascript:;" class="text-decoration-none text-reset"
                                                       onclick="editChannel('${item.channelId}')">${item.managerName}</a>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted small">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${item.status eq 'ACTIVE'}">
                                                    <span class="status-badge status-ACTIVE">
                                                        <span class="status-dot dot-ACTIVE"></span>정상
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
                                        <button type="button" class="btn-action" title="수정" onclick="editChannel('${item.channelId}')">
                                            <i class="bi bi-pencil-fill"></i>
                                        </button>
                                        <c:if test="${sessionScope.loginVO.memberType ne 'CHANNEL_ADMIN'}">
                                            <button type="button" class="btn-action danger" title="삭제" onclick="deleteChannel('${item.channelId}')">
                                                <i class="bi bi-trash-fill"></i>
                                            </button>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty resultList}">
                            <tr>
                                <td colspan="${(sessionScope.loginVO.memberType eq 'SUPER_ADMIN' or sessionScope.loginVO.memberType eq 'SUPER' or sessionScope.loginVO.roleCd eq 'SUPER') ? 7 : 6}">
                                    <div class="empty-state">
                                        <div class="empty-text fw-semibold">등록된 채널이 없습니다.</div>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <div class="pagination-wrap">
                <div class="pagination-info">
                    총 <strong class="text-primary">${paginationInfo.totalRecordCount}</strong>건의 채널이 등록되어 있습니다.
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
        const form = document.getElementById("searchForm");
        form.action = "<c:url value='/admin/sysChannel/channelList.do'/>";
        let input = form.querySelector("input[name='pageIndex']");
        if (!input) {
            input = document.createElement("input");
            input.type = "hidden";
            input.name = "pageIndex";
            form.appendChild(input);
        }
        input.value = pageNo;
        form.submit();
    }

    function openChannelModal() {
        const companyId = "${searchVO.companyId}";
        const url = "<c:url value='/admin/sysChannel/channelForm.do'/>?isModal=Y" + (companyId ? "&companyId=" + companyId : "");
        fn_openAdminModal(url, "신규 채널 등록");
    }

    function editChannel(id) {
        const url = "<c:url value='/admin/sysChannel/channelForm.do'/>?channelId=" + id + "&isModal=Y";
        fn_openAdminModal(url, "채널 정보 수정");
    }

    $(document).on("click", "#btnSaveChannel", function() {
        const $modal = $("#adminCommonModalBody");
        const type = $modal.find("select[name='channelType']").val();
        const name = $modal.find("input[name='channelName']").val().trim();

        if (!type) { alert("채널 유형을 선택하세요."); return; }
        if (!name) { alert("채널명을 입력하세요."); return; }

        const formData = $modal.find("#channelForm").serialize();
        $.post("<c:url value='/admin/sysChannel/saveChannel.ajax'/>", formData, function(res) {
            if (res.status === "SUCCESS") {
                fn_onSaveSuccess();
            } else {
                alert(res.message || "저장 중 오류가 발생했습니다.");
            }
        }).fail(function() {
            alert("서버 통신 오류가 발생했습니다.");
        });
    });

    fn_onSaveSuccess = function() {
        const modalEl = document.getElementById("adminCommonModal");
        const modal = bootstrap.Modal.getInstance(modalEl);
        if (modal) {
            $(modalEl).one("hidden.bs.modal", function() {
                fn_toast("채널 정보가 저장되었습니다.", "success");
                setTimeout(function() { location.reload(); }, 1000);
            });
            modal.hide();
        } else {
            fn_toast("채널 정보가 저장되었습니다.", "success");
            setTimeout(function() { location.reload(); }, 1000);
        }
    };

    function deleteChannel(id) {
        if (!confirm("해당 채널을 중지 처리하시겠습니까?")) return;

        $.ajax({
            url: "<c:url value='/admin/sysChannel/deleteChannel.ajax'/>",
            type: "POST",
            data: { channelId: id },
            success: function(res) {
                if (res.status === "SUCCESS") {
                    fn_toast("채널이 중지 처리되었습니다.", "success");
                    setTimeout(function() { location.reload(); }, 1000);
                } else {
                    fn_toast("처리 실패: " + res.message, "danger");
                }
            },
            error: function() {
                fn_toast("통신 오류가 발생했습니다.", "danger");
            }
        });
    }
</script>
