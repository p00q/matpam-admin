<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    .form-container { background: #fff; padding: 20px; border-radius: 8px; }
    .form-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
    .form-table th { background: #f4f7f9; text-align: left; padding: 12px 15px; border: 1px solid #dee2e6; width: 150px; font-weight: 600; }
    .form-table td { padding: 10px 15px; border: 1px solid #dee2e6; }
    .section-title { font-size: 16px; font-weight: 700; margin: 30px 0 15px 0; display: flex; align-items: center; gap: 8px; }
    .section-title::before { content: ""; display: inline-block; width: 4px; height: 16px; background: #2c5f7c; }
    .nav-tabs .nav-link { color: #666; font-weight: 600; padding: 10px 25px; border: 1px solid transparent; border-bottom: 2px solid #dee2e6; }
    .nav-tabs .nav-link.active { color: #2c5f7c; border-color: #dee2e6 #dee2e6 #fff; border-bottom: 2px solid #2c5f7c; background: #fff; }
    .btn-sm-custom { padding: 2px 10px; font-size: 12px; }
    .asset-box { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 4px; padding: 15px; }
    .red-label { color: #d9534f; font-weight: 600; }
    .badge-status { padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
</style>

<div class="container-fluid p-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <c:choose>
            <c:when test="${mode eq 'insert'}">
                <h4 class="fw-bold">회원 신규등록</h4>
            </c:when>
            <c:otherwise>
                <h4 class="fw-bold">회원상세 (${member.memberTypeCd eq 'BUYER' ? '구매자' : (member.memberTypeCd eq 'ADMIN' ? '관리자' : '판매자')})</h4>
            </c:otherwise>
        </c:choose>
        <div class="text-muted small">홈 > 회원관리 > ${mode eq 'insert' ? '회원 신규등록' : '회원상세'}</div>
    </div>

    <!-- Tab Navigation -->
    <ul class="nav nav-tabs mb-4" id="memberTab" role="tablist">
        <li class="nav-item">
            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-info" type="button">회원정보</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-order" type="button">거래정보</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-money" type="button">입출금정보</button>
        </li>
    </ul>

    <form id="memberForm" method="post" action="/admin/member/saveMember.do">
        <input type="hidden" name="memberId" value="${member.memberId}" />
        <input type="hidden" name="mode" value="${mode}" />

        <div class="tab-content">
            <!-- 회원정보 탭 (Screenshot 2) -->
            <div class="tab-pane fade show active" id="tab-info">
                <div class="d-flex justify-content-end mb-2">
                    <button type="button" class="btn btn-secondary btn-sm px-3" onclick="location.href='/admin/member/memberList.do'">목록</button>
                </div>
                
                <div class="form-container border shadow-sm">
                    <table class="form-table">
                        <tr>
                            <th>회원타입</th>
                            <td>
                                <select name="memberTypeCd" id="memberTypeCd" class="form-select form-select-sm w-50" onchange="fn_toggle_member_type(this.value)">
                                    <c:forEach var="code" items="${memberTypes}">
                                        <c:choose>
                                            <c:when test="${mode eq 'insert'}">
                                                <option value="${code.detailCode}" ${fn:trim(code.detailCode) eq 'BUYER' ? 'selected' : ''}>${code.detailCodeName}</option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="${code.detailCode}" ${fn:trim(member.memberTypeCd) eq fn:trim(code.detailCode) ? 'selected' : ''}>${code.detailCodeName}</option>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </select>
                            </td>
                            <th>채널</th>
                            <td>
                                <select name="channelCd" class="form-select form-select-sm w-50">
                                    <c:forEach var="code" items="${channels}">
                                        <option value="${code.detailCode}" ${member.channelCd eq code.detailCode ? 'selected' : ''}>${code.detailCodeName}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th>아이디</th>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="red-label">${member.loginId}</span>
                                    <c:if test="${mode eq 'insert'}">
                                        <input type="text" name="loginId" value="${member.loginId}" class="form-control form-control-sm w-75" />
                                    </c:if>
                                </div>
                            </td>
                            <th>업체명</th>
                            <td><span class="red-label">${member.companyName}</span> <c:if test="${mode eq 'insert'}"><input type="text" name="companyName" value="${member.companyName}" class="form-control form-control-sm w-75 d-inline-block" /></c:if></td>
                        </tr>
                        <tr>
                            <th>비밀번호</th>
                            <td>
                                <input type="password" name="loginPwd" class="form-control form-control-sm w-75" placeholder="${mode eq 'update' ? '변경 시에만 입력' : '비밀번호 입력'}" />
                            </td>
                            <th>비밀번호 확인</th>
                            <td>
                                <input type="password" name="loginPwdConfirm" class="form-control form-control-sm w-75" placeholder="${mode eq 'update' ? '변경 시에만 입력' : '비밀번호 확인'}" />
                            </td>
                        </tr>
                        <tr>
                            <th>사업자등록번호</th>
                            <td><input type="text" name="bizRegNo" value="${member.bizRegNo}" class="form-control form-control-sm w-75" /></td>
                            <th>회원등급</th>
                            <td>
                                <select name="memberGradeCd" class="form-select form-select-sm w-50">
                                    <c:forEach var="code" items="${memberGrades}">
                                        <option value="${code.detailCode}" ${member.memberGradeCd eq code.detailCode ? 'selected' : ''}>${code.detailCodeName}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th>대표자명</th>
                            <td><span class="red-label">${member.ceoName}</span> <c:if test="${mode eq 'insert'}"><input type="text" name="ceoName" value="${member.ceoName}" class="form-control form-control-sm w-75 d-inline-block" /></c:if></td>
                            <th>가입상태</th>
                            <td>
                                <select name="joinStatusCd" class="form-select form-select-sm w-50">
                                    <c:forEach var="code" items="${statusCodes}">
                                        <option value="${code.detailCode}" ${member.joinStatusCd eq code.detailCode ? 'selected' : ''}>${code.detailCodeName}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th>휴대폰번호</th>
                            <td><input type="text" name="ceoMobileNo" value="${member.ceoMobileNo}" class="form-control form-control-sm w-75" /></td>
                            <th>회사 전화번호</th>
                            <td><input type="text" name="companyTelNo" value="${member.companyTelNo}" class="form-control form-control-sm w-75" /></td>
                        </tr>
                        <tr>
                            <th>이메일주소</th>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <input type="email" name="email" value="${member.email}" class="form-control form-control-sm w-75" placeholder="이메일 주소 입력" />
                                    <c:if test="${not empty member.email}">
                                        <a href="mailto:${member.email}" class="btn btn-outline-secondary btn-sm-custom"><i class="bi bi-envelope"></i></a>
                                    </c:if>
                                </div>
                            </td>
                            <th>최근접속시간</th>
                            <td><fmt:formatDate value="${member.lastLoginDt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                        </tr>
                        <tr>
                            <th>주소</th>
                            <td colspan="3">
                                <div class="d-flex align-items-center gap-2">
                                    <input type="text" id="zipCode" name="zipCode" value="${member.zipCode}" class="form-control form-control-sm" style="width: 100px;" readonly />
                                    <input type="text" id="addr1" name="addr1" value="${member.addr1}" class="form-control form-control-sm w-50" readonly />
                                    <button type="button" class="btn btn-secondary btn-sm" onclick="fn_addr_search()">주소찾기</button>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>상세 주소</th>
                            <td colspan="3">
                                <input type="text" name="addr2" value="${member.addr2}" class="form-control form-control-sm w-50" />
                            </td>
                        </tr>
                    </table>

                    <%-- 미트머니: insert=구매자기본=표시, update=BUYER만 표시 --%>
                    <div id="section_meatmoney_info" style="${(mode eq 'insert' or fn:contains(member.memberTypeCd, 'BUYER')) ? '' : 'display:none;'}">
                    <div class="section-title">■ 미트머니 정보 <button type="button" class="btn btn-dark btn-sm float-end ms-auto" style="font-size: 11px;">여신관리</button></div>
                    <div class="row g-0 border">
                        <div class="col-md-6 border-end">
                            <table class="form-table mb-0 border-0">
                                <tr>
                                    <th class="border-0">여신 약정일</th>
                                    <td class="border-0">2024년 10월 11일</td>
                                </tr>
                                <tr>
                                    <th class="border-0 red-label">여신 제공액</th>
                                    <td class="border-0 text-end fw-bold"><fmt:formatNumber value="${member.creditBalanceAmt}" pattern="#,###"/> 원</td>
                                </tr>
                                <tr>
                                    <th class="border-0 red-label">미트머니 잔액</th>
                                    <td class="border-0 text-end fw-bold"><fmt:formatNumber value="${member.meatmoneyBalanceAmt}" pattern="#,###"/> 원</td>
                                </tr>
                                <tr>
                                    <th class="border-0">출금 가능 금액</th>
                                    <td class="border-0 text-end fw-bold text-primary">
                                        <fmt:formatNumber value="${member.meatmoneyBalanceAmt - member.creditBalanceAmt}" pattern="#,###"/> 원
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <table class="form-table mb-0 border-0">
                                <tr>
                                    <th class="border-0">월 누적 주문금액</th>
                                    <td class="border-0 text-end"><fmt:formatNumber value="${member.monthOrderAmt}" pattern="#,###"/> 원</td>
                                </tr>
                                <tr>
                                    <th class="border-0">연 누적 주문금액</th>
                                    <td class="border-0 text-end"><fmt:formatNumber value="${member.yearOrderAmt}" pattern="#,###"/> 원</td>
                                </tr>
                                <tr>
                                    <th class="border-0">총 누적 주문금액</th>
                                    <td class="border-0 text-end fw-bold"><fmt:formatNumber value="${member.totalOrderAmt}" pattern="#,###"/> 원</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    </div><!-- /section_meatmoney_info -->

                    <%-- 판매자 정보: insert=구매자기본=숨김, update=SELLER만 표시 --%>
                    <div id="section_seller_info" style="${fn:contains(member.memberTypeCd, 'SELLER') ? '' : 'display:none;'}">
                        <div class="section-title">■ 판매자 정보</div>
                        <table class="form-table">
                            <tr id="row_seller_type">
                                <th>판매자 유형</th>
                                <td>
                                    <select name="sellerTypeCd" class="form-select form-select-sm w-50">
                                        <c:forEach var="code" items="${sellerTypes}">
                                            <option value="${code.detailCode}" ${member.sellerTypeCd eq code.detailCode ? 'selected' : ''}>${code.detailCodeName}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <th>과세 유형</th>
                                <td>
                                    <select name="taxTypeCd" class="form-select form-select-sm w-50">
                                        <c:forEach var="code" items="${taxTypes}">
                                            <option value="${code.detailCode}" ${member.taxTypeCd eq code.detailCode ? 'selected' : ''}>${code.detailCodeName}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                            </tr>
                            <tr id="row_seller_account">
                                <th>계좌 정보</th>
                                <td colspan="3">
                                    <div class="d-flex gap-2">
                                        <input type="text" name="bankCd" value="${member.bankCd}" class="form-control form-control-sm" style="width: 100px;" placeholder="은행명" />
                                        <input type="text" name="accountNo" value="${member.accountNo}" class="form-control form-control-sm w-25" placeholder="계좌번호" />
                                        <input type="text" name="accountName" value="${member.accountName}" class="form-control form-control-sm w-25" placeholder="예금주" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>

                    <div class="section-title">■ 가입 정보</div>
                    <table class="form-table">
                        <tr>
                            <th>가입일자</th>
                            <td><fmt:formatDate value="${member.joinDt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                            <th>수정일자</th>
                            <td><fmt:formatDate value="${member.modDt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                        </tr>
                        <tr>
                            <th>탈퇴일자</th>
                            <td colspan="3">
                                <div class="d-flex align-items-center gap-3">
                                    <span><fmt:formatDate value="${member.withdrawDt}" pattern="yyyy-MM-dd HH:mm:ss" /></span>
                                    <button type="button" class="btn btn-secondary btn-sm-custom">회원탈퇴</button>
                                </div>
                            </td>
                        </tr>
                    </table>

                    <%-- 담당자: ADMIN만 숨김, insert=구매자기본=표시 --%>
                    <div id="section_contact_info" style="${fn:contains(member.memberTypeCd, 'ADMIN') ? 'display:none;' : ''}">
                    <div class="section-title">
                        ■ 담당자 정보 
                        <div class="form-check ms-3">
                            <input class="form-check-input" type="checkbox" id="chk_same_ceo" onchange="fn_copy_ceo()">
                            <label class="form-check-label small" for="chk_same_ceo">대표자 정보와 동일</label>
                        </div> 
                        <button type="button" id="btn_add_contact" class="btn btn-dark btn-sm ms-2" onclick="fn_add_contact()">생성</button>
                    </div>
                    
                    <div id="contact_1" class="border p-3 mb-3 bg-light rounded">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="fw-bold">담당자 1</span>
                        </div>
                        <table class="form-table mb-0 border-0">
                            <tr>
                                <th class="border-0 bg-transparent">이름</th>
                                <td class="border-0"><input type="text" name="contacts[0].name" value="${member.contacts[0].name}" class="form-control form-control-sm w-50" /></td>
                                <th class="border-0 bg-transparent text-danger">이메일주소</th>
                                <td class="border-0"><input type="email" name="contacts[0].email" value="${member.contacts[0].email}" class="form-control form-control-sm" /></td>
                            </tr>
                            <tr>
                                <th class="border-0 bg-transparent">휴대폰번호</th>
                                <td class="border-0"><input type="text" name="contacts[0].mobileNo" value="${member.contacts[0].mobileNo}" class="form-control form-control-sm w-75 phone-format" /></td>
                                <th class="border-0 bg-transparent">전화번호</th>
                                <td class="border-0"><input type="text" name="contacts[0].phoneNo" value="${member.contacts[0].phoneNo}" class="form-control form-control-sm w-75 phone-format" /></td>
                            </tr>
                        </table>
                    </div>

                    <div id="contact_2" class="border p-3 mb-3 bg-light rounded" style="${empty member.contacts[1].name ? 'display:none;' : ''}">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="fw-bold">담당자 2</span>
                            <button type="button" class="btn btn-secondary btn-sm-custom" onclick="fn_del_contact(2)">삭제</button>
                        </div>
                        <table class="form-table mb-0 border-0">
                            <tr>
                                <th class="border-0 bg-transparent">이름</th>
                                <td class="border-0"><input type="text" name="contacts[1].name" value="${member.contacts[1].name}" class="form-control form-control-sm w-50" /></td>
                                <th class="border-0 bg-transparent text-danger">이메일주소</th>
                                <td class="border-0"><input type="email" name="contacts[1].email" value="${member.contacts[1].email}" class="form-control form-control-sm" /></td>
                            </tr>
                            <tr>
                                <th class="border-0 bg-transparent">휴대폰번호</th>
                                <td class="border-0"><input type="text" name="contacts[1].mobileNo" value="${member.contacts[1].mobileNo}" class="form-control form-control-sm w-75 phone-format" /></td>
                                <th class="border-0 bg-transparent">전화번호</th>
                                <td class="border-0"><input type="text" name="contacts[1].phoneNo" value="${member.contacts[1].phoneNo}" class="form-control form-control-sm w-75 phone-format" /></td>
                            </tr>
                        </table>
                    </div>
                    </div><!-- /section_contact_info -->
                    
                    <div class="d-flex gap-3 mt-4 border-top pt-3">
                        <div class="form-check form-switch"><input class="form-check-input" type="checkbox"><label class="form-check-label small">제3자 정보 제공 동의 여부</label></div>
                        <div class="form-check form-switch"><input class="form-check-input" type="checkbox"><label class="form-check-label small">광고 수신 동의 여부</label></div>
                    </div>
                </div>
                
                <div class="d-flex justify-content-center gap-2 mt-4">
                    <button type="button" class="btn btn-secondary px-4" onclick="location.href='/admin/member/memberList.do'">목록</button>
                    <button type="button" class="btn btn-dark px-4" onclick="fn_save()">${mode eq 'insert' ? '등록' : '저장'}</button>
                    <button type="button" class="btn btn-secondary px-4" onclick="history.back()">취소</button>
                </div>
            </div>

            <!-- 거래정보 탭 (Screenshot 3 Placeholder) -->
            <div class="tab-pane fade" id="tab-order">
                <div class="form-container border shadow-sm p-4">
                    <div class="row text-center mb-4 border py-3 bg-light g-0">
                        <div class="col border-end">총 주문금액<br><span class="fw-bold">5,000,000 원</span></div>
                        <div class="col border-end">총 주문건수<br><span class="fw-bold">55</span></div>
                        <div class="col border-end">총 결제금액<br><span class="fw-bold">9,000,000 원</span></div>
                        <div class="col">미트머니 잔액<br><span class="text-danger fw-bold">4,200,000 원</span></div>
                    </div>
                    <div class="section-title">■ 거래정보</div>
                    <div class="text-center py-5 text-muted border">주문 내역이 존재하지 않습니다.</div>
                </div>
            </div>

            <!-- 입출금정보 탭 (Screenshot 4 Placeholder) -->
            <div class="tab-pane fade" id="tab-money">
                <div class="form-container border shadow-sm p-4">
                    <div class="row text-center mb-4 border py-3 bg-light g-0 small">
                        <div class="col border-end">제공여신액<br><span class="fw-bold">5,000,000 원</span></div>
                        <div class="col border-end">총 입금액<br><span class="fw-bold">8,200,000 원</span></div>
                        <div class="col border-end">총 사용금액<br><span class="text-danger fw-bold">1,000,000 원</span></div>
                        <div class="col border-end">보유 미트머니<br><span class="fw-bold">1,000,000 원</span></div>
                        <div class="col">출금 가능 금액<br><span class="fw-bold">5,000,000 원</span></div>
                    </div>
                    <div class="section-title">■ 거래정보</div>
                    <div class="text-center py-5 text-muted border">거래 내역이 존재하지 않습니다.</div>
                </div>
            </div>
        </div>
    </form>
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    function fn_save() {
        const form = document.getElementById('memberForm');
        const mode = form.mode.value;
        
        // 필수값 체크
        if (mode === 'insert') {
            if (!form.loginId.value) {
                alert('아이디를 입력해주세요.');
                form.loginId.focus();
                return;
            }
            if (!form.companyName.value) {
                alert('업체명을 입력해주세요.');
                form.companyName.focus();
                return;
            }
            if (!form.ceoName.value) {
                alert('대표자명을 입력해주세요.');
                form.ceoName.focus();
                return;
            }
            if (!form.loginPwd.value) {
                alert('비밀번호를 입력해주세요.');
                form.loginPwd.focus();
                return;
            }
        }
        
        // 비밀번호 체크
        if (form.loginPwd.value) {
            if (form.loginPwd.value.length < 4) {
                alert('비밀번호는 최소 4자 이상이어야 합니다.');
                form.loginPwd.focus();
                return;
            }
            if (form.loginPwd.value !== form.loginPwdConfirm.value) {
                alert('비밀번호와 비밀번호 확인이 일치하지 않습니다.');
                form.loginPwdConfirm.focus();
                return;
            }
        }

        if (!form.bizRegNo.value) {
            alert('사업자등록번호를 입력해주세요.');
            form.bizRegNo.focus();
            return;
        }
        
        // 사업자번호 형식 체크 (10자리 숫자)
        const bizRegNo = form.bizRegNo.value.replace(/[^0-9]/g, '');
        if (bizRegNo.length !== 10) {
            alert('사업자등록번호를 정확히 입력해주세요 (10자리 숫자).');
            form.bizRegNo.focus();
            return;
        }
        form.bizRegNo.value = bizRegNo;

        if(confirm('변경 사항을 저장하시겠습니까?')) {
            form.submit();
        }
    }
    
    function fn_addr_search() {
        new daum.Postcode({
            oncomplete: function(data) {
                document.getElementById('zipCode').value = data.zonecode;
                document.getElementById('addr1').value = data.address;
                document.querySelector('input[name="addr2"]').focus();
            }
        }).open();
    }
    
    function fn_copy_ceo() {
        const chk = document.getElementById('chk_same_ceo');
        if(chk.checked) {
            const form = document.getElementById('memberForm');
            // 등록 모드일 때는 input에서, 수정 모드일 때는 span 텍스트에서 가져옴
            const ceoNameInput = document.querySelector('input[name="ceoName"]');
            const ceoName = ceoNameInput ? ceoNameInput.value : (document.querySelector('td:has(input[name="ceoMobileNo"])').parentElement.previousElementSibling.previousElementSibling.querySelector('span.red-label')?.innerText || '');
            
            // 더 정확한 선택자 사용
            const ceoMobile = document.querySelector('input[name="ceoMobileNo"]').value;
            const companyTel = document.querySelector('input[name="companyTelNo"]').value;
            const email = document.querySelector('input[name="email"]').value;
            
            document.querySelector('input[name="contacts[0].name"]').value = ceoName;
            document.querySelector('input[name="contacts[0].mobileNo"]').value = ceoMobile;
            document.querySelector('input[name="contacts[0].phoneNo"]').value = companyTel;
            document.querySelector('input[name="contacts[0].email"]').value = email;
        }
    }

    function fn_add_contact() {
        const contact2 = document.getElementById('contact_2');
        if (contact2.style.display === 'none') {
            contact2.style.display = '';
            document.getElementById('btn_add_contact').disabled = true;
        }
    }

    function fn_del_contact(idx) {
        if (confirm('담당자 ' + idx + ' 정보를 삭제하시겠습니까?')) {
            const div = document.getElementById('contact_' + idx);
            div.style.display = 'none';
            // 필드 초기화
            div.querySelectorAll('input').forEach(input => input.value = '');
            if (idx === 2) {
                document.getElementById('btn_add_contact').disabled = false;
            }
        }
    }

    function fn_toggle_member_type(val) {
        val = (val || '').trim();
        // 미트머니: 구매자만
        document.getElementById('section_meatmoney_info').style.display  = val.includes('BUYER')  ? '' : 'none';
        // 판매자 정보: 판매자만
        document.getElementById('section_seller_info').style.display     = val.includes('SELLER') ? '' : 'none';
        // 담당자: 관리자만 숨김
        document.getElementById('section_contact_info').style.display    = val.includes('ADMIN')  ? 'none' : '';
    }

    // 포맷팅 함수들
    function formatBizNo(str) {
        str = str.replace(/[^0-9]/g, '');
        if (str.length <= 3) return str;
        if (str.length <= 5) return str.replace(/(\d{3})(\d{1,2})/, '$1-$2');
        return str.replace(/(\d{3})(\d{2})(\d{1,5})/, '$1-$2-$3');
    }

    function formatPhone(str) {
        str = str.replace(/[^0-9]/g, '');
        if (str.length < 3) return str;
        
        // 서울 지역번호(02) 처리
        if (str.startsWith('02')) {
            if (str.length <= 2) return str;
            if (str.length <= 5) return str.replace(/(\d{2})(\d{1,3})/, '$1-$2');
            if (str.length <= 9) return str.replace(/(\d{2})(\d{3})(\d{1,4})/, '$1-$2-$3');
            return str.replace(/(\d{2})(\d{4})(\d{4})/, '$1-$2-$3');
        } else {
            if (str.length <= 3) return str;
            if (str.length <= 6) return str.replace(/(\d{3})(\d{1,3})/, '$1-$2');
            if (str.length <= 10) return str.replace(/(\d{3})(\d{3})(\d{1,4})/, '$1-$2-$3');
            return str.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
        }
    }

    // 숫자만 입력 및 포맷팅 이벤트 바인딩
    document.addEventListener('DOMContentLoaded', function() {
        // 초기 회원타입에 따른 섹션 표시/숨김
        var memberTypeSelect = document.getElementById('memberTypeCd');
        if (memberTypeSelect) {
            fn_toggle_member_type(memberTypeSelect.value);
        }

        // 사업자번호 포맷팅
        const bizInput = document.querySelector('input[name="bizRegNo"]');
        if (bizInput) {
            bizInput.addEventListener('input', function() {
                this.value = formatBizNo(this.value);
            });
            bizInput.value = formatBizNo(bizInput.value);
        }

        // 전화번호 포맷팅
        const phoneInputs = document.querySelectorAll('input[name="ceoMobileNo"], input[name="companyTelNo"], .phone-format');
        phoneInputs.forEach(input => {
            input.addEventListener('input', function() {
                this.value = formatPhone(this.value);
            });
            input.value = formatPhone(input.value);
        });

        // 에러 메시지 처리
        <c:if test="${not empty errorMessage}">
            alert('${errorMessage}');
        </c:if>

        // 담당자 2가 보이고 있으면 생성 버튼 비활성화
        if (document.getElementById('contact_2') && document.getElementById('contact_2').style.display !== 'none') {
            document.getElementById('btn_add_contact').disabled = true;
        }
    });
</script>