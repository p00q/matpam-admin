<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.matpam.common.util.MatpamContextHolder" %>
<%
    // [EMERGENCY-FIX] 빌드 시스템 오류로 인한 테넌트 유실 방지
    MatpamContextHolder.setCurrentTenantId(1L);
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<div class="container-fluid px-0">
    <!-- Header Area -->
    <div class="d-flex justify-content-between align-items-center mb-4 px-4 pt-3">
        <div>
            <h4 class="fw-bold mb-1 text-dark">채널 관리</h4>
            <p class="text-muted small mb-0">연동된 판매 채널(스마트스토어, 쿠팡 등)을 관리합니다.</p>
        </div>
        <a href="<c:url value='/admin/sysChannel/channelForm.do'/>" class="btn btn-primary px-4 shadow-sm" style="border-radius:12px; font-weight:600;">
            <i class="bi bi-plus-lg me-2"></i>신규 채널 등록
        </a>
    </div>

    <!-- Search Area -->
    <div class="px-4 mb-4">
        <div class="card border-0 shadow-sm" style="border-radius:16px;">
            <div class="card-body p-3">
                <form id="searchForm" action="<c:url value='/admin/sysChannel/channelList.do'/>" method="get" class="row g-3 align-items-center">
                    <div class="col-md-4">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0 text-muted"><i class="bi bi-search"></i></span>
                            <input type="text" name="searchKeyword" class="form-control border-start-0 ps-0" placeholder="채널명으로 검색하세요" value="${searchVO.searchKeyword}">
                        </div>
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn btn-dark px-4" style="border-radius:10px;">조회</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- List Area -->
    <div class="px-4">
        <div class="card border-0 shadow-sm" style="border-radius:16px; overflow:hidden;">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light">
                        <tr>
                            <th class="ps-4 text-muted small fw-bold py-3" style="width: 80px;">ID</th>
                            <th class="text-muted small fw-bold py-3">채널명</th>
                            <th class="text-muted small fw-bold py-3">플랫폼</th>
                            <th class="text-muted small fw-bold py-3">관리업체</th>
                            <th class="text-muted small fw-bold py-3">Shop ID</th>
                            <th class="text-muted small fw-bold py-3">상태</th>
                            <th class="text-muted small fw-bold py-3">등록일</th>
                            <th class="text-center pe-4 text-muted small fw-bold py-3" style="width: 120px;">관리</th>
                        </tr>
                    </thead>
                    <tbody class="border-top-0">
                        <c:forEach var="item" items="${resultList}">
                            <tr>
                                <td class="ps-4 text-muted small">${item.channelId}</td>
                                <td>
                                    <div class="fw-bold text-dark">${item.channelName}</div>
                                </td>
                                <td>
                                    <span class="badge rounded-pill bg-light text-dark border px-3">${item.platformName}</span>
                                </td>
                                <td class="small text-muted">${item.companyName}</td>
                                <td><code class="text-primary small">${item.shopId}</code></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.status eq 'ACTIVE'}">
                                            <span class="badge bg-success-subtle text-success px-3 border border-success-subtle">운영중</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary-subtle text-secondary px-3 border border-secondary-subtle">정지</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="small text-muted">${item.createdAt}</td>
                                <td class="text-center pe-4">
                                    <div class="d-flex gap-2 justify-content-center">
                                        <a href="<c:url value='/admin/sysChannel/channelForm.do?channelId=${item.channelId}'/>" class="btn btn-sm btn-outline-primary border-0" title="수정" style="border-radius:8px; width:32px; height:32px; padding:0; display:flex; align-items:center; justify-content:center;">
                                            <i class="bi bi-pencil-square"></i>
                                        </a>
                                        <button type="button" class="btn btn-sm btn-outline-danger border-0" title="삭제" style="border-radius:8px; width:32px; height:32px; padding:0; display:flex; align-items:center; justify-content:center;" onclick="if(confirm('정말 삭제하시겠습니까?')) { deleteChannel('${item.channelId}'); }">
                                            <i class="bi bi-trash3"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty resultList}">
                            <tr>
                                <td colspan="8" class="text-center py-5">
                                    <i class="bi bi-inbox fs-1 text-muted d-block mb-2"></i>
                                    <span class="text-muted">등록된 채널 정보가 없습니다.</span>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            
            <!-- Pagination Area -->
            <div class="card-footer bg-white py-3 border-0">
                <div class="d-flex justify-content-center">
                    <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_link_page" />
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function fn_link_page(pageNo) {
        location.href = "<c:url value='/admin/sysChannel/channelList.do'/>?pageIndex=" + pageNo + "&searchKeyword=${searchVO.searchKeyword}";
    }

    function deleteChannel(channelId) {
        $.ajax({
            type: "POST",
            url: "<c:url value='/admin/sysChannel/deleteChannel.ajax'/>",
            data: { channelId: channelId },
            success: function(res) {
                if (res.status === 'SUCCESS') {
                    alert('채널이 삭제되었습니다.');
                    location.reload();
                } else {
                    alert('삭제에 실패했습니다: ' + res.message);
                }
            },
            error: function() {
                alert('채널 삭제 중 오류가 발생했습니다.');
            }
        });
    }
</script>
