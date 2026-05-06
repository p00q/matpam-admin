<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<div class="container-fluid px-4">
    <h1 class="mt-4">업체 ${empty company.companyId ? '등록' : '수정'}</h1>
    <ol class="breadcrumb mb-4">
        <li class="breadcrumb-item"><a href="<c:url value='/admin/dashboard/main.do'/>">대시보드</a></li>
        <li class="breadcrumb-item"><a href="<c:url value='/admin/company/companyList.do'/>">업체 관리</a></li>
        <li class="breadcrumb-item active">업체 ${empty company.companyId ? '등록' : '수정'}</li>
    </ol>

    <div class="card mb-4 shadow-sm">
        <div class="card-header bg-white py-3">
            <i class="fas fa-edit me-1"></i> 업체 기본 정보
        </div>
        <div class="card-body">
            <form:form modelAttribute="company" id="detailForm" name="detailForm">
                <form:hidden path="companyId" />
                <form:hidden path="tenantId" value="1" /> <!-- 임시 고정 -->

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">업체명 <span class="text-danger">*</span></label>
                        <form:input path="companyName" class="form-control" placeholder="상호명을 입력하세요" />
                    </div>
                    <c:if test="${company.companyId gt 0}">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">업체 타입 <span class="text-danger">*</span></label>
                        <form:hidden path="companyType" />
                        <form:select path="companyType" class="form-select bg-light" disabled="true">
                            <form:option value="SELLER" label="판매업체 (Seller)" />
                            <form:option value="BUYER" label="구매업체 (Buyer)" />
                        </form:select>
                    </div>
                    </c:if>
                    <c:if test="${empty company.companyId or company.companyId eq 0}">
                        <form:hidden path="companyType" />
                    </c:if>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">사업자 등록 번호 <span class="text-danger">*</span></label>
                        <form:input path="businessNo" class="form-control" placeholder="000-00-00000" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">대표자명 <span class="text-danger">*</span></label>
                        <form:input path="ceoName" class="form-control" />
                    </div>
                </div>

                <div class="row mb-3" id="sellerTypeArea" style="${company.companyType == 'SELLER' ? '' : 'display:none;'}">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">판매업체 유형 <span class="text-danger">*</span></label>
                        <form:select path="sellerType" class="form-select">
                            <form:option value="RAW" label="원물 (Raw)" />
                            <form:option value="PROCESSED" label="가공 (Processed)" />
                            <form:option value="FINISHED" label="완제품 (Finished)" />
                        </form:select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">과세 구분 <span class="text-danger">*</span></label>
                        <div class="pt-2">
                            <div class="form-check form-check-inline">
                                <form:radiobutton path="defaultTaxType" value="TAXABLE" id="taxable" class="form-check-input" />
                                <label class="form-check-label" for="taxable">과세</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <form:radiobutton path="defaultTaxType" value="TAX_FREE" id="taxFree" class="form-check-input" />
                                <label class="form-check-label" for="taxFree">면세</label>
                            </div>
                        </div>
                    </div>
                </div>

                <hr class="my-4">

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label fw-bold">전화번호</label>
                        <form:input path="phone" class="form-control" placeholder="02-000-0000" />
                    </div>
                    <div class="col-md-8">
                        <label class="form-label fw-bold">이메일</label>
                        <form:input path="email" type="email" class="form-control" placeholder="example@domain.com" />
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-12">
                        <label class="form-label fw-bold">주소</label>
                        <div class="input-group mb-2" style="width: 300px;">
                            <form:input path="postalCode" class="form-control" placeholder="우편번호" readonly="true" />
                            <button class="btn btn-outline-secondary" type="button" onclick="fn_searchAddr()">주소 검색</button>
                        </div>
                        <form:input path="address1" class="form-control mb-2" placeholder="기본 주소" readonly="true" />
                        <form:input path="address2" class="form-control" placeholder="상세 주소" />
                    </div>
                </div>

                <hr class="my-4">

                <!-- 담당자 관리 섹션 -->
                <div class="mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0 text-primary"><i class="bi bi-people-fill me-2"></i>담당자 관리</h5>
                        <button type="button" class="btn btn-sm btn-outline-primary" onclick="fn_addContact()">
                            <i class="bi bi-person-plus me-1"></i> 담당자 추가
                        </button>
                    </div>
                    
                    <div class="table-responsive border rounded shadow-sm bg-white">
                        <table class="table table-hover align-middle mb-0" id="contactTable">
                            <thead class="bg-light">
                                <tr>
                                    <th class="ps-3">성명</th>
                                    <th>역할</th>
                                    <th>연락처</th>
                                    <th>이메일</th>
                                    <th class="text-center">대표</th>
                                    <th class="text-center">상태</th>
                                    <th class="text-center" style="width: 100px;">관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="contact" items="${company.contactList}">
                                    <tr>
                                        <td class="ps-3 fw-bold">${contact.contactName}</td>
                                        <td>
                                            <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25 px-2">
                                                ${contact.contactRole}
                                            </span>
                                        </td>
                                        <td>${contact.mobile}</td>
                                        <td>${contact.email}</td>
                                        <td class="text-center">
                                            <c:if test="${contact.isPrimary == 'Y'}">
                                                <i class="bi bi-check-circle-fill text-primary"></i>
                                            </c:if>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge ${contact.status == 'ACTIVE' ? 'bg-success' : 'bg-danger'} rounded-pill">
                                                ${contact.status == 'ACTIVE' ? '정상' : '중지'}
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <button type="button" class="btn btn-sm btn-link text-danger p-0" onclick="fn_deleteContact(${contact.contactId})">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty company.contactList}">
                                    <tr>
                                        <td colspan="7" class="text-center py-4 text-muted">등록된 담당자가 없습니다.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">상태</label>
                        <div>
                            <div class="form-check form-check-inline">
                                <form:radiobutton path="status" value="ACTIVE" id="statusActive" class="form-check-input" />
                                <label class="form-check-label" for="statusActive">활성</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <form:radiobutton path="status" value="INACTIVE" id="statusInactive" class="form-check-input" />
                                <label class="form-check-label" for="statusInactive">비활성</label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 미트머니(여신/선수금) 관리 섹션 (구매업체 전용) -->
                <c:if test="${company.companyType == 'BUYER'}">
                    <hr class="my-4">
                    <div class="mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold mb-0 text-success"><i class="bi bi-wallet2 me-2"></i>미트머니(Meat Money) 관리</h5>
                        </div>
                        <div class="row gx-3">
                            <div class="col-md-4">
                                <div class="card bg-light border-0 shadow-sm text-center p-3">
                                    <div class="small text-muted mb-1">가용 여신 (Credit)</div>
                                    <div class="h4 fw-bold mb-0" id="currentCredit">0 원</div>
                                    <button type="button" class="btn btn-sm btn-outline-success mt-2" onclick="fn_openCreditModal()">여신 조정</button>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card bg-light border-0 shadow-sm text-center p-3">
                                    <div class="small text-muted mb-1">선수금 잔액 (Advance)</div>
                                    <div class="h4 fw-bold mb-0" id="currentAdvance">0 원</div>
                                    <button type="button" class="btn btn-sm btn-outline-info mt-2" onclick="fn_openAdvanceModal()">선수금 입금</button>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card bg-success bg-opacity-10 border-0 shadow-sm text-center p-3">
                                    <div class="small text-success fw-bold mb-1">총 가용 미트머니</div>
                                    <div class="h3 fw-bold text-success mb-0" id="totalMeatMoney">0 원</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>

                <div class="mt-4 pt-3 border-top d-flex justify-content-between">
                    <a href="<c:url value='/admin/company/companyList.do'/>" class="btn btn-outline-secondary px-4">
                        <i class="fas fa-list me-1"></i> 목록으로
                    </a>
                    <button type="submit" class="btn btn-primary px-5" id="btnSave">
                        <i class="fas fa-save me-1"></i> 저장하기
                    </button>
                </div>
            </form:form>
        </div>
    </div>
