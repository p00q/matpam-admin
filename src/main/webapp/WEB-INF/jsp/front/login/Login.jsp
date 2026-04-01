<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맛팜 로그인</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/front-shop.css'/>">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<div class="login-wrap">
    <div class="login-card">
        <div class="login-logo"><span>MAT</span>PAM</div>
        <p class="text-center text-muted mb-4" style="font-size:0.9rem">미트 머니 쇼핑몰에 오신 걸 환영합니다</p>

        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger rounded-3 py-2 text-center" style="font-size:0.9rem">
                <i class="bi bi-exclamation-circle me-1"></i>${errorMsg}
            </div>
        </c:if>

        <form id="login-form">
            <div class="mb-3">
                <label class="form-label fw-semibold text-muted" style="font-size:0.85rem">아이디</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-person text-muted"></i></span>
                    <input type="text" name="loginId" id="loginId" class="form-control border-start-0 ps-0"
                           placeholder="회원 아이디를 입력하세요" autocomplete="username">
                </div>
            </div>
            <div class="mb-4">
                <label class="form-label fw-semibold text-muted" style="font-size:0.85rem">비밀번호</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-lock text-muted"></i></span>
                    <input type="password" name="loginPw" id="loginPw" class="form-control border-start-0 ps-0"
                           placeholder="비밀번호를 입력하세요" autocomplete="current-password">
                </div>
            </div>

            <button type="submit" class="btn-shop-primary w-100 justify-content-center py-3" id="btn-login">
                <i class="bi bi-box-arrow-in-right me-2"></i> 로그인
            </button>
        </form>

        <p class="text-center text-muted mt-4 mb-0" style="font-size:0.8rem">
            회원가입은 맛팜 공식 채널을 통해 진행됩니다.
        </p>

        <hr class="my-3">
        <div class="text-center">
            <a href="<c:url value='/admin/loginForm.do'/>" class="text-muted" style="font-size:0.8rem">
                <i class="bi bi-shield-lock me-1"></i>관리자 로그인
            </a>
        </div>
    </div>
</div>

<script>
$('#login-form').on('submit', function(e) {
    e.preventDefault();
    const $btn = $('#btn-login');
    $btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm me-2"></span>로그인 중...');

    $.ajax({
        url: '<c:url value="/front/login.ajax"/>',
        type: 'POST',
        data: {
            loginId: $('#loginId').val(),
            loginPw: $('#loginPw').val()
        },
        dataType: 'json',
        success: function(res) {
            if (res.success) {
                location.href = '<c:url value="/front/main.do"/>';
            } else {
                alert(res.message || '로그인에 실패했습니다.');
                $btn.prop('disabled', false).html('<i class="bi bi-box-arrow-in-right me-2"></i> 로그인');
            }
        },
        error: function() {
            alert('서버 오류가 발생했습니다.');
            $btn.prop('disabled', false).html('<i class="bi bi-box-arrow-in-right me-2"></i> 로그인');
        }
    });
});
</script>
</body>
</html>
