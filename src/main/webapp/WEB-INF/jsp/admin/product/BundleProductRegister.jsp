<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- 구성상품 등록/상세 화면 -->

<c:set var="saleTypeList" value="${not empty saleTypes ? saleTypes : saleTypeCodes}" />
<c:set var="storageTypeList" value="${not empty storageTypes ? storageTypes : storageTypeCodes}" />
<c:set var="divisionTypeList" value="${not empty divisionTypes ? divisionTypes : divisionTypeCodes}" />
<c:set var="processTypeList" value="${not empty processTypes ? processTypes : processTypeCodes}" />
<c:set var="unitTypeList" value="${unitTypes}" />
<c:set var="saleStatusList" value="${not empty saleStatuses ? saleStatuses : saleStatusCodes}" />

<style>
    .form-table th,
    .form-table td {
        padding: 0.6rem 0.75rem !important;
        vertical-align: middle;
    }

    .form-table th {
        background-color: #f8f9fa;
        font-weight: 600;
        width: 12%;
    }

    .section-header {
        background-color: #e9ecef;
        padding: 0.5rem 1rem;
        font-weight: 600;
        border-left: 4px solid #2c5f7c;
        margin-bottom: 1rem;
    }
</style>

<div class="container-fluid p-4">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><i class="bi bi-house-door-fill"></i></li>
            <li class="breadcrumb-item"><a href="<c:url value='/admin/product/bundleProductList.do?menu=bundle'/>">상품관리</a></li>
            <li class="breadcrumb-item"><a href="<c:url value='/admin/product/bundleProductList.do?menu=bundle'/>">상품목록</a></li>
            <li class="breadcrumb-item active" aria-current="page">
                <c:choose>
                    <c:when test="${not empty bundle.productNo}">구성 상품 상세</c:when>
                    <c:otherwise>구성 상품 등록</c:otherwise>
                </c:choose>
            </li>
        </ol>
    </nav>

    <h4 class="mb-4">
        <c:choose>
            <c:when test="${not empty bundle.productNo}">구성 상품 상세</c:when>
            <c:otherwise>구성 상품 등록</c:otherwise>
        </c:choose>
    </h4>

    <c:set var="formAction" value="${not empty bundle.productNo ? '/admin/product/updateBundleProduct.do' : '/admin/product/insertBundleProduct.do'}" />

    <form name="bundleForm" method="post" action="<c:url value='${formAction}'/>">
        <input type="hidden" name="menu" value="bundle" />
        <c:if test="${not empty bundle.productNo}">
            <input type="hidden" name="productNo" value="${bundle.productNo}" />
        </c:if>

        <div class="section-header">■ 상품일반정보</div>
        <table class="table table-bordered form-table">
            <colgroup>
                <col style="width: 12%;">
                <col style="width: 38%;">
                <col style="width: 12%;">
                <col style="width: 38%;">
            </colgroup>
            <tbody>
                <!-- Row 1: 상품명 / 판매유형 -->
                <tr>
                    <th>상품명 <span class="text-danger">*</span></th>
                    <td>
                        <input type="text" name="productName" class="form-control form-control-sm"
                            value="<c:out value='${bundle.productName}'/>" required />
                    </td>
                    <th>판매유형 <span class="text-danger">*</span></th>
                    <td>
                        <select name="saleType" class="form-select form-select-sm" style="max-width: 200px;" required>
                            <option value="" disabled <c:if test="${empty bundle.saleType}">selected</c:if>>선택</option>
                            <c:forEach var="code" items="${saleTypeList}">
                                <option value="${code.detailCode}" <c:if test="${bundle.saleType eq code.detailCode}">selected</c:if>>${code.detailCodeName}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <!-- Row 2: 저장유형 / 판매자명 -->
                <tr>
                    <th>저장유형 <span class="text-danger">*</span></th>
                    <td>
                        <select name="storageType" class="form-select form-select-sm" style="max-width: 200px;" required>
                            <option value="" disabled <c:if test="${empty bundle.storageType}">selected</c:if>>선택</option>
                            <c:forEach var="code" items="${storageTypeList}">
                                <option value="${code.detailCode}" <c:if test="${bundle.storageType eq code.detailCode}">selected</c:if>>${code.detailCodeName}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <th>판매자명 <span class="text-danger">*</span></th>
                    <td>
                        <select name="sellerId" class="form-select form-select-sm" style="max-width: 200px;" required>
                            <option value="" disabled <c:if test="${empty bundle.sellerId}">selected</c:if>>선택</option>
                            <c:forEach var="seller" items="${sellers}">
                                <option value="${seller.memberNo}" <c:if test="${bundle.sellerId eq seller.memberNo}">selected</c:if>>${seller.companyName}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <!-- Row 3: 처리유형 / 원가 -->
                <tr>
                    <th>처리유형 <span class="text-danger">*</span></th>
                    <td>
                        <select name="processType" class="form-select form-select-sm" style="max-width: 200px;" required>
                            <option value="" disabled <c:if test="${empty bundle.processType}">selected</c:if>>선택</option>
                            <c:forEach var="code" items="${processTypeList}">
                                <option value="${code.detailCode}" <c:if test="${bundle.processType eq code.detailCode}">selected</c:if>>${code.detailCodeName}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <th>원가 <span class="text-danger">*</span></th>
                    <td>
                        <div class="input-group" style="max-width: 200px;">
                            <input type="number" name="costPrice" id="costPrice" class="form-control form-control-sm"
                                value="<c:out value='${bundle.costPrice}'/>" required min="0" />
                            <span class="input-group-text">원</span>
                        </div>
                    </td>
                </tr>
                <!-- Row 4: 분리유형 / 부가세 -->
                <tr>
                    <th>분리유형 <span class="text-danger">*</span></th>
                    <td>
                        <select name="divisionType" class="form-select form-select-sm" style="max-width: 200px;" required>
                            <option value="" disabled <c:if test="${empty bundle.divisionType}">selected</c:if>>선택</option>
                            <c:forEach var="code" items="${divisionTypeList}">
                                <option value="${code.detailCode}" <c:if test="${bundle.divisionType eq code.detailCode}">selected</c:if>>${code.detailCodeName}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <th>부가세</th>
                    <td>
                        <div class="d-flex align-items-center gap-3">
                            <div class="input-group" style="max-width: 200px;">
                                <input type="number" name="vatAmount" id="vatAmount" class="form-control form-control-sm"
                                    value="<c:out value='${bundle.vatAmount}'/>" min="0" />
                                <span class="input-group-text">원</span>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="autoVat" id="autoVat" value="Y" <c:if test="${bundle.autoVatYn eq 'Y' or empty bundle.autoVatYn}">checked</c:if>>
                                <label class="form-check-label text-danger" for="autoVat">☑ 체크시 부가세 자동계산</label>
                            </div>
                        </div>
                    </td>
                </tr>
                <!-- Row 5: 단위구분 / 판매가격 -->
                <tr>
                    <th>단위구분 <span class="text-danger">*</span></th>
                    <td>
                        <select name="unitType" class="form-select form-select-sm" style="max-width: 200px;" required>
                            <option value="" disabled <c:if test="${empty bundle.unitType}">selected</c:if>>선택</option>
                            <c:forEach var="code" items="${unitTypeList}">
                                <option value="${code.detailCode}" <c:if test="${bundle.unitType eq code.detailCode}">selected</c:if>>${code.detailCodeName}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <th>판매가격</th>
                    <td>
                        <div class="d-flex align-items-center gap-2">
                            <div class="input-group" style="max-width: 200px;">
                                <input type="number" name="salePrice" id="salePrice" class="form-control form-control-sm"
                                    value="<c:out value='${bundle.salePrice}'/>" min="0" readonly />
                                <span class="input-group-text">원</span>
                            </div>
                            <small class="text-muted">(원가 + 부가세 = 판매가격)</small>
                        </div>
                    </td>
                </tr>
                <!-- Row 6: 판매상태 / 노출상태 -->
                <tr>
                    <th>판매상태 <span class="text-danger">*</span></th>
                    <td>
                        <select name="saleStatus" class="form-select form-select-sm" style="max-width: 200px;" required>
                            <option value="" disabled <c:if test="${empty bundle.saleStatus}">selected</c:if>>선택</option>
                            <c:forEach var="code" items="${saleStatusList}">
                                <option value="${code.detailCode}" <c:if test="${bundle.saleStatus eq code.detailCode}">selected</c:if>>${code.detailCodeName}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <th>노출상태</th>
                    <td>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="displayStatus" id="displayStatus" value="Y" <c:if test="${bundle.displayYn eq 'Y' or empty bundle.displayYn}">checked</c:if>>
                            <label class="form-check-label" for="displayStatus">노출</label>
                        </div>
                    </td>
                </tr>
                <!-- Row 7: 판매 기간 -->
                <tr>
                    <th>판매 기간</th>
                    <td colspan="3">
                        <div class="d-flex align-items-center gap-2">
                            <input type="date" name="saleStartDate" class="form-control form-control-sm"
                                value="<fmt:formatDate value='${bundle.saleStartDate}' pattern='yyyy-MM-dd'/>"
                                style="max-width: 150px;" />
                            <span>~</span>
                            <input type="date" name="saleEndDate" class="form-control form-control-sm"
                                value="<fmt:formatDate value='${bundle.saleEndDate}' pattern='yyyy-MM-dd'/>"
                                style="max-width: 150px;" />
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>

        <!-- Action Buttons -->
        <div class="d-flex justify-content-end gap-2 mt-4">
            <button type="submit" class="btn btn-primary px-4">
                <c:choose>
                    <c:when test="${not empty bundle.productNo}">수정</c:when>
                    <c:otherwise>등록</c:otherwise>
                </c:choose>
            </button>
            <button type="button" class="btn btn-secondary px-4" onclick="history.back()">취소</button>
            <c:if test="${not empty bundle.productNo}">
                <button type="button" class="btn btn-danger px-4" onclick="fn_delete()">삭제</button>
            </c:if>
        </div>
    </form>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const costPriceInput = document.getElementById('costPrice');
        const vatAmountInput = document.getElementById('vatAmount');
        const salePriceInput = document.getElementById('salePrice');
        const autoVatCheckbox = document.getElementById('autoVat');

        function calculatePrices() {
            const costPrice = parseInt(costPriceInput.value) || 0;

            if (autoVatCheckbox.checked) {
                const vatAmount = Math.round(costPrice * 0.1);
                vatAmountInput.value = vatAmount;
            } else {
                vatAmountInput.value = 0;
            }

            const vatAmount = parseInt(vatAmountInput.value) || 0;
            const salePrice = costPrice + vatAmount;
            salePriceInput.value = salePrice;
        }

        costPriceInput.addEventListener('input', calculatePrices);

        autoVatCheckbox.addEventListener('change', function () {
            if (this.checked) {
                vatAmountInput.readOnly = true;
            } else {
                vatAmountInput.readOnly = false;
            }
            calculatePrices();
        });

        if (autoVatCheckbox.checked) {
            vatAmountInput.readOnly = true;
        }

        if (!costPriceInput.value) {
            calculatePrices();
        }
    });

    document.querySelector('form[name="bundleForm"]').addEventListener('submit', function (e) {
        if (!this.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
            alert('필수 항목을 입력해주세요.');
        }
        this.classList.add('was-validated');
    });

    function fn_delete() {
        if (confirm('정말 삭제하시겠습니까?')) {
            location.href = '<c:url value="/admin/product/deleteBundleProduct.do"/>?productNo=${bundle.productNo}';
        }
    }
</script>

<c:if test="${mode eq 'view'}">
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('form[name="bundleForm"] input, form[name="bundleForm"] select, form[name="bundleForm"] textarea')
                .forEach(function (el) {
                    el.setAttribute('disabled', 'disabled');
                });
        });
    </script>
</c:if>
