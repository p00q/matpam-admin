<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="container-fluid px-0">
    <div class="px-4 py-3">
        <div class="card border-0 shadow-sm" style="border-radius:16px;">
            <div class="card-header bg-white py-3 border-bottom border-light">
                <h6 class="mb-0 fw-bold text-primary"><i class="bi bi-diagram-3-fill me-2"></i>채널 정보 설정</h6>
            </div>
            <div class="card-body p-4">
                <form id="channelDataForm">
                    <input type="hidden" name="channelId" value="${channelVO.channelId}" />

                    <div class="row g-4">
                        <!-- 기본 정보 -->
                        <div class="col-md-12">
                            <h5 class="fw-bold small text-muted mb-3"><i class="bi bi-info-circle me-1"></i> 기본 정보</h5>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-muted">채널 명칭 <span class="text-danger">*</span></label>
                            <input type="text" name="channelName" class="form-control" value="${channelVO.channelName}" required placeholder="예: 맛팜 스마트스토어" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-muted">플랫폼 선택 (채널유형) <span class="text-danger">*</span></label>
                            <select name="platformId" class="form-select" required>
                                <option value="">플랫폼을 선택하세요</option>
                                <c:forEach var="p" items="${platformList}">
                                    <option value="${p.platformId}" <c:if test="${p.platformId == channelVO.platformId}">selected</c:if>>${p.platformName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-muted">관리 업체 <span class="text-danger">*</span></label>
                            <select name="companyId" class="form-select" required>
                                <option value="">-- 업체 선택 --</option>
                                <c:forEach var="c" items="${companyList}">
                                    <option value="${c.companyId}" <c:if test="${c.companyId == channelVO.companyId}">selected</c:if>>${c.companyName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-muted">운영 상태 <span class="text-danger">*</span></label>
                            <select name="status" class="form-select">
                                <option value="ACTIVE" <c:if test="${channelVO.status == 'ACTIVE'}">selected</c:if>>정상 운영</option>
                                <option value="INACTIVE" <c:if test="${channelVO.status == 'INACTIVE'}">selected</c:if>>운영 중지</option>
                            </select>
                        </div>

                        <!-- API 설정 -->
                        <div class="col-md-12 mt-5">
                            <h5 class="fw-bold small text-muted mb-3"><i class="bi bi-key me-1"></i> API 및 연동 설정</h5>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label fw-bold small text-muted">Shop ID (또는 스토어 ID)</label>
                            <input type="text" name="shopId" class="form-control" value="${channelVO.shopId}" placeholder="플랫폼에서 발급받은 Shop ID" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-muted">API Key / Client ID</label>
                            <input type="text" name="apiKey" class="form-control" value="${channelVO.apiKey}" placeholder="API 액세스 키" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-muted">API Secret / Client Secret</label>
                            <input type="password" name="apiSecret" class="form-control" value="${channelVO.apiSecret}" placeholder="API 시크릿 키" />
                        </div>
                    </div>

                    <div class="mt-5 d-flex justify-content-between border-top pt-4">
                        <div>
                            <c:if test="${not empty channelVO.channelId}">
                                <button type="button" class="btn btn-outline-danger px-4" style="border-radius:10px;" onclick="fn_deleteChannel()"><i class="bi bi-trash me-1"></i> 삭제</button>
                            </c:if>
                        </div>
                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-light px-4" style="border-radius:10px;" onclick="history.back()">취소</button>
                            <button type="button" class="btn btn-primary px-5" style="border-radius:10px; font-weight:600;" onclick="fn_saveChannel()">저장하기</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function fn_saveChannel() {
        if (!$('input[name=channelName]').val()) { alert('채널 명칭을 입력하세요.'); return; }
        if (!$('select[name=platformId]').val()) { alert('플랫폼을 선택하세요.'); return; }
        if (!$('select[name=companyId]').val()) { alert('관리 업체를 선택하세요.'); return; }

        if(!confirm('채널 정보를 저장하시겠습니까?')) return;

        $.ajax({
            url: '<c:url value="/admin/sysChannel/saveChannel.ajax"/>',
            type: 'POST',
            data: $('#channelDataForm').serialize(),
            success: function(res) {
                if (res.status === 'SUCCESS') {
                    alert('저장되었습니다.');
                    location.href = '<c:url value="/admin/sysChannel/channelList.do"/>';
                } else {
                    alert('저장 실패: ' + res.message);
                }
            },
            error: function(xhr) {
                alert('서버 통신 오류가 발생했습니다. (Status: ' + xhr.status + ')');
            }
        });
    }

    function fn_deleteChannel() {
        if (!confirm('정말 삭제하시겠습니까?')) return;
        $.ajax({
            url: '<c:url value="/admin/channel/deleteChannel.ajax"/>',
            type: 'POST',
            data: { channelId: '${channelVO.channelId}' },
            success: function(res) {
                if (res.status === 'SUCCESS') {
                    alert('삭제되었습니다.');
                    location.href = '<c:url value="/admin/channel/channelList.do"/>';
                } else {
                    alert('삭제 실패: ' + res.message);
                }
            }
        });
    }
</script>
