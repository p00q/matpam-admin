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
    <h1 class="mt-4">사용자 ${empty user.userId ? '등록' : '수정'}</h1>
    <ol class="breadcrumb mb-4">
        <li class="breadcrumb-item"><a href="/admin/dashboard/main.do">대시보드</a></li>
        <li class="breadcrumb-item"><a href="/admin/user/userList.do">사용자 관리</a></li>
        <li class="breadcrumb-item active">사용자 ${empty user.userId ? '등록' : '수정'}</li>
    </ol>

    <div class="row justify-content-center">
        <div class="col-xl-9 col-lg-10">

            <form:form modelAttribute="user" id="detailForm" name="detailForm">
                <form:hidden path="userId"/>

                <!-- ══════════════════════════════════════════════════
                     STEP 1 : 회원 유형 선택
                ══════════════════════════════════════════════════ -->
                <div class="form-section">
                    <div class="section-head">
                        <div class="section-title">
                            <span class="section-badge">1</span> 회원 유형
                        </div>
                    </div>
                    <div class="section-body">
                        <div class="role-card-group" id="roleCardGroup">

                            <label class="role-card ${user.userRole == 'SUPER_ADMIN' ? 'active' : ''}" id="card-SUPER_ADMIN">
                                <input type="radio" name="userRole" id="role_SUPER_ADMIN" value="SUPER_ADMIN"
                                       ${user.userRole == 'SUPER_ADMIN' ? 'checked' : ''}/>
                                <span class="role-icon">🛡️</span>
                                <div class="role-label">수퍼관리자</div>
                                <div class="role-desc">플랫폼 전체 관리</div>
                            </label>

                            <label class="role-card ${user.userRole == 'SELLER_ADMIN' || empty user.userRole ? 'active' : ''}" id="card-SELLER_ADMIN">
                                <input type="radio" name="userRole" id="role_SELLER_ADMIN" value="SELLER_ADMIN"
                                       ${user.userRole == 'SELLER_ADMIN' || empty user.userRole ? 'checked' : ''}/>
                                <span class="role-icon">🏭</span>
                                <div class="role-label">판매처 관리자</div>
                                <div class="role-desc">자기 테넌트 전체 관리</div>
                            </label>

                            <label class="role-card ${user.userRole == 'CHANNEL_ADMIN' ? 'active' : ''}" id="card-CHANNEL_ADMIN">
                                <input type="radio" name="userRole" id="role_CHANNEL_ADMIN" value="CHANNEL_ADMIN"
                                       ${user.userRole == 'CHANNEL_ADMIN' ? 'checked' : ''}/>
                                <span class="role-icon">📦</span>
                                <div class="role-label">채널 관리자</div>
                                <div class="role-desc">1개 채널 담당</div>
                            </label>

                            <label class="role-card ${user.userRole == 'BUYER_ADMIN' ? 'active' : ''}" id="card-BUYER_ADMIN">
                                <input type="radio" name="userRole" id="role_BUYER_ADMIN" value="BUYER_ADMIN"
                                       ${user.userRole == 'BUYER_ADMIN' ? 'checked' : ''}/>
                                <span class="role-icon">🛒</span>
                                <div class="role-label">구매처 관리자</div>
                                <div class="role-desc">자기 업체 조회·수정</div>
                            </label>

                        </div>

                        <!-- 역할별 안내 메시지 -->
                        <div id="hint-SUPER_ADMIN" class="role-hint mt-3">
                            <i class="fas fa-info-circle me-1"></i>
                            <strong>수퍼관리자</strong>는 특정 테넌트·업체·채널에 소속되지 않습니다. 소속 정보는 자동으로 비워집니다.
                        </div>
                        <div id="hint-SELLER_ADMIN" class="role-hint mt-3">
                            <i class="fas fa-info-circle me-1"></i>
                            <strong>판매처 관리자</strong>는 선택한 테넌트의 <em>대표 판매업체</em>에 자동 소속됩니다.
                        </div>
                        <div id="hint-CHANNEL_ADMIN" class="role-hint mt-3">
                            <i class="fas fa-info-circle me-1"></i>
                            <strong>채널 관리자</strong>는 판매업체 소속이며, 반드시 <em>1개 채널</em>만 담당합니다.
                        </div>
                        <div id="hint-BUYER_ADMIN" class="role-hint mt-3">
                            <i class="fas fa-info-circle me-1"></i>
                            <strong>구매처 관리자</strong>는 <em>구매업체</em>에만 소속될 수 있습니다. 직접 구매업체를 선택해 주세요.
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
                <div class="form-section" id="affiliationSection">
                    <div class="section-head">
                        <div class="section-title">
                            <span class="section-badge">3</span> 소속 정보
                        </div>
                    </div>
                    <div class="section-body">

                        <div class="row g-3">

                            <!-- 테넌트 (SUPER_ADMIN 제외 필수) -->
                            <div class="col-md-6" id="tenantField">
                                <label for="tenantSelect" class="form-label required fw-semibold">테넌트</label>
                                <select id="tenantSelect" name="tenantId" class="form-select">
                                    <option value="">-- 테넌트 선택 --</option>
                                    <c:forEach var="t" items="${tenants}">
                                        <option value="${t.tenantId}"
                                            ${user.tenantId == t.tenantId ? 'selected' : ''}>
                                            ${t.tenantName}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="form-text text-muted">플랫폼(판매업체 운영 단위)을 선택합니다.</div>
                            </div>

                            <!-- 소속 업체 (SELLER_ADMIN, CHANNEL_ADMIN → 자동세팅 / BUYER_ADMIN → 직접선택) -->
                            <div class="col-md-6" id="companyField">

                                <!-- 자동세팅 표시 (SELLER_ADMIN, CHANNEL_ADMIN) -->
                                <div id="companyAutoArea">
                                    <label class="form-label fw-semibold">소속 업체</label>
                                    <div class="auto-set-info">
                                        <i class="fas fa-magic"></i>
                                        <span id="companyAutoText">테넌트 선택 시 대표 판매업체가 자동 세팅됩니다.</span>
                                    </div>
                                    <input type="hidden" id="companyIdHidden" name="companyId"
                                           value="${user.companyId}"/>
                                </div>

                                <!-- 직접 선택 (BUYER_ADMIN) -->
                                <div id="companySelectArea" style="display:none;">
                                    <label for="buyerCompanySelect" class="form-label required fw-semibold">
                                        구매업체 선택
                                    </label>
                                    <select id="buyerCompanySelect" class="form-select">
                                        <option value="">-- 구매업체 선택 --</option>
                                    </select>
                                    <div class="form-text text-muted">구매업체(company_type=BUYER)만 표시됩니다.</div>
                                </div>

                            </div>

                            <!-- 담당 채널 (CHANNEL_ADMIN 전용) -->
                            <div class="col-md-6" id="channelField" style="display:none;">
                                <label for="channelSelect" class="form-label required fw-semibold">담당 채널</label>
                                <select id="channelSelect" name="channelId" class="form-select">
                                    <option value="">-- 채널 선택 --</option>
                                </select>
                                <div class="form-text text-muted">채널관리자는 1개 채널만 담당합니다.</div>
                            </div>

                        </div><!-- /row -->

                    </div><!-- /section-body -->
                </div><!-- /form-section -->

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
                    <a href="/admin/user/userList.do" class="btn btn-outline-secondary px-4">
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
   역할 카드 선택
