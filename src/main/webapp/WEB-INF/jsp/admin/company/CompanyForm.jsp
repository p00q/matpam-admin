<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<div class="container-fluid px-4">
    <h1 class="mt-4">업체 ${empty company.companyId ? '등록' : '수정'}</h1>
    <ol class="breadcrumb mb-4">
        <li class="breadcrumb-item"><a href="/admin/dashboard/main.do">대시보드</a></li>
        <li class="breadcrumb-item"><a href="/admin/company/companyList.do">업체 관리</a></li>
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
                        <form:input path="companyName" class="form-control" placeholder="상호명을 입력하세요" required="true" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">업체 타입 <span class="text-danger">*</span></label>
                        <form:select path="companyType" class="form-select" required="true">
                            <form:option value="SELLER" label="판매업체 (Seller)" />
                            <form:option value="BUYER" label="구매업체 (Buyer)" />
                        </form:select>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">사업자 등록 번호 <span class="text-danger">*</span></label>
                        <form:input path="businessNo" class="form-control" placeholder="000-00-00000" required="true" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">대표자명 <span class="text-danger">*</span></label>
                        <form:input path="ceoName" class="form-control" required="true" />
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

                <div class="mt-4 pt-3 border-top d-flex justify-content-between">
                    <a href="/admin/company/companyList.do" class="btn btn-outline-secondary px-4">
                        <i class="fas fa-list me-1"></i> 목록으로
                    </a>
                    <button type="button" class="btn btn-primary px-5" onclick="fn_save()">
                        <i class="fas fa-save me-1"></i> 저장하기
                    </button>
                </div>
            </form:form>
        </div>
    </div>
</div>

<!-- 다음 주소 API (필요시) -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
function fn_searchAddr() {
    new daum.Postcode({
        oncomplete: function(data) {
            document.getElementById('postalCode').value = data.zonecode;
            document.getElementById('address1').value = data.address;
            document.getElementById('address2').focus();
        }
    }).open();
}

function fn_save() {
    const form = document.getElementById('detailForm');
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    if (!confirm('저장하시겠습니까?')) return;

    const formData = $(form).serialize();
    $.ajax({
        url: '/admin/company/saveCompany.ajax',
        type: 'POST',
        data: formData,
        success: function(res) {
            if (res.success) {
                alert('정상적으로 저장되었습니다.');
                location.href = '/admin/company/companyList.do';
            } else {
                alert('저장 실패: ' + res.message);
            }
        },
        error: function() {
            alert('통신 중 오류가 발생했습니다.');
        }
    });
}
</script>
