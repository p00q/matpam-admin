<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<fmt:formatDate var="saleStartValue" value="${product.saleStartAt}" pattern="yyyy-MM-dd'T'HH:mm" />
<fmt:formatDate var="saleEndValue" value="${product.saleEndAt}" pattern="yyyy-MM-dd'T'HH:mm" />

<div class="container-fluid px-4">
    <h1 class="mt-4">상품 상세 정보</h1>
    <ol class="breadcrumb mb-4">
        <li class="breadcrumb-item"><a href="<c:url value='/admin/dashboard/main.do'/>">대시보드</a></li>
        <li class="breadcrumb-item"><a href="<c:url value='/admin/product/productList.do'/>">상품 관리</a></li>
        <li class="breadcrumb-item active">상품 상세</li>
    </ol>

    <form:form modelAttribute="product" action="${pageContext.request.contextPath}/admin/product/saveProduct.do" method="post" id="productForm">
        <form:hidden path="productId" />
        <form:hidden path="tenantId" />
        <form:hidden path="taxCategory" id="taxCategory" />
        <input type="hidden" name="itemKind" value="GOODS" />

        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white py-3">
                <h5 class="mb-0"><i class="fas fa-box me-2"></i>상품 기본 정보</h5>
            </div>
            <div class="card-body p-4">
                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label fw-bold">판매자명 <span class="text-danger">*</span></label>
                        <c:choose>
                            <c:when test="${sellerLocked}">
                                <c:forEach var="seller" items="${sellerList}">
                                    <input type="text" class="form-control" value="${seller.companyName}" readonly />
                                    <input type="hidden" name="sellerCompanyId" value="${seller.companyId}" />
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <select name="sellerCompanyId" class="form-select" required>
                                    <option value="">판매업체 선택</option>
                                    <c:forEach var="seller" items="${sellerList}">
                                        <option value="${seller.companyId}" <c:if test="${product.sellerCompanyId == seller.companyId}">selected</c:if>>${seller.companyName}</option>
                                    </c:forEach>
                                </select>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">상품번호</label>
                        <c:choose>
                            <c:when test="${not empty product.productId}">
                                <form:input path="productCode" class="form-control" readonly="true" />
                            </c:when>
                            <c:otherwise>
                                <form:input path="productCode" class="form-control" placeholder="미입력 시 자동 채번" />
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">과세여부</label>
                        <input type="text" id="taxCategoryLabel" class="form-control bg-light" value="" readonly />
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-12">
                        <label class="form-label fw-bold d-block">상품유형 <span class="text-danger">*</span></label>
                        <label class="form-check form-check-inline">
                            <form:radiobutton path="processingType" value="RAW_GOODS" cssClass="form-check-input js-product-type" />
                            <span class="form-check-label">원물</span>
                        </label>
                        <label class="form-check form-check-inline">
                            <form:radiobutton path="processingType" value="FINISHED_GOODS" cssClass="form-check-input js-product-type" />
                            <span class="form-check-label">완제품</span>
                        </label>
                        <label class="form-check form-check-inline">
                            <form:radiobutton path="processingType" value="PROCESSED_GOODS" cssClass="form-check-input js-product-type" />
                            <span class="form-check-label">가공</span>
                        </label>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-8">
                        <label class="form-label fw-bold">상품명 <span class="text-danger">*</span></label>
                        <form:input path="productName" class="form-control" maxlength="200" required="required" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">단위/중량 구분 <span class="text-danger">*</span></label>
                        <form:select path="unitName" class="form-select" required="required">
                            <form:option value="kg" label="kg" />
                            <form:option value="g" label="g" />
                            <form:option value="box" label="box" />
                            <form:option value="ea" label="ea" />
                        </form:select>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label fw-bold">품목상태 <span class="text-danger">*</span></label>
                        <form:select path="saleStatus" class="form-select">
                            <form:option value="ON_SALE" label="판매중" />
                            <form:option value="STOPPED" label="판매중지" />
                            <form:option value="SOLD_OUT" label="품절" />
                            <form:option value="APPROVAL_WAIT" label="승인대기" />
                            <form:option value="TEMP_SAVE" label="임시저장" />
                            <form:option value="HIDDEN" label="숨김" />
                        </form:select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">판매시작일</label>
                        <input type="datetime-local" name="saleStartAt" class="form-control" value="${saleStartValue}" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">판매종료일</label>
                        <input type="datetime-local" name="saleEndAt" class="form-control" value="${saleEndValue}" />
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white py-3">
                <h5 class="mb-0"><i class="fas fa-won-sign me-2"></i>가격/재고/전시</h5>
            </div>
            <div class="card-body p-4">
                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label fw-bold">공급가액</label>
                        <form:input path="supplyPrice" type="number" min="0" step="0.01" class="form-control js-money" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">부가세액</label>
                        <form:input path="vatAmount" type="number" min="0" step="0.01" class="form-control bg-light" readonly="true" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">판매가격</label>
                        <form:input path="salePrice" type="number" min="0" step="0.01" class="form-control js-money" />
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-3">
                        <label class="form-label fw-bold">전시순번</label>
                        <form:input path="displayOrder" type="number" min="0" step="1" class="form-control" placeholder="미입력 시 자동" />
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-bold">배송비</label>
                        <form:input path="deliveryFee" type="number" min="0" step="0.01" class="form-control" />
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-bold">재고관리여부</label>
                        <div class="pt-2">
                            <label class="form-check form-check-inline">
                                <form:radiobutton path="stockManageYn" value="Y" cssClass="form-check-input" />
                                <span class="form-check-label">사용</span>
                            </label>
                            <label class="form-check form-check-inline">
                                <form:radiobutton path="stockManageYn" value="N" cssClass="form-check-input" />
                                <span class="form-check-label">미사용</span>
                            </label>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-bold">안전재고수량</label>
                        <form:input path="safetyStockQty" type="number" min="0" step="0.01" class="form-control" />
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-12">
                        <label class="form-label fw-bold d-block">상품 표시 옵션</label>
                        <input type="hidden" name="isNew" id="isNew" value="${product.isNew == 'Y' ? 'Y' : 'N'}" />
                        <input type="hidden" name="isMonthly" id="isMonthly" value="${product.isMonthly == 'Y' ? 'Y' : 'N'}" />
                        <input type="hidden" name="isHidden" id="isHidden" value="${product.isHidden == 'Y' ? 'Y' : 'N'}" />
                        <label class="form-check form-check-inline">
                            <input type="checkbox" id="isNewCheck" class="form-check-input js-flag-check" data-target="isNew" <c:if test="${product.isNew == 'Y'}">checked</c:if> />
                            <span class="form-check-label">신상품</span>
                        </label>
                        <label class="form-check form-check-inline">
                            <input type="checkbox" id="isMonthlyCheck" class="form-check-input js-flag-check" data-target="isMonthly" <c:if test="${product.isMonthly == 'Y'}">checked</c:if> />
                            <span class="form-check-label">이달의 상품</span>
                        </label>
                        <label class="form-check form-check-inline">
                            <input type="checkbox" id="isHiddenCheck" class="form-check-input js-flag-check" data-target="isHidden" <c:if test="${product.isHidden == 'Y'}">checked</c:if> />
                            <span class="form-check-label">상품 숨김</span>
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white py-3">
                <h5 class="mb-0"><i class="fas fa-image me-2"></i>상품 이미지</h5>
            </div>
            <div class="card-body p-4">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">대표이미지 URL</label>
                        <form:input path="mainImageUrl" class="form-control js-image-url" maxlength="500" placeholder="/images/product/main.jpg" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">추가이미지 1 URL</label>
                        <form:input path="subImageUrl1" class="form-control js-image-url" maxlength="500" />
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">추가이미지 2 URL</label>
                        <form:input path="subImageUrl2" class="form-control js-image-url" maxlength="500" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">추가이미지 3 URL</label>
                        <form:input path="subImageUrl3" class="form-control js-image-url" maxlength="500" />
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white py-3">
                <h5 class="mb-0"><i class="fas fa-pen me-2"></i>상품 설명</h5>
            </div>
            <div class="card-body p-4">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">MD코멘트</label>
                        <form:input path="mdComment" class="form-control" maxlength="500" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">상품요약</label>
                        <form:input path="summary" class="form-control" maxlength="1000" />
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold">상품설명</label>
                    <form:textarea path="description" class="form-control" rows="8" />
                </div>
            </div>
        </div>

        <div class="card shadow-sm mb-4" id="recommendedProcessPanel">
            <div class="card-header bg-white py-3">
                <h5 class="mb-0"><i class="fas fa-link me-2"></i>추천가공</h5>
            </div>
            <div class="card-body p-4">
                <c:choose>
                    <c:when test="${empty recommendedProcessCandidates}">
                        <div class="text-muted">선택 가능한 가공 상품이 없습니다.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="row g-2">
                            <c:forEach var="candidate" items="${recommendedProcessCandidates}">
                                <c:set var="candidateToken" value=",${candidate.productId}," />
                                <div class="col-md-6 col-lg-4">
                                    <label class="form-check border rounded p-2 w-100">
                                        <input type="checkbox"
                                               name="recommendedProcessIdArray"
                                               value="${candidate.productId}"
                                               class="form-check-input me-2"
                                               <c:if test="${fn:contains(product.recommendedProcessIdCsv, candidateToken)}">checked</c:if> />
                                        <span class="form-check-label">
                                            ${candidate.productName}
                                            <small class="text-muted d-block">${candidate.productCode}</small>
                                        </span>
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="d-flex justify-content-end gap-2 mt-4 mb-5">
            <a href="<c:url value='/admin/product/productList.do'/>" class="btn btn-light px-4">목록으로</a>
            <button type="submit" class="btn btn-primary px-4">저장하기</button>
        </div>
    </form:form>
