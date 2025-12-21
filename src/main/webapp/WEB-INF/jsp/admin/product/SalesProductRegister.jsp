<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!-- 판매상품 등록/수정 -->
                <style>
                    .section-header {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        font-weight: 700;
                        margin: 16px 0 8px;
                    }

                    .section-header::before {
                        content: "";
                        display: inline-block;
                        width: 4px;
                        height: 16px;
                        background: #2c3e50;
                    }

                    .form-table th,
                    .form-table td {
                        padding: 0.5rem 0.75rem !important;
                        vertical-align: middle;
                    }

                    .date-range {
                        flex-wrap: wrap;
                        gap: 6px;
                    }

                    .preview-wrapper {
                        border: 1px dashed #cbd5e1;
                        border-radius: 8px;
                        height: 120px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        cursor: pointer;
                        overflow: hidden;
                        position: relative;
                    }

                    .preview-wrapper.has-image {
                        border-style: solid;
                    }

                    .preview-wrapper img {
                        max-width: 100%;
                        max-height: 100%;
                    }

                    .btn-upload {
                        position: absolute;
                        inset: 0;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                    }

                    /* 중간에 끼여있던 CSS를 이곳으로 이동 */
                    .image-upload-box {
                        width: 100%;
                        height: 150px;
                        border: 1px solid #dee2e6;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        cursor: pointer;
                        background-color: #fff;
                        position: relative;
                        overflow: hidden;
                    }

                    .image-upload-box:hover {
                        background-color: #f8f9fa;
                    }

                    .image-upload-box img {
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                    }

                    .image-change-btn {
                        position: absolute;
                        top: 6px;
                        right: 6px;
                    }

                    /* SmartEditor 영역을 폼 입력과 동일한 타이포로 맞춤 */
                    #mdContent,
                    .se2_inputarea,
                    .se2_inputarea textarea,
                    .se2_textarea iframe {
                        font-family: inherit !important;
                        font-size: 0.875rem !important;
                        color: #212529;
                    }
                </style>

                <div class="container-fluid p-4">
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><i class="bi bi-house-door-fill"></i></li>
                            <li class="breadcrumb-item">판매상품관리</li>
                            <li class="breadcrumb-item active" aria-current="page">판매상품 등록</li>
                        </ol>
                    </nav>

                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h4>
                            <c:choose>
                                <c:when test="${salesProduct.salesProdId != null}">판매상품 상세</c:when>
                                <c:otherwise>판매상품 등록</c:otherwise>
                            </c:choose>
                        </h4>
                        <div>
                            <button type="button" class="btn btn-secondary" onclick="location.href='<c:url value="
                                /admin/product/salesProductList.do" />';">목록</button>
                        </div>
                    </div>

                    <form name="productForm" method="post"
                        action="${pageContext.request.contextPath}/admin/product/salesProductRegister.do"
                        enctype="multipart/form-data">
                        <input type="hidden" name="salesProdId" value="<c:out value='${salesProduct.salesProdId}'/>" />
                        <input type="hidden" name="salesProdCode"
                            value="<c:out value='${salesProduct.salesProdCode}'/>" />

                        <c:if test="${not empty compositionJson}">
                            <script type="application/json"
                                id="compositionData"><c:out value='${compositionJson}' escapeXml="false"/></script>
                        </c:if>

                        <fmt:formatNumber var="listPriceFormatted"
                            value="${empty salesProduct.listPrice ? 0 : salesProduct.listPrice}" type="number"
                            maxFractionDigits="0" groupingUsed="false" />
                        <fmt:formatNumber var="costPriceFormatted"
                            value="${empty salesProduct.costPrice ? (empty salesProduct.listPrice ? 0 : salesProduct.listPrice) : salesProduct.costPrice}"
                            type="number" maxFractionDigits="0" groupingUsed="false" />
                        <fmt:formatNumber var="viewCountFormatted"
                            value="${empty salesProduct.viewCnt ? 0 : salesProduct.viewCnt}" type="number"
                            maxFractionDigits="0" groupingUsed="false" />

                        <!-- 1. 상품일반정보 -->
                        <div class="section-header">상품일반정보</div>
                        <table class="table table-bordered form-table">
                            <colgroup>
                                <col style="width: 12%;">
                                <col style="width: 38%;">
                                <col style="width: 12%;">
                                <col style="width: 38%;">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>상품명</th>
                                    <td><input type="text" name="salesProdName" class="form-control form-control-sm"
                                            value="<c:out value='${salesProduct.salesProdName}'/>" required /></td>
                                    <th>상품 요약</th>
                                    <td><input type="text" name="summary" class="form-control form-control-sm"
                                            value="<c:out value='${salesProduct.summary}'/>" /></td>
                                </tr>
                                <tr>
                                    <th>판매 가격</th>
                                    <td>
                                        <div class="input-group input-group-sm" style="max-width: 220px;">
                                            <input type="number" name="listPrice" id="listPrice"
                                                class="form-control form-control-sm" step="1" min="0"
                                                value="<c:out value='${listPriceFormatted}' default='0'/>" />
                                            <span class="input-group-text">원</span>
                                        </div>
                                    </td>
                                    <th>VAT</th>
                                    <td>
                                        <div class="input-group input-group-sm" style="max-width: 220px;">
                                            <input type="number" name="vatAmount" id="vatAmount"
                                                class="form-control form-control-sm"
                                                value="<c:out value='${empty salesProduct.vatAmount ? 0 : salesProduct.vatAmount}' default='0'/>" />
                                            <span class="input-group-text">원</span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>원가</th>
                                    <td>
                                        <div class="input-group input-group-sm" style="max-width: 220px;">
                                            <input type="number" name="costPrice" id="costPrice"
                                                class="form-control form-control-sm" step="1" min="0"
                                                value="<c:out value='${costPriceFormatted}' default='0'/>" />
                                            <span class="input-group-text">원</span>
                                        </div>
                                    </td>
                                    <th>판매상태</th>
                                    <td>
                                        <select name="saleStatusCd" id="saleStatusCd" class="form-select form-select-sm"
                                            style="max-width: 220px;">
                                            <c:choose>
                                                <c:when test="${not empty saleStatuses}">
                                                    <c:forEach var="code" items="${saleStatuses}">
                                                        <option value="${code.detailCode}" <c:if
                                                            test="${empty salesProduct.saleStatusCd ? code.detailCode eq 'LIVE' : salesProduct.saleStatusCd eq code.detailCode}">
                                                            selected</c:if>>
                                                            ${code.detailCodeName}
                                                        </option>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="LIVE" <c:if
                                                        test="${empty salesProduct.saleStatusCd or salesProduct.saleStatusCd eq 'LIVE'}">
                                                        selected</c:if>>판매중</option>
                                                    <option value="WAIT" <c:if
                                                        test="${salesProduct.saleStatusCd eq 'WAIT'}">selected</c:if>
                                                        >판매대기</option>
                                                    <option value="STOP" <c:if
                                                        test="${salesProduct.saleStatusCd eq 'STOP'}">selected</c:if>
                                                        >판매중지</option>
                                                </c:otherwise>
                                            </c:choose>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th>판매기간</th>
                                    <td>
                                        <div class="d-flex align-items-center gap-2 flex-wrap">
                                            <input type="date" name="saleStartDt" id="saleStartDt"
                                                class="form-control form-control-sm" style="max-width: 180px;"
                                                value="<fmt:formatDate value='${salesProduct.saleStartDt}' pattern='yyyy-MM-dd'/>" />
                                            <span class="text-muted">~</span>
                                            <input type="date" name="saleEndDt" id="saleEndDt"
                                                class="form-control form-control-sm" style="max-width: 180px;"
                                                value="<fmt:formatDate value='${salesProduct.saleEndDt}' pattern='yyyy-MM-dd'/>" />
                                        </div>
                                    </td>
                                    <th>조회수</th>
                                    <td>
                                        <input type="text" class="form-control form-control-sm"
                                            style="max-width: 220px;"
                                            value="<c:out value='${viewCountFormatted}' default='0'/>" readonly />
                                    </td>
                                </tr>
                                <tr>
                                    <th>노출여부</th>
                                    <td>
                                        <select name="exposureStatusCd" id="exposureStatusCd"
                                            class="form-select form-select-sm" style="max-width: 220px;">
                                            <option value="Y" <c:if
                                                test="${empty salesProduct.exposureStatusCd or salesProduct.exposureStatusCd eq 'Y'}">
                                                selected</c:if>>노출</option>
                                            <option value="N" <c:if test="${salesProduct.exposureStatusCd eq 'N'}">
                                                selected</c:if>>비노출</option>
                                        </select>
                                    </td>
                                    <th>사용여부</th>
                                    <td>
                                        <select name="useYn" id="useYn" class="form-select form-select-sm"
                                            style="max-width: 220px;">
                                            <option value="Y" <c:if
                                                test="${empty salesProduct.useYn or salesProduct.useYn eq 'Y'}">selected
                                                </c:if>>사용</option>
                                            <option value="N" <c:if test="${salesProduct.useYn eq 'N'}">selected</c:if>
                                                >미사용</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th>판매자(업체명)</th>
                                    <td>
                                        <c:set var="selectedSellerIdStr"
                                            value="${fn:trim(salesProduct.sellerMemberId)}" />
                                        <select name="sellerMemberId" id="sellerMemberId"
                                            class="form-select form-select-sm" style="max-width: 220px;">
                                            <option value="">선택</option>
                                            <c:forEach var="seller" items="${sellers}">
                                                <c:set var="sellerPkStr" value="${fn:trim(seller.memberPk)}" />
                                                <c:set var="legacySellerId" value="${fn:trim(seller.loginId)}" />
                                                <c:set var="sellerSelected"
                                                    value="${selectedSellerIdStr eq sellerPkStr or selectedSellerIdStr eq legacySellerId}" />
                                                <option value="<c:out value='${sellerPkStr}'/>"
                                                    data-legacy-id="<c:out value='${legacySellerId}'/>"
                                                    data-seller-name="<c:out value='${seller.ceoName}'/>"
                                                    ${sellerSelected ? 'selected' : '' }>
                                                    <c:out value='${seller.companyName}' />
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <th>판매자명</th>
                                    <td>
                                        <select name="sellerName" id="sellerName" class="form-select form-select-sm"
                                            style="max-width: 220px;">
                                            <option value="">선택</option>
                                            <c:forEach var="seller" items="${sellers}">
                                                <c:set var="sellerPkStr" value="${fn:trim(seller.memberPk)}" />
                                                <c:set var="legacySellerId" value="${fn:trim(seller.loginId)}" />
                                                <option value="<c:out value='${seller.ceoName}'/>"
                                                    data-member-id="<c:out value='${sellerPkStr}'/>"
                                                    data-legacy-id="<c:out value='${legacySellerId}'/>" <c:if
                                                    test="${seller.ceoName eq salesProduct.sellerName}">selected</c:if>>
                                                    <c:out value='${seller.ceoName}' />
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th>MD 코멘트</th>
                                    <td colspan="3"><textarea name="mdComment" rows="2"
                                            class="form-control form-control-sm"><c:out value='${salesProduct.mdComment}'/></textarea>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <!-- 2. 상품 구성 목록 -->
                        <div class="d-flex justify-content-between align-items-center mt-4 mb-2">
                            <div class="section-header" style="margin:0;">상품 구성 목록</div>
                            <button type="button" class="btn btn-secondary btn-sm" id="addComponentButton"
                                onclick="fn_addComponentPopup()">구성 추가</button>
                        </div>
                        <!-- 구성 상품 테이블 영역 (JS로 렌더링 될 부분 - 테이블 태그가 필요하다면 추가해야 함) -->
                        <table class="table table-bordered table-hover text-center" style="font-size: 0.9rem;">
                            <thead class="table-light">
                                <tr>
                                    <th>판매자</th>
                                    <th>구성상품명</th>
                                    <th>판매유형</th>
                                    <th>판매상태</th>
                                    <th>판매가</th>
                                    <th>원가</th>
                                    <th>VAT</th>
                                    <th>보관구분</th>
                                    <th>가공구분</th>
                                    <th>구분</th>
                                    <th>등록일</th>
                                    <th>수정일</th>
                                    <th>노출여부</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody id="componentTableBody">
                                <tr id="emptyRow">
                                    <td colspan="14" class="text-muted py-4">구성 상품이 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>


                        <!-- 3. 이미지 등록 -->
                        <div class="section-header">상품 이미지</div>
                        <div class="row g-2 mb-4">
                            <c:forEach begin="1" end="5" varStatus="status">
                                <c:set var="image" value="${salesProduct.imageList[status.index-1]}" />
                                <div class="col">
                                    <div class="image-upload-box" id="imageBox${status.index}"
                                        data-input-id="file${status.index}" style="cursor: pointer;">
                                        <!-- 실제 파일 input (숨김) -->
                                        <input type="file" id="file${status.index}" name="file${status.index}"
                                            accept="image/*" style="display:none;"
                                            onchange="fn_previewImage(this, 'imageBox${status.index}')">

                                        <c:choose>
                                            <c:when test="${not empty image}">
                                                <img src="${image.imgUrl}" alt="상품 이미지 ${status.index}"
                                                    class="product-image-thumb" data-full-url="${image.imgUrl}" />
                                                <button type="button" class="btn btn-light btn-sm image-change-btn"
                                                    onclick="event.stopPropagation(); document.getElementById('file${status.index}').click();">변경</button>
                                                <input type="hidden" name="existingImages[${status.index-1}].imgId"
                                                    value="${image.imgId}" />
                                            </c:when>
                                            <c:otherwise>
                                                <div class="text-center text-muted small">
                                                    <i class="bi bi-cloud-upload fs-3 d-block mb-2"></i>
                                                    클릭하여 이미지 업로드
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- 4. 상품 상세 설명 -->
                        <div class="section-header">상품 상세 설명</div>
                        <textarea id="mdContent" name="detailHtml" class="form-control"
                            style="width:100%; height:300px;"><c:out value='${salesProduct.detailHtml}'/></textarea>
                        <div class="form-text">상세 설명은 네이버 스마트에디터가 적용되며, 이미지 삽입 후 미리보기로 확인할 수 있습니다.</div>

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

                        <!-- 6. 하단 버튼 -->
                        <div class="d-flex justify-content-end gap-2 mt-5 mb-5">
                            <button type="button" class="btn btn-secondary px-4" onclick="fn_preview()">미리보기</button>
                            <button type="button" class="btn btn-secondary px-4" onclick="fn_save();">저장</button>
                            <button type="button" class="btn btn-secondary px-4" onclick="history.back()">취소</button>
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
                        if (!tbody) return; // 테이블이 없을 경우 방어

                        tbody.innerHTML = '';

                        if (componentProductList.length === 0) {
                            tbody.innerHTML = '<tr id="emptyRow"><td colspan="14" class="text-muted py-4">구성 상품이 없습니다.</td></tr>';
                            return;
                        }

                        componentProductList.forEach((item, index) => {
                            const salePrice = Number(item.listPrice) || 0;
                            const costPrice = Number(item.costPrice) || 0;
                            const vatAmount = Number(item.vatAmount) || 0;

                            const tr = document.createElement('tr');
                            tr.innerHTML = `
                <td>\${item.sellerName}</td>
                <td>\${item.componentProdName}</td>
                <td>\${item.saleTypeName}</td>
                <td>\${item.saleStatusName}</td>
                <td class="text-end">\${salePrice.toLocaleString()}</td>
                <td class="text-end">\${costPrice.toLocaleString()}</td>
                <td class="text-end">\${vatAmount.toLocaleString()}</td>
                <td>\${item.storageTypeName}</td>
                <td>\${item.processTypeName}</td>
                <td>\${item.divisionTypeName}</td>
                <td>\${item.regDt}</td>
                <td>\${item.modDt}</td>
                <td>\${item.exposureStatusCd == 'Y' ? '노출' : '비노출'}</td>
                <td>
                    <button type="button" class="btn btn-secondary btn-sm" style="font-size:0.8rem;" onclick="removeComponentRow(\${index})">삭제</button>
                </td>
            `;
                            tbody.appendChild(tr);
                        });

                        // 테이블 갱신 시 가격 정보도 업데이트
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
                        const vatRateHidden = document.getElementById('vatRate');
                        const saleStartDateInput = document.getElementById('saleStartDt');
                        const saleEndDateInput = document.getElementById('saleEndDt');
                        const sellerSelect = document.getElementById('sellerMemberId');
                        const exposureStatusSelect = document.getElementById('exposureStatusCd');

                        if (componentProductList.length > 0) {
                            let totalSale = 0, totalCost = 0, totalVat = 0;
                            let rawSellerId = null;
                            let defaultSellerId = null;
                            let forceHidden = false;
                            const today = new Date().toISOString().slice(0, 10);
                            componentProductList.forEach(item => {
                                const salePrice = Number(item.listPrice) || 0;
                                totalSale += salePrice;
                                totalCost += Number(item.costPrice) || 0;
                                totalVat += Number(item.vatAmount) || 0;

                                const saleTypeCode = (item.saleType || '').toString();
                                const saleTypeName = item.saleTypeName || '';
                                const isRawMaterial = saleTypeName.indexOf('원물') > -1 || saleTypeCode.toLowerCase().indexOf('raw') > -1;

                                if (!defaultSellerId && item.sellerMemberId) defaultSellerId = item.sellerMemberId;
                                if (!rawSellerId && isRawMaterial && item.sellerMemberId) rawSellerId = item.sellerMemberId;

                                const isHidden = item.exposureStatusCd === 'N';
                                const outOfPeriod = (item.saleStartDt && item.saleStartDt > today) || (item.saleEndDt && item.saleEndDt < today);

                                if (isHidden || outOfPeriod) forceHidden = true;
                            });

                            salePriceInput.value = totalSale;
                            costPriceInput.value = totalCost;
                            vatAmountInput.value = totalVat;
                            // salePriceInput.readOnly = true; // User wants these editable
                            // saleStartDateInput.readOnly = true;
                            // saleEndDateInput.readOnly = true;

                            if (rawSellerId) sellerSelect.value = rawSellerId;
                            else if (defaultSellerId) sellerSelect.value = defaultSellerId;

                            const { start, end } = calculateSalePeriod(componentProductList);
                            saleStartDateInput.value = start;
                            saleEndDateInput.value = end;
                            const hasCalculatedPeriod = !!(start && end);
                            saleStartDateInput.readOnly = hasCalculatedPeriod;
                            saleEndDateInput.readOnly = hasCalculatedPeriod;

                            if (forceHidden && exposureStatusSelect && exposureStatusSelect.value !== 'N') {
                                exposureStatusSelect.value = 'N';
                                alert("구성상품 중 판매 중지(비노출)되거나 판매 기간이 아닌 상품이 포함되어 있어\n전체 상품이 '비노출' 로 설정됩니다.");
                            }
                        } else {
                            // salePriceInput.readOnly = false;
                            // saleStartDateInput.readOnly = false;
                            // saleEndDateInput.readOnly = false;
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
                        window.open('about:blank', 'productPreviewPopup', `width=\${width},height=\${height},top=\${top},left=\${left},scrollbars=yes,resizable=yes`);

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