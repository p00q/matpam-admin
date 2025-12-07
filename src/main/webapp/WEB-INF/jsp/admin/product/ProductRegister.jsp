<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                    <h4>판매상품 등록</h4>
                    <div>
                        <button type="button" class="btn btn-secondary"
                            onclick="location.href='<c:url value="/admin/product/productList.do"/>'">목록</button>
                    </div>
                </div>

                <form name="productForm" method="post" enctype="multipart/form-data">
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
                                        <input class="form-check-input" type="checkbox" id="displayYnCheckbox"
                                            <c:if test="${product.displayYn ne 'N'}">checked</c:if>
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
                                            <option value="${seller.memberNo}"
                                                <c:if test="${seller.memberNo eq product.sellerId}">selected</c:if>>
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
                        <button type="button" class="btn btn-secondary btn-sm" onclick="fn_addBundlePopup()">구성
                            추가</button>
                    </div>

                    <table class="table table-bordered table-hover text-center align-middle bg-white" id="bundleTable">
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
                    <div class="row g-2 mb-4">
                        <c:forEach begin="1" end="5" varStatus="status">
                            <div class="col">
                                <div class="image-upload-box" id="imageBox${status.index}" data-input-id="file${status.index}">
                                    <div class="text-center text-muted small">이미지를 업로드하세요</div>
                                </div>
                                <input type="file" name="files" id="file${status.index}" style="display:none;"
                                    onchange="fn_previewImage(this, 'imageBox${status.index}')" accept="image/*" />
                            </div>
                        </c:forEach>
                    </div>

                    <!-- 4. 상품 상세 설명 -->
                    <div class="section-header">상품 상세 설명</div>
                    <textarea id="mdContent" name="description" class="form-control" style="width:100%; height:300px;">
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
                    <button type="button" class="btn btn-secondary px-4">미리보기</button>
                    <button type="submit" class="btn btn-secondary px-4">저장</button>
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

        <script id="smartEditorScript" type="text/javascript" charset="utf-8"
            src="<c:url value='/smarteditor/js/service/HuskyEZCreator.js'/>"
            onerror="this.onerror=null; this.src='https://cdn.jsdelivr.net/gh/naver/smarteditor2@2.10.0/workspace/static/js/service/HuskyEZCreator.js';"></script>
        <script>
            // === 구성상품 관련 로직 ===
            let bundleList = [];
            const previewImages = {};
            const objectUrlMap = {};
            const imageModalElement = document.getElementById('imagePreviewModal');
            const imageModalInstance = (window.bootstrap && imageModalElement) ? new bootstrap.Modal(imageModalElement) : null;
            let fallbackModalCloser = null;
            let oEditors = [];

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

                function fn_addBundlePopup() {
                    const url = '<c:url value="/admin/product/popup/bundleList.do"/>';
                    const name = 'bundlePopup';
                    const option = 'width=1000,height=800,scrollbars=yes';
                    window.open(url, name, option);
                }

                function addBundleRow(item) {
                    bundleList.push(normalizeBundleItem(item));
                    renderBundleTable();
                    updateProductInfo();
                }

                function removeBundleRow(index) {
                    bundleList.splice(index, 1);
                    renderBundleTable();
                    updateProductInfo();
                }

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
                    <input type="hidden" name="compositionList[\${index}].bundleId" value="\${item.bundleId}">
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

                if (bundleList.length > 0) {
                    // 2. 가격 합계 계산 (수정금지)
                    let totalSale = 0, totalCost = 0, totalVat = 0;
                    let rawSellerId = null;
                    let defaultSellerId = null;

                    bundleList.forEach(item => {
                        totalSale += Number(item.salePrice) || 0;
                        totalCost += Number(item.costPrice) || 0;
                        totalVat += Number(item.vatAmount) || 0;

                        const saleTypeCode = (item.saleType || '').toString();
                        const saleTypeName = item.saleTypeName || '';
                        const isRawMaterial = saleTypeName.indexOf('원물') > -1 || saleTypeCode.toLowerCase().indexOf('raw') > -1;

                        if (!defaultSellerId && item.sellerId) {
                            defaultSellerId = item.sellerId;
                        }

                        if (!rawSellerId && isRawMaterial && item.sellerId) {
                            rawSellerId = item.sellerId;
                        }

                    });

                    salePriceInput.value = totalSale;
                    costPriceInput.value = totalCost;
                    vatAmountInput.value = totalVat;

                    salePriceInput.readOnly = true;
                    costPriceInput.readOnly = true;
                    vatAmountInput.readOnly = true;

                    // 판매자는 원물 판매자 우선, 없으면 첫번째 구성 판매자로 설정
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

                } else {
                    // 구성상품 없으면 직접 입력 가능
                    salePriceInput.readOnly = false;
                    costPriceInput.readOnly = false;
                    vatAmountInput.readOnly = false;
                    saleStartDateInput.readOnly = false;
                    saleEndDateInput.readOnly = false;
                    // sellerSelect.disabled = false;
                }
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

                function fn_previewImage(input, boxId) {
                    const box = document.getElementById(boxId);
                    if (!input.files || input.files.length === 0 || !box) return;

                    const file = input.files[0];
                    const prevUrl = objectUrlMap[boxId];
                    if (prevUrl) {
                        URL.revokeObjectURL(prevUrl);
                    }

                    const src = URL.createObjectURL(file);
                    objectUrlMap[boxId] = src;
                    previewImages[boxId] = src;

                    box.innerHTML = `
                        <img src="${src}" alt="업로드 이미지" />
                        <button type="button" class="btn btn-light btn-sm image-change-btn" onclick="event.stopPropagation(); document.getElementById('${input.id}').click();">변경</button>
                    `;

                    box.onclick = function () {
                        openImageModal(src);
                    };
                }

            function openImageModal(src) {
                const modalImg = document.getElementById('imagePreviewModalImg');
                if (!modalImg) return;
                modalImg.src = src;

                    if (imageModalInstance) {
                        imageModalInstance.show();
                        return;
                    }

                    if (!imageModalElement) return;
                    imageModalElement.classList.add('show');
                    imageModalElement.style.display = 'block';
                    imageModalElement.removeAttribute('aria-hidden');
                    document.body.classList.add('modal-open');
                    document.body.style.overflow = 'hidden';

                    fallbackModalCloser = function () {
                        imageModalElement.classList.remove('show');
                        imageModalElement.style.display = 'none';
                        imageModalElement.setAttribute('aria-hidden', 'true');
                        document.body.classList.remove('modal-open');
                        document.body.style.overflow = '';
                    };

                    imageModalElement.addEventListener('click', fallbackModalCloser, { once: true });
                }

                function initSmartEditor() {
                    const localSkin = "<c:url value='/smarteditor/SmartEditor2Skin.html'/>";
                    const cdnSkin = "https://cdn.jsdelivr.net/gh/naver/smarteditor2@2.10.0/workspace/static/SmartEditor2Skin.html";

                    const createEditor = function (skinUrl) {
                        if (!(window.nhn && window.nhn.husky && window.nhn.husky.EZCreator)) return;
                        window.nhn.husky.EZCreator.createInIFrame({
                            oAppRef: oEditors,
                            elPlaceHolder: "mdContent",
                            sSkinURI: skinUrl,
                            fCreator: "createSEditor2",
                            htParams: {
                                bUseToolbar: true,
                                bUseVerticalResizer: true,
                                bUseModeChanger: true
                            }
                        });
                    };

                    const tryCreate = () => {
                        fetch(localSkin, { method: 'HEAD' })
                            .then(res => createEditor(res.ok ? localSkin : cdnSkin))
                            .catch(() => createEditor(cdnSkin));
                    };

                    if (window.nhn && window.nhn.husky && window.nhn.husky.EZCreator) {
                        tryCreate();
                    } else {
                        const loader = document.getElementById('smartEditorScript');
                        if (loader) {
                            loader.addEventListener('load', tryCreate, { once: true });
                            loader.addEventListener('error', () => createEditor(cdnSkin), { once: true });
                        }
                    }
                }

                // 노출여부 동기화
                function fn_toggleDisplayYn(checkbox) {
                    document.getElementById('displayYnValue').value = checkbox.checked ? 'Y' : 'N';
                }

                document.addEventListener('DOMContentLoaded', function () {
                    const displayYnCheckbox = document.getElementById('displayYnCheckbox');
                    fn_toggleDisplayYn(displayYnCheckbox);

                    document.querySelectorAll('.image-upload-box').forEach(box => {
                        const inputId = box.getAttribute('data-input-id');
                        box.addEventListener('click', function () {
                            if (previewImages[box.id]) {
                                openImageModal(previewImages[box.id]);
                            } else if (inputId) {
                                const inputEl = document.getElementById(inputId);
                                if (inputEl) {
                                    inputEl.click();
                                }
                            }
                        });
                    });

                    initSmartEditor();

                    window.addEventListener('beforeunload', function () {
                        Object.values(objectUrlMap).forEach((url) => URL.revokeObjectURL(url));
                    });

                    const form = document.forms['productForm'];
                    if (form) {
                        form.addEventListener('submit', function () {
                            if (oEditors && oEditors.getById && oEditors.getById["mdContent"]) {
                                oEditors.getById["mdContent"].exec("UPDATE_CONTENTS_FIELD", []);
                            }
                        });
                    }
                });

            </script>