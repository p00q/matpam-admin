<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!-- 판매상품 등록 화면 -->

                <style>
                    .form-table th,
                    .form-table td {
                        padding: 0.5rem 0.75rem !important;
                        vertical-align: middle;
                    }

                    .form-table th {
                        background-color: #f8f9fa;
                        font-weight: 600;
                        width: 12%;
                    }

                    .section-header {
                        font-weight: 700;
                        font-size: 1.1rem;
                        margin-top: 2rem;
                        margin-bottom: 0.5rem;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .section-header::before {
                        content: "";
                        display: block;
                        width: 4px;
                        height: 16px;
                        background-color: #2c3e50;
                    }

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
                                <c:when test="${product.productNo != null}">판매상품 상세</c:when>
                                <c:otherwise>판매상품 등록</c:otherwise>
                            </c:choose>
                        </h4>
                        <div>
                            <button type="button" class="btn btn-secondary" onclick="location.href='<c:url value="
                                /admin/product/productList.do" />'">목록</button>
                        </div>
                    </div>

                    <form name="productForm" method="post"
                        action="${pageContext.request.contextPath}/admin/product/productRegist.do"
                        enctype="multipart/form-data">
                        <input type="hidden" name="productNo" value="<c:out value='${product.productNo}'/>" />
                        <input type="hidden" name="displayYn" id="displayYnValue"
                            value="<c:out value='${product.displayYn}' default='Y'/>" />

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
                                    <td>
                                        <input type="text" name="productName" class="form-control form-control-sm"
                                            value="<c:out value='${product.productName}'/>" required />
                                    </td>
                                    <th>상품 번호</th>
                                    <td>
                                        <input type="text" class="form-control form-control-sm" placeholder="자동 생성"
                                            value="<c:out value='${product.productNo}'/>" readonly disabled />
                                    </td>
                                </tr>
                                <tr>
                                    <th>판매 가격</th>
                                    <td>
                                        <div class="input-group input-group-sm">
                                            <input type="number" name="salePrice" id="salePrice" class="form-control"
                                                value="<c:out value='${product.salePrice}' default='0'/>" />
                                            <span class="input-group-text">원</span>
                                        </div>
                                    </td>
                                    <th>원가</th>
                                    <td>
                                        <div class="input-group input-group-sm">
                                            <input type="number" name="costPrice" id="costPrice" class="form-control"
                                                value="<c:out value='${product.costPrice}' default='0'/>" />
                                            <span class="input-group-text">원</span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>부가세</th>
                                    <td>
                                        <div class="input-group input-group-sm">
                                            <input type="number" name="vatAmount" id="vatAmount" class="form-control"
                                                value="<c:out value='${product.vatAmount}' default='0'/>" />
                                            <span class="input-group-text">원</span>
                                        </div>
                                    </td>
                                    <th>노출여부</th>
                                    <td>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="displayYnCheckbox" <c:if
                                                test="${product.displayYn ne 'N'}">checked</c:if>
                                            onclick="fn_toggleDisplayYn(this)">
                                            <label class="form-check-label" for="displayYnCheckbox">노출</label>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>판매기간</th>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <input type="date" name="saleStartDate" id="saleStartDate"
                                                class="form-control form-control-sm"
                                                value="<fmt:formatDate value='${product.saleStartDate}' pattern='yyyy-MM-dd'/>" />
                                            <span>~</span>
                                            <input type="date" name="saleEndDate" id="saleEndDate"
                                                class="form-control form-control-sm"
                                                value="<fmt:formatDate value='${product.saleEndDate}' pattern='yyyy-MM-dd'/>" />
                                        </div>
                                    </td>
                                    <th>조회수</th>
                                    <td>
                                        <input type="text" class="form-control form-control-sm" value="0" readonly />
                                    </td>
                                </tr>
                                <tr>
                                    <th>상품 요약</th>
                                    <td>
                                        <input type="text" name="productSummary" class="form-control form-control-sm"
                                            value="<c:out value='${product.productSummary}'/>" />
                                    </td>
                                    <th>판매자</th>
                                    <td>
                                        <select name="sellerId" id="sellerId" class="form-select form-select-sm">
                                            <option value="">선택</option>
                                            <c:forEach var="seller" items="${sellers}">
                                                <option value="${seller.memberNo}" <c:if
                                                    test="${seller.memberNo eq product.sellerId}">selected</c:if>>
                                                    ${seller.companyName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th>MD 코멘트</th>
                                    <td colspan="3">
                                        <input type="text" name="mdComment" class="form-control form-control-sm"
                                            value="<c:out value='${product.mdComment}'/>" />
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <!-- 2. 상품 구성 목록 -->
                        <div class="d-flex justify-content-between align-items-center mt-4 mb-2">
                            <div class="section-header" style="margin:0;">상품 구성 목록</div>
                            <button type="button" class="btn btn-secondary btn-sm" id="addBundleButton">구성 추가</button>
                        </div>

                        <table class="table table-bordered table-hover text-center align-middle bg-white"
                            id="bundleTable">
                            <thead class="table-light">
                                <tr>
                                    <th>판매 업체</th>
                                    <th>상품명</th>
                                    <th>판매유형</th>
                                    <th>판매상태</th>
                                    <th>판매가격</th>
                                    <th>원가</th>
                                    <th>VAT</th>
                                    <th>저장유형</th>
                                    <th>처리유형</th>
                                    <th>분리유형</th>
                                    <th>생성일</th>
                                    <th>변경일</th>
                                    <th>노출상태</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody id="bundleTableBody">
                                <!-- Javascript로 동적 추가 -->
                                <tr id="emptyRow">
                                    <td colspan="14" class="text-muted py-4">구성 상품이 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>

                        <!-- 3. 상품 이미지 -->
                        <div class="section-header">상품 이미지</div>
                        <div class="alert alert-info small mb-2">
                            <i class="bi bi-info-circle me-1"></i>
                            이미지는 로컬 환경에서만 미리보기가 가능합니다. 저장 후 다시 열면 이미지가 표시되지 않습니다. (서버 이미지 저장 기능 개발 예정)
                        </div>
                        <div class="row g-2 mb-4">
                            <c:forEach begin="0" end="4" varStatus="status">
                                <div class="col">
                                    <div class="image-upload-box position-relative d-flex align-items-center justify-content-center border rounded bg-light"
                                        id="preview-wrapper-${status.index}"
                                        onclick="fn_triggerFileUpload('${status.index}')"
                                        style="cursor: pointer; height: 150px; overflow: hidden;">

                                        <!-- 업로드 안내 문구 -->
                                        <div id="btn-upload-${status.index}" class="text-center text-muted small">
                                            <i class="bi bi-cloud-upload fs-3 d-block mb-2"></i>
                                            클릭하여 업로드
                                        </div>

                                        <!-- 미리보기 이미지 -->
                                        <img id="preview${status.index}" class="product-image-thumb w-100 h-100"
                                            style="display:none; object-fit: cover;" alt="상품이미지" />

                                        <!-- 삭제 버튼 -->
                                        <button type="button"
                                            class="btn-close position-absolute top-0 end-0 m-2 bg-white"
                                            style="z-index: 10;" onclick="fn_deleteImage('${status.index}');"></button>
                                    </div>
                                    <input type="file" name="files" id="file${status.index}" style="display:none;"
                                        onchange="fn_previewImage(this, '${status.index}')" accept="image/*" />
                                </div>
                            </c:forEach>
                        </div>

                        <!-- 4. 상품 상세 설명 -->
                        <div class="section-header">상품 상세 설명</div>
                        <textarea id="mdContent" name="description" class="form-control"
                            style="width:100%; height:300px;">
                        <c:out value='${product.description}'/>
                    </textarea>
                        <div class="form-text">상세 설명은 네이버 스마트에디터가 적용되며, 이미지 삽입 후 미리보기로 확인할 수 있습니다.</div>

                        <!-- 5. 안내 정보 -->
                        <div class="section-header">안내 정보</div>
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <div class="card h-100">
                                    <div class="card-header bg-light fw-bold">상품 결제 정보</div>
                                    <div class="card-body">
                                        <textarea class="form-control" name="paymentInfo" rows="5"
                                            placeholder="결제 수단, 결제 시 유의사항 등을 입력하세요."><c:out value='${product.paymentInfo}'/></textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card h-100">
                                    <div class="card-header bg-light fw-bold">배송 정보</div>
                                    <div class="card-body">
                                        <textarea class="form-control" name="shippingInfo" rows="5"
                                            placeholder="배송 방법, 소요 기간, 배송비 등을 입력하세요."><c:out value='${product.shippingInfo}'/></textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card h-100">
                                    <div class="card-header bg-light fw-bold">교환 및 반품 정보</div>
                                    <div class="card-body">
                                        <textarea class="form-control" name="exchangeReturnInfo" rows="5"
                                            placeholder="교환/반품 조건, 절차, 비용 등을 입력하세요."><c:out value='${product.exchangeReturnInfo}'/></textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card h-100">
                                    <div class="card-header bg-light fw-bold">환불 정보</div>
                                    <div class="card-body">
                                        <textarea class="form-control" name="refundInfo" rows="5"
                                            placeholder="환불 소요 기간, 유의사항 등을 입력하세요."><c:out value='${product.refundInfo}'/></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 5. 하단 버튼 -->
                        <div class="d-flex justify-content-end gap-2 mt-5 mb-5">
                            <button type="button" class="btn btn-secondary px-4" onclick="fn_preview()">미리보기</button>
                            <button type="button" class="btn btn-secondary px-4" onclick="fn_save();">
                                저장
                            </button>
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

                    // ★ 전역 변수 추가
                    let bundleList = [];
                    const previewImages = {};
                    const objectUrlMap = {};
                    let imageModalInstance = null;

                    // 페이지 로딩 시 한 번만 호출
                    document.addEventListener('DOMContentLoaded', function () {
                        console.log('DOMContentLoaded - 페이지 초기화 시작');

                        initSmartEditor();
                        initImagePreview();
                        initSalePeriodRecalc();
                        initBundlePopup();
                        initDisplayToggle();
                        initUnloadCleanup();

                        // 구성상품 로딩 (수정 모드일 때만)
                        loadExistingCompositions();

                        // 이미지 미리보기 초기화 (썸네일이 있으면)
                        setTimeout(function () {
                            initProductImagePopup();
                        }, 500);

                        console.log('페이지 초기화 완료');
                    });

                    function initSmartEditor() {
                        if (!(window.nhn && window.nhn.husky && window.nhn.husky.EZCreator)) {
                            // 로딩이 조금 늦을 수 있으니 300ms 뒤 재시도
                            setTimeout(initSmartEditor, 300);
                            return;
                        }

                        nhn.husky.EZCreator.createInIFrame({
                            oAppRef: oEditors,
                            elPlaceHolder: "mdContent",   // textarea id
                            sSkinURI: "<c:url value='/smarteditor2/SmartEditor2Skin.html' />",
                            fCreator: "createSEditor2"
                        });
                    }

                    function syncEditorContent() {
                        if (oEditors && oEditors.getById && oEditors.getById["mdContent"]) {
                            oEditors.getById["mdContent"].exec("UPDATE_CONTENTS_FIELD", []);
                        }
                    }



                    // ===== 구성상품 / 판매기간 계산 =====
                    function calculateSalePeriod(components) {
                        if (!components || components.length === 0) {
                            return { start: '', end: '' };
                        }

                        const starts = components
                            .map(c => c.saleStartDate)
                            .filter(Boolean)
                            .sort();
                        const ends = components
                            .map(c => c.saleEndDate)
                            .filter(Boolean)
                            .sort();

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

                    // (Duplicate functions removed - moved to bottom)

                    function renderBundleTable() {
                        const tbody = document.getElementById('bundleTableBody');
                        tbody.innerHTML = '';

                        if (bundleList.length === 0) {
                            tbody.innerHTML = '<tr id="emptyRow"><td colspan="14" class="text-muted py-4">구성 상품이 없습니다.</td></tr>';
                            return;
                        }

                        bundleList.forEach((item, index) => {
                            const salePrice = Number(item.salePrice) || 0;
                            const costPrice = Number(item.costPrice) || 0;
                            const vatAmount = Number(item.vatAmount) || 0;

                            const tr = document.createElement('tr');
                            tr.innerHTML = `
                            <td>\${item.sellerName}</td>
                            <td>\${item.productName}</td>
                            <td>\${item.saleTypeName || item.saleType}</td>
                            <td>\${item.saleStatusName}</td>
                            <td class="text-end">\${salePrice.toLocaleString()}</td>
                            <td class="text-end">\${costPrice.toLocaleString()}</td>
                            <td class="text-end">\${vatAmount.toLocaleString()}</td>
                            <td>\${item.storageTypeName}</td>
                            <td>\${item.processTypeName}</td>
                            <td>\${item.divisionTypeName}</td>
                            <td>\${item.regDt}</td>
                            <td>\${item.modDt}</td>
                            <td>\${item.displayYn == 'Y' ? '노출' : '비노출'}</td>
                            <td>
                                <button type="button" class="btn btn-secondary btn-sm" style="font-size:0.8rem;" disabled>수정</button>
                                <button type="button" class="btn btn-secondary btn-sm" style="font-size:0.8rem;" onclick="removeBundleRow(\${index})">삭제</button>
                            </td>
                        `;
                            tbody.appendChild(tr);
                        });
                    }

                    function updateProductInfo() {
                        const salePriceInput = document.getElementById('salePrice');
                        const costPriceInput = document.getElementById('costPrice');
                        const vatAmountInput = document.getElementById('vatAmount');
                        const saleStartDateInput = document.getElementById('saleStartDate');
                        const saleEndDateInput = document.getElementById('saleEndDate');
                        const sellerSelect = document.getElementById('sellerId');
                        const displayYnCheckbox = document.getElementById('displayYnCheckbox');
                        const displayYnHidden = document.getElementById('displayYnValue');

                        if (bundleList.length > 0) {
                            let totalSale = 0, totalCost = 0, totalVat = 0;
                            let rawSellerId = null;
                            let defaultSellerId = null;
                            let forceHidden = false;
                            const today = new Date().toISOString().slice(0, 10); // YYYY-MM-DD

                            bundleList.forEach(item => {
                                totalSale += Number(item.salePrice) || 0;
                                totalCost += Number(item.costPrice) || 0;
                                totalVat += Number(item.vatAmount) || 0;

                                // 판매자 자동 선택 로직
                                const saleTypeCode = (item.saleType || '').toString();
                                const saleTypeName = item.saleTypeName || '';
                                const isRawMaterial =
                                    saleTypeName.indexOf('원물') > -1 ||
                                    saleTypeCode.toLowerCase().indexOf('raw') > -1;

                                if (!defaultSellerId && item.sellerId) {
                                    defaultSellerId = item.sellerId;
                                }
                                if (!rawSellerId && isRawMaterial && item.sellerId) {
                                    rawSellerId = item.sellerId;
                                }

                                // 노출 상태 로직: 구성상품이 비노출이거나 판매기간이 현재 날짜를 포함하지 않으면 비노출 강제
                                const isHidden = item.displayYn === 'N';
                                const outOfPeriod = (item.saleStartDate && item.saleStartDate > today) ||
                                    (item.saleEndDate && item.saleEndDate < today);

                                if (isHidden || outOfPeriod) {
                                    forceHidden = true;
                                }
                            });

                            salePriceInput.value = totalSale;
                            costPriceInput.value = totalCost;
                            vatAmountInput.value = totalVat;

                            salePriceInput.readOnly = true;
                            costPriceInput.readOnly = true;
                            vatAmountInput.readOnly = true;

                            if (rawSellerId) {
                                sellerSelect.value = rawSellerId;
                            } else if (defaultSellerId) {
                                sellerSelect.value = defaultSellerId;
                            }

                            const { start, end } = calculateSalePeriod(bundleList);
                            saleStartDateInput.value = start;
                            saleEndDateInput.value = end;

                            const hasCalculatedPeriod = !!(start && end);
                            saleStartDateInput.readOnly = hasCalculatedPeriod;
                            saleEndDateInput.readOnly = hasCalculatedPeriod;

                            // 강제 비노출 처리
                            if (forceHidden) {
                                if (displayYnCheckbox.checked) {
                                    displayYnCheckbox.checked = false;
                                    displayYnHidden.value = 'N';
                                    alert("구성상품 중 판매 중지(비노출)되거나 판매 기간이 아닌 상품이 포함되어 있어\n전체 상품이 '비노출' 로 설정됩니다.");
                                }
                                // displayYnCheckbox.disabled = true; // 필요하다면 disabled 처리
                            } else {
                                // displayYnCheckbox.disabled = false;
                            }

                        } else {
                            salePriceInput.readOnly = false;
                            costPriceInput.readOnly = false;
                            vatAmountInput.readOnly = false;
                            saleStartDateInput.readOnly = false;
                            saleEndDateInput.readOnly = false;
                            // displayYnCheckbox.disabled = false;
                        }
                    }

                    function fn_preview() {
                        // 1. 에디터 내용 동기화
                        if (window.oEditors && oEditors.length > 0) {
                            oEditors.getById["mdContent"].exec("UPDATE_CONTENTS_FIELD", []);
                        }

                        // 2. 팝업 창 열기
                        const width = 1200;
                        const height = 800;
                        const left = (window.screen.width / 2) - (width / 2);
                        const top = (window.screen.height / 2) - (height / 2);
                        const win = window.open('about:blank', 'productPreviewPopup', `width=${width},height=${height},top=${top},left=${left},scrollbars=yes,resizable=yes`);

                        // 3. 폼 타겟 변경 및 서브밋
                        const form = document.querySelector('form[name="productForm"]');
                        const originalAction = form.action;
                        const originalTarget = form.target;

                        form.action = '<c:url value="/admin/product/preview.do"/>'; // 미리보기용 별도 URL 필요 (혹은 JS로 파싱)
                        form.target = 'productPreviewPopup';

                        // 미리보기 URL이 구현되지 않았을 경우를 대비해 alert만 띄우거나, 임시로 처리
                        // 현재 preview.do가 컨트롤러에 없으므로, 현재는 alert로 대체하거나 컨트롤러에 추가해야 함.
                        // 요구사항에 '구현'하라고 했으므로 컨트롤러에 추가 예정.
                        form.submit();

                        // 4. 폼 복구
                        setTimeout(() => {
                            form.action = originalAction;
                            form.target = originalTarget || '_self';
                        }, 100);
                    }

                    function normalizeBundleItem(item) {
                        const safeDate = (value) => {
                            if (!value) return '';
                            return value.toString();
                        };

                        return {
                            ...item,
                            salePrice: Number(item.salePrice) || 0,
                            costPrice: Number(item.costPrice) || 0,
                            vatAmount: Number(item.vatAmount) || 0,
                            saleStartDate: safeDate(item.saleStartDate),
                            saleEndDate: safeDate(item.saleEndDate)
                        };
                    }

                    // ===== 이미지 업로드 & 팝업 =====
                    // 파일 업로드 후 박스에 썸네일 넣기
                    function fn_previewImage(input, boxId) {
                        const box = document.getElementById(boxId);
                        if (!input.files || input.files.length === 0 || !box) return;

                        const file = input.files[0];

                        // 이전 blob URL 정리
                        const prevUrl = objectUrlMap[boxId];
                        if (prevUrl) {
                            URL.revokeObjectURL(prevUrl);
                        }

                        const src = URL.createObjectURL(file);
                        objectUrlMap[boxId] = src;
                        previewImages[boxId] = src;

                        // ★ JSP EL이 건드리지 못하게 문자열 + 연산으로 작성
                        box.innerHTML =
                            '<img src="' + src + '" alt="업로드 이미지" ' +
                            'class="product-image-thumb" ' +
                            'data-full-url="' + src + '" />' +
                            '<button type="button" ' +
                            'class="btn btn-light btn-sm image-change-btn" ' +
                            'onclick="event.stopPropagation(); document.getElementById(\'' + input.id + '\').click();">' +
                            '변경' +
                            '</button>';

                        // 새로 생긴 썸네일에 팝업 이벤트 다시 바인딩
                        initProductImagePopup();
                    }



                    function getImageModalInstance() {
                        // 부트스트랩 JS가 있으면 Modal 인스턴스 사용
                        if (window.bootstrap && window.bootstrap.Modal) {
                            if (!imageModalInstance) {
                                const el = document.getElementById('imagePreviewModal');
                                if (el) {
                                    imageModalInstance = new bootstrap.Modal(el);
                                }
                            }
                            return imageModalInstance;
                        }
                        // 부트스트랩 JS 없으면 null 반환 (수동 처리로 fallback)
                        return null;
                    }

                    function openImageModal(src) {
                        // 빈 이미지는 모달 열지 않음
                        if (!src) {
                            console.warn('이미지 소스가 없습니다');
                            return;
                        }

                        const el = document.getElementById('imagePreviewModal');
                        const img = document.getElementById('imagePreviewModalImg');
                        if (!el || !img) {
                            console.error('모달 요소를 찾을 수 없습니다');
                            return;
                        }

                        // 이미지 로드 실패 시 처리
                        img.onerror = function () {
                            console.error('이미지 로드 실패:', src);
                            // 기본 플레이스홀더 이미지
                            img.src = 'data:image/svg+xml;charset=utf-8,' + encodeURIComponent(
                                '<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">' +
                                '<rect width="400" height="400" fill="#f0f0f0"/>' +
                                '<text x="50%" y="50%" font-size="20" text-anchor="middle" dy=".3em" fill="#999">' +
                                '이미지를 불러올 수 없습니다' +
                                '</text></svg>'
                            );
                        };

                        img.src = src;

                        const modal = getImageModalInstance();
                        if (modal) {
                            // 부트스트랩 모달 사용
                            modal.show();
                            return;
                        }

                        // ✅ 부트스트랩 JS 없는 환경용 수동 모달 처리
                        el.classList.add('show');
                        el.style.display = 'block';
                        el.removeAttribute('aria-hidden');
                        document.body.classList.add('modal-open');
                        document.body.style.overflow = 'hidden';

                        function handleClick(e) {
                            // 바깥 영역 클릭 시 닫기
                            if (e.target === el) {
                                el.classList.remove('show');
                                el.style.display = 'none';
                                el.setAttribute('aria-hidden', 'true');
                                document.body.classList.remove('modal-open');
                                document.body.style.overflow = '';
                                el.removeEventListener('click', handleClick);
                            }
                        }

                        el.addEventListener('click', handleClick);
                    }

                    function initProductImagePopup() {
                        const thumbs = document.querySelectorAll('.product-image-thumb');
                        console.log('initProductImagePopup - 썸네일 개수:', thumbs.length);

                        if (!thumbs.length) {
                            console.log('업로드된 이미지 없음');
                            return;
                        }

                        thumbs.forEach((thumb, index) => {
                            if (thumb.dataset.popupBound === 'true') return;
                            thumb.dataset.popupBound = 'true';

                            thumb.addEventListener('click', function (e) {
                                e.preventDefault();
                                e.stopPropagation();

                                const fullUrl = thumb.getAttribute('data-full-url') || thumb.getAttribute('src');
                                console.log(`썸네일[${index}] 클릭 - URL:`, fullUrl);

                                if (!fullUrl) {
                                    console.warn('이미지 URL이 없습니다');
                                    return;
                                }

                                // Blob URL 체크 - 경고만 표시하고 계속 진행
                                if (fullUrl.startsWith('blob:')) {
                                    console.warn('Blob URL - 페이지 새로고침 시 사라질 수 있습니다:', fullUrl);
                                    // Blob URL도 현재 세션에서는 작동하므로 계속 진행
                                }

                                openImageModal(fullUrl);
                            });
                        });
                    }

                    function initImagePreview() {
                        // 업로드 박스 클릭 시 : 이미지 있으면 팝업, 없으면 파일 선택
                        document.querySelectorAll('.image-upload-box').forEach((box) => {
                            const inputId = box.getAttribute('data-input-id');

                            // 이미 서버에서 내려온 이미지가 있을 경우 미리 등록
                            const innerImg = box.querySelector('.product-image-thumb, img');
                            if (innerImg) {
                                const fullUrl = innerImg.getAttribute('data-full-url') || innerImg.getAttribute('src');
                                if (fullUrl) {
                                    previewImages[box.id] = fullUrl;
                                }
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

                        // 썸네일이 이미 있는 경우도 팝업 이벤트 연결
                        initProductImagePopup();
                    }

                    // ===== 기타 초기화 =====
                    function initSalePeriodRecalc() {
                        updateProductInfo();
                    }

                    function fn_toggleDisplayYn(checkbox) {
                        const hiddenField = document.getElementById('displayYnValue');
                        if (hiddenField && checkbox) {
                            hiddenField.value = checkbox.checked ? 'Y' : 'N';
                        }
                    }

                    function initDisplayToggle() {
                        const displayYnCheckbox = document.getElementById('displayYnCheckbox');
                        fn_toggleDisplayYn(displayYnCheckbox);
                        if (displayYnCheckbox) {
                            displayYnCheckbox.addEventListener('change', function (e) {
                                fn_toggleDisplayYn(e.target);
                            });
                        }
                    }

                    function initBundlePopup() {
                        const addButton = document.getElementById('addBundleButton');
                        if (addButton) {
                            addButton.addEventListener('click', function (e) {
                                e.preventDefault();
                                fn_addBundlePopup();
                            });
                        }
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
                            if (!dataElement) {
                                console.log('No composition data element found');
                                return;
                            }

                            const jsonText = dataElement.textContent || dataElement.innerText;
                            console.log('JSON text:', jsonText);

                            const compositions = JSON.parse(jsonText);
                            console.log('Parsed compositions:', compositions);

                            if (compositions && compositions.length > 0) {
                                compositions.forEach(function (comp) {
                                    if (comp.bundleId > 0) {
                                        bundleList.push({
                                            bundleId: comp.bundleId,
                                            productName: comp.productName || '',
                                            saleType: comp.saleType || '',
                                            saleTypeName: comp.saleTypeName || '',
                                            salePrice: comp.salePrice || 0,
                                            costPrice: comp.costPrice || 0,
                                            vatAmount: comp.vatAmount || 0,
                                            displayYn: comp.displayYn || 'Y',
                                            sellerName: comp.sellerName || '',
                                            saleStatusName: '',
                                            storageTypeName: '',
                                            processTypeName: '',
                                            divisionTypeName: '',
                                            regDt: '',
                                            modDt: ''
                                        });
                                        console.log('Added composition:', comp.bundleId, comp.productName);
                                    }
                                });

                                console.log('Final bundleList:', bundleList);
                                renderBundleTable();
                                updateProductInfo();
                            } else {
                                console.log('No compositions found');
                            }
                        } catch (e) {
                            console.error('Error loading compositions:', e);
                        }
                    }

                    // 이미지 삭제
                    function fn_deleteImage(index) {
                        // 이벤트 전파 중단 (중요: input file click 방지)
                        if (event) {
                            event.stopPropagation();
                            event.preventDefault();
                        }

                        document.getElementById('file' + index).value = "";
                        document.getElementById('preview' + index).src = "";
                        document.getElementById('preview' + index).style.display = "none";
                        document.getElementById('preview-wrapper-' + index).classList.remove('has-image');
                        document.getElementById('btn-upload-' + index).style.display = "flex";

                        // 삭제 시 hidden input도 정리
                        const hiddenInput = document.querySelector('input[name="displayYn"]'); // 예시, 실제로는 이미지 관련 hidden input 처리 필요
                    }

                    // 이미지 미리보기 (파일 선택 시)
                    function fn_previewImage(input, index) {
                        if (input.files && input.files[0]) {
                            var reader = new FileReader();
                            reader.onload = function (e) {
                                var preview = document.getElementById('preview' + index);
                                var wrapper = document.getElementById('preview-wrapper-' + index);
                                var btn = document.getElementById('btn-upload-' + index);

                                preview.src = e.target.result;
                                preview.style.display = "block";
                                wrapper.classList.add('has-image');
                                btn.style.display = "none";

                                // 팝업 이벤트 바인딩 (setTimeout으로 DOM 렌더링 후 처리)
                                setTimeout(initProductImagePopup, 100);
                            }
                            reader.readAsDataURL(input.files[0]);
                        }
                    }

                    // 파일 선택창 열기 (중복 실행 방지)
                    function fn_triggerFileUpload(index) {
                        var preview = document.getElementById('preview' + index);
                        if (preview && preview.style.display !== 'none') {
                            // 이미지가 이미 있으면 업로드창 띄우지 않음 (모달 띄우기는 img click event가 처리)
                            return;
                        }
                        document.getElementById('file' + index).click();
                    }

                    // 구성상품 추가 팝업
                    function fn_addBundlePopup() {
                        var url = "<c:url value='/admin/product/popup/bundleList.do'/>";
                        // 넓이 1100 -> 1200 (요청사항 3)
                        var popupOption = "width=1200,height=800,status=no,toolbar=no,scrollbars=yes";
                        window.open(url, "bundleProductPopup", popupOption);
                    }

                    // 미리보기
                    function fn_preview() {
                        // 에디터 내용 동기화
                        oEditors.getById["description"].exec("UPDATE_CONTENTS_FIELD", []);

                        var form = document.productForm;
                        var originalAction = form.action;
                        var originalTarget = form.target;

                        // 새 창 열기
                        window.open('', 'productPreviewPopup', 'width=1000,height=800,scrollbars=yes');

                        form.action = "<c:url value='/admin/product/preview.do'/>";
                        form.target = "productPreviewPopup";
                        form.submit();

                        // form 복구 (약간의 딜레이 후)
                        setTimeout(function () {
                            form.action = originalAction;
                            form.target = originalTarget;
                        }, 500);
                    }
                    // ===== 저장 버튼 처리 =====
                    function fn_save() {
                        // 1) 필수 입력 검증
                        const productName = document.querySelector('input[name="productName"]');
                        if (!productName || !productName.value.trim()) {
                            alert('상품명을 입력해주세요.');
                            if (productName) productName.focus();
                            return false;
                        }

                        // 2) 스마트에디터 내용 textarea로 반영
                        syncEditorContent();

                        // 3) 숫자 필드 빈 값 처리 (null 대신 0으로)
                        ['salePrice', 'costPrice', 'vatAmount'].forEach(fieldId => {
                            const field = document.getElementById(fieldId);
                            if (field && !field.value.trim()) {
                                field.value = '0';
                            }
                        });

                        // 4) 날짜 필드 빈 값 처리 (빈 문자열을 그냥 제출하지 않도록)
                        ['saleStartDate', 'saleEndDate'].forEach(fieldId => {
                            const field = document.getElementById(fieldId);
                            if (field && !field.value.trim()) {
                                // 빈 값인 경우 name 속성 제거하여 전송하지 않음
                                field.removeAttribute('name');
                            }
                        });

                        // 5) 구성상품 목록을 hidden input으로 추가
                        // 기존 구성상품 hidden input 제거
                        const form = document.productForm;
                        const oldInputs = form.querySelectorAll('input[name^="compositionList"]');
                        oldInputs.forEach(input => input.remove());

                        // bundleList를 기반으로 새로운 hidden input 생성
                        bundleList.forEach((item, index) => {
                            const input = document.createElement('input');
                            input.type = 'hidden';
                            input.name = 'compositionList[' + index + '].bundleId';
                            input.value = item.bundleId;
                            form.appendChild(input);
                        });

                        // 6) 페이지 나갈 때 뜨는 beforeunload 경고 끄기
                        window.onbeforeunload = null;

                        // 7) 실제 폼 제출
                        if (form) {
                            form.submit();
                        }
                    }
                </script>