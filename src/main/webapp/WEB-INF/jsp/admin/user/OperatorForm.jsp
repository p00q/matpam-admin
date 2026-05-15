<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:if test="${param.isModal != 'Y'}">
    <div class="px-4 pt-3 pb-1">
        <h4 class="fw-bold mb-0"><i class="bi bi-person-gear me-2"></i>운영자 정보 관리</h4>
    </div>
</c:if>

<div class="px-4 py-3 ${param.isModal == 'Y' ? 'pt-4' : ''}">
    <form id="operatorForm">
        <input type="hidden" name="userId" value="${user.userId}">
        <input type="hidden" id="formUserRole" name="userRole" value="${not empty user.userRole ? user.userRole : 'OPERATOR'}">
        <c:if test="${channelAssignmentLocked}">
            <input type="hidden" name="channelId" value="${user.channelId}">
        </c:if>

        <div class="premium-card mb-4 border-0 shadow-sm">
            <div class="card-header bg-white py-3 border-bottom">
                <h6 class="mb-0 fw-bold text-primary"><span class="badge bg-primary-subtle text-primary me-2">01</span> 계정 정보</h6>
            </div>
            <div class="card-body p-4">
                <div class="row g-3 mb-4">
                    <div class="col-md-12">
                        <label class="form-label fw-bold small text-muted">소속 테넌트(운영사) <span class="text-danger">*</span></label>
                        <select name="tenantId" class="form-select" ${not empty user.userId ? 'disabled' : ''}>
                            <option value="">-- 테넌트 선택 --</option>
                            <c:forEach var="t" items="${tenants}">
                                <option value="${t.tenantId}" ${user.tenantId eq t.tenantId ? 'selected' : ''}>${t.tenantName}</option>
                            </c:forEach>
                        </select>
                        <c:if test="${not empty user.userId}">
                            <input type="hidden" name="tenantId" value="${user.tenantId}">
                        </c:if>
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-muted">로그인 ID <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <input type="text" id="formLoginId" name="loginId" class="form-control" value="${user.loginId}"
                                   ${not empty user.userId ? 'readonly' : ''} placeholder="4~20자 영문/숫자">
                            <c:if test="${empty user.userId}">
                                <button class="btn btn-outline-dark" type="button" onclick="fn_checkId()">중복확인</button>
                            </c:if>
                        </div>
                        <div id="idCheckMsg" class="small mt-1"></div>
                        <input type="hidden" id="idChecked" value="${not empty user.userId ? 'Y' : 'N'}">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-muted">이름 <span class="text-danger">*</span></label>
                        <input type="text" name="userName" class="form-control" value="${user.userName}" placeholder="실명을 입력하세요">
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-muted">비밀번호 <c:if test="${empty user.userId}"><span class="text-danger">*</span></c:if></label>
                        <input type="password" id="formPassword" name="passwordHash" class="form-control" placeholder="영문+숫자+특수문자 8자 이상">
                        <c:if test="${not empty user.userId}">
                            <div class="form-text text-muted" style="font-size:0.75rem;">변경 시에만 입력하세요.</div>
                        </c:if>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-muted">비밀번호 확인</label>
                        <input type="password" id="formPasswordConfirm" class="form-control" placeholder="비밀번호 재입력">
                        <div id="pwdMatchMsg" class="small mt-1"></div>
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-muted">휴대폰 번호</label>
                        <input type="text" name="mobile" class="form-control" value="${user.mobile}" placeholder="010-0000-0000">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-muted">이메일</label>
                        <input type="email" name="email" class="form-control" value="${user.email}" placeholder="example@domain.com">
                    </div>
                </div>

                <div>
                    <label class="form-label fw-bold small text-muted">상태 <span class="text-danger">*</span></label>
                    <div class="d-flex gap-4">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="status" id="stActive" value="ACTIVE" ${user.status eq 'ACTIVE' ? 'checked' : ''}>
                            <label class="form-check-label" for="stActive">정상</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="status" id="stLocked" value="LOCKED" ${user.status eq 'LOCKED' ? 'checked' : ''}>
                            <label class="form-check-label" for="stLocked">잠김</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="status" id="stInactive" value="INACTIVE" ${user.status eq 'INACTIVE' ? 'checked' : ''}>
                            <label class="form-check-label" for="stInactive">중지</label>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="premium-card mb-4 border-0 shadow-sm">
            <div class="card-header bg-white py-3 border-bottom">
                <h6 class="mb-0 fw-bold text-primary"><span class="badge bg-primary-subtle text-primary me-2">02</span> 권한 및 역할</h6>
            </div>
            <div class="card-body p-4">
                <div class="row g-2 mb-4">
                    <div class="col-md-6">
                        <label class="role-card-v4 ${user.userRole eq 'OPERATOR' or empty user.userRole ? 'active' : ''}" id="card-OPERATOR">
                            <input type="radio" name="roleType" value="OPERATOR" ${user.userRole eq 'OPERATOR' or empty user.userRole ? 'checked' : ''} ${channelAssignmentLocked ? 'disabled' : ''} onclick="fn_roleChange('OPERATOR')">
                            <div class="role-icon-box total"><i class="bi bi-person-badge"></i></div>
                            <div class="role-info">
                                <div class="role-title">운영자</div>
                                <div class="role-text">몰 전체 관리 권한</div>
                            </div>
                        </label>
                    </div>
                    <div class="col-md-6">
                        <label class="role-card-v4 ${user.userRole eq 'CHANNEL_ADMIN' ? 'active' : ''}" id="card-CHANNEL_ADMIN">
                            <input type="radio" name="roleType" value="CHANNEL_ADMIN" ${user.userRole eq 'CHANNEL_ADMIN' ? 'checked' : ''} ${channelAssignmentLocked ? 'disabled' : ''} onclick="fn_roleChange('CHANNEL_ADMIN')">
                            <div class="role-icon-box active"><i class="bi bi-diagram-3"></i></div>
                            <div class="role-info">
                                <div class="role-title">채널 운영자</div>
                                <div class="role-text">특정 채널 전담 관리</div>
                            </div>
                        </label>
                    </div>
                </div>

                <c:if test="${channelAssignmentLocked}">
                    <div class="alert alert-warning py-2 px-3 small mb-4">
                        현재 이 운영자는 채널관리에서 <strong>${fn:escapeXml(managedChannel.channelName)}</strong> 담당자로 지정되어 있습니다. 역할과 담당 채널은 채널관리에서만 변경할 수 있습니다.
                    </div>
                </c:if>
                <div id="channelWrap" style="${user.userRole eq 'CHANNEL_ADMIN' ? '' : 'display:none;'}">
                    <label class="form-label fw-bold small text-muted">담당 채널</label>
                    <select name="channelId" class="form-select" ${channelAssignmentLocked ? 'disabled' : ''}>
                        <option value="">-- 채널 선택 --</option>
                        <c:forEach var="ch" items="${channelList}">
                            <option value="${ch.channelId}" ${user.channelId eq ch.channelId ? 'selected' : ''}>${fn:escapeXml(ch.channelName)}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-center gap-3 mb-4">
            <button type="button" id="btnSaveOperator" class="btn btn-primary px-5 py-2 shadow" style="border-radius:12px; font-weight:700;" onclick="fn_saveOperator()">
                <i class="bi bi-check2-circle me-1"></i> ${empty user.userId ? '운영자 등록하기' : '수정 내용 저장'}
            </button>
        </div>
    </form>
