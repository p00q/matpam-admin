<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="px-4 py-3 pt-4">
    <input type="hidden" name="channelId" value="${channel.channelId}">

    <!-- 채널 정보 요약 -->
    <div class="d-flex align-items-center gap-3 mb-4 p-3" style="background:linear-gradient(135deg,#f8fafc,#f1f5f9); border-radius:12px; border:1px solid #e2e8f0;">
        <div style="width:42px; height:42px; border-radius:10px; background:linear-gradient(135deg,#4361ee,#7c3aed); display:flex; align-items:center; justify-content:center;">
            <i class="bi bi-truck text-white" style="font-size:1.1rem;"></i>
        </div>
        <div>
            <div class="fw-bold text-dark" style="font-size:.95rem;">${channel.channelName}</div>
            <div class="text-muted" style="font-size:.78rem;">
                <c:choose>
                    <c:when test="${channel.channelType eq 'COURIER'}">전국택배</c:when>
                    <c:when test="${channel.channelType eq 'DIRECT'}">화물직배송</c:when>
                    <c:when test="${channel.channelType eq 'COLLECT'}">공장수령</c:when>
                    <c:otherwise>${channel.channelType}</c:otherwise>
                </c:choose>
                · 채널ID: ${channel.channelId}
            </div>
        </div>
    </div>

    <!-- 현재 담당자 표시 -->
    <div class="premium-card mb-4 border-0 shadow-sm">
        <div class="card-header bg-white py-3 border-bottom">
            <h6 class="mb-0 fw-bold text-primary">
                <span class="badge bg-primary-subtle text-primary me-2">01</span>현재 담당자
            </h6>
        </div>
        <div class="card-body p-4">
            <c:choose>
                <c:when test="${not empty currentManager}">
                    <div class="d-flex align-items-center justify-content-between p-3" style="background:#f0fdf4; border-radius:10px; border:1px solid #bbf7d0;">
                        <div class="d-flex align-items-center gap-3">
                            <div style="width:40px; height:40px; border-radius:50%; background:#22c55e; display:flex; align-items:center; justify-content:center;">
                                <i class="bi bi-person-fill text-white" style="font-size:1.1rem;"></i>
                            </div>
                            <div>
                                <div class="fw-bold" style="color:#166534;">${currentManager.userName}</div>
                                <div style="font-size:.78rem; color:#64748b;">${currentManager.loginId} · ${currentManager.mobile} · ${currentManager.email}</div>
                            </div>
                        </div>
                        <button type="button" id="btnRemoveManager" class="btn btn-outline-danger btn-sm px-3" style="border-radius:8px; font-weight:600;">
                            <i class="bi bi-person-x me-1"></i>해제
                        </button>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-3" style="color:#94a3b8;">
                        <i class="bi bi-person-slash" style="font-size:2rem; display:block; margin-bottom:.5rem;"></i>
                        <div class="fw-semibold">지정된 담당자가 없습니다.</div>
                        <div class="small">아래에서 기존 계정을 선택하거나 신규 담당자를 등록하세요.</div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- 담당자 지정 방식 선택 -->
    <div class="premium-card mb-4 border-0 shadow-sm">
        <div class="card-header bg-white py-3 border-bottom">
            <h6 class="mb-0 fw-bold text-primary">
                <span class="badge bg-primary-subtle text-primary me-2">02</span>담당자 지정
            </h6>
        </div>
        <div class="card-body p-4">
            <!-- 방식 선택 탭 -->
            <div class="d-flex gap-2 mb-4">
                <label class="flex-fill">
                    <input type="radio" name="assignMode" value="existing" class="btn-check" id="modeExisting" checked>
                    <div class="btn btn-outline-dark w-100 py-2" style="border-radius:10px; font-weight:600; font-size:.85rem;" onclick="toggleAssignMode('existing')">
                        <i class="bi bi-person-check me-1"></i>기존 계정 선택
                    </div>
                </label>
                <label class="flex-fill">
                    <input type="radio" name="assignMode" value="new" class="btn-check" id="modeNew">
                    <div class="btn btn-outline-dark w-100 py-2" style="border-radius:10px; font-weight:600; font-size:.85rem;" onclick="toggleAssignMode('new')">
                        <i class="bi bi-person-plus me-1"></i>신규 계정 생성
                    </div>
                </label>
            </div>

            <!-- 기존 계정 선택 영역 -->
            <div id="existingSection">
                <c:choose>
                    <c:when test="${not empty candidates}">
                        <label class="form-label fw-bold text-dark">채널 담당자 후보 <span class="text-muted fw-normal small">(CHANNEL_ADMIN 역할, 미배정 계정)</span></label>
                        <select class="form-select bg-light" name="existingUserId">
                            <option value="">-- 담당자 선택 --</option>
                            <c:forEach var="cand" items="${candidates}">
                                <option value="${cand.userId}" ${channel.managerId eq cand.userId ? 'selected' : ''}>${cand.userName} (${cand.loginId})</option>
                            </c:forEach>
                        </select>
                        <div class="form-text text-muted mt-1">다른 채널에 배정되지 않은 CHANNEL_ADMIN 계정만 표시됩니다.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-3" style="background:#fef3c7; border-radius:8px; border:1px solid #fde68a;">
                            <i class="bi bi-exclamation-triangle-fill text-warning"></i>
                            <span class="fw-semibold text-dark small"> 지정 가능한 CHANNEL_ADMIN 계정이 없습니다. 신규 계정을 생성해 주세요.</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 신규 계정 생성 영역 -->
            <div id="newSection" style="display:none;">
                <div class="mb-3">
                    <label class="form-label fw-bold text-dark">로그인 ID <span class="text-danger">*</span></label>
                    <input type="text" class="form-control bg-light" name="newLoginId" placeholder="예: ch_courier_admin" autocomplete="off">
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold text-dark">담당자 이름 <span class="text-danger">*</span></label>
                    <input type="text" class="form-control bg-light" name="newUserName" placeholder="담당자 실명">
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold text-dark">비밀번호 <span class="text-danger">*</span></label>
                    <input type="password" class="form-control bg-light" name="newPassword" placeholder="초기 비밀번호 설정" autocomplete="new-password">
                </div>
                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-dark">연락처</label>
                        <input type="text" class="form-control bg-light" name="newMobile" placeholder="010-0000-0000">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-dark">이메일</label>
                        <input type="email" class="form-control bg-light" name="newEmail" placeholder="email@example.com">
                    </div>
                </div>
                <div class="p-2 rounded" style="background:#eff6ff; border:1px solid #bfdbfe; font-size:.78rem; color:#1e40af;">
                    <i class="bi bi-info-circle me-1"></i> 신규 계정은 <strong>CHANNEL_ADMIN</strong> 역할로 자동 생성되며, 이 채널에 즉시 배정됩니다.
                </div>
            </div>
        </div>
    </div>

    <!-- 저장 버튼 -->
    <div class="d-flex justify-content-center gap-3 mb-4">
        <button type="button" id="btnAssignManager" class="btn btn-primary px-5 py-2 shadow"
                style="border-radius:12px; font-weight:700;">
            <i class="bi bi-check2-circle me-1"></i>담당자 지정
        </button>
    </div>
