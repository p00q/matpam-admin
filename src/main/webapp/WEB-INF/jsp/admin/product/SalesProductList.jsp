<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>

                <jsp:useBean id="today" class="java.util.Date" />

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
                            <li class="breadcrumb-item">판매상품관리</li>
                            <li class="breadcrumb-item active" aria-current="page">판매상품 목록</li>
                        </ol>
                    </nav>

                    <!-- Success/Error Messages -->
                    <c:if test="${not empty message}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i>${message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Search Filter Section -->
                    <div class="card mb-4 border-0 shadow-sm">
                        <div class="card-body p-0">
                            <form name="searchForm" id="searchForm"
                                action="<c:url value='/admin/product/salesProductList.do'/>" method="get">
                                <input type="hidden" name="pageIndex"
                                    value="<c:out value='${searchVO.pageIndex}' default='1'/>" />

                                <table class="table table-bordered mb-0 align-middle search-filter-table">
                                    <colgroup>
                                        <col style="width: 15%;">
                                        <col style="width: 35%;">
                                        <col style="width: 15%;">
                                        <col style="width: 35%;">
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th class="text-center" style="background-color: #e9ecef;">검색</th>
                                            <td>
                                                <div class="d-flex gap-2">
                                                    <select name="searchCondition" class="form-select form-select-sm"
                                                        style="width: 120px;">
                                                        <option value="salesProdName" <c:if
                                                            test="${searchVO.searchCondition eq 'salesProdName'}">
                                                            selected
                                                            </c:if>>상품명</option>
                                                        <option value="sellerName" <c:if
                                                            test="${searchVO.searchCondition eq 'sellerName'}">selected
                                                            </c:if>>업체명</option>
                                                    </select>
                                                    <input type="text" name="searchKeyword"
                                                        class="form-control form-control-sm" placeholder="검색어를 입력하세요"
                                                        value="${searchVO.searchKeyword}" style="max-width: 300px;" />
                                                </div>
                                            </td>
                                            <th class="text-center" style="background-color: #e9ecef;">등록일</th>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <input type="date" name="searchStartDate"
                                                        class="form-control form-control-sm"
                                                        value="${searchVO.searchStartDate}" style="max-width: 150px;" />
                                                    <span>~</span>
                                                    <input type="date" name="searchEndDate"
                                                        class="form-control form-control-sm"
                                                        value="${searchVO.searchEndDate}" style="max-width: 150px;" />
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="text-center" style="background-color: #e9ecef;">판매상태</th>
                                            <td>
                                                <!-- 판매상태코드(sale_status_cd) -->
                                                <select name="saleStatusCd" class="form-select form-select-sm"
                                                    style="max-width: 200px;">
                                                    <option value="">전체</option>
                                                    <option value="LIVE" <c:if
                                                        test="${searchVO.saleStatusCd eq 'LIVE'}">selected</c:if>>판매중
                                                    </option>
                                                    <option value="WAIT" <c:if
                                                        test="${searchVO.saleStatusCd eq 'WAIT'}">
                                                        selected</c:if>>판매예정</option>
                                                    <option value="STOP" <c:if
                                                        test="${searchVO.saleStatusCd eq 'STOP'}">
                                                        selected</c:if>>판매종료</option>
                                                </select>
                                            </td>
                                            <th class="text-center" style="background-color: #e9ecef;">노출상태</th>
                                            <td>
                                                <select name="exposureStatusCd" class="form-select form-select-sm"
                                                    style="max-width: 200px;">
                                                    <option value="">전체</option>
                                                    <option value="Y" <c:if test="${searchVO.exposureStatusCd eq 'Y'}">
                                                        selected
                                                        </c:if>>노출</option>
                                                    <option value="N" <c:if test="${searchVO.exposureStatusCd eq 'N'}">
                                                        selected
                                                        </c:if>>비노출</option>
                                                </select>
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
                            <fmt:formatNumber value="${paginationInfo.totalRecordCount}" type="number" />건
                        </div>
                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-success btn-sm"
                                onclick="location.href='<c:url value='/admin/product/salesProductRegister.do'/>'">
                                <i class="bi bi-plus-circle me-1"></i>신규등록
                            </button>
                            <button type="button" class="btn btn-secondary btn-sm">
                                <i class="bi bi-file-earmark-excel me-1"></i>엑셀 다운로드
                            </button>
                        </div>
                    </div>

                    <!-- 목록 테이블 -->
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover text-center align-middle bg-white">
                            <thead class="table-light">
                                <tr>
                                    <th scope="col" style="width: 8%;">상품번호</th>
                                    <th scope="col" style="width: 30%;">상품명</th>
                                    <th scope="col" style="width: 12%;">판매가격</th>
                                    <th scope="col" style="width: 8%;">조회수</th>
                                    <th scope="col" style="width: 8%;">주문수</th>
                                    <th scope="col" style="width: 12%;">등록일</th>
                                    <th scope="col" style="width: 10%;">판매상태</th>
                                    <th scope="col" style="width: 12%;">노출상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${salesProductList}" varStatus="status">
                                    <tr>
                                        <td>
                                            <c:out value="${item.salesProdCode}" />
                                        </td>
                                        <td class="text-start">
                                            <a href="<c:url value='/admin/product/salesProductRegister.do?salesProdId=${item.salesProdId}'/>"
                                                class="text-decoration-none text-primary fw-bold">
                                                ${item.salesProdName}
                                            </a>
                                        </td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${item.listPrice}" type="number" />원
                                        </td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${item.viewCnt == null ? 0 : item.viewCnt}" type="number" />
                                        </td>
                                        <td>0</td>
                                        <td>
                                            <fmt:formatDate value="${item.regDt}" pattern="yyyy-MM-dd" />
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when
                                                    test="${not empty item.saleStartDt && item.saleStartDt.time > today.time}">
                                                    <span class="badge bg-info">판매예정</span>
                                                </c:when>
                                                <c:when
                                                    test="${not empty item.saleEndDt && item.saleEndDt.time < today.time}">
                                                    <span class="badge bg-secondary">판매종료</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success">판매중</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.exposureStatusCd eq 'Y'}">
                                                    <span class="badge bg-primary">노출</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">비노출</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty salesProductList}">
                                    <tr>
                                        <td colspan="8" class="py-4 text-center text-muted">
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
                </div>

                <script>
                    function fn_page(pageNo) {
                        document.getElementById("searchForm").pageIndex.value = pageNo;
                        document.getElementById("searchForm").submit();
                    }

                    function fn_reset() {
                        location.href = '<c:url value="/admin/product/salesProductList.do"/>';
                    }
                </script>