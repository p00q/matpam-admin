<%@ page contentType="text/html; charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>

                <style>
                    .search-filter-table th,
                    .search-filter-table td {
                        padding: 0.4rem 0.75rem !important;
                        vertical-align: middle;
                    }

                    .search-filter-table .form-select-sm,
                    .search-filter-table .form-control-sm {
                        padding: 0.25rem 0.5rem;
                        font-size: 0.875rem;
                        height: calc(1.5em + 0.5rem + 2px);
                    }
                </style>

                <div class="container-fluid p-4">
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><i class="bi bi-house-door-fill"></i></li>
                            <li class="breadcrumb-item active" aria-current="page">구성상품관리</li>
                        </ol>
                    </nav>

                    <!-- Search Filter Section -->
                    <div class="card mb-4 border-0 shadow-sm">
                        <div class="card-body p-0">
                            <form id="searchForm" method="get"
                                action="<c:url value='/admin/product/bundleProductList.do'/>">
                                <input type="hidden" name="menu" value="bundle" />
                                <table class="table table-bordered mb-0 align-middle search-filter-table">
                                    <colgroup>
                                        <col style="width: 15%;">
                                        <col style="width: 35%;">
                                        <col style="width: 15%;">
                                        <col style="width: 35%;">
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th class="text-center" style="background-color: #e9ecef;">판매구분</th>
                                            <td>
                                                <select name="saleDivCd" class="form-select form-select-sm"
                                                    style="max-width: 200px;">
                                                    <option value="">전체</option>
                                                    <c:forEach var="code" items="${saleTypes}">
                                                        <option value="${code.detailCode}" ${param.saleDivCd eq
                                                            code.detailCode ? 'selected' : '' }>${code.detailCodeName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <th class="text-center" style="background-color: #e9ecef;">판매자명</th>
                                            <td>
                                                <select name="saleMemberNo" class="form-select form-select-sm"
                                                    style="max-width: 200px;">
                                                    <option value="">전체</option>
                                                    <c:forEach var="item" items="${sellers}">
                                                        <option value="${item.memberNo}" ${param.saleMemberNo eq
                                                            item.memberNo ? 'selected' : '' }>${item.companyName}
                                                            (${item.ceoName})
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="text-center" style="background-color: #e9ecef;">저장유형</th>
                                            <td>
                                                <select name="storageTypeCd" class="form-select form-select-sm"
                                                    style="max-width: 200px;">
                                                    <option value="">전체</option>
                                                    <c:forEach var="code" items="${storageTypes}">
                                                        <option value="${code.detailCode}" ${param.storageTypeCd eq
                                                            code.detailCode ? 'selected' : '' }>${code.detailCodeName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <th class="text-center" style="background-color: #e9ecef;">처리구분</th>
                                            <td>
                                                <select name="processDivCd" class="form-select form-select-sm"
                                                    style="max-width: 200px;">
                                                    <option value="">전체</option>
                                                    <c:forEach var="code" items="${processTypes}">
                                                        <option value="${code.detailCode}" ${param.processDivCd eq
                                                            code.detailCode ? 'selected' : '' }>${code.detailCodeName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="text-center" style="background-color: #e9ecef;">재고단위</th>
                                            <td>
                                                <select name="stockUnitCd" class="form-select form-select-sm"
                                                    style="max-width: 200px;">
                                                    <option value="">전체</option>
                                                    <c:forEach var="code" items="${unitTypes}">
                                                        <option value="${code.detailCode}" ${param.stockUnitCd eq
                                                            code.detailCode ? 'selected' : '' }>${code.detailCodeName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <th class="text-center" style="background-color: #e9ecef;">구성상품코드</th>
                                            <td>
                                                <input type="text" name="componentGoodsCd" value="${param.componentGoodsCd}"
                                                    class="form-control form-control-sm" style="max-width: 200px;" />
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>

                                <div class="d-flex justify-content-center gap-2 mt-3 mb-3">
                                    <button type="submit" class="btn btn-primary btn-sm px-4">
                                        <i class="bi bi-search me-1"></i>검색
                                    </button>
                                    <button type="button" class="btn btn-secondary btn-sm px-4" onclick="fn_reset()">
                                        <i class="bi bi-arrow-counterclockwise me-1"></i>초기화
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Data Table Section -->
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <div class="fw-bold text-primary">TOTAL :
                            <c:choose>
                                <c:when test="${not empty paginationInfo}">
                                    <fmt:formatNumber value="${paginationInfo.totalRecordCount}" type="number" />건
                                </c:when>
                                <c:otherwise>0건</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="d-flex gap-2">
                            <a href="<c:url value='/admin/product/bundleRegist.do'/>" class="btn btn-success btn-sm">
                                <i class="bi bi-plus-lg me-1"></i>상품등록
                            </a>
                            <button type="button" class="btn btn-secondary btn-sm">
                                <i class="bi bi-file-earmark-excel me-1"></i>엑셀다운로드
                            </button>
                        </div>
                    </div>

                    <!-- 목록 테이블 -->
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover text-center align-middle"
                            style="font-size: 0.9rem;">
                            <thead class="table-light">
                                <tr>
                                    <th scope="col">순번</th>
                                    <th scope="col">구성상품코드</th>
                                    <th scope="col">상품코드</th>
                                    <th scope="col">판매자명</th>
                                    <th scope="col">저장유형</th>
                                    <th scope="col">처리구분</th>
                                    <th scope="col">재고단위</th>
                                    <th scope="col">판매구분</th>
                                    <th scope="col">기준수량</th>
                                    <th scope="col">구매단가</th>
                                    <th scope="col">VAT포함</th>
                                    <th scope="col">자동VAT계산</th>
                                    <th scope="col">등록일</th>
                                    <th scope="col">수정일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${bundleList}" varStatus="status">
                                    <tr>
                                        <td>${status.index + 1}</td>
                                        <td class="text-start">${item.componentGoodsCd}</td>
                                        <td class="text-start">
                                            <c:url var="bundleViewUrl" value="/admin/product/bundleDetail.do">
                                                <c:param name="productNo" value="${item.bundleId}" />
                                            </c:url>
                                            <a href="${bundleViewUrl}">${item.goodsCd}</a>
                                        </td>

                                        <td>${item.sellerName}</td>

                                        <td>${item.storageTypeName}</td>
                                        <td>${item.processDivName}</td>
                                        <td>${item.stockUnitName}</td>
                                        <td>${item.saleDivName}</td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${item.stdrQty}" type="number" />
                                        </td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${item.poHubPurcUnitCost}" type="number" />
                                        </td>
                                        <td>${item.poHubPurcVatIncldYn}</td>
                                        <td>${item.autoVatCalYn}</td>
                                        <td>
                                            <fmt:formatDate value="${item.regDt}" pattern="yyyy-MM-dd" />
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${item.updDt}" pattern="yyyy-MM-dd" />
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty bundleList}">
                                    <tr>
                                        <td colspan="12" class="py-4 text-center text-muted">
                                            검색된 결과가 없습니다.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${not empty paginationInfo}">
                        <div class="d-flex justify-content-center mt-4">
                            <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_page" />
                        </div>
                    </c:if>

                    <!-- 페이지 유지용 form -->
                    <form name="pageForm" id="pageForm" method="get"
                        action="<c:url value='/admin/product/bundleProductList.do'/>">
                        <input type="hidden" name="menu" value="bundle" />
                        <input type="hidden" name="pageIndex"
                            value="${not empty paginationInfo ? paginationInfo.currentPageNo : 1}" />
                        <input type="hidden" name="saleDivCd" value="${param.saleDivCd}" />
                        <input type="hidden" name="storageTypeCd" value="${param.storageTypeCd}" />
                        <input type="hidden" name="processDivCd" value="${param.processDivCd}" />
                        <input type="hidden" name="stockUnitCd" value="${param.stockUnitCd}" />
                        <input type="hidden" name="sellerName" value="${param.sellerName}" />
                        <input type="hidden" name="componentGoodsCd" value="${param.componentGoodsCd}" />
                    </form>
                </div>

                <script>
                    function fn_reset() {
                        var form = document.getElementById('searchForm');
                        form.saleDivCd.value = "";
                        form.storageTypeCd.value = "";
                        form.processDivCd.value = "";
                        form.stockUnitCd.value = "";
                        form.sellerName.value = "";
                        form.componentGoodsCd.value = "";
                    }

                    function fn_page(pageNo) {
                        document.pageForm.pageIndex.value = pageNo;
                        document.pageForm.submit();
                    }
                </script>