</div>

<!-- 여신 조정 모달 -->
<div class="modal fade" id="creditModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title fw-bold">여신 한도 조정</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <form id="creditForm">
                    <input type="hidden" name="companyId" value="${company.companyId}">
                    <div class="mb-3">
                        <label class="form-label fw-bold">조정 금액 (+/- 가능) <span class="text-danger">*</span></label>
                        <input type="number" name="amount" id="credit_amount" class="form-control" placeholder="예: 1000000" required>
                        <div class="form-text">증액은 양수(+), 감액은 음수(-)로 입력하세요.</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">사유 <span class="text-danger">*</span></label>
                        <input type="text" name="memo" id="credit_memo" class="form-control" placeholder="조정 사유를 입력하세요" required>
                    </div>
                </form>
            </div>
            <div class="modal-footer bg-light border-0">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-success" onclick="fn_saveCredit()">조정 반영</button>
            </div>
        </div>
    </div>
</div>

<!-- 선수금 입금 모달 -->
<div class="modal fade" id="advanceModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title fw-bold">선수금(예치금) 입금 처리</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <form id="advanceForm">
                    <input type="hidden" name="companyId" value="${company.companyId}">
                    <div class="mb-3">
                        <label class="form-label fw-bold">입금 금액 <span class="text-danger">*</span></label>
                        <input type="number" name="amount" id="advance_amount" class="form-control" placeholder="예: 500000" required min="1">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">입금 사유/비고 <span class="text-danger">*</span></label>
                        <input type="text" name="memo" id="advance_memo" class="form-control" placeholder="예: 무통장 입금 확인" required>
                    </div>
                </form>
            </div>
            <div class="modal-footer bg-light border-0">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-info text-white" onclick="fn_saveAdvance()">입금 완료</button>
            </div>
        </div>
    </div>