──────────────────────────────────────────────────── */
function fn_selectRole(role) {
    // 카드 active 갱신
    document.querySelectorAll('.role-card').forEach(c => c.classList.remove('active'));
    const card = document.getElementById('card-' + role);
    if (card) card.classList.add('active');

    // radio 체크
    const radio = document.getElementById('role_' + role);
    if (radio) radio.checked = true;

    // 힌트 표시
    document.querySelectorAll('.role-hint').forEach(h => h.classList.remove('show'));
    const hint = document.getElementById('hint-' + role);
    if (hint) hint.classList.add('show');

    // 소속 섹션 / 담당자 섹션 재구성
    fn_applyRoleLayout(role);
}

/* ────────────────────────────────────────────────────
   역할별 레이아웃 적용 (핵심 동적 폼 로직)
──────────────────────────────────────────────────── */
function fn_applyRoleLayout(role) {
    const tenantField      = document.getElementById('tenantField');
    const companyAutoArea  = document.getElementById('companyAutoArea');
    const companySelectArea= document.getElementById('companySelectArea');
    const channelField     = document.getElementById('channelField');
    const contactSection   = document.getElementById('contactSection');
    const affiliationSection = document.getElementById('affiliationSection');

    // 초기화
    document.getElementById('companyIdHidden').value = '';
    document.getElementById('companyAutoText').textContent = '테넌트 선택 시 대표 판매업체가 자동 세팅됩니다.';

    switch(role) {

        case 'SUPER_ADMIN':
            affiliationSection.style.display = 'none';
            contactSection.style.display     = 'none';
            // 소속 hidden 값 클리어
            document.getElementById('tenantSelect').value = '';
            document.getElementById('channelSelect').value = '';
            break;

        case 'SELLER_ADMIN':
            affiliationSection.style.display = '';
            tenantField.style.display        = '';
            companyAutoArea.style.display    = '';
            companySelectArea.style.display  = 'none';
            channelField.style.display       = 'none';
            contactSection.style.display     = '';
            // 채널 select name 제거해 전송 방지
            document.getElementById('channelSelect').removeAttribute('name');
            // 기본 담당자 역할
            fn_setDefaultContactRole('SELLER_ADMIN');
            break;

        case 'CHANNEL_ADMIN':
            affiliationSection.style.display = '';
            tenantField.style.display        = '';
            companyAutoArea.style.display    = '';
            companySelectArea.style.display  = 'none';
            channelField.style.display       = '';
            contactSection.style.display     = '';
            document.getElementById('channelSelect').setAttribute('name', 'channelId');
            fn_setDefaultContactRole('CHANNEL_ADMIN');
            break;

        case 'BUYER_ADMIN':
            affiliationSection.style.display = '';
            tenantField.style.display        = '';
            companyAutoArea.style.display    = 'none';
            companySelectArea.style.display  = '';
            channelField.style.display       = 'none';
            contactSection.style.display     = '';
            document.getElementById('channelSelect').removeAttribute('name');
            // buyerCompanySelect → companyId 로 name 연결
            document.getElementById('buyerCompanySelect').setAttribute('name', 'companyId');
            fn_setDefaultContactRole('BUYER_ADMIN');

            // 테넌트가 이미 선택돼 있으면 구매업체 목록 로드
            const tidForBuyer = document.getElementById('tenantSelect').value;
            if (tidForBuyer) fn_loadBuyerCompanies(tidForBuyer);
            break;
    }

    // SELLER/CHANNEL: buyerCompanySelect는 name 없이 (서버 미전송)
    if (role !== 'BUYER_ADMIN') {
        document.getElementById('buyerCompanySelect').removeAttribute('name');
    }
}

