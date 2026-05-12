<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:if test="${param.isModal != 'Y'}">
    <div class="px-4 pt-3 pb-1">
        <h4 class="fw-bold mb-0"><i class="bi bi-truck me-2"></i>채널 정보 관리</h4>
    </div>
</c:if>

<div class="px-4 py-3 ${param.isModal == 'Y' ? 'pt-4' : ''}">
    <form id="channelForm">
        <input type="hidden" name="channelId" value="${channel.channelId}">
        <input type="hidden" name="companyId" value="${channel.companyId}">

        <!-- ── 섹션 01 : 채널 정보 ── -->
        <div class="premium-card mb-4 border-0 shadow-sm">
            <div class="card-header bg-white py-3 border-bottom">
                <h6 class="mb-0 fw-bold text-primary"><span class="badge bg-primary-subtle text-primary me-2">01</span> 채널 상세 정보</h6>
            </div>
            <div class="card-body p-4">
                <div class="mb-4">
                    <label class="form-label fw-bold text-dark">채널 유형 <span class="text-danger">*</span></label>
                    <select class="form-select bg-light" name="channelType" required id="formChannelType">
                        <option value="">유형 선택</option>
                        <option value="COURIER" ${channel.channelType eq 'COURIER' ? 'selected' : ''}>전국택배</option>
                        <option value="DIRECT"  ${channel.channelType eq 'DIRECT'  ? 'selected' : ''}>화물직송</option>
                        <option value="COLLECT" ${channel.channelType eq 'COLLECT' ? 'selected' : ''}>공장수령</option>
                    </select>
                    <div class="form-text text-muted">하나의 업체에 유형별로 하나의 채널만 생성 가능합니다.</div>
                </div>
                
                <div class="mb-4">
                    <label class="form-label fw-bold text-dark">채널명 <span class="text-danger">*</span></label>
                    <input type="text" class="form-control bg-light" name="channelName" value="${channel.channelName}" 
                           placeholder="예: 로젠택배, 용달, 공장직접수령" required>
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
                            <input class="form-check-input" type="radio" name="status" id="chActive" value="ACTIVE" ${channel.status eq 'ACTIVE' ? 'checked' : ''}>
                            <label class="form-check-label" for="chActive">정상</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="status" id="chInactive" value="INACTIVE" ${channel.status ne 'ACTIVE' ? 'checked' : ''}>
                            <label class="form-check-label" for="chInactive">중지</label>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-center gap-3 mb-4">
            <button type="button" id="btnSaveChannel" class="btn btn-primary px-5 py-2 shadow" style="border-radius:12px; font-weight:700;">
                <i class="bi bi-check2-circle me-1"></i> ${empty channel.channelId ? '채널 등록하기' : '수정 내용 저장'}
            </button>
        </div>
    </form>
</div>

<script>
    // 모달 로드 시 $.globalEval로 실행되므로 setTimeout으로 DOM 렌더 완료 후 실행
    setTimeout(function() {
        const existingTypes = "${existingTypes}".split(",").filter(function(v){ return v !== ""; });
        const typeSelect = document.getElementById('formChannelType');
        const currentType = "${channel.channelType}";

        if (!typeSelect) return; // null 가드

        Array.from(typeSelect.options).forEach(function(opt) {
            if (opt.value !== "" && opt.value !== currentType) {
                if (existingTypes.includes(opt.value)) {
                    opt.disabled = true;
                    opt.text += " (이미 존재)";
                }
            }
        });
    }, 100);
</script>
