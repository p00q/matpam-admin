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
                            <c:when test="${loginVO.roleCd eq 'SUPER_ADMIN' or loginVO.roleCd eq 'OPERATOR'}">
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
                                        <c:if test="${loginVO.channelId == chn.channelId}">
                                            ${chn.channelName}
                                            <input type="hidden" name="channelId" value="${chn.channelId}">
                                            <c:set var="foundChannel" value="true" />
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${not foundChannel}">
                                        <span class="text-danger">소속 채널 정보 없음 (ID: ${loginVO.channelId})</span>
                                        <input type="hidden" name="channelId" value="${loginVO.channelId}">
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
                <div class="d-flex align-items-center gap-2">
                    <span class="badge bg-light text-muted border small fw-normal">
                        <i class="bi bi-info-circle me-1"></i> 회원 등록 후 자동 연동됩니다
                    </span>
                    <c:if test="${currentMenu eq 'op_mall'}">
                        <button type="button" class="btn btn-primary btn-sm px-3" style="border-radius:8px;" onclick="fn_openMallOperatorModal()">
                            <i class="bi bi-person-plus me-1"></i> 운영자 추가
                        </button>
                    </c:if>
                </div>
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
                            <c:if test="${currentMenu eq 'op_mall'}">
                                <th class="text-center">관리</th>
                            </c:if>
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
                                        <span class="status-badge status-${ct.userStatus == 'ACTIVE' ? 'ACTIVE' : 'INACTIVE'}">
                                            <span class="status-dot dot-${ct.userStatus == 'ACTIVE' ? 'ACTIVE' : 'INACTIVE'}"></span>
                                            <c:choose>
                                                <c:when test="${ct.userStatus eq 'ACTIVE'}">정상</c:when>
                                                <c:when test="${ct.userStatus eq 'LOCKED'}">잠김</c:when>
                                                <c:otherwise>중지</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <c:if test="${currentMenu eq 'op_mall'}">
                                        <td class="text-center">
                                            <button type="button"
                                                    class="btn btn-outline-primary btn-sm"
                                                    style="border-radius:8px;"
                                                    onclick="fn_openMallOperatorModal(this)"
                                                    data-user-id="${ct.linkedUserId}"
                                                    data-user-role="${ct.userRole}"
                                                    data-login-id="${fn:escapeXml(ct.loginId)}"
                                                    data-name="${fn:escapeXml(ct.contactName)}"
                                                    data-mobile="${fn:escapeXml(ct.mobile)}"
                                                    data-email="${fn:escapeXml(ct.email)}"
                                                    data-status="${empty ct.userStatus ? 'ACTIVE' : ct.userStatus}">
                                                <i class="bi bi-pencil-square me-1"></i> 수정
                                            </button>
                                        </td>
                                    </c:if>
                                </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="${currentMenu eq 'op_mall' ? 6 : 5}" class="text-center py-4 text-muted small">등록된 담당자가 없습니다.</td>
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

