<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
  /**
  * @Class Name : dataValidator.jsp
  * @Description : 데이터 정합성 검증 화면
  * @Modification Information
  *
  *   수정일         수정자                   수정내용
  *  -------    --------    ---------------------------
  *  2023.10.26  루미          최초 생성
  *
  *  @author 루미
  *  @since 2023.10.26
  *  @version 1.0
  *
  */
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>데이터 정합성 검증</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>">
<script src="<c:url value='/js/egovframework/com/cmm/jquery.js'/>"></script>
<script src="<c:url value='/js/egovframework/com/cmm/jquery-ui.js'/>"></script>
<link rel="stylesheet" href="<c:url value='/css/egovframework/com/cmm/jquery-ui.css'/>">

<script type="text/javaScript" language="javascript" defer="defer">
<!--
/*
 * 페이징 처리 함수
 */
function fn_egov_link_page(pageNo){
    document.searchVO.pageIndex.value = pageNo;
    document.searchVO.submit();
}

/*
 * 검증 실행 함수
 */
function fn_validate(){
    var startDate = document.searchVO.searchStartDate.value;
    var endDate = document.searchVO.searchEndDate.value;

    if (startDate === "" || endDate === "") {
        alert("검증 기간을 입력해주세요.");
        return;
    }
    
    if (startDate > endDate) {
        alert("시작일은 종료일보다 이전 날짜여야 합니다.");
        return;
    }

    document.searchVO.pageIndex.value = 1; // 검색 시에는 항상 첫 페이지로 이동
    document.searchVO.submit();
}

$(function() {
    // jQuery UI Datepicker를 적용해서 달력으로 날짜를 쉽게 선택할 수 있게 합니다.
    $("#searchStartDate, #searchEndDate").datepicker({
        dateFormat: "yy-mm-dd",
        showOn: "button",
        buttonImage: "<c:url value='/images/egovframework/com/cmm/icon/bu_icon_carlendar.gif'/>",
        buttonImageOnly: true,
        buttonText: "달력"
    });

    // PM님, 사용자가 매번 날짜를 입력하는 건 번거롭죠.
    // 기본값으로 최근 한 달을 설정해두는 센스를 발휘해봤습니다.
    if ($("#searchStartDate").val() === "") {
        var today = new Date();
        var oneMonthAgo = new Date(today.getFullYear(), today.getMonth() - 1, today.getDate());
        
        var year = oneMonthAgo.getFullYear();
        var month = ("0" + (oneMonthAgo.getMonth() + 1)).slice(-2);
        var day = ("0" + oneMonthAgo.getDate()).slice(-2);
        
        $("#searchStartDate").val(year + "-" + month + "-" + day);
    }
    
    if ($("#searchEndDate").val() === "") {
        var today = new Date();
        var year = today.getFullYear();
        var month = ("0" + (today.getMonth() + 1)).slice(-2);
        var day = ("0" + today.getDate()).slice(-2);
        
        $("#searchEndDate").val(year + "-" + month + "-" + day);
    }
});
//-->
</script>
</head>

<body>

<form:form commandName="searchVO" id="searchVO" name="searchVO" method="post" action="/adm/validator/selectMismatchedOrderList.do">
    <form:hidden path="pageIndex" />

    <div id="content_pop">
        <!-- 타이틀 -->
        <div id="title">
            <ul>
                <li><img src="<c:url value='/images/egovframework/let/cmm/icon/tit_icon.gif'/>" alt="title icon"> <h1>데이터 정합성 검증</h1></li>
            </ul>
        </div>
        <!-- // 타이틀 -->

        <!-- 검색조건 -->
        <div id="search_box" class="box_type_1">
            <div class="search_title">검증 항목: 주문-주문항목 금액 일치 여부</div>
            <table class="search_table" border="0">
                <caption>검색조건</caption>
                <colgroup>
                    <col style="width: 15%;">
                    <col style="width: 85%;">
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">검증 기간</th>
                        <td>
                            <form:input path="searchStartDate" id="searchStartDate" cssClass="txa" maxlength="10" title="검색 시작일" /> ~
                            <form:input path="searchEndDate" id="searchEndDate" cssClass="txa" maxlength="10" title="검색 종료일" />
                            <span class="btn_blue_s"><a href="#LINK" onclick="fn_validate(); return false;">검증 실행</a></span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <!-- //검색조건 -->

        <!-- 결과 -->
        <div id="result_area">
            <%-- 초기 진입 시 안내 메시지 표시 --%>
            <c:if test="${not empty message}">
                <div class="result_message" style="text-align: center; padding: 20px;">
                    <c:out value="${message}"/>
                </div>
            </c:if>

            <%-- 검색 실행 후 결과 표시 --%>
            <c:if test="${empty message}">
                <div class="result_summary" style="margin-bottom: 10px;">
                    총 <strong><c:out value="${resultListTotCnt}"/></strong> 건의 불일치 데이터가 발견되었습니다.
                </div>

                <table class="list_table" summary="주문번호, 주문 테이블 금액, 주문항목 계산 금액을 포함하는 데이터 정합성 검증 결과 목록입니다.">
                    <caption>데이터 정합성 검증 결과</caption>
                    <colgroup>
                        <col style="width:10%;">
                        <col style="width:40%;">
                        <col style="width:25%;">
                        <col style="width:25%;">
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">번호</th>
                            <th scope="col">주문번호</th>
                            <th scope="col">주문 테이블 금액</th>
                            <th scope="col">주문항목 계산 금액</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${resultListTotCnt == 0}">
                            <tr>
                                <td colspan="4" class="lt_text_c">불일치 항목이 없습니다.</td>
                            </tr>
                        </c:if>
                        <c:forEach var="result" items="${resultList}" varStatus="status">
                            <tr>
                                <td class="lt_text_c"><c:out value="${resultListTotCnt - ((searchVO.pageIndex-1) * searchVO.pageSize) - status.index}"/></td>
                                <td class="lt_text_c"><c:out value="${result.orderId}"/></td>
                                <td class="lt_text_r"><fmt:formatNumber value="${result.orderTotalPrice}" pattern="#,##0" /> 원</td>
                                <td class="lt_text_r"><fmt:formatNumber value="${result.itemAmountSum}" pattern="#,##0" /> 원</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- 페이징 -->
                <c:if test="${resultListTotCnt > 0}">
                    <div id="paging" style="margin-top:10px;">
                        <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_egov_link_page" />
                    </div>
                </c:if>
                <!-- // 페이징 -->
            </c:if>
        </div>
        <!-- // 결과 -->
    </div>
</form:form>

</body>
</html>