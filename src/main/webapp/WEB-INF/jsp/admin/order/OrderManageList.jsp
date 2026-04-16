<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="animate-fade-in">
    <!-- Breadcrumb & Title -->
    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1" style="font-size: 0.85rem;">
                    <li class="breadcrumb-item text-muted">주문 관리</li>
                    <li class="breadcrumb-item active">주문 목록</li>
                </ol>
            </nav>
            <h3 class="fw-bold mb-0" style="letter-spacing: -1px; color: var(--primary);"><c:out value="${pageTitle}"/> <span class="text-accent" style="color:var(--accent)">현황 관리</span></h3>
        </div>
        <div>
            <button type="button" class="btn btn-primary btn-premium px-4 shadow-sm me-2" onclick="fn_openManualOrder()">
                <i class="bi bi-pencil-square me-2"></i>수기 주문 등록
            </button>
            <button type="button" class="btn btn-outline-secondary btn-premium px-4 shadow-sm" onclick="fn_downloadExcel()">
                <i class="bi bi-file-earmark-excel me-2"></i>엑셀 다운로드
            </button>
        </div>
    </div>

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

    <!-- KPI Summary Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="premium-card p-3 h-100 border-start border-4 border-primary">
                <div class="text-muted small fw-bold mb-1">총 주문금액</div>
                <div class="d-flex align-items-center justify-content-between">
                    <h4 class="fw-bold mb-0 text-dark"><span id="kpiGoodsAmt">0</span> <span class="small fw-normal">원</span></h4>
                    <div class="rounded-circle bg-soft-primary p-2">
                        <i class="bi bi-cart-fill text-primary"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="premium-card p-3 h-100 border-start border-4 border-info">
                <div class="text-muted small fw-bold mb-1">총 배송비</div>
                <div class="d-flex align-items-center justify-content-between">
                    <h4 class="fw-bold mb-0 text-dark"><span id="kpiDeliveryAmt">0</span> <span class="small fw-normal">원</span></h4>
                    <div class="rounded-circle bg-soft-info p-2">
                        <i class="bi bi-truck text-info"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="premium-card p-3 h-100 border-start border-4 border-danger">
                <div class="text-muted small fw-bold mb-1">총 할인금액</div>
                <div class="d-flex align-items-center justify-content-between">
                    <h4 class="fw-bold mb-0 text-dark"><span id="kpiDiscountAmt">0</span> <span class="small fw-normal">원</span></h4>
                    <div class="rounded-circle bg-soft-danger p-2">
                        <i class="bi bi-tag-fill text-danger"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="premium-card p-3 h-100 border-start border-4 border-accent" style="border-color: var(--accent) !important;">
                <div class="text-muted small fw-bold mb-1">총 결제금액</div>
                <div class="d-flex align-items-center justify-content-between">
                    <h4 class="fw-bold mb-0 text-accent" style="color:var(--accent)"><span id="kpiPayAmt">0</span> <span class="small fw-normal">원</span></h4>
                    <div class="rounded-circle bg-soft-accent p-2">
                        <i class="bi bi-wallet2 text-accent"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Search Filter Section -->
    <div class="premium-card mb-4">
        <form name="searchForm" id="searchForm">
            <input type="hidden" name="pageIndex" id="pageIndex" value="1" />
            <input type="hidden" name="opType" id="opType" value="${searchVO.opType}" />
            <div class="row g-3">
                <div class="col-md-3">
                    <label class="form-label fw-bold small">주문 상태</label>
                    <select name="orderStatusCd" id="orderStatusCd" class="form-select">
                        <option value="">전체 상태</option>
                        <c:forEach var="code" items="${orderStatusList}">
                            <option value="${code.detailCodeId}">${code.detailCodeName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold small">배송 방법</label>
                    <select name="deliveryTypeCd" id="deliveryTypeCd" class="form-select">
                        <option value="">전체 방법</option>
                        <c:forEach var="code" items="${deliveryTypeList}">
                            <option value="${code.detailCodeId}">${code.detailCodeName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold small">주문 기간</label>
                    <div class="d-flex align-items-center gap-2">
                        <input type="date" name="orderDtFrom" id="orderDtFrom" class="form-control" />
                        <span class="text-muted">~</span>
                        <input type="date" name="orderDtTo" id="orderDtTo" class="form-control" />
                    </div>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <div class="form-check mb-2">
                        <input type="checkbox" class="form-check-input" id="todayOnlyYn" onchange="fn_toggleTodayOnly()">
                        <label class="form-check-label fw-semibold text-primary" for="todayOnlyYn" style="cursor:pointer;">금일 주문만</label>
                    </div>
                </div>
                <div class="col-md-12 mt-3">
                    <label class="form-label fw-bold small">업체명 검색</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="bi bi-building text-muted"></i></span>
                        <input type="text" name="buyerCompanyName" id="buyerCompanyName" class="form-control border-start-0" placeholder="업체명을 입력하여 검색하세요." />
                        <button type="button" class="btn btn-primary px-5 btn-premium" onclick="fn_search();">
                            <i class="bi bi-search me-2"></i>검색하기
                        </button>
                        <button type="button" class="btn btn-outline-secondary px-4 btn-premium" onclick="fn_reset();">
                            <i class="bi bi-arrow-counterclockwise"></i>
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <!-- Data Table Section -->
    <div class="premium-card">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div class="d-flex align-items-center gap-3">
                <h5 class="fw-bold mb-0"><i class="bi bi-receipt me-2 text-primary"></i>주문 목록</h5>
                <span class="badge bg-soft-primary text-primary px-3">TOTAL: <span id="totalCount" class="fw-bold">0</span>건</span>
            </div>
            <div class="d-flex align-items-center gap-2">
                <span class="text-muted small me-2 border-end pe-3">선택 일괄 처리</span>
                <select id="batchStatusCd" class="form-select form-select-sm" style="width: 140px;">
                    <option value="">주문상태 변경</option>
                    <c:forEach var="code" items="${orderStatusList}">
                        <option value="${code.detailCodeId}">${code.detailCodeName}</option>
                    </c:forEach>
                </select>
                <button type="button" class="btn btn-warning btn-premium btn-sm px-3" onclick="fn_updateStatusBatch();">
                    <i class="bi bi-check2-circle me-1"></i>적용
                </button>
            </div>
        </div>

        <div class="table-responsive">
            <table class="premium-table">
                <thead>
                    <tr>
                        <th style="width: 4%;"><input type="checkbox" id="checkAll" onclick="fn_checkAll(this);"></th>
                        <th style="width: 4%;">번호</th>
                        <th style="width: 15%;">주문일시 / 상품명</th>
                        <th style="width: 15%;">주문번호 / 업체명</th>
                        <th class="text-end" style="width: 10%;">주문금액</th>
                        <th class="text-center" style="width: 6%;">수량</th>
                        <th class="text-end" style="width: 8%;">배송 / 할인</th>
                        <th class="text-end" style="width: 12%;">최종 결제액(VAT)</th>
                        <th class="text-center" style="width: 8%;">운송방법</th>
                        <th class="text-center" style="width: 10%;">주문상태</th>
                        <th class="text-center" style="width: 8%;">관리</th>
                    </tr>
                </thead>
                <tbody id="orderListBody">
                    <tr>
                        <td colspan="11" class="py-5 text-center text-muted">
                            <div class="spinner-border spinner-border-sm text-primary me-2" role="status"></div>
                            주문 내역을 불러오는 중입니다...
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Pagination & List Size -->
        <div class="d-flex justify-content-between align-items-center mt-4">
            <div class="d-flex align-items-center gap-2">
                <select id="pageSize" class="form-select form-select-sm" style="width: 100px;" onchange="fn_changePageSize();">
                    <option value="20">20개씩</option>
                    <option value="50">50개씩</option>
                    <option value="100">100개씩</option>
                </select>
                <span class="text-muted mini-text">페이지당 출력 개수</span>
            </div>
            <div id="paginationArea"></div>
            <div style="width: 100px;"></div> <!-- Spacer -->
        </div>
    </div>
</div>
                </div>

    <!-- Tracking Modal -->
    <div class="modal fade" id="trackingModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content premium-card border-0">
                <div class="modal-header border-bottom p-3">
                    <h5 class="modal-title fw-bold"><i class="bi bi-truck me-2 text-primary"></i>운송 정보 입력</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <input type="hidden" id="trackingOrderId" />
                    <input type="hidden" id="trackingDeliveryType" />
                    <div id="trackingFormArea"></div>
                </div>
                <div class="modal-footer border-top p-3">
                    <button type="button" class="btn btn-outline-secondary btn-premium px-4" data-bs-dismiss="modal">닫기</button>
                    <button type="button" class="btn btn-primary btn-premium px-4" onclick="fn_saveTracking();">저장하기</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Manual Order Modal -->
    <div class="modal fade" id="manualOrderModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content premium-card border-0">
                <div class="modal-header border-bottom p-3">
                    <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2 text-primary"></i>수기 주문 등록</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label fw-bold">회원 (구매자) 지정</label>
                        <div class="input-group">
                            <input type="text" id="manualSearchKeyword" class="form-control" placeholder="이름 또는 연락처 검색" onkeypress="if(event.keyCode==13) { fn_searchManualMember(); return false;}">
                            <button class="btn btn-outline-secondary" type="button" onclick="fn_searchManualMember()">검색</button>
                        </div>
                    </div>
                    <div id="manualMemberResult" class="mb-3" style="max-height:150px; overflow-y:auto;">
                        <!-- Search results will appear here -->
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">선택된 회원</label>
                        <input type="hidden" id="manualSelectedMemberId" value="">
                        <input type="text" id="manualSelectedMemberName" class="form-control bg-light" readonly placeholder="위에서 회원을 검색 후 선택하세요">
                    </div>

                    <div class="mb-3 d-flex justify-content-between align-items-end">
                        <label class="form-label fw-bold mb-0">보유 맛팜 머니</label>
                        <h5 class="fw-bold text-accent mb-0" style="color:var(--accent);"><span id="manualCurrentMoneyDisplay">0</span><span class="small text-muted fw-normal ms-1">원</span></h5>
                        <input type="hidden" id="manualCurrentMoney" value="0">
                    </div>

                    <div class="mb-3 p-3 bg-soft-primary rounded border border-primary border-opacity-25">
                        <label class="form-label fw-bold text-primary">결제(차감) 금액</label>
                        <div class="input-group">
                            <input type="number" id="manualPayAmt" class="form-control form-control-lg text-end fw-bold" placeholder="차감할 금액 입력" oninput="fn_checkManualMoney()">
                            <span class="input-group-text bg-white">원</span>
                        </div>
                        <div id="manualMoneyWarning" class="form-text text-danger d-none mt-2 fw-semibold">
                            <i class="bi bi-exclamation-circle me-1"></i>보유하신 맛팜 머니 잔액이 부족합니다.
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-top p-3 bg-light">
                    <button type="button" class="btn btn-outline-secondary btn-premium px-4 shadow-sm" data-bs-dismiss="modal">취소</button>
                    <button type="button" id="btnSaveManualOrder" class="btn btn-primary btn-premium px-4 shadow-sm" onclick="fn_saveManualOrder()" disabled>주문(결제) 처리</button>
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
                            tbody.append('<tr><td colspan="11" class="py-5 text-center text-muted"><i class="bi bi-inbox fs-2 d-block mb-3 opacity-25"></i>검색된 주문 내역이 없습니다.</td></tr>');
                            $('#paginationArea').empty();
                            return;
                        }

                        const firstIndex = paginationInfo.firstRecordIndex || 0;

                        list.forEach(function (item, idx) {
                            const prodName = item.firstSalesProdName || '-';
                            const itemCountDisplay = (item.itemCount > 1)
                                ? '<div class="text-dark fw-semibold mt-1">' + prodName + ' <span class="text-primary small">외 ' + (item.itemCount - 1) + '건</span></div>'
                                : '<div class="text-dark fw-semibold mt-1">' + prodName + '</div>';

                            const orderDt = item.orderDt ? new Date(item.orderDt).toLocaleString('ko-KR') : '-';
                            const payDisplay = '<div class="fw-bold text-accent" style="color:var(--accent)">' + formatNumber(item.payTotalAmt) + '</div>' +
                                             '<div class="mini-text text-muted">(' + formatNumber(item.vatTotalAmt) + ')</div>';
                            const opTypeBadge = getOpTypeBadge(item.opType);

                            const row = '<tr>' +
                                '<td><input type="checkbox" class="order-check form-check-input" value="' + item.orderId + '"></td>' +
                                '<td>' + (firstIndex + idx + 1) + '</td>' +
                                '<td>' +
                                    '<div class="mini-text text-muted">' + orderDt + '</div>' +
                                    itemCountDisplay +
                                '</td>' +
                                '<td>' +
                                    '<div class="mini-text text-primary fw-bold">' + (item.orderNo || '-') + '</div>' +
                                    '<div class="text-dark small fw-semibold mt-1">' + (item.buyerCompanyName || '-') + '</div>' +
                                '</td>' +
                                '<td class="text-end fw-bold">' + formatNumber(item.goodsTotalAmt) + '</td>' +
                                '<td class="text-center">' + formatNumber(item.totalOrderQty) + '</td>' +
                                '<td class="text-end">' +
                                    '<div class="mini-text text-info">배: ' + formatNumber(item.deliveryTotalAmt) + '</div>' +
                                    '<div class="mini-text text-danger">할: -' + formatNumber(item.discountTotalAmt) + '</div>' +
                                '</td>' +
                                '<td class="text-end">' + payDisplay + '</td>' +
                                '<td class="text-center small">' + 
                                    '<div>' + (item.deliveryTypeName || item.deliveryTypeCd || '-') + '</div>' +
                                    '<div class="mt-1">' + opTypeBadge + '</div>' +
                                '</td>' +
                                '<td class="text-center"><span class="badge rounded-pill bg-soft-' + getStatusBadgeColor(item.orderStatusCd) + ' text-' + getStatusBadgeColor(item.orderStatusCd) + ' border border-' + getStatusBadgeColor(item.orderStatusCd) + '">' +
                                (item.orderStatusName || item.orderStatusCd || '-') + '</span></td>' +
                                '<td class="text-center">' +
                                    '<button type="button" class="btn btn-outline-primary btn-sm p-1 px-2" ' +
                                    'onclick="fn_openTracking(' + item.orderId + ', \'' + (item.deliveryTypeCd || '') + '\');">' +
                                    '<i class="bi bi-truck"></i></button>' +
                                '</td>' +
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
                    
                    // --- Manual Order Javascript ---
                    function fn_openManualOrder() {
                        $('#manualSearchKeyword').val('');
                        $('#manualMemberResult').empty();
                        $('#manualSelectedMemberId').val('');
                        $('#manualSelectedMemberName').val('');
                        $('#manualCurrentMoney').val('0');
                        $('#manualCurrentMoneyDisplay').text('0');
                        $('#manualPayAmt').val('');
                        $('#btnSaveManualOrder').prop('disabled', true);
                        $('#manualMoneyWarning').addClass('d-none');
                        $('#manualOrderModal').modal('show');
                    }

                    function fn_searchManualMember() {
                        const keyword = $('#manualSearchKeyword').val();
                        if (!keyword) {
                            alert("검색어를 입력하세요.");
                            return;
                        }
                        
                        $.ajax({
                            url: contextPath + '/admin/member/selectMemberList.ajax',
                            type: 'POST',
                            data: {
                                pageIndex: 1,
                                recordCountPerPage: 10,
                                searchKeyword: keyword
                            },
                            dataType: 'json',
                            success: function(res) {
                                if (res.success) {
                                    let html = '<ul class="list-group list-group-flush border rounded">';
                                    if (res.memberList && res.memberList.length > 0) {
                                        res.memberList.forEach(function(m) {
                                            const bal = m.moneyBalance || 0;
                                            html += '<li class="list-group-item list-group-item-action py-2" style="cursor:pointer;" ' +
                                                    'onclick="fn_selectManualMember(\'' + m.memberId + '\', \'' + m.memberName + '\', ' + bal + ')">' +
                                                    '<div class="d-flex justify-content-between align-items-center">' +
                                                    '<div><strong>' + m.memberName + '</strong> <span class="text-muted small">(' + m.mobile + ')</span></div>' +
                                                    '<span class="badge bg-soft-accent text-accent">잔액: ' + formatNumber(bal) + '원</span>' +
                                                    '</div></li>';
                                        });
                                    } else {
                                        html += '<li class="list-group-item text-center text-muted py-3">검색 결과가 없습니다.</li>';
                                    }
                                    html += '</ul>';
                                    $('#manualMemberResult').html(html);
                                }
                            }
                        });
                    }

                    function fn_selectManualMember(id, name, balance) {
                        $('#manualSelectedMemberId').val(id);
                        $('#manualSelectedMemberName').val(name);
                        $('#manualCurrentMoney').val(balance);
                        $('#manualCurrentMoneyDisplay').text(formatNumber(balance));
                        $('#manualMemberResult').empty();
                        fn_checkManualMoney();
                    }

                    function fn_checkManualMoney() {
                        const selectedId = $('#manualSelectedMemberId').val();
                        const balance = Number($('#manualCurrentMoney').val()) || 0;
                        const reqAmt = Number($('#manualPayAmt').val()) || 0;
                        
                        if (selectedId && reqAmt > 0) {
                            if (balance >= reqAmt) {
                                $('#manualMoneyWarning').addClass('d-none');
                                $('#btnSaveManualOrder').prop('disabled', false);
                            } else {
                                $('#manualMoneyWarning').removeClass('d-none');
                                $('#btnSaveManualOrder').prop('disabled', true);
                            }
                        } else {
                            $('#btnSaveManualOrder').prop('disabled', true);
                        }
                    }

                    function fn_saveManualOrder() {
                        const buyerMemberId = $('#manualSelectedMemberId').val();
                        const payTotalAmt = $('#manualPayAmt').val();
                        
                        if (!buyerMemberId) return alert("회원을 선택하세요.");
                        if (!payTotalAmt || payTotalAmt <= 0) return alert("결제 금액을 올바르게 입력하세요.");
                        
                        if (!confirm(formatNumber(payTotalAmt) + "원의 머니를 차감하고 주문을 등록하시겠습니까?")) return;
                        
                        $.ajax({
                            url: contextPath + '/admin/order/insertManualOrder.ajax',
                            type: 'POST',
                            data: {
                                buyerMemberId: buyerMemberId,
                                payTotalAmt: payTotalAmt
                            },
                            dataType: 'json',
                            success: function(res) {
                                alert(res.message);
                                if (res.success) {
                                    $('#manualOrderModal').modal('hide');
                                    fn_search();
                                }
                            },
                            error: function(xhr, status, error) {
                                alert("서버 처리 중 오류가 발생했습니다.");
                            }
                        });
                    }
                </script>