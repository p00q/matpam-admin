<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<div class="container-fluid px-4">
    <h1 class="mt-4">회원 계정 등록</h1>
    <ol class="breadcrumb mb-4">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard/main.do">대시보드</a></li>
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/member/memberList.do">회원 관리</a></li>
        <li class="breadcrumb-item active">계정 등록</li>
    </ol>

    <div class="card mb-4 shadow-sm border-0 rounded-3">
        <div class="card-header bg-white py-3 border-bottom-0">
            <h5 class="card-title mb-0 fw-bold text-primary">
                <i class="fas fa-user-plus me-2"></i>기본 계정 정보
            </h5>
        </div>
        <div class="card-body">
            <form id="regForm" name="regForm">
                <!-- 테넌트 선택 (멀티테넌트 지원) -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">소속 테넌트(플랫폼) <span class="text-danger">*</span></label>
                        <select name="tenantId" id="tenantId" class="form-select form-select-lg shadow-sm border-2" required>
                            <option value="">-- 테넌트 선택 --</option>
                            <c:forEach var="tenant" items="${tenantList}">
                                <option value="${tenant.id}">${tenant.name}</option>
                            </c:forEach>
                        </select>
                        <div class="form-text text-muted">사용자가 소속될 플랫폼 본사를 선택하세요.</div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">사용자 권한 <span class="text-danger">*</span></label>
                        <select name="userRole" id="userRole" class="form-select form-select-lg shadow-sm border-2" required>
                            <option value="">-- 권한 선택 --</option>
                            <option value="SUPER_ADMIN">슈퍼 관리자 (플랫폼 전체)</option>
                            <option value="SELLER_ADMIN">판매자 관리자 (본사)</option>
                            <option value="CHANNEL_ADMIN">채널 담당자 (물류/채널)</option>
                            <option value="BUYER_ADMIN">구매자 관리자 (거래처)</option>
                        </select>
                    </div>
                </div>

                <div class="row mb-4">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">로그인 ID <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-2"><i class="fas fa-id-badge"></i></span>
                            <input type="text" name="loginId" id="loginId" class="form-control form-control-lg border-2" placeholder="아이디를 입력하세요" required>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">비밀번호 <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-2"><i class="fas fa-lock"></i></span>
                            <input type="password" name="passwordHash" id="passwordHash" class="form-control form-control-lg border-2" placeholder="초기 비밀번호" required>
                        </div>
                    </div>
                </div>

                <div class="row mb-4">
                    <div class="col-md-4">
                        <label class="form-label fw-bold">성명 <span class="text-danger">*</span></label>
                        <input type="text" name="userName" class="form-control form-control-lg border-2" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">휴대폰 번호 <span class="text-danger">*</span></label>
                        <input type="text" name="mobile" class="form-control form-control-lg border-2" placeholder="010-0000-0000" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">이메일</label>
                        <input type="email" name="email" class="form-control form-control-lg border-2" placeholder="email@example.com">
                    </div>
                </div>

                <!-- 동적 선택 영역 (채널/구매업체) -->
                <div id="dynamicArea" class="p-4 bg-light rounded-3 mb-4 border" style="display:none;">
                    <div id="channelGroup" style="display:none;">
                        <label class="form-label fw-bold text-primary"><i class="fas fa-truck me-2"></i>담당 운영 채널 선택 <span class="text-danger">*</span></label>
                        <select name="channelId" id="channelId" class="form-select form-select-lg border-2">
                            <option value="">-- 채널 선택 --</option>
                        </select>
                        <div class="form-text mt-2">전국택배, 화물직송, 공장수령 중 담당할 채널을 지정하세요.</div>
                    </div>
                    <div id="buyerGroup" style="display:none;">
                        <label class="form-label fw-bold text-primary"><i class="fas fa-store me-2"></i>소속 구매업체 선택 <span class="text-danger">*</span></label>
                        <select name="companyId" id="companyId" class="form-select form-select-lg border-2">
                            <option value="">-- 업체 선택 --</option>
                        </select>
                    </div>
                </div>

                <div class="d-flex justify-content-between mt-5 pt-3 border-top">
                    <a href="${pageContext.request.contextPath}/admin/member/memberList.do" class="btn btn-lg btn-outline-secondary px-5 rounded-pill shadow-sm">
                        <i class="fas fa-times me-2"></i>취소
                    </a>
                    <button type="button" class="btn btn-lg btn-primary px-5 rounded-pill shadow-sm" onclick="fn_register()">
                        <i class="fas fa-check me-2"></i>계정 생성하기
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    // 권한 변경 시 UI 동적 제어
    $('#userRole').on('change', function() {
        const role = $(this).val();
        $('#dynamicArea').hide();
        $('#channelGroup').hide();
        $('#buyerGroup').hide();
        
        $('#channelId').prop('required', false);
        $('#companyId').prop('required', false);

        if (role === 'CHANNEL_ADMIN') {
            $('#dynamicArea').show();
            $('#channelGroup').show();
            $('#channelId').prop('required', true);
        } else if (role === 'BUYER_ADMIN') {
            $('#dynamicArea').show();
            $('#buyerGroup').show();
            $('#companyId').prop('required', true);
        }
    });

    // 테넌트 변경 시 채널/업체 목록 로드
    $('#tenantId').on('change', function() {
        const tenantId = $(this).val();
        if (!tenantId) return;

        $.ajax({
            url: '${pageContext.request.contextPath}/admin/member/getOptions.do',
            data: { tenantId: tenantId },
            success: function(res) {
                // 채널 목록 갱신
                let channelHtml = '<option value="">-- 채널 선택 --</option>';
                res.channelList.forEach(item => {
                    channelHtml += '<option value="' + item.id + '">' + item.name + '</option>';
                });
                $('#channelId').html(channelHtml);

                // 구매업체 목록 갱신
                let buyerHtml = '<option value="">-- 업체 선택 --</option>';
                res.buyerList.forEach(item => {
                    buyerHtml += '<option value="' + item.id + '">' + item.name + '</option>';
                });
                $('#companyId').html(buyerHtml);
            }
        });
    });
});

function fn_register() {
    const form = document.getElementById('regForm');
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    if (!confirm('새로운 계정을 생성하시겠습니까?')) return;

    $.ajax({
        url: '${pageContext.request.contextPath}/admin/member/insertUser.do',
        type: 'POST',
        data: $(form).serialize(),
        success: function(res) {
            console.log('Registration Result:', res);
            if (res.success) {
                // 알럿창 없이 즉시 이동하거나 타이밍을 조절하여 이동 보장
                setTimeout(function() {
                    location.href = '${pageContext.request.contextPath}/admin/member/memberList.do';
                }, 500);
            } else {
                alert('계정 생성 실패: ' + (res.message || '알 수 없는 오류'));
            }
        },
        error: function(xhr, status, error) {
            console.error('AJAX Error:', status, error);
            alert('서버 통신 중 오류가 발생했습니다. (상태: ' + status + ')');
        }
    });
}
</script>