</div>

<script>
    function toggleAssignMode(mode) {
        if (mode === 'existing') {
            document.getElementById('existingSection').style.display = '';
            document.getElementById('newSection').style.display = 'none';
            document.getElementById('modeExisting').checked = true;
        } else {
            document.getElementById('existingSection').style.display = 'none';
            document.getElementById('newSection').style.display = '';
            document.getElementById('modeNew').checked = true;
        }
    }

    // 라디오 버튼 시각적 활성화
    setTimeout(function() {
        var radios = document.querySelectorAll("input[name='assignMode']");
        radios.forEach(function(r) {
            r.addEventListener("change", function() {
                document.querySelectorAll("input[name='assignMode'] + div").forEach(function(d) {
                    d.classList.remove("btn-dark");
                    d.classList.add("btn-outline-dark");
                });
                if (this.checked) {
                    this.nextElementSibling.classList.remove("btn-outline-dark");
                    this.nextElementSibling.classList.add("btn-dark");
                }
            });
        });
        // 초기 상태 반영
        var checkedRadio = document.querySelector("input[name='assignMode']:checked");
        if (checkedRadio) {
            checkedRadio.nextElementSibling.classList.remove("btn-outline-dark");
            checkedRadio.nextElementSibling.classList.add("btn-dark");
        }
    }, 100);
</script>
