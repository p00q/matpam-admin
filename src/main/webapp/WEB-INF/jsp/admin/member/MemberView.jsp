<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid p-4">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><i class="bi bi-house-door-fill"></i></li>
            <li class="breadcrumb-item"><a href="<c:url value='/admin/member/memberList.do?menu=member'/>">회원관리</a></li>
            <li class="breadcrumb-item active" aria-current="page">회원 상세</li>
        </ol>
    </nav>

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="mb-0 fw-bold text-primary">회원 정보</h5>
        <div class="d-flex gap-2">
            <button type="button" class="btn btn-secondary btn-sm"
                onclick="location.href='<c:url value='/admin/member/memberList.do?menu=member'/>'">
                목록으로
            </button>
        </div>
    </div>

    <div class="card shadow-sm mb-4">
        <div class="card-header bg-light fw-semibold">기본 정보</div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-3">
                    <label class="form-label text-muted">회원타입</label>
                    <div class="form-control">${member.memberTypeName}</div>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-muted">아이디</label>
                    <div class="form-control">${member.memberId}</div>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-muted">가입상태</label>
                    <div class="form-control">${member.statusName}</div>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-muted">가입일</label>
                    <div class="form-control">${member.joinDate}</div>
                </div>

                <div class="col-md-4">
                    <label class="form-label text-muted">업체명</label>
                    <div class="form-control fw-semibold">${member.companyName}</div>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted">사업자등록번호</label>
                    <div class="form-control">${member.businessNumber}</div>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted">대표명</label>
                    <div class="form-control">${member.ceoName}</div>
                </div>

                <div class="col-md-4">
                    <label class="form-label text-muted">대표 연락처</label>
                    <div class="form-control">${member.contactNumber}</div>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted">대표 이메일</label>
                    <div class="form-control">${member.email}</div>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted">대표 전화번호</label>
                    <div class="form-control">${member.companyPhone}</div>
                </div>

                <div class="col-md-6">
                    <label class="form-label text-muted">주소</label>
                    <div class="form-control">${member.address}</div>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-muted">상세주소</label>
                    <div class="form-control">${member.addressDetail}</div>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-muted">우편번호</label>
                    <div class="form-control">${member.postcode}</div>
                </div>

                <div class="col-md-3">
                    <label class="form-label text-muted">지역</label>
                    <div class="form-control">${member.region}</div>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-muted">회원등급</label>
                    <div class="form-control">${member.memberGradeName}</div>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-muted">여신</label>
                    <div class="form-control text-end">
                        <fmt:formatNumber value="${member.creditLimit}" type="number" />원
                    </div>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-muted">미트머니</label>
                    <div class="form-control text-end">
                        <fmt:formatNumber value="${member.meatMoney}" type="number" />원
                    </div>
                </div>

                <div class="col-md-3">
                    <label class="form-label text-muted">마케팅 수신동의</label>
                    <div class="form-control">${member.agreeMarketing}</div>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-muted">SMS 수신동의</label>
                    <div class="form-control">${member.agreeSms}</div>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-header bg-light fw-semibold">담당자 정보</div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table mb-0 table-bordered align-middle text-center">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 10%">대표</th>
                            <th style="width: 20%">이름</th>
                            <th style="width: 20%">휴대전화번호</th>
                            <th style="width: 20%">전화번호</th>
                            <th style="width: 30%">이메일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="manager" items="${memberManagers}">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${manager.mainYn == 'Y'}">
                                            <span class="badge bg-primary">대표</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">서브</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${manager.managerName}</td>
                                <td>${manager.mobileNumber}</td>
                                <td>${manager.phoneNumber}</td>
                                <td>${manager.email}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty memberManagers}">
                            <tr>
                                <td colspan="5" class="py-3 text-muted">등록된 담당자가 없습니다.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
