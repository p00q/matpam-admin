<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<div class="container-fluid px-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="mt-4 fw-bold text-dark">사용자 ${empty user.userId ? '등록' : '수정'}</h1>
            <p class="text-muted">시스템 접근 권한과 소속 정보를 관리합니다.</p>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-10">
            <form:form modelAttribute="user" id="detailForm" name="detailForm">
                <form:hidden path="userId" />
                
                <div class="row">
                    <!-- 왼쪽: 계정 정보 -->
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm mb-4" style="border-radius: 15px;">
                            <div class="card-header bg-white py-3 border-0">
                                <h6 class="m-0 fw-bold text-primary"><i class="bi bi-person-badge me-2"></i>계정 정보</h6>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">로그인 ID <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <form:input path="loginId" class="form-control" placeholder="아이디를 입력하세요" required="true" readonly="${not empty user.userId}" />
                                        <c:if test="${empty user.userId}">
                                            <button class="btn btn-outline-primary" type="button" id="btnCheckId" onclick="fn_checkId()">중복 확인</button>
                                        </c:if>
                                    </div>
                                    <div id="idCheckMsg" class="small mt-1"></div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">비밀번호 <c:if test="${empty user.userId}"><span class="text-danger">*</span></c:if></label>
                                    <form:password path="passwordHash" class="form-control" placeholder="${empty user.userId ? '비밀번호 입력' : '변경 시에만 입력'}" required="${empty user.userId}" />
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">사용자 이름 <span class="text-danger">*</span></label>
                                    <form:input path="userName" class="form-control" required="true" placeholder="실명을 입력하세요" />
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-semibold">휴대폰 번호</label>
                                        <form:input path="mobile" class="form-control" placeholder="010-0000-0000" />
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-semibold">이메일</label>
                                        <form:input path="email" type="email" class="form-control" placeholder="user@example.com" />
                                    </div>
                                </div>
                                <div class="mb-0">
                                    <label class="form-label fw-semibold d-block">상태</label>
                                    <div class="form-check form-check-inline mt-1">
                                        <form:radiobutton path="status" value="ACTIVE" id="statusActive" class="form-check-input" />
                                        <label class="form-check-label" for="statusActive">활성</label>
                                    </div>
                                    <div class="form-check form-check-inline mt-1">
                                        <form:radiobutton path="status" value="INACTIVE" id="statusInactive" class="form-check-input" />
                                        <label class="form-check-label" for="statusInactive">중지</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 오른쪽: 권한 및 소속 정보 -->
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm mb-4" style="border-radius: 15px;">
                            <div class="card-header bg-white py-3 border-0">
                                <h6 class="m-0 fw-bold text-primary"><i class="bi bi-shield-lock me-2"></i>권한 및 소속 정보</h6>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">회원 역할 <span class="text-danger">*</span></label>
                                    <form:select path="userRole" id="userRole" class="form-select" required="true" onchange="fn_toggleFields()">
                                        <form:option value="" label="-- 역할 선택 --" />
                                        <form:option value="SUPER_ADMIN" label="슈퍼 관리자 (전체)" />
                                        <form:option value="SELLER_ADMIN" label="판매처 관리자" />
                                        <form:option value="CHANNEL_ADMIN" label="채널 관리자" />
                                        <form:option value="BUYER_ADMIN" label="구매처 관리자" />
                                    </form:select>
                                    <div class="form-text text-primary mt-2" id="roleDesc">역할을 선택하면 관련 필드가 활성화됩니다.</div>
                                </div>

                                <div id="tenantGroup" class="mb-3" style="display:none;">
                                    <label class="form-label fw-semibold">소속 테넌트 <span class="text-danger">*</span></label>
                                    <form:select path="tenantId" id="tenantId" class="form-select">
                                        <form:option value="1" label="맛팜 본사 플랫폼" />
                                    </form:select>
                                </div>

                                <div id="companyGroup" class="mb-3" style="display:none;">
                                    <label class="form-label fw-semibold">소속 업체 <span class="text-danger">*</span></label>
                                    <form:select path="companyId" id="companyId" class="form-select">
                                        <form:option value="" label="-- 업체 선택 --" />
                                        <c:forEach var="comp" items="${companies}">
                                            <form:option value="${comp.companyId}" data-type="${comp.companyType}" label="${comp.companyName} (${comp.companyType})" />
                                        </c:forEach>
                                    </form:select>
                                </div>

                                <div id="channelGroup" class="mb-0" style="display:none;">
                                    <label class="form-label fw-semibold">담당 채널 <span class="text-danger">*</span></label>
                                    <form:select path="channelId" id="channelId" class="form-select">
                                        <form:option value="" label="-- 채널 선택 --" />
                                        <form:option value="1" label="전국 택배 (PARCEL)" />
                                        <form:option value="2" label="화물 직송 (FREIGHT)" />
                                        <form:option value="3" label="공장 수령 (PICKUP)" />
                                    </form:select>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 담당자 생성 옵션 (신규 등록 시에만 표시) -->
                        <c:if test="${empty user.userId}">
                            <div class="card border-0 shadow-sm mb-4" style="border-radius: 15px; background-color: #f8f9fa;">
                                <div class="card-body">
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" id="createContact" name="createContact" value="Y">
                                        <label class="form-check-label fw-bold" for="createContact">업체 담당자로 동시 등록</label>
                                    </div>
                                    <div class="small text-muted mt-1 ps-1">체크 시 해당 업체의 연락처 담당자로 자동 추가됩니다.</div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>

                <div class="d-flex justify-content-between mt-2 mb-5">
                    <a href="${pageContext.request.contextPath}/admin/user/userList.do" class="btn btn-lg btn-outline-secondary rounded-pill px-4">
                        <i class="bi bi-x-lg me-1"></i> 취소
                    </a>
                    <button type="button" class="btn btn-lg btn-primary rounded-pill px-5 shadow" onclick="fn_save()">
                        <i class="bi bi-check-lg me-1"></i> ${empty user.userId ? '사용자 등록 완료' : '정보 수정 완료'}
                    </button>
                </div>
            </form:form>
        </div>
    </div>
