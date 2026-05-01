<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <title>채널 설정 | 맛팜 B2B</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" rel="stylesheet" />
    <style>
        .page-header { margin-bottom: 2rem; border-bottom: 1px solid #eee; padding-bottom: 1rem; }
        .card { border-radius: 15px; border: none; box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075); }
        .form-label { font-weight: 600; color: #555; }
        .form-control:focus { box-shadow: none; border-color: #764ba2; }
    </style>
</head>
<body class="bg-light p-4">
    <div class="container" style="max-width: 800px;">
        <div class="page-header">
            <h2 class="fw-bold mb-0">
                <c:choose>
                    <c:when test="${not empty channelVO.channelId}">채널 정보 수정</c:when>
                    <c:otherwise>신규 채널 등록</c:otherwise>
                </c:choose>
            </h2>
        </div>

        <div class="card">
            <div class="card-body p-4">
                <form id="dataForm">
                    <input type="hidden" name="channelId" value="${channelVO.channelId}" />

                    <div class="row g-4">
                        <!-- 기본 정보 -->
                        <div class="col-md-12">
                            <h5 class="text-primary mb-3"><i class="fas fa-info-circle me-1"></i> 기본 정보</h5>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">채널 명칭</label>
                            <input type="text" name="channelName" class="form-control" value="${channelVO.channelName}" required placeholder="예: 맛팜 스마트스토어" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">플랫폼 선택</label>
                            <select name="platformId" class="form-select" required>
                                <option value="">플랫폼을 선택하세요</option>
                                <c:forEach var="p" items="${platformList}">
                                    <option value="${p.platformId}" <c:if test="${p.platformId == channelVO.platformId}">selected</c:if>>${p.platformName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">관리 업체</label>
                            <select name="companyId" class="form-select" required>
                                <c:forEach var="c" items="${companyList}">
                                    <option value="${c.companyId}" <c:if test="${c.companyId == channelVO.companyId}">selected</c:if>>${c.companyName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">운영 상태</label>
                            <select name="status" class="form-select">
                                <option value="ACTIVE" <c:if test="${channelVO.status == 'ACTIVE'}">selected</c:if>>정상 운영</option>
                                <option value="INACTIVE" <c:if test="${channelVO.status == 'INACTIVE'}">selected</c:if>>운영 중지</option>
                            </select>
                        </div>

                        <!-- API 설정 -->
                        <div class="col-md-12 mt-5">
                            <h5 class="text-primary mb-3"><i class="fas fa-key me-1"></i> API 및 연동 설정</h5>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">Shop ID (또는 스토어 ID)</label>
                            <input type="text" name="shopId" class="form-control" value="${channelVO.shopId}" placeholder="플랫폼에서 발급받은 Shop ID" />
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">API Key / Client ID</label>
                            <input type="text" name="apiKey" class="form-control" value="${channelVO.apiKey}" placeholder="API 액세스 키" />
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">API Secret / Client Secret</label>
                            <input type="password" name="apiSecret" class="form-control" value="${channelVO.apiSecret}" placeholder="API 시크릿 키" />
                        </div>
                    </div>

                    <div class="mt-5 d-flex justify-content-between">
                        <div>
                            <c:if test="${not empty channelVO.channelId}">
                                <button type="button" class="btn btn-outline-danger px-4" onclick="fn_delete()"><i class="fas fa-trash-alt me-1"></i> 삭제</button>
                            </c:if>
                        </div>
                        <div>
                            <button type="button" class="btn btn-light px-4 me-2" onclick="history.back()">취소</button>
                            <button type="button" class="btn btn-primary px-5" onclick="fn_save()">저장하기</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function fn_save() {
            if (!$('input[name=channelName]').val()) { alert('채널 명칭을 입력하세요.'); return; }
            if (!$('select[name=platformId]').val()) { alert('플랫폼을 선택하세요.'); return; }

            $.ajax({
                url: 'saveChannel.ajax',
                type: 'POST',
                data: $('#dataForm').serialize(),
                success: function(res) {
                    if (res.status === 'SUCCESS') {
                        alert('저장되었습니다.');
                        location.href = 'channelList.do';
                    } else {
                        alert('저장 실패: ' + res.message);
                    }
                }
            });
        }

        function fn_delete() {
            if (!confirm('정말 삭제하시겠습니까?')) return;
            $.ajax({
                url: 'deleteChannel.ajax',
                type: 'POST',
                data: { channelId: '${channelVO.channelId}' },
                success: function(res) {
                    if (res.status === 'SUCCESS') {
                        alert('삭제되었습니다.');
                        location.href = 'channelList.do';
                    } else {
                        alert('삭제 실패: ' + res.message);
                    }
                }
            });
        }
    </script>
</body>
</html>
