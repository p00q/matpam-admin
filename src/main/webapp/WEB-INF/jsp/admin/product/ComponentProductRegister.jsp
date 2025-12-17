<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
                            <!-- Row 1: 컴포넌트코드 / 상품명 -->
                            <tr>
                                <th>컴포넌트코드 <span class="text-danger">*</span></th>
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
                                        <option value="" disabled <c:if test="${empty component.saleTypeCd}">selected
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
                                            <c:set var="sellerPk" value="${seller.memberNo}" />
                                            <c:set var="legacySellerId" value="${seller.memberId}" />
                                            <option value="${sellerPk}"
                                                <c:if
                                                    test="${component.sellerMemberId eq sellerPk or component.sellerMemberId eq legacySellerId}">selected</c:if>>
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
                                        <option value="" disabled <c:if test="${empty component.storageTypeCd}">selected
                                            </c:if>>선택</option>
                                        <c:forEach var="code" items="${storageTypeList}">
                                            <option value="${code.detailCode}" <c:if
                                                test="${component.storageTypeCd eq code.detailCode}">selected</c:if>>
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
                                        <option value="" disabled <c:if test="${empty component.processTypeCd}">selected
                                            </c:if>>선택</option>
                                        <c:forEach var="code" items="${processTypeList}">
                                            <option value="${code.detailCode}" <c:if
                                                test="${component.processTypeCd eq code.detailCode}">selected</c:if>>
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
                                        <option value="" disabled <c:if test="${empty component.unitTypeCd}">selected
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

                            <!-- Row 5: 가격(정가/원가) / VAT율 -->
                            <tr>
                                <th>정가 <span class="text-danger">*</span></th>
                                <td>
                                    <div class="input-group" style="max-width: 200px;">
                                        <input type="number" name="listPrice" id="listPrice"
                                            class="form-control form-control-sm"
                                            value="<c:out value='${component.listPrice}'/>" required min="0" />
                                        <span class="input-group-text">원</span>
                                    </div>
                                </td>

                                <th>원가 <span class="text-danger">*</span></th>
                                <td>
                                    <div class="input-group" style="max-width: 200px;">
                                        <input type="number" name="costPrice" id="costPrice"
                                            class="form-control form-control-sm"
                                            value="<c:out value='${component.costPrice}'/>" required min="0" />
                                        <span class="input-group-text">원</span>
                                    </div>
                                </td>
                            </tr>

                            <tr>
                                <th>VAT율(%) <span class="text-danger">*</span></th>
                                <td>
                                    <div class="input-group" style="max-width: 200px;">
                                        <input type="number" name="vatRate" id="vatRate"
                                            class="form-control form-control-sm"
                                            value="<c:out value='${component.vatRate}'/>" required min="0" max="100" />
                                        <span class="input-group-text">%</span>
                                    </div>
                                </td>

                                <th>VAT(계산)</th>
                                <td>
                                    <div class="input-group" style="max-width: 200px;">
                                        <!-- 화면 표시용 계산값(저장X) -->
                                        <input type="number" id="vatAmountView" class="form-control form-control-sm"
                                            readonly />
                                        <span class="input-group-text">원</span>
                                    </div>
                                    <small class="text-muted">(정가 × VAT율)</small>
                                </td>
                            </tr>

                            <!-- Row 6: 판매상태 / 노출상태 -->
                            <tr>
                                <th>판매상태 <span class="text-danger">*</span></th>
                                <td>
                                    <!-- 기존 saleStatus -> saleStatusCd -->
                                    <select name="saleStatusCd" class="form-select form-select-sm"
                                        style="max-width: 200px;" required>
                                        <option value="" disabled <c:if test="${empty component.saleStatusCd}">selected
                                            </c:if>>선택</option>
                                        <c:forEach var="code" items="${saleStatusList}">
                                            <option value="${code.detailCode}" <c:if
                                                test="${component.saleStatusCd eq code.detailCode}">selected</c:if>>
                                                ${code.detailCodeName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </td>

                                <th>노출상태</th>
                                <td>
                                    <!-- 노출상태는 코드 테이블이 있으면 코드로 교체 권장 -->
                                    <select name="exposureStatusCd" class="form-select form-select-sm"
                                        style="max-width: 200px;">
                                        <option value="Y" <c:if test="${component.exposureStatusCd eq 'Y'}">selected
                                            </c:if>>노출</option>
                                        <option value="N" <c:if test="${component.exposureStatusCd eq 'N'}">selected
                                            </c:if>>미노출</option>
                                    </select>
                                </td>
                            </tr>

                            <!-- Row 7: 판매 기간 -->
                            <tr>
                                <th>판매 기간</th>
                                <td colspan="3">
                                    <div class="d-flex align-items-center gap-2">
                                        <!-- 기존 saleStartDate/saleEndDate -> saleStartDt/saleEndDt -->
                                        <input type="date" name="saleStartDt" class="form-control form-control-sm"
                                            value="<fmt:formatDate value='${component.saleStartDt}' pattern='yyyy-MM-dd'/>"
                                            style="max-width: 150px;" />
                                        <span>~</span>
                                        <input type="date" name="saleEndDt" class="form-control form-control-sm"
                                            value="<fmt:formatDate value='${component.saleEndDt}' pattern='yyyy-MM-dd'/>"
                                            style="max-width: 150px;" />
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 8: 사용여부 -->
                            <tr>
                                <th>사용여부</th>
                                <td colspan="3">
                                    <select name="useYn" class="form-select form-select-sm" style="max-width: 200px;">
                                        <option value="Y" <c:if
                                            test="${empty component.useYn or component.useYn eq 'Y'}">selected</c:if>>사용
                                        </option>
                                        <option value="N" <c:if test="${component.useYn eq 'N'}">selected</c:if>>미사용
                                        </option>
                                    </select>
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

                        <button type="button" class="btn btn-secondary px-4"
                            onclick="location.href='<c:url value='/admin/product/componentProductList.do?menu=component'/>'">취소</button>

                        <c:if test="${not empty component.componentProdId}">
                            <button type="button" class="btn btn-danger px-4" onclick="fn_delete()">삭제</button>
                        </c:if>
                    </div>
                </form>
            </div>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const listPriceInput = document.getElementById('listPrice');
                    const vatRateInput = document.getElementById('vatRate');
                    const vatAmountView = document.getElementById('vatAmountView');

                    function calcVat() {
                        const listPrice = parseFloat(listPriceInput.value) || 0;
                        const vatRate = parseFloat(vatRateInput.value) || 0;
                        const vat = Math.round(listPrice * (vatRate / 100));
                        vatAmountView.value = vat;
                    }

                    listPriceInput.addEventListener('input', calcVat);
                    vatRateInput.addEventListener('input', calcVat);

                    calcVat();
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