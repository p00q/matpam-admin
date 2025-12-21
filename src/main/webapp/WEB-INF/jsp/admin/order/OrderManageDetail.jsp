<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <style>
                    .detail-table th {
                        background-color: #f1f3f5;
                        width: 15%;
                        text-align: left;
                        padding-left: 15px;
                        font-weight: 600;
                        vertical-align: middle;
                    }

                    .detail-table td {
                        width: 35%;
                        vertical-align: middle;
                    }

                    .item-table th {
                        background-color: #f1f3f5;
                        text-align: center;
                        vertical-align: middle;
                        font-weight: 600;
                    }

                    .item-table td {
                        vertical-align: middle;
                    }

                    .product-img {
                        width: 60px;
                        height: 60px;
                        object-fit: cover;
                        border-radius: 4px;
                        border: 1px solid #dee2e6;
                    }

                    .summary-row {
                        background-color: #f8f9fa;
                        font-weight: bold;
                    }

                    .section-title {
                        font-size: 1rem;
                        font-weight: 700;
                        margin-top: 20px;
                        margin-bottom: 10px;
                        border-left: 4px solid #343a40;
                        padding-left: 10px;
                    }
                </style>

                <div class="container-fluid p-4">
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><i class="bi bi-house-door-fill"></i></li>
                            <li class="breadcrumb-item">주문상세</li>
                            <li class="breadcrumb-item active" aria-current="page">주문건별 상세</li>
                        </ol>
                    </nav>

                    <div class="d-flex justify-content-end mb-3 gap-2">
                        <button type="button" class="btn btn-secondary btn-sm"
                            onclick="location.href='<c:url value='/admin/order/orderList.do'/>'">목록</button>
                        <button type="button" class="btn btn-outline-secondary btn-sm">거래명세서출력</button>
                    </div>

                    <!-- Tabs -->
                    <ul class="nav nav-tabs mb-4">
                        <li class="nav-item">
                            <a class="nav-link active" href="#">주문건별</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">상품별</a>
                        </li>
                    </ul>

                    <!-- 1. 주문일반정보 -->
                    <div class="section-title">주문일반정보</div>
                    <table class="table table-bordered detail-table">
                        <tr>
                            <th>주문번호</th>
                            <td>${orderDetail.orderNo}</td>
                            <th>주문상태</th>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge bg-secondary">${orderDetail.orderStatusName}</span>
                                    <select class="form-select form-select-sm" style="width: auto;">
                                        <option value="${orderDetail.orderStatusCd}">${orderDetail.orderStatusName}
                                        </option>
                                        <!-- 상태 변경 로직 추가 가능 -->
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>주문업체명</th>
                            <td>${orderDetail.buyerCompanyName}</td>
                            <th>주문일</th>
                            <td>
                                <fmt:formatDate value="${orderDetail.orderDt}" pattern="yyyy-MM-dd HH:mm:ss" />
                            </td>
                        </tr>
                        <tr>
                            <th>총 주문금액</th>
                            <td>
                                <fmt:formatNumber value="${orderDetail.goodsTotalAmt}" pattern="#,###" />원
                            </td>
                            <th>총 배송비</th>
                            <td>
                                <fmt:formatNumber value="${orderDetail.deliveryTotalAmt}" pattern="#,###" />원
                            </td>
                        </tr>
                        <tr>
                            <th>총 할인금액</th>
                            <td>
                                <fmt:formatNumber value="${orderDetail.discountTotalAmt}" pattern="#,###" />원
                                <span class="text-muted text-small">(등급)</span>
                            </td>
                            <th>총 결제금액(VAT)</th>
                            <td>
                                <span class="fw-bold text-danger">
                                    <fmt:formatNumber value="${orderDetail.payTotalAmt}" pattern="#,###" />원
                                </span>
                                <span class="text-muted">(${orderDetail.vatTotalAmt}원)</span>
                            </td>
                        </tr>
                    </table>

                    <!-- 2. 배송정보 -->
                    <div class="section-title">배송정보</div>
                    <table class="table table-bordered detail-table">
                        <tr>
                            <th>배송지명</th>
                            <td>기본배송지</td> <!-- VO에 추가 필요하거나 고정? -->
                            <th>배송상태</th>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge bg-info text-dark">${orderDetail.deliveryStatusName}</span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>주소</th>
                            <td>[${orderDetail.receiverZipCode}] ${orderDetail.receiverAddr1}
                                ${orderDetail.receiverAddr2}</td>
                            <th>상세주소</th>
                            <td>${orderDetail.receiverAddr2}</td> <!-- 중복? -->
                        </tr>
                    </table>

                    <!-- 배송 폼 (수정 가능 영역) -->
                    <form id="deliveryForm">
                        <input type="hidden" name="orderId" value="${orderDetail.orderId}" />

                        <table class="table table-bordered detail-table mt-2" style="border-top: 2px solid #ced4da;">
                            <!-- 택배 / 직접배송 선택 -->
                            <tr>
                                <th>배송방법</th>
                                <td>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="deliveryTypeCd"
                                            id="dt_parcel" value="PARCEL" ${orderDetail.deliveryTypeCd eq 'PARCEL'
                                            ? 'checked' : '' }>
                                        <label class="form-check-label" for="dt_parcel">택배</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="deliveryTypeCd"
                                            id="dt_direct" value="DIRECT" ${orderDetail.deliveryTypeCd eq 'DIRECT'
                                            ? 'checked' : '' }>
                                        <label class="form-check-label" for="dt_direct">직접배송</label>
                                    </div>
                                </td>
                                <th>운송장 정보</th>
                                <td>
                                    <div class="d-flex gap-2">
                                        <select class="form-select form-select-sm" name="courierCd"
                                            style="width: 120px;">
                                            <option value="">택배사 선택</option>
                                            <!-- 공통코드 반복 -->
                                            <option value="POST">우체국</option>
                                            <option value="CJ">CJ대한통운</option>
                                        </select>
                                        <input type="text" class="form-control form-control-sm" name="trackingNo"
                                            placeholder="운송장번호" value="">
                                    </div>
                                </td>
                            </tr>
                            <!-- 화물/기사 정보 (조건부 표시 가능) -->
                            <tr id="freightRow" style="display:none;"> <!-- JS로 제어 필요 -->
                                <th>운전기사</th>
                                <td>
                                    <select class="form-select form-select-sm" name="driverId">
                                        <option value="">기사 선택</option>
                                        <!-- 드라이버 목록 -->
                                    </select>
                                </td>
                                <th>연락처</th>
                                <td><input type="text" class="form-control form-control-sm" name="driverMobile"
                                        readonly></td>
                            </tr>
                        </table>
                    </form>

                    <!-- 3. 주문상세정보 (아이템 리스트) -->
                    <div class="section-title">주문상세정보</div>
                    <div class="table-responsive">
                        <table class="table table-bordered item-table">
                            <thead>
                                <tr>
                                    <th style="width: 50%;">상품명 / 구성품목</th>
                                    <th style="width: 10%;">단가</th>
                                    <th style="width: 10%;">수량</th>
                                    <th style="width: 10%;">구매가</th>
                                    <th style="width: 10%;">등급할인</th>
                                    <th style="width: 10%;">배송비</th>
                                    <th style="width: 10%;">총결제금액(VAT)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${orderItemList}">
                                    <tr>
                                        <td class="text-start">
                                            <div class="d-flex align-items-center">
                                                <img src="${pageContext.request.contextPath}${item.salesProdMainImgPath}"
                                                    class="product-img me-3" onerror="this.src='/images/no-image.png'">
                                                <div>
                                                    <div class="fw-bold">${item.salesProdName}</div>
                                                    <div class="text-muted small mt-1">
                                                        <!-- 구성품목 예시 -->
                                                        - [구성] 상세 구성품 1<br>
                                                        - [구성] 상세 구성품 2
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${item.salesPrice}" pattern="#,###" />원
                                        </td>
                                        <td class="text-center">${item.orderQty}</td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${item.supplyAmt}" pattern="#,###" />원
                                        </td> <!-- 구매가 = 공급가? -->
                                        <td class="text-end">
                                            <fmt:formatNumber value="${item.itemDiscountAmt}" pattern="#,###" />원
                                        </td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${item.itemDeliveryAmt}" pattern="#,###" />원
                                        </td>
                                        <td class="text-end fw-bold">
                                            <div class="text-danger">
                                                <fmt:formatNumber value="${item.totalAmt}" pattern="#,###" />원
                                            </div>
                                            <div class="small text-muted">(
                                                <fmt:formatNumber value="${item.vatAmt}" pattern="#,###" />원)
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <!-- 합계 행 -->
                            <tfoot>
                                <tr class="summary-row">
                                    <td class="text-center">합계</td>
                                    <td class="text-end">-</td>
                                    <td class="text-center">${orderDetail.totalOrderQty}</td> <!-- 총 수량 -->
                                    <td class="text-end">
                                        <fmt:formatNumber value="${orderDetail.goodsTotalAmt}" pattern="#,###" />원
                                    </td>
                                    <td class="text-end">
                                        <fmt:formatNumber value="${orderDetail.discountTotalAmt}" pattern="#,###" />원
                                    </td>
                                    <td class="text-end">
                                        <fmt:formatNumber value="${orderDetail.deliveryTotalAmt}" pattern="#,###" />원
                                    </td>
                                    <td class="text-end text-danger">
                                        <fmt:formatNumber value="${orderDetail.payTotalAmt}" pattern="#,###" />원
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>

                    <div class="d-flex justify-content-center gap-2 mt-4">
                        <button type="button" class="btn btn-secondary px-4" onclick="history.back();">취소</button>
                        <button type="button" class="btn btn-primary px-4" onclick="fn_save();">확인</button>
                    </div>
                </div>

                <script>
                    function fn_save() {
                        if (!confirm('저장하시겠습니까?')) return;
                        // 저장 로직 (AJAX)
                        // const formData = $('#deliveryForm').serialize();
                        // $.ajax({...})
                        alert('저장 기능은 구현 중입니다.');
                    }
                </script>