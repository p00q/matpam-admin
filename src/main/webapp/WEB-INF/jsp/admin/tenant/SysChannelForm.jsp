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

                <!-- ── 담당자 지정 (기존 선택 + 신규 추가) ── -->
                <div class="mb-4">
                    <label class="form-label fw-bold text-dark">담당자 지정 <span class="text-muted fw-normal">(선택)</span></label>
                    <div class="d-flex gap-2 align-items-start">
                        <select class="form-select bg-light" name="managerId" id="managerSelect" style="flex:1;">
                            <option value="">-- 담당자 없음 --</option>
                            <c:forEach var="mgr" items="${managerList}">
                                <option value="${mgr.userId}" ${channel.managerId eq mgr.userId ? 'selected' : ''}>${mgr.userName} (${mgr.loginId})</option>
                            </c:forEach>
                        </select>
                        <button type="button" class="btn btn-outline-primary btn-sm px-3"
                                style="white-space:nowrap; border-radius:8px; font-weight:600; height:38px;"
                                onclick="fn_toggleNewMgr()">
                            <i class="bi bi-person-plus me-1"></i>신규 추가
                        </button>
                    </div>
                </div>

                <!-- ── 신규 담당자 인라인 등록 폼 (기본 숨김) ── -->
                <div id="newManagerSection" style="display:none;" class="mb-4">
                    <div class="p-3 rounded-3" style="background:#f8fafc; border:1px solid #e2e8f0;">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <h6 class="mb-0 fw-bold" style="color:#4361ee; font-size:.85rem;">
                                <i class="bi bi-person-plus-fill me-1"></i>신규 채널 담당자 등록
                            </h6>
                            <button type="button" class="btn-close btn-close-sm" onclick="fn_closeNewMgr()" style="font-size:.6rem;"></button>
                        </div>
                        <div class="row g-2 mb-2">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-dark mb-1">로그인 ID <span class="text-danger">*</span></label>
                                <input type="text" class="form-control form-control-sm bg-white" id="newMgrLoginId" placeholder="예: ch_admin_01" autocomplete="off">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-dark mb-1">이름 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control form-control-sm bg-white" id="newMgrUserName" placeholder="담당자 실명">
                            </div>
                        </div>
                        <div class="row g-2 mb-2">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-dark mb-1">비밀번호 <span class="text-danger">*</span></label>
                                <input type="password" class="form-control form-control-sm bg-white" id="newMgrPassword" placeholder="초기 비밀번호" autocomplete="new-password">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-dark mb-1">연락처</label>
                                <input type="text" class="form-control form-control-sm bg-white" id="newMgrMobile" placeholder="010-0000-0000">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-dark mb-1">이메일</label>
                            <input type="email" class="form-control form-control-sm bg-white" id="newMgrEmail" placeholder="email@example.com">
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="small" style="color:#64748b;">
                                <i class="bi bi-info-circle me-1"></i><strong>CHANNEL_ADMIN</strong> 역할로 자동 생성됩니다.
                            </div>
                            <button type="button" class="btn btn-primary btn-sm px-4" id="btnCreateNewManager" style="border-radius:8px; font-weight:600;">
                                <i class="bi bi-check-lg me-1"></i>계정 생성 후 지정
                            </button>
                        </div>
                    </div>
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
        var existingTypes = "${existingTypes}".split(",").filter(function(value) { return value !== ""; });
        var typeSelect = document.getElementById("formChannelType");
        var currentType = "${channel.channelType}";

        if (!typeSelect) return;
        Array.from(typeSelect.options).forEach(function(option) {
            if (option.value !== "" && option.value !== currentType && existingTypes.includes(option.value)) {
                option.disabled = true;
                option.text += " (이미 존재)";
            }
        });
    }, 100);

    /* ── 신규 담당자 추가 토글 (인라인 onclick) ── */
    function fn_toggleNewMgr() {
        var $s = $("#newManagerSection");
        if ($s.is(":visible")) { $s.slideUp(200); } else { $s.slideDown(200); }
    }
    function fn_closeNewMgr() {
        $("#newManagerSection").slideUp(200);
    }

    /* ── 신규 담당자 계정 생성 ── */
    $("#btnCreateNewManager").on("click", function() {
        var loginId  = $("#newMgrLoginId").val().trim();
        var userName = $("#newMgrUserName").val().trim();
        var password = $("#newMgrPassword").val().trim();
        var mobile   = $("#newMgrMobile").val().trim();
        var email    = $("#newMgrEmail").val().trim();
        var companyId = $("input[name='companyId']").val();

        if (!loginId)  { alert("로그인 ID를 입력하세요."); $("#newMgrLoginId").focus(); return; }
        if (!userName) { alert("이름을 입력하세요."); $("#newMgrUserName").focus(); return; }
        if (!password) { alert("비밀번호를 입력하세요."); $("#newMgrPassword").focus(); return; }

        var $btn = $(this);
        $btn.prop("disabled", true).html('<i class="bi bi-hourglass-split me-1"></i>생성 중...');

        $.ajax({
            url: "<c:url value='/admin/sysChannel/createChannelAdmin.ajax'/>",
            type: "POST",
            data: {
                companyId: companyId,
                loginId: loginId,
                userName: userName,
                password: password,
                mobile: mobile,
                email: email
            },
            success: function(res) {
                if (res.status === "SUCCESS") {
                    /* 드롭다운에 새 옵션 추가 & 자동 선택 */
                    var $select = $("#managerSelect");
                    var newOption = new Option(res.userName + " (" + res.loginId + ")", res.userId, true, true);
                    $select.append(newOption);

                    /* 입력 필드 초기화 & 섹션 닫기 */
                    $("#newMgrLoginId, #newMgrUserName, #newMgrPassword, #newMgrMobile, #newMgrEmail").val("");
                    $("#newManagerSection").slideUp(200);

                    /* 토스트 알림 */
                    if (typeof fn_toast === "function") {
                        fn_toast("채널 담당자 '" + res.userName + "'이(가) 생성되었습니다.", "success");
                    } else {
                        alert("채널 담당자 '" + res.userName + "'이(가) 생성되었습니다.");
                    }
                } else {
                    alert(res.message || "생성 중 오류가 발생했습니다.");
                }
                $btn.prop("disabled", false).html('<i class="bi bi-check-lg me-1"></i>계정 생성 후 지정');
            },
            error: function() {
                alert("서버 통신 오류가 발생했습니다.");
                $btn.prop("disabled", false).html('<i class="bi bi-check-lg me-1"></i>계정 생성 후 지정');
            }
        });
    });
</script>