/* ────────────────────────────────────────────────────
   테넌트 변경 → 채널·구매업체·판매업체ID 동적 로드
──────────────────────────────────────────────────── */
function fn_onTenantChange(tenantId) {
    const role = fn_getSelectedRole();
    fn_loadFormOptions(role, tenantId);
}

function fn_loadFormOptions(role, tenantId) {
    if (!tenantId) return;

    $.ajax({
        url: '/admin/user/formOptions.ajax',
        type: 'GET',
        data: { userRole: role, tenantId: tenantId },
        success: function(res) {
            if (!res.success) {
                console.error('폼옵션 로드 실패:', res.message);
                return;
            }

            // 채널 목록 세팅 (CHANNEL_ADMIN)
            if (role === 'CHANNEL_ADMIN') {
                const $ch = $('#channelSelect').empty().append('<option value="">-- 채널 선택 --</option>');
                if (res.channels && res.channels.length > 0) {
                    $.each(res.channels, function(i, ch) {
                        const selected = (ch.channelId == INIT_CHANNEL && IS_EDIT) ? 'selected' : '';
                        $ch.append('<option value="' + ch.channelId + '" ' + selected + '>'
                            + fn_channelLabel(ch.channelCode) + ' (' + ch.channelName + ')</option>');
                    });
                }
            }

            // 대표 판매업체 자동세팅 (SELLER_ADMIN, CHANNEL_ADMIN)
            if (role === 'SELLER_ADMIN' || role === 'CHANNEL_ADMIN') {
                if (res.sellerCompanyId) {
                    document.getElementById('companyIdHidden').value = res.sellerCompanyId;
                    document.getElementById('companyAutoText').textContent
                        = '✔ 대표 판매업체(ID: ' + res.sellerCompanyId + ')가 자동 세팅되었습니다.';
                } else {
                    document.getElementById('companyIdHidden').value = '';
                    document.getElementById('companyAutoText').textContent
                        = '⚠ 해당 테넌트에 대표 판매업체가 지정되지 않았습니다.';
                }
            }

            // 구매업체 목록 세팅 (BUYER_ADMIN)
            if (role === 'BUYER_ADMIN') {
                const $bc = $('#buyerCompanySelect').empty().append('<option value="">-- 구매업체 선택 --</option>');
                if (res.buyerCompanies && res.buyerCompanies.length > 0) {
                    $.each(res.buyerCompanies, function(i, co) {
                        const selected = (co.companyId == INIT_COMPANY && IS_EDIT) ? 'selected' : '';
                        $bc.append('<option value="' + co.companyId + '" ' + selected + '>'
                            + co.companyName + ' (' + co.businessNo + ')</option>');
                    });
                } else {
                    $bc.append('<option value="" disabled>해당 테넌트에 구매업체가 없습니다.</option>');
                }
            }
        },
        error: function() {
            console.error('폼옵션 AJAX 통신 오류');
        }
    });
}