<c:if test="${currentMenu eq 'op_mall'}">
<div class="modal fade" id="mallOperatorModal" tabindex="-1" aria-hidden="true" style="z-index: 2100;">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px; overflow:hidden;">
            <div class="modal-header bg-white border-bottom">
                <h6 class="modal-title fw-bold mb-0" id="mallOperatorModalTitle">
                    <i class="bi bi-person-badge me-2 text-primary"></i>몰 운영자 추가
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <form id="mallOperatorForm">
                    <input type="hidden" name="userId" id="mallOperatorUserId">
                    <input type="hidden" name="tenantId" value="${not empty company.tenantId ? company.tenantId : 1}">
                    <input type="hidden" name="companyId" value="${company.companyId}">
                    <input type="hidden" name="userRole" id="mallOperatorRole" value="OPERATOR">
                    <input type="hidden" name="contactRole" value="ADMIN">

                    <div class="mb-3">
                        <label class="form-label fw-bold small">로그인 ID <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <input type="text" name="loginId" id="mallOperatorLoginId" class="form-control" maxlength="20" autocomplete="off">
                            <button type="button" id="mallOperatorIdCheckBtn" class="btn btn-outline-secondary" onclick="fn_checkMallOperatorLoginId()">중복 확인</button>
                        </div>
                        <input type="hidden" id="mallOperatorIdChecked" value="N">
                        <div id="mallOperatorIdMsg" class="small mt-1"></div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold small">이름 <span class="text-danger">*</span></label>
                        <input type="text" name="userName" id="mallOperatorName" class="form-control" maxlength="50" placeholder="담당자 이름">
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">비밀번호 <span id="mallOperatorPasswordRequired" class="text-danger">*</span></label>
                            <input type="password" name="passwordHash" id="mallOperatorPassword" class="form-control" maxlength="100" autocomplete="new-password" placeholder="신규 또는 변경 시 입력">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">비밀번호 확인</label>
                            <input type="password" id="mallOperatorPasswordConfirm" class="form-control" maxlength="100" autocomplete="new-password" placeholder="비밀번호 재입력">
                        </div>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">연락처</label>
                            <input type="text" name="mobile" id="mallOperatorMobile" class="form-control" maxlength="13" inputmode="tel" autocomplete="off" placeholder="010-0000-0000">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">이메일</label>
                            <input type="email" name="email" id="mallOperatorEmail" class="form-control" maxlength="100" autocomplete="off" placeholder="name@example.com">
                        </div>
                    </div>

                    <div>
                        <label class="form-label fw-bold small">상태</label>
                        <div class="d-flex gap-4">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="status" id="mallOperatorStatusActive" value="ACTIVE" checked>
                                <label class="form-check-label" for="mallOperatorStatusActive">정상</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="status" id="mallOperatorStatusLocked" value="LOCKED">
                                <label class="form-check-label" for="mallOperatorStatusLocked">잠김</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="status" id="mallOperatorStatusInactive" value="INACTIVE">
                                <label class="form-check-label" for="mallOperatorStatusInactive">중지</label>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer bg-light border-top">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" id="mallOperatorSaveBtn" class="btn btn-primary px-4" onclick="fn_saveMallOperator()">
                    <i class="bi bi-check2-circle me-1"></i> 저장
                </button>
            </div>
        </div>
    </div>
