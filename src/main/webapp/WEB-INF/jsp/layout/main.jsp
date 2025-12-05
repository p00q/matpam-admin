<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>맛팜 관리자</title>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
            <style>
                body {
                    margin: 0;
                    padding: 0;
                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
                }

                /* Header Navigation */
                .main-header {
                    background: linear-gradient(135deg, #2c5f7c 0%, #3a7ca5 100%);
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                }

                .main-nav {
                    display: flex;
                    list-style: none;
                    margin: 0;
                    padding: 0;
                }

                .main-nav li {
                    margin: 0;
                }

                .main-nav a {
                    display: block;
                    padding: 1rem 1.5rem;
                    color: rgba(255, 255, 255, 0.9);
                    text-decoration: none;
                    font-weight: 500;
                    font-size: 0.95rem;
                    transition: all 0.3s ease;
                    border-bottom: 3px solid transparent;
                }

                .main-nav a:hover {
                    background-color: rgba(255, 255, 255, 0.1);
                    color: white;
                }

                .main-nav a.active {
                    background-color: rgba(255, 255, 255, 0.15);
                    color: white;
                    border-bottom-color: #ffc107;
                }

                .main-nav i {
                    margin-right: 0.5rem;
                }

                /* Content Area */
                .main-content {
                    min-height: calc(100vh - 60px);
                    background-color: #f8f9fa;
                }

                /* Breadcrumb */
                .breadcrumb-section {
                    background-color: white;
                    padding: 1rem 0;
                    border-bottom: 1px solid #e9ecef;
                }

                .breadcrumb {
                    margin-bottom: 0;
                    background-color: transparent;
                }

                .breadcrumb-item.active {
                    color: #2c5f7c;
                    font-weight: 600;
                }
            </style>
        </head>

        <body>
            <!-- Main Header with Tab Navigation -->
            <header class="main-header">
                <nav>
                    <ul class="main-nav">
                        <li>
                            <a href="<c:url value='/admin/member/memberList.do'/>"
                                class="${param.menu eq 'member' ? 'active' : ''}">
                                <i class="bi bi-people-fill"></i>회원관리
                            </a>
                        </li>
                        <li>
                            <a href="<c:url value='/admin/order/orderList.do'/>"
                                class="${param.menu eq 'order' ? 'active' : ''}">
                                <i class="bi bi-cart-fill"></i>주문관리
                            </a>
                        </li>
                        <li>
                            <a href="<c:url value='/admin/product/productList.do'/>"
                                class="${param.menu eq 'product' ? 'active' : ''}">
                                <i class="bi bi-box-seam-fill"></i>판매상품관리
                            </a>
                        </li>
                        <li>
                            <a href="<c:url value='/admin/product/bundleProductList.do?menu=bundle'/>"
                                class="${param.menu eq 'bundle' ? 'active' : ''}">
                                <i class="bi bi-gear-fill"></i>구성상품관리
                            </a>
                        </li>
                        <li>
                            <a href="<c:url value='/admin/settlement/settlementList.do'/>"
                                class="${param.menu eq 'settlement' ? 'active' : ''}">
                                <i class="bi bi-currency-exchange"></i>교환/정산/보상
                            </a>
                        </li>
                        <li>
                            <a href="<c:url value='/admin/basic/basicList.do'/>"
                                class="${param.menu eq 'basic' ? 'active' : ''}">
                                <i class="bi bi-file-earmark-text-fill"></i>기본정보관리
                            </a>
                        </li>
                    </ul>
                </nav>
            </header>

            <!-- Main Content Area -->
            <main class="main-content">
                <jsp:include page="${contentPage}" />
            </main>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>