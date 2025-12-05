<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- 회원등록 화면 -->

            <style>
                .form-table th,
                .form-table td {
                    padding: 0.6rem 0.75rem !important;
                    vertical-align: middle;
                }

                .form-table th {
                    background-color: #f8f9fa;
                    font-weight: 600;
                    width: 15%;
                }

                .nav-tabs .nav-link {
                    color: #495057;
                    border: 1px solid transparent;
                    border-bottom: 2px solid #dee2e6;
                }

                .nav-tabs .nav-link.active {
                    color: #2c5f7c;
                    background-color: #fff;
                    border-color: #dee2e6 #dee2e6 #fff;
                    border-bottom: 2px solid #2c5f7c;
                    font-weight: 600;
                }

                .section-header {
                    background-color: #e9ecef;
                    padding: 0.5rem 1rem;
                    font-weight: 600;
                    border-left: 4px solid #2c5f7c;
                    margin-bottom: 1rem;
                }

                .manager-section {
                    border: 1px solid #dee2e6;
                    padding: 1rem;
                    margin-bottom: 1rem;
                    border-radius: 0.25rem;
                    background-color: #f8f9fa;
                }
            </style>

            <div class="container-fluid p-4">
                <!-- Breadcrumb -->
                <nav aria-label="breadcrumb" class="mb-3">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><i class="bi bi-house-door-fill"></i></li>
                        <li class="breadcrumb-item"><a
                                href="<c:url value='/admin/member/memberList.do?menu=member'/>">회원관리</a></li>
                        <li class="breadcrumb-item active" aria-current="page">회원등록</li>
                    </ol>
                </nav>

                <jsp:useBean id="today" class="java.util.Date" />
                <fmt:formatDate var="currentDate" value="${today}" pattern="yyyy-MM-dd" />
                <c:set var="managers"
                    value="${not empty member.memberManagers ? member.memberManagers : managers}" />

                <form name="memberForm" method="post" action="<c:url value='/admin/member/insertMember.do'/>">
                    <input type="hidden" name="menu" value="member" />
                    <input type="hidden" name="joinDate"
                        value="<c:out value='${not empty member.joinDate ? member.joinDate : currentDate}'/>" />
                    <input type="hidden" name="creditLimit"
                        value="<c:out value='${not empty member.creditLimit ? member.creditLimit : 0}'/>" />
                    <input type="hidden" name="meatMoney"
                        value="<c:out value='${not empty member.meatMoney ? member.meatMoney : 0}'/>" />

                    <!-- Tab Navigation -->
                    <ul class="nav nav-tabs mb-3" id="memberTab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="basic-tab" data-bs-toggle="tab" data-bs-target="#basic"
                                type="button" role="tab">기본정보</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="transaction-tab" data-bs-toggle="tab"
                                data-bs-target="#transaction" type="button" role="tab">거래정보</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="deposit-tab" data-bs-toggle="tab" data-bs-target="#deposit"
                                type="button" role="tab">입금금액관리내역</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="delivery-tab" data-bs-toggle="tab" data-bs-target="#delivery"
                                type="button" role="tab">배송지</button>
                        </li>
                    </ul>

                    <!-- Tab Content -->
                    <div class="tab-content" id="memberTabContent">
                        <!-- 기본 정보 Tab -->
                        <div class="tab-pane fade show active" id="basic" role="tabpanel">
                            <div class="section-header">■ 기본 정보</div>
                            <table class="table table-bordered form-table">
                                <colgroup>
                                    <col style="width: 15%;">
                                    <col style="width: 35%;">
                                    <col style="width: 15%;">
                                    <col style="width: 35%;">
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th>회원타입 <span class="text-danger">*</span></th>
                                        <td>
                                            <select name="memberType" id="memberType" class="form-select form-select-sm"
                                                style="max-width: 200px;" required>
                                                <option value="" disabled
                                                    <c:if test="${empty member.memberType}">selected</c:if>>회원타입 선택</option>
                                                <c:forEach var="type" items="${memberTypes}">
                                                    <option value="${type.detailCode}"
                                                        <c:if test="${member.memberType eq type.detailCode}">selected</c:if>>${type.detailCodeName}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <th>지역</th>
                                        <td>
                                            <select name="region" class="form-select form-select-sm"
                                                style="max-width: 200px;">
                                                <option value="" <c:if test="${empty member.region}">selected</c:if>>전체</option>
                                                <option value="SEOUL" <c:if test="${member.region eq 'SEOUL'}">selected</c:if>>서울</option>
                                                <option value="GYEONGGI" <c:if test="${member.region eq 'GYEONGGI'}">selected</c:if>>경기</option>
                                                <option value="INCHEON" <c:if test="${member.region eq 'INCHEON'}">selected</c:if>>인천</option>
                                                <option value="GANGWON" <c:if test="${member.region eq 'GANGWON'}">selected</c:if>>강원</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>아이디 <span class="text-danger">*</span></th>
                                        <td>
                                            <input type="text" name="memberId" class="form-control form-control-sm"
                                                value="<c:out value='${member.memberId}'/>" required />
                                        </td>
                                        <th>비밀번호 <span class="text-danger">*</span></th>
                                        <td>
                                            <input type="password" name="loginPw" class="form-control form-control-sm"
                                                required />
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>업체명</th>
                                        <td>
                                            <input type="text" name="companyName"
                                                value="<c:out value='${member.companyName}'/>"
                                                class="form-control form-control-sm" />
                                        </td>
                                        <th>사업자등록번호</th>
                                        <td>
                                            <input type="text" name="businessNumber"
                                                class="form-control form-control-sm" placeholder="000-00-00000"
                                                maxlength="12" value="<c:out value='${member.businessNumber}'/>" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>회원등급</th>
                                        <td>
                                            <select name="memberGrade" class="form-select form-select-sm"
                                                style="max-width: 200px;">
                                                <c:forEach var="grade" items="${memberGrades}">
                                                    <option value="${grade.detailCode}"
                                                        <c:if test="${member.memberGrade eq grade.detailCode}">selected</c:if>>${grade.detailCodeName}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <th>대표자명</th>
                                        <td>
                                            <input type="text" name="ceoName" class="form-control form-control-sm"
                                                value="<c:out value='${member.ceoName}'/>" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>가입상태</th>
                                        <td>
                                            <select name="status" class="form-select form-select-sm"
                                                style="max-width: 200px;">
                                                <c:forEach var="statusItem" items="${statusCodes}">
                                                    <option value="${statusItem.detailCode}"
                                                        <c:if test="${member.status eq statusItem.detailCode}">selected</c:if>>
                                                        ${statusItem.detailCodeName}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <th>연락처 <span class="text-danger">*</span></th>
                                        <td>
                                            <input type="tel" name="contactNumber" class="form-control form-control-sm"
                                                placeholder="010-0000-0000" maxlength="13" required
                                                value="<c:out value='${member.contactNumber}'/>" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>회사 전화번호</th>
                                        <td>
                                            <input type="text" name="companyPhone" class="form-control form-control-sm"
                                                placeholder="02-0000-0000" maxlength="13"
                                                value="<c:out value='${member.companyPhone}'/>" />
                                        </td>
                                        <th>이메일주소</th>
                                        <td>
                                            <input type="email" name="email" class="form-control form-control-sm"
                                                value="<c:out value='${member.email}'/>" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>주소</th>
                                        <td colspan="3">
                                            <div class="d-flex gap-2 mb-2">
                                                <input type="text" id="postcode" name="postcode"
                                                    class="form-control form-control-sm" placeholder="우편번호" readonly
                                                    style="max-width: 150px;" value="<c:out value='${member.postcode}'/>" />
                                                <button type="button" class="btn btn-secondary btn-sm"
                                                    onclick="execDaumPostcode()">주소검색</button>
                                            </div>
                                            <input type="text" id="address" name="address"
                                                class="form-control form-control-sm mb-2" placeholder="주소" readonly
                                                value="<c:out value='${member.address}'/>" />
                                            <input type="text" name="addressDetail" class="form-control form-control-sm"
                                                placeholder="상세주소" value="<c:out value='${member.addressDetail}'/>" />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>

                            <c:if test="${empty member.memberType or member.memberType ne 'ADMIN'}">
                                <div id="managerBlock">
                                    <div class="section-header">
                                        ■ 담당자 정보
                                        <button type="button" id="btnAddManager" class="btn btn-sm btn-primary float-end"
                                            onclick="addManager()">생성</button>
                                        <div class="form-check form-check-inline float-end me-2">
                                            <input class="form-check-input" type="checkbox" id="sameAsMember"
                                                onchange="copySameAsMember()">
                                            <label class="form-check-label" for="sameAsMember">회원정보와 동일</label>
                                        </div>
                                    </div>

                                    <div id="managerContainer">
                                    <c:choose>
                                        <c:when test="${not empty managers}">
                                            <c:forEach var="manager" items="${managers}" varStatus="status">
                                                <div class="manager-section" data-index="${status.index}">
                                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                                        <div class="d-flex align-items-center gap-3">
                                                            <strong class="manager-title">담당자 ${status.index + 1}</strong>
                                                            <div class="form-check mb-0">
                                                                <input class="form-check-input main-radio" type="radio"
                                                                    name="mainManagerIndex" value="${status.index}"
                                                                    <c:if test="${manager.mainYn eq 'Y' or (empty manager.mainYn and status.first)}">checked</c:if>>
                                                                <label class="form-check-label">기본 담당자</label>
                                                            </div>
                                                        </div>
                                                        <button type="button"
                                                            class="btn btn-sm btn-danger remove-manager-btn <c:if test='${status.first and fn:length(managers) == 1}'>d-none</c:if>"
                                                            onclick="removeManager(this)">삭제</button>
                                                    </div>
                                                    <input type="hidden" class="main-yn-field"
                                                        name="memberManagers[${status.index}].mainYn"
                                                        value="<c:out value='${empty manager.mainYn ? (status.first ? "Y" : "N") : manager.mainYn}'/>" />
                                                    <input type="hidden" class="use-yn-field"
                                                        name="memberManagers[${status.index}].useYn"
                                                        value="<c:out value='${not empty manager.useYn ? manager.useYn : "Y"}'/>" />
                                                    <table class="table table-bordered form-table mb-0">
                                                        <tbody>
                                                            <tr>
                                                                <th>이름</th>
                                                                <td>
                                                                    <input type="text" id="managerName${status.index}"
                                                                        data-field="managerName"
                                                                        name="memberManagers[${status.index}].managerName"
                                                                        value="<c:out value='${manager.managerName}'/>"
                                                                        class="form-control form-control-sm" />
                                                                </td>
                                                                <th>전화번호</th>
                                                                <td>
                                                                    <input type="tel" id="managerPhone${status.index}"
                                                                        data-field="phoneNumber"
                                                                        name="memberManagers[${status.index}].phoneNumber"
                                                                        class="form-control form-control-sm"
                                                                        placeholder="010-0000-0000" maxlength="13"
                                                                        value="<c:out value='${manager.phoneNumber}'/>" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <th>휴대전화번호</th>
                                                                <td>
                                                                    <input type="tel" id="managerMobile${status.index}"
                                                                        data-field="mobileNumber"
                                                                        name="memberManagers[${status.index}].mobileNumber"
                                                                        class="form-control form-control-sm"
                                                                        placeholder="010-0000-0000" maxlength="13"
                                                                        value="<c:out value='${manager.mobileNumber}'/>" />
                                                                </td>
                                                                <th>이메일주소</th>
                                                                <td>
                                                                    <input type="email" id="managerEmail${status.index}"
                                                                        data-field="email"
                                                                        name="memberManagers[${status.index}].email"
                                                                        class="form-control form-control-sm"
                                                                        value="<c:out value='${manager.email}'/>" />
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="manager-section" data-index="0">
                                                <div class="d-flex justify-content-between align-items-center mb-2">
                                                    <div class="d-flex align-items-center gap-3">
                                                        <strong class="manager-title">담당자 1</strong>
                                                        <div class="form-check mb-0">
                                                            <input class="form-check-input main-radio" type="radio"
                                                                name="mainManagerIndex" value="0" checked>
                                                            <label class="form-check-label">기본 담당자</label>
                                                        </div>
                                                    </div>
                                                    <button type="button" class="btn btn-sm btn-danger remove-manager-btn d-none"
                                                        onclick="removeManager(this)">삭제</button>
                                                </div>
                                                <input type="hidden" class="main-yn-field"
                                                    name="memberManagers[0].mainYn" value="Y" />
                                                <input type="hidden" class="use-yn-field" name="memberManagers[0].useYn"
                                                    value="Y" />
                                                <table class="table table-bordered form-table mb-0">
                                                    <tbody>
                                                        <tr>
                                                            <th>이름</th>
                                                            <td>
                                                                <input type="text" id="managerName0" data-field="managerName"
                                                                    name="memberManagers[0].managerName"
                                                                    value="<c:out value='${member.managerName}'/>"
                                                                    class="form-control form-control-sm" />
                                                            </td>
                                                            <th>전화번호</th>
                                                            <td>
                                                                <input type="tel" id="managerPhone0" data-field="phoneNumber"
                                                                    name="memberManagers[0].phoneNumber"
                                                                    class="form-control form-control-sm"
                                                                    placeholder="010-0000-0000" maxlength="13"
                                                                    value="<c:out value='${member.managerPhone}'/>" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>휴대전화번호</th>
                                                            <td>
                                                                <input type="tel" id="managerMobile0" data-field="mobileNumber"
                                                                    name="memberManagers[0].mobileNumber"
                                                                    class="form-control form-control-sm"
                                                                    placeholder="010-0000-0000" maxlength="13"
                                                                    value="<c:out value='${member.managerMobile}'/>" />
                                                            </td>
                                                            <th>이메일주소</th>
                                                            <td>
                                                                <input type="email" id="managerEmail0" data-field="email"
                                                                    name="memberManagers[0].email" class="form-control form-control-sm"
                                                                    value="<c:out value='${member.managerEmail}'/>" />
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    </div>
                                </div>
                            </c:if>

                            <div class="section-header">■ 정보 동의 여부</div>
                            <div class="p-3">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" name="agreeMarketing"
                                        id="agreeMarketing" value="Y"
                                        <c:if test="${member.agreeMarketing eq 'Y'}">checked</c:if>>
                                    <label class="form-check-label" for="agreeMarketing">광고성 정보 수신 여부</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" name="agreeSms" id="agreeSms"
                                        value="Y" <c:if test="${member.agreeSms eq 'Y'}">checked</c:if>>
                                    <label class="form-check-label" for="agreeSms">문자 수신 여부</label>
                                </div>
                            </div>
                        </div>

                        <!-- 거래정보 Tab -->
                        <div class="tab-pane fade" id="transaction" role="tabpanel">
                            <div class="section-header">■ 거래 정보</div>
                            <table class="table table-bordered form-table">
                                <tbody>
                                    <tr>
                                        <th>거래일자</th>
                                        <td>
                                            <input type="date" name="transactionDate"
                                                class="form-control form-control-sm" style="max-width: 200px;" />
                                        </td>
                                        <th>수정일자</th>
                                        <td>
                                            <input type="date" name="transactionModifyDate"
                                                class="form-control form-control-sm" style="max-width: 200px;"
                                                readonly />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- 입금금액관리내역 Tab -->
                        <div class="tab-pane fade" id="deposit" role="tabpanel">
                            <div class="section-header">■ 입금 금액 관리 내역</div>
                            <p class="text-muted">입금 내역이 없습니다.</p>
                        </div>

                        <!-- 배송지 Tab -->
                        <div class="tab-pane fade" id="delivery" role="tabpanel">
                            <div class="section-header">■ 배송지 정보</div>
                            <p class="text-muted">등록된 배송지가 없습니다.</p>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="d-flex justify-content-center gap-2 mt-4">
                        <button type="button" class="btn btn-secondary px-4" onclick="history.back()">목록</button>
                        <button type="submit" id="btnSave" class="btn btn-primary px-4">등록</button>
                        <button type="button" id="btnReset" class="btn btn-danger px-4" onclick="resetForm()">취소</button>
                    </div>
                </form>
            </div>

            <!-- Daum Postcode API -->
            <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

            <script>
                let managerIndex = <c:out value='${fn:length(managers) gt 0 ? fn:length(managers) - 1 : 0}'/>;

                document.addEventListener('DOMContentLoaded', function () {
                    attachPhoneFormatter(document.querySelectorAll('input[type="tel"], input[name="businessNumber"], input[name="contactNumber"], input[name="companyPhone"]'));
                    document.querySelectorAll('.main-radio').forEach(radio => radio.addEventListener('change', syncMainFlags));
                    syncMainFlags();
                    toggleManagerArea();

                    const memberTypeSelect = document.getElementById('memberType');
                    if (memberTypeSelect) {
                        memberTypeSelect.addEventListener('change', toggleManagerArea);
                    }

                    const renderedManagers = document.querySelectorAll('#managerContainer .manager-section').length;
                    if (renderedManagers > 0) {
                        managerIndex = renderedManagers - 1;
                    }
                });

                function attachPhoneFormatter(inputs) {
                    inputs.forEach(input => {
                        input.addEventListener('input', function (e) {
                            let value = e.target.value.replace(/[^0-9]/g, '');
                            let formattedValue = '';

                            if (e.target.name === 'businessNumber') {
                                if (value.length <= 3) {
                                    formattedValue = value;
                                } else if (value.length <= 5) {
                                    formattedValue = value.slice(0, 3) + '-' + value.slice(3);
                                } else {
                                    formattedValue = value.slice(0, 3) + '-' + value.slice(3, 5) + '-' + value.slice(5, 10);
                                }
                            } else {
                                if (value.startsWith('02')) {
                                    if (value.length <= 2) {
                                        formattedValue = value;
                                    } else if (value.length <= 6) {
                                        formattedValue = value.slice(0, 2) + '-' + value.slice(2);
                                    } else {
                                        formattedValue = value.slice(0, 2) + '-' + value.slice(2, 6) + '-' + value.slice(6, 10);
                                    }
                                } else {
                                    if (value.length <= 3) {
                                        formattedValue = value;
                                    } else if (value.length <= 7) {
                                        formattedValue = value.slice(0, 3) + '-' + value.slice(3);
                                    } else {
                                        formattedValue = value.slice(0, 3) + '-' + value.slice(3, 7) + '-' + value.slice(7, 11);
                                    }
                                }
                            }

                            e.target.value = formattedValue;
                        });
                    });
                }

                function execDaumPostcode() {
                    new daum.Postcode({
                        oncomplete: function (data) {
                            document.getElementById('postcode').value = data.zonecode;
                            document.getElementById('address').value = data.address;
                            document.querySelector('input[name="addressDetail"]').focus();
                        }
                    }).open();
                }

                function copySameAsMember() {
                    const checked = document.getElementById('sameAsMember').checked;
                    const ceoName = document.querySelector('input[name="ceoName"]').value;
                    const contactNumber = document.querySelector('input[name="contactNumber"]').value;
                    const email = document.querySelector('input[name="email"]').value;

                    document.getElementById('managerName0').value = checked ? ceoName : '';
                    document.getElementById('managerPhone0').value = checked ? contactNumber : '';
                    document.getElementById('managerMobile0').value = checked ? contactNumber : '';
                    document.getElementById('managerEmail0').value = checked ? email : '';
                }

                function toggleManagerArea() {
                    const type = document.getElementById('memberType');
                    const managerBlock = document.getElementById('managerBlock');
                    if (!type || !managerBlock) {
                        return;
                    }
                    const value = type.value;
                    if (value === 'ADMIN' || value === '관리자') {
                        managerBlock.style.display = 'none';
                    } else {
                        managerBlock.style.display = '';
                    }
                }

                function buildManagerSection(index) {
                    const newManager = document.createElement('div');
                    newManager.className = 'manager-section';
                    newManager.dataset.index = index;
                    newManager.innerHTML = `
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <div class="d-flex align-items-center gap-3">
                                <strong class="manager-title">담당자 ${index + 1}</strong>
                                <div class="form-check mb-0">
                                    <input class="form-check-input main-radio" type="radio" name="mainManagerIndex" value="${index}">
                                    <label class="form-check-label">기본 담당자</label>
                                </div>
                            </div>
                            <button type="button" class="btn btn-sm btn-danger remove-manager-btn" onclick="removeManager(this)">삭제</button>
                        </div>
                        <input type="hidden" class="main-yn-field" name="memberManagers[${index}].mainYn" value="N" />
                        <input type="hidden" class="use-yn-field" name="memberManagers[${index}].useYn" value="Y" />
                        <table class="table table-bordered form-table mb-0">
                            <tbody>
                                <tr>
                                    <th>이름</th>
                                    <td>
                                        <input type="text" data-field="managerName" name="memberManagers[${index}].managerName" class="form-control form-control-sm" />
                                    </td>
                                    <th>전화번호</th>
                                    <td>
                                        <input type="tel" data-field="phoneNumber" name="memberManagers[${index}].phoneNumber" class="form-control form-control-sm" placeholder="010-0000-0000" maxlength="13" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>휴대전화번호</th>
                                    <td>
                                        <input type="tel" data-field="mobileNumber" name="memberManagers[${index}].mobileNumber" class="form-control form-control-sm" placeholder="010-0000-0000" maxlength="13" />
                                    </td>
                                    <th>이메일주소</th>
                                    <td>
                                        <input type="email" data-field="email" name="memberManagers[${index}].email" class="form-control form-control-sm" />
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    `;
                    return newManager;
                }

                function addManager() {
                    managerIndex++;
                    const container = document.getElementById('managerContainer');
                    const newManager = buildManagerSection(managerIndex);
                    container.appendChild(newManager);
                    attachPhoneFormatter(newManager.querySelectorAll('input[type="tel"]'));
                    newManager.querySelector('.main-radio').addEventListener('change', syncMainFlags);
                    renumberManagers();
                    syncMainFlags();
                }

                function removeManager(button) {
                    const manager = button.closest('.manager-section');
                    if (manager) {
                        manager.remove();
                        renumberManagers();
                        syncMainFlags();
                    }
                }

                function renumberManagers() {
                    const managers = document.querySelectorAll('#managerContainer .manager-section');
                    managers.forEach((manager, index) => {
                        manager.dataset.index = index;
                        const title = manager.querySelector('.manager-title');
                        if (title) {
                            title.textContent = '담당자 ' + (index + 1);
                        }
                        manager.querySelectorAll('[data-field]').forEach(input => {
                            const field = input.dataset.field;
                            input.name = `memberManagers[${index}].${field}`;
                            input.id = `${field}${index}`;
                        });
                        const mainField = manager.querySelector('.main-yn-field');
                        const useField = manager.querySelector('.use-yn-field');
                        if (mainField) {
                            mainField.name = `memberManagers[${index}].mainYn`;
                        }
                        if (useField) {
                            useField.name = `memberManagers[${index}].useYn`;
                        }
                        const radio = manager.querySelector('.main-radio');
                        if (radio) {
                            radio.value = index;
                            radio.name = 'mainManagerIndex';
                        }
                        const removeBtn = manager.querySelector('.remove-manager-btn');
                        if (removeBtn) {
                            removeBtn.classList.toggle('d-none', managers.length === 1 && index === 0);
                        }
                    });
                    if (!document.querySelector('.main-radio:checked') && managers.length > 0) {
                        managers[0].querySelector('.main-radio').checked = true;
                    }
                    managerIndex = managers.length - 1;
                }

                function syncMainFlags() {
                    const selectedMain = document.querySelector('.main-radio:checked');
                    const mainIndex = selectedMain ? selectedMain.value : '0';
                    document.querySelectorAll('#managerContainer .manager-section').forEach(manager => {
                        const mainField = manager.querySelector('.main-yn-field');
                        if (mainField) {
                            mainField.value = manager.dataset.index === mainIndex ? 'Y' : 'N';
                        }
                    });
                }

                function resetForm() {
                    if (confirm('입력한 내용을 모두 취소하시겠습니까?')) {
                        const form = document.querySelector('form[name="memberForm"]');
                        form.reset();
                        form.classList.remove('was-validated');
                        const managers = document.querySelectorAll('#managerContainer .manager-section');
                        managers.forEach((manager, index) => {
                            if (index > 0) {
                                manager.remove();
                            } else {
                                manager.querySelectorAll('input').forEach(input => {
                                    if (input.type !== 'hidden' && input.type !== 'radio' && input.type !== 'checkbox') {
                                        input.value = '';
                                    }
                                });
                                const mainRadio = manager.querySelector('.main-radio');
                                if (mainRadio) {
                                    mainRadio.checked = true;
                                }
                                const mainYnField = manager.querySelector('.main-yn-field');
                                if (mainYnField) {
                                    mainYnField.value = 'Y';
                                }
                                const useYnField = manager.querySelector('.use-yn-field');
                                if (useYnField) {
                                    useYnField.value = 'Y';
                                }
                            }
                        });
                        managerIndex = 0;
                        syncMainFlags();
                    }
                }

                document.querySelector('form[name="memberForm"]').addEventListener('submit', function (e) {
                    syncMainFlags();
                    if (!this.checkValidity()) {
                        e.preventDefault();
                        e.stopPropagation();
                        alert('필수 항목을 입력해주세요.');
                    }
                    this.classList.add('was-validated');
                });
            </script>

            <c:if test="${mode eq 'view'}">
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        document.querySelectorAll('input, select, textarea').forEach(function (el) {
                            el.readOnly = true;
                        });

                        document.querySelectorAll('select, input[type="checkbox"], input[type="radio"]').forEach(function (el) {
                            el.disabled = true;
                        });

                        ['btnSave', 'btnReset', 'btnAddManager'].forEach(function (id) {
                            const button = document.getElementById(id);
                            if (button) {
                                button.style.display = 'none';
                            }
                        });
                    });
                </script>
            </c:if>