</div>
</c:if>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
(function () {
    var COMPANY_ID   = '${not empty company.companyId ? company.companyId : 0}';
    var COMPANY_TYPE = '${not empty company.companyType ? company.companyType : param.companyType}';
    var IS_MALL      = '${currentMenu}' === 'op_mall';
    jQuery('#global-loader').hide();

    /* ================================================================
       유틸 함수
    ================================================================ */
    window.showCompanyMessagePopup = function(msg) {
        var modalId = 'companyMessagePopup';
        var $modal = jQuery('#' + modalId);

        if (!$modal.length) {
            jQuery('body').append(
                '<div class="modal fade" id="' + modalId + '" tabindex="-1" aria-hidden="true" style="z-index: 2100;">' +
                '  <div class="modal-dialog modal-dialog-centered" style="max-width: 420px;">' +
                '    <div class="modal-content border-0 shadow-lg" style="border-radius: 16px; overflow: hidden;">' +
                '      <div class="modal-header border-0 pb-0">' +
                '        <h6 class="modal-title fw-bold text-dark mb-0"><i class="bi bi-exclamation-circle-fill text-warning me-2"></i>입력 확인</h6>' +
                '        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>' +
                '      </div>' +
                '      <div class="modal-body pt-3 pb-2">' +
                '        <div id="' + modalId + 'Msg" class="small text-secondary" style="line-height:1.6;"></div>' +
                '      </div>' +
                '      <div class="modal-footer border-0 pt-0">' +
                '        <button type="button" class="btn btn-primary btn-sm px-4" data-bs-dismiss="modal" style="border-radius:8px;">확인</button>' +
                '      </div>' +
                '    </div>' +
                '  </div>' +
                '</div>'
            );
            $modal = jQuery('#' + modalId);
        }

        jQuery('#' + modalId + 'Msg').text(msg);
        if (window.bootstrap && bootstrap.Modal) {
            bootstrap.Modal.getOrCreateInstance($modal[0]).show();
        } else if (window.fn_toast) {
            fn_toast(msg, 'warning');
        } else {
            alert(msg);
        }
    };

    window.validationFail = function(msg, selector) {
        console.warn('[Validation Failed]', msg);
        // Browser alert 대신 화면 내부 팝업을 사용한다.
        showCompanyMessagePopup(msg);
        
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
            
            // 1. 참여 채널 확인 (UI 최상단)
            var ctype = (typeof COMPANY_TYPE !== 'undefined' ? COMPANY_TYPE : '');
            var $channelSelect = jQuery('#channelId');
            var $channelHidden = jQuery('input[name="channelId"]');
            var channelId = ($channelSelect.length && $channelSelect.val()) 
                          ? $channelSelect.val()
                          : ($channelHidden.length ? $channelHidden.val() : '');
            var channelAreaVisible = jQuery('#channelSelectArea').is(':visible');
            
            if (channelAreaVisible && (ctype === 'SELLER' || ctype === 'BUYER') && !channelId) { 
                restoreBtn();
                validationFail('참여 채널을 선택하세요.', '#channelId'); 
                return; 
            }

            // 2. 업체명
            var companyName = (jQuery('#companyName').val() || '').trim();
            if (!companyName) { restoreBtn(); validationFail('업체명을 입력하세요.', '#companyName'); return; }

            // 3. 판매업체 유형 (판매업체 전용)
            if (ctype === 'SELLER') {
                var sellerType = jQuery('input[name="sellerType"]:checked').val();
                if (!sellerType) { restoreBtn(); validationFail('판매업체 유형을 선택하세요.', '#sellerTypeRaw'); return; }
            }

            // 4. 사업자번호 및 중복확인
            var businessNo  = (jQuery('#businessNo').val() || '').trim();
            if (!businessNo)  { restoreBtn(); validationFail('사업자 등록 번호를 입력하세요.', '#businessNo'); return; }
            var bizChecked = jQuery('#bizNoChecked').val();
            if (!IS_MALL && (!COMPANY_ID || COMPANY_ID === '0')) {
                if (bizChecked !== 'Y') { 
                    restoreBtn();
                    validationFail('사업자번호 중복 확인을 먼저 해주세요.', '#businessNo'); 
                    return; 
                }
            }

            // 5. 대표자명
            var ceoName = (jQuery('#ceoName').val() || '').trim();
            if (!ceoName) { restoreBtn(); validationFail('대표자명을 입력하세요.', '#ceoName'); return; }

            // 6. 연락처 (전화, 이메일)
            var phone = (jQuery('#phone').val() || '').trim();
            var email = (jQuery('#email').val() || '').trim();
            if (!phone) { restoreBtn(); validationFail('대표 전화번호를 입력하세요.', '#phone'); return; }
            if (!email) { restoreBtn(); validationFail('대표 이메일을 입력하세요.', '#email'); return; }

            // 7. 주소 (UI 최하단부)
            var addr1 = (jQuery('#address1').val() || '').trim();
            if (!addr1) { restoreBtn(); validationFail('기본 주소를 입력하세요.', '#address1'); return; }

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
    function openPostcodeLayer(onComplete) {
        if (!window.daum || !daum.Postcode) {
            showCompanyMessagePopup('주소 검색 서비스를 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.');
            return;
        }

        var modalId = 'postcodeLayerModal';
        var bodyId = 'postcodeLayerBody';
        var $modal = jQuery('#' + modalId);

        if (!$modal.length) {
            jQuery('body').append(
                '<div class="modal fade" id="' + modalId + '" tabindex="-1" aria-hidden="true" style="z-index: 2100;">' +
                '  <div class="modal-dialog modal-dialog-centered modal-lg">' +
                '    <div class="modal-content border-0 shadow-lg" style="border-radius: 16px; overflow: hidden;">' +
                '      <div class="modal-header bg-white border-bottom">' +
                '        <h6 class="modal-title fw-bold mb-0"><i class="bi bi-search me-2 text-primary"></i>주소 검색</h6>' +
                '        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>' +
                '      </div>' +
                '      <div class="modal-body p-0">' +
                '        <div id="' + bodyId + '" style="position:relative; width:100%; height:520px;"></div>' +
                '      </div>' +
                '    </div>' +
                '  </div>' +
                '</div>'
            );
            $modal = jQuery('#' + modalId);
        }

        var modal = bootstrap.Modal.getOrCreateInstance($modal[0]);
        var $body = jQuery('#' + bodyId).html(
            '<div id="postcodeLayerFrame" style="position:relative; width:100%; height:520px;"></div>' +
            '<div id="postcodeLayerLoading" class="d-flex justify-content-center align-items-center text-muted small" ' +
            '     style="position:absolute; inset:56px 0 0 0; background:#fff; z-index:2;">' +
            '주소 검색을 불러오는 중입니다.' +
            '</div>'
        );

        $modal.off('shown.bs.modal.postcode').one('shown.bs.modal.postcode', function() {
            var $frame = jQuery('#postcodeLayerFrame');
            var $loading = jQuery('#postcodeLayerLoading');
            new daum.Postcode({
                width: '100%',
                height: '100%',
                onresize: function(size) {
                    if (size && size.height) {
                        $frame.height(Math.max(size.height, 520));
                        $body.height(Math.max(size.height, 520));
                    }
                    $loading.remove();
                },
                oncomplete: function(data) {
                    onComplete(data);
                    modal.hide();
                }
            }).embed($frame[0]);

            setTimeout(function() {
                $loading.remove();
            }, 3500);
        });

        modal.show();
    }

    function openPostcodeFixedLayer(onComplete) {
        if (!window.daum || !daum.Postcode) {
            showCompanyMessagePopup('주소 검색 서비스를 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.');
            return;
        }

        jQuery('#postcodeLayerModal').remove();
        jQuery('.modal-backdrop').remove();
        jQuery('body').removeClass('modal-open').css('overflow', '');

        var layerId = 'postcodeFixedLayer';
        var frameId = 'postcodeFixedFrame';
        var $layer = jQuery('#' + layerId);

        if (!$layer.length) {
            jQuery('body').append(
                '<div id="' + layerId + '" style="display:none; position:fixed; inset:0; z-index:3000; background:rgba(15,23,42,.55);">' +
                '  <div style="position:absolute; left:50%; top:50%; transform:translate(-50%,-50%); width:min(760px, calc(100vw - 32px)); background:#fff; border-radius:16px; overflow:hidden; box-shadow:0 20px 60px rgba(0,0,0,.25);">' +
                '    <div style="height:56px; display:flex; align-items:center; justify-content:space-between; padding:0 18px; border-bottom:1px solid #e5e7eb;">' +
                '      <div style="font-weight:700; color:#111827;"><i class="bi bi-search me-2 text-primary"></i>주소 검색</div>' +
                '      <button type="button" id="postcodeFixedClose" class="btn-close" aria-label="Close"></button>' +
                '    </div>' +
                '    <div id="' + frameId + '" style="position:relative; width:100%; height:520px;">' +
                '      <div id="postcodeFixedLoading" class="d-flex justify-content-center align-items-center text-muted small" style="position:absolute; inset:0; background:#fff; z-index:2;">주소 검색을 불러오는 중입니다.</div>' +
                '    </div>' +
                '  </div>' +
                '</div>'
            );
            $layer = jQuery('#' + layerId);
            jQuery(document).on('click', '#postcodeFixedClose', function() {
                jQuery('#' + layerId).hide();
                jQuery('#' + frameId).empty();
            });
        }

        var $frame = jQuery('#' + frameId).html(
            '<div id="postcodeFixedLoading" class="d-flex justify-content-center align-items-center text-muted small" style="position:absolute; inset:0; background:#fff; z-index:2;">주소 검색을 불러오는 중입니다.</div>'
        );
        var $loading = jQuery('#postcodeFixedLoading');
        $layer.show();

        new daum.Postcode({
            width: '100%',
            height: '100%',
            onresize: function(size) {
                if (size && size.height) {
                    $frame.height(Math.max(size.height, 520));
                }
                $loading.remove();
            },
            oncomplete: function(data) {
                onComplete(data);
                $layer.hide();
                $frame.empty();
            }
        }).embed($frame[0]);

        setTimeout(function() {
            $loading.remove();
        }, 3500);
    }

    window.fn_searchAddr = function() {
        openPostcodeFixedLayer(function(data) {
            jQuery('#postalCode').val(data.zonecode);
            jQuery('#address1').val(data.address);
            jQuery('#address2').focus();
        });
    };
    window.fn_searchFactoryAddr = function() {
        openPostcodeFixedLayer(function(data) {
            jQuery('#factoryPostalCode').val(data.zonecode);
            jQuery('#factoryAddress1').val(data.address);
            jQuery('#factoryAddress2').focus();
        });
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
        fn_openMallOperatorModal();
    };

    window.fn_openMallOperatorModal = function(button) {
        if (!COMPANY_ID || COMPANY_ID === '0') {
            showCompanyMessagePopup('몰 기본정보를 먼저 저장한 후 담당자를 추가할 수 있습니다.');
            return;
        }

        if (!IS_MALL) {
            showCompanyMessagePopup('몰 운영자 담당자는 몰 기본정보 화면에서만 관리할 수 있습니다.');
            return;
        }

        var $form = jQuery('#mallOperatorForm');
        jQuery('#global-loader').hide();
        if (!$form.length) {
            showCompanyMessagePopup('몰 운영자 관리 화면을 찾을 수 없습니다.');
            return;
        }

        $form[0].reset();
        jQuery('#mallOperatorIdMsg').empty();
        jQuery('#mallOperatorIdChecked').val('N');
        jQuery('#mallOperatorUserId').val('');
        jQuery('#mallOperatorLoginId').val('').prop('readonly', false);
        jQuery('#mallOperatorName').val('');
        jQuery('#mallOperatorPassword').val('');
        jQuery('#mallOperatorPasswordConfirm').val('');
        jQuery('#mallOperatorMobile').val('');
        jQuery('#mallOperatorEmail').val('');
        jQuery('#mallOperatorIdCheckBtn').show();
        jQuery('#mallOperatorPasswordRequired').show();
        jQuery('#mallOperatorRole').val('OPERATOR');
        jQuery('#mallOperatorModalTitle').html('<i class="bi bi-person-badge me-2 text-primary"></i>몰 운영자 추가');

        if (button) {
            var $btn = jQuery(button);
            var userId = $btn.data('user-id');
            var userRole = $btn.data('user-role') || 'OPERATOR';
            if (!userId) {
                showCompanyMessagePopup('연결된 운영자 계정이 없어 이 화면에서 수정할 수 없습니다.');
                return;
            }
            if (userRole !== 'OPERATOR') {
                showCompanyMessagePopup('몰 운영자 계정만 이 화면에서 수정할 수 있습니다.');
                return;
            }

            jQuery('#mallOperatorUserId').val(userId);
            jQuery('#mallOperatorRole').val(userRole);
            jQuery('#mallOperatorLoginId').val($btn.data('login-id') || '').prop('readonly', true);
            jQuery('#mallOperatorIdCheckBtn').hide();
            jQuery('#mallOperatorIdChecked').val('Y');
            jQuery('#mallOperatorName').val($btn.data('name') || '');
            jQuery('#mallOperatorMobile').val($btn.data('mobile') || '');
            jQuery('#mallOperatorEmail').val($btn.data('email') || '');
            jQuery('#mallOperatorPasswordRequired').hide();
            jQuery('#mallOperatorModalTitle').html('<i class="bi bi-person-badge me-2 text-primary"></i>몰 운영자 수정');

            var status = $btn.data('status') || 'ACTIVE';
            jQuery('#mallOperatorForm input[name="status"][value="' + status + '"]').prop('checked', true);
        } else {
            jQuery('#mallOperatorStatusActive').prop('checked', true);
        }

        bootstrap.Modal.getOrCreateInstance(document.getElementById('mallOperatorModal')).show();
        if (!button) {
            setTimeout(function() {
                jQuery('#mallOperatorLoginId').val('').focus();
            }, 100);
        }
    };

    window.fn_checkMallOperatorLoginId = function() {
        var loginId = (jQuery('#mallOperatorLoginId').val() || '').trim();
        var $msg = jQuery('#mallOperatorIdMsg');

        if (!loginId) {
            showCompanyMessagePopup('로그인 ID를 입력하세요.');
            jQuery('#mallOperatorLoginId').focus();
            return;
        }
        if (!/^[A-Za-z0-9_]{4,20}$/.test(loginId)) {
            jQuery('#mallOperatorIdChecked').val('N');
            $msg.html('<span class="text-danger">로그인 ID는 영문, 숫자, 밑줄(_) 4~20자로 입력하세요.</span>');
            jQuery('#mallOperatorLoginId').focus();
            return;
        }

        jQuery.get('<c:url value="/admin/user/checkLoginId.ajax"/>', { loginId: loginId }, function(res) {
            if (res && res.success && !res.duplicated) {
                jQuery('#mallOperatorIdChecked').val('Y');
                $msg.html('<span class="text-success">사용 가능한 ID입니다.</span>');
            } else {
                jQuery('#mallOperatorIdChecked').val('N');
                $msg.html('<span class="text-danger">이미 사용 중인 ID입니다.</span>');
            }
        }).fail(function() {
            jQuery('#mallOperatorIdChecked').val('N');
            $msg.html('<span class="text-danger">중복 확인에 실패했습니다.</span>');
        });
    };

    window.fn_saveMallOperator = function() {
        var userId = (jQuery('#mallOperatorUserId').val() || '').trim();
        var loginId = (jQuery('#mallOperatorLoginId').val() || '').trim();
        var userName = (jQuery('#mallOperatorName').val() || '').trim();
        var password = jQuery('#mallOperatorPassword').val() || '';
        var passwordConfirm = jQuery('#mallOperatorPasswordConfirm').val() || '';
        var mobile = formatMallOperatorMobile(jQuery('#mallOperatorMobile').val() || '');
        jQuery('#mallOperatorMobile').val(mobile);
        var email = (jQuery('#mallOperatorEmail').val() || '').trim();
        var loginIdPattern = /^[A-Za-z0-9_]{4,20}$/;
        var mobilePattern = /^01[016789]-\d{3,4}-\d{4}$/;
        var emailPattern = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

        if (!loginId) { showCompanyMessagePopup('로그인 ID를 입력하세요.'); jQuery('#mallOperatorLoginId').focus(); return; }
        if (!loginIdPattern.test(loginId)) {
            showCompanyMessagePopup('로그인 ID는 영문, 숫자, 밑줄(_) 4~20자로 입력하세요.');
            jQuery('#mallOperatorLoginId').focus();
            return;
        }
        if (!userId && jQuery('#mallOperatorIdChecked').val() !== 'Y') {
            showCompanyMessagePopup('로그인 ID 중복 확인을 먼저 해주세요.');
            return;
        }
        if (!userName) { showCompanyMessagePopup('이름을 입력하세요.'); jQuery('#mallOperatorName').focus(); return; }
        if (userName.length > 50) { showCompanyMessagePopup('이름은 50자 이하로 입력하세요.'); jQuery('#mallOperatorName').focus(); return; }
        if (!userId && !password) { showCompanyMessagePopup('비밀번호를 입력하세요.'); jQuery('#mallOperatorPassword').focus(); return; }
        if (password && password.length > 100) { showCompanyMessagePopup('비밀번호는 100자 이하로 입력하세요.'); jQuery('#mallOperatorPassword').focus(); return; }
        if (password && password !== passwordConfirm) {
            showCompanyMessagePopup('비밀번호가 일치하지 않습니다.');
            jQuery('#mallOperatorPasswordConfirm').focus();
            return;
        }
        if (mobile && !mobilePattern.test(mobile)) {
            showCompanyMessagePopup('연락처는 010-1234-5678 형식으로 입력하세요.');
            jQuery('#mallOperatorMobile').focus();
            return;
        }
        if (email && (email.length > 100 || !emailPattern.test(email))) {
            showCompanyMessagePopup('이메일은 100자 이하의 올바른 이메일 형식으로 입력하세요.');
            jQuery('#mallOperatorEmail').focus();
            return;
        }

        var $saveButton = jQuery('#mallOperatorSaveBtn');
        if ($saveButton.prop('disabled')) return;
        $saveButton.prop('disabled', true);

        jQuery.ajax({
            url: '<c:url value="/admin/user/saveUser.ajax"/>',
            type: 'POST',
            global: false,
            timeout: 15000,
            dataType: 'json',
            data: jQuery('#mallOperatorForm').serialize(),
            success: function(res) {
                if (res && res.success) {
                    if (window.fn_toast) {
                        fn_toast(res.message || '저장되었습니다.', 'success');
                    }
                    bootstrap.Modal.getOrCreateInstance(document.getElementById('mallOperatorModal')).hide();
                    setTimeout(function() { location.reload(); }, 500);
                } else {
                    showCompanyMessagePopup((res && res.message) || '저장 중 오류가 발생했습니다.');
                }
            },
            error: function(xhr) {
                var message = '저장 요청에 실패했습니다.';
                if (xhr.responseJSON && xhr.responseJSON.message) {
                    message = xhr.responseJSON.message;
                }
                showCompanyMessagePopup(message);
            },
            complete: function() {
                $saveButton.prop('disabled', false);
            }
        });
    };

    jQuery(document).on('input', '#mallOperatorLoginId', function() {
        jQuery('#mallOperatorIdChecked').val('N');
        jQuery('#mallOperatorIdMsg').empty();
        this.value = this.value.replace(/[^A-Za-z0-9_]/g, '').slice(0, 20);
    });

    function formatMallOperatorMobile(value) {
        var digits = (value || '').replace(/\D/g, '').slice(0, 11);
        if (digits.length <= 3) {
            return digits;
        }
        if (digits.length <= 7) {
            return digits.slice(0, 3) + '-' + digits.slice(3);
        }
        return digits.slice(0, 3) + '-' + digits.slice(3, 7) + '-' + digits.slice(7);
    }

    jQuery(document).on('input', '#mallOperatorMobile', function() {
        this.value = formatMallOperatorMobile(this.value);
    });

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
