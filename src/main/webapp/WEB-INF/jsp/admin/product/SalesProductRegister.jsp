<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 판매상품 등록/수정 -->
<style>
    /* Page specific overrides if any */
    .image-upload-box {
        width: 100%;
        height: 160px;
        border: 2px dashed var(--border-color);
        border-radius: var(--radius-md);
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        background-color: #fff;
        position: relative;
        overflow: hidden;
        transition: var(--transition);
    }

    .image-upload-box:hover {
        border-color: var(--accent);
        background-color: #fefce8;
    }

    .image-upload-box img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .tax-summary-card {
        background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
        border: 1px solid var(--border-color);
        border-radius: var(--radius-md);
        padding: 1.25rem;
    }

    .tax-summary-item {
        display: flex;
        justify-content: space-between;
        margin-bottom: 0.5rem;
        font-size: 0.9rem;
    }

    .tax-summary-total {
        border-top: 1px solid var(--border-color);
        padding-top: 0.75rem;
        margin-top: 0.75rem;
        font-weight: 700;
        font-size: 1.05rem;
        color: var(--primary);
    }
</style>

<div class="animate-fade-in">
    <!-- Breadcrumb & Title -->
    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1" style="font-size: 0.85rem;">
                    <li class="breadcrumb-item text-muted">상품 관리</li>
                    <li class="breadcrumb-item active">판매상품</li>
                </ol>
            </nav>
            <h3 class="fw-bold mb-0" style="letter-spacing: -1px; color: var(--primary);">
                <c:choose>
                    <c:when test="${salesProduct.salesProdId != null}">판매상품 (v2) <span class="text-accent" style="color:var(--accent)">상세 정보</span></c:when>
                    <c:otherwise>새로운 판매상품 (v2) <span class="text-accent" style="color:var(--accent)">등록</span></c:otherwise>
                </c:choose>
            </h3>
        </div>
        <div>
            <button type="button" class="btn btn-outline-secondary btn-premium px-4" onclick="fn_goList()">
                <i class="bi bi-list me-2"></i>목록으로
            </button>
        </div>
    </div>

    <form name="productForm" method="post" action="${pageContext.request.contextPath}/admin/product/salesProductRegister.do" enctype="multipart/form-data">
        <input type="hidden" name="salesProdId" value="<c:out value='${salesProduct.salesProdId}'/>" />
        <input type="hidden" name="salesProdCode" value="<c:out value='${salesProduct.salesProdCode}'/>" />

        <c:if test="${not empty compositionJson}">
            <script type="application/json" id="compositionData"><c:out value='${compositionJson}' escapeXml="false"/></script>
        </c:if>

        <fmt:formatNumber var="listPriceFormatted" value="${empty salesProduct.listPrice ? 0 : salesProduct.listPrice}" type="number" maxFractionDigits="0" groupingUsed="false" />
        <fmt:formatNumber var="costPriceFormatted" value="${empty salesProduct.costPrice ? (empty salesProduct.listPrice ? 0 : salesProduct.listPrice) : salesProduct.costPrice}" type="number" maxFractionDigits="0" groupingUsed="false" />
                        <fmt:formatNumber var="viewCountFormatted"
                            value="${empty salesProduct.viewCnt ? 0 : salesProduct.viewCnt}" type="number"
                            maxFractionDigits="0" groupingUsed="false" />

                                <!-- 1. 상품일반정보 & Tax Summary -->
        <div class="row g-4">
            <div class="col-lg-8">
                <div class="premium-card h-100">
                    <div class="section-title">기본 정보</div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">상품명</label>
                            <input type="text" name="salesProdName" class="form-control" value="<c:out value='${salesProduct.salesProdName}'/>" required />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">상품 요약</label>
                            <input type="text" name="summary" class="form-control" value="<c:out value='${salesProduct.summary}'/>" />
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold small">판매 가격</label>
                            <div class="input-group border border-primary-subtle rounded">
                                <input type="number" name="listPrice" id="listPrice" class="form-control fw-bold text-primary" step="1" min="0" value="<c:out value='${listPriceFormatted}' default='0'/>" />
                                <span class="input-group-text bg-primary-subtle text-primary border-0">원</span>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold small">VAT (자동 계산)</label>
                            <div class="input-group">
                                <input type="number" name="vatAmount" id="vatAmount" class="form-control bg-light" value="<c:out value='${empty salesProduct.vatAmount ? 0 : salesProduct.vatAmount}' default='0'/>" readonly />
                                <span class="input-group-text">원</span>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold small">원가</label>
                            <div class="input-group">
                                <input type="number" name="costPrice" id="costPrice" class="form-control" step="1" min="0" value="<c:out value='${costPriceFormatted}' default='0'/>" />
                                <span class="input-group-text">원</span>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold small text-danger">할인 금액</label>
                            <div class="input-group">
                                <input type="number" name="discountAmt" id="discountAmt" class="form-control border-danger-subtle" step="1" min="0" value="<c:out value='${empty salesProduct.discountAmt ? 0 : salesProduct.discountAmt}' default='0'/>" />
                                <span class="input-group-text border-danger-subtle text-danger">원</span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold small">판매 상태</label>
                            <select name="saleStatusCd" id="saleStatusCd" class="form-select">
                                <c:choose>
                                    <c:when test="${not empty saleStatuses}">
                                        <c:forEach var="code" items="${saleStatuses}">
                                            <option value="${code.detailCode}" <c:if test="${empty salesProduct.saleStatusCd ? code.detailCode eq 'LIVE' : salesProduct.saleStatusCd eq code.detailCode}">selected</c:if>>${code.detailCodeName}</option>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="LIVE" <c:if test="${empty salesProduct.saleStatusCd or salesProduct.saleStatusCd eq 'LIVE'}">selected</c:if>>판매중</option>
                                        <option value="WAIT" <c:if test="${salesProduct.saleStatusCd eq 'WAIT'}">selected</c:if>>판매대기</option>
                                        <option value="STOP" <c:if test="${salesProduct.saleStatusCd eq 'STOP'}">selected</c:if>>판매중지</option>
                                    </c:otherwise>
                                </c:choose>
                            </select>
                        </div>
                        <div class="col-md-8">
                            <label class="form-label fw-bold small">판매 기간</label>
                            <div class="d-flex align-items-center gap-2">
                                <input type="date" name="saleStartDt" id="saleStartDt" class="form-control" value="<fmt:formatDate value='${salesProduct.saleStartDt}' pattern='yyyy-MM-dd'/>" />
                                <span class="text-muted">~</span>
                                <input type="date" name="saleEndDt" id="saleEndDt" class="form-control" value="<fmt:formatDate value='${salesProduct.saleEndDt}' pattern='yyyy-MM-dd'/>" />
                            </div>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label fw-bold small">MD 코멘트</label>
                            <textarea name="mdComment" rows="2" class="form-control"><c:out value='${salesProduct.mdComment}'/></textarea>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="premium-card h-100">
                    <div class="section-title">세금 정산 요약</div>
                    <div class="tax-summary-card mt-2">
                        <div class="tax-summary-item">
                            <span class="text-muted">세전 가격 (공급가액)</span>
                            <span id="summarySupplyAmt">0 원</span>
                        </div>
                        <div class="tax-summary-item">
                            <span class="text-muted">부가가치세 (VAT 10%)</span>
                            <span id="summaryVatAmt" class="text-warning fw-bold">0 원</span>
                        </div>
                        <div class="tax-summary-item">
                            <span class="text-muted">면세 금액 합계</span>
                            <span id="summaryFreeAmt" class="text-primary">0 원</span>
                        </div>
                        <div class="tax-summary-total">
                            <span>최종 판매가</span>
                            <span id="summaryTotalAmt">0 원</span>
                        </div>
                    </div>
                    <div class="alert alert-info py-2 mt-3 mb-0" style="font-size: 0.8rem;">
                        <i class="bi bi-info-circle-fill me-2"></i>
                        가공품 구성상품에 대해서만 10%의 부가세가 계산되어 합산됩니다.
                    </div>
                </div>
            </div>
        </div>

                                <!-- 2. 상품 구성 목록 -->
        <div class="premium-card mt-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="section-title mb-0">상품 구성 소싱</div>
                <button type="button" class="btn btn-primary btn-premium btn-sm" onclick="fn_addComponentPopup()">
                    <i class="bi bi-plus-lg me-1"></i>구성상품 추가
                </button>
            </div>
            <div class="table-responsive">
                <table class="premium-table">
                    <thead>
                        <tr>
                            <th>판매자</th>
                            <th>구성상품명</th>
                            <th>상태</th>
                            <th class="text-end">판매가</th>
                            <th class="text-end">VAT</th>
                            <th>구분</th>
                            <th class="text-center">노출</th>
                            <th class="text-center">관리</th>
                        </tr>
                    </thead>
                    <tbody id="componentTableBody">
                        <tr id="emptyRow">
                            <td colspan="8" class="text-muted py-5 text-center">
                                <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                구성 상품을 추가해주세요.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>


                        <!-- 3. 이미지 및 상세 설명 -->
        <div class="row g-4 mt-1">
            <div class="col-md-4">
                <div class="premium-card h-100">
                    <div class="section-title">&#xb300;&#xd45c; &#xc774;&#xbc00;&#xc9c0;</div> <!-- 대표 이미지 -->
                    <c:catch var="ex">
                        <c:choose>
                            <%-- Properties not found on stale class workaround --%>
                            <c:when test="${not empty salesProduct and salesProduct.getClass().getSimpleName() == 'SalesProductVO' and not empty salesProduct.imgUrl1}">
                                <img src="${salesProduct.imgUrl1}" id="previewImg1" alt="Preview" />
                                <div class="image-change-btn btn btn-dark btn-sm rounded-circle p-1 opacity-75">
                                    <i class="bi bi-pencil-fill px-1"></i>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center">
                                    <i class="bi bi-image text-muted fs-1 mb-2"></i>
                                    <p class="mb-0 text-muted small px-3">클릭하여 이미지 업로드<br>(권장: 800x800)</p>
                                </div>
                                <img id="previewImg1" style="display:none;" />
                            </c:otherwise>
                        </c:choose>
                    </c:catch>
                        <input type="file" name="files" id="imgFile1" class="d-none" onchange="previewImage(this, 'previewImg1')" accept="image/*" />
                    </div>
                    <div class="mt-3">
                        <label class="form-label fw-bold small">&#xcd94;&#xac00; &#xc774;&#xbc00;&#xc9c0; (&#xc120;&#xd0dd;)</label> <!-- 추가 이미지 (선택) -->
                        <div class="row g-2">
                            <div class="col-6">
                                <div class="image-upload-box" style="height: 100px;" onclick="document.getElementById('imgFile2').click();">
                                    <c:catch var="ex2">
                                        <c:choose>
                                            <c:when test="${salesProduct != null and not empty salesProduct.imgUrl2}">
                                                <img src="${salesProduct.imgUrl2}" id="previewImg2" />
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-plus text-muted fs-3"></i>
                                                <img id="previewImg2" style="display:none;" />
                                            </c:otherwise>
                                        </c:choose>
                                    </c:catch>
                                    <input type="file" name="files" id="imgFile2" class="d-none" onchange="previewImage(this, 'previewImg2')" accept="image/*" />
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="image-upload-box" style="height: 100px;" onclick="document.getElementById('imgFile3').click();">
                                    <c:catch var="ex3">
                                        <c:choose>
                                            <c:when test="${salesProduct != null and not empty salesProduct.imgUrl3}">
                                                <img src="${salesProduct.imgUrl3}" id="previewImg3" />
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-plus text-muted fs-3"></i>
                                                <img id="previewImg3" style="display:none;" />
                                            </c:otherwise>
                                        </c:choose>
                                    </c:catch>
                                    <input type="file" name="files" id="imgFile3" class="d-none" onchange="previewImage(this, 'previewImg3')" accept="image/*" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-8">
                <div class="premium-card h-100">
                    <div class="section-title">상세 설명</div>
                    <div class="bg-light p-2 rounded border">
                        <!-- SmartEditor / Textarea -->
                        <textarea name="detailHtml" id="mdContent" style="width:100%; height:320px;" class="form-control"><c:out value="${salesProduct.detailHtml}" /></textarea>
                    </div>
                </div>
            </div>
        </div>

        <!-- 4. 하단 버튼 영역 -->
        <div class="d-flex justify-content-center gap-3 mt-5 mb-5 pb-5 animate-fade-in" style="animation-delay: 0.3s;">
            <c:if test="${not empty salesProduct.salesProdId}">
                <button type="button" class="btn btn-outline-danger btn-premium btn-lg px-5 border-2" onclick="fn_delete()">
                    <i class="bi bi-trash3 me-2"></i>삭제하기
                </button>
            </c:if>
            <button type="button" class="btn btn-primary btn-premium btn-lg px-5 shadow-sm" onclick="fn_save()">
                <i class="bi bi-check2-circle me-2"></i>저장하기
            </button>
        </div>

                        <!-- 5. 안내 정보 -->
                        <div class="section-header">안내 정보</div>
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <div class="card h-100">
                                    <div class="card-header bg-light fw-bold">상품 결제 정보</div>
                                    <div class="card-body">
                                        <textarea class="form-control" name="paymentInfo" rows="5"
                                            placeholder="결제 수단, 결제 시 유의사항 등을 입력하세요."><c:out value='${salesProduct.paymentInfo}'/></textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card h-100">
                                    <div class="card-header bg-light fw-bold">배송 정보</div>
                                    <div class="card-body">
                                        <textarea class="form-control" name="deliveryInfo" rows="5"
                                            placeholder="배송 방법, 소요 기간, 배송비 등을 입력하세요."><c:out value='${salesProduct.deliveryInfo}'/></textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card h-100">
                                    <div class="card-header bg-light fw-bold">교환 및 반품 정보</div>
                                    <div class="card-body">
                                        <textarea class="form-control" name="returnInfo" rows="5"
                                            placeholder="교환/반품 조건, 절차, 비용 등을 입력하세요."><c:out value='${salesProduct.returnInfo}'/></textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card h-100">
                                    <div class="card-header bg-light fw-bold">환불 정보</div>
                                    <div class="card-body">
                                        <textarea class="form-control" name="refundInfo" rows="5"
                                            placeholder="환불 소요 기간, 유의사항 등을 입력하세요."><c:out value='${salesProduct.refundInfo}'/></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </form>
                </div>

                <!-- 이미지 확대 뷰어 -->
                <div class="modal fade" id="imagePreviewModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-body p-0">
                                <img id="imagePreviewModalImg" src="" alt="이미지 미리보기" class="img-fluid w-100" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SmartEditor2 필수 스크립트 -->
                <script type="text/javascript" charset="utf-8"
                    src="<c:url value='/smarteditor2/js/service/HuskyEZCreator.js' />"></script>

                <script type="text/javascript">
                    var oEditors = [];

                    // ★ 전역 변수
                    let componentProductList = [];
                    const previewImages = {};
                    const objectUrlMap = {};
                    let imageModalInstance = null;

                    // 페이지 로딩 시 초기화
                    document.addEventListener('DOMContentLoaded', function () {
                        console.log('DOMContentLoaded - 페이지 초기화 시작');

                        initSmartEditor();
                        initImagePreview();
                        // initSalePeriodRecalc(); // 필요시 구현
                        // initDisplayToggle();    // 필요시 구현
                        initUnloadCleanup();

                        syncManualPrice();
                        defaultSalePeriodIfEmpty();

                        // 구성상품 로딩 (수정 모드일 때만)
                        loadExistingCompositions();

                        // 이미지 미리보기 초기화 (썸네일이 있으면)
                        setTimeout(function () {
                            initProductImagePopup();
                        }, 500);

                        const salePriceInput = document.getElementById('listPrice');
                        if (salePriceInput) {
                            salePriceInput.addEventListener('input', syncManualPrice);
                        }

                        const discountInput = document.getElementById('discountAmt');
                        if (discountInput) {
                            discountInput.addEventListener('input', updateProductInfo);
                        }

                        const sellerSelect = document.getElementById('sellerMemberId');
                        const sellerNameSelect = document.getElementById('sellerName');
                        if (sellerSelect) {
                            sellerSelect.addEventListener('change', syncSellerName);
                        }
                        if (sellerNameSelect) {
                            sellerNameSelect.addEventListener('change', syncSellerFromName);
                        }

                        syncSellerName();

                        updateProductInfo();

                        console.log('페이지 초기화 완료');
                    });

                    function initSmartEditor() {
                        if (!(window.nhn && window.nhn.husky && window.nhn.husky.EZCreator)) {
                            setTimeout(initSmartEditor, 300);
                            return;
                        }
                        nhn.husky.EZCreator.createInIFrame({
                            oAppRef: oEditors,
                            elPlaceHolder: "mdContent",
                            sSkinURI: "<c:url value='/smarteditor2/SmartEditor2Skin.html' />",
                            fCreator: "createSEditor2"
                        });
                    }

                    function syncEditorContent() {
                        if (oEditors && oEditors.getById && oEditors.getById["mdContent"]) {
                            oEditors.getById["mdContent"].exec("UPDATE_CONTENTS_FIELD", []);
                        }
                    }

                    function formatDateValue(value) {
                        if (!value) return '';
                        if (value instanceof Date) {
                            return value.toISOString().split('T')[0];
                        }
                        const text = value.toString();
                        if (text.indexOf('T') > -1) {
                            return text.split('T')[0];
                        }
                        return text.substring(0, 10);
                    }

                    function fn_addComponentPopup() {
                        const url = '<c:url value="/admin/product/popup/componentList.do"/>';
                        const name = 'componentPopup';
                        const option = 'width=1440,height=800,scrollbars=yes';
                        window.open(url, name, option);
                    }

                    // 노출 여부 토글 함수 (HTML에서 호출됨)
                    // ===== 구성상품 / 판매기간 계산 =====
                    function calculateSalePeriod(components) {
                        if (!components || components.length === 0) {
                            return { start: '', end: '' };
                        }
                        const starts = components.map(c => c.saleStartDt).filter(Boolean).sort();
                        const ends = components.map(c => c.saleEndDt).filter(Boolean).sort();

                        if (starts.length === 0 || ends.length === 0) {
                            return { start: '', end: '' };
                        }
                        const latestStart = starts[starts.length - 1];
                        const earliestEnd = ends[0];

                        if (latestStart > earliestEnd) {
                            return { start: '', end: '' };
                        }
                        return { start: latestStart, end: earliestEnd };
                    }

                                        function renderComponentTable() {
                        const tbody = document.getElementById('componentTableBody');
                        if (!tbody) return;

                        tbody.innerHTML = '';

                        if (componentProductList.length === 0) {
                            tbody.innerHTML = '<tr id="emptyRow"><td colspan="8" class="text-muted py-5 text-center"><i class="bi bi-inbox fs-2 d-block mb-2"></i>구성 상품을 추가해주세요.</td></tr>';
                            updateProductInfo();
                            return;
                        }

                        componentProductList.forEach((item, index) => {
                            const salePrice = Number(item.listPrice) || 0;
                            const vatAmount = Number(item.vatAmount) || 0;
                            const isTaxable = item.taxType === 'TAXABLE';
                            const taxBadge = isTaxable ? '<span class="badge bg-danger-subtle text-danger px-2 border border-danger-subtle" style="font-size:0.7rem">과세</span>' 
                                                       : '<span class="badge bg-primary-subtle text-primary px-2 border border-primary-subtle" style="font-size:0.7rem">면세</span>';

                            const tr = document.createElement('tr');
                            tr.innerHTML = `
                                <td><span class="text-muted small">\${item.sellerName || '-'}</span></td>
                                <td>
                                    <div class="fw-bold">\${item.componentProdName}</div>
                                    <div class="mt-1">\${taxBadge} <span class="text-muted" style="font-size:0.75rem">\${item.saleStatusName || ''}</span></div>
                                </td>
                                <td class="text-center"><span class="badge bg-light text-dark border">\${item.divisionTypeName || '-'}</span></td>
                                <td class="text-end fw-bold">\${salePrice.toLocaleString()} 원</td>
                                <td class="text-end text-warning">\${Math.round(isTaxable ? salePrice * 0.1 : 0).toLocaleString()} 원</td>
                                <td class="text-center"><span class="text-muted small">\${item.saleTypeName || ''}</span></td>
                                <td class="text-center">\${item.exposureStatusCd == 'N' ? '<i class="bi bi-eye-slash text-danger"></i>' : '<i class="bi bi-eye-fill text-success"></i>'}</td>
                                <td class="text-center">
                                    <button type="button" class="btn btn-outline-danger btn-sm p-1 px-2" onclick="removeComponentRow(\${index})"><i class="bi bi-trash"></i></button>
                                </td>
                            `;
                            tbody.appendChild(tr);
                        });

                        updateProductInfo();
                    }

                    function removeComponentRow(index) {
                        componentProductList.splice(index, 1);
                        renderComponentTable();
                    }

                    function addComponentRow(data) {
                        if (!data || !data.componentProdId) return;

                        const exists = componentProductList.some(item => item.componentProdId === Number(data.componentProdId));
                        if (!exists) {
                            componentProductList.push({
                                componentProdId: Number(data.componentProdId),
                                componentProdName: data.componentProdName || '',
                                saleType: data.saleType || '',
                                saleTypeName: data.saleTypeName || '',
                                saleStatusName: data.saleStatusName || '',
                                storageTypeName: data.storageTypeName || '',
                                processTypeName: data.processTypeName || '',
                                divisionTypeName: data.divisionTypeName || '',
                                taxType: data.taxType || 'TAXABLE',
                                listPrice: data.listPrice || 0,
                                costPrice: data.costPrice || 0,
                                vatAmount: data.vatAmount || 0,
                                exposureStatusCd: data.exposureStatusCd || 'Y',
                                sellerMemberId: data.sellerMemberId || null,
                                sellerName: data.sellerName || '',
                                saleStartDt: formatDateValue(data.saleStartDt),
                                saleEndDt: formatDateValue(data.saleEndDt),
                                regDt: formatDateValue(data.regDt),
                                modDt: formatDateValue(data.modDt)
                            });
                        }

                        renderComponentTable();
                    }

                    function sanitizeInteger(value) {
                        const num = Math.max(0, Math.floor(Number(value) || 0));
                        return Number.isFinite(num) ? num : 0;
                    }

                    function defaultSalePeriodIfEmpty() {
                        const saleStartInput = document.getElementById('saleStartDt');
                        const saleEndInput = document.getElementById('saleEndDt');
                        const today = new Date();
                        const format = (d) => d.toISOString().slice(0, 10);

                        if (saleStartInput && !saleStartInput.value) {
                            saleStartInput.value = format(today);
                        }

                        if (saleEndInput && !saleEndInput.value) {
                            const nextYear = new Date(today);
                            nextYear.setFullYear(today.getFullYear() + 1);
                            saleEndInput.value = format(nextYear);
                        }
                    }

                    function syncSellerName() {
                        const sellerSelect = document.getElementById('sellerMemberId');
                        const sellerNameSelect = document.getElementById('sellerName');
                        if (!sellerSelect || !sellerNameSelect) return;

                        const selectedOption = sellerSelect.selectedOptions && sellerSelect.selectedOptions[0];
                        const name = selectedOption && selectedOption.dataset ? selectedOption.dataset.sellerName || '' : '';
                        const legacyId = selectedOption && selectedOption.dataset ? selectedOption.dataset.legacyId || '' : '';
                        const memberId = selectedOption ? selectedOption.value : '';

                        let matched = false;
                        Array.from(sellerNameSelect.options).forEach(opt => {
                            const optMember = opt.dataset ? opt.dataset.memberId || '' : '';
                            const optLegacy = opt.dataset ? opt.dataset.legacyId || '' : '';
                            if (name && opt.value === name) {
                                opt.selected = true;
                                matched = true;
                            } else if (!matched && (optMember === memberId || (legacyId && optLegacy === legacyId))) {
                                opt.selected = true;
                                matched = true;
                            }
                        });

                        if (!matched) {
                            sellerNameSelect.value = '';
                        }
                    }

                    function syncSellerFromName() {
                        const sellerSelect = document.getElementById('sellerMemberId');
                        const sellerNameSelect = document.getElementById('sellerName');
                        if (!sellerSelect || !sellerNameSelect) return;

                        const selectedOption = sellerNameSelect.selectedOptions && sellerNameSelect.selectedOptions[0];
                        if (!selectedOption) return;

                        const memberId = selectedOption.dataset ? selectedOption.dataset.memberId || '' : '';
                        const legacyId = selectedOption.dataset ? selectedOption.dataset.legacyId || '' : '';

                        Array.from(sellerSelect.options).forEach(opt => {
                            const optLegacy = opt.dataset ? opt.dataset.legacyId || '' : '';
                            if (opt.value === memberId || (legacyId && optLegacy === legacyId)) {
                                opt.selected = true;
                            }
                        });
                    }

                    function syncManualPrice() {
                        const salePriceInput = document.getElementById('listPrice');
                        const costPriceInput = document.getElementById('costPrice');
                        const vatAmountInput = document.getElementById('vatAmount');

                        const salePrice = sanitizeInteger(salePriceInput.value);
                        salePriceInput.value = salePrice;

                        // 원가가 비어있으면 판매가와 동일하게 세팅 (수동 입력 시)
                        if (!costPriceInput.value || costPriceInput.value == '0') {
                            costPriceInput.value = salePrice;
                        }

                        // 구성상품이 없을 때만 10% 자동계산 (사용자 편의)
                        if (componentProductList.length === 0) {
                            if (!vatAmountInput.value || vatAmountInput.value == '0') {
                                vatAmountInput.value = Math.round(salePrice * 0.1);
                            }
                        }
                    }

                                        function updateProductInfo() {
                        const salePriceInput = document.getElementById('listPrice');
                        const costPriceInput = document.getElementById('costPrice');
                        const vatAmountInput = document.getElementById('vatAmount');
                        const saleStartDateInput = document.getElementById('saleStartDt');
                        const saleEndDateInput = document.getElementById('saleEndDt');
                        const sellerSelect = document.getElementById('sellerMemberId');
                        const exposureStatusSelect = document.getElementById('exposureStatusCd');

                        const discountInput = document.getElementById('discountAmt');

                        if (componentProductList.length > 0) {
                            let totalSale = 0, totalCost = 0, totalVat = 0, totalFree = 0, totalSupply = 0;
                            let rawSellerId = null;
                            let defaultSellerId = null;
                            let forceHidden = false;

                            componentProductList.forEach(item => {
                                const salePrice = Number(item.listPrice) || 0;
                                const vatAmt = Number(item.vatAmount) || 0;
                                const isTaxable = item.taxType === 'TAXABLE';
                                
                                totalSale += salePrice;
                                totalVat += vatAmt;
                                totalCost += Number(item.costPrice) || 0;
                                totalSupply += (salePrice - vatAmt);
                                
                                if(!isTaxable) totalFree += salePrice;

                                const saleTypeName = item.saleTypeName || '';
                                const isRawMaterial = saleTypeName.indexOf('원물') > -1;

                                if (!defaultSellerId && item.sellerMemberId) defaultSellerId = item.sellerMemberId;
                                if (!rawSellerId && isRawMaterial && item.sellerMemberId) rawSellerId = item.sellerMemberId;

                                if (item.exposureStatusCd === 'N') forceHidden = true;
                            });

                            // 할인 적용
                            const discount = sanitizeInteger(discountInput ? discountInput.value : 0);
                            const finalPrice = Math.max(0, totalSale - discount);

                            salePriceInput.value = finalPrice;
                            costPriceInput.value = totalCost;
                            vatAmountInput.value = totalVat;

                            // Update visual summary
                            if(sumSupply) sumSupply.innerText = totalSupply.toLocaleString() + ' 원';
                            if(sumVat) sumVat.innerText = totalVat.toLocaleString() + ' 원';
                            if(sumFree) sumFree.innerText = totalFree.toLocaleString() + ' 원';
                            if(sumTotal) sumTotal.innerText = finalPrice.toLocaleString() + ' 원';

                            if (rawSellerId) sellerSelect.value = rawSellerId;
                            else if (defaultSellerId) sellerSelect.value = defaultSellerId;

                            const { start, end } = calculateSalePeriod(componentProductList);
                            if(start) saleStartDateInput.value = start;
                            if(end) saleEndDateInput.value = end;

                            if (forceHidden && exposureStatusSelect && exposureStatusSelect.value !== 'N') {
                                exposureStatusSelect.value = 'N';
                            }
                        } else {
                            if(sumSupply) sumSupply.innerText = '0 원';
                            if(sumVat) sumVat.innerText = '0 원';
                            if(sumFree) sumFree.innerText = '0 원';
                            if(sumTotal) sumTotal.innerText = '0 원';
                            syncManualPrice();
                        }

                        syncSellerName();
                    }

                    function fn_preview() {
                        if (window.oEditors && oEditors.length > 0) {
                            oEditors.getById["mdContent"].exec("UPDATE_CONTENTS_FIELD", []);
                        }

                        const width = 1200;
                        const height = 800;
                        const left = (window.screen.width / 2) - (width / 2);
                        const top = (window.screen.height / 2) - (height / 2);
                        window.open('about:blank', 'productPreviewPopup', `width=${width},height=${height},top=${top},left=${left},scrollbars=yes,resizable=yes`);

                        const form = document.querySelector('form[name="productForm"]');
                        const originalAction = form.action;
                        const originalTarget = form.target;

                        form.action = '<c:url value="/admin/product/preview.do"/>';
                        form.target = 'productPreviewPopup';
                        form.submit();

                        setTimeout(() => {
                            form.action = originalAction;
                            form.target = originalTarget || '_self';
                        }, 100);
                    }

                    // ===== 이미지 업로드 & 팝업 =====
                    function fn_previewImage(input, boxId) {
                        const box = document.getElementById(boxId);
                        if (!input.files || input.files.length === 0 || !box) return;

                        const file = input.files[0];
                        const prevUrl = objectUrlMap[boxId];
                        if (prevUrl) URL.revokeObjectURL(prevUrl);

                        const src = URL.createObjectURL(file);
                        objectUrlMap[boxId] = src;
                        previewImages[boxId] = src;

                        box.innerHTML =
                            '<img src="' + src + '" alt="업로드 이미지" class="product-image-thumb" data-full-url="' + src + '" />' +
                            '<button type="button" class="btn btn-light btn-sm image-change-btn" onclick="event.stopPropagation(); document.getElementById(\'' + input.id + '\').click();">변경</button>';

                        initProductImagePopup();
                    }

                    function getImageModalInstance() {
                        if (window.bootstrap && window.bootstrap.Modal) {
                            if (!imageModalInstance) {
                                const el = document.getElementById('imagePreviewModal');
                                if (el) imageModalInstance = new bootstrap.Modal(el);
                            }
                            return imageModalInstance;
                        }
                        return null;
                    }

                    function openImageModal(src) {
                        if (!src) return;
                        const el = document.getElementById('imagePreviewModal');
                        const img = document.getElementById('imagePreviewModalImg');
                        if (!el || !img) return;

                        img.onerror = function () {
                            img.src = 'data:image/svg+xml;charset=utf-8,' + encodeURIComponent('<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg"><rect width="400" height="400" fill="#f0f0f0"/><text x="50%" y="50%" font-size="20" text-anchor="middle" dy=".3em" fill="#999">이미지를 불러올 수 없습니다</text></svg>');
                        };
                        img.src = src;

                        const modal = getImageModalInstance();
                        if (modal) {
                            modal.show();
                            return;
                        }
                        // Fallback for no bootstrap js
                        el.classList.add('show');
                        el.style.display = 'block';
                        el.removeAttribute('aria-hidden');
                        document.body.classList.add('modal-open');

                        function handleClick(e) {
                            if (e.target === el) {
                                el.classList.remove('show');
                                el.style.display = 'none';
                                el.setAttribute('aria-hidden', 'true');
                                document.body.classList.remove('modal-open');
                                el.removeEventListener('click', handleClick);
                            }
                        }
                        el.addEventListener('click', handleClick);
                    }

                    function initProductImagePopup() {
                        const thumbs = document.querySelectorAll('.product-image-thumb');
                        if (!thumbs.length) return;

                        thumbs.forEach((thumb, index) => {
                            if (thumb.dataset.popupBound === 'true') return;
                            thumb.dataset.popupBound = 'true';
                            thumb.addEventListener('click', function (e) {
                                e.preventDefault();
                                e.stopPropagation();
                                const fullUrl = thumb.getAttribute('data-full-url') || thumb.getAttribute('src');
                                if (fullUrl) openImageModal(fullUrl);
                            });
                        });
                    }

                    function initImagePreview() {
                        document.querySelectorAll('.image-upload-box').forEach((box) => {
                            const inputId = box.getAttribute('data-input-id');
                            const innerImg = box.querySelector('.product-image-thumb, img');
                            if (innerImg) {
                                const fullUrl = innerImg.getAttribute('data-full-url') || innerImg.getAttribute('src');
                                if (fullUrl) previewImages[box.id] = fullUrl;
                            }
                            box.addEventListener('click', function () {
                                if (previewImages[box.id]) {
                                    openImageModal(previewImages[box.id]);
                                } else if (inputId) {
                                    const inputEl = document.getElementById(inputId);
                                    if (inputEl) inputEl.click();
                                }
                            });
                        });
                        initProductImagePopup();
                    }

                    function initUnloadCleanup() {
                        window.addEventListener('beforeunload', function () {
                            Object.values(objectUrlMap).forEach((url) => URL.revokeObjectURL(url));
                        });
                    }

                    // ===== 기존 구성상품 로딩 =====
                    function loadExistingCompositions() {
                        console.log('loadExistingCompositions called');
                        try {
                            const dataElement = document.getElementById('compositionData');
                            if (!dataElement) return;

                            const jsonText = (dataElement.textContent || dataElement.innerText || '').trim();
                            const compositions = jsonText ? JSON.parse(jsonText) : [];

                            if (compositions && compositions.length > 0) {
                                compositions.forEach(function (comp) {
                                    if (comp.componentProdId > 0) {
                                        componentProductList.push({
                                            componentProdId: comp.componentProdId,
                                            componentProdName: comp.componentProdName || '',
                                            saleType: comp.saleType || '',
                                            saleTypeName: comp.saleTypeName || '',
                                            saleStatusName: comp.saleStatusName || '',
                                            storageTypeName: comp.storageTypeName || '',
                                            processTypeName: comp.processTypeName || '',
                                            divisionTypeName: comp.divisionTypeName || '',
                                            taxType: comp.taxType || 'TAXABLE',
                                            listPrice: comp.listPrice || 0,
                                            costPrice: comp.costPrice || 0,
                                            vatAmount: comp.vatAmount || 0,
                                            exposureStatusCd: comp.exposureStatusCd || 'Y',
                                            sellerMemberId: comp.sellerMemberId || null,
                                            sellerName: comp.sellerName || '',
                                            saleStartDt: formatDateValue(comp.saleStartDt),
                                            saleEndDt: formatDateValue(comp.saleEndDt),
                                            regDt: formatDateValue(comp.regDt),
                                            modDt: formatDateValue(comp.modDt)
                                        });
                                    }
                                });
                                renderComponentTable(); // 로딩 후 테이블 그리기
                            }
                        } catch (e) {
                            console.error('Error loading compositions:', e);
                        }
                    } // <--- 기존에 누락되었던 닫는 괄호 추가됨

                    // ===== 저장 버튼 처리 (하단 중복 코드 통합 및 정리) =====
                    function fn_save() {
                        const productName = document.querySelector('input[name="salesProdName"]');
                        if (!productName || !productName.value.trim()) {
                            alert('상품명을 입력해주세요.');
                            if (productName) productName.focus();
                            return false;
                        }

                        syncEditorContent();

                        // 숫자 필드 빈 값 처리
                        ['listPrice', 'costPrice', 'vatAmount'].forEach(fieldId => {
                            const field = document.getElementById(fieldId);
                            if (field && !field.value.trim()) field.value = '0';
                        });

                        // 날짜 필드 빈 값 처리
                        ['saleStartDt', 'saleEndDt'].forEach(fieldId => {
                            const field = document.getElementById(fieldId);
                            if (field && !field.value.trim()) field.removeAttribute('name');
                        });

                        // 구성상품 목록을 hidden input으로 생성
                        const form = document.querySelector('form[name="productForm"]');
                        if (!form) return;

                        // 기존 hidden input 삭제 (재생성 위함)
                        const oldInputs = form.querySelectorAll('input[name^="compositionList"]');
                        oldInputs.forEach(input => input.remove());

                        // componentProductList를 기반으로 hidden input 생성
                        componentProductList.forEach((item, index) => {
                            const input = document.createElement('input');
                            input.type = 'hidden';
                            input.name = 'compositionList[' + index + '].componentProdId';
                            input.value = item.componentProdId;
                            form.appendChild(input);
                        });

                        window.onbeforeunload = null;
                        form.submit();
                    }
                </script>