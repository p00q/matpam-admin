<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>코드관리</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css">
                <style>
                    .table-container {
                        height: 500px;
                        overflow-y: auto;
                        border: 1px solid #dee2e6;
                    }

                    .table-fixed {
                        width: 100%;
                    }

                    .table-fixed thead {
                        position: sticky;
                        top: 0;
                        background-color: #f8f9fa;
                        z-index: 10;
                    }

                    .table-fixed tbody tr {
                        cursor: pointer;
                    }

                    .table-fixed tbody tr.selected {
                        background-color: #ffc107 !important;
                    }

                    .table-fixed tbody tr:hover {
                        background-color: #f0f0f0;
                    }

                    .btn-circle {
                        width: 30px;
                        height: 30px;
                        border-radius: 50%;
                        padding: 0;
                        font-size: 16px;
                        line-height: 30px;
                    }

                    .section-header {
                        background-color: #0d6efd;
                        color: white;
                        padding: 8px 12px;
                        font-weight: bold;
                        border-radius: 4px 4px 0 0;
                    }

                    .search-section {
                        background-color: #f8f9fa;
                        padding: 15px;
                        border: 1px solid #dee2e6;
                        border-radius: 4px;
                        margin-bottom: 15px;
                    }

                    input[type="text"].form-control-sm,
                    select.form-select-sm {
                        height: 32px;
                        font-size: 14px;
                    }

                    .col-actions {
                        width: 80px;
                        text-align: center;
                    }

                    /* Premium Toast Notification */
                    #toast-container {
                        position: fixed;
                        top: 20px;
                        right: 20px;
                        z-index: 9999;
                    }

                    .toast-custom {
                        min-width: 300px;
                        padding: 15px 20px;
                        background: #fff;
                        color: #333;
                        border-radius: 8px;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
                        margin-bottom: 10px;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        animation: slideIn 0.3s ease-out forwards;
                        border-left: 5px solid #ccc;
                    }

                    @keyframes slideIn {
                        from { transform: translateX(100%); opacity: 0; }
                        to { transform: translateX(0); opacity: 1; }
                    }

                    .toast-custom.success { border-left-color: #28a745; background-color: #f0fff0; }
                    .toast-custom.error { border-left-color: #dc3545; background-color: #fff5f5; }
                    .toast-custom.warning { border-left-color: #ffc107; background-color: #fffff0; }

                    .toast-content { display: flex; align-items: center; gap: 12px; }
                    .toast-icon { font-size: 1.2rem; }
                    .toast-close { cursor: pointer; color: #999; margin-left: 15px; }
                    .toast-close:hover { color: #333; }
                </style>
            </head>

            <body>
                <div class="container-fluid p-4">
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><i class="bi bi-house-door-fill"></i></li>
                            <li class="breadcrumb-item">기본정보관리</li>
                            <li class="breadcrumb-item active" aria-current="page">코드관리</li>
                        </ol>
                    </nav>

                    <!-- 검색 필터 -->
                    <div class="search-section">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label mb-1">그룹코드명</label>
                                <input type="text" id="searchGroupCodeName" class="form-control form-control-sm"
                                    placeholder="그룹코드명">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label mb-1">코드명</label>
                                <input type="text" id="searchCodeName" class="form-control form-control-sm"
                                    placeholder="코드명">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label mb-1">상세코드명</label>
                                <input type="text" id="searchDetailCodeName" class="form-control form-control-sm"
                                    placeholder="상세코드명">
                            </div>
                            <div class="col-md-2">
                                <label class="form-label mb-1">사용여부</label>
                                <select id="searchUseYn" class="form-select form-select-sm">
                                    <option value="전체">전체</option>
                                    <option value="사용">사용</option>
                                    <option value="미사용">미사용</option>
                                </select>
                            </div>
                            <div class="col-md-1 d-flex align-items-end">
                                <button type="button" class="btn btn-primary btn-sm w-100"
                                    onclick="searchAll()">조회</button>
                            </div>
                        </div>
                    </div>

                    <!-- 3단 테이블 영역 -->
                    <div class="row">
                        <!-- 그룹코드 테이블 -->
                        <div class="col-md-4">
                            <div class="section-header d-flex justify-content-between align-items-center">
                                <span>그룹코드</span>
                                <div>
                                    <button type="button" class="btn btn-sm btn-light btn-circle"
                                        onclick="addGroupCodeRow()" title="추가">
                                        <i class="bi bi-plus"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-danger btn-circle ms-1"
                                        onclick="deleteGroupCodeRow(event)" title="삭제">
                                        <i class="bi bi-dash"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="table-container">
                                <table class="table table-sm table-bordered table-fixed mb-0">
                                    <thead>
                                        <tr>
                                            <th style="width: 30%;">그룹코드</th>
                                            <th style="width: 50%;">그룹코드명</th>
                                            <th style="width: 20%;">사용여부</th>
                                        </tr>
                                    </thead>
                                    <tbody id="groupCodeTableBody">
                                        <!-- 데이터가 여기에 추가됩니다 -->
                                    </tbody>
                                </table>
                            </div>
                            <div class="text-end mt-2">
                                <button type="button" class="btn btn-success btn-sm"
                                    onclick="saveGroupCodes()">저장</button>
                            </div>
                        </div>

                        <!-- 코드 테이블 -->
                        <div class="col-md-4">
                            <div class="section-header d-flex justify-content-between align-items-center">
                                <span>코드</span>
                                <div>
                                    <button type="button" class="btn btn-sm btn-light btn-circle" onclick="addCodeRow()"
                                        title="추가">
                                        <i class="bi bi-plus"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-danger btn-circle ms-1"
                                        onclick="deleteCodeRow(event)" title="삭제">
                                        <i class="bi bi-dash"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="table-container">
                                <table class="table table-sm table-bordered table-fixed mb-0">
                                    <thead>
                                        <tr>
                                            <th style="width: 30%;">코드</th>
                                            <th style="width: 12%;">순서</th>
                                            <th style="width: 38%;">코드명</th>
                                            <th style="width: 20%;">사용여부</th>
                                        </tr>
                                    </thead>
                                    <tbody id="codeTableBody">
                                        <!-- 데이터가 여기에 추가됩니다 -->
                                    </tbody>
                                </table>
                            </div>
                            <div class="text-end mt-2">
                                <button type="button" class="btn btn-success btn-sm" onclick="saveCodes()">저장</button>
                            </div>
                        </div>

                        <!-- 상세코드 테이블 -->
                        <div class="col-md-4">
                            <div class="section-header d-flex justify-content-between align-items-center">
                                <span>상세코드</span>
                                <div>
                                    <button type="button" class="btn btn-sm btn-light btn-circle"
                                        onclick="addDetailCodeRow()" title="추가">
                                        <i class="bi bi-plus"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-danger btn-circle ms-1"
                                        onclick="deleteDetailCodeRow(event)" title="삭제">
                                        <i class="bi bi-dash"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="table-container">
                                <table class="table table-sm table-bordered table-fixed mb-0">
                                    <thead>
                                        <tr>
                                            <th style="width: 30%;">상세코드</th>
                                            <th style="width: 12%;">순서</th>
                                            <th style="width: 38%;">상세코드명</th>
                                            <th style="width: 20%;">사용여부</th>
                                        </tr>
                                    </thead>
                                    <tbody id="detailCodeTableBody">
                                        <!-- 데이터가 여기에 추가됩니다 -->
                                    </tbody>
                                </table>
                            </div>
                            <div class="text-end mt-2">
                                <button type="button" class="btn btn-success btn-sm"
                                    onclick="saveDetailCodes()">저장</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 삭제 확인 모달 -->
                <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">삭제 확인</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body" id="deleteModalMessage">
                                정말 삭제하시겠습니까?
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                                <button type="button" class="btn btn-danger" id="btnConfirmDelete">삭제</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="toast-container"></div>

                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script>
                    function showToast(message, type = 'success') {
                        const container = $('#toast-container');
                        const icon = type === 'success' ? 'bi-check-circle-fill' : (type === 'error' ? 'bi-exclamation-octagon-fill' : 'bi-info-circle-fill');
                        const toast = $('<div class="toast-custom ' + type + '">' +
                            '<div class="toast-content">' +
                            '<i class="bi ' + icon + ' toast-icon"></i>' +
                            '<span>' + message + '</span>' +
                            '</div>' +
                            '<i class="bi bi-x toast-close"></i>' +
                            '</div>');

                        container.append(toast);

                        // Auto-remove after 3 seconds
                        setTimeout(() => {
                            toast.fadeOut(300, function () { $(this).remove(); });
                        }, 3000);

                        toast.find('.toast-close').click(function () {
                            toast.remove();
                        });
                    }
                </script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    let currentGroupItem = null;
                    let currentCodeItem = null;
                    let currentDetailItem = null;
                    let selectedGroupCode = null;
                    let selectedCode = null;
                    let selectedDetailCode = null;
                    let groupCodeData = [];
                    let codeData = [];
                    let detailCodeData = [];
                    
                    let deleteTargetInfo = null; // { type: 'group'|'code'|'detail', item: obj }

                    // 페이지 로드 시 그룹코드 조회
                    $(document).ready(function () {
                        loadGroupCodes();
                        
                        // 모달 삭제 버튼 클릭 이벤트
                        $('#btnConfirmDelete').on('click', function() {
                            if (deleteTargetInfo) {
                                executeDeletion(deleteTargetInfo);
                            }
                            $('#deleteConfirmModal').modal('hide');
                        });
                    });

                    // ========== 그룹코드 관련 함수 ==========
                    function loadGroupCodes() {
                        console.log('loadGroupCodes called');
                        const searchVO = {
                            groupCodeName: $('#searchGroupCodeName').val(),
                            code: $('#searchCodeName').val(),
                            detailCode: $('#searchDetailCodeName').val(),
                            useYn: $('#searchUseYn').val()
                        };

                        $.ajax({
                            url: '<c:url value="/admin/code/groupCodeList.do"/>',
                            type: 'GET',
                            data: searchVO,
                            success: function (response) {
                                if (response.success) {
                                    groupCodeData = (response.data || []).map(item => {
                                        item.isNew = false;
                                        return item;
                                    });
                                    renderGroupCodeTable();
                                } else {
                                    showToast('조회 실패: ' + response.message, 'error');
                                }
                            },
                            error: function () {
                                showToast('그룹코드 조회 중 오류가 발생했습니다.', 'error');
                            }
                        });
                    }

                    function searchAll() {
                        loadGroupCodes();
                    }

                    function renderGroupCodeTable() {
                        console.log('renderGroupCodeTable called, data length:', groupCodeData.length);
                        const tbody = $('#groupCodeTableBody');
                        tbody.empty();

                        groupCodeData.forEach(function (item, index) {
                            const row = $('<tr>')
                                .attr('data-index', index)
                                .click(function (e) {
                                    // input 클릭 시 중복 처리 방지
                                    if (e.target.tagName !== 'INPUT' && e.target.tagName !== 'SELECT') {
                                        selectGroupCode($(this));
                                    }
                                });

                            if (currentGroupItem === item) {
                                row.addClass('selected');
                            }

                            // 그룹코드 입력 필드
                            const groupCodeInput = $('<input type="text" class="form-control form-control-sm">')
                                .val(item.groupCode || '')
                                .on('focus', function() { selectGroupCode(row); })
                                .on('change', function() { item.groupCode = $(this).val().trim(); });
                            
                            if (item.isNew === false) {
                                groupCodeInput.prop('readonly', true).addClass('bg-light');
                            }
                            row.append($('<td>').append(groupCodeInput));

                            // 그룹코드명 입력 필드
                            const groupCodeNameInput = $('<input type="text" class="form-control form-control-sm">')
                                .val(item.groupCodeName || '')
                                .on('focus', function() { selectGroupCode(row); })
                                .on('change', function() { item.groupCodeName = $(this).val(); });
                            row.append($('<td>').append(groupCodeNameInput));
                            
                            // 사용여부 선택 필드
                            const useYnSelect = $('<select class="form-select form-select-sm">')
                                .append('<option value="Y"' + (item.useYn === 'Y' ? ' selected' : '') + '>사용</option>')
                                .append('<option value="N"' + (item.useYn === 'N' ? ' selected' : '') + '>미사용</option>')
                                .on('focus', function() { selectGroupCode(row); })
                                .on('change', function() { item.useYn = $(this).val(); });
                            row.append($('<td>').append(useYnSelect));

                            tbody.append(row);
                        });
                    }

                    function selectGroupCode(row) {
                        $('#groupCodeTableBody tr').removeClass('selected');
                        row.addClass('selected');

                        const index = parseInt(row.attr('data-index'));
                        const item = groupCodeData[index];
                        if (!item) return;

                        currentGroupItem = item;
                        selectedGroupCode = item.groupCode;
                        currentCodeItem = null;
                        selectedCode = null;
                        currentDetailItem = null;
                        selectedDetailCode = null;
                        console.log('selectGroupCode:', selectedGroupCode);

                        if (selectedGroupCode && !item.isNew) {
                            loadCodes(selectedGroupCode);
                        } else {
                            codeData = [];
                            detailCodeData = [];
                            renderCodeTable();
                            renderDetailCodeTable();
                        }
                    }

                    function addGroupCodeRow() {
                        console.log('addGroupCodeRow called');
                        const newRow = {
                            groupCode: '',
                            groupCodeName: '',
                            useYn: 'Y',
                            isNew: true
                        };
                        groupCodeData.push(newRow);
                        renderGroupCodeTable();
                        
                        setTimeout(() => {
                            const lastRow = $('#groupCodeTableBody tr:last');
                            selectGroupCode(lastRow);
                            lastRow[0].scrollIntoView({ behavior: 'smooth', block: 'nearest' });
                        }, 50);
                    }

                    function deleteGroupCodeRow(event) {
                        const e = event || window.event;
                        if (e) e.stopPropagation();
                        
                        if (!currentGroupItem) {
                            const selectedRow = $('#groupCodeTableBody tr.selected');
                            if (selectedRow.length > 0) {
                                currentGroupItem = groupCodeData[parseInt(selectedRow.attr('data-index'))];
                            }
                        }

                        if (!currentGroupItem) {
                            showToast('삭제할 그룹코드를 선택하세요.', 'warning');
                            return;
                        }

                        const item = currentGroupItem;
                        if (!item.isNew) {
                            const hasChildren = (codeData && codeData.length > 0);
                            const msg = hasChildren ? 
                                '하위 코드가 존재합니다. 함께 삭제하시겠습니까? (데이터베이스에서 영구 삭제됩니다)' : 
                                '정말 삭제하시겠습니까? (데이터베이스에서 영구 삭제됩니다)';
                            
                            showDeleteModal('group', item, msg);
                        } else {
                            const index = groupCodeData.indexOf(item);
                            if (index > -1) {
                                groupCodeData.splice(index, 1);
                                renderGroupCodeTable();
                                currentGroupItem = null;
                                selectedGroupCode = null;
                            }
                        }
                    }

                    function saveGroupCodes() {
                        console.log('saveGroupCodes called');
                        let saveCount = 0;
                        let errorCount = 0;
                        let validationError = false;

                        const ids = new Set();
                        for(let i=0; i<groupCodeData.length; i++) {
                            const item = groupCodeData[i];
                            if (!item.groupCode?.trim() || !item.groupCodeName?.trim()) {
                                showToast((i + 1) + '번째 행의 필수값을 입력하세요.', 'warning');
                                validationError = true;
                                break;
                            }
                            if (ids.has(item.groupCode)) {
                                showToast('중복된 그룹코드가 존재합니다: ' + item.groupCode, 'warning');
                                validationError = true;
                                break;
                            }
                            ids.add(item.groupCode);
                        }

                        if (validationError) return;

                        groupCodeData.forEach(function(item) {
                            $.ajax({
                                url: '<c:url value="/admin/code/saveGroupCode.do"/>',
                                type: 'POST',
                                data: item,
                                async: false,
                                success: function (response) {
                                    if (response.success) saveCount++;
                                    else errorCount++;
                                },
                                error: function () { errorCount++; }
                            });
                        });

                        if (errorCount > 0) {
                            showToast('일부 저장 실패 (성공: ' + saveCount + ', 실패: ' + errorCount + ')', 'error');
                        } else if (saveCount > 0) {
                            showToast('모든 변경사항이 저장되었습니다.', 'success');
                        }
                        loadGroupCodes();
                    }

                    // ========== 코드 관련 함수 ==========
                    function loadCodes(groupCode) {
                        console.log('loadCodes called for:', groupCode);
                        $.ajax({
                            url: '<c:url value="/admin/code/codeList.do"/>',
                            type: 'GET',
                            data: { groupCode: groupCode },
                            success: function (response) {
                                if (response.success) {
                                    codeData = (response.data || []).map(item => {
                                        item.isNew = false;
                                        return item;
                                    });
                                    renderCodeTable();
                                    detailCodeData = [];
                                    renderDetailCodeTable();
                                }
                            },
                            error: function() {
                                showToast('코드 목록을 불러오지 못했습니다.', 'error');
                                codeData = [];
                                detailCodeData = [];
                                renderCodeTable();
                                renderDetailCodeTable();
                            }
                        });
                    }

                    function renderCodeTable() {
                        console.log('renderCodeTable called, length:', codeData.length);
                        const tbody = $('#codeTableBody');
                        tbody.empty();

                        codeData.forEach(function (item, index) {
                            const row = $('<tr>')
                                .attr('data-index', index)
                                .click(function (e) {
                                    if (e.target.tagName !== 'INPUT' && e.target.tagName !== 'SELECT') {
                                        selectCode($(this));
                                    }
                                });

                            if (currentCodeItem === item) {
                                row.addClass('selected');
                            }

                            // 코드 입력 필드
                            const codeInput = $('<input type="text" class="form-control form-control-sm">')
                                .val(item.code || '')
                                .on('focus', function() { selectCode(row); })
                                .on('change', function() { item.code = $(this).val().trim(); });
                            
                            if (item.isNew === false) {
                                codeInput.prop('readonly', true).addClass('bg-light');
                            }
                            row.append($('<td>').append(codeInput));

                            // 순서 입력 필드
                            const sortOrderInput = $('<input type="number" class="form-control form-control-sm">')
                                .val(item.sortOrder || 0)
                                .on('focus', function() { selectCode(row); })
                                .on('change', function() { item.sortOrder = $(this).val(); });
                            row.append($('<td>').append(sortOrderInput));

                            // 코드명 입력 필드
                            const codeNameInput = $('<input type="text" class="form-control form-control-sm">')
                                .val(item.codeName || '')
                                .on('focus', function() { selectCode(row); })
                                .on('change', function() { item.codeName = $(this).val(); });
                            row.append($('<td>').append(codeNameInput));
                            
                            // 사용여부 선택 필드
                            const useYnSelect = $('<select class="form-select form-select-sm">')
                                .append('<option value="Y"' + (item.useYn === 'Y' ? ' selected' : '') + '>사용</option>')
                                .append('<option value="N"' + (item.useYn === 'N' ? ' selected' : '') + '>미사용</option>')
                                .on('focus', function() { selectCode(row); })
                                .on('change', function() { item.useYn = $(this).val(); });
                            row.append($('<td>').append(useYnSelect));

                            tbody.append(row);
                        });
                    }

                    function selectCode(row) {
                        $('#codeTableBody tr').removeClass('selected');
                        row.addClass('selected');

                        const index = parseInt(row.attr('data-index'));
                        const item = codeData[index];
                        if (!item) return;

                        currentCodeItem = item;
                        selectedCode = item.code;
                        currentDetailItem = null;
                        selectedDetailCode = null;
                        console.log('selectCode:', selectedCode);

                        if (selectedGroupCode && selectedCode && !item.isNew) {
                            loadDetailCodes(selectedGroupCode, selectedCode);
                        } else {
                            detailCodeData = [];
                            renderDetailCodeTable();
                        }
                    }

                    function addCodeRow() {
                        console.log('addCodeRow called');
                        if (!selectedGroupCode) {
                            showToast('그룹코드를 먼저 선택하세요.', 'warning');
                            return;
                        }

                        let maxOrder = 0;
                        codeData.forEach(c => {
                            const order = parseInt(c.sortOrder);
                            if (!isNaN(order) && order > maxOrder) maxOrder = order;
                        });

                        const newRow = {
                            groupCode: selectedGroupCode,
                            code: '',
                            codeName: '',
                            sortOrder: maxOrder + 1,
                            useYn: 'Y',
                            isNew: true
                        };
                        codeData.push(newRow);
                        renderCodeTable();

                        setTimeout(() => {
                            const lastRow = $('#codeTableBody tr:last');
                            selectCode(lastRow);
                            lastRow[0].scrollIntoView({ behavior: 'smooth', block: 'nearest' });
                        }, 50);
                    }

                    function deleteCodeRow(event) {
                        const e = event || window.event;
                        if (e) e.stopPropagation();
                        
                        let item = currentCodeItem;
                        if (!item) {
                            const selectedRow = $('#codeTableBody tr.selected');
                            if (selectedRow.length > 0) {
                                item = codeData[parseInt(selectedRow.attr('data-index'))];
                                currentCodeItem = item;
                            }
                        }
                        
                        if (!item) {
                            showToast('삭제할 코드를 선택하세요.', 'warning');
                            return;
                        }

                        if (!item.isNew) {
                            const hasChildren = (detailCodeData && detailCodeData.length > 0);
                            const msg = hasChildren ? 
                                '하위 상세코드가 존재합니다. 함께 삭제하시겠습니까? (영구 삭제)' : 
                                '정말 삭제하시겠습니까? (데이터베이스에서 영구 삭제됩니다)';
                            
                            showDeleteModal('code', item, msg);
                        } else {
                            const index = codeData.indexOf(item);
                            if (index > -1) {
                                codeData.splice(index, 1);
                                renderCodeTable();
                                currentCodeItem = null;
                                selectedCode = null;
                            }
                        }
                    }

                    function saveCodes() {
                        console.log('saveCodes called');
                        if (!selectedGroupCode) {
                            showToast('그룹코드를 먼저 선택하세요.', 'warning');
                            return;
                        }

                        let saveCount = 0;
                        let errorCount = 0;
                        let validationError = false;

                        const ids = new Set();
                        for(let i=0; i<codeData.length; i++) {
                            const item = codeData[i];
                            if (!item.code?.trim() || !item.codeName?.trim()) {
                                showToast((i + 1) + '번째 행의 필수값을 입력하세요.', 'warning');
                                validationError = true;
                                break;
                            }
                            if (ids.has(item.code)) {
                                showToast('중복된 코드가 존재합니다: ' + item.code, 'warning');
                                validationError = true;
                                break;
                            }
                            ids.add(item.code);
                        }

                        if (validationError) return;

                        codeData.forEach(function(item) {
                            $.ajax({
                                url: '<c:url value="/admin/code/saveCode.do"/>',
                                type: 'POST',
                                data: item,
                                async: false,
                                success: function (response) {
                                    if (response.success) saveCount++;
                                    else errorCount++;
                                },
                                error: function () { errorCount++; }
                            });
                        });

                        if (errorCount > 0) {
                            showToast('일부 저장 실패 (성공: ' + saveCount + ', 실패: ' + errorCount + ')', 'error');
                        } else if (saveCount > 0) {
                            showToast('모든 변경사항이 저장되었습니다.', 'success');
                        }
                        loadCodes(selectedGroupCode);
                    }

                    // ========== 상세코드 관련 함수 ==========
                    function loadDetailCodes(groupCode, code) {
                        console.log('loadDetailCodes called for:', groupCode, code);
                        $.ajax({
                            url: '<c:url value="/admin/code/detailCodeList.do"/>',
                            type: 'GET',
                            data: {
                                groupCode: groupCode,
                                code: code
                            },
                            success: function (response) {
                                if (response.success) {
                                    detailCodeData = (response.data || []).map(item => {
                                        item.isNew = false;
                                        return item;
                                    });
                                    renderDetailCodeTable();
                                }
                            },
                            error: function() {
                                showToast('상세코드 목록을 불러오지 못했습니다.', 'error');
                                detailCodeData = [];
                                renderDetailCodeTable();
                            }
                        });
                    }

                    function renderDetailCodeTable() {
                        console.log('renderDetailCodeTable called, length:', detailCodeData.length);
                        const tbody = $('#detailCodeTableBody');
                        tbody.empty();

                        detailCodeData.forEach(function (item, index) {
                            const row = $('<tr>')
                                .attr('data-index', index)
                                .attr('data-detail-code', item.detailCode || '')
                                .click(function(e) {
                                    if (e.target.tagName !== 'INPUT' && e.target.tagName !== 'SELECT') {
                                        selectDetailCode($(this));
                                    }
                                });

                            if (currentDetailItem === item) {
                                row.addClass('selected');
                            }

                            // 상세코드 입력 필드
                            const detailCodeInput = $('<input type="text" class="form-control form-control-sm">')
                                .val(item.detailCode || '')
                                .on('focus', function() { selectDetailCode(row); })
                                .on('change', function() { item.detailCode = $(this).val(); });
                            
                            if (item.isNew === false) {
                                detailCodeInput.prop('readonly', true).addClass('bg-light');
                            }
                            row.append($('<td>').append(detailCodeInput));

                            // 순서 입력 필드
                            const sortOrderInput = $('<input type="number" class="form-control form-control-sm">')
                                .val(item.sortOrder || 0)
                                .on('focus', function() { selectDetailCode(row); })
                                .on('change', function() { item.sortOrder = $(this).val(); });
                            row.append($('<td>').append(sortOrderInput));

                            // 상세코드명 입력 필드
                            const detailCodeNameInput = $('<input type="text" class="form-control form-control-sm">')
                                .val(item.detailCodeName || '')
                                .on('focus', function() { selectDetailCode(row); })
                                .on('change', function() { item.detailCodeName = $(this).val(); });
                            row.append($('<td>').append(detailCodeNameInput));
                            
                            // 사용여부 선택 필드
                            const useYnSelect = $('<select class="form-select form-select-sm">')
                                .append('<option value="Y"' + (item.useYn === 'Y' ? ' selected' : '') + '>사용</option>')
                                .append('<option value="N"' + (item.useYn === 'N' ? ' selected' : '') + '>미사용</option>')
                                .on('focus', function() { selectDetailCode(row); })
                                .on('change', function() { item.useYn = $(this).val(); });
                            row.append($('<td>').append(useYnSelect));

                            tbody.append(row);
                        });
                    }

                    function selectDetailCode(row) {
                        $('#detailCodeTableBody tr').removeClass('selected');
                        row.addClass('selected');
                        
                        const index = parseInt(row.attr('data-index'));
                        const item = detailCodeData[index];
                        if (item) {
                            currentDetailItem = item;
                            selectedDetailCode = item.detailCode;
                        }
                        console.log('selectDetailCode called:', selectedDetailCode);
                    }

                    function addDetailCodeRow() {
                        console.log('addDetailCodeRow called');
                        if (!selectedGroupCode || !selectedCode) {
                            showToast('코드를 먼저 선택하세요.', 'warning');
                            return;
                        }

                        let maxOrder = 0;
                        detailCodeData.forEach(c => {
                            const order = parseInt(c.sortOrder);
                            if (!isNaN(order) && order > maxOrder) maxOrder = order;
                        });

                        const newRow = {
                            groupCode: selectedGroupCode,
                            code: selectedCode,
                            detailCode: '',
                            detailCodeName: '',
                            sortOrder: maxOrder + 1,
                            useYn: 'Y',
                            isNew: true
                        };
                        detailCodeData.push(newRow);
                        renderDetailCodeTable();

                        setTimeout(() => {
                            const lastRow = $('#detailCodeTableBody tr:last');
                            selectDetailCode(lastRow);
                            lastRow[0].scrollIntoView({ behavior: 'smooth', block: 'nearest' });
                        }, 50);
                    }

                    function deleteDetailCodeRow(event) {
                        const e = event || window.event;
                        if (e) e.stopPropagation();
                        
                        let item = currentDetailItem;
                        if (!item) {
                            const selectedRow = $('#detailCodeTableBody tr.selected');
                            if (selectedRow.length > 0) {
                                item = detailCodeData[parseInt(selectedRow.attr('data-index'))];
                                currentDetailItem = item;
                            }
                        }

                        if (!item) {
                            showToast('삭제할 상세코드를 선택하세요.', 'warning');
                            return;
                        }

                        if (!item.isNew) {
                            showDeleteModal('detail', item, '정말 삭제하시겠습니까? (데이터베이스에서 영구 삭제됩니다)');
                        } else {
                            const index = detailCodeData.indexOf(item);
                            if (index > -1) {
                                detailCodeData.splice(index, 1);
                                currentDetailItem = null;
                                selectedDetailCode = null;
                                renderDetailCodeTable();
                            }
                        }
                    }

                    // 모달 표시 함수
                    function showDeleteModal(type, item, message) {
                        deleteTargetInfo = { type: type, item: item };
                        $('#deleteModalMessage').text(message);
                        const modal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
                        modal.show();
                    }

                    // 실제 삭제 실행 함수
                    function executeDeletion(info) {
                        const item = info.item;
                        let url = '';
                        let data = {};

                        if (info.type === 'group') {
                            url = '<c:url value="/admin/code/deleteGroupCode.do"/>';
                            data = { groupCode: item.groupCode };
                        } else if (info.type === 'code') {
                            url = '<c:url value="/admin/code/deleteCode.do"/>';
                            data = { groupCode: item.groupCode, code: item.code };
                        } else if (info.type === 'detail') {
                            url = '<c:url value="/admin/code/deleteDetailCode.do"/>';
                            data = { groupCode: item.groupCode, code: item.code, detailCode: item.detailCode };
                        }

                        $.ajax({
                            url: url,
                            type: 'POST',
                            data: data,
                            success: function (response) {
                                showToast(response.message, response.success ? 'success' : 'error');
                                if (response.success) {
                                    if (info.type === 'group') {
                                        currentGroupItem = null;
                                        selectedGroupCode = null;
                                        loadGroupCodes();
                                        codeData = [];
                                        detailCodeData = [];
                                        renderCodeTable();
                                        renderDetailCodeTable();
                                    } else if (info.type === 'code') {
                                        currentCodeItem = null;
                                        selectedCode = null;
                                        loadCodes(item.groupCode);
                                        detailCodeData = [];
                                        renderDetailCodeTable();
                                    } else if (info.type === 'detail') {
                                        currentDetailItem = null;
                                        selectedDetailCode = null;
                                        loadDetailCodes(item.groupCode, item.code);
                                    }
                                }
                            },
                            error: function() {
                                showToast('삭제 중 오류가 발생했습니다.', 'error');
                            }
                        });
                    }

                    function saveDetailCodes() {
                        console.log('saveDetailCodes called');
                        if (!selectedGroupCode || !selectedCode) {
                            showToast('코드를 먼저 선택하세요.', 'warning');
                            return;
                        }

                        let saveCount = 0;
                        let errorCount = 0;
                        let validationError = false;

                        const ids = new Set();
                        for(let i=0; i<detailCodeData.length; i++) {
                            const item = detailCodeData[i];
                            if (!item.detailCode?.trim() || !item.detailCodeName?.trim()) {
                                showToast((i + 1) + '번째 행의 필수값을 입력하세요.', 'warning');
                                validationError = true;
                                break;
                            }
                            if (ids.has(item.detailCode)) {
                                showToast('중복된 상세코드가 존재합니다: ' + item.detailCode, 'warning');
                                validationError = true;
                                break;
                            }
                            ids.add(item.detailCode);
                        }

                        if (validationError) return;

                        detailCodeData.forEach(function(item) {
                            $.ajax({
                                url: '<c:url value="/admin/code/saveDetailCode.do"/>',
                                type: 'POST',
                                data: item,
                                async: false,
                                success: function (response) {
                                    if (response.success) saveCount++;
                                    else errorCount++;
                                },
                                error: function () { errorCount++; }
                            });
                        });

                        if (errorCount > 0) {
                            showToast('일부 저장 실패 (성공: ' + saveCount + ', 실패: ' + errorCount + ')', 'error');
                        } else if (saveCount > 0) {
                            showToast('모든 변경사항이 저장되었습니다.', 'success');
                        }
                        loadDetailCodes(selectedGroupCode, selectedCode);
                    }
                </script>
            </body>

            </html>