</div>

<script>
(function () {
    var VAT_RATE = 0.1;
    var isSyncingPrice = false;

    function money(value) {
        var num = Number(value || 0);
        return Math.round(num * 100) / 100;
    }

    function updateTaxCategory() {
        var checked = document.querySelector('input[name="processingType"]:checked');
        var type = checked ? checked.value : 'RAW_GOODS';
        var tax = type === 'RAW_GOODS' ? 'TAX_FREE' : 'TAXABLE';
        var label = tax === 'TAX_FREE' ? '면세' : '과세';
        var prefix = type === 'RAW_GOODS' ? '1000000' : (type === 'FINISHED_GOODS' ? '2000000' : '3000000');

        document.getElementById('taxCategory').value = tax;
        document.getElementById('taxCategoryLabel').value = label;

        var code = document.getElementById('productCode');
        if (code && !code.value) {
            code.placeholder = prefix + ' 대역 자동 채번';
        }

        var order = document.getElementById('displayOrder');
        if (order && !order.value) {
            order.placeholder = prefix + ' 대역 자동';
        }

        var panel = document.getElementById('recommendedProcessPanel');
        if (panel) {
            panel.style.display = type === 'RAW_GOODS' ? '' : 'none';
        }
        syncPriceFromSupply();
    }

    function syncPriceFromSupply() {
        if (isSyncingPrice) return;
        isSyncingPrice = true;
        var tax = document.getElementById('taxCategory').value;
        var supply = document.getElementById('supplyPrice');
        var vat = document.getElementById('vatAmount');
        var sale = document.getElementById('salePrice');
        var supplyValue = Number(supply.value || 0);

        if (tax === 'TAX_FREE') {
            vat.value = '0.00';
            if (supply.value) sale.value = money(supplyValue).toFixed(2);
        } else if (supply.value) {
            var vatValue = money(supplyValue * VAT_RATE);
            vat.value = vatValue.toFixed(2);
            sale.value = money(supplyValue + vatValue).toFixed(2);
        }
        isSyncingPrice = false;
    }

    function syncPriceFromSale() {
        if (isSyncingPrice) return;
        isSyncingPrice = true;
        var tax = document.getElementById('taxCategory').value;
        var supply = document.getElementById('supplyPrice');
        var vat = document.getElementById('vatAmount');
        var sale = document.getElementById('salePrice');
        var saleValue = Number(sale.value || 0);

        if (tax === 'TAX_FREE') {
            vat.value = '0.00';
            if (sale.value) supply.value = money(saleValue).toFixed(2);
        } else if (sale.value) {
            var supplyValue = money(saleValue / 1.1);
            var vatValue = money(saleValue - supplyValue);
            supply.value = supplyValue.toFixed(2);
            vat.value = vatValue.toFixed(2);
        }
        isSyncingPrice = false;
    }

    document.querySelectorAll('.js-product-type').forEach(function (radio) {
        radio.addEventListener('change', updateTaxCategory);
    });
    var supply = document.getElementById('supplyPrice');
    var sale = document.getElementById('salePrice');
    if (supply) supply.addEventListener('input', syncPriceFromSupply);
    if (sale) sale.addEventListener('input', syncPriceFromSale);
    document.querySelectorAll('.js-flag-check').forEach(function (checkbox) {
        function syncFlag() {
            var target = document.getElementById(checkbox.getAttribute('data-target'));
            if (target) target.value = checkbox.checked ? 'Y' : 'N';
        }
        checkbox.addEventListener('change', syncFlag);
        syncFlag();
    });
    updateTaxCategory();
})();
</script>
