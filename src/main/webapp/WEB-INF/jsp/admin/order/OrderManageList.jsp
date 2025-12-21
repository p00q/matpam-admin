<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <style>
                    /* 검색 필터 테이블 스타일 */
                    .search-filter-table {
                        table-layout: fixed;
                        width: 100%;
                    }

                    .search-filter-table th {
                        width: 140px;
                        background-color: #e9ecef;
                        text-align: center;
                        vertical-align: middle;
                        padding: 0.4rem 0.75rem !important;
                        white-space: nowrap;
                    }

                    .search-filter-table td {
                        vertical-align: middle;
                        padding: 0.4rem 0.75rem !important;
                    }

                    .search-filter-table .form-select-sm,
                    .search-filter-table .form-control-sm {
                        padding: 0.25rem 0.5rem;
                        font-size: 0.875rem;
                        height: calc(1.5em + 0.5rem + 2px);
                    }

                    /* KPI 요약 테이블 스타일 */
                    .summary-table {
                        table-layout: fixed;
                        width: 100%;
                    }

                    .summary-table th {
                        width: 120px;
                        background-color: #e9ecef;
                        text-align: center;
                        vertical-align: middle;
                        white-space: nowrap;
                        padding: 0.4rem 0.75rem;
                        font-weight: 600;
                    }

                    .summary-table td {
                        width: auto;
                        text-align: left;
                        vertical-align: middle;
                        white-space: nowrap;
                        padding: 0.4rem 0.75rem;
                    }

                    .btn-tracking {
                        padding: 0.2rem 0.5rem;
                        font-size: 0.75rem;
                    }
                </style>

                <div class="container-fluid p-4">
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><i class="bi bi-house-door-fill"></i></li>
                            <li class="breadcrumb-item">주문관리</li>
                            <li class="breadcrumb-item active" aria-current="page">주문건별 목록</li>
                        </ol>
                    </nav>

                    <!-- Success/Error Messages -->
                    <c:if test="${not empty message}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i>${message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Tabs (주문건별/상품별) -->
                    <ul class="nav nav-tabs mb-4" id="orderTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="order-tab" data-bs-toggle="tab"
                                data-bs-target="#orderByOrder" type="button" role="tab">주문건별</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="product-tab" data-bs-toggle="tab"
                                data-bs-target="#orderByProduct" type="button" role="tab">상품별</button>
                        </li>
                    </ul>

                    <!-- KPI Summary (Table Format) -->
                    <table class="table table-bordered mb-3 align-middle summary-table">
                        <colgroup>
                            <col style="width: 10%;">
                            <col style="width: 15%;">
                            <col style="width: 10%;">
                            <col style="width: 15%;">
                            <col style="width: 10%;">
                            <col style="width: 15%;">
                            <col style="width: 10%;">
                            <col style="width: 15%;">
                        </colgroup>
                        <tr>
                            <th>총 주문금액</th>
                            <td><span id="kpiGoodsAmt">0</span> 원</td>
                            <th>총 배송비</th>
                            <td><span id="kpiDeliveryAmt">0</span> 원</td>
                            <th>총 할인금액</th>
                            <td><span id="kpiDiscountAmt">0</span> 원</td>
                            <th>총 결제금액</th>
                            <td><span id="kpiPayAmt">0</span> 원</td>
                        </tr>
                    </table>

                    <!-- Search Filter Section -->
                    <div class="mb-3">
                        <form name="searchForm" id="searchForm">
                            <input type="hidden" name="pageIndex" id="pageIndex" value="1" />

                            <table class="table table-bordered mb-0 align-middle search-filter-table">
                                <colgroup>
                                    <col style="width: 15%;">
                                    <col style="width: 35%;">
                                    <col style="width: 15%;">
                                    <col style="width: 35%;">
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th>주문상태</th>
                                        <td>
                                            <select name="orderStatusCd" id="orderStatusCd"
                                                class="form-select form-select-sm" style="max-width: 180px;">
                                                <option value="">전체</option>
                                                <c:forEach var="code" items="${orderStatusList}">
                                                    <option value="${code.detailCodeId}">${code.detailCodeName}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <th>주문기간</th>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <input type="date" name="orderDtFrom" id="orderDtFrom"
                                                    class="form-control form-control-sm" style="max-width: 150px;" />
                                                <span>~</span>
                                                <input type="date" name="orderDtTo" id="orderDtTo"
                                                    class="form-control form-control-sm" style="max-width: 150px;" />
                                                <div class="form-check ms-3">
                                                    <input type="checkbox" class="form-check-input" id="todayOnlyYn"
                                                        onchange="fn_toggleTodayOnly()">
                                                    <label class="form-check-label" for="todayOnlyYn">금일주문건</label>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>배송방법</th>
                                        <td>
                                            <select name="deliveryTypeCd" id="deliveryTypeCd"
                                                class="form-select form-select-sm" style="max-width: 180px;">
                                                <option value="">전체</option>
                                                <c:forEach var="code" items="${deliveryTypeList}">
                                                    <option value="${code.detailCodeId}">${code.detailCodeName}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <th>검색</th>
                                        <td>
                                            <div class="d-flex gap-2">
                                                <select class="form-select form-select-sm" style="width: 100px;">
                                                    <option value="buyerCompanyName">업체명</option>
                                                </select>
                                                <input type="text" name="buyerCompanyName" id="buyerCompanyName"
                                                    class="form-control form-control-sm" placeholder="검색어를 입력하세요"
                                                    style="max-width: 300px;" />
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>

                            <div class="d-flex justify-content-center gap-2 mt-3 mb-3">
                                <button type="button" class="btn btn-primary btn-sm px-4" onclick="fn_search();">
                                    <i class="bi bi-search me-1"></i>검색
                                </button>
                                <button type="button" class="btn btn-secondary btn-sm px-4" onclick="fn_reset();">
                                    <i class="bi bi-arrow-counterclockwise me-1"></i>초기화
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Data Table Section -->
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <div class="d-flex align-items-center gap-2">
                            <span class="fw-bold text-primary">TOTAL : <span id="totalCount">0</span>건</span>
                            <span class="text-muted ms-3">선택된 주문</span>
                            <select id="batchStatusCd" class="form-select form-select-sm" style="width: 120px;">
                                <option value="">상태선택</option>
                                <c:forEach var="code" items="${orderStatusList}">
                                    <option value="${code.detailCodeId}">${code.detailCodeName}</option>
                                </c:forEach>
                            </select>
                            <button type="button" class="btn btn-warning btn-sm" onclick="fn_updateStatusBatch();">
                                <i class="bi bi-check2-circle me-1"></i>확인
                            </button>
                        </div>
                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="fn_printInvoice();">
                                <i class="bi bi-printer me-1"></i>거래명세서출력
                            </button>
                            <button type="button" class="btn btn-secondary btn-sm" onclick="fn_downloadExcel();">
                                <i class="bi bi-file-earmark-excel me-1"></i>엑셀다운로드
                            </button>
                        </div>
                    </div>

                    <!-- 목록 테이블 -->
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover text-center align-middle bg-white"
                            style="font-size: 0.9rem;">
                            <thead class="table-light">
                                <tr>
                                    <th scope="col" style="width: 3%;"><input type="checkbox" id="checkAll"
                                            onclick="fn_checkAll(this);"></th>
                                    <th scope="col" style="width: 4%;">순번</th>
                                    <th scope="col" style="width: 10%;">주문일시</th>
                                    <th scope="col" style="width: 8%;">주문번호</th>
                                    <th scope="col" style="width: 10%;">주문업체명</th>
                                    <th scope="col" style="width: 16%;">주문상품</th>
                                    <th scope="col" style="width: 8%;">주문금액</th>
                                    <th scope="col" style="width: 4%;">수량</th>
                                    <th scope="col" style="width: 6%;">배송비</th>
                                    <th scope="col" style="width: 6%;">할인금액</th>
                                    <th scope="col" style="width: 8%;">결제금액(VAT)</th>
                                    <th scope="col" style="width: 6%;">운송방법</th>
                                    <th scope="col" style="width: 6%;">주문상태</th>
                                    <th scope="col" style="width: 5%;">운송장</th>
                                </tr>
                            </thead>
                            <tbody id="orderListBody">
                                <tr>
                                    <td colspan="14" class="py-4 text-center text-muted">
                                        검색 버튼을 클릭하여 주문을 조회하세요.
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <div class="d-flex justify-content-center align-items-center mt-4 gap-3">
                        <div id="paginationArea"></div>
                        <select id="pageSize" class="form-select form-select-sm" style="width: 100px;"
                            onchange="fn_changePageSize();">
                            <option value="20">20개씩</option>
                            <option value="50">50개씩</option>
                            <option value="100">100개씩</option>
                        </select>
                    </div>
                </div>

                <!-- Tracking Modal -->
                <div class="modal fade" id="trackingModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">운송장 정보</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" id="trackingOrderId" />
                                <input type="hidden" id="trackingDeliveryType" />
                                <div id="trackingFormArea"></div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary btn-sm"
                                    data-bs-dismiss="modal">취소</button>
                                <button type="button" class="btn btn-primary btn-sm"
                                    onclick="fn_saveTracking();">저장</button>
                            </div>
                        </div>
                    </div>
                </div>

                <script>
                    const contextPath = '${pageContext.request.contextPath}';

                    $(document).ready(function () {
                        const today = new Date();
                        const weekAgo = new Date();
                        weekAgo.setDate(today.getDate() - 7);

                        $('#orderDtFrom').val(formatDate(weekAgo));
                        $('#orderDtTo').val(formatDate(today));

                        fn_search();
                    });

                    function formatDate(date) {
                        const y = date.getFullYear();
                        const m = String(date.getMonth() + 1).padStart(2, '0');
                        const d = String(date.getDate()).padStart(2, '0');
                        return y + '-' + m + '-' + d;
                    }

                    function formatNumber(num) {
                        if (num == null) return '0';
                        return Number(num).toLocaleString();
                    }

                    function fn_toggleTodayOnly() {
                        const checked = $('#todayOnlyYn').is(':checked');
                        if (checked) {
                            const today = formatDate(new Date());
                            $('#orderDtFrom').val(today).prop('disabled', true);
                            $('#orderDtTo').val(today).prop('disabled', true);
                        } else {
                            $('#orderDtFrom').prop('disabled', false);
                            $('#orderDtTo').prop('disabled', false);
                        }
                    }

                    function fn_search() {
                        $('#pageIndex').val(1);
                        fn_selectList();
                        fn_selectSummary();
                    }

                    function fn_reset() {
                        $('#searchForm')[0].reset();
                        $('#todayOnlyYn').prop('checked', false);
                        $('#orderDtFrom').prop('disabled', false);
                        $('#orderDtTo').prop('disabled', false);

                        const today = new Date();
                        const weekAgo = new Date();
                        weekAgo.setDate(today.getDate() - 7);
                        $('#orderDtFrom').val(formatDate(weekAgo));
                        $('#orderDtTo').val(formatDate(today));

                        fn_search();
                    }

                    function fn_page(pageNo) {
                        $('#pageIndex').val(pageNo);
                        fn_selectList();
                    }

                    function fn_changePageSize() {
                        $('#pageIndex').val(1);
                        fn_selectList();
                    }

                    function fn_selectList() {
                        const formData = $('#searchForm').serialize();
                        const pageSize = $('#pageSize').val();

                        $.ajax({
                            url: contextPath + '/admin/order/selectOrderList.ajax',
                            type: 'POST',
                            data: formData + '&recordCountPerPage=' + pageSize,
                            dataType: 'json',
                            success: function (result) {
                                if (result.success) {
                                    renderOrderList(result.orderList, result.paginationInfo);
                                    $('#totalCount').text(formatNumber(result.totalCount));
                                } else {
                                    alert('조회 오류: ' + result.message);
                                }
                            },
                            error: function (xhr, status, error) {
                                console.error('AJAX Error:', error);
                                alert('서버 통신 오류가 발생했습니다.');
                            }
                        });
                    }

                    function fn_selectSummary() {
                        const formData = $('#searchForm').serialize();

                        $.ajax({
                            url: contextPath + '/admin/order/selectOrderSummary.ajax',
                            type: 'POST',
                            data: formData,
                            dataType: 'json',
                            success: function (result) {
                                if (result.success && result.summary) {
                                    $('#kpiGoodsAmt').text(formatNumber(result.summary.sumGoodsTotalAmt));
                                    $('#kpiDeliveryAmt').text(formatNumber(result.summary.sumDeliveryTotalAmt));
                                    $('#kpiDiscountAmt').text(formatNumber(result.summary.sumDiscountTotalAmt));
                                    $('#kpiPayAmt').text(formatNumber(result.summary.sumPayTotalAmt));
                                }
                            },
                            error: function (xhr, status, error) {
                                console.error('KPI Error:', error);
                            }
                        });
                    }

                    function renderOrderList(list, paginationInfo) {
                        const tbody = $('#orderListBody');
                        tbody.empty();

                        if (!list || list.length === 0) {
                            tbody.append('<tr><td colspan="14" class="py-4 text-center text-muted">검색된 결과가 없습니다.</td></tr>');
                            $('#paginationArea').empty();
                            return;
                        }

                        const firstIndex = paginationInfo.firstRecordIndex || 0;

                        list.forEach(function (item, idx) {
                            const prodName = item.firstSalesProdName || '-';
                            const itemCountDisplay = (item.itemCount > 1)
                                ? prodName + ' <span class="text-muted">외 ' + (item.itemCount - 1) + '건</span>'
                                : prodName;

                            const orderDt = item.orderDt ? new Date(item.orderDt).toLocaleString('ko-KR') : '-';
                            const payDisplay = formatNumber(item.payTotalAmt) + '(' + formatNumber(item.vatTotalAmt) + ')';

                            const row = '<tr>' +
                                '<td><input type="checkbox" class="order-check" value="' + item.orderId + '"></td>' +
                                '<td>' + (firstIndex + idx + 1) + '</td>' +
                                '<td>' + orderDt + '</td>' +
                                '<td>' + (item.orderNo || '-') + '</td>' +
                                '<td class="text-start">' + (item.buyerCompanyName || '-') + '</td>' +
                                '<td class="text-start">' + itemCountDisplay + '</td>' +
                                '<td class="text-end">' + formatNumber(item.goodsTotalAmt) + '</td>' +
                                '<td class="text-end">' + formatNumber(item.totalOrderQty) + '</td>' +
                                '<td class="text-end">' + formatNumber(item.deliveryTotalAmt) + '</td>' +
                                '<td class="text-end">' + formatNumber(item.discountTotalAmt) + '</td>' +
                                '<td class="text-end">' + payDisplay + '</td>' +
                                '<td>' + (item.deliveryTypeName || item.deliveryTypeCd || '-') + '</td>' +
                                '<td><span class="badge bg-' + getStatusBadgeColor(item.orderStatusCd) + '">' +
                                (item.orderStatusName || item.orderStatusCd || '-') + '</span></td>' +
                                '<td><button type="button" class="btn btn-outline-primary btn-tracking" ' +
                                'onclick="fn_openTracking(' + item.orderId + ', \'' + (item.deliveryTypeCd || '') + '\');">' +
                                '운송장</button></td>' +
                                '</tr>';

                            tbody.append(row);
                        });

                        renderPagination(paginationInfo);
                    }

                    function getStatusBadgeColor(statusCd) {
                        switch (statusCd) {
                            case 'COMPLETE': return 'success';
                            case 'CANCEL': return 'danger';
                            case 'SHIPPING': return 'info';
                            case 'CONFIRM': return 'primary';
                            default: return 'secondary';
                        }
                    }

                    function renderPagination(paginationInfo) {
                        const area = $('#paginationArea');
                        area.empty();

                        if (!paginationInfo || paginationInfo.totalRecordCount === 0) return;

                        const currentPage = paginationInfo.currentPageNo;
                        const totalPages = Math.ceil(paginationInfo.totalRecordCount / paginationInfo.recordCountPerPage);
                        const pageSize = paginationInfo.pageSize || 10;

                        const startPage = Math.floor((currentPage - 1) / pageSize) * pageSize + 1;
                        const endPage = Math.min(startPage + pageSize - 1, totalPages);

                        let html = '<nav><ul class="pagination pagination-sm mb-0">';

                        if (startPage > 1) {
                            html += '<li class="page-item"><a class="page-link" href="javascript:fn_page(1);">«</a></li>';
                            html += '<li class="page-item"><a class="page-link" href="javascript:fn_page(' + (startPage - 1) + ');">‹</a></li>';
                        }

                        for (let i = startPage; i <= endPage; i++) {
                            if (i === currentPage) {
                                html += '<li class="page-item active"><span class="page-link">' + i + '</span></li>';
                            } else {
                                html += '<li class="page-item"><a class="page-link" href="javascript:fn_page(' + i + ');">' + i + '</a></li>';
                            }
                        }

                        if (endPage < totalPages) {
                            html += '<li class="page-item"><a class="page-link" href="javascript:fn_page(' + (endPage + 1) + ');">›</a></li>';
                            html += '<li class="page-item"><a class="page-link" href="javascript:fn_page(' + totalPages + ');">»</a></li>';
                        }

                        html += '</ul></nav>';
                        area.html(html);
                    }

                    function fn_checkAll(checkbox) {
                        $('.order-check').prop('checked', checkbox.checked);
                    }

                    function fn_getSelectedOrderIds() {
                        const ids = [];
                        $('.order-check:checked').each(function () {
                            ids.push($(this).val());
                        });
                        return ids;
                    }

                    function fn_updateStatusBatch() {
                        const orderIds = fn_getSelectedOrderIds();
                        const statusCd = $('#batchStatusCd').val();

                        if (orderIds.length === 0) {
                            alert('주문을 선택해주세요.');
                            return;
                        }
                        if (!statusCd) {
                            alert('변경할 상태를 선택해주세요.');
                            return;
                        }

                        if (!confirm(orderIds.length + '건의 주문 상태를 변경하시겠습니까?')) {
                            return;
                        }

                        $.ajax({
                            url: contextPath + '/admin/order/updateOrderStatusBatch.ajax',
                            type: 'POST',
                            data: {
                                orderIds: orderIds.join(','),
                                orderStatusCd: statusCd
                            },
                            dataType: 'json',
                            success: function (result) {
                                alert(result.message);
                                if (result.success) {
                                    fn_selectList();
                                }
                            },
                            error: function (xhr, status, error) {
                                alert('상태 변경 오류: ' + error);
                            }
                        });
                    }

                    function fn_openTracking(orderId, deliveryTypeCd) {
                        $('#trackingOrderId').val(orderId);
                        $('#trackingDeliveryType').val(deliveryTypeCd);

                        let formHtml = '';
                        if (deliveryTypeCd === 'PARCEL' || !deliveryTypeCd) {
                            formHtml = `
                <div class="mb-3">
                    <label class="form-label">택배사</label>
                    <input type="text" id="trackingCourierCd" class="form-control form-control-sm" />
                </div>
                <div class="mb-3">
                    <label class="form-label">운송장번호</label>
                    <input type="text" id="trackingTrackingNo" class="form-control form-control-sm" />
                </div>
            `;
                        } else if (deliveryTypeCd === 'FREIGHT') {
                            formHtml = `
                <div class="mb-3">
                    <label class="form-label">운송업체명</label>
                    <input type="text" id="trackingFreightCompany" class="form-control form-control-sm" />
                </div>
                <div class="mb-3">
                    <label class="form-label">기사명</label>
                    <input type="text" id="trackingDriverName" class="form-control form-control-sm" />
                </div>
                <div class="mb-3">
                    <label class="form-label">기사 연락처</label>
                    <input type="text" id="trackingDriverMobile" class="form-control form-control-sm" />
                </div>
                <div class="mb-3">
                    <label class="form-label">차량번호</label>
                    <input type="text" id="trackingTruckNo" class="form-control form-control-sm" />
                </div>
            `;
                        } else if (deliveryTypeCd === 'FACTORY') {
                            formHtml = `
                <div class="mb-3">
                    <label class="form-label">수령장소</label>
                    <input type="text" id="trackingPickupPlace" class="form-control form-control-sm" />
                </div>
                <div class="mb-3">
                    <label class="form-label">담당자명</label>
                    <input type="text" id="trackingContactName" class="form-control form-control-sm" />
                </div>
                <div class="mb-3">
                    <label class="form-label">담당자 연락처</label>
                    <input type="text" id="trackingContactMobile" class="form-control form-control-sm" />
                </div>
            `;
                        }

                        $('#trackingFormArea').html(formHtml);
                        $('#trackingModal').modal('show');

                        fn_loadTrackingData(orderId, deliveryTypeCd);
                    }

                    function fn_loadTrackingData(orderId, deliveryTypeCd) {
                        let url = '';
                        if (deliveryTypeCd === 'PARCEL' || !deliveryTypeCd) {
                            url = contextPath + '/admin/order/selectDeliveryParcel.ajax';
                        } else if (deliveryTypeCd === 'FREIGHT') {
                            url = contextPath + '/admin/order/selectDeliveryFreight.ajax';
                        } else if (deliveryTypeCd === 'FACTORY') {
                            url = contextPath + '/admin/order/selectDeliveryFactory.ajax';
                        }

                        if (!url) return;

                        $.ajax({
                            url: url,
                            type: 'POST',
                            data: { orderId: orderId },
                            dataType: 'json',
                            success: function (result) {
                                if (result.success) {
                                    if (result.parcel) {
                                        $('#trackingCourierCd').val(result.parcel.courierCd);
                                        $('#trackingTrackingNo').val(result.parcel.trackingNo);
                                    } else if (result.freight) {
                                        $('#trackingFreightCompany').val(result.freight.freightCompanyName);
                                        $('#trackingDriverName').val(result.freight.driverName);
                                        $('#trackingDriverMobile').val(result.freight.driverMobile);
                                        $('#trackingTruckNo').val(result.freight.truckNo);
                                    } else if (result.factory) {
                                        $('#trackingPickupPlace').val(result.factory.pickupPlaceCd);
                                        $('#trackingContactName').val(result.factory.contactName);
                                        $('#trackingContactMobile').val(result.factory.contactMobile);
                                    }
                                }
                            }
                        });
                    }

                    function fn_saveTracking() {
                        const orderId = $('#trackingOrderId').val();
                        const deliveryTypeCd = $('#trackingDeliveryType').val();

                        let url = '';
                        let data = { orderId: orderId };

                        if (deliveryTypeCd === 'PARCEL' || !deliveryTypeCd) {
                            url = contextPath + '/admin/order/saveDeliveryParcel.ajax';
                            data.courierCd = $('#trackingCourierCd').val();
                            data.trackingNo = $('#trackingTrackingNo').val();
                        } else if (deliveryTypeCd === 'FREIGHT') {
                            url = contextPath + '/admin/order/saveDeliveryFreight.ajax';
                            data.freightCompanyName = $('#trackingFreightCompany').val();
                            data.driverName = $('#trackingDriverName').val();
                            data.driverMobile = $('#trackingDriverMobile').val();
                            data.truckNo = $('#trackingTruckNo').val();
                        } else if (deliveryTypeCd === 'FACTORY') {
                            url = contextPath + '/admin/order/saveDeliveryFactory.ajax';
                            data.pickupPlaceCd = $('#trackingPickupPlace').val();
                            data.contactName = $('#trackingContactName').val();
                            data.contactMobile = $('#trackingContactMobile').val();
                        }

                        $.ajax({
                            url: url,
                            type: 'POST',
                            data: data,
                            dataType: 'json',
                            success: function (result) {
                                alert(result.message);
                                if (result.success) {
                                    $('#trackingModal').modal('hide');
                                }
                            },
                            error: function (xhr, status, error) {
                                alert('저장 오류: ' + error);
                            }
                        });
                    }

                    function fn_printInvoice() {
                        const orderIds = fn_getSelectedOrderIds();
                        if (orderIds.length === 0) {
                            alert('거래명세서를 출력할 주문을 선택해주세요.');
                            return;
                        }
                        alert('거래명세서 출력 기능은 추가 개발이 필요합니다.');
                    }

                    function fn_downloadExcel() {
                        const from = $('#orderDtFrom').val();
                        const to = $('#orderDtTo').val();

                        if (!from || !to) {
                            alert('엑셀 다운로드를 위해 주문기간을 입력해주세요.');
                            return;
                        }
                        alert('엑셀 다운로드 기능은 추가 개발이 필요합니다.');
                    }
                </script>