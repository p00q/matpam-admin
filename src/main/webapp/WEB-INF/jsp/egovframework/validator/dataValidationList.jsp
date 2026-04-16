<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
  /**
  * @Class Name : dataValidationList.jsp
  * @Description : 데이터 정합성 검증 목록 화면
  * @Modification Information
  *
  *   수정일         수정자                   수정내용
  *  -------    --------    ---------------------------
  *  2023.10.23  강호          최초 생성
  *  2023.11.15  강호          Ajax 기능 추가 및 순번 로직 개선
  *  2023.11.16  루미          초기 페이지 번호 설정 안정화 (핫픽스)
  *
  *  @author 강호
  *  @since 2023.10.23
  *  @version 1.2
  *  @see
  *
  */
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>데이터 정합성 검증</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>"/>
<script src="<c:url value='/js/egovframework/com/cmm/jquery.js'/>"></script>
<script type="text/javaScript" language="javascript" defer="defer">
<!--
/*
 * 페이징 처리
 */
function fn_go_page(pageNo){
    $("#pageIndex").val(pageNo);
    fn_search();
}

/*
 * 검증 실행 (Ajax)
 */
function fn_search(){
    // 로딩 인디케이터 표시
    $("#resultArea").html("<div class='loading'>검증 중...</div>");

    var frm = document.searchForm;
    var params = $(frm).serialize();

    $.ajax({
        type: "POST",
        url: "<c:url value='/validator/selectDataValidationList.do'/>",
        data: params,
        success: function(resultHTML){
            $("#resultArea").html(resultHTML);
        },
        error: function(xhr, status, error) {
            alert("오류가 발생했습니다: " + error);
            $("#resultArea").html("<div class='error'>데이터를 불러오는 데 실패했습니다.</div>");
        }
    });
}
//-->
</script>
</head>

<body style="text-align:center; margin:0 auto; display:inline; padding-top:100px;">

    <div id="main_content">
        <h2>데이터 정합성 검증</h2>
        <br/>

        <form:form commandName="searchVO" id="searchForm" name="searchForm" method="post">
            <%-- [P1] 초기 페이지 번호 설정 안정화: 첫 조회는 항상 1페이지부터 시작하도록 보장 --%>
            <input type="hidden" id="pageIndex" name="pageIndex" value="1" />

            <div id="search_area">
                <%-- 검색 조건 UI (이번 작업 범위 아님) --%>
            </div>

            <div style="text-align: right;">
                <input type="button" value="검증 실행" onclick="fn_search(); return false;" class="btn" />
            </div>
        </form:form>

        <br/>
        <div id="resultArea">
            <%-- Ajax 결과가 이 영역에 표시됩니다. --%>
            <div style="text-align: center; padding: 20px; color: #888;">
                [검증 실행] 버튼을 클릭하여 데이터 정합성 검사를 시작하세요.
            </div>
        </div>
    </div>

</body>
</html>