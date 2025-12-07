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
                                            <th class="text-center" style="background-color: #e9ecef;">판매유형</th>
                                            <td>
                                                <select name="saleType" class="form-select form-select-sm"
                                                    style="max-width: 200px;">
                                                    <option value="">전체</option>
                                                    <c:forEach var="code" items="${saleTypes}">
                                                        <option value="${code.detailCode}" ${param.saleType eq
                                                            code.detailCode ? 'selected' : '' }>${code.detailCodeName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <th class="text-center" style="background-color: #e9ecef;">판매자명</th>
                                            <td>
                                                <input type="text" name="sellerName" value="${param.sellerName}"
                                                    class="form-control form-control-sm" style="max-width: 200px;" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="text-center" style="background-color: #e9ecef;">저장유형</th>
                                            <td>
                                                <select name="storageType" class="form-select form-select-sm"
                                                    style="max-width: 200px;">
                                                    <option value="">전체</option>
                                                    <c:forEach var="code" items="${storageTypes}">
                                                        <option value="${code.detailCode}" ${param.storageType eq
                                                            code.detailCode ? 'selected' : '' }>${code.detailCodeName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <th class="text-center" style="background-color: #e9ecef;">판매상태</th>
                                            <td>
                                                <select name="saleStatus" class="form-select form-select-sm"
                                                    style="max-width: 200px;">
                                                    <option value="">전체</option>
                                                    <c:forEach var="code" items="${saleStatuses}">
                                                        <option value="${code.detailCode}" ${param.saleStatus eq
                                                            code.detailCode ? 'selected' : '' }>${code.detailCodeName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="text-center" style="background-color: #e9ecef;">분리유형</th>
                                            <td>
                                                <select name="divisionType" class="form-select form-select-sm"
                                                    style="max-width: 200px;">
                                                    <option value="">전체</option>
                                                    <c:forEach var="code" items="${divisionTypes}">
                                                        <option value="${code.detailCode}" ${param.divisionType eq
                                                            code.detailCode ? 'selected' : '' }>${code.detailCodeName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <th class="text-center" style="background-color: #e9ecef;">노출상태</th>
                                            <td>
                                                <select name="displayYn" class="form-select form-select-sm"
                                                    style="max-width: 200px;">
                                                    <option value="">전체</option>
                                                    <option value="Y" ${param.displayYn eq 'Y' ? 'selected' : '' }>노출
                                                    </option>
                                                    <option value="N" ${param.displayYn eq 'N' ? 'selected' : '' }>비노출
                                                    </option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="text-center" style="background-color: #e9ecef;">처리유형</th>
                                            <td>
                                                <select name="processType" class="form-select form-select-sm"
                                                    style="max-width: 200px;">
                                                    <option value="">전체</option>
                                                    <c:forEach var="code" items="${processTypes}">
                                                        <option value="${code.detailCode}" ${param.processType eq
                                                            code.detailCode ? 'selected' : '' }>${code.detailCodeName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <th class="text-center" style="background-color: #e9ecef;">상품명</th>
                                            <td>
                                                <input type="text" name="productName" value="${param.productName}"
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
                                    <th scope="col">판매유형</th>
                                    <th scope="col">상품명</th>
                                    <th scope="col">업체명</th>
                                    <th scope="col">저장유형</th>
                                    <th scope="col">분리유형</th>
                                    <th scope="col">처리유형</th>
                                    <th scope="col">판매상태</th>
                                    <th scope="col">노출상태</th>
                                    <th scope="col">판매가격</th>
                                    <th scope="col">VAT</th>
                                    <th scope="col">총판매수</th>
                                    <th scope="col">판매시작일</th>
                                    <th scope="col">판매종료일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${bundleList}" varStatus="status">
                                    <tr>
                                        <td>${status.index + 1}</td>
                                        <td>${item.saleTypeName}</td>
                                        <td class="text-start">
                                            <c:url var="bundleViewUrl" value="/admin/product/bundleDetail.do">
                                                <c:param name="productNo" value="${item.bundleId}" />
                                            </c:url>
                                            <a href="${bundleViewUrl}">${item.productName}</a>
                                        </td>
                                        <td>${item.sellerName}</td>
                                        <td>${item.storageTypeName}</td>
                                        <td>${item.divisionTypeName}</td>
                                        <td>${item.processTypeName}</td>
                                        <td>${item.saleStatusName}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.displayYn eq 'Y'}">노출</c:when>
                                                <c:when test="${item.displayYn eq 'N'}">비노출</c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${item.salePrice}" type="number" />원
                                        </td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${item.vatAmount}" type="number" />원
                                        </td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${item.totalSalesQty}" type="number" />
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${item.saleStartDate}" pattern="yyyy-MM-dd" />
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${item.saleEndDate}" pattern="yyyy-MM-dd" />
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty bundleList}">
                                    <tr>
                                        <td colspan="14" class="py-4 text-center text-muted">
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
                        <input type="hidden" name="saleType" value="${param.saleType}" />
                        <input type="hidden" name="storageType" value="${param.storageType}" />
                        <input type="hidden" name="divisionType" value="${param.divisionType}" />
                        <input type="hidden" name="processType" value="${param.processType}" />
                        <input type="hidden" name="sellerName" value="${param.sellerName}" />
                        <input type="hidden" name="saleStatus" value="${param.saleStatus}" />
                        <input type="hidden" name="displayYn" value="${param.displayYn}" />
                        <input type="hidden" name="productName" value="${param.productName}" />
                    </form>
                </div>

                <script>
                    function fn_reset() {
                        var form = document.getElementById('searchForm');
                        form.saleType.value = "";
                        form.storageType.value = "";
                        form.divisionType.value = "";
                        form.processType.value = "";
                        form.sellerName.value = "";
                        form.saleStatus.value = "";
                        form.displayYn.value = "";
                        form.productName.value = "";
                    }

                    function fn_page(pageNo) {
                        document.pageForm.pageIndex.value = pageNo;
                        document.pageForm.submit();
                    }
                </script>