function fn_loadBuyerCompanies(tenantId) {
    fn_loadFormOptions('BUYER_ADMIN', tenantId);
}

function fn_channelLabel(code) {
    const map = { PARCEL: '전국택배', FREIGHT: '화물직송', PICKUP: '공장수령' };
    return map[code] || code;
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
        url: '/admin/user/checkLoginId.ajax',
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
    const role = fn_getSelectedRole();
    if (!role) { alert('회원 유형을 선택하세요.'); return false; }

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

    // 역할별 소속 검증
    if (role !== 'SUPER_ADMIN') {
        const tenantId = $('#tenantSelect').val();
        if (!tenantId) { alert('테넌트를 선택하세요.'); return false; }
    }
    if (role === 'CHANNEL_ADMIN') {
        const channelId = $('#channelSelect').val();
        if (!channelId) { alert('담당 채널을 선택하세요.'); return false; }
    }
    if (role === 'BUYER_ADMIN') {
        const companyId = $('#buyerCompanySelect').val();
        if (!companyId) { alert('구매업체를 선택하세요.'); return false; }
    }
    if ((role === 'SELLER_ADMIN' || role === 'CHANNEL_ADMIN')) {
        const sellerComp = $('#companyIdHidden').val();
        if (!sellerComp) {
            alert('선택한 테넌트에 대표 판매업체가 지정되지 않았습니다. 먼저 테넌트를 확인하세요.');
            return false;
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
        url: '/admin/user/saveUser.ajax',
        type: 'POST',
        data: formData,
        success: function(res) {
            if (res.success) {
                alert(res.message || '정상적으로 처리되었습니다.');
                location.href = '/admin/user/userList.do';
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

    /* 역할 카드 클릭 */
    document.querySelectorAll('.role-card').forEach(function(card) {
        card.addEventListener('click', function() {
            const radio = this.querySelector('input[type=radio]');
            if (radio) fn_selectRole(radio.value);
        });
    });

    /* 테넌트 변경 */
    $('#tenantSelect').on('change', function() {
        fn_onTenantChange(this.value);
    });

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

    /* ── 초기화: 현재 역할로 레이아웃 세팅 ── */
    fn_selectRole(INIT_ROLE);

    /* 수정 모드이고 테넌트가 있으면 옵션 로드 */
    if (IS_EDIT && INIT_TENANT) {
        fn_loadFormOptions(INIT_ROLE, INIT_TENANT);
    }
});
</script>
