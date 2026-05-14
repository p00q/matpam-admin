<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:if test="${param.isModal != 'Y'}">
    <div class="px-4 pt-3 pb-1">
        <h4 class="fw-bold mb-0"><i class="bi bi-truck me-2"></i>채널 정보 관리</h4>
    </div>
</c:if>

<div class="px-4 py-3 ${param.isModal == 'Y' ? 'pt-4' : ''}">
    <form id="channelForm">
        <input type="hidden" name="channelId" value="${channel.channelId}">
        <input type="hidden" name="companyId" value="${channel.companyId}">

        <div class="premium-card mb-4 border-0 shadow-sm">
            <div class="card-header bg-white py-3 border-bottom">
                <h6 class="mb-0 fw-bold text-primary">
                    <span class="badge bg-primary-subtle text-primary me-2">01</span>채널 상세 정보
                </h6>
            </div>
            <div class="card-body p-4">
                <div class="mb-4">
                    <label class="form-label fw-bold text-dark">채널 유형 <span class="text-danger">*</span></label>
                    <select class="form-select bg-light" name="channelType" required id="formChannelType">
                        <option value="">유형 선택</option>
                        <option value="COURIER" ${channel.channelType eq 'COURIER' ? 'selected' : ''}>전국택배</option>
                        <option value="DIRECT" ${channel.channelType eq 'DIRECT' ? 'selected' : ''}>화물직배송</option>
                        <option value="COLLECT" ${channel.channelType eq 'COLLECT' ? 'selected' : ''}>공장수령</option>
                    </select>
                    <div class="form-text text-muted">운영업체별로 같은 채널 유형은 하나만 생성할 수 있습니다.</div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold text-dark">채널명 <span class="text-danger">*</span></label>
                    <input type="text" class="form-control bg-light" name="channelName" value="${channel.channelName}"
                           placeholder="예: 전국택배, 수도권 직배송, 공장수령" required>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold text-dark">담당자 지정 <span class="text-muted fw-normal">(선택)</span></label>
                    <select class="form-select bg-light" name="managerId">
                        <option value="">-- 담당자 없음 --</option>
                        <c:forEach var="mgr" items="${managerList}">
                            <option value="${mgr.userId}" ${channel.managerId eq mgr.userId ? 'selected' : ''}>${mgr.userName} (${mgr.loginId})</option>
                        </c:forEach>
                    </select>
                </div>

                <div>
                    <label class="form-label fw-bold text-dark">상태 <span class="text-danger">*</span></label>
                    <div class="d-flex gap-4">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="status" id="chActive" value="ACTIVE"
                                   ${empty channel.status or channel.status eq 'ACTIVE' ? 'checked' : ''}>
                            <label class="form-check-label" for="chActive">정상</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="status" id="chInactive" value="INACTIVE"
                                   ${channel.status eq 'INACTIVE' ? 'checked' : ''}>
                            <label class="form-check-label" for="chInactive">중지</label>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-center gap-3 mb-4">
            <button type="button" id="btnSaveChannel" class="btn btn-primary px-5 py-2 shadow"
                    style="border-radius:12px; font-weight:700;">
                <i class="bi bi-check2-circle me-1"></i>
                ${empty channel.channelId ? '채널 등록하기' : '수정 내용 저장'}
            </button>
        </div>
    </form>
</div>

<script>
    setTimeout(function() {
        const existingTypes = "${existingTypes}".split(",").filter(function(value) { return value !== ""; });
        const typeSelect = document.getElementById("formChannelType");
        const currentType = "${channel.channelType}";

        if (!typeSelect) return;
        Array.from(typeSelect.options).forEach(function(option) {
            if (option.value !== "" && option.value !== currentType && existingTypes.includes(option.value)) {
                option.disabled = true;
                option.text += " (이미 존재)";
            }
        });
    }, 100);
</script>
