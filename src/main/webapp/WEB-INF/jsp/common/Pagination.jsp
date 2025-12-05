<%@ page contentType="text/html; charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <c:if test="${not empty paginationInfo}">
            <nav aria-label="Page navigation">
                <ul class="pagination mb-0">
                    <%-- 이전 페이지 그룹 --%>
                        <c:if test="${paginationInfo.currentPageNo > 1}">
                            <li class="page-item">
                                <a class="page-link"
                                    href="javascript:fn_egov_link_page(${paginationInfo.currentPageNo - 1});"
                                    aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>

                        <%-- 페이지 번호 --%>
                            <c:forEach var="i" begin="${paginationInfo.firstPageNoOnPageList}"
                                end="${paginationInfo.lastPageNoOnPageList}">
                                <c:choose>
                                    <c:when test="${i == paginationInfo.currentPageNo}">
                                        <li class="page-item active"><span class="page-link">${i}</span></li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="page-item"><a class="page-link"
                                                href="javascript:fn_egov_link_page(${i});">${i}</a></li>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <%-- 다음 페이지 그룹 --%>
                                <c:if test="${paginationInfo.currentPageNo < paginationInfo.totalPageCount}">
                                    <li class="page-item">
                                        <a class="page-link"
                                            href="javascript:fn_egov_link_page(${paginationInfo.currentPageNo + 1});"
                                            aria-label="Next">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                </c:if>
                </ul>
            </nav>
        </c:if>

        <script>
            function fn_egov_link_page(pageNo) {
                var form = document.getElementById('pageForm');
                if (form) {
                    var pageInput = form.querySelector('input[name="pageIndex"]');
                    if (pageInput) {
                        pageInput.value = pageNo;
                    }
                    form.submit();
                }
            }
        </script>