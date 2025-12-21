<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!-- 구성상품(컴포넌트상품) 등록/상세 화면 -->

                <c:set var="saleTypeList" value="${not empty saleTypes ? saleTypes : saleTypeCodes}" />
                <c:set var="storageTypeList" value="${not empty storageTypes ? storageTypes : storageTypeCodes}" />
                <c:set var="processTypeList" value="${not empty processTypes ? processTypes : processTypeCodes}" />
                <c:set var="unitTypeList" value="${not empty unitTypes ? unitTypes : unitTypeCodes}" />
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
                            <li class="breadcrumb-item"><a
                                    href="<c:url value='/admin/product/componentProductList.do?menu=component'/>">구성상품관리</a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">
                                <c:choose>
                                    <c:when test="${not empty component.componentProdId}">구성 상품 상세</c:when>
                                    <c:otherwise>구성 상품 등록</c:otherwise>
                                </c:choose>
                            </li>
                        </ol>
                    </nav>

                    <h4 class="mb-4">
                        <c:choose>
                            <c:when test="${not empty component.componentProdId}">구성 상품 상세</c:when>
                            <c:otherwise>구성 상품 등록</c:otherwise>
                        </c:choose>
                    </h4>

                    <c:set var="formAction"
                        value="${not empty component.componentProdId ? '/admin/product/updateComponentProduct.do' : '/admin/product/insertComponentProduct.do'}" />

                    <c:if test="${not empty component.componentProdId}">
                        <fmt:formatNumber var="listPriceInt" value="${component.listPrice}" maxFractionDigits="0"
                            groupingUsed="false" />
                        <fmt:formatNumber var="costPriceInt" value="${component.costPrice}" maxFractionDigits="0"
                            groupingUsed="false" />
                        <fmt:formatNumber var="vatAmountInt" value="${component.vatAmount}" maxFractionDigits="0"
                            groupingUsed="false" />
                    </c:if>

                    <form name="componentForm" method="post" action="<c:url value='${formAction}'/>">
                        <input type="hidden" name="menu" value="component" />
                        <c:if test="${not empty component.componentProdId}">
                            <input type="hidden" name="componentProdId" value="${component.componentProdId}" />
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
                                <!-- Row 1: 구성상품 코드 / 상품명 -->
                                <tr>
                                    <th>구성상품 코드 <span class="text-danger">*</span></th>
                                    <td>
                                        <input type="text" name="componentProdCode" class="form-control form-control-sm"
                                            value="<c:out value='${component.componentProdCode}'/>" required
                                            placeholder="예) CP000001" />
                                    </td>
                                    <th>상품명 <span class="text-danger">*</span></th>
                                    <td>
                                        <input type="text" name="componentProdName" class="form-control form-control-sm"
                                            value="<c:out value='${component.componentProdName}'/>" required />
                                    </td>
                                </tr>

                                <!-- Row 2: 판매유형 / 판매자명 -->
                                <tr>
                                    <th>판매유형 <span class="text-danger">*</span></th>
                                    <td>
                                        <!-- 기존 saleDivCd -> saleTypeCd -->
                                        <select name="saleTypeCd" class="form-select form-select-sm"
                                            style="max-width: 200px;" required>
                                            <option value="" disabled <c:if test="${empty component.saleTypeCd}">
                                                selected
                                                </c:if>>선택</option>
                                            <c:forEach var="code" items="${saleTypeList}">
                                                <option value="${code.detailCode}" <c:if
                                                    test="${component.saleTypeCd eq code.detailCode}">selected</c:if>>
                                                    ${code.detailCodeName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </td>

                                    <th>판매자명 <span class="text-danger">*</span></th>
                                    <td>
                                        <!-- sellerMemberId는 회원 PK(MEMBER_ID)를 사용하며, 구데이터(loginId)도 대응 -->
                                        <select name="sellerMemberId" class="form-select form-select-sm"
                                            style="max-width: 200px;" required>
                                            <option value="" disabled <c:if test="${empty component.sellerMemberId}">
                                                selected</c:if>>선택</option>
                                            <c:forEach var="seller" items="${sellers}">
                                                <c:set var="sellerPkStr" value="${fn:trim(seller.memberPk)}" />
                                                <c:set var="legacySellerId" value="${fn:trim(seller.memberId)}" />
                                                <c:set var="componentSellerIdStr"
                                                    value="${fn:trim(component.sellerMemberId)}" />
                                                <c:set var="sellerSelected"
                                                    value="${componentSellerIdStr eq sellerPkStr or componentSellerIdStr eq legacySellerId}" />
                                                <option value="${sellerPkStr}" ${sellerSelected ? 'selected' : '' }>
                                                    ${seller.companyName} (${seller.ceoName})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>

                                <!-- Row 3: 저장유형 / 처리구분 -->
                                <tr>
                                    <th>저장유형 <span class="text-danger">*</span></th>
                                    <td>
                                        <select name="storageTypeCd" class="form-select form-select-sm"
                                            style="max-width: 200px;" required>
                                            <option value="" disabled <c:if test="${empty component.storageTypeCd}">
                                                selected
                                                </c:if>>선택</option>
                                            <c:forEach var="code" items="${storageTypeList}">
                                                <option value="${code.detailCode}" <c:if
                                                    test="${component.storageTypeCd eq code.detailCode}">selected</c:if>
                                                    >
                                                    ${code.detailCodeName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </td>

                                    <th>처리구분 <span class="text-danger">*</span></th>
                                    <td>
                                        <!-- 기존 processDivCd -> processTypeCd -->
                                        <select name="processTypeCd" class="form-select form-select-sm"
                                            style="max-width: 200px;" required>
                                            <option value="" disabled <c:if test="${empty component.processTypeCd}">
                                                selected
                                                </c:if>>선택</option>
                                            <c:forEach var="code" items="${processTypeList}">
                                                <option value="${code.detailCode}" <c:if
                                                    test="${component.processTypeCd eq code.detailCode}">selected</c:if>
                                                    >
                                                    ${code.detailCodeName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>

                                <!-- Row 4: 분리유형 / 단위유형 -->
                                <tr>
                                    <th>분리유형 <span class="text-danger">*</span></th>
                                    <td>
                                        <select name="cutTypeCd" class="form-select form-select-sm"
                                            style="max-width: 200px;" required>
                                            <option value="" disabled <c:if test="${empty component.cutTypeCd}">selected
                                                </c:if>>선택</option>
                                            <c:forEach var="code" items="${cutTypes}">
                                                <option value="${code.detailCode}" <c:if
                                                    test="${component.cutTypeCd eq code.detailCode}">selected</c:if>>
                                                    ${code.detailCodeName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </td>

                                    <th>단위유형 <span class="text-danger">*</span></th>
                                    <td>
                                        <select name="unitTypeCd" class="form-select form-select-sm"
                                            style="max-width: 200px;" required>
                                            <option value="" disabled <c:if test="${empty component.unitTypeCd}">
                                                selected
                                                </c:if>>선택</option>
                                            <c:forEach var="code" items="${unitTypeList}">
                                                <option value="${code.detailCode}" <c:if
                                                    test="${component.unitTypeCd eq code.detailCode}">selected</c:if>>
                                                    ${code.detailCodeName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>

                                <!-- Row 5: 판매가격 / VAT -->
                                <tr>
                                    <th>판매가격 <span class="text-danger">*</span></th>
                                    <td>
                                        <div class="input-group" style="max-width: 200px;">
                                            <input type="number" name="listPrice" id="listPrice"
                                                class="form-control form-control-sm" step="1"
                                                value="<c:out value='${not empty listPriceInt ? listPriceInt : (empty component.listPrice ? 0 : component.listPrice)}' default='0'/>"
                                                required min="0" />
                                            <span class="input-group-text">원</span>
                                        </div>
                                        <input type="hidden" name="totalSaleQty" id="totalSaleQty"
                                            value="<c:out value='${empty component.totalSaleQty ? component.listPrice : component.totalSaleQty}' default='0'/>" />
                                    </td>
                                    <th>VAT <span class="text-danger">*</span></th>
                                    <td>
                                        <div class="input-group" style="max-width: 200px;">
                                            <input type="number" name="vatAmount" id="vatAmount"
                                                class="form-control form-control-sm"
                                                value="<c:out value='${not empty vatAmountInt ? vatAmountInt : (empty component.vatAmount ? 0 : component.vatAmount)}' default='0'/>" />
                                            <span class="input-group-text">원</span>
                                        </div>
                                    </td>
                                </tr>

                                <!-- Row 6: 원가 / 판매상태 -->
                                <tr>
                                    <th>원가 <span class="text-danger">*</span></th>
                                    <td>
                                        <div class="input-group" style="max-width: 200px;">
                                            <input type="number" name="costPrice" id="costPrice"
                                                class="form-control form-control-sm" step="1"
                                                value="<c:out value='${not empty costPriceInt ? costPriceInt : (empty component.costPrice ? 0 : component.costPrice)}' default='0'/>"
                                                required min="0" />
                                            <span class="input-group-text">원</span>
                                        </div>
                                    </td>
                                    <th>판매상태 <span class="text-danger">*</span></th>
                                    <td>
                                        <select name="saleStatusCd" class="form-select form-select-sm"
                                            style="max-width: 200px;" required>
                                            <option value="" disabled <c:if test="${empty component.saleStatusCd}">
                                                selected</c:if>>선택</option>
                                            <c:forEach var="code" items="${saleStatusList}">
                                                <option value="${code.detailCode}" <c:if
                                                    test="${component.saleStatusCd eq code.detailCode}">selected</c:if>>
                                                    ${code.detailCodeName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>

                                <!-- Row 7: 노출상태 / 사용여부 -->
                                <tr>
                                    <th>노출상태</th>
                                    <td>
                                        <select name="exposureStatusCd" class="form-select form-select-sm"
                                            style="max-width: 200px;">
                                            <option value="Y" <c:if test="${component.exposureStatusCd eq 'Y'}">selected
                                                </c:if>>노출</option>
                                            <option value="N" <c:if test="${component.exposureStatusCd eq 'N'}">selected
                                                </c:if>>미노출</option>
                                        </select>
                                    </td>
                                    <th>사용여부</th>
                                    <td>
                                        <select name="useYn" class="form-select form-select-sm"
                                            style="max-width: 200px;">
                                            <option value="Y" <c:if
                                                test="${empty component.useYn or component.useYn eq 'Y'}">selected
                                                </c:if>>사용</option>
                                            <option value="N" <c:if test="${component.useYn eq 'N'}">selected</c:if>>미사용
                                            </option>
                                        </select>
                                    </td>
                                </tr>

                                <!-- Row 8: 판매 기간 -->
                                <tr>
                                    <th>판매 기간</th>
                                    <td colspan="3">
                                        <div class="d-flex align-items-center gap-2 flex-wrap">
                                            <input type="date" name="saleStartDt" class="form-control form-control-sm"
                                                value="<fmt:formatDate value='${component.saleStartDt}' pattern='yyyy-MM-dd'/>"
                                                style="max-width: 180px;" />
                                            <span class="text-muted">~</span>
                                            <input type="date" name="saleEndDt" class="form-control form-control-sm"
                                                value="<fmt:formatDate value='${component.saleEndDt}' pattern='yyyy-MM-dd'/>"
                                                style="max-width: 180px;" />
                                        </div>
                                    </td>
                                </tr>

                            </tbody>
                        </table>

                        <!-- Action Buttons -->
                        <div class="d-flex justify-content-end gap-2 mt-4">
                            <button type="submit" class="btn btn-primary px-4">
                                <c:choose>
                                    <c:when test="${not empty component.componentProdId}">수정</c:when>
                                    <c:otherwise>등록</c:otherwise>
                                </c:choose>
                            </button>

                            <button type="button" class="btn btn-secondary px-4" onclick="location.href='<c:url value="
                                /admin/product/componentProductList.do?menu=component" />';">취소</button>

                            <c:if test="${not empty component.componentProdId}">
                                <button type="button" class="btn btn-danger px-4" onclick="fn_delete()">삭제</button>
                            </c:if>
                        </div>
                    </form>
                </div>

                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const listPriceInput = document.getElementById('listPrice');
                        const vatAmountInput = document.getElementById('vatAmount');
                        const costPriceInput = document.getElementById('costPrice');
                        const totalSaleQtyInput = document.getElementById('totalSaleQty');
                        const saleStartInput = document.querySelector('input[name="saleStartDt"]');
                        const saleEndInput = document.querySelector('input[name="saleEndDt"]');

                        function sanitizeInteger(value) {
                            const num = Math.max(0, Math.floor(Number(value) || 0));
                            return Number.isFinite(num) ? num : 0;
                        }

                        function syncFromSalePrice() {
                            const salePrice = sanitizeInteger(listPriceInput.value);
                            listPriceInput.value = salePrice;

                            if (totalSaleQtyInput) {
                                totalSaleQtyInput.value = salePrice;
                            }
                        }

                        function calcVat() {
                            const listPrice = sanitizeInteger(listPriceInput.value);
                            // vatAmount is manually entered now, but we could default it to 10% if empty
                            if (!vatAmountInput.value || vatAmountInput.value == '0') {
                                vatAmountInput.value = Math.round(listPrice * 0.1);
                            }
                        }

                        function defaultSalePeriodIfEmpty() {
                            const today = new Date();
                            const toDateInputValue = (dateObj) => dateObj.toISOString().slice(0, 10);

                            if (saleStartInput && !saleStartInput.value) {
                                saleStartInput.value = toDateInputValue(today);
                            }

                            if (saleEndInput && !saleEndInput.value) {
                                const nextYear = new Date(today);
                                nextYear.setFullYear(today.getFullYear() + 1);
                                saleEndInput.value = toDateInputValue(nextYear);
                            }
                        }

                        listPriceInput.addEventListener('input', function () {
                            syncFromSalePrice();
                            calcVat();
                        });

                        syncFromSalePrice();
                        calcVat();
                        defaultSalePeriodIfEmpty();
                    });

                    document.querySelector('form[name="componentForm"]').addEventListener('submit', function (e) {
                        if (!this.checkValidity()) {
                            e.preventDefault();
                            e.stopPropagation();
                            alert('필수 항목을 입력해주세요.');
                        }
                        this.classList.add('was-validated');
                    });

                    function fn_delete() {
                        if (confirm('정말 삭제하시겠습니까?')) {
                            location.href = '<c:url value="/admin/product/deleteComponentProduct.do"/>?componentProdId=${component.componentProdId}';
                        }
                    }
                </script>

                <c:if test="${mode eq 'view'}">
                    <script>
                        document.addEventListener('DOMContentLoaded', function () {
                            document.querySelectorAll('form[name="componentForm"] input, form[name="componentForm"] select, form[name="componentForm"] textarea')
                                .forEach(function (el) {
                                    el.setAttribute('disabled', 'disabled');
                                });
                        });
                    </script>
                </c:if>