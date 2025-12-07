<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>

                <div class="container-fluid p-4">

                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><i class="bi bi-house-door-fill"></i></li>
                            <li class="breadcrumb-item">판매상품관리</li>
                            <li class="breadcrumb-item active" aria-current="page">판매상품 목록</li>
                        </ol>
                    </nav>

                    <h4>판매상품 목록</h4>

                    <!-- Search Filter -->
                    <div class="card p-4 mb-4 bg-light border-0">
                        <form name="searchForm" id="searchForm" method="post"
                            action="<c:url value='/admin/product/productList.do'/>">
                            <input type="hidden" name="pageIndex"
                                value="<c:out value='${searchVO.pageIndex}' default='1'/>" />

                            <div class="row g-3 align-items-center mb-2">
                                <div class="col-md-1 fw-bold bg-secondary text-white p-2 text-center">상품명</div>
                                <div class="col-md-5">
                                    <input type="text" class="form-control" name="searchKeyword"
                                        value="${searchVO.searchKeyword}" />
                                </div>
                                <div class="col-md-1 fw-bold bg-secondary text-white p-2 text-center">기간 조회</div>
                                <div class="col-md-5 d-flex gap-2">
                                    <input type="date" class="form-control" name="searchStartDate" />
                                    <input type="date" class="form-control" name="searchEndDate" />
                                </div>
                            </div>
                            <div class="row g-3 align-items-center">
                                <div class="col-md-1 fw-bold bg-secondary text-white p-2 text-center">판매상태</div>
                                <div class="col-md-5">
                                    <select class="form-select" name="saleStatus">
                                        <option value="">전체</option>
                                        <!-- Code Loop -->
                                    </select>
                                </div>
                                <div class="col-md-1 fw-bold bg-secondary text-white p-2 text-center">노출상태</div>
                                <div class="col-md-5">
                                    <select class="form-select" name="displayYn">
                                        <option value="">전체</option>
                                        <option value="Y" <c:if test="${searchVO.displayYn eq 'Y'}">selected</c:if>>노출
                                        </option>
                                        <option value="N" <c:if test="${searchVO.displayYn eq 'N'}">selected</c:if>>비노출
                                        </option>
                                    </select>
                                </div>
                            </div>

                            <div class="d-flex justify-content-center gap-2 mt-4">
                                <button type="submit" class="btn btn-secondary px-4">검색</button>
                                <button type="button" class="btn btn-secondary px-4"
                                    onclick="location.href='<c:url value='/admin/product/productList.do'/>'">초기화</button>
                            </div>
                        </form>
                    </div>

                    <div class="d-flex justify-content-end mb-2">
                        <button type="button" class="btn btn-secondary btn-sm">엑셀다운로드</button>
                    </div>

                    <div class="d-flex justify-content-between align-items-end mb-2 border-top pt-2"
                        style="border-top-color: orange !important; border-top-width: 2px !important;">
                        <div class="text-primary fw-bold">TOTAL :
                            <c:out value="${paginationInfo.totalRecordCount}" default="0" />건
                        </div>
                        <select class="form-select form-select-sm" style="width: auto;">
                            <option>20 개씩 보기</option>
                        </select>
                    </div>

                    <!-- 목록 테이블 -->
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover text-center align-middle"
                            style="font-size: 0.9rem;">
                            <thead class="table-light">
                                <tr>
                                    <th scope="col">상품번호</th>
                                    <th scope="col">서브카테고리</th>
                                    <th scope="col">상품명</th>
                                    <th scope="col">판매가격</th>
                                    <th scope="col">조회수</th>
                                    <th scope="col">주문수</th>
                                    <th scope="col">등록일</th>
                                    <th scope="col">판매상태</th>
                                    <th scope="col">노출상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${productList}" varStatus="status">
                                    <tr>
                                        <td>
                                            <c:out value="${item.productNo}" />
                                        </td>
                                        <td>-</td> <!-- 서브카테고리 데이터 없음 -->
                                        <td class="text-start">
                                            <a
                                                href="<c:url value='/admin/product/productRegist.do?productNo=${item.productNo}'/>">
                                                ${item.productName}
                                            </a>
                                        </td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${item.salePrice}" type="number" />
                                        </td>
                                        <td>0</td> <!-- 조회수 데이터 없음 -->
                                        <td>0</td> <!-- 주문수 데이터 없음 -->
                                        <td>
                                            <fmt:formatDate value="${item.regDt}" pattern="yyyy-MM-dd" />
                                        </td>
                                        <td>판매중</td> <!-- 판매상태 데이터 없음 -->
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.displayYn eq 'Y'}">노출</c:when>
                                                <c:otherwise>비노출</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty productList}">
                                    <tr>
                                        <td colspan="9" class="py-4 text-center text-muted">
                                            검색된 결과가 없습니다.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <div class="d-flex justify-content-end mt-3">
                        <a href="<c:url value='/admin/product/productRegist.do'/>" class="btn btn-secondary">신규등록</a>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${not empty paginationInfo}">
                        <div class="d-flex justify-content-center mt-4">
                            <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_page" />
                        </div>
                    </c:if>

                    <script>
                        function fn_page(pageNo) {
                            var form = document.getElementById("searchForm");
                            form.pageIndex.value = pageNo;
                            form.submit();
                        }
                    </script>
                </div>