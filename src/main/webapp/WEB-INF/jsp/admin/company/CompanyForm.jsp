<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<div class="container-fluid px-0">

    <style>
        .premium-card { border-radius: 16px; border: none; box-shadow: 0 4px 20px rgba(0,0,0,0.05); overflow: hidden; background: #fff; }
        .premium-card .card-header { background: #fff; border-bottom: 1px solid #f1f5f9; padding: 1.25rem 1.5rem; }
        .premium-card .card-body { padding: 1.5rem; }
        
        .role-card-v4 {
            display: flex; align-items: center; gap: 1rem; padding: 1rem; border: 2px solid #f1f5f9;
            border-radius: 12px; transition: all 0.2s ease; background: #fff;
        }
        .role-card-v4:hover { border-color: #cbd5e1; background: #f8fafc; }
        .role-card-v4.active { border-color: #4361ee; background: #f0f3ff; }
        .role-card-v4 input[type="radio"] { display: none; }
        .role-icon-box {
            width: 42px; height: 42px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem;
        }
        .role-icon-box.total { background: #eff6ff; color: #3b82f6; }
        .role-icon-box.active { background: #f0fdf4; color: #22c55e; }
        .role-info { flex: 1; }
        .role-title { font-weight: 700; font-size: 0.95rem; color: #1e293b; margin-bottom: 2px; }
        .role-text { font-size: 0.8rem; color: #64748b; }
    </style>

    <!-- ── 페이지 헤더 ── -->
    <div class="px-4 pt-3 pb-1">
        <div class="d-flex align-items-center justify-content-between mb-1">
            <h4 class="fw-bold mb-0" style="color:#1e293b;">
                <c:choose>
                    <c:when test="${currentMenu eq 'op_mall'}">몰 정보 관리</c:when>
                    <c:when test="${company.companyType eq 'SELLER' or param.companyType eq 'SELLER'}">판매업체 관리</c:when>
                    <c:when test="${company.companyType eq 'BUYER' or param.companyType eq 'BUYER'}">구매업체 관리</c:when>
                    <c:otherwise>업체 정보 관리</c:otherwise>
                </c:choose>
                <small class="text-muted fs-6 fw-normal ms-2">| ${empty company.companyId ? '신규 등록' : '정보 수정'}</small>
            </h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0" style="font-size:.78rem;">
                    <li class="breadcrumb-item text-muted">
                        <c:choose>
                            <c:when test="${currentMenu eq 'op_mall'}"><a href="#" class="text-decoration-none text-muted">운영관리</a></c:when>
                            <c:otherwise><a href="#" class="text-decoration-none text-muted">업체관리</a></c:otherwise>
                        </c:choose>
                    </li>
                    <li class="breadcrumb-item active text-muted">
                        <c:choose>
                            <c:when test="${currentMenu eq 'op_mall'}">몰 정보 관리</c:when>
                            <c:when test="${company.companyType eq 'SELLER' or param.companyType eq 'SELLER'}">
                                <a href="<c:url value='/admin/company/companyList.do?companyType=SELLER'/>" class="text-decoration-none text-muted">판매업체 관리</a>
                            </c:when>
                            <c:otherwise>
                                <a href="<c:url value='/admin/company/companyList.do?companyType=BUYER'/>" class="text-decoration-none text-muted">구매업체 관리</a>
                            </c:otherwise>
                        </c:choose>
                    </li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="px-4 py-3">
        <!-- ===================== 업체 기본 정보 카드 ===================== -->
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white py-3 border-bottom-0">
                <h5 class="fw-bold mb-0">업체 기본 정보</h5>
            </div>
            <div class="card-body">
            
            <form id="detailForm" name="detailForm">
                <input type="hidden" name="companyId"   id="hiddenCompanyId"   value="${company.companyId}">
                <input type="hidden" name="tenantId"    value="1">
                <input type="hidden" name="companyType" id="hiddenCompanyType" value="${not empty company.companyType ? company.companyType : param.companyType}">

                <%-- 통합 업체 기본 정보 --%>
                <div class="row mb-3">
                    <div class="col-md-6" id="channelSelectArea" style="display: ${currentMenu eq 'comp_seller' or currentMenu eq 'comp_buyer' ? 'block' : 'none'};">
                        <label class="form-label fw-bold small">참여 채널 <span class="text-danger">*</span></label>
                        <c:choose>
                            <c:when test="${loginVO.roleCd eq 'SUPER_ADMIN' or loginVO.channelCd eq '1'}">
                                <select name="channelId" id="channelId" class="form-select form-select-sm">
                                    <option value="">-- 채널 선택 --</option>
                                    <c:forEach var="chn" items="${allChannelList}">
                                        <option value="${chn.channelId}" ${company.channelId == chn.channelId ? 'selected' : ''}>${chn.channelName}</option>
                                    </c:forEach>
                                </select>
                            </c:when>
                            <c:otherwise>
                                <div class="form-control-plaintext bg-light px-3 border rounded small">
                                    <c:set var="foundChannel" value="false" />
                                    <c:forEach var="chn" items="${allChannelList}">
                                        <c:if test="${loginVO.channelCd == chn.channelId}">
                                            ${chn.channelName}
                                            <input type="hidden" name="channelId" value="${chn.channelId}">
                                            <c:set var="foundChannel" value="true" />
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${not foundChannel}">
                                        <span class="text-danger">소속 채널 정보 없음 (ID: ${loginVO.channelCd})</span>
                                        <input type="hidden" name="channelId" value="${loginVO.channelCd}">
                                    </c:if>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="${currentMenu eq 'comp_seller' or currentMenu eq 'comp_buyer' ? 'col-md-6' : 'col-md-12'}">
                        <label class="form-label fw-bold small">업체명 <span class="text-danger">*</span></label>
                        <input type="text" name="companyName" id="companyName" class="form-control form-control-sm" 
                               value="${fn:escapeXml(company.companyName)}" placeholder="상호명을 입력하세요">
                    </div>
                </div>

                <div class="row mb-3">
                    <c:choose>
                        <c:when test="${company.companyType eq 'SELLER' or param.companyType eq 'SELLER'}">
                            <div class="col-md-4">
                                <label class="form-label fw-bold small">판매업체 유형 <span class="text-danger">*</span></label>
                                <div class="mt-1">
                                    <div class="form-check form-check-inline small">
                                        <input type="radio" name="sellerType" id="sellerTypeRaw" value="RAW"
                                               class="form-check-input" onchange="fn_changeSellerType()"
                                               ${company.sellerType == 'RAW' ? 'checked' : ''}>
                                        <label class="form-check-label" for="sellerTypeRaw">원물</label>
                                    </div>
                                    <div class="form-check form-check-inline small">
                                        <input type="radio" name="sellerType" id="sellerTypeProcessed" value="PROCESSED"
                                               class="form-check-input" onchange="fn_changeSellerType()"
                                               ${company.sellerType == 'PROCESSED' ? 'checked' : ''}>
                                        <label class="form-check-label" for="sellerTypeProcessed">가공</label>
                                    </div>
                                    <div class="form-check form-check-inline small">
                                        <input type="radio" name="sellerType" id="sellerTypeFinished" value="FINISHED"
                                               class="form-check-input" onchange="fn_changeSellerType()"
                                               ${company.sellerType == 'FINISHED' ? 'checked' : ''}>
                                        <label class="form-check-label" for="sellerTypeFinished">완제품</label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                        </c:when>
                        <c:otherwise>
                            <div class="col-md-6">
                        </c:otherwise>
                    </c:choose>
                        <label class="form-label fw-bold small">기본 과세 유형 <span class="text-danger">*</span></label>
                        <div class="mt-1">
                            <div class="form-check form-check-inline small">
                                <input type="radio" name="defaultTaxType" id="taxTaxable" value="TAXABLE"
                                       class="form-check-input"
                                       ${empty company.defaultTaxType or company.defaultTaxType == 'TAXABLE' ? 'checked' : ''}>
                                <label class="form-check-label" for="taxTaxable">과세</label>
                            </div>
                            <div class="form-check form-check-inline small">
                                <input type="radio" name="defaultTaxType" id="taxTaxFree" value="TAX_FREE"
                                       class="form-check-input"
                                       ${company.defaultTaxType == 'TAX_FREE' ? 'checked' : ''}>
                                <label class="form-check-label" for="taxTaxFree">면세</label>
                            </div>
                        </div>
                    </div>
                    <c:choose>
                        <c:when test="${company.companyType eq 'SELLER' or param.companyType eq 'SELLER'}">
                            <div class="col-md-4">
                        </c:when>
                        <c:otherwise>
                            <div class="col-md-6">
                        </c:otherwise>
                    </c:choose>
                        <label class="form-label fw-bold small">상태</label>
                        <div class="mt-1">
                            <div class="form-check form-check-inline small">
                                <input type="radio" name="status" id="stActive" value="ACTIVE"
                                       class="form-check-input"
                                       ${empty company.status or company.status == 'ACTIVE' ? 'checked' : ''}>
                                <label class="form-check-label" for="stActive">정상</label>
                            </div>
                            <div class="form-check form-check-inline small">
                                <input type="radio" name="status" id="stInactive" value="INACTIVE"
                                       class="form-check-input"
                                       ${company.status == 'INACTIVE' ? 'checked' : ''}>
                                <label class="form-check-label" for="stInactive">중지</label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mb-3">
                    <%-- 2. 중단 Row: 사업자번호 + 대표자명 --%>
                    <div class="col-md-6">
                        <label class="form-label fw-bold small">사업자 등록 번호 <span class="text-danger">*</span></label>
                        <div class="input-group input-group-sm">
                            <input type="text" name="businessNo" id="businessNo" class="form-control" 
                                   value="${fn:escapeXml(company.businessNo)}" placeholder="000-00-00000">
                            <button class="btn btn-outline-primary" type="button" onclick="fn_checkBizNo()">중복 확인</button>
                        </div>
                        <div id="bizNoCheckMsg" class="mt-1 small"></div>
                        <input type="hidden" id="bizNoChecked" value="${not empty company.companyId ? 'Y' : 'N'}">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold small">대표자명 <span class="text-danger">*</span></label>
                        <input type="text" name="ceoName" id="ceoName" class="form-control form-control-sm" 
                               value="${fn:escapeXml(company.ceoName)}">
                    </div>
                </div>

                <div class="row mb-3">
                    <%-- 3. 하단 Row: 전화번호 + 팩스 + 이메일 --%>
                    <div class="col-md-4">
                        <label class="form-label fw-bold small">대표 전화번호 <span class="text-danger">*</span></label>
                        <input type="text" name="phone" id="phone" class="form-control form-control-sm" 
                               value="${fn:escapeXml(company.phone)}" placeholder="000-000-0000">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold small">팩스</label>
                        <input type="text" name="fax" id="fax" class="form-control form-control-sm" 
                               value="${fn:escapeXml(company.fax)}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold small">대표 이메일 <span class="text-danger">*</span></label>
                        <input type="email" name="email" id="email" class="form-control form-control-sm" 
                               value="${fn:escapeXml(company.email)}">
                    </div>
                </div>

                <c:if test="${currentMenu eq 'op_mall'}">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">연락처 (추가)</label>
                            <input type="text" name="contactPhone" id="contactPhone" class="form-control form-control-sm" 
                                   value="${fn:escapeXml(company.contactPhone)}" placeholder="010-0000-0000">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">통신판매업 신고번호</label>
                            <input type="text" name="ecommerceRegNo" id="ecommerceRegNo" class="form-control form-control-sm" 
                                   value="${fn:escapeXml(company.ecommerceRegNo)}" placeholder="지자체-2024-시군구-일련번호">
                        </div>
                    </div>
                </c:if>

                <%-- 주소 --%>
                <div class="row mb-3">
                    <div class="col-12">
                        <label class="form-label fw-bold small">주소 <span class="text-danger">*</span></label>
                        <div class="row g-2 mb-2">
                            <div class="col-md-3">
                                <div class="input-group input-group-sm">
                                    <input type="text" name="postalCode" id="postalCode"
                                           class="form-control" placeholder="우편번호"
                                           value="${fn:escapeXml(company.postalCode)}">
                                    <button class="btn btn-outline-secondary" type="button" onclick="fn_searchAddr()">검색</button>
                                </div>
                            </div>
                        </div>
                        <input type="text" name="address1" id="address1"
                               class="form-control form-control-sm mb-2" placeholder="기본 주소"
                               value="${fn:escapeXml(company.address1)}">
                        <input type="text" name="address2" id="address2"
                               class="form-control form-control-sm" placeholder="상세 주소"
                               value="${fn:escapeXml(company.address2)}">
                    </div>
                </div>

                <%-- 공장 주소 --%>
                <div class="row mb-3">
                    <div class="col-12">
                        <label class="form-label fw-bold small">공장 주소</label>
                        <div class="row g-2 mb-2">
                            <div class="col-md-3">
                                <div class="input-group input-group-sm">
                                    <input type="text" name="factoryPostalCode" id="factoryPostalCode"
                                           class="form-control" placeholder="우편번호"
                                           value="${fn:escapeXml(company.factoryPostalCode)}">
                                    <button class="btn btn-outline-secondary" type="button" onclick="fn_searchFactoryAddr()">검색</button>
                                </div>
                            </div>
                        </div>
                        <input type="text" name="factoryAddress1" id="factoryAddress1"
                               class="form-control form-control-sm mb-2" placeholder="공장 기본 주소"
                               value="${fn:escapeXml(company.factoryAddress1)}">
                        <input type="text" name="factoryAddress2" id="factoryAddress2"
                               class="form-control form-control-sm" placeholder="공장 상세 주소"
                               value="${fn:escapeXml(company.factoryAddress2)}">
                    </div>
                </div>


                <%-- 은행 정보 --%>
                <div class="row mb-4">
                    <div class="col-md-4">
                        <label class="form-label fw-bold small">은행명</label>
                        <input type="text" name="bankName" id="bankName" class="form-control form-control-sm" 
                               value="${fn:escapeXml(company.bankName)}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold small">예금주</label>
                        <input type="text" name="accountHolder" id="accountHolder" class="form-control form-control-sm" 
                               value="${fn:escapeXml(company.accountHolder)}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold small">계좌번호</label>
                        <input type="text" name="accountNo" id="accountNo" class="form-control form-control-sm" 
                               value="${fn:escapeXml(company.accountNo)}">
                    </div>
                </div>

                <div class="mt-4 pt-3 border-top d-flex justify-content-end">
                    <c:if test="${currentMenu ne 'op_mall'}">
                    <a href="<c:url value='/admin/company/companyList.do'/>?companyType=${not empty company.companyType ? company.companyType : param.companyType}"
                       class="btn btn-outline-secondary px-4 shadow-sm me-2" style="border-radius: 8px;">
                        <i class="bi bi-list me-1"></i> 목록으로
                    </a>
                    </c:if>
                    <button type="button" class="btn btn-primary px-5 shadow-sm fw-bold" style="border-radius: 8px;" onclick="fn_save(false)">
                        <i class="bi bi-check-lg me-1"></i> 저장하기
                    </button>
                </div>
            </form>
        </div>

        <!-- ===================== 담당자 관리 카드 ===================== -->
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h5 class="fw-bold mb-0">담당자 관리</h5>
                <span class="badge bg-light text-muted border small fw-normal">
                    <i class="bi bi-info-circle me-1"></i> 회원 등록 후 자동 연동됩니다
                </span>
            </div>
            
            <div class="table-responsive">
                <table class="premium-data-table mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">성명</th>
                            <th>역할</th>
                            <th>연락처</th>
                            <th>이메일</th>
                            <th class="text-center">상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty contactList}">
                                <c:forEach var="ct" items="${contactList}">
                                <tr>
                                    <td class="ps-4 fw-bold" style="color: #334155;">${fn:escapeXml(ct.contactName)}</td>
                                    <td>
                                        <span class="badge bg-light text-primary border small fw-normal">${ct.contactRole}</span>
                                    </td>
                                    <td class="small text-muted">${fn:escapeXml(ct.mobile)}</td>
                                    <td class="small text-muted">${fn:escapeXml(ct.email)}</td>
                                    <td class="text-center">
                                        <span class="status-badge status-${ct.status == 'ACTIVE' ? 'ACTIVE' : 'INACTIVE'}">
                                            <span class="status-dot dot-${ct.status == 'ACTIVE' ? 'ACTIVE' : 'INACTIVE'}"></span>
                                            ${ct.status == 'ACTIVE' ? '정상' : '중지'}
                                        </span>
                                    </td>
                                </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="text-center py-4 text-muted small">등록된 담당자가 없습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ===================== 미트머니 관리 카드 (구매업체 전용) ===================== -->
        <c:if test="${company.companyType == 'BUYER' and not empty company.companyId and company.companyId gt 0}">
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white py-3">
                <h5 class="fw-bold mb-0">미트머니(Meat Money) 관리</h5>
            </div>
            <div class="card-body">
                <div class="row g-4">
                    <div class="col-md-4 text-center border-end">
                        <div class="small text-muted mb-1">가용 여신 (Credit)</div>
                        <div class="h4 fw-bold mb-0">0 원</div>
                    </div>
                    <div class="col-md-4 text-center border-end">
                        <div class="small text-muted mb-1">선수금 잔액 (Advance)</div>
                        <div class="h4 fw-bold mb-0">0 원</div>
                    </div>
                    <div class="col-md-4 text-center">
                        <div class="small text-success fw-bold mb-1">총 가용 미트머니</div>
                        <div class="h4 fw-bold text-success mb-0">0 원</div>
                    </div>
                </div>
            </div>
        </div>
        </c:if>

    </div><!-- /container-fluid -->
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
(function () {
    var COMPANY_ID   = '${not empty company.companyId ? company.companyId : 0}';
    var COMPANY_TYPE = '${not empty company.companyType ? company.companyType : param.companyType}';
    var IS_MALL      = '${currentMenu}' === 'op_mall';

    /* ================================================================
       유틸 함수
    ================================================================ */
    window.validationFail = function(msg, selector) {
        console.warn('[Validation Failed]', msg);
        // [FORCE ALERT] 텍스트 알림 (PM 확인용)
        alert(msg);
        
        if (selector) {
            var $el = jQuery(selector);
            if ($el.length) {
                $el.focus().addClass('is-invalid');
                setTimeout(function() { $el.removeClass('is-invalid'); }, 3000);
            }
        }
    };


    /* ================================================================
       사업자번호 중복 체크
    ================================================================ */
    window.fn_checkBizNo = function() {
        var bizNo = (jQuery('#businessNo').val() || '').trim();
        if (!bizNo) { alert('사업자번호를 입력하세요.'); return; }
        
        jQuery.ajax({
            url : '<c:url value="/admin/company/checkBusinessNo.ajax"/>',
            type: 'GET',
            data: { businessNo: bizNo, companyId: COMPANY_ID },
            success: function(res) {
                var $msg = jQuery('#bizNoCheckMsg');
                if (res.success) {
                    if (res.isDuplicate) {
                        $msg.text('이미 등록된 사업자번호입니다.').removeClass('text-success').addClass('text-danger');
                        jQuery('#bizNoChecked').val('N');
                    } else {
                        $msg.text('사용 가능한 사업자번호입니다.').removeClass('text-danger').addClass('text-success');
                        jQuery('#bizNoChecked').val('Y');
                    }
                } else {
                    alert('중복 체크 중 오류 발생: ' + res.message);
                }
            },
            error: function() { alert('통신 오류가 발생했습니다.'); }
        });
    };

    /* ================================================================
       업체 저장 (Extreme Stabilization Version)
    ================================================================ */
    window.fn_save = function(afterSave) {
        try {
            console.log('--- [fn_save initiated] --- afterSave:', afterSave);
            
            var $btn = jQuery('button[onclick*="fn_save"]');
            var originalBtnHtml = $btn.html();
            
            // 중복 클릭 방지
            if ($btn.prop('disabled')) return;
            $btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm me-2"></span>처리중...');
            
            // 버튼 복구 공통 함수
            function restoreBtn() {
                $btn.prop('disabled', false).html(originalBtnHtml);
            }
            
            // 1. 기본 유효성 검사
            var companyName = (jQuery('#companyName').val() || '').trim();
            var businessNo  = (jQuery('#businessNo').val() || '').trim();
            var ceoName     = (jQuery('#ceoName').val() || '').trim();
            
            console.log('Step 1: Basic Check - Name:', companyName, 'BizNo:', businessNo);
            
            if (!companyName) { restoreBtn(); validationFail('업체명을 입력하세요.', '#companyName'); return; }
            if (!ceoName)     { restoreBtn(); validationFail('대표자명을 입력하세요.', '#ceoName'); return; }

            // 2. 사업자번호 및 중복확인
            if (!businessNo)  { restoreBtn(); validationFail('사업자 등록 번호를 입력하세요.', '#businessNo'); return; }
            var bizChecked = jQuery('#bizNoChecked').val();
            
            console.log('Step 2: BizNo Check - IS_MALL:', IS_MALL, 'bizChecked:', bizChecked, 'COMPANY_ID:', COMPANY_ID);
            
            if (!IS_MALL && (!COMPANY_ID || COMPANY_ID === '0')) {
                if (bizChecked !== 'Y') { 
                    restoreBtn();
                    validationFail('사업자번호 중복 확인을 먼저 해주세요.', '#businessNo'); 
                    return; 
                }
            }

            // 3. 연락처 및 주소 (최소 필수값)
            var phone = (jQuery('#phone').val() || '').trim();
            var email = (jQuery('#email').val() || '').trim();
            var addr1 = (jQuery('#address1').val() || '').trim();
            
            console.log('Step 3: Contact Check - Phone:', phone, 'Email:', email);
            
            if (!phone) { restoreBtn(); validationFail('대표 전화번호를 입력하세요.', '#phone'); return; }
            if (!email) { restoreBtn(); validationFail('대표 이메일을 입력하세요.', '#email'); return; }
            if (!addr1) { restoreBtn(); validationFail('기본 주소를 입력하세요.', '#address1'); return; }

            // 4. 채널 확인 (판매/구매업체 전용, channelSelectArea가 표시된 경우만)
            var ctype = (typeof COMPANY_TYPE !== 'undefined' ? COMPANY_TYPE : '');
            // select 박스 또는 hidden input 모두에서 channelId를 읽음
            var $channelSelect = jQuery('#channelId');
            var $channelHidden = jQuery('input[name="channelId"]');
            var channelId = ($channelSelect.length && $channelSelect.val()) 
                          ? $channelSelect.val()
                          : ($channelHidden.length ? $channelHidden.val() : '');
            var channelAreaVisible = jQuery('#channelSelectArea').is(':visible');
            
            console.log('Step 4: Type/Channel Check - Type:', ctype, 'ChannelId:', channelId, 'AreaVisible:', channelAreaVisible);
            
            if (channelAreaVisible && (ctype === 'SELLER' || ctype === 'BUYER') && !channelId) { 
                restoreBtn();
                validationFail('참여 채널을 선택하세요.', '#channelId'); 
                return; 
            }

            // 4.5 판매업체 유형 확인
            if (ctype === 'SELLER') {
                var sellerType = jQuery('input[name="sellerType"]:checked').val();
                if (!sellerType) { restoreBtn(); validationFail('판매업체 유형을 선택하세요.', '#sellerTypeRaw'); return; }
            }

            // 5. 서버 전송
            console.log('Step 5: Serializing and Sending...');
            var formData = jQuery('#detailForm').serialize();

            jQuery.ajax({
                url : '<c:url value="/admin/company/saveCompany.ajax"/>',
                type: 'POST',
                data: formData,
                success: function(res) {
                    console.log('Step 6: AJAX Success Response:', res);
                    if (res.success) {
                        var cid = res.companyId || COMPANY_ID;
                        
                        fn_saveAdditionalInfo(cid, function() {
                            if (window.fn_toast) {
                                fn_toast('정상적으로 저장되었습니다.', 'success');
                            } else {
                                alert('정상적으로 저장되었습니다.');
                            }
                            setTimeout(function() {
                                if (IS_MALL) {
                                    location.reload();
                                } else {
                                    var type = ctype || COMPANY_TYPE || 'SELLER';
                                    location.href = '<c:url value="/admin/company/companyList.do"/>?companyType=' + type;
                                }
                            }, 2000);
                        });
                    } else {
                        alert('저장 실패: ' + res.message);
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Step 7: AJAX Critical Error:', status, error);
                    alert('서버와의 통신에 실패했습니다.');
                },
                complete: function() {
                    restoreBtn();
                }
            });
        } catch (e) {
            console.error('--- [CRITICAL SAVE ERROR] ---', e);
            alert('자바스크립트 오류: ' + e.message);
        }
    };

    window.fn_saveAdditionalInfo = function(companyId, callback) {
        var chId = jQuery('#channelId').val() || jQuery('input[name="channelId"]').val();
        if (!chId) { if(callback) callback(); return; }
        
        var roles = [COMPANY_TYPE === 'BUYER' ? 'BUYER_ADMIN' : (chId === '1' ? 'SELLER_ADMIN' : 'CHANNEL_ADMIN')];
        jQuery.ajax({
            url: '<c:url value="/admin/company/saveChannels.ajax"/>',
            type: 'POST',
            data: { companyId: companyId, 'channelIds[]': [chId], 'roles[]': roles },
            success: function() { if(callback) callback(); },
            error: function() { alert('채널 매핑 저장 오류'); if(callback) callback(); }
        });
    };

    /* 주소 검색 */
    window.fn_searchAddr = function() {
        new daum.Postcode({
            oncomplete: function(data) {
                jQuery('#postalCode').val(data.zonecode);
                jQuery('#address1').val(data.address);
                jQuery('#address2').focus();
            }
        }).open();
    };
    window.fn_searchFactoryAddr = function() {
        new daum.Postcode({
            oncomplete: function(data) {
                jQuery('#factoryPostalCode').val(data.zonecode);
                jQuery('#factoryAddress1').val(data.address);
                jQuery('#factoryAddress2').focus();
            }
        }).open();
    };
    
    /* 판매업체 유형 변경 시 과세/면세 자동 전환 */
    window.fn_changeSellerType = function() {
        var type = jQuery('input[name="sellerType"]:checked').val();
        if (type === 'RAW') {
            jQuery('#taxTaxFree').prop('checked', true);
        } else if (type === 'PROCESSED' || type === 'FINISHED') {
            jQuery('#taxTaxable').prop('checked', true);
        }
    };
    
    /* ================================================================
       담당자 관리 (수동 CRUD)
    ================================================================ */
    window.fn_addContact = function() {
        if (!COMPANY_ID || COMPANY_ID === '0') {
            alert('업체 정보를 먼저 저장한 후 담당자를 추가할 수 있습니다.');
            return;
        }
        alert('회원관리에서 회원을 등록하시면 자동으로 담당자 목록에 추가됩니다. 수동 추가가 필요하시면 @개발자에게 요청해 주세요.');
    };

    window.fn_deleteContact = function(id) {
        if (!confirm('해당 담당자를 삭제하시겠습니까?')) return;
        jQuery.ajax({
            url: '<c:url value="/admin/company/deleteContact.ajax"/>',
            type: 'POST',
            data: { contactId: id },
            success: function(res) {
                if (res.success) {
                    alert('삭제되었습니다.');
                    location.reload();
                }
            }
        });
    };

})();
</script>
