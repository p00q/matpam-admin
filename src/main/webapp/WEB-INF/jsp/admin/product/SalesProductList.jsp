<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>

                <jsp:useBean id="today" class="java.util.Date" />

<div class="animate-fade-in">
    <!-- Breadcrumb & Title -->
    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1" style="font-size: 0.85rem;">
                    <li class="breadcrumb-item text-muted">상품 관리</li>
                    <li class="breadcrumb-item active">판매상품 목록</li>
                </ol>
            </nav>
            <h3 class="fw-bold mb-0" style="letter-spacing: -1px; color: var(--primary);">판매상품 <span class="text-accent" style="color:var(--accent)">현황</span></h3>
        </div>
        <div>
            <button type="button" class="btn btn-primary btn-premium px-4 shadow-sm" onclick="fn_register()">
                <i class="bi bi-plus-lg me-2"></i>새로운 상품 등록
            </button>
        </div>
    </div>

    <!-- Success/Error Messages -->
    <c:if test="${not empty message}">
        <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
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
    <div class="premium-card mb-4">
        <form name="searchForm" id="searchForm" action="<c:url value='/admin/product/salesProductList.do'/>" method="get">
            <input type="hidden" name="pageIndex" value="<c:out value='${searchVO.pageIndex}' default='1'/>" />
            <input type="hidden" name="opType" value="<c:out value='${searchVO.opType}'/>" />
            
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label fw-bold small">검색어</label>
                    <div class="input-group">
                        <select name="searchCondition" class="form-select border-end-0" style="max-width: 100px;">
                            <option value="salesProdName" <c:if test="${searchVO.searchCondition eq 'salesProdName'}">selected</c:if>>상품명</option>
                            <option value="sellerName" <c:if test="${searchVO.searchCondition eq 'sellerName'}">selected</c:if>>업체명</option>
                        </select>
                        <input type="text" name="searchKeyword" class="form-control" placeholder="검색어를 입력하세요." value="${searchVO.searchKeyword}" />
                    </div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold small">등록일 기간</label>
                    <div class="d-flex align-items-center gap-2">
                        <input type="date" name="searchStartDate" class="form-control" value="${searchVO.searchStartDate}" />
                        <span class="text-muted">~</span>
                        <input type="date" name="searchEndDate" class="form-control" value="${searchVO.searchEndDate}" />
                    </div>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-bold small">판매 상태</label>
                    <select name="saleStatusCd" class="form-select">
                        <option value="">전체</option>
                        <option value="LIVE" <c:if test="${searchVO.saleStatusCd eq 'LIVE'}">selected</c:if>>판매중</option>
                        <option value="WAIT" <c:if test="${searchVO.saleStatusCd eq 'WAIT'}">selected</c:if>>판매예정</option>
                        <option value="STOP" <c:if test="${searchVO.saleStatusCd eq 'STOP'}">selected</c:if>>판매종료</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-bold small">노출 여부</label>
                    <select name="exposureStatusCd" class="form-select">
                        <option value="">전체</option>
                        <option value="Y" <c:if test="${searchVO.exposureStatusCd eq 'Y'}">selected</c:if>>노출</option>
                        <option value="N" <c:if test="${searchVO.exposureStatusCd eq 'N'}">selected</c:if>>비노출</option>
                    </select>
                </div>
            </div>

            <div class="d-flex justify-content-center gap-2 mt-4">
                <button type="button" class="btn btn-outline-secondary px-4 btn-premium" onclick="fn_reset()">
                    <i class="bi bi-arrow-counterclockwise me-1"></i>초기화
                </button>
                <button type="submit" class="btn btn-primary px-5 btn-premium">
                    <i class="bi bi-search me-2"></i>상품 검색
                </button>
            </div>
        </form>
    </div>

    <!-- Data Table Section -->
    <div class="premium-card">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h5 class="fw-bold mb-0"><i class="bi bi-table me-2 text-primary"></i>상품 목록</h5>
            <div class="text-muted small">
                검색 결과: <span class="text-primary fw-bold"><fmt:formatNumber value="${paginationInfo.totalRecordCount}" type="number" /></span> 건
            </div>
        </div>

        <div class="table-responsive">
            <table class="premium-table">
                <thead>
                    <tr>
                        <th style="width: 5%;">구분</th>
                        <th style="width: 8%;">상품번호</th>
                        <th style="width: 28%;">상품명</th>
                        <th style="width: 12%;">업체명</th>
                        <th class="text-end" style="width: 10%;">판매가격</th>
                        <th class="text-end" style="width: 7%;">조회수</th>
                        <th style="width: 10%;">등록일</th>
                        <th class="text-center" style="width: 10%;">판매상태</th>
                        <th class="text-center" style="width: 8%;">노출</th>
                        <th class="text-center" style="width: 5%;">관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${salesProductList}" varStatus="status">
                        <tr>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${item.opType eq 'NATIONAL'}">
                                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2">전국</span>
                                    </c:when>
                                    <c:when test="${item.opType eq 'LOCAL'}">
                                        <span class="badge bg-success-subtle text-success border border-success-subtle px-2">로컬</span>
                                    </c:when>
                                    <c:when test="${item.opType eq 'FACTORY'}">
                                        <span class="badge bg-warning-subtle text-warning border border-warning-subtle px-2">공장</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary-subtle text-secondary px-2">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="<c:url value='/admin/product/salesProductRegister.do?salesProdId=${item.salesProdId}'/>" class="text-decoration-none text-primary fw-bold">
                                    <c:out value="${item.salesProdCode}" />
                                </a>
                            </td>
                            <td class="text-start">
                                <div class="fw-semibold text-dark"><c:out value="${item.salesProdName}" /></div>
                                <div class="text-muted mini-text mt-1" style="font-size: 0.75rem;"><c:out value="${item.summary}" /></div>
                            </td>
                            <td>
                                <span class="text-muted"><c:out value="${item.sellerName}" /></span>
                            </td>
                            <td class="text-end fw-bold">
                                <fmt:formatNumber value="${item.listPrice}" type="number" /> <span class="small fw-normal">원</span>
                            </td>
                            <td class="text-end">
                                <fmt:formatNumber value="${item.viewCnt == null ? 0 : item.viewCnt}" type="number" />
                            </td>
                            <td>
                                <fmt:formatDate value="${item.regDt}" pattern="yyyy-MM-dd" />
                            </td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${not empty item.saleStartDt && item.saleStartDt.time > today.time}">
                                        <span class="badge rounded-pill bg-soft-info text-info border border-info">판매예정</span>
                                    </c:when>
                                    <c:when test="${not empty item.saleEndDt && item.saleEndDt.time < today.time}">
                                        <span class="badge rounded-pill bg-soft-secondary text-secondary border border-secondary">판매종료</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge rounded-pill bg-soft-success text-success border border-success">판매중</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${item.exposureStatusCd eq 'Y'}">
                                        <i class="bi bi-eye-fill text-primary" title="노출중"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-eye-slash text-danger" title="비노출"></i>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <button type="button" class="btn btn-outline-primary btn-sm p-1 px-2" onclick="fn_edit('${item.salesProdId}')">
                                    <i class="bi bi-pencil-square"></i>
                                </button>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty salesProductList}">
                        <tr>
                            <td colspan="9" class="py-5 text-center text-muted">
                                <i class="bi bi-search fs-2 d-block mb-3 opacity-25"></i>
                                검색된 결과가 없습니다.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <c:if test="${not empty paginationInfo}">
            <div class="mt-4 pb-2">
                <nav class="d-flex justify-content-center">
                    <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_page" />
                </nav>
            </div>
        </c:if>
    </div>
</div>

                <script>
                    function fn_page(pageNo) {
                        document.getElementById("searchForm").pageIndex.value = pageNo;
                        document.getElementById("searchForm").submit();
                    }

                    function fn_reset() {
                        location.href = '<c:url value="/admin/product/salesProductList.do"/>';
                    }

                    function fn_register() {
                        location.href = '<c:url value="/admin/product/salesProductRegister.do"/>';
                    }

                    function fn_edit(id) {
                        location.href = '<c:url value="/admin/product/salesProductRegister.do"/>?salesProdId=' + id;
                    }
                </script>