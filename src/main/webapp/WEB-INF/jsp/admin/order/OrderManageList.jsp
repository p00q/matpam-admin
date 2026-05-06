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
            // 초기 날짜 설정
            const today = new Date();
            const weekAgo = new Date();
            weekAgo.setDate(today.getDate() - 7);

            $('#orderDtFrom').val(formatDate(weekAgo));
            $('#orderDtTo').val(formatDate(today));

            // 최초 검색 실행
            fn_search();
        });

        // --- Utility Functions ---
        function formatDate(date) {
            if (!date) return '-';
            const d = new Date(date);
            if (isNaN(d.getTime())) return date;
            const y = d.getFullYear();
            const m = String(d.getMonth() + 1).padStart(2, '0');
            const day = String(d.getDate()).padStart(2, '0');
            return y + '-' + m + '-' + day;
        }

        function formatDateTime(date) {
            if (!date) return '-';
            const d = new Date(date);
            if (isNaN(d.getTime())) return date;
            return formatDate(d) + ' ' + String(d.getHours()).padStart(2, '0') + ':' + String(d.getMinutes()).padStart(2, '0');
        }

        function formatNumber(num) {
            if (num == null) return '0';
            return Number(num).toLocaleString();
        }

        function getVal(obj, key) {
            if (!obj) return undefined;
            if (obj[key] !== undefined) return obj[key];
            // Handle EgovMap style (Underscore Upper)
            const underscoreUpper = key.replace(/([A-Z])/g, "_$1").toUpperCase();
            if (obj[underscoreUpper] !== undefined) return obj[underscoreUpper];
            return undefined;
        }

        // --- Business Functions ---
        function fn_search() {
            $('#pageIndex').val(1);
            fn_selectList();
            fn_selectSummary();
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
            
            console.log('Fetching order list...');

            $.ajax({
                url: contextPath + '/admin/order/selectOrderList.do',
                type: 'POST',
                data: formData + '&recordCountPerPage=' + pageSize,
                dataType: 'json',
                success: function (result) {
                    if (result.success) {
                        renderOrderList(result.orderList, result.paginationInfo);
                        $('#totalCount').text(formatNumber(result.totalCount || 0));
                    } else {
                        console.error('List Error:', result.message);
                    }
                },
                error: function (xhr) {
                    $('#orderListBody').html('<tr><td colspan="11" class="py-5 text-center text-danger">통신 중 오류가 발생했습니다. (Status: ' + xhr.status + ')</td></tr>');
                }
            });
        }

        function fn_selectSummary() {
            const formData = $('#searchForm').serialize();
            $.ajax({
                url: contextPath + '/admin/order/selectOrderSummary.do',
                type: 'POST',
                data: formData,
                dataType: 'json',
                success: function (result) {
                    if (result.success && result.summary) {
                        const s = result.summary;
                        $('#kpiGoodsAmt').text(formatNumber(getVal(s, 'sumGoodsTotalAmt') || 0));
                        $('#kpiDeliveryAmt').text(formatNumber(getVal(s, 'sumDeliveryTotalAmt') || 0));
                        $('#kpiDiscountAmt').text(formatNumber(getVal(s, 'sumDiscountTotalAmt') || 0));
                        $('#kpiPayAmt').text(formatNumber(getVal(s, 'sumPayTotalAmt') || 0));
                    }
                }
            });
        }

        function renderOrderList(list, paginationInfo) {
            const tbody = $('#orderListBody');
            tbody.empty();

            if (!list || list.length === 0) {
                tbody.append('<tr><td colspan="11" class="py-5 text-center text-muted"><i class="bi bi-inbox me-2"></i>조회된 내역이 없습니다.</td></tr>');
                $('#paginationArea').empty();
                return;
            }

            list.forEach(function (item, idx) {
                try {
                    const orderId = getVal(item, 'orderId');
                    const orderNo = getVal(item, 'orderNo') || '-';
                    const orderDt = getVal(item, 'orderDt');
                    const prodName = getVal(item, 'firstSalesProdName') || '-';
                    const buyerName = getVal(item, 'buyerCompanyName') || '-';
                    const goodsAmt = getVal(item, 'goodsTotalAmt') || 0;
                    const deliveryAmt = getVal(item, 'deliveryTotalAmt') || 0;
                    const discountAmt = getVal(item, 'discountTotalAmt') || 0;
                    const payAmt = getVal(item, 'payTotalAmt') || 0;
                    const vatAmt = getVal(item, 'vatTotalAmt') || 0;
                    const itemCount = getVal(item, 'itemCount') || 1;
                    const totalQty = getVal(item, 'totalOrderQty') || 0;
                    const statusName = getVal(item, 'orderStatusName') || '접수';
                    const statusCd = getVal(item, 'orderStatusCd');
                    const deliveryName = getVal(item, 'deliveryTypeName') || '택배';

                    const row = `
                        <tr>
                            <td><input type="checkbox" class="order-check" value="\${orderId}"></td>
                            <td class="text-center text-muted small">\${(paginationInfo.firstRecordIndex || 0) + idx + 1}</td>
                            <td>
                                <div class="mini-text text-muted">\${formatDateTime(orderDt)}</div>
                                <div class="fw-bold text-truncate" style="max-width: 200px;">\${prodName}</div>
                                \${itemCount > 1 ? `<span class="text-primary small">외 \${itemCount - 1}건</span>` : ''}
                            </td>
                            <td>
                                <div class="mini-text text-primary fw-bold">\${orderNo}</div>
                                <div class="small fw-semibold">\${buyerName}</div>
                            </td>
                            <td class="text-end fw-bold">\${formatNumber(goodsAmt)}</td>
                            <td class="text-center">\${formatNumber(totalQty)}</td>
                            <td class="text-end text-muted small">
                                <div>배: \${formatNumber(deliveryAmt)}</div>
                                <div class="text-danger">할: -\${formatNumber(discountAmt)}</div>
                            </td>
                            <td class="text-end">
                                <div class="fw-bold text-success">\${formatNumber(payAmt)}</div>
                                <div class="mini-text text-muted">(VAT \${formatNumber(vatAmt)})</div>
                            </td>
                            <td class="text-center"><span class="badge bg-soft-info text-info">\${deliveryName}</span></td>
                            <td class="text-center">
                                <span class="badge \${getStatusBadgeClass(statusCd)}">\${statusName}</span>
                            </td>
                            <td class="text-center">
                                <button type="button" class="btn btn-sm btn-outline-primary px-2" onclick="fn_openDetail('\${orderId}')">상세</button>
                            </td>
                        </tr>
                    `;
                    tbody.append(row);
                } catch (e) {
                    console.error('Render Row Error:', e, item);
                }
            });

            renderPagination(paginationInfo);
        }

        function getStatusBadgeClass(status) {
            switch (status) {
                case 'RECEIVED': return 'bg-soft-primary text-primary';
                case 'CONFIRMED': return 'bg-soft-info text-info';
                case 'SHIPPED': return 'bg-soft-warning text-warning';
                case 'COMPLETED': return 'bg-soft-success text-success';
                case 'CANCELLED': return 'bg-soft-danger text-danger';
                default: return 'bg-soft-secondary text-secondary';
            }
        }

        function renderPagination(info) {
            const area = $('#paginationArea');
            area.empty();
            if (!info || info.totalRecordCount === 0) return;

            const totalPages = Math.ceil(info.totalRecordCount / info.recordCountPerPage);
            const currentPage = info.currentPageNo;
            const pageSize = 10;
            const startPage = Math.floor((currentPage - 1) / pageSize) * pageSize + 1;
            const endPage = Math.min(startPage + pageSize - 1, totalPages);

            let html = '<ul class="pagination pagination-sm mb-0">';
            if (startPage > 1) {
                html += `<li class="page-item"><a class="page-link" href="javascript:fn_page(\${startPage - 1})">‹</a></li>`;
            }
            for (let i = startPage; i <= endPage; i++) {
                html += `<li class="page-item \${i === currentPage ? 'active' : ''}"><a class="page-link" href="javascript:fn_page(\${i})">\${i}</a></li>`;
            }
            if (endPage < totalPages) {
                html += `<li class="page-item"><a class="page-link" href="javascript:fn_page(\${endPage + 1})">›</a></li>`;
            }
            html += '</ul>';
            area.html(html);
        }

        // --- Other Interactions ---
        function fn_checkAll(cb) {
            $('.order-check').prop('checked', cb.checked);
        }

        function fn_openDetail(orderId) {
            alert('상세 정보(ID: ' + orderId + ') 기능은 준비 중입니다.');
        }

        // --- Manual Order ---
        function fn_openManualOrder() {
            $('#manualOrderModal').modal('show');
        }

        function fn_searchManualMember() {
            const keyword = $('#manualSearchKeyword').val();
            if (!keyword) return alert('검색어를 입력하세요.');
            $.ajax({
                url: contextPath + '/admin/member/selectMemberList.do',
                type: 'POST',
                data: { searchKeyword: keyword, pageIndex: 1, recordCountPerPage: 10 },
                success: function (res) {
                    if (res.success) {
                        let html = '<div class="list-group list-group-flush border rounded">';
                        res.memberList.forEach(m => {
                            html += `<button type="button" class="list-group-item list-group-item-action py-2" onclick="fn_selectManualMember('\${m.memberId}', '\${m.memberName}', \${m.moneyBalance || 0})">
                                        <div class="d-flex justify-content-between">
                                            <strong>\${m.memberName}</strong>
                                            <span class="badge bg-soft-accent text-accent">\${formatNumber(m.moneyBalance)}원</span>
                                        </div>
                                     </button>`;
                        });
                        html += '</div>';
                        $('#manualMemberResult').html(html);
                    }
                }
            });
        }

        function fn_selectManualMember(id, name, bal) {
            $('#manualSelectedMemberId').val(id);
            $('#manualSelectedMemberName').val(name);
            $('#manualCurrentMoney').val(bal);
            $('#manualCurrentMoneyDisplay').text(formatNumber(bal));
            $('#manualMemberResult').empty();
            fn_checkManualMoney();
        }

        function fn_checkManualMoney() {
            const bal = Number($('#manualCurrentMoney').val());
            const pay = Number($('#manualPayAmt').val());
            const canSave = bal >= pay && pay > 0;
            $('#btnSaveManualOrder').prop('disabled', !canSave);
            $('#manualMoneyWarning').toggleClass('d-none', bal >= pay);
        }

        function fn_saveManualOrder() {
            const id = $('#manualSelectedMemberId').val();
            const pay = $('#manualPayAmt').val();
            if (!confirm('주문을 등록하시겠습니까?')) return;
            $.ajax({
                url: contextPath + '/admin/order/insertManualOrder.ajax',
                type: 'POST',
                data: { buyerMemberId: id, payTotalAmt: pay },
                success: function (res) {
                    alert(res.message);
                    if (res.success) {
                        $('#manualOrderModal').modal('hide');
                        fn_search();
                    }
                }
            });
        }
    </script>