</div>

<script>
let idChecked = ${not empty user.userId};

$(document).ready(function() {
    fn_toggleFields();
});

function fn_toggleFields() {
    const role = $('#userRole').val();
    const $tenantGroup = $('#tenantGroup');
    const $companyGroup = $('#companyGroup');
    const $channelGroup = $('#channelGroup');
    const $roleDesc = $('#roleDesc');
    const $companyOptions = $('#companyId option');

    // 초기화
    $tenantGroup.hide();
    $companyGroup.hide();
    $channelGroup.hide();
    
    // 필수 속성 제거
    $('#tenantId, #companyId, #channelId').prop('required', false);

    if (role === 'SUPER_ADMIN') {
        $roleDesc.text('수퍼 관리자는 특정 테넌트나 업체에 종속되지 않습니다.');
    } else if (role === 'SELLER_ADMIN') {
        $roleDesc.text('판매처 관리자는 해당 테넌트의 대표 판매 업체에 소속됩니다.');
        $tenantGroup.show();
        $companyGroup.show();
        $('#tenantId').prop('required', true);
        
        // SELLER만 표시
        $companyOptions.each(function() {
            if ($(this).data('type') === 'SELLER' || !$(this).val()) $(this).show();
            else $(this).hide();
        });
    } else if (role === 'CHANNEL_ADMIN') {
        $roleDesc.text('채널 관리자는 특정 배송 채널을 전담 관리합니다.');
        $tenantGroup.show();
        $companyGroup.show();
        $channelGroup.show();
        $('#tenantId, #channelId').prop('required', true);
        
        // SELLER만 표시
        $companyOptions.each(function() {
            if ($(this).data('type') === 'SELLER' || !$(this).val()) $(this).show();
            else $(this).hide();
        });
    } else if (role === 'BUYER_ADMIN') {
        $roleDesc.text('구매처 관리자는 특정 구매 업체(바이어)에 소속된 계정입니다.');
        $tenantGroup.show();
        $companyGroup.show();
        $('#tenantId, #companyId').prop('required', true);
        
        // BUYER만 표시
        $companyOptions.each(function() {
            if ($(this).data('type') === 'BUYER' || !$(this).val()) $(this).show();
            else $(this).hide();
        });
    } else {
        $roleDesc.text('역할을 선택하면 관련 필드가 활성화됩니다.');
    }
}

function fn_checkId() {
    const loginId = $('#loginId').val();
    if (!loginId) {
        alert('아이디를 입력하세요.');
        return;
    }

    $.ajax({
        url: '${pageContext.request.contextPath}/admin/user/checkLoginId.ajax',
        type: 'GET',
        data: { loginId: loginId },
        success: function(res) {
            if (res.success) {
                if (res.duplicated) {
                    $('#idCheckMsg').text('이미 사용 중인 아이디입니다.').removeClass('text-success').addClass('text-danger');
                    idChecked = false;
                } else {
                    $('#idCheckMsg').text('사용 가능한 아이디입니다.').removeClass('text-danger').addClass('text-success');
                    idChecked = true;
                }
            }
        }
    });
}

function fn_save() {
    const form = document.getElementById('detailForm');
    
    if (!idChecked) {
        alert('아이디 중복 확인이 필요합니다.');
        return;
    }

    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    if (!confirm('저장하시겠습니까?')) return;

    const formData = $(form).serialize();
    $.ajax({
        url: '${pageContext.request.contextPath}/admin/user/saveUser.ajax',
        type: 'POST',
        data: formData,
        success: function(res) {
            if (res.success) {
                alert('정상적으로 처리되었습니다.');
                location.href = '${pageContext.request.contextPath}/admin/user/userList.do';
            } else {
                alert('처리 실패: ' + res.message);
            }
        },
        error: function() {
            alert('통신 중 오류가 발생했습니다.');
        }
    });
}

$('#loginId').on('input', function() {
    idChecked = false;
    $('#idCheckMsg').text('');
});
</script>
