<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <title>채널 관리 | 맛팜 B2B</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        .page-header { margin-bottom: 2rem; border-bottom: 1px solid #eee; padding-bottom: 1rem; }
        .card { border-radius: 15px; border: none; box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075); }
        .table thead th { background-color: #f8f9fa; border-top: none; }
        .badge-active { background-color: #e8f5e9; color: #2e7d32; }
        .badge-inactive { background-color: #ffebee; color: #c62828; }
        
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
    </style>
</head>
<body class="bg-light p-4">
    <div class="container-fluid">
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h2 class="fw-bold mb-0"><i class="fas fa-network-wired me-2"></i>채널 관리</h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item">시스템 설정</li>
                        <li class="breadcrumb-item active">채널 관리</li>
                    </ol>
                </nav>
            </div>
            <a href="channelForm.do" class="btn btn-primary px-4"><i class="fas fa-plus me-1"></i> 신규 채널 등록</a>
        </div>

        <!-- 검색 영역 -->
        <div class="card mb-4">
            <div class="card-body">
                <form id="searchForm" action="channelList.do" method="get" class="row g-3 align-items-center">
                    <div class="col-auto">
                        <input type="text" name="searchKeyword" class="form-control" placeholder="채널명 검색" value="${searchVO.searchKeyword}">
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn btn-secondary px-4">검색</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- 목록 영역 -->
        <div class="card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0 align-middle">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">ID</th>
                                <th>채널명</th>
                                <th>플랫폼</th>
                                <th>관리업체</th>
                                <th>Shop ID</th>
                                <th>상태</th>
                                <th>등록일</th>
                                <th class="text-center pe-4">관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${resultList}">
                                <tr>
                                    <td class="ps-4">${item.channelId}</td>
                                    <td class="fw-bold">${item.channelName}</td>
                                    <td><span class="badge bg-light text-dark border">${item.platformName}</span></td>
                                    <td>${item.companyName}</td>
                                    <td><code>${item.shopId}</code></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.status eq 'ACTIVE'}">
                                                <span class="badge badge-active px-3">운영중</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-inactive px-3">정지</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${item.createdAt}</td>
                                    <td class="text-center pe-4">
                                        <div class="action-btn-group">
                                            <a href="channelForm.do?channelId=${item.channelId}" class="btn-action" title="수정">
                                                <i class="bi bi-pencil-fill"></i>
                                            </a>
                                            <button type="button" class="btn-action danger" title="삭제" onclick="if(confirm('정말 삭제하시겠습니까?')) { deleteChannel('${item.channelId}'); }">
                                                <i class="bi bi-trash-fill"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty resultList}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">등록된 채널이 없습니다.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- 페이징 -->
        <div class="mt-4 d-flex justify-content-center">
            <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_link_page" />
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function fn_link_page(pageNo) {
            location.href = "channelList.do?pageIndex=" + pageNo + "&searchKeyword=${searchVO.searchKeyword}";
        }

        function deleteChannel(channelId) {
            $.ajax({
                type: "POST",
                url: "channelDelete.do",
                data: { channelId: channelId },
                dataType: "json",
                success: function(data) {
                    if (data.result === 'SUCCESS') {
                        alert('채널이 삭제되었습니다.');
                        location.href = 'channelList.do';
                    } else {
                        alert('삭제에 실패했습니다: ' + data.message);
                    }
                },
                error: function() {
                    alert('채널 삭제 중 오류가 발생했습니다.');
                }
            });
        }
    </script>
</body>
</html>
