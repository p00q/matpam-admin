<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid">
    <h4 class="mb-3">구성상품 ${mode eq 'view' ? '상세' : '등록'}</h4>

    <c:if test="${not empty message}">
        <div class="alert alert-success" role="alert">${message}</div>
    </c:if>

    <form id="bundleForm" method="post" action="<c:url value='/admin/product/bundleRegist.do'/>">
        <div class="row">
            <div class="col-md-6">
                <div class="mb-3">
                    <label class="form-label">상품명</label>
                    <input type="text" name="productName" value="${bundle.productName}" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">판매유형</label>
                    <select name="saleType" class="form-select">
                        <option value="">선택</option>
                        <c:forEach var="code" items="${saleTypes}">
                            <option value="${code.code}" ${code.code eq bundle.saleType ? 'selected' : ''}>${code.codeNm}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">유형</label>
                    <select name="type" class="form-select">
                        <option value="">선택</option>
                        <c:forEach var="code" items="${productTypes}">
                            <option value="${code.code}" ${code.code eq bundle.type ? 'selected' : ''}>${code.codeNm}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">업체명</label>
                    <input type="text" name="companyName" value="${bundle.companyName}" class="form-control" />
                </div>
                <div class="mb-3">
                    <label class="form-label">판매가격</label>
                    <input type="number" name="salePrice" value="${bundle.salePrice}" class="form-control" />
                </div>
                <div class="mb-3">
                    <label class="form-label">VAT</label>
                    <input type="number" name="vatAmount" value="${bundle.vatAmount}" class="form-control" />
                </div>
            </div>
            <div class="col-md-6">
                <div class="mb-3">
                    <label class="form-label">저장유형</label>
                    <select name="storageType" class="form-select">
                        <option value="">선택</option>
                        <c:forEach var="code" items="${storageTypes}">
                            <option value="${code.code}" ${code.code eq bundle.storageType ? 'selected' : ''}>${code.codeNm}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">분리유형</label>
                    <select name="divisionType" class="form-select">
                        <option value="">선택</option>
                        <c:forEach var="code" items="${divisionTypes}">
                            <option value="${code.code}" ${code.code eq bundle.divisionType ? 'selected' : ''}>${code.codeNm}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">처리유형</label>
                    <select name="processType" class="form-select">
                        <option value="">선택</option>
                        <c:forEach var="code" items="${processTypes}">
                            <option value="${code.code}" ${code.code eq bundle.processType ? 'selected' : ''}>${code.codeNm}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">판매상태</label>
                    <select name="saleStatus" class="form-select">
                        <option value="">선택</option>
                        <c:forEach var="code" items="${saleStatusCodes}">
                            <option value="${code.code}" ${code.code eq bundle.saleStatus ? 'selected' : ''}>${code.codeNm}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">노출상태</label>
                    <select name="displayStatus" class="form-select">
                        <option value="">선택</option>
                        <c:forEach var="code" items="${displayStatusCodes}">
                            <option value="${code.code}" ${code.code eq bundle.displayStatus ? 'selected' : ''}>${code.codeNm}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="row">
                    <div class="col-6 mb-3">
                        <label class="form-label">판매시작일</label>
                        <input type="date" name="saleStartDate" value="${bundle.saleStartDate}" class="form-control" />
                    </div>
                    <div class="col-6 mb-3">
                        <label class="form-label">판매종료일</label>
                        <input type="date" name="saleEndDate" value="${bundle.saleEndDate}" class="form-control" />
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">총판매수</label>
                    <input type="number" name="totalSalesQty" value="${bundle.totalSalesQty}" class="form-control" />
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-between mt-3">
            <div>
                <a href="<c:url value='/admin/product/bundleList.do'/>" class="btn btn-outline-secondary">목록</a>
            </div>
            <div>
                <button type="submit" class="btn btn-primary" ${mode eq 'view' ? 'disabled' : ''}>저장</button>
            </div>
        </div>
    </form>
</div>

<c:if test="${mode eq 'view'}">
    <script>
        (function() {
            const inputs = document.querySelectorAll('#bundleForm input, #bundleForm select, #bundleForm textarea');
            inputs.forEach(function(el) {
                el.setAttribute('disabled', 'disabled');
            });
        })();
    </script>
</c:if>
