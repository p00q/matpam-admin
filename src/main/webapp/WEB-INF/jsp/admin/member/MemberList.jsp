<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
                            <li class="breadcrumb-item active" aria-current="page">회원관리</li>
                        </ol>
                    </nav>

                    <!-- Search Filter Section -->
                    <div class="card mb-4 border-0 shadow-sm">
                        <div class="card-body p-0">
                            <form name="searchForm" action="<c:url value='/admin/member/memberList.do'/>" method="get">
                                <input type="hidden" name="menu" value="member" />
                                <table class="table table-bordered mb-0 align-middle search-filter-table">
                                    <colgroup>
                                        <col style="width: 15%;">
                                        <col style="width: 35%;">
                                        <col style="width: 15%;">
                                        <col style="width: 35%;">
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th class="text-center" style="background-color: #e9ecef;">가입상태</th>
                                            <td>
                                                <select name="status" class="form-select form-select-sm"
                                                    style="max-width: 200px;">
                                                    <option value="">전체</option>
                                                    <c:forEach var="st" items="${statusCodes}">
                                                        <option value="${st.detailCode}" <c:if
                                                            test="${searchVO.status eq st.detailCode}">
                                                            selected="selected"
                                                            </c:if>>
                                                            ${st.detailCodeName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <th class="text-center" style="background-color: #e9ecef;">가입일</th>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <input type="date" name="joinDateFrom"
                                                        class="form-control form-control-sm"
                                                        value="${searchVO.joinDateFrom}" style="max-width: 150px;" />
                                                    <span>~</span>
                                                    <input type="date" name="joinDateTo"
                                                        class="form-control form-control-sm"
                                                        value="${searchVO.joinDateTo}" style="max-width: 150px;" />
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="text-center" style="background-color: #e9ecef;">지역</th>
                                            <td>
                                                <select name="region" class="form-select form-select-sm"
                                                    style="max-width: 200px;">
                                                    <option value="">전체</option>
                                                    <option value="SEOUL" <c:if test="${searchVO.region eq 'SEOUL'}">
                                                        selected</c:if>>서울</option>
                                                    <option value="GYEONGGI" <c:if
                                                        test="${searchVO.region eq 'GYEONGGI'}">selected</c:if>>경기
                                                    </option>
                                                    <option value="INCHEON" <c:if
                                                        test="${searchVO.region eq 'INCHEON'}">selected</c:if>>인천
                                                    </option>
                                                    <option value="GANGWON" <c:if
                                                        test="${searchVO.region eq 'GANGWON'}">selected</c:if>>강원
                                                    </option>
                                                </select>
                                            </td>
                                            <th class="text-center" style="background-color: #e9ecef;">회원등급</th>
                                            <td>
                                                <select name="memberGrade" class="form-select form-select-sm"
                                                    style="max-width: 200px;">
                                                    <option value="">전체</option>
                                                    <c:forEach var="grade" items="${memberGrades}">
                                                        <option value="${grade.detailCode}" <c:if
                                                            test="${searchVO.memberGrade eq grade.detailCode}">
                                                            selected="selected"
                                                            </c:if>>
                                                            ${grade.detailCodeName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="text-center" style="background-color: #e9ecef;">검색</th>
                                            <td colspan="3">
                                                <div class="d-flex gap-2">
                                                    <select name="searchCondition" class="form-select form-select-sm"
                                                        style="width: 120px;">
                                                        <option value="companyName" <c:if
                                                            test="${searchVO.searchCondition eq 'companyName'}">selected
                                                            </c:if>>업체명</option>
                                                        <option value="memberId" <c:if
                                                            test="${searchVO.searchCondition eq 'memberId'}">selected
                                                            </c:if>>아이디</option>
                                                        <option value="ceoName" <c:if
                                                            test="${searchVO.searchCondition eq 'ceoName'}">selected
                                                            </c:if>>대표명</option>
                                                    </select>
                                                    <input type="text" name="searchKeyword"
                                                        class="form-control form-control-sm" placeholder="검색어를 입력하세요"
                                                        value="${searchVO.searchKeyword}" style="max-width: 400px;" />
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>

                                <div class="d-flex justify-content-center gap-2 mt-3 mb-3">
                                    <button type="submit" class="btn btn-primary btn-sm px-4"><i
                                            class="bi bi-search me-1"></i>검색</button>
                                    <button type="button" class="btn btn-secondary btn-sm px-4" onclick="fn_reset()"><i
                                            class="bi bi-arrow-counterclockwise me-1"></i>초기화</button>
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
                                onclick="location.href='<c:url value='/admin/member/memberRegisterForm.do?menu=member'/>'">
                                <i class="bi bi-plus-lg me-1"></i>신규등록
                            </button>
                            <button type="button" class="btn btn-secondary btn-sm">
                                <i class="bi bi-file-earmark-excel me-1"></i>엑셀다운로드
                            </button>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-bordered table-hover text-center align-middle"
                            style="font-size: 0.9rem;">
                            <thead class="table-light">
                                <tr>
                                    <th scope="col">순번</th>
                                    <th scope="col">회원타입</th>
                                    <th scope="col">아이디</th>
                                    <th scope="col">연락처</th>
                                    <th scope="col">업체명</th>
                                    <th scope="col">사업자등록번호</th>
                                    <th scope="col">대표명</th>
                                    <th scope="col">담당자</th>
                                    <th scope="col">담당자연락처</th>
                                    <th scope="col">여신</th>
                                    <th scope="col">미트머니</th>
                                    <th scope="col">지역</th>
                                    <th scope="col">회원등급</th>
                                    <th scope="col">가입상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="member" items="${resultList}" varStatus="status">
                                    <tr>
                                        <td>
                                            <c:out
                                                value="${paginationInfo.totalRecordCount - ((searchVO.pageIndex-1) * searchVO.pageUnit + status.index)}" />
                                        </td>
                                        <td>${member.memberTypeName}</td>
                                        <td>
                                            <c:url var="memberViewUrl" value='/admin/member/memberDetail.do'>
                                                <c:param name='memberId' value='${member.memberId}' />
                                                <c:param name='menu' value='member' />
                                            </c:url>
                                            <a class="text-primary text-decoration-underline" href="${memberViewUrl}">
                                                ${member.memberId}</a>
                                        </td>
                                        <td>${member.contactNumber}</td>
                                        <td class="fw-bold">${member.companyName}</td>
                                        <td>${member.businessNumber}</td>
                                        <td>${member.ceoName}</td>
                                        <td>${member.managerName}</td>
                                        <td>${member.managerContact}</td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${member.creditLimit}" type="number" />원
                                        </td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${member.meatMoney}" type="number" />원
                                        </td>
                                        <td>${member.region}</td>
                                        <td>
                                            <span
                                                class="badge rounded-pill bg-secondary">${member.memberGradeName}</span>
                                        </td>
                                        <td>${member.statusName}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty resultList}">
                                    <tr>
                                        <td colspan="14" class="py-4 text-center text-muted">검색된 결과가 없습니다.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <div class="d-flex justify-content-center mt-4">
                        <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_page" />
                    </div>

                    <form name="pageForm" action="<c:url value='/admin/member/memberList.do'/>" method="get">
                        <input type="hidden" name="menu" value="member" />
                        <input type="hidden" name="pageIndex" value="${searchVO.pageIndex}" />
                        <input type="hidden" name="status" value="${searchVO.status}" />
                        <input type="hidden" name="region" value="${searchVO.region}" />
                        <input type="hidden" name="joinDateFrom" value="${searchVO.joinDateFrom}" />
                        <input type="hidden" name="joinDateTo" value="${searchVO.joinDateTo}" />
                        <input type="hidden" name="memberGrade" value="${searchVO.memberGrade}" />
                        <input type="hidden" name="searchCondition" value="${searchVO.searchCondition}" />
                        <input type="hidden" name="searchKeyword" value="${searchVO.searchKeyword}" />
                    </form>
                </div>

                <script>
                    function fn_reset() {
                        var form = document.searchForm;
                        form.status.value = "";
                        form.region.value = "";
                        form.joinDateFrom.value = "";
                        form.joinDateTo.value = "";
                        form.memberGrade.value = "";
                        form.searchCondition.value = "companyName";
                        form.searchKeyword.value = "";
                    }

                    function fn_page(pageNo) {
                        document.pageForm.pageIndex.value = pageNo;
                        document.pageForm.submit();
                    }
                </script>