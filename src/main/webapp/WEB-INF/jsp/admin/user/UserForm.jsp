<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<div class="container-fluid px-0">
    <div class="px-4 py-3 ${param.isModal == 'Y' ? 'pt-4' : ''}">
        <div class="row justify-content-center">
            <div class="col-xl-12 col-lg-12">
                <form:form modelAttribute="user" id="userDetailForm" name="detailForm" action="${pageContext.request.contextPath}/admin/user/saveUser.ajax">
                    <form:hidden path="userId" id="userIdHidden"/>
                    <form:hidden path="tenantId" id="tenantIdHidden"/>
                    <form:hidden path="userRole" id="userRoleHidden"/>
                    <form:hidden path="companyId" id="companyIdHidden"/>

                    <div class="premium-card mb-4 shadow-sm border-0" style="border-radius:16px; overflow:hidden;">
                        <div class="card-header bg-white py-3 border-bottom border-light">
                            <h6 class="mb-0 fw-bold text-primary"><i class="bi bi-shield-lock-fill me-2"></i>회원 정보 관리 (V34)</h6>
                        </div>
                        <div class="card-body p-4 bg-light-subtle">
                            <!-- 소속 정보 -->
                            <c:set var="isRoleFixed" value="${not empty param.userRole or (not empty user.userId and (user.userRole eq 'SELLER_ADMIN' or user.userRole eq 'BUYER_ADMIN'))}"/>
                            <div class="row g-4 mb-4">
                                <div class="col-md-4 ${isRoleFixed ? 'd-none' : ''}">
                                    <label class="form-label fw-bold text-dark">소속 구분 <span class="text-danger">*</span></label>
                                    <select id="affiliationType" class="form-select shadow-none" onchange="window.fn_onAffiliationTypeChange(this.value)">
                                        <option value="HQ" ${user.userRole == 'OPERATOR' ? 'selected' : ''}>운영사 (HQ)</option>
                                        <option value="SELLER" ${user.userRole == 'SELLER_ADMIN' || empty user.userRole ? 'selected' : ''}>판매업체 (Seller)</option>
                                        <option value="BUYER" ${user.userRole == 'BUYER_ADMIN' ? 'selected' : ''}>구매업체 (Buyer)</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-bold text-dark">대상 채널</label>
                                    <div id="channelNameDisplay" class="form-control-plaintext bg-light px-3 border rounded small" style="min-height:38px;">
                                        <c:choose>
                                            <c:when test="${not empty user.channelName}">${user.channelName}</c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="${isRoleFixed ? 'col-md-8' : 'col-md-4'}">
                                    <label class="form-label fw-bold text-dark">대상 업체 <span class="text-danger">*</span></label>
                                    <select id="companySelect" class="form-select shadow-none" onchange="window.fn_onCompanyChange(this.value)">
                                        <option value="">-- 업체 선택 --</option>
                                    </select>
                                </div>
                            </div>

                            <!-- 계정 정보 -->
                            <div class="row g-4 mb-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-dark">사용자 ID <span class="text-danger">*</span></label>
                                    <form:input path="loginId" id="loginId" class="form-control shadow-none" readonly="${not empty user.userId}" placeholder="ID"/>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-dark">이름 <span class="text-danger">*</span></label>
                                    <form:input path="userName" id="userName" class="form-control shadow-none" placeholder="실명을 입력하세요"/>
                                </div>
                            </div>

                            <!-- 연락처 정보 (에러 메시지 레드 강조) -->
                            <div class="row g-4 mb-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-dark">휴대폰 번호</label>
                                    <form:input path="mobile" id="mobile" class="form-control shadow-none" placeholder="010-0000-0000"/>
                                    <div id="mobileHelper" class="small mt-1" style="color:#94a3b8;">입력 시 하이픈(-) 자동 변환</div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-dark">이메일 주소</label>
                                    <form:input path="email" id="email" type="email" class="form-control shadow-none" placeholder="example@domain.com"/>
                                    <div id="emailHelper" class="small mt-1" style="color:#94a3b8;">정확한 형식을 입력해 주세요.</div>
                                </div>
                            </div>

                            <!-- 비밀번호 및 상태 -->
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-dark">비밀번호 <c:if test="${empty user.userId}"><span class="text-danger">*</span></c:if></label>
                                    <form:input path="passwordHash" id="passwordHash" type="password" class="form-control shadow-none" placeholder="${empty user.userId ? '필수 입력' : '변경 시에만 입력'}"/>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-dark">계정 상태 <span class="text-danger">*</span></label>
                                    <div class="d-flex gap-4 mt-1">
                                        <div class="form-check"><form:radiobutton path="status" value="ACTIVE" id="st_active" class="form-check-input"/><label class="form-check-label text-success fw-bold" for="st_active">정상</label></div>
                                        <div class="form-check"><form:radiobutton path="status" value="LOCKED" id="st_locked" class="form-check-input"/><label class="form-check-label text-warning fw-bold" for="st_locked">잠김</label></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 저장 버튼 -->
                    <div class="d-flex justify-content-center gap-3 mb-4 mt-4">
                        <button type="button" class="btn btn-primary px-5 py-3 shadow" style="border-radius:14px; font-weight:700; font-size:1.1rem;" onclick="window.fn_save()">
                            <i class="bi bi-cloud-check-fill me-2"></i> 수정 내용 저장하기
                        </button>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
