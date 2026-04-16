<%--
  Class Name : dataValidationList.jsp
  Description : 데이터 정합성 검증 목록 조회 화면
  Modification Information

      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2023.11.01  강호          최초 생성
     2024.05.21  루미          Form Submit -> Ajax 방식으로 변경, 결과 영역 분리

    author   : 공통서비스 개발팀
    since    : 2023.11.01
--%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>데이터 정합성 검증</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>">
<script src="<c:url value='/js/egovframework/com/cmm/jquery-1.12.4.min.js' />"></script>
<script type="text/javaScript" language="javascript" defer="defer">
<!--
/*
 * ******************************************************************************
 * Script
 * ******************************************************************************
 */

/**
 * 검증 실행 (Ajax)
 */
function fn_validate(pageNo) {
    if (!pageNo) {
        pageNo = 1;
    }
    $("#pageIndex").val(pageNo);
    var formData = $("#searchVO").serialize();

    $.ajax({
        type: "POST",
        url: "<c:url value='/adm/validator/selectMismatchedOrderList.do'/>",
        data: formData,
        beforeSend: function() {
            // 로딩 인디케이터 표시
            $("#result_area").html("<div style='text-align:center; padding:20px;'><p>검증을 실행 중입니다. 잠시만 기다려주세요...</p></div>");
        },
        success: function(resultHtml) {
            // 결과 영역을 반환된 HTML로 교체
            $("#result_area").html(resultHtml);
        },
        error: function(xhr, status, error) {
            // 에러 처리
            alert("오류가 발생했습니다: " + error);
            $("#result_area").html("<div style='text-align:center; padding:20px; color:red;'><p>오류가 발생했습니다. 다시 시도해주세요.</p></div>");
        }
    });
}
//-->
</script>
</head>

<body>

<form:form modelAttribute="searchVO" id="searchVO" name="searchVO" method="post">
    <input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${searchVO.pageIndex}'/>"/>

    <div id="content_pop">
        <!-- 타이틀 -->
        <div id="title">
            <ul>
                <li><img src="<c:url value='/images/egovframework/com/cmm/icon/tit_icon.gif'/>" width="16" height="16" hspace="3" align="absmiddle" alt="제목 아이콘 이미지"> 데이터 정합성 검증</li>
            </ul>
        </div>
        <!-- // 타이틀 -->

        <!-- 검색조건 -->
        <div id="search">
            <ul>
                <li>
                    <label for="searchBgnDe">검증 기간 : </label>
                    <form:input path="searchBgnDe" size="10" maxlength="10" title="검색 시작일" /> ~
                    <form:input path="searchEndDe" size="10" maxlength="10" title="검색 종료일" />
                </li>
                <li>
                    <span class="btn_b"><a href="#LINK" onclick="fn_validate(1); return false;" title="검증 실행">검증 실행</a></span>
                </li>
            </ul>
        </div>
        <!-- //검색조건 -->

        <!-- 결과가 표시될 영역 -->
        <div id="result_area">
            <div style="text-align:center; padding:20px;">
                <p>검증 실행 버튼을 클릭하여 데이터 불일치 내역을 확인하세요.</p>
            </div>
        </div>
        <!-- //결과 표시 영역 -->

    </div>
</form:form>

</body>
</html>