<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Chart.js include -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<div class="row animate-fade-in">
    <!-- 1. Page Header -->
    <div class="col-12 d-flex justify-content-between align-items-end mb-4">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1" style="font-size: 0.85rem;">
                    <li class="breadcrumb-item text-muted">정산/보상 관리</li>
                    <li class="breadcrumb-item active">일간 정산 내역</li>
                </ol>
            </nav>
            <h3 class="fw-bold mb-0" style="letter-spacing: -1px; color: var(--primary);"><c:out value="${pageTitle}"/> <span class="text-accent" style="color:var(--accent)">모니터링</span></h3>
        </div>
        <div class="gap-2 d-flex">
            <button type="button" class="btn btn-outline-primary btn-premium px-4 shadow-sm" onclick="fn_search()">
                <i class="bi bi-arrow-clockwise me-2"></i>데이터 새로고침
            </button>
        </div>
    </div>

    <!-- 2. KPI Metrics Section -->
    <div class="col-12 mb-4">
        <div class="row g-4">
            <!-- Total Payment Amount -->
            <div class="col-md-4">
                <div class="premium-card p-4 d-flex align-items-center bg-white shadow-sm border-0 h-100">
                    <div class="rounded-circle bg-primary bg-opacity-10 p-3 me-3">
                        <i class="bi bi-cash-stack text-primary fs-3"></i>
                    </div>
                    <div>
                        <div class="text-muted small fw-medium mb-1 uppercase tracking-wider">누적 총 결제액</div>
                        <h3 class="fw-bold mb-0" id="stat_sum_pay_amt" style="color: var(--primary);">0 <small class="fw-normal text-muted fs-6">원</small></h3>
                    </div>
                </div>
            </div>
            <!-- Average Processed Ratio -->
            <div class="col-md-4">
                <div class="premium-card p-4 d-flex align-items-center bg-white shadow-sm border-0 h-100">
                    <div class="rounded-circle bg-success bg-opacity-10 p-3 me-3">
                        <i class="bi bi-pie-chart text-success fs-3"></i>
                    </div>
                    <div class="flex-grow-1">
                        <div class="text-muted small fw-medium mb-1 uppercase tracking-wider">평균 원물(비과세) 비중</div>
                        <div class="d-flex align-items-end gap-2">
                            <h3 class="fw-bold mb-0 text-success" id="stat_avg_raw_ratio">0 <small class="fw-normal text-muted fs-6">%</small></h3>
                            <div class="progress flex-grow-1 mb-2" style="height: 6px; background: #eaedf1;">
                                <div id="stat_raw_bar" class="progress-bar bg-success" role="progressbar" style="width: 0%"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Total Order Count -->
            <div class="col-md-4">
                <div class="premium-card p-4 d-flex align-items-center bg-white shadow-sm border-0 h-100">
                    <div class="rounded-circle bg-warning bg-opacity-10 p-3 me-3">
                        <i class="bi bi-receipt text-warning fs-3"></i>
                    </div>
                    <div>
                        <div class="text-muted small fw-medium mb-1 uppercase tracking-wider">총 매출 주문건수</div>
                        <h3 class="fw-bold mb-0" id="stat_sum_order_cnt" style="color: var(--primary);">0 <small class="fw-normal text-muted fs-6">건</small></h3>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 3. Search Filters -->
    <div class="col-12 mb-4">
        <div class="premium-card p-4 bg-white border-0 shadow-sm">
            <div class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label class="form-label text-muted small fw-bold">정산 기간 <i class="bi bi-calendar-range ms-1"></i></label>
                    <div class="input-group">
                        <input type="date" class="form-control border-light-subtle bg-light bg-opacity-50" name="searchSettleDtFrom" id="searchSettleDtFrom">
                        <span class="input-group-text bg-light border-light-subtle">~</span>
                        <input type="date" class="form-control border-light-subtle bg-light bg-opacity-50" name="searchSettleDtTo" id="searchSettleDtTo">
                    </div>
                </div>
                <!-- opType 필터 (NATIONAL 운영자 전용) -->
                <c:if test="${opType eq 'NATIONAL'}">
                    <div class="col-md-3">
                        <label class="form-label text-muted small fw-bold">운영 타입 <i class="bi bi-shield-lock ms-1"></i></label>
                        <select class="form-select border-light-subtle bg-light bg-opacity-50" name="opType" id="opType">
                            <option value="">전체 권역</option>
                            <option value="NATIONAL">전국본부 (NATIONAL)</option>
                            <option value="LOCAL">전북본부 (LOCAL)</option>
                            <option value="FACTORY">가공공장 (FACTORY)</option>
                        </select>
                    </div>
                </c:if>
                <div class="col-md-2 ms-auto">
                    <button type="button" class="btn btn-primary btn-premium w-100 shadow-sm" style="height: 48px;" onclick="fn_search()">
                        <i class="bi bi-search me-2"></i>조회하기
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Premium Chart Section -->
    <div class="col-12 mb-4">
        <div class="premium-card bg-white border-0 shadow-sm overflow-hidden p-4">
            <h5 class="fw-bold mb-4" style="color: var(--primary);"><i class="bi bi-graph-up-arrow me-2"></i>운영권역별 매출 추이</h5>
            <div style="height: 300px; width: 100%;">
                <canvas id="settlementTrendChart"></canvas>
            </div>
        </div>
    </div>

    <!-- 4. Data List -->
    <div class="col-12">
        <div class="premium-card bg-white border-0 shadow-sm overflow-hidden mb-4">
            <div class="card-header bg-white py-3 border-0 d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center">
                    <i class="bi bi-table text-primary me-2"></i>
                    <h5 class="mb-0 fw-bold" style="color: var(--primary);">정산 내역 상세</h5>
                    <div class="vr mx-3 text-light-subtle" style="height: 15px;"></div>
                    <!-- 수동 실행 도구 -->
                    <div class="d-flex align-items-center gap-2">
                        <input type="date" class="form-control form-control-sm border-accent" id="execSettleDate" style="width: 140px;">
                        <button type="button" class="btn btn-warning shadow-sm fw-bold px-3 btn-sm" onclick="fn_executeSettlement()">
                            <i class="bi bi-play-fill"></i> 당일 정산 배치 강제실행
                        </button>
                    </div>
                </div>
                <div class="text-muted small">총 <span class="fw-bold text-primary" id="span_total_count">0</span>건</div>
            </div>
            <div class="table-responsive">
                <table class="premium-table">
                    <thead>
                        <tr class="text-center">
                            <th>정산 일자</th>
                            <th>운영 권역</th>
                            <th class="text-end">주문 건수</th>
                            <th class="text-end">총 상품액</th>
                            <th class="text-end">총 배달/할인</th>
                            <th class="text-end">총 부가세</th>
                            <th class="text-end pe-4">실 결제액(머니)</th>
                            <th class="text-center">원물/가공 비중</th>
                        </tr>
                    </thead>
                    <tbody id="settlement_list_tbody">
                        <!-- AJAX 렌더링 영역 -->
                    </tbody>
                </table>
            </div>
            <!-- Pagination -->
            <div id="pagination_div" class="py-4 bg-light bg-opacity-10 d-flex justify-content-center"></div>
        </div>
    </div>