</div>

<script>
/**
 * [회원 관리] 스크립트 엔진 V34 (레드 강조 검증 + 자동 이동 패치)
 */
(function(window, $) {
    window.IS_EDIT   = ${not empty user.userId ? 'true' : 'false'};
    window.INIT_CO   = '${not empty user.companyId ? user.companyId : ""}';
    window.INIT_ROLE = '${empty user.userRole ? "SELLER_ADMIN" : user.userRole}';

    // 휴대폰 번호 포맷팅
    window.fn_formatMobile = function(val) {
        var cleanVal = val.replace(/[^0-9]/g, '');
        if (cleanVal.length <= 3) return cleanVal;
        if (cleanVal.length <= 7) return cleanVal.substring(0, 3) + '-' + cleanVal.substring(3);
        return cleanVal.substring(0, 3) + '-' + cleanVal.substring(3, 7) + '-' + cleanVal.substring(7, 11);
    };

    window.fn_onAffiliationTypeChange = function(type) {
        var role = 'SELLER_ADMIN';
        if (type === 'HQ') role = 'OPERATOR';
        else if (type === 'BUYER') role = 'BUYER_ADMIN';
        
        $('#userRoleHidden').val(role);
        window.fn_loadCompanies(type);
    };

    window.fn_loadCompanies = function(type) {
        if (!type) return;
        var $select = $('#companySelect').empty().append('<option value="">-- 업체 선택 --</option>');
        
        // 중복 호출 방지용 기교
        if (window._loadingCompanies === type) return;
        window._loadingCompanies = type;

        $.ajax({
            url: "<c:url value='/admin/company/search.ajax'/>?v=" + new Date().getTime(),
            type: 'GET',
            data: { companyType: type },
            success: function(res) {
                window._loadingCompanies = null;
                if (res.success && res.list) {
                    $.each(res.list, function(i, co) {
                        if (co.companyType !== type && co.companyType !== 'BOTH') return;

                        var isSelected = String(co.companyId) === String(window.INIT_CO);
                        var displayName = co.companyName;
                        if (co.businessNo) {
                            displayName += ' (' + co.businessNo + ')';
                        }
                        
                        $select.append('<option value="' + co.companyId + '" data-tenant="' + co.tenantId + '" data-channel="' + (co.channelName || '-') + '" ' + (isSelected ? 'selected' : '') + '>' + displayName + '</option>');
                    });
                    if (window.INIT_CO) {
                        $select.val(window.INIT_CO);
                        window.fn_onCompanyChange(window.INIT_CO);
                    }
                }
            },
            error: function() {
                window._loadingCompanies = null;
            }
        });
    };

    window.fn_onCompanyChange = function(id) {
        var $opt = $('#companySelect option:selected');
        var tenantId = $opt.data('tenant');
        var channelName = $opt.data('channel') || '-';
        
        $('#companyIdHidden').val(id);
        $('#tenantIdHidden').val(tenantId || 1);
        $('#channelNameDisplay').text(channelName);
    };

    // 검증 헬퍼 (레드 강조)
    window.fn_setError = function(id, msg) {
        var $el = $('#' + id);
        var $helper = $('#' + id + 'Helper');
        $el.addClass('is-invalid'); // 부트스트랩 에러 테두리
        $helper.text('⚠ ' + msg).css({'color': '#dc3545', 'font-weight': '600'});
        $el.focus();
    };

    window.fn_clearError = function(id, defaultMsg) {
        var $el = $('#' + id);
        var $helper = $('#' + id + 'Helper');
        $el.removeClass('is-invalid');
        $helper.text(defaultMsg).css({'color': '#94a3b8', 'font-weight': '400'});
    };

    window.fn_validate = function() {
        window.fn_clearError('mobile', '입력 시 하이픈(-) 자동 변환');
        window.fn_clearError('email', '정확한 형식을 입력해 주세요.');

        if (!$('#companyIdHidden').val()) { alert('업체를 선택해 주세요.'); return false; }
        if (!$('#userName').val()) { alert('이름을 입력해 주세요.'); return false; }
        
        var mobile = $('#mobile').val();
        if (mobile && mobile.trim() !== '') {
            if (!/^01[016789]-\d{3,4}-\d{4}$/.test(mobile)) {
                window.fn_setError('mobile', '휴대폰 번호 형식이 올바르지 않습니다.');
                alert('휴대폰 번호 형식을 다시 확인해 주세요.');
                return false;
            }
        }

        var email = $('#email').val();
        if (email && email.trim() !== '') {
            if (!/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(email)) {
                window.fn_setError('email', '이메일 주소 형식이 올바르지 않습니다.');
                alert('이메일 주소 형식을 다시 확인해 주세요.');
                return false;
            }
        }
        return true;
    };

    window.fn_save = function() {
        if (!window.fn_validate()) return;
        
        var formData = $('#userDetailForm').serialize();
        $.ajax({
            url: $('#userDetailForm').attr('action'),
            type: 'POST',
            data: formData,
            cache: false,
            success: function(res) {
                if (res.success) {
                    if (typeof window.fn_onSaveSuccess === 'function') {
                        window.fn_onSaveSuccess();
                    } else if (typeof window.parent.fn_onSaveSuccess === 'function') {
                        window.parent.fn_onSaveSuccess();
                    } else {
                        if(typeof fn_toast === 'function') fn_toast('성공적으로 저장되었습니다.', 'success');
                        else alert('성공적으로 저장되었습니다.');
                        location.href = "<c:url value='/admin/user/userList.do'/>";
                    }
                } else {
                    if(typeof fn_toast === 'function') fn_toast('저장 실패: ' + res.message, 'error');
                    else alert('저장 실패: ' + res.message);
                }
            },
            error: function(xhr) {
                alert('서버 통신 오류가 발생했습니다.');
            }
        });
    };

    $(function() {
        $('#mobile').on('input', function() {
            $(this).val(window.fn_formatMobile($(this).val()));
            window.fn_clearError('mobile', '입력 시 하이픈(-) 자동 변환');
        });
        $('#email').on('input', function() {
            window.fn_clearError('email', '정확한 형식을 입력해 주세요.');
        });
        if ($('#mobile').val()) {
            $('#mobile').val(window.fn_formatMobile($('#mobile').val()));
        }
        var initType = 'SELLER';
        if (window.INIT_ROLE === 'OPERATOR') initType = 'HQ';
        else if (window.INIT_ROLE === 'BUYER_ADMIN') initType = 'BUYER';
        
        $('#affiliationType').val(initType);
        window.fn_loadCompanies(initType);
    });

})(window, jQuery);
</script>

<style>
/* V34 전용 스타일: 에러 테두리 강조 */
.is-invalid { border-color: #dc3545 !important; box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25) !important; }
</style>
