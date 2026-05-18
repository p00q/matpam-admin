<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="container-fluid px-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="mt-4 fw-bold text-dark">구매업체 상세 정보</h1>
            <p class="text-muted">업체의 기본 정보와 소속 사용자 계정을 관리합니다.</p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/admin/member/memberList.do" class="btn btn-outline-secondary rounded-pill px-4">
                <i class="bi bi-arrow-left me-1"></i> 목록으로
            </a>
        </div>
    </div>

    <div class="row">
        <!-- 업체 기본 정보 -->
        <div class="col-xl-4 col-md-6 mb-4">
            <div class="card border-0 shadow-sm h-100" style="border-radius: 15px;">
                <div class="card-header bg-white py-3 border-0">
                    <h6 class="m-0 fw-bold text-primary"><i class="bi bi-building me-2"></i>기본 정보</h6>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="small text-muted mb-1">업체명</label>
                        <div class="fw-bold fs-5 text-dark">${memberVO.companyName}</div>
                    </div>
                    <div class="mb-3">
                        <label class="small text-muted mb-1">사업자번호</label>
                        <div class="fw-semibold">${memberVO.maskedBusinessNo}</div>
                    </div>
                    <div class="mb-3">
                        <label class="small text-muted mb-1">대표자명</label>
                        <div class="fw-semibold">${memberVO.maskedCeoName}</div>
                    </div>
                    <div class="mb-0">
                        <label class="small text-muted mb-1">상태</label>
                        <div>
                            <c:choose>
                                <c:when test="${memberVO.status == 'ACTIVE'}">
                                    <span class="badge bg-success rounded-pill px-3">정상</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger rounded-pill px-3">중지</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 연락처 및 주소 -->
        <div class="col-xl-8 col-md-6 mb-4">
            <div class="card border-0 shadow-sm h-100" style="border-radius: 15px;">
                <div class="card-header bg-white py-3 border-0">
                    <h6 class="m-0 fw-bold text-primary"><i class="bi bi-geo-alt me-2"></i>연락처 및 주소</h6>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="small text-muted mb-1">대표 전화</label>
                            <div class="fw-semibold">${memberVO.maskedPhone}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="small text-muted mb-1">대표 이메일</label>
                            <div class="fw-semibold">${memberVO.maskedEmail}</div>
                        </div>
                    </div>
                    <div class="mb-0">
                        <label class="small text-muted mb-1">주소</label>
                        <div class="fw-semibold">
                            <c:if test="${not empty memberVO.postalCode}">
                                [${memberVO.postalCode}]<br>
                            </c:if>
                            ${memberVO.address1} ${memberVO.address2}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 소속 사용자 목록 -->
    <div class="card border-0 shadow-sm mb-4" style="border-radius: 15px;">
        <div class="card-header bg-white py-3 border-0 d-flex justify-content-between align-items-center">
            <h6 class="m-0 fw-bold text-primary"><i class="bi bi-people me-2"></i>소속 사용자 계정</h6>
            <button class="btn btn-sm btn-primary rounded-pill px-3" onclick="location.href='${pageContext.request.contextPath}/admin/user/userForm.do?companyId=${memberVO.companyId}'">
                <i class="bi bi-plus-lg me-1"></i> 사용자 추가
            </button>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light bg-opacity-50">
                        <tr>
                            <th class="ps-4">성명</th>
                            <th>아이디</th>
                            <th>이메일</th>
                            <th class="text-center">역할</th>
                            <th class="text-center">상태</th>
                            <th class="pe-4 text-center">등록일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${userList}">
                            <tr>
                                <td class="ps-4">
                                    <div class="fw-bold">${user.userName}</div>
                                </td>
                                <td><code class="text-primary">${user.loginId}</code></td>
                                <td class="text-muted small">${user.email}</td>
                                <td class="text-center">
                                    <span class="badge bg-light text-dark border rounded-pill px-2">${user.userRole}</span>
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${user.status == 'ACTIVE'}">
                                            <span class="text-success small"><i class="bi bi-check-circle-fill me-1"></i>활성</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-danger small"><i class="bi bi-dash-circle-fill me-1"></i>중지</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="pe-4 text-center text-muted small">
                                    <fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd" />
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty userList}">
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">
                                    등록된 사용자 계정이 없습니다.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
