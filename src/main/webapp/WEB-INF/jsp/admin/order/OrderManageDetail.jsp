<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="animate-fade-in shadow-none">
    <!-- Breadcrumb & Title -->
    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1" style="font-size: 0.85rem;">
                    <li class="breadcrumb-item text-muted">주문 관리</li>
                    <li class="breadcrumb-item">주문 목록</li>
                    <li class="breadcrumb-item active">주문 상세</li>
                </ol>
            </nav>
            <h3 class="fw-bold mb-0" style="letter-spacing: -1px; color: var(--primary);">주문 <span class="text-accent" style="color:var(--accent)">상세 내역</span></h3>
        </div>
        <div class="gap-2 d-flex">
            <button type="button" class="btn btn-outline-secondary btn-premium px-4 shadow-sm" onclick="location.href='<c:url value='/admin/order/orderList.do'/>';">
                <i class="bi bi-list me-2"></i>목록으로
            </button>
            <button type="button" class="btn btn-primary btn-premium px-4 shadow-sm" onclick="fn_printInvoice()">
                <i class="bi bi-printer me-2"></i>거래명세서 출력
            </button>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <!-- 1. 주문 일반 정보 -->
        <div class="col-lg-7">
            <div class="premium-card h-100">
                <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-2">
                    <h5 class="fw-bold mb-0"><i class="bi bi-info-circle me-2 text-primary"></i>주문 기본 정보</h5>
                    <span class="badge rounded-pill bg-soft-primary text-primary px-3 border border-primary">${orderDetail.orderStatusName}</span>
                </div>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label text-muted mini-text mb-1">주문번호</label>
                        <div class="fw-bold fs-5 text-primary">${orderDetail.orderNo}</div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted mini-text mb-1">주문일시</label>
                        <div class="text-dark"><fmt:formatDate value="${orderDetail.orderDt}" pattern="yyyy-MM-dd HH:mm:ss" /></div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted mini-text mb-1">주문업체명</label>
                        <div class="fw-semibold">${orderDetail.buyerCompanyName}</div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted mini-text mb-1">총 결제금액 (VAT 포함)</label>
                        <div class="text-accent fs-5 fw-bold" style="color:var(--accent)">
                            <fmt:formatNumber value="${orderDetail.payTotalAmt}" pattern="#,###" /> <span class="small fw-normal">원</span>
                            <span class="text-muted mini-text ms-2 font-normal">(VAT <fmt:formatNumber value="${orderDetail.vatTotalAmt}" pattern="#,###" />원)</span>
                        </div>
                    </div>
                </div>
                <hr class="my-4 opacity-10">
                <div class="row g-2 text-center">
                    <div class="col-4 border-end">
                        <div class="text-muted mini-text mb-1">상품 합계</div>
                        <div class="fw-bold"><fmt:formatNumber value="${orderDetail.goodsTotalAmt}" pattern="#,###" />원</div>
                    </div>
                    <div class="col-4 border-end">
                        <div class="text-muted mini-text mb-1">배송비 합계</div>
                        <div class="fw-bold"><fmt:formatNumber value="${orderDetail.deliveryTotalAmt}" pattern="#,###" />원</div>
                    </div>
                    <div class="col-4">
                        <div class="text-muted mini-text mb-1">할인 합계</div>
                        <div class="fw-bold text-danger">-<fmt:formatNumber value="${orderDetail.discountTotalAmt}" pattern="#,###" />원</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 2. 배송 상태 및 처리 -->
        <div class="col-lg-5">
            <div class="premium-card h-100">
                <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-2">
                    <h5 class="fw-bold mb-0"><i class="bi bi-truck me-2 text-primary"></i>배송 정보 및 처리</h5>
                    <span class="badge rounded-pill bg-soft-info text-info px-3 border border-info">${orderDetail.deliveryStatusName}</span>
                </div>
                <form id="deliveryForm">
                    <input type="hidden" name="orderId" value="${orderDetail.orderId}" />
                    <div class="mb-3">
                        <label class="form-label text-muted mini-text mb-1">배송 방법</label>
                        <div class="d-flex gap-4">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="deliveryTypeCd" id="dt_parcel" value="PARCEL" ${orderDetail.deliveryTypeCd eq 'PARCEL' ? 'checked' : '' }>
                                <label class="form-check-label fw-semibold" for="dt_parcel" style="cursor:pointer;">택배 배송</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="deliveryTypeCd" id="dt_direct" value="DIRECT" ${orderDetail.deliveryTypeCd eq 'DIRECT' ? 'checked' : '' }>
                                <label class="form-check-label fw-semibold" for="dt_direct" style="cursor:pointer;">직접 배송</label>
                            </div>
                        </div>
                    </div>
                    <div class="row g-2">
                        <div class="col-md-5">
                            <label class="form-label text-muted mini-text mb-1">운송업체</label>
                            <select class="form-select" name="courierCd">
                                <option value="">업체 선택</option>
                                <option value="POST">우체국</option>
                                <option value="CJ">CJ대한통운</option>
                            </select>
                        </div>
                        <div class="col-md-7">
                            <label class="form-label text-muted mini-text mb-1">운송장 번호</label>
                            <input type="text" class="form-control" name="trackingNo" placeholder="번호를 입력하세요." value="${orderDetail.trackingNo}">
                        </div>
                    </div>
                    <div class="mt-4">
                        <label class="form-label text-muted mini-text mb-1">수령인 정보</label>
                        <div class="p-3 bg-light rounded shadow-inner" style="background-color: #f8f9fa !important; border: 1px inset #eee;">
                            <div class="fw-bold text-dark mb-1">기본 배송지</div>
                            <div class="small text-muted">[${orderDetail.receiverZipCode}] ${orderDetail.receiverAddr1} ${orderDetail.receiverAddr2}</div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 3. 주문 상세 품목 리스트 -->
    <div class="premium-card">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h5 class="fw-bold mb-0"><i class="bi bi-box-seam me-2 text-primary"></i>주문 상세 품목</h5>
            <div class="text-muted small">총 <span class="text-primary fw-bold">${fn:length(orderItemList)}</span>종의 상품</div>
        </div>

        <div class="table-responsive">
            <table class="premium-table">
                <thead>
                    <tr>
                        <th style="width: 45%;">상품명 및 구성 정보</th>
                        <th class="text-end" style="width: 10%;">단가</th>
                        <th class="text-center" style="width: 8%;">수량</th>
                        <th class="text-end" style="width: 10%;">공급가액</th>
                        <th class="text-end" style="width: 10%;">등급할인</th>
                        <th class="text-end" style="width: 8%;">배송비</th>
                        <th class="text-end" style="width: 12%;">최종 결제액 (VAT)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${orderItemList}">
                        <tr>
                            <td class="text-start">
                                <div class="d-flex align-items-center py-1">
                                    <div class="position-relative">
                                        <img src="${pageContext.request.contextPath}${item.salesProdMainImgPath}"
                                             class="rounded shadow-sm border" style="width: 50px; height: 50px; object-fit: cover;"
                                             onerror="this.src='${pageContext.request.contextPath}/resources/img/no-image.png'">
                                    </div>
                                    <div class="ms-3">
                                        <div class="fw-bold text-dark">${item.salesProdName}</div>
                                        <div class="mini-text text-muted mt-1">
                                            <i class="bi bi-info-circle mini-text me-1"></i>표준 규격 상품
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td class="text-end fw-semibold">
                                <fmt:formatNumber value="${item.salesPrice}" pattern="#,###" /> <span class="mini-text font-normal text-muted">원</span>
                            </td>
                            <td class="text-center fw-bold">
                                ${item.orderQty} <span class="mini-text font-normal text-muted">개</span>
                            </td>
                            <td class="text-end">
                                <fmt:formatNumber value="${item.supplyAmt}" pattern="#,###" /> <span class="mini-text text-muted">원</span>
                            </td>
                            <td class="text-end text-danger pt-2">
                                <div class="fw-semibold">-<fmt:formatNumber value="${item.itemDiscountAmt}" pattern="#,###" />원</div>
                                <div class="mini-text text-muted opacity-75">(회원등급 혜택)</div>
                            </td>
                            <td class="text-end text-info">
                                <fmt:formatNumber value="${item.itemDeliveryAmt}" pattern="#,###" />원
                            </td>
                            <td class="text-end">
                                <div class="fw-bold text-accent" style="color:var(--accent)"><fmt:formatNumber value="${item.totalAmt}" pattern="#,###" />원</div>
                                <div class="mini-text text-muted">(VAT <fmt:formatNumber value="${item.vatAmt}" pattern="#,###" />원)</div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
                <tfoot class="bg-soft-primary" style="background-color: rgba(10, 48, 91, 0.03) !important;">
                    <tr class="fw-bold">
                        <td class="text-center py-3">합 계</td>
                        <td class="text-end">-</td>
                        <td class="text-center">${orderDetail.totalOrderQty}</td>
                        <td class="text-end"><fmt:formatNumber value="${orderDetail.goodsTotalAmt}" pattern="#,###" />원</td>
                        <td class="text-end text-danger"><fmt:formatNumber value="${orderDetail.discountTotalAmt}" pattern="#,###" />원</td>
                        <td class="text-end text-info"><fmt:formatNumber value="${orderDetail.deliveryTotalAmt}" pattern="#,###" />원</td>
                        <td class="text-end text-accent fs-6" style="color:var(--accent)"><fmt:formatNumber value="${orderDetail.payTotalAmt}" pattern="#,###" />원</td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>

    <div class="d-flex justify-content-center gap-3 mt-4 mb-5">
        <button type="button" class="btn btn-outline-secondary btn-premium px-5" onclick="history.back();">취소 및 뒤로가기</button>
        <button type="button" class="btn btn-primary btn-premium px-5 shadow-sm" onclick="fn_save();">설정 저장하기</button>
    </div>
</div>

                <script>
                    function fn_save() {
                        const trackingNo = $('input[name="trackingNo"]').val();
                        if (!trackingNo) {
                            alert('운송장 번호를 입력해주세요.');
                            return;
                        }

                        if (!confirm('배송 정보와 주문 설정을 저장하시겠습니까?')) return;
                        
                        const formData = $('#deliveryForm').serialize();
                        $.ajax({
                            url: '<c:url value="/admin/logistics/saveShipment.ajax"/>',
                            type: 'POST',
                            data: formData,
                            success: function(res) {
                                if (res.success) {
                                    alert('배송 정보가 저장되었습니다.');
                                    location.reload();
                                } else {
                                    alert('저장 실패: ' + res.message);
                                }
                            },
                            error: function() {
                                alert('서버 통신 중 오류가 발생했습니다.');
                            }
                        });
                    }

                    function fn_printInvoice() {
                        alert('거래명세서 출력 모듈을 로딩 중입니다.');
                    }
                </script>