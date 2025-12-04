<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

                <form name="memberForm" method="post" action="<c:url value='/admin/member/insertMember.do'/>">
                    <input type="hidden" name="menu" value="member" />
                    <input type="hidden" name="joinDate" value="${currentDate}" />
                    <input type="hidden" name="creditLimit" value="0" />
                    <input type="hidden" name="meatMoney" value="0" />

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
                                            <select name="memberType" class="form-select form-select-sm"
                                                style="max-width: 200px;" required>
                                                <option value="" disabled selected>회원타입 선택</option>
                                                <c:forEach var="type" items="${memberTypes}">
                                                    <option value="${type.detailCode}">${type.detailCodeName}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <th>지역</th>
                                        <td>
                                            <select name="region" class="form-select form-select-sm"
                                                style="max-width: 200px;">
                                                <option value="">전체</option>
                                                <option value="SEOUL">서울</option>
                                                <option value="GYEONGGI">경기</option>
                                                <option value="INCHEON">인천</option>
                                                <option value="GANGWON">강원</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>아이디 <span class="text-danger">*</span></th>
                                        <td>
                                            <input type="text" name="memberId" class="form-control form-control-sm"
                                                required />
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
                                                class="form-control form-control-sm" />
                                        </td>
                                        <th>사업자등록번호</th>
                                        <td>
                                            <input type="text" name="businessNumber"
                                                class="form-control form-control-sm" placeholder="000-00-00000"
                                                maxlength="12" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>회원등급</th>
                                        <td>
                                            <select name="memberGrade" class="form-select form-select-sm"
                                                style="max-width: 200px;">
                                                <c:forEach var="grade" items="${memberGrades}">
                                                    <option value="${grade.detailCode}">${grade.detailCodeName}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <th>대표자명</th>
                                        <td>
                                            <input type="text" name="ceoName" class="form-control form-control-sm" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>가입상태</th>
                                        <td>
                                            <select name="status" class="form-select form-select-sm"
                                                style="max-width: 200px;">
                                                <c:forEach var="statusItem" items="${statusCodes}">
                                                    <option value="${statusItem.detailCode}">
                                                        ${statusItem.detailCodeName}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <th>연락처 <span class="text-danger">*</span></th>
                                        <td>
                                            <input type="tel" name="contactNumber" class="form-control form-control-sm"
                                                placeholder="010-0000-0000" maxlength="13" required />
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>회사 전화번호</th>
                                        <td>
                                            <input type="text" name="companyPhone" class="form-control form-control-sm"
                                                placeholder="02-0000-0000" maxlength="13" />
                                        </td>
                                        <th>이메일주소</th>
                                        <td>
                                            <input type="email" name="email" class="form-control form-control-sm" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>주소</th>
                                        <td colspan="3">
                                            <div class="d-flex gap-2 mb-2">
                                                <input type="text" id="postcode" name="postcode"
                                                    class="form-control form-control-sm" placeholder="우편번호" readonly
                                                    style="max-width: 150px;" />
                                                <button type="button" class="btn btn-secondary btn-sm"
                                                    onclick="execDaumPostcode()">주소검색</button>
                                            </div>
                                            <input type="text" id="address" name="address"
                                                class="form-control form-control-sm mb-2" placeholder="주소" readonly />
                                            <input type="text" name="addressDetail" class="form-control form-control-sm"
                                                placeholder="상세주소" />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>

                            <div class="section-header">
                                ■ 담당자 정보
                                <button type="button" class="btn btn-sm btn-primary float-end"
                                    onclick="addManager()">생성</button>
                                <div class="form-check form-check-inline float-end me-2">
                                    <input class="form-check-input" type="checkbox" id="sameAsMember"
                                        onchange="copySameAsMember()">
                                    <label class="form-check-label" for="sameAsMember">회원정보와 동일</label>
                                </div>
                            </div>

                            <div id="managerContainer">
                                <!-- 담당자 1 -->
                                <div class="manager-section" id="manager1">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <strong>담당자 1</strong>
                                    </div>
                                    <table class="table table-bordered form-table mb-0">
                                        <tbody>
                                            <tr>
                                                <th>이름</th>
                                                <td>
                                                    <input type="text" name="managerName" id="managerName"
                                                        class="form-control form-control-sm" />
                                                </td>
                                                <th>전화번호</th>
                                                <td>
                                                    <input type="tel" name="managerContact" id="managerContact"
                                                        class="form-control form-control-sm" placeholder="010-0000-0000"
                                                        maxlength="13" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>휴대전화번호</th>
                                                <td>
                                                    <input type="tel" name="managerMobile1" id="managerMobile1"
                                                        class="form-control form-control-sm" placeholder="010-0000-0000"
                                                        maxlength="13" />
                                                </td>
                                                <th>이메일주소</th>
                                                <td>
                                                    <input type="email" name="managerEmail1" id="managerEmail1"
                                                        class="form-control form-control-sm" />
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <div class="section-header">■ 정보 동의 여부</div>
                            <div class="p-3">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" name="agreeMarketing"
                                        id="agreeMarketing" value="Y">
                                    <label class="form-check-label" for="agreeMarketing">광고성 정보 수신 여부</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" name="agreeSms" id="agreeSms"
                                        value="Y">
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
                        <button type="submit" class="btn btn-primary px-4">등록</button>
                        <button type="button" class="btn btn-danger px-4" onclick="resetForm()">취소</button>
                    </div>
                </form>
            </div>

            <!-- Daum Postcode API -->
            <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

            <script>
                let managerCount = 1;

                // 전화번호 자동 하이픈 추가
                document.addEventListener('DOMContentLoaded', function () {
                    const phoneInputs = document.querySelectorAll('input[type="tel"], input[name="businessNumber"], input[name="contactNumber"], input[name="companyPhone"]');
                    phoneInputs.forEach(input => {
                        input.addEventListener('input', function (e) {
                            let value = e.target.value.replace(/[^0-9]/g, '');
                            let formattedValue = '';

                            if (e.target.name === 'businessNumber') {
                                // 사업자등록번호: 000-00-00000
                                if (value.length <= 3) {
                                    formattedValue = value;
                                } else if (value.length <= 5) {
                                    formattedValue = value.slice(0, 3) + '-' + value.slice(3);
                                } else {
                                    formattedValue = value.slice(0, 3) + '-' + value.slice(3, 5) + '-' + value.slice(5, 10);
                                }
                            } else {
                                // 전화번호: 010-0000-0000 또는 02-0000-0000
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
                });

                // Daum 주소 검색
                function execDaumPostcode() {
                    new daum.Postcode({
                        oncomplete: function (data) {
                            document.getElementById('postcode').value = data.zonecode;
                            document.getElementById('address').value = data.address;
                            document.querySelector('input[name="addressDetail"]').focus();
                        }
                    }).open();
                }

                // 회원정보와 동일
                function copySameAsMember() {
                    const checked = document.getElementById('sameAsMember').checked;
                    if (checked) {
                        document.getElementById('managerName').value = document.querySelector('input[name="ceoName"]').value;
                        document.getElementById('managerContact').value = document.querySelector('input[name="contactNumber"]').value;
                        document.getElementById('managerMobile1').value = document.querySelector('input[name="contactNumber"]').value;
                        document.getElementById('managerEmail1').value = document.querySelector('input[name="email"]').value;
                    } else {
                        document.getElementById('managerName').value = '';
                        document.getElementById('managerContact').value = '';
                        document.getElementById('managerMobile1').value = '';
                        document.getElementById('managerEmail1').value = '';
                    }
                }

                // 담당자 추가
                function addManager() {
                    managerCount++;
                    const container = document.getElementById('managerContainer');
                    const newManager = document.createElement('div');
                    newManager.className = 'manager-section';
                    newManager.id = 'manager' + managerCount;

                    let html = '';
                    html += '<div class="d-flex justify-content-between align-items-center mb-2">';
                    html += '    <strong>담당자 ' + managerCount + '</strong>';
                    html += '    <button type="button" class="btn btn-sm btn-danger" onclick="removeManager(' + managerCount + ')">삭제</button>';
                    html += '</div>';
                    html += '<table class="table table-bordered form-table mb-0">';
                    html += '    <tbody>';
                    html += '        <tr>';
                    html += '            <th style="width: 15%;">이름</th>';
                    html += '            <td style="width: 35%;">';
                    html += '                <input type="text" name="managerName' + managerCount + '" class="form-control form-control-sm"/>';
                    html += '            </td>';
                    html += '            <th style="width: 15%;">전화번호</th>';
                    html += '            <td style="width: 35%;">';
                    html += '                <input type="tel" name="managerPhone' + managerCount + '" class="form-control form-control-sm" placeholder="010-0000-0000" maxlength="13"/>';
                    html += '            </td>';
                    html += '        </tr>';
                    html += '        <tr>';
                    html += '            <th>휴대전화번호</th>';
                    html += '            <td>';
                    html += '                <input type="tel" name="managerMobile' + managerCount + '" class="form-control form-control-sm" placeholder="010-0000-0000" maxlength="13"/>';
                    html += '            </td>';
                    html += '            <th>이메일주소</th>';
                    html += '            <td>';
                    html += '                <input type="email" name="managerEmail' + managerCount + '" class="form-control form-control-sm"/>';
                    html += '            </td>';
                    html += '        </tr>';
                    html += '    </tbody>';
                    html += '</table>';

                    newManager.innerHTML = html;
                    container.appendChild(newManager);

                    // 새로 추가된 전화번호 입력 필드에도 이벤트 리스너 추가
                    const newPhoneInputs = newManager.querySelectorAll('input[type="tel"]');
                    newPhoneInputs.forEach(input => {
                        input.addEventListener('input', function (e) {
                            let value = e.target.value.replace(/[^0-9]/g, '');
                            let formattedValue = '';

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

                            e.target.value = formattedValue;
                        });
                    });
                }

                // 담당자 삭제
                function removeManager(num) {
                    const manager = document.getElementById('manager' + num);
                    if (manager) {
                        manager.remove();
                    }
                }

                // 폼 초기화
                function resetForm() {
                    if (confirm('입력한 내용을 모두 취소하시겠습니까?')) {
                        document.querySelector('form[name="memberForm"]').reset();
                        document.querySelector('form[name="memberForm"]').classList.remove('was-validated');
                        // 담당자 2 이상 모두 삭제
                        const managers = document.querySelectorAll('.manager-section');
                        managers.forEach((manager, index) => {
                            if (index > 0) {
                                manager.remove();
                            }
                        });
                        managerCount = 1;
                    }
                }

                // Form validation
                document.querySelector('form[name="memberForm"]').addEventListener('submit', function (e) {
                    if (!this.checkValidity()) {
                        e.preventDefault();
                        e.stopPropagation();
                        alert('필수 항목을 입력해주세요.');
                    }
                    this.classList.add('was-validated');
                });
            </script>