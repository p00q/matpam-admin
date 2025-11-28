<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 목록</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
</head>
<body>
<div class="container mt-4">
    <h2 class="mb-4">회원 목록</h2>
    <form class="row gy-2 gx-3 align-items-center mb-3" action="<c:url value='/admin/member/memberList.do'/>" method="get">
        <div class="col-md-2">
            <label class="form-label">가입상태</label>
            <select name="status" class="form-select">
                <option value="">전체</option>
                <option value="ACTIVE" <c:if test="${searchVO.status eq 'ACTIVE'}">selected</c:if>>가입</option>
                <option value="PENDING" <c:if test="${searchVO.status eq 'PENDING'}">selected</c:if>>대기</option>
                <option value="INACTIVE" <c:if test="${searchVO.status eq 'INACTIVE'}">selected</c:if>>탈퇴</option>
            </select>
        </div>
        <div class="col-md-2">
            <label class="form-label">지역</label>
            <select name="region" class="form-select">
                <option value="">전체</option>
                <option value="SEOUL" <c:if test="${searchVO.region eq 'SEOUL'}">selected</c:if>>서울</option>
                <option value="BUSAN" <c:if test="${searchVO.region eq 'BUSAN'}">selected</c:if>>부산</option>
                <option value="DAEJEON" <c:if test="${searchVO.region eq 'DAEJEON'}">selected</c:if>>대전</option>
            </select>
        </div>
        <div class="col-md-3">
            <label class="form-label">가입일</label>
            <div class="input-group">
                <input type="date" name="joinDateFrom" class="form-control" value="${searchVO.joinDateFrom}"/>
                <span class="input-group-text">~</span>
                <input type="date" name="joinDateTo" class="form-control" value="${searchVO.joinDateTo}"/>
            </div>
        </div>
        <div class="col-md-2">
            <label class="form-label">회원등급</label>
            <select name="memberGrade" class="form-select">
                <option value="">전체</option>
                <option value="VIP" <c:if test="${searchVO.memberGrade eq 'VIP'}">selected</c:if>>VIP</option>
                <option value="GOLD" <c:if test="${searchVO.memberGrade eq 'GOLD'}">selected</c:if>>Gold</option>
                <option value="SILVER" <c:if test="${searchVO.memberGrade eq 'SILVER'}">selected</c:if>>Silver</option>
            </select>
        </div>
        <div class="col-md-3">
            <label class="form-label">검색</label>
            <div class="input-group">
                <select name="searchCondition" class="form-select">
                    <option value="memberId" <c:if test="${searchVO.searchCondition eq 'memberId'}">selected</c:if>>아이디</option>
                    <option value="companyName" <c:if test="${searchVO.searchCondition eq 'companyName'}">selected</c:if>>업체명</option>
                </select>
                <input type="text" name="searchKeyword" class="form-control" placeholder="검색어" value="${searchVO.searchKeyword}"/>
            </div>
        </div>
        <div class="col-12 text-end">
            <button type="submit" class="btn btn-primary">검색</button>
        </div>
    </form>

    <table class="table table-striped table-hover align-middle">
        <thead class="table-light">
        <tr>
            <th scope="col">회원타입</th>
            <th scope="col">지역</th>
            <th scope="col">아이디</th>
            <th scope="col">업체명</th>
            <th scope="col">사업자번호</th>
            <th scope="col">대표명</th>
            <th scope="col">연락처</th>
            <th scope="col">담당자</th>
            <th scope="col">담당자연락처</th>
            <th scope="col">여신</th>
            <th scope="col">미트머니</th>
            <th scope="col">회원등급</th>
            <th scope="col">가입상태</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="member" items="${resultList}">
            <tr>
                <td>${member.memberType}</td>
                <td>${member.region}</td>
                <td>${member.memberId}</td>
                <td>${member.companyName}</td>
                <td>${member.businessNumber}</td>
                <td>${member.ceoName}</td>
                <td>${member.contactNumber}</td>
                <td>${member.managerName}</td>
                <td>${member.managerContact}</td>
                <td class="text-end"><fmt:formatNumber value="${member.creditLimit}" type="number" groupingUsed="true"/></td>
                <td class="text-end"><fmt:formatNumber value="${member.meatMoney}" type="number" groupingUsed="true"/></td>
                <td>${member.memberGrade}</td>
                <td>
                    <span class="badge bg-<c:choose><c:when test='${member.status eq "ACTIVE"}'>success</c:when><c:when test='${member.status eq "PENDING"}'>warning text-dark</c:when><c:otherwise>secondary</c:otherwise></c:choose>">
                        ${member.status}
                    </span>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty resultList}">
            <tr>
                <td colspan="13" class="text-center">등록된 회원이 없습니다.</td>
            </tr>
        </c:if>
        </tbody>
    </table>

    <div class="d-flex justify-content-center">
        <ui:pagination paginationInfo="${paginationInfo}" type="bootstrap" jsFunction="fn_page"/>
    </div>

    <form name="pageForm" action="<c:url value='/admin/member/memberList.do'/>" method="get">
        <input type="hidden" name="pageIndex" value="${searchVO.pageIndex}"/>
        <input type="hidden" name="status" value="${searchVO.status}"/>
        <input type="hidden" name="region" value="${searchVO.region}"/>
        <input type="hidden" name="joinDateFrom" value="${searchVO.joinDateFrom}"/>
        <input type="hidden" name="joinDateTo" value="${searchVO.joinDateTo}"/>
        <input type="hidden" name="memberGrade" value="${searchVO.memberGrade}"/>
        <input type="hidden" name="searchCondition" value="${searchVO.searchCondition}"/>
        <input type="hidden" name="searchKeyword" value="${searchVO.searchKeyword}"/>
    </form>
</div>
<script type="text/javascript">
    function fn_page(pageNo) {
        document.pageForm.pageIndex.value = pageNo;
        document.pageForm.submit();
    }
</script>
</body>
</html>
