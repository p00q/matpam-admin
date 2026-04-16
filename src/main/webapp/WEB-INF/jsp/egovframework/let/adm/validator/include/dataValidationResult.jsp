<%--
  Class Name : dataValidationResult.jsp
  Description : 데이터 정합성 검증 결과 목록 (Ajax Fragment)
  Modification Information

      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2024.05.21  루미          최초 생성 (Ajax 결과 영역 분리)

    author   : 공통서비스 개발팀 루미
    since    : 2024.05.21
--%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 총 건수 -->
<div id="result_info">
    <span>총 <c:out value="${resultCnt}"/>건</span>
</div>
<!-- //총 건수 -->

<!-- 목록 -->
<div id="table">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" summary="번호, 주문ID, 주문일자, 주문금액, 결제금액, 차액 정보">
        <caption style="visibility:hidden">번호, 주문ID, 주문일자, 주문금액, 결제금액, 차액 정보</caption>
        <colgroup>
            <col width="8%">
            <col width="22%">
            <col width="20%">
            <col width="15%">
            <col width="15%">
            <col width="20%">
        </colgroup>
        <thead>
            <tr>
                <th scope="col">번호</th>
                <th scope="col">주문ID</th>
                <th scope="col">주문일자</th>
                <th scope="col">주문금액</th>
                <th scope="col">결제금액</th>
                <th scope="col">차액</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${fn:length(resultList) == 0}">
                <tr>
                    <td colspan="6" class="lt_text3">불일치 데이터가 없습니다.</td>
                </tr>
            </c:if>
            <c:forEach var="result" items="${resultList}" varStatus="status">
                <tr>
                    <%-- [오류 수정 핵심] paginationInfo 객체를 사용하여 정확한 순번 계산 --%>
                    <td><c:out value="${paginationInfo.totalRecordCount - ((paginationInfo.currentPageNo-1) * paginationInfo.recordCountPerPage) - status.index}"/></td>
                    <td class="lt_text3"><c:out value="${result.orderId}"/></td>
                    <td><c:out value="${result.orderDate}"/></td>
                    <td class="rt_text3"><c:out value="${result.orderAmount}"/></td>
                    <td class="rt_text3"><c:out value="${result.paymentAmount}"/></td>
                    <td class="rt_text3"><c:out value="${result.amountDiff}"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
<!-- //목록 -->

<!-- 페이징 -->
<div id="paging">
    <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_validate" />
</div>
<!-- //페이징 -->