</div>

<script>
    $(function() {
        $('#formPasswordConfirm').on('input', function() {
            const pw = $('#formPassword').val();
            const msg = $('#pwdMatchMsg');
            if (!pw || !$(this).val()) { msg.html(''); return; }
            if (pw !== $(this).val()) {
                msg.html('<span class="text-danger">비밀번호가 일치하지 않습니다.</span>');
            } else {
                msg.html('<span class="text-success">일치합니다.</span>');
            }
        });
    });

    function fn_roleChange(role) {
        $('#formUserRole').val(role);
        $('#channelWrap').toggle(role === 'CHANNEL_ADMIN');
        $('.role-card-v4').removeClass('active');
        $('#card-' + role).addClass('active');
    }

    function fn_checkId() {
        const loginId = $('#formLoginId').val().trim();
        if (!loginId) { alert('로그인 ID를 입력하세요.'); return; }
        $.get("<c:url value='/admin/user/checkLoginId.ajax'/>", { loginId: loginId }, function(d) {
            const msg = $('#idCheckMsg');
            if (d.duplicated) {
                msg.html('<span class="text-danger">이미 사용 중인 ID입니다.</span>');
                $('#idChecked').val('N');
            } else {
                msg.html('<span class="text-success">사용 가능한 ID입니다.</span>');
                $('#idChecked').val('Y');
            }
        });
    }

    function fn_saveOperator() {
        const userId = '${user.userId}';
        const loginId = $('#formLoginId').val().trim();
        const userName = $('input[name="userName"]').val().trim();
        const pw = $('#formPassword').val();
        const pwC = $('#formPasswordConfirm').val();
        const role = $('#formUserRole').val();

        if (!loginId) { alert('로그인 ID를 입력하세요.'); return; }
        if (!userId && $('#idChecked').val() !== 'Y') { alert('ID 중복 확인을 해주세요.'); return; }
        if (!userName) { alert('이름을 입력하세요.'); return; }
        if (!userId && !pw) { alert('비밀번호를 입력하세요.'); return; }
        if (pw && pw !== pwC) { alert('비밀번호가 일치하지 않습니다.'); return; }

        const $saveButton = $('#btnSaveOperator');
        const formData = $('#operatorForm').serialize();
        $saveButton.prop('disabled', true);

        $.ajax({
            url: "<c:url value='/admin/user/saveUser.ajax'/>",
            type: "POST",
            data: formData,
            dataType: "json"
        }).done(function(res) {
            if (typeof res === 'string') {
                try {
                    res = JSON.parse(res);
                } catch (e) {
                    res = { success: false, message: '응답을 해석하지 못했습니다.' };
                }
            }

            if (res.success) {
                $saveButton.prop('disabled', false);
                try {
                    if ("${param.isModal}" === "Y" && typeof fn_onSaveSuccess === 'function') {
                        fn_onSaveSuccess();
                    } else if (typeof window.parent.fn_onSaveSuccess === 'function') {
                        window.parent.fn_onSaveSuccess();
                    } else {
                        if (typeof fn_toast === 'function') fn_toast(res.message || '저장되었습니다.', 'success');
                        else alert(res.message || '저장되었습니다.');
                        setTimeout(function() { location.reload(); }, 1000);
                    }
                } catch (e) {
                    console.error('[Operator Save Success Callback Error]', e);
                    alert(res.message || '저장되었습니다.');
                    location.reload();
                }
            } else {
                if (typeof fn_toast === 'function') fn_toast(res.message || '저장 중 오류가 발생했습니다.', 'error');
                else alert(res.message || '저장 중 오류가 발생했습니다.');
            }
        }).fail(function(xhr) {
            let message = '저장 중 오류가 발생했습니다.';
            if (xhr.responseJSON && xhr.responseJSON.message) {
                message = xhr.responseJSON.message;
            } else if (xhr.responseText) {
                try {
                    const parsed = JSON.parse(xhr.responseText);
                    if (parsed.message) {
                        message = parsed.message;
                    }
                } catch (e) {
                    message = '저장 요청이 실패했습니다. (' + xhr.status + ')';
                }
            }

            if (typeof fn_toast === 'function') fn_toast(message, 'error');
            else alert(message);
        }).always(function() {
            $saveButton.prop('disabled', false);
        });
    }
</script>