</div>

<script>
    let trendChart = null;

    $(document).ready(function() {
        // 초기 날짜 설정 (최근 7일)
        let lastWeek = new Date();
        lastWeek.setDate(lastWeek.getDate() - 7);
        $('#searchSettleDtFrom').val(lastWeek.toISOString().substring(0, 10));
        $('#searchSettleDtTo').val(new Date().toISOString().substring(0, 10));

        // 당일 정산 디폴트는 오늘
        $('#execSettleDate').val(new Date().toISOString().substring(0, 10));

        fn_search(1);
    });

    /**
     * Number Formatting
     */
    function formatNumber(num) {
        if (!num) return '0';
        return Number(num).toLocaleString();
    }

    /**
     * 목록 및 요약 정보 통합 조회
     */
    function fn_search(pageIndex) {
        if (!pageIndex) pageIndex = 1;
        
        // 날짜 하이픈 제거 ('YYYY-MM-DD' -> 'YYYYMMDD')
        let fromDt = $('#searchSettleDtFrom').val().replace(/-/g, '');
        let toDt = $('#searchSettleDtTo').val().replace(/-/g, '');
        
        let params = {
            pageIndex: pageIndex,
            // (주의: MyBatis에서 settleDate가 String일 경우 Like 처리를 하거나, 여기선 기간이 아닌 특정일이면 settleDate 전달.)
            // 여기 MVP에서는 특정 settleDate 파라미터 대신 전체 조회를 수행합니다. 실제 운영에선 Between 필요.
            opType: $('#opType').val() || ''
        };

        // 1. KPI 요약 조회
        $.ajax({
            url: "<c:url value='/admin/settlement/selectSettlementSummary.ajax'/>",
            type: "POST",
            data: params,
            dataType: 'json',
            success: function(res) {
                if (res.success && res.summary) {
                    let s = res.summary;
                    $('#stat_sum_pay_amt').html(formatNumber(s.sumPayAmt) + ' <small class="fw-normal text-muted fs-6">원</small>');
                    $('#stat_sum_order_cnt').html(formatNumber(s.sumOrderCnt) + ' <small class="fw-normal text-muted fs-6">건</small>');
                    
                    $('#stat_avg_raw_ratio').html(formatNumber(s.avgRawRatio) + ' <small class="fw-normal text-muted fs-6">%</small>');
                    $('#stat_raw_bar').css('width', (s.avgRawRatio || 0) + '%');
                }
            }
        });

        // 2. 목록 조회
        $.ajax({
            url: "<c:url value='/admin/settlement/selectSettlementList.ajax'/>",
            type: "POST",
            data: params,
            dataType: 'json',
            success: function(res) {
                if (res.success) {
                    renderList(res.settlementList);
                    renderChart(res.settlementList);
                    $('#span_total_count').text(formatNumber(res.totalCount));
                } else {
                    alert('데이터 조회 중 오류: ' + res.message);
                }
            }
        });
    }

    /**
     * 데이터 목록 렌더링
     */
    function renderList(list) {
        let $tbody = $('#settlement_list_tbody');
        $tbody.empty();

        if (!list || list.length === 0) {
            $tbody.append('<tr><td colspan="8" class="text-center py-5 text-muted">정산 데이터가 존재하지 않습니다.</td></tr>');
            return;
        }

        list.forEach(item => {
            let opBadge = getOpTypeBadge(item.opType);

            // 날짜 포맷 (YYYYMMDD -> YYYY-MM-DD)
            let formattedDate = item.settleDate;
            if (formattedDate && formattedDate.length === 8) {
                formattedDate = formattedDate.substring(0,4) + '-' + formattedDate.substring(4,6) + '-' + formattedDate.substring(6,8);
            }

            // 기타 금액
            let discountDeliveryAmt = (item.totalSalesAmt || 0) - (item.totalGoodsAmt || 0);

            let html = `
                <tr class="text-center align-middle hover-row">
                    <td class="fw-bold text-dark">\${formattedDate}</td>
                    <td>\${opBadge}</td>
                    <td class="text-end fw-medium">\${formatNumber(item.orderCount)} 건</td>
                    <td class="text-end fw-bold text-dark">\${formatNumber(item.totalGoodsAmt)} 원</td>
                    <td class="text-end text-muted">\${formatNumber(discountDeliveryAmt)} 원</td>
                    <td class="text-end text-muted">\${formatNumber(item.totalVatAmt)} 원</td>
                    <td class="text-end pe-4 fw-bold" style="color: var(--accent); font-size: 1.05rem;">\${formatNumber(item.totalPayAmt)} 원</td>
                    <td class="text-center"><span class="small text-muted">\${item.rawMaterialRatio}% / \${item.processedRatio}%</span></td>
                </tr>
            `;
            $tbody.append(html);
        });
    }

    /**
     * 차트 렌더링
     */
    function renderChart(list) {
        if (!list || list.length === 0) return;

        // Group data by Date and opType
        const labels = Array.from(new Set(list.map(i => i.settleDate))).sort();
        const datasets = [];
        
        const nationalData = [];
        const localData = [];
        const factoryData = [];

        labels.forEach(date => {
            const nationalItem = list.find(i => i.settleDate === date && i.opType === 'NATIONAL');
            const localItem = list.find(i => i.settleDate === date && i.opType === 'LOCAL');
            const factoryItem = list.find(i => i.settleDate === date && i.opType === 'FACTORY');

            nationalData.push(nationalItem ? nationalItem.totalPayAmt : 0);
            localData.push(localItem ? localItem.totalPayAmt : 0);
            factoryData.push(factoryItem ? factoryItem.totalPayAmt : 0);
        });

        // formatting date labels
        const fmtLabels = labels.map(l => l.length === 8 ? l.substring(4,6) + '/' + l.substring(6,8) : l);

        const ctx = document.getElementById('settlementTrendChart').getContext('2d');
        if (trendChart) {
            trendChart.destroy();
        }

        trendChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: fmtLabels,
                datasets: [
                    {
                        label: '전국 매출',
                        data: nationalData,
                        backgroundColor: 'rgba(59, 130, 246, 0.8)',
                        borderRadius: 4
                    },
                    {
                        label: '로컬 매출',
                        data: localData,
                        backgroundColor: 'rgba(16, 185, 129, 0.8)',
                        borderRadius: 4
                    },
                    {
                        label: '공장 매출',
                        data: factoryData,
                        backgroundColor: 'rgba(245, 158, 11, 0.8)',
                        borderRadius: 4
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'top' }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return value.toLocaleString() + '원';
                            }
                        }
                    }
                }
            }
        });
    }

    /**
     * 수동 정산 배치 강제 실행
     */
    function fn_executeSettlement() {
        const d = $('#execSettleDate').val();
        if(!d) {
            alert('정산 실행할 일자를 선택해주세요.');
            return;
        }

        const settleDate = d.replace(/-/g, ''); // yyyyMMdd
        if(!confirm(d + ' 일자 정산을 실행하시겠습니까?\n기존 집계 데이터는 지워지고 주문 내역을 바탕으로 매상과 비중이 실시간 재계산됩니다.')) return;

        $('#execSettleDate').attr('disabled', true);
        
        $.ajax({
            url: "<c:url value='/admin/settlement/executeSettlement.ajax'/>",
            type: "POST",
            data: { settleDate: settleDate },
            dataType: 'json',
            success: function(res) {
                if(res.success) {
                    alert(res.message);
                    fn_search(1);
                } else {
                    alert('에러: ' + res.message);
                }
            },
            complete: function() {
                $('#execSettleDate').attr('disabled', false);
            }
        });
    }
</script>

<style>
    .hover-row:hover { background-color: rgba(234, 179, 8, 0.02) !important; }
    .tracking-wider { letter-spacing: 0.05em; }

    /**
     * 운영타입별 배지 렌더링
     */
    function getOpTypeBadge(opType) {
        if (opType === 'NATIONAL') return '<span class="badge bg-primary px-3 shadow-sm rounded-pill">전국 본부</span>';
        if (opType === 'LOCAL') return '<span class="badge bg-success px-3 shadow-sm rounded-pill">로컬 지사</span>';
        if (opType === 'FACTORY') return '<span class="badge bg-warning text-dark px-3 shadow-sm rounded-pill">가공 공장</span>';
        return '<span class="badge bg-secondary px-3 shadow-sm rounded-pill">미지정</span>';
    }
</style>