</div>

<!-- 담당자 등록/수정 모달 -->
<div class="modal fade" id="contactModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title fw-bold">담당자 등록</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <form id="contactForm">
                    <input type="hidden" name="companyId" value="${company.companyId}">
                    <input type="hidden" name="contactId" id="modal_contactId">
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">성명 <span class="text-danger">*</span></label>
                        <input type="text" name="contactName" id="modal_contactName" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">역할 <span class="text-danger">*</span></label>
                        <select name="contactRole" id="modal_contactRole" class="form-select" required>
                            <option value="ADMIN">관리 (Admin)</option>
                            <option value="SALES">영업 (Sales)</option>
                            <option value="TAX">세무/정산 (Tax)</option>
                            <option value="SHIPPING">물류/배송 (Logistics)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">휴대폰 번호 <span class="text-danger">*</span></label>
                        <input type="text" name="mobile" id="modal_mobile" class="form-control" placeholder="010-0000-0000" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">이메일</label>
                        <input type="email" name="email" id="modal_email" class="form-control" placeholder="example@domain.com">
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" name="isPrimary" value="Y" id="modal_isPrimary" class="form-check-input">
                        <label class="form-check-label" for="modal_isPrimary">대표 담당자로 설정</label>
                    </div>
                </form>
            </div>
            <div class="modal-footer bg-light border-0">
                <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary px-4" onclick="fn_saveContact()">저장하기</button>
            </div>
        </div>
    </div>
</div>

<!-- 다음 주소 API (필요시) -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
// --- Global Functions ---
window.fn_save = function(e, callback) {
    if (e) e.preventDefault();
    console.log("DEBUG: fn_save initiated");
    
    const form = document.getElementById('detailForm');
    
    if (!form.companyName.value) { alert("업체명을 입력하세요."); return; }
    if (!form.businessNo.value) { alert("사업자 등록 번호를 입력하세요."); return; }
    if (!form.ceoName.value) { alert("대표자명을 입력하세요."); return; }

    if (!callback && !confirm('저장하시겠습니까?')) return;

    const $form = jQuery(form);
    const disabled = $form.find(':input:disabled').removeAttr('disabled');
    const formData = $form.serialize();
    disabled.attr('disabled', 'disabled');

    console.log("DEBUG: Sending AJAX request...");
    jQuery.ajax({
        url: '<c:url value="/admin/company/saveCompany.ajax"/>',
        type: 'POST',
        data: formData,
        success: function(res) {
            console.log("DEBUG: Save success", res);
            if (res.success) {
                if (callback) {
                    alert('업체 정보가 저장되었습니다. 이제 담당자를 등록할 수 있습니다.');
                    location.href = '<c:url value="/admin/company/companyForm.do"/>?companyId=' + res.companyId;
                } else {
                    alert('정상적으로 저장되었습니다.');
                    location.href = '<c:url value="/admin/company/companyList.do"/>?companyType=' + jQuery('#companyType').val();
                }
            } else {
                alert('저장 실패: ' + res.message);
            }
        },
        error: function(xhr) {
            console.error("DEBUG: Save error", xhr);
            alert('통신 중 오류가 발생했습니다.');
        }
    });
};

window.fn_addContact = function() {
    const companyId = "${company.companyId}";
    if (!companyId || companyId === "0") {
        if (confirm("담당자를 등록하려면 업체 정보를 먼저 저장해야 합니다. 지금 저장하시겠습니까?")) {
            fn_save(null, true); // callback mode
        }
        return;
    }
    jQuery('#modal_contactId').val('');
    jQuery('#contactForm')[0].reset();
    jQuery('#contactModal').modal('show');
};

window.fn_formatBusinessNo = function(str) {
    if (!str) return str;
    str = str.replace(/[^0-9]/g, '');
    if (str.length <= 3) return str;
    if (str.length <= 5) return str.substr(0, 3) + '-' + str.substr(3);
    return str.substr(0, 3) + '-' + str.substr(3, 2) + '-' + str.substr(5, 5);
};

