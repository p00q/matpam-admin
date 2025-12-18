<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>상품 미리보기</title>
                <link rel="stylesheet" href="<c:url value='/css/bootstrap.min.css'/>" />
                <style>
                    body {
                        padding: 20px;
                        background-color: #f8f9fa;
                    }

                    .container {
                        background-color: #fff;
                        padding: 30px;
                        border-radius: 8px;
                        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                        max-width: 1000px;
                    }

                    .product-header {
                        border-bottom: 2px solid #333;
                        padding-bottom: 15px;
                        margin-bottom: 20px;
                    }

                    .product-title {
                        font-size: 24px;
                        font-weight: bold;
                    }

                    .product-price {
                        font-size: 20px;
                        color: #dc3545;
                        font-weight: bold;
                    }

                    .product-info-table th {
                        background-color: #f1f3f5;
                        width: 15%;
                    }

                    .product-images {
                        display: flex;
                        gap: 10px;
                        margin-bottom: 20px;
                        overflow-x: auto;
                    }

                    .product-images img {
                        width: 100px;
                        height: 100px;
                        object-fit: cover;
                        border: 1px solid #ddd;
                    }

                    .detail-content {
                        border-top: 1px solid #eee;
                        padding-top: 20px;
                        min-height: 300px;
                        font-size: 11px;
                        /* 요청사항 1: 글꼴 11 */
                    }
                </style>
            </head>

            <body>

                <div class="container">
                    <div class="product-header d-flex justify-content-between align-items-end">
                        <div>
                            <div class="badge bg-primary mb-2">${salesProduct.exposureStatusCd == 'Y' ? '판매중' : '판매중지'}
                            </div>
                            <div class="product-title">
                                <c:out value="${salesProduct.salesProdName}" />
                            </div>
                        </div>
                        <div class="product-price">
                            <fmt:formatNumber value="${salesProduct.listPrice}" type="number" />원
                        </div>
                    </div>

                    <!-- 이미지 미리보기 (임시) -->
                    <div class="product-images">
                        <c:forEach items="${salesProduct.imageList}" var="img">
                            <img src="<c:url value='${img.imgUrl}'/>" alt="상품이미지">
                        </c:forEach>
                        <c:if test="${empty salesProduct.imageList}">
                            <div class="text-muted p-3 border w-100 text-center">등록된 이미지가 없습니다.</div>
                        </c:if>
                    </div>

                    <table class="table table-bordered product-info-table">
                        <tr>
                            <th>상품요약</th>
                            <td colspan="3">
                                <c:out value="${salesProduct.summary}" />
                            </td>
                        </tr>
                        <tr>
                            <th>판매기간</th>
                            <td>
                                <fmt:formatDate value="${salesProduct.saleStartDt}" pattern="yyyy-MM-dd" /> ~
                                <fmt:formatDate value="${salesProduct.saleEndDt}" pattern="yyyy-MM-dd" />
                            </td>
                            <th>판매자</th>
                            <td>
                                <c:out value="${salesProduct.sellerName}" />
                            </td>
                        </tr>
                        <tr>
                            <th>원가</th>
                            <td>
                                <fmt:formatNumber value="${salesProduct.costPrice}" type="number" />원
                            </td>
                            <th>VAT</th>
                            <td>
                                <fmt:formatNumber value="${salesProduct.vatAmount}" type="number" />원
                            </td>
                        </tr>
                        <tr>
                            <th>MD 코멘트</th>
                            <td colspan="3">
                                <c:out value="${salesProduct.mdComment}" />
                            </td>
                        </tr>
                    </table>

                    <div class="section-title mt-4 mb-2">
                        <h4>상품 상세 설명</h4>
                    </div>
                    <div class="detail-content">
                        ${salesProduct.description}
                    </div>

                    <div class="text-center mt-5">
                        <button type="button" class="btn btn-secondary px-5" onclick="window.close()">닫기</button>
                    </div>
                </div>

            </body>

            </html>