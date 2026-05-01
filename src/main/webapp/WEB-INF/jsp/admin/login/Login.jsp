<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>관리자 로그인 | 맛팜 B2B</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" rel="stylesheet" />
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            border: none;
            border-radius: 1rem;
            box-shadow: 0 1rem 3rem rgba(0,0,0,0.175);
            width: 100%;
            max-width: 400px;
            overflow: hidden;
        }
        .login-header {
            background: #fff;
            padding: 3rem 2rem 1rem;
            text-align: center;
        }
        .login-body {
            background: #fff;
            padding: 1rem 2.5rem 3rem;
        }
        .btn-login {
            padding: 0.8rem;
            font-weight: 600;
            border-radius: 0.5rem;
            background: #764ba2;
            border: none;
        }
        .btn-login:hover {
            background: #667eea;
        }
        .form-control {
            padding: 0.8rem 1rem;
            border-radius: 0.5rem;
        }
        .brand-logo {
            font-size: 2.5rem;
            font-weight: 800;
            color: #764ba2;
            margin-bottom: 0.5rem;
        }
        .brand-logo span {
            color: #667eea;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="login-header">
            <div class="brand-logo">MAT<span>PAM</span></div>
            <h5 class="text-muted">B2B Admin Portal</h5>
        </div>
        <div class="login-body">
            <c:if test="${not empty message}">
                <div class="alert alert-danger small py-2 mb-4" role="alert">
                    <i class="fas fa-exclamation-circle me-1"></i> ${message}
                </div>
            </c:if>

            <form action="loginProcess.do" method="post">
                <div class="mb-4">
                    <label class="form-label small text-muted fw-bold">ID</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="fas fa-user"></i></span>
                        <input type="text" name="loginId" class="form-control border-start-0 ps-0" placeholder="아이디" required autofocus />
                    </div>
                </div>
                <div class="mb-4">
                    <label class="form-label small text-muted fw-bold">Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="fas fa-lock"></i></span>
                        <input type="password" name="loginPw" class="form-control border-start-0 ps-0" placeholder="비밀번호" required />
                    </div>
                </div>
                <div class="d-grid mt-5">
                    <button type="submit" class="btn btn-primary btn-login">
                        로그인 <i class="fas fa-arrow-right ms-2"></i>
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
