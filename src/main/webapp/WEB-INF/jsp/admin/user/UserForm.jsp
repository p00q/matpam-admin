<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<div class="container-fluid px-4">
    <h1 class="mt-4">사용자 ${empty user.userId ? '등록' : '수정'}</h1>
    <ol class="breadcrumb mb-4">
        <li class="breadcrumb-item"><a href="/admin/dashboard/main.do">대시보드</a></li>
        <li class="breadcrumb-item"><a href="/admin/user/userList.do">사용자 관리</a></li>
        <li class="breadcrumb-item active">사용자 ${empty user.userId ? '등록' : '수정'}</li>
    </ol>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card mb-4 shadow-sm border-0">
                <div class="card-header bg-white py-3 border-bottom">
                    <h6 class="m-0 font-weight-bold text-primary">사용자 계정 정보</h6>
                </div>
                <div class="card-body p-4">
                    <form:form modelAttribute="user" id="detailForm" name="detailForm">
                        <form:hidden path="userId" />
                        <form:hidden path="tenantId" value="1" /> <!-- 임시 고정 -->

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">로그인 ID <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <form:input path="loginId" class="form-control" placeholder="아이디를 입력하세요" required="true" readonly="${not empty user.userId}" />
                                    <c:if test="${empty user.userId}">
                                        <button class="btn btn-outline-secondary" type="button" id="btnCheckId" onclick="fn_checkId()">중복 확인</button>
                                    </c:if>
                                </div>
                                <div id="idCheckMsg" class="small mt-1"></div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">사용자 이름 <span class="text-danger">*</span></label>
                                <form:input path="userName" class="form-control" required="true" />
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">비밀번호 <c:if test="${empty user.userId}"><span class="text-danger">*</span></c:if></label>
                                <form:input path="passwordHash" type="password" class="form-control" placeholder="${empty user.userId ? '비밀번호 입력' : '변경 시에만 입력'}" required="${empty user.userId}" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">소속 업체 <span class="text-danger">*</span></label>
                                <form:select path="companyId" class="form-select" required="true">
                                    <form:option value="" label="-- 업체 선택 --" />
                                    <c:forEach var="comp" items="${companies}">
                                        <form:option value="${comp.companyId}" label="${comp.companyName}" />
                                    </c:forEach>
                                </form:select>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">권한 <span class="text-danger">*</span></label>
                                <form:select path="userRole" class="form-select" required="true">
                                    <form:option value="SUPER_ADMIN" label="슈퍼관리자" />
                                    <form:option value="SELLER_ADMIN" label="판매처관리자" />
                                    <form:option value="BUYER_ADMIN" label="구매처관리자" />
                                    <form:option value="CHANNEL_ADMIN" label="채널관리자" />
                                </form:select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">상태</label>
                                <div class="mt-2">
                                    <div class="form-check form-check-inline">
                                        <form:radiobutton path="status" value="ACTIVE" id="statusActive" class="form-check-input" />
                                        <label class="form-check-label" for="statusActive">활성</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <form:radiobutton path="status" value="INACTIVE" id="statusInactive" class="form-check-input" />
                                        <label class="form-check-label" for="statusInactive">중지</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <hr class="my-4">

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">휴대폰 번호</label>
                                <form:input path="mobile" class="form-control" placeholder="010-0000-0000" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">이메일</label>
                                <form:input path="email" type="email" class="form-control" placeholder="example@domain.com" />
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top d-flex justify-content-between">
                            <a href="/admin/user/userList.do" class="btn btn-outline-secondary px-4">
                                <i class="fas fa-list me-1"></i> 목록으로
                            </a>
                            <button type="button" class="btn btn-primary px-5 shadow-sm" onclick="fn_save()">
                                <i class="fas fa-save me-1"></i> ${empty user.userId ? '사용자 등록' : '정보 수정'}
                            </button>
                        </div>
                    </form:form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
let idChecked = ${not empty user.userId};

function fn_checkId() {
    const loginId = $('#loginId').val();
    if (!loginId) {
        alert('아이디를 입력하세요.');
        return;
    }

    $.ajax({
        url: '/admin/user/checkLoginId.ajax',
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
        url: '/admin/user/saveUser.ajax',
        type: 'POST',
        data: formData,
        success: function(res) {
            if (res.success) {
                alert('정상적으로 처리되었습니다.');
                location.href = '/admin/user/userList.do';
            } else {
                alert('처리 실패: ' + res.message);
            }
        },
        error: function() {
            alert('통신 중 오류가 발생했습니다.');
        }
    });
}

// 아이디 입력값이 바뀌면 중복확인 다시 하도록 처리
$('#loginId').on('input', function() {
    idChecked = false;
    $('#idCheckMsg').text('');
});
</script>
