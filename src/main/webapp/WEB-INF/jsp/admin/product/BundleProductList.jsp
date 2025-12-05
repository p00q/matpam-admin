<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid">

    <!-- 검색영역 -->
    <form id="searchForm" method="get" action="<c:url value='/admin/product/bundleList.do'/>">
        <div class="row mb-3">

            <!-- 왼쪽 (유형 ~ 처리유형) -->
            <div class="col-6">
                <table class="table table-sm align-middle">
                    <colgroup>
                        <col style="width: 120px;">
                        <col>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th class="bg-light text-center">유형</th>
                        <td>
                            <select name="type" class="form-select form-select-sm">
                                <option value="">전체</option>
                                <option value="RAW"   ${param.type eq 'RAW'   ? 'selected' : ''}>원물</option>
                                <option value="PROC"  ${param.type eq 'PROC'  ? 'selected' : ''}>가공</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th class="bg-light text-center">저장유형</th>
                        <td>
                            <select name="storageType" class="form-select form-select-sm">
                                <option value="">전체</option>
                                <option value="COLD">냉장</option>
                                <option value="FROZEN">냉동</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th class="bg-light text-center">분리유형</th>
                        <td>
                            <select name="divisionType" class="form-select form-select-sm">
                                <option value="">전체</option>
                                <!-- 필요 타입 추가 -->
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th class="bg-light text-center">처리유형</th>
                        <td>
                            <select name="processType" class="form-select form-select-sm">
                                <option value="">전체</option>
                                <!-- 필요 타입 추가 -->
                            </select>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <!-- 오른쪽 (판매자명 ~ 상품명) -->
            <div class="col-6">
                <table class="table table-sm align-middle">
                    <colgroup>
                        <col style="width: 120px;">
                        <col>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th class="bg-light text-center">판매자명</th>
                        <td>
                            <input type="text" name="sellerName" value="${param.sellerName}"
                                   class="form-control form-control-sm"/>
                        </td>
                    </tr>
                    <tr>
                        <th class="bg-light text-center">판매상태</th>
                        <td>
                            <select name="saleStatus" class="form-select form-select-sm">
                                <option value="">선택</option>
                                <option value="ON">판매중</option>
                                <option value="OFF">판매중지</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th class="bg-light text-center">노출상태</th>
                        <td>
                            <select name="displayStatus" class="form-select form-select-sm">
                                <option value="">선택</option>
                                <option value="Y">노출</option>
                                <option value="N">비노출</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th class="bg-light text-center">상품명</th>
                        <td>
                            <input type="text" name="productName" value="${param.productName}"
                                   class="form-control form-control-sm"/>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <!-- 검색 / 초기화 버튼 -->
            <div class="col-12 text-center mb-2">
                <button type="submit" class="btn btn-secondary btn-sm px-4">검색</button>
                <button type="button" class="btn btn-outline-secondary btn-sm px-4"
                        onclick="location.href='<c:url value='/admin/product/bundleList.do'/>'">
                    초기화
                </button>
            </div>
        </div>
    </form>

    <!-- 상단 TOTAL / 페이지 사이즈 / 상품등록 -->
    <div class="d-flex justify-content-between align-items-center mb-2">
        <div>
            TOTAL : <strong>${paginationInfo.totalRecordCount}</strong>건
            &nbsp;&nbsp;
            <select name="pageUnit" class="form-select form-select-sm d-inline-block w-auto"
                    onchange="document.getElementById('pageForm').submit();">
                <option value="20" ${paginationInfo.recordCountPerPage == 20 ? 'selected' : ''}>20개씩 보기</option>
                <option value="50" ${paginationInfo.recordCountPerPage == 50 ? 'selected' : ''}>50개씩 보기</option>
            </select>
        </div>
        <div>
            <a href="<c:url value='/admin/product/bundleRegist.do'/>"
               class="btn btn-secondary btn-sm px-4">상품등록</a>
        </div>
    </div>

    <!-- 목록 테이블 -->
    <div class="table-responsive">
        <table class="table table-bordered table-hover text-center align-middle">
            <thead class="table-light">
            <tr>
                <th>순번</th>
                <th>판매유형</th>
                <th>상품명</th>
                <th>업체명</th>
                <th>저장유형</th>
                <th>분리유형</th>
                <th>처리유형</th>
                <th>판매상태</th>
                <th>노출상태</th>
                <th>판매가격</th>
                <th>VAT</th>
                <th>총판매수</th>
                <th>판매시작일</th>
                <th>판매종료일</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${bundleList}" varStatus="status">
                <tr>
                    <td>${status.index + 1}</td>
                    <td>${item.saleTypeName}</td>
                    <td class="text-start">
                        <a href="<c:url value='/admin/product/bundleView.do'>
                                   <c:param name='bundleId' value='${item.bundleId}'/>
                                 </c:url>">
                            ${item.productName}
                        </a>
                    </td>
                    <td>${item.companyName}</td>
                    <td>${item.storageTypeName}</td>
                    <td>${item.divisionTypeName}</td>
                    <td>${item.processTypeName}</td>
                    <td>${item.saleStatusName}</td>
                    <td>${item.displayStatusName}</td>
                    <td class="text-end">
                        <fmt:formatNumber value="${item.salePrice}" type="number"/>원
                    </td>
                    <td class="text-end">
                        <fmt:formatNumber value="${item.vatAmount}" type="number"/>원
                    </td>
                    <td class="text-end">
                        <fmt:formatNumber value="${item.totalSalesQty}" type="number"/>
                    </td>
                    <td><fmt:formatDate value="${item.saleStartDate}" pattern="yyyy-MM-dd"/></td>
                    <td><fmt:formatDate value="${item.saleEndDate}"   pattern="yyyy-MM-dd"/></td>
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

    <!-- 페이징 -->
    <div class="d-flex justify-content-center mt-3">
        <jsp:include page="/WEB-INF/jsp/common/Pagination.jsp">
            <jsp:param name="paginationInfo" value="${paginationInfo}"/>
        </jsp:include>
    </div>

    <!-- 페이지 유지용 form -->
    <form id="pageForm" method="get" action="<c:url value='/admin/product/bundleList.do'/>">
        <input type="hidden" name="pageIndex" value="${paginationInfo.currentPageNo}"/>
        <input type="hidden" name="pageUnit"  value="${paginationInfo.recordCountPerPage}"/>
        <input type="hidden" name="type" value="${param.type}"/>
        <input type="hidden" name="storageType" value="${param.storageType}"/>
        <input type="hidden" name="divisionType" value="${param.divisionType}"/>
        <input type="hidden" name="processType" value="${param.processType}"/>
        <input type="hidden" name="sellerName" value="${param.sellerName}"/>
        <input type="hidden" name="saleStatus" value="${param.saleStatus}"/>
        <input type="hidden" name="displayStatus" value="${param.displayStatus}"/>
        <input type="hidden" name="productName" value="${param.productName}"/>
    </form>
</div>
