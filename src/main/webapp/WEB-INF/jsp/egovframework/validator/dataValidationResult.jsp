<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
  /**
  * @Class Name : dataValidationResult.jsp
  * @Description : 데이터 정합성 검증 결과 표시 (Ajax 부분)
  * @Modification Information
  *
  *   수정일         수정자                   수정내용
  *  -------    --------    ---------------------------
  *  2023.11.15  강호          최초 생성 (Ajax 분리)
  *  2023.11.16  루미          egovMap 키 형식(snake_case)에 맞게 변수명 수정 (핫픽스)
  *
  *  @author 강호
  *  @since 2023.11.15
  *  @version 1.1
  *  @see
  *
  */
%>
<div id="result_table">
    <table class="board_list">
        <caption>데이터 정합성 검증 결과</caption>
        <colgroup>
            <col style="width:10%;" />
            <col style="width:20%;" />
            <col style="width:15%;" />
            <col style="width:15%;" />
            <col style="width:15%;" />
            <col style="width:auto;" />
        </colgroup>
        <thead>
            <tr>
                <th>순번</th>
                <th>주문ID</th>
                <th>주문일자</th>
                <th>주문금액</th>
                <th>결제금액</th>
                <th>차액</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${empty resultList}">
                <tr>
                    <td colspan="6">불일치 데이터가 없습니다.</td>
                </tr>
            </c:if>
            <c:forEach var="result" items="${resultList}" varStatus="status">
                <tr>
                    <%-- 순번은 쿼리에서 계산된 rnum을 사용 --%>
                    <td><c:out value="${result.rnum}"/></td>
                    <%-- [P0] 결과 데이터 표시 오류 수정: camelCase -> snake_case --%>
                    <td><c:out value="${result.order_id}"/></td>
                    <td><c:out value="${result.order_date}"/></td>
                    <td style="text-align: right;"><fmt:formatNumber value="${result.order_amount}" pattern="#,###" /></td>
                    <td style="text-align: right;"><fmt:formatNumber value="${result.payment_amount}" pattern="#,###" /></td>
                    <td style="text-align: right; color: red;"><fmt:formatNumber value="${result.amount_diff}" pattern="#,###" /></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<div id="pagination">
    <ui:pagination paginationInfo = "${paginationInfo}" type="image" jsFunction="fn_go_page" />
</div>