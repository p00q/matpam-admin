<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<style>
/* ── 섹션 헤더 ── */
.section-badge {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 26px; height: 26px;
    border-radius: 50%;
    background: #4361ee;
    color: #fff;
    font-size: .78rem;
    font-weight: 700;
    margin-right: 8px;
    flex-shrink: 0;
}
.section-title {
    font-size: .95rem;
    font-weight: 700;
    color: #2d3a4a;
    display: flex;
    align-items: center;
}

/* ── 역할 카드 ── */
.role-card-group { display: flex; gap: 10px; flex-wrap: wrap; }
.role-card {
    flex: 1 1 calc(25% - 8px);
    min-width: 120px;
    border: 2px solid #dee2e6;
    border-radius: 10px;
    padding: 14px 10px;
    text-align: center;
    cursor: pointer;
    transition: all .18s;
    background: #fff;
    position: relative;
}
.role-card:hover { border-color: #4361ee; background: #f0f4ff; }
.role-card.active {
    border-color: #4361ee;
    background: #f0f4ff;
    box-shadow: 0 0 0 3px rgba(67,97,238,.15);
}
.role-card input[type=radio] { position: absolute; opacity: 0; width: 0; height: 0; }
.role-card .role-icon { font-size: 1.6rem; margin-bottom: 6px; display: block; }
.role-card .role-label { font-size: .82rem; font-weight: 600; color: #2d3a4a; line-height: 1.3; }
.role-card .role-desc  { font-size: .72rem; color: #6c757d; margin-top: 3px; }

/* ── 소속 정보 안내 박스 ── */
.role-hint {
    border-left: 4px solid #4361ee;
    background: #f0f4ff;
    border-radius: 0 8px 8px 0;
    padding: 10px 14px;
    font-size: .83rem;
    color: #3a4a6a;
    display: none;
}
.role-hint.show { display: block; }

/* ── 섹션 카드 ── */
.form-section {
    border: 1px solid #e9ecef;
    border-radius: 12px;
    margin-bottom: 20px;
    overflow: hidden;
}
.form-section .section-head {
    background: #f8f9fa;
    padding: 12px 20px;
    border-bottom: 1px solid #e9ecef;
}
.form-section .section-body { padding: 20px; }

/* ── 담당자 옵션 토글 ── */
#contactSection { transition: all .2s; }

/* ── 상태 뱃지 ── */
.status-group .form-check { margin-right: 16px; }
.status-group .form-check-input { width: 1.1em; height: 1.1em; margin-top: .18em; }

/* ── 저장 버튼 영역 ── */
.action-bar {
    background: #f8f9fa;
    border-top: 1px solid #e9ecef;
    padding: 16px 24px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-radius: 0 0 12px 12px;
}

/* ── 필드 라벨 ── */
.form-label.required::after {
    content: ' *';
    color: #dc3545;
}

/* ── 자동세팅 읽기전용 ── */
.auto-set-info {
    display: flex;
    align-items: center;
    padding: 8px 12px;
    background: #e9ecef;
    border-radius: 6px;
    font-size: .85rem;
    color: #495057;
    min-height: 38px;
}
.auto-set-info i { margin-right: 6px; color: #4361ee; }

/* 비밀번호 강도 */
.pwd-strength { height: 4px; border-radius: 2px; margin-top: 5px; transition: all .3s; }
.pwd-weak    { background: #dc3545; width: 33%; }
.pwd-medium  { background: #fd7e14; width: 66%; }
.pwd-strong  { background: #198754; width: 100%; }
</style>

<div class="container-fluid px-4">
    <h1 class="mt-4">회원 ${empty user.userId ? '등록' : '수정'}</h1>
    <ol class="breadcrumb mb-4">
        <li class="breadcrumb-item"><a href="<c:url value='/admin/dashboard/main.do'/>">대시보드</a></li>
        <li class="breadcrumb-item"><a href="<c:url value='/admin/user/userList.do'/>">회원 관리</a></li>
        <li class="breadcrumb-item active">회원 ${empty user.userId ? '등록' : '수정'}</li>
    </ol>

    <div class="row justify-content-center">
        <div class="col-xl-9 col-lg-10">

            <form:form modelAttribute="user" id="detailForm" name="detailForm" action="${pageContext.request.contextPath}/admin/user/userSave.do">
                <form:hidden path="userId"/>

                <!-- ══════════════════════════════════════════════════
                     STEP 1 : 소속 유형 선택
                ══════════════════════════════════════════════════ -->
                <div class="form-section">
                    <div class="section-head">
                        <div class="section-title">
                            <span class="section-badge">1</span> 소속 유형
                        </div>
                    </div>
                    <div class="section-body">
                        <div class="role-card-group" id="affiliationTypeGroup">
                            <label class="role-card ${user.userRole == 'SELLER_ADMIN' || user.userRole == 'CHANNEL_ADMIN' || empty user.userRole ? 'active' : ''}" id="card-SELLER">
                                <input type="radio" name="affiliationType" id="type_SELLER" value="SELLER"
                                       ${user.userRole == 'SELLER_ADMIN' || user.userRole == 'CHANNEL_ADMIN' || empty user.userRole ? 'checked' : ''}
                                       onclick="fn_onAffiliationChange('SELLER')"/>
                                <span class="role-icon">🏭</span>
                                <div class="role-label">판매업체</div>
                                <div class="role-desc">제조사/공급사 소속</div>
                            </label>

                            <label class="role-card ${user.userRole == 'BUYER_ADMIN' ? 'active' : ''}" id="card-BUYER">
                                <input type="radio" name="affiliationType" id="type_BUYER" value="BUYER"
                                       ${user.userRole == 'BUYER_ADMIN' ? 'checked' : ''}
                                       onclick="fn_onAffiliationChange('BUYER')"/>
                                <span class="role-icon">🛒</span>
                                <div class="role-label">구매업체</div>
                                <div class="role-desc">구매사/식당 소속</div>
                            </label>

                            <label class="role-card ${user.userRole == 'SUPER_ADMIN' ? 'active' : ''}" id="card-SUPER">
                                <input type="radio" name="affiliationType" id="type_SUPER" value="SUPER"
                                       ${user.userRole == 'SUPER_ADMIN' ? 'checked' : ''}
                                       onclick="fn_onAffiliationChange('SUPER')"/>
                                <span class="role-icon">🛡️</span>
                                <div class="role-label">시스템 관리</div>
                                <div class="role-desc">플랫폼 운영자 전용</div>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- ══════════════════════════════════════════════════
                     STEP 2 : 기본 정보
                ══════════════════════════════════════════════════ -->
                <div class="form-section">
                    <div class="section-head">
                        <div class="section-title">
                            <span class="section-badge">2</span> 기본 정보
                        </div>
                    </div>
                    <div class="section-body">

                        <div class="row g-3 mb-3">
                            <!-- 로그인 ID -->
                            <div class="col-md-6">
                                <label for="loginId" class="form-label required fw-semibold">로그인 ID</label>
                                <div class="input-group">
                                    <form:input path="loginId" id="loginId" class="form-control"
                                                placeholder="영문·숫자 조합 4~20자"
                                                readonly="${not empty user.userId}"/>
                                    <c:if test="${empty user.userId}">
                                        <button class="btn btn-outline-secondary" type="button"
                                                id="btnCheckId" onclick="fn_checkId()">
                                            <i class="fas fa-search me-1"></i>중복확인
                                        </button>
                                    </c:if>
                                </div>
                                <div id="idCheckMsg" class="small mt-1"></div>
                            </div>

                            <!-- 사용자명 -->
                            <div class="col-md-6">
                                <label for="userName" class="form-label required fw-semibold">사용자 이름</label>
                                <form:input path="userName" id="userName" class="form-control"
                                            placeholder="실명을 입력하세요"/>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <!-- 비밀번호 -->
                            <div class="col-md-6">
                                <label for="passwordHash" class="form-label fw-semibold
                                    ${empty user.userId ? 'required' : ''}">
                                    비밀번호
                                    <c:if test="${not empty user.userId}">
                                        <span class="text-muted fw-normal">(변경 시에만 입력)</span>
                                    </c:if>
                                </label>
                                <form:input path="passwordHash" id="passwordHash" type="password"
                                            class="form-control"
                                            placeholder="${empty user.userId ? '영문+숫자+특수문자 8자 이상' : '변경하지 않으면 빈칸'}"/>
                                <div id="pwdStrengthBar" class="pwd-strength mt-1" style="display:none;"></div>
                                <div id="pwdStrengthMsg" class="small mt-1 text-muted"></div>
                            </div>

                            <!-- 비밀번호 확인 -->
                            <div class="col-md-6">
                                <label for="passwordConfirm" class="form-label fw-semibold
                                    ${empty user.userId ? 'required' : ''}">
                                    비밀번호 확인
                                </label>
                                <input type="password" id="passwordConfirm" class="form-control"
                                       placeholder="비밀번호를 다시 입력하세요"/>
                                <div id="pwdMatchMsg" class="small mt-1"></div>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <!-- 휴대폰 -->
                            <div class="col-md-6">
                                <label for="mobile" class="form-label fw-semibold">휴대폰 번호</label>
                                <form:input path="mobile" id="mobile" class="form-control"
                                            placeholder="010-0000-0000"/>
                            </div>

                            <!-- 이메일 -->
                            <div class="col-md-6">
                                <label for="email" class="form-label fw-semibold">이메일</label>
                                <form:input path="email" id="email" type="email" class="form-control"
                                            placeholder="example@domain.com"/>
                            </div>
                        </div>

                        <!-- 상태 -->
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label required fw-semibold">상태</label>
                                <div class="d-flex status-group mt-1">
                                    <div class="form-check form-check-inline">
                                        <form:radiobutton path="status" value="ACTIVE" id="statusActive"
                                                          class="form-check-input"/>
                                        <label class="form-check-label" for="statusActive">
                                            <span class="badge bg-success">활성</span>
                                        </label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <form:radiobutton path="status" value="LOCKED" id="statusLocked"
                                                          class="form-check-input"/>
                                        <label class="form-check-label" for="statusLocked">
                                            <span class="badge bg-warning text-dark">잠금</span>
                                        </label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <form:radiobutton path="status" value="INACTIVE" id="statusInactive"
                                                          class="form-check-input"/>
                                        <label class="form-check-label" for="statusInactive">
                                            <span class="badge bg-secondary">비활성</span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div><!-- /section-body -->
                </div><!-- /form-section -->

                <!-- ══════════════════════════════════════════════════
                     STEP 3 : 소속 정보 (역할별 동적 노출)
                ══════════════════════════════════════════════════ -->
                <!-- ══════════════════════════════════════════════════
                     STEP 3 : 소속 정보
                ══════════════════════════════════════════════════ -->
                <div class="form-section" id="affiliationSection">
                    <div class="section-head">
                        <div class="section-title">
                            <span class="section-badge">3</span> 소속 정보
                        </div>
                    </div>
                    <div class="section-body">
                        <div class="row g-3">
                            <!-- 업체 검색 및 선택 -->
                            <div class="col-md-6" id="companySearchField">
                                <label class="form-label required fw-semibold">대상 업체 선택</label>
                                <div class="input-group">
                                    <input type="text" id="companyNameDisplay" class="form-control bg-light"
                                           placeholder="업체를 검색하여 선택하세요" readonly
                                           value="${not empty user.companyName ? user.companyName : ''}"/>
                                    <button class="btn btn-primary" type="button" onclick="fn_openCompanySearch()">
                                        <i class="fas fa-search me-1"></i> 업체 검색
                                    </button>
                                </div>
                                <form:hidden path="companyId" id="companyIdHidden"/>
                                <form:hidden path="tenantId" id="tenantIdHidden"/>
                                <div class="form-text text-muted" id="companyInfoHint">
                                    ${not empty user.companyName ? '현재 선택됨: '.concat(user.companyName) : '먼저 소속될 업체를 찾아주세요.'}
                                </div>
                            </div>

                            <!-- 판매업체 전용 역할 선택 (판매업체일 때만) -->
                            <div class="col-md-6" id="sellerRoleField" style="display:none;">
                                <label class="form-label required fw-semibold">회원 역할 부여</label>
                                <div class="mt-1">
                                    <div class="form-check form-check-inline">
                                        <input type="radio" name="sellerUserRole" id="role_SELLER_ADMIN" value="SELLER_ADMIN"
                                               class="form-check-input" ${user.userRole == 'SELLER_ADMIN' ? 'checked' : ''}
                                               onchange="fn_onSellerRoleChange(this.value)"/>
                                        <label class="form-check-label" for="role_SELLER_ADMIN">일반 담당자</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input type="radio" name="sellerUserRole" id="role_CHANNEL_ADMIN" value="CHANNEL_ADMIN"
                                               class="form-check-input" ${user.userRole == 'CHANNEL_ADMIN' ? 'checked' : ''}
                                               onchange="fn_onSellerRoleChange(this.value)"/>
                                        <label class="form-check-label" for="role_CHANNEL_ADMIN">채널 담당자</label>
                                    </div>
                                </div>
                                <input type="hidden" name="userRole" id="userRoleHidden" value="${user.userRole}"/>
                            </div>

                            <!-- 담당 채널 (채널 담당자 전용) -->
                            <div class="col-md-6" id="channelField" style="display:none;">
                                <label for="channelSelect" class="form-label required fw-semibold">담당 채널</label>
                                <select id="channelSelect" name="channelId" class="form-select">
                                    <option value="">-- 채널 선택 --</option>
                                </select>
                                <div class="form-text text-muted">채널담당자는 담당할 특정 채널을 지정해야 합니다.</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ══════════════════════════════════════════════════
                     STEP 4 : 담당자 동시 생성 옵션
                ══════════════════════════════════════════════════ -->
                <div class="form-section" id="contactSection">
                    <div class="section-head d-flex justify-content-between align-items-center">
                        <div class="section-title">
                            <span class="section-badge">4</span> 담당자 동시 생성
                            <span class="badge bg-light text-secondary fw-normal ms-2" style="font-size:.72rem;">선택사항</span>
                        </div>
                        <div class="form-check form-switch mb-0">
                            <input class="form-check-input" type="checkbox" role="switch"
                                   id="createContactSwitch"
                                   onchange="fn_toggleContact(this.checked)"/>
                            <label class="form-check-label" for="createContactSwitch">담당자 생성</label>
                        </div>
                    </div>
                    <div class="section-body" id="contactOptionBody" style="display:none;">
                        <input type="hidden" id="createContactYn" name="createContactYn" value="N"/>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="contactRole" class="form-label fw-semibold">담당자 역할</label>
                                <select id="contactRole" name="contactRole" class="form-select">
                                    <option value="ADMIN">ADMIN – 관리</option>
                                    <option value="SALES">SALES – 영업</option>
                                    <option value="TAX">TAX – 세금계산서</option>
                                    <option value="SETTLEMENT">SETTLEMENT – 정산</option>
                                    <option value="SHIPPING">SHIPPING – 출고</option>
                                    <option value="PURCHASE">PURCHASE – 구매</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">대표 담당자</label>
                                <div class="mt-2">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio"
                                               name="isPrimaryContact" id="isPrimaryY" value="Y"/>
                                        <label class="form-check-label" for="isPrimaryY">대표 담당자로 지정</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio"
                                               name="isPrimaryContact" id="isPrimaryN" value="N" checked/>
                                        <label class="form-check-label" for="isPrimaryN">일반 담당자</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="alert alert-info mt-3 mb-0 py-2 small">
                            <i class="fas fa-info-circle me-1"></i>
                            담당자(tb_company_contact)가 사용자와 함께 자동으로 연결·생성됩니다. 로그인 없는 담당자는 별도 업체 담당자 메뉴에서 등록할 수 있습니다.
                        </div>
                    </div>
                </div>

                <!-- ══════════════════════════════════════════════════
                     액션 버튼
                ══════════════════════════════════════════════════ -->
                <div class="action-bar">
                    <a href="<c:url value='/admin/user/userList.do'/>" class="btn btn-outline-secondary px-4">
                        <i class="fas fa-list me-1"></i> 목록으로
                    </a>
                    <button type="button" class="btn btn-primary px-5 shadow-sm" onclick="fn_save()">
                        <i class="fas fa-save me-1"></i>
                        ${empty user.userId ? '사용자 등록' : '정보 수정'}
                    </button>
                </div>

            </form:form>
        </div><!-- /col -->
    </div><!-- /row -->
</div><!-- /container -->

<!-- ================================================================
     JavaScript
================================================================ -->
<script>
/* ────────────────────────────────────────────────────
   초기 상태
──────────────────────────────────────────────────── */
let idChecked     = ${not empty user.userId};   // 수정모드는 체크 불필요
let pwdValid      = ${not empty user.userId};   // 수정모드는 선택사항

const IS_EDIT     = ${ not empty user.userId ? 'true' : 'false' };
const INIT_ROLE   = '${empty user.userRole ? "SELLER_ADMIN" : user.userRole}';
const INIT_TENANT = '${user.tenantId != null ? user.tenantId : ""}';
const INIT_CHANNEL= '${user.channelId != null ? user.channelId : ""}';
const INIT_COMPANY= '${user.companyId != null ? user.companyId : ""}';

/* ────────────────────────────────────────────────────
   회원 유형 / 소속 유형 변경 핸들러
──────────────────────────────────────────────────── */
function fn_onAffiliationChange(type) {
    // 카드 활성화 표시
    $('.role-card').removeClass('active');
    $('#card-' + type).addClass('active');

    // 기본 가시성 리셋
    $('#affiliationSection').show();
    $('#companySearchField').show();
    $('#sellerRoleField').hide();
    $('#channelField').hide();
    $('#contactSection').show();

    if (type === 'SUPER') {
        $('#affiliationSection').hide();
        $('#contactSection').hide();
        $('#userRoleHidden').val('SUPER_ADMIN');
    } else if (type === 'SELLER') {
        $('#sellerRoleField').show();
        // 판매업체 기본 역할은 SELLER_ADMIN
        const currentRole = $('#userRoleHidden').val();
        if (currentRole !== 'SELLER_ADMIN' && currentRole !== 'CHANNEL_ADMIN') {
            $('#userRoleHidden').val('SELLER_ADMIN');
            $('#role_SELLER_ADMIN').prop('checked', true);
        }
        fn_onSellerRoleChange($('#userRoleHidden').val());
    } else if (type === 'BUYER') {
        $('#userRoleHidden').val('BUYER_ADMIN');
    }
}

/* ────────────────────────────────────────────────────
   판매업체 내부 역할 변경 (담당자 vs 채널담당자)
──────────────────────────────────────────────────── */
function fn_onSellerRoleChange(role) {
    $('#userRoleHidden').val(role);
    if (role === 'CHANNEL_ADMIN') {
        $('#channelField').show();
        const tenantId = $('#tenantIdHidden').val();
        if (tenantId) fn_loadChannels(tenantId);
    } else {
        $('#channelField').hide();
    }
}

/* ────────────────────────────────────────────────────
   업체 검색 모달 & AJAX
──────────────────────────────────────────────────── */
function fn_openCompanySearch() {
    const type = $('input[name="affiliationType"]:checked').val();
    if (type === 'SUPER') return;
    
    $('#modalSearchKeyword').val('');
    $('#companySearchResultBody').html('<tr><td colspan="4" class="text-center py-5 text-muted">검색어를 입력해 주세요.</td></tr>');
    $('#companySearchModal').modal('show');
}

function fn_searchCompanies() {
    const keyword = $('#modalSearchKeyword').val().trim();
    if (!keyword) { alert('검색어를 입력하세요.'); return; }
    
    const type = $('input[name="affiliationType"]:checked').val(); // SELLER or BUYER

    $.ajax({
        url: "<c:url value='/admin/company/search.ajax'/>",
        type: 'GET',
        data: { searchKeyword: keyword, companyType: type },
        success: function(res) {
            const $body = $('#companySearchResultBody').empty();
            if (res.success && res.list && res.list.length > 0) {
                $.each(res.list, function(i, co) {
                    let row = '<tr>';
                    row += '<td><span class="fw-bold">' + co.companyName + '</span></td>';
                    row += '<td>' + (co.businessNo || '-') + '</td>';
                    row += '<td><span class="text-muted small">' + (co.tenantName || '미지정') + '</span></td>';
                    row += '<td class="text-center"><button class="btn btn-sm btn-outline-primary" onclick="fn_selectCompany('
                        + co.companyId + ', \'' + co.companyName.replace(/'/g, "\\'") + '\', ' + co.tenantId + ')">선택</button></td>';
                    row += '</tr>';
                    $body.append(row);
                });
            } else {
                $body.append('<tr><td colspan="4" class="text-center py-5 text-muted">검색 결과가 없습니다.</td></tr>');
            }
        },
        error: function() { alert('업체 검색 중 오류가 발생했습니다.'); }
    });
}

function fn_selectCompany(id, name, tenantId) {
    $('#companyIdHidden').val(id);
    $('#tenantIdHidden').val(tenantId);
    $('#companyNameDisplay').val(name);
    $('#companyInfoHint').html('✔ 선택됨: <strong>' + name + '</strong> (테넌트 ID: ' + tenantId + ')');
    
    $('#companySearchModal').modal('hide');
    
    // 역할이 채널관리자라면 해당 테넌트의 채널 목록 다시 로드
    if ($('#userRoleHidden').val() === 'CHANNEL_ADMIN') {
        fn_loadChannels(tenantId);
    }
}

function fn_loadChannels(tenantId) {
    if (!tenantId) return;
    $.ajax({
        url: "<c:url value='/admin/user/formOptions.ajax'/>",
        type: 'GET',
        data: { userRole: 'CHANNEL_ADMIN', tenantId: tenantId },
        success: function(res) {
            if (res.success && res.channels) {
                const $ch = $('#channelSelect').empty().append('<option value="">-- 채널 선택 --</option>');
                $.each(res.channels, function(i, ch) {
                    const selected = (ch.channelId == INIT_CHANNEL && IS_EDIT) ? 'selected' : '';
                    $ch.append('<option value="' + ch.channelId + '" ' + selected + '>'
                        + ch.channelName + '</option>');
                });
            }
        }
    });
}

function fn_channelLabel(type) {
    const map = { COURIER: '전국택배', DIRECT: '공장수령(직송)', COLLECT: '화물(수집)' };
    return map[type] || type;
}

/* ────────────────────────────────────────────────────
   담당자 역할 기본값
──────────────────────────────────────────────────── */
function fn_setDefaultContactRole(role) {
    const map = { SELLER_ADMIN: 'ADMIN', CHANNEL_ADMIN: 'ADMIN', BUYER_ADMIN: 'PURCHASE' };
    const $sel = $('#contactRole');
    if ($sel.length) $sel.val(map[role] || 'ADMIN');
}

/* ────────────────────────────────────────────────────
   담당자 생성 스위치 토글
──────────────────────────────────────────────────── */
function fn_toggleContact(checked) {
    document.getElementById('contactOptionBody').style.display = checked ? '' : 'none';
    document.getElementById('createContactYn').value = checked ? 'Y' : 'N';
}

/* ────────────────────────────────────────────────────
   로그인 ID 중복 확인
──────────────────────────────────────────────────── */
function fn_checkId() {
    const loginId = $('#loginId').val();
    if (!loginId || loginId.trim() === '') {
        alert('아이디를 입력하세요.');
        return;
    }
    if (!/^[a-zA-Z0-9]{4,20}$/.test(loginId)) {
        $('#idCheckMsg').text('영문·숫자 조합 4~20자로 입력하세요.')
                        .removeClass('text-success').addClass('text-danger');
        return;
    }

    $.ajax({
        url: "<c:url value='/admin/user/checkLoginId.ajax'/>",
        type: 'GET',
        data: { loginId: loginId },
        success: function(res) {
            if (res.success) {
                if (res.duplicated) {
                    $('#idCheckMsg').text('이미 사용 중인 아이디입니다.')
                                    .removeClass('text-success').addClass('text-danger');
                    idChecked = false;
                } else {
                    $('#idCheckMsg').text('✔ 사용 가능한 아이디입니다.')
                                    .removeClass('text-danger').addClass('text-success');
                    idChecked = true;
                }
            }
        },
        error: function() { alert('중복 확인 중 오류가 발생했습니다.'); }
    });
}

/* ────────────────────────────────────────────────────
   비밀번호 강도 체크
──────────────────────────────────────────────────── */
function fn_checkPwdStrength(val) {
    if (!val) {
        $('#pwdStrengthBar').hide();
        $('#pwdStrengthMsg').text('');
        pwdValid = IS_EDIT;
        return;
    }
    let score = 0;
    if (val.length >= 8) score++;
    if (/[A-Z]/.test(val) || /[a-z]/.test(val)) score++;
    if (/[0-9]/.test(val)) score++;
    if (/[^A-Za-z0-9]/.test(val)) score++;

    const bar = document.getElementById('pwdStrengthBar');
    const msg = document.getElementById('pwdStrengthMsg');
    bar.style.display = '';
    bar.className = 'pwd-strength mt-1';
    if (score <= 1) {
        bar.classList.add('pwd-weak');
        msg.textContent = '취약한 비밀번호입니다.';
        msg.className = 'small mt-1 text-danger';
        pwdValid = false;
    } else if (score === 2 || score === 3) {
        bar.classList.add('pwd-medium');
        msg.textContent = '보통 강도입니다.';
        msg.className = 'small mt-1 text-warning';
        pwdValid = val.length >= 8;
    } else {
        bar.classList.add('pwd-strong');
        msg.textContent = '강한 비밀번호입니다. ✔';
        msg.className = 'small mt-1 text-success';
        pwdValid = true;
    }
}

/* ────────────────────────────────────────────────────
   비밀번호 일치 확인
──────────────────────────────────────────────────── */
function fn_checkPwdMatch() {
    const pwd  = $('#passwordHash').val();
    const conf = $('#passwordConfirm').val();
    if (!conf) { $('#pwdMatchMsg').text(''); return; }
    if (pwd === conf) {
        $('#pwdMatchMsg').text('✔ 비밀번호가 일치합니다.').removeClass('text-danger').addClass('text-success');
    } else {
        $('#pwdMatchMsg').text('비밀번호가 일치하지 않습니다.').removeClass('text-success').addClass('text-danger');
    }
}

/* ────────────────────────────────────────────────────
   현재 선택된 역할
──────────────────────────────────────────────────── */
function fn_getSelectedRole() {
    return $('input[name="userRole"]:checked').val();
}

/* ────────────────────────────────────────────────────
   저장 전 프론트 검증
──────────────────────────────────────────────────── */
function fn_validate() {
    const type = $('input[name="affiliationType"]:checked').val();
    if (!type) { alert('소속 유형을 선택하세요.'); return false; }

    const loginId = $('#loginId').val();
    if (!loginId) { alert('로그인 ID를 입력하세요.'); return false; }

    if (!IS_EDIT && !idChecked) {
        alert('로그인 ID 중복 확인이 필요합니다.'); return false;
    }

    const userName = $('#userName').val();
    if (!userName) { alert('사용자 이름을 입력하세요.'); return false; }

    // 비밀번호 신규등록 필수
    const pwd  = $('#passwordHash').val();
    const conf = $('#passwordConfirm').val();
    if (!IS_EDIT && !pwd) { alert('비밀번호를 입력하세요.'); return false; }
    if (pwd && pwd !== conf) { alert('비밀번호가 일치하지 않습니다.'); return false; }
    if (pwd && !pwdValid) { alert('비밀번호 강도가 너무 약합니다. 영문+숫자+특수문자 8자 이상을 권장합니다.'); return false; }

    // 소속 정보 검증
    if (type !== 'SUPER') {
        const companyId = $('#companyIdHidden').val();
        if (!companyId) { alert('대상 업체를 검색하여 선택하세요.'); return false; }
        
        const role = $('#userRoleHidden').val();
        if (role === 'CHANNEL_ADMIN') {
            const channelId = $('#channelSelect').val();
            if (!channelId) { alert('담당 채널을 선택하세요.'); return false; }
        }
    }

    return true;
}

/* ────────────────────────────────────────────────────
   저장
──────────────────────────────────────────────────── */
function fn_save() {
    if (!fn_validate()) return;
    if (!confirm('저장하시겠습니까?')) return;

    const formData = $('#detailForm').serialize();

    $.ajax({
        url: "<c:url value='/admin/user/saveUser.ajax'/>",
        type: 'POST',
        data: formData,
        success: function(res) {
            if (res.success) {
                alert(res.message || '정상적으로 처리되었습니다.');
                location.href = "<c:url value='/admin/user/userList.do'/>";
            } else {
                alert('[' + (res.errorCode || 'ERR') + '] ' + res.message);
            }
        },
        error: function() {
            alert('통신 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
        }
    });
}

/* ────────────────────────────────────────────────────
   DOM 이벤트 바인딩 & 초기화
──────────────────────────────────────────────────── */
$(function() {

    /* 로그인 ID 변경 시 중복확인 초기화 */
    $('#loginId').on('input', function() {
        idChecked = false;
        $('#idCheckMsg').text('').removeClass('text-success text-danger');
    });

    /* 비밀번호 강도 실시간 체크 */
    $('#passwordHash').on('input', function() {
        fn_checkPwdStrength($(this).val());
        fn_checkPwdMatch();
    });

    /* 비밀번호 확인 실시간 체크 */
    $('#passwordConfirm').on('input', fn_checkPwdMatch);

    /* ── 초기화 ── */
    // 기존 데이터 기반 소속 유형 결정
    let initType = 'SELLER';
    if (INIT_ROLE === 'SUPER_ADMIN') initType = 'SUPER';
    else if (INIT_ROLE === 'BUYER_ADMIN') initType = 'BUYER';

    $('input[name="affiliationType"][value="' + initType + '"]').prop('checked', true);
    fn_onAffiliationChange(initType);

    /* 수정 모드이고 테넌트가 있으면 채널 목록 등 로드 */
    if (IS_EDIT && INIT_ROLE === 'CHANNEL_ADMIN' && INIT_TENANT) {
        fn_loadChannels(INIT_TENANT);
    }
});
</script>
