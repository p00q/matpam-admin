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
                }

                .image-upload-box:hover {
                    background-color: #f8f9fa;
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
                                <div class="image-upload-box"
                                    onclick="document.getElementById('file${status.index}').click()">
                                    <div class="text-center">
                                        <i class="bi bi-plus-lg fs-3 text-secondary"></i>
                                    </div>
                                    <input type="file" name="files" id="file${status.index}" style="display:none;"
                                        onchange="fn_previewImage(this, ${status.index})" accept="image/*" />
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- 4. 상품 상세 설명 -->
                    <div class="section-header">상품 상세 설명</div>
                    <div class="mb-4 bg-light p-3 border text-center" style="height: 200px;">
                        에디터 영역 (추후 구현)
                    </div>

                    <!-- 5. 하단 버튼 -->
                    <div class="d-flex justify-content-end gap-2 mt-5 mb-5">
                        <button type="button" class="btn btn-secondary px-4">미리보기</button>
                        <button type="submit" class="btn btn-secondary px-4">저장</button>
                        <button type="button" class="btn btn-secondary px-4" onclick="history.back()">취소</button>
                    </div>

                </form>
            </div>

            <script>
                // === 구성상품 관련 로직 ===
                let bundleList = [];

                function fn_addBundlePopup() {
                    const url = '<c:url value="/admin/product/popup/bundleList.do"/>';
                    const name = 'bundlePopup';
                    const option = 'width=1000,height=800,scrollbars=yes';
                    window.open(url, name, option);
                }

                function addBundleRow(item) {
                    bundleList.push(item);
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
                        const tr = document.createElement('tr');
                        tr.innerHTML = `
                <td>\${item.sellerName}</td>
                <td>\${item.productName}</td>
                <td>\${item.saleType}</td>
                <td>\${item.saleStatusName}</td>
                <td class="text-end">\${item.salePrice.toLocaleString()}</td>
                <td class="text-end">\${item.costPrice.toLocaleString()}</td>
                <td class="text-end">\${item.vatAmount.toLocaleString()}</td>
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
                        let hasRawMaterial = false;
                        let rawSellerId = null;

                        bundleList.forEach(item => {
                            totalSale += item.salePrice || 0;
                            totalCost += item.costPrice || 0;
                            totalVat += item.vatAmount || 0;

                            // 5. 판매자: 원물이 있으면 원물의 판매자 우선
                            if (item.saleType === '원물') { // 실제 코드값 확인 필요
                                hasRawMaterial = true;
                                rawSellerId = item.sellerId;
                            }
                        });

                        salePriceInput.value = totalSale;
                        costPriceInput.value = totalCost;
                        vatAmountInput.value = totalVat;

                        salePriceInput.readOnly = true;
                        costPriceInput.readOnly = true;
                        vatAmountInput.readOnly = true;

                        // 5. 판매자 설정
                        if (hasRawMaterial && rawSellerId) {
                            sellerSelect.value = rawSellerId;
                            // sellerSelect.disabled = true; // 필요시 비활성화하지만 submit시 값을 넘겨야 하므로 disabled보다는 CSS처리나 hidden값 사용 권장
                        }

                        // 3, 4. 노출여부/기간 등은 복합적이므로 첫번째 상품 기준으로 예시 설정 하거나 로직 상세화 필요
                        // 여기서는 첫번째 상품 기준으로 설정
                        const first = bundleList[0];
                        // 예시 로직

                    } else {
                        // 구성상품 없으면 직접 입력 가능
                        salePriceInput.readOnly = false;
                        costPriceInput.readOnly = false;
                        vatAmountInput.readOnly = false;
                        // sellerSelect.disabled = false;
                    }
                }

                function fn_previewImage(input, index) {
                    // 이미지 미리보기 로직 (생략 - 박스 안에 img 태그 생성)
                }

                // 노출여부 동기화
                function fn_toggleDisplayYn(checkbox) {
                    document.getElementById('displayYnValue').value = checkbox.checked ? 'Y' : 'N';
                }

                document.addEventListener('DOMContentLoaded', function () {
                    const displayYnCheckbox = document.getElementById('displayYnCheckbox');
                    fn_toggleDisplayYn(displayYnCheckbox);
                });

            </script>