window.fn_formatPhone = function(str) {
    if (!str) return str;
    str = str.replace(/[^0-9]/g, '');
    if (str.length <= 3) return str;
    if (str.startsWith('02')) {
        if (str.length <= 5) return str.substr(0, 2) + '-' + str.substr(2);
        if (str.length <= 9) return str.substr(0, 2) + '-' + str.substr(2, 3) + '-' + str.substr(5);
        return str.substr(0, 2) + '-' + str.substr(2, 4) + '-' + str.substr(6, 4);
    } else {
        if (str.length <= 6) return str.substr(0, 3) + '-' + str.substr(3);
        if (str.length <= 10) return str.substr(0, 3) + '-' + str.substr(3, 3) + '-' + str.substr(6);
        return str.substr(0, 3) + '-' + str.substr(3, 4) + '-' + str.substr(7, 4);
    }
};

// --- Initialization ---
function fn_init_listeners() {
    if (typeof jQuery === 'undefined') {
        setTimeout(fn_init_listeners, 100);
        return;
    }
    
    jQuery(document).ready(function() {
        const $ = jQuery;
        
        // Auto-formatters
        $('#businessNo').on('keyup', function() { $(this).val(fn_formatBusinessNo($(this).val())); });
        $('#phone, #modal_mobile').on('keyup', function() { $(this).val(fn_formatPhone($(this).val())); });

        // Auto Tax Logic
        $('#sellerType').on('change', function() {
            const type = $(this).val();
            if (type === 'RAW') $('#taxFree').prop('checked', true);
            else if (type === 'PROCESSED' || type === 'FINISHED') $('#taxable').prop('checked', true);
        });

        // Form Submit
        $('#detailForm').on('submit', function(e) {
            fn_save(e);
        });
        
        // Load Financials
        if ("${company.companyId gt 0 && company.companyType eq 'BUYER'}" == "true") {
            fn_loadMeatMoney();
        }
    });
}

// Global Financial & Other Utils
window.fn_saveContact = function() {
    jQuery.ajax({
        url: '<c:url value="/admin/company/saveContact.ajax"/>',
        type: 'POST',
        data: jQuery('#contactForm').serialize(),
        success: function(res) {
            if (res.success) { alert('담당자가 저장되었습니다.'); location.reload(); }
            else alert('오류: ' + res.message);
        }
    });
};

window.fn_deleteContact = function(contactId) {
    if (!confirm('삭제하시겠습니까?')) return;
    jQuery.ajax({
        url: '<c:url value="/admin/company/deleteContact.ajax"/>',
        type: 'POST',
        data: { contactId: contactId },
        success: function(res) {
            if (res.success) location.reload();
            else alert('오류: ' + res.message);
        }
    });
};

window.fn_searchAddr = function() {
    new daum.Postcode({
        oncomplete: function(data) {
            document.getElementById('postalCode').value = data.zonecode;
            document.getElementById('address1').value = data.address;
            document.getElementById('address2').focus();
        }
    }).open();
};

window.fn_loadMeatMoney = function() {
    jQuery.ajax({
        url: '<c:url value="/admin/financial/getMeatMoney.ajax"/>',
        type: 'GET',
        data: { companyId: "${company.companyId}" },
        success: function(res) {
            if (res.success) {
                jQuery('#currentCredit').text(Number(res.credit).toLocaleString() + " 원");
                jQuery('#currentAdvance').text(Number(res.advance).toLocaleString() + " 원");
                jQuery('#totalMeatMoney').text(Number(res.total).toLocaleString() + " 원");
            }
        }
    });
};

window.fn_openCreditModal = function() {
    jQuery('#creditForm')[0].reset();
    jQuery('#creditModal').modal('show');
};

window.fn_saveCredit = function() {
    const form = document.getElementById('creditForm');
    if (!form.checkValidity()) { form.reportValidity(); return; }
    if (!confirm('여신 한도를 조정하시겠습니까?')) return;

    jQuery.ajax({
        url: '<c:url value="/admin/financial/adjustCredit.ajax"/>',
        type: 'POST',
        data: jQuery(form).serialize(),
        success: function(res) {
            if (res.success) {
                alert('여신이 조정되었습니다.');
                jQuery('#creditModal').modal('hide');
                fn_loadMeatMoney();
            } else {
                alert('오류: ' + res.message);
            }
        }
    });
};

window.fn_openAdvanceModal = function() {
    jQuery('#advanceForm')[0].reset();
    jQuery('#advanceModal').modal('show');
};

window.fn_saveAdvance = function() {
    const form = document.getElementById('advanceForm');
    if (!form.checkValidity()) { form.reportValidity(); return; }
    if (!confirm('선수금 입금을 처리하시겠습니까?')) return;

    jQuery.ajax({
        url: '<c:url value="/admin/financial/depositAdvance.ajax"/>',
        type: 'POST',
        data: jQuery(form).serialize(),
        success: function(res) {
            if (res.success) {
                alert('입금 처리가 완료되었습니다.');
                jQuery('#advanceModal').modal('hide');
                fn_loadMeatMoney();
            } else {
                alert('오류: ' + res.message);
            }
        }
    });
};

fn_init_listeners();
</script>
