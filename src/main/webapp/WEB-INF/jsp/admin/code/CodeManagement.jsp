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
                                        onclick="deleteGroupCodeRow()" title="삭제">
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
                                        onclick="deleteCodeRow()" title="삭제">
                                        <i class="bi bi-dash"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="table-container">
                                <table class="table table-sm table-bordered table-fixed mb-0">
                                    <thead>
                                        <tr>
                                            <th style="width: 20%;">코드</th>
                                            <th style="width: 15%;">순서</th>
                                            <th style="width: 45%;">코드명</th>
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
                                        onclick="deleteDetailCodeRow()" title="삭제">
                                        <i class="bi bi-dash"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="table-container">
                                <table class="table table-sm table-bordered table-fixed mb-0">
                                    <thead>
                                        <tr>
                                            <th style="width: 20%;">상세코드</th>
                                            <th style="width: 15%;">순서</th>
                                            <th style="width: 45%;">상세코드명</th>
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

                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    let selectedGroupCode = null;
                    let selectedCode = null;
                    let groupCodeData = [];
                    let codeData = [];
                    let detailCodeData = [];

                    // 페이지 로드 시 그룹코드 조회
                    $(document).ready(function () {
                        loadGroupCodes();
                    });

                    // ========== 전체 검색 ==========
                    function searchAll() {
                        loadGroupCodes();
                    }

                    // ========== 그룹코드 관련 함수 ==========
                    function loadGroupCodes() {
                        const searchVO = {
                            groupCodeName: $('#searchGroupCodeName').val(),
                            useYn: $('#searchUseYn').val()
                        };

                        $.ajax({
                            url: '<c:url value="/admin/code/groupCodeList.do"/>',
                            type: 'GET',
                            data: searchVO,
                            success: function (response) {
                                if (response.success) {
                                    groupCodeData = response.data || [];
                                    renderGroupCodeTable();
                                } else {
                                    alert('조회 실패: ' + response.message);
                                }
                            },
                            error: function () {
                                alert('서버 오류가 발생했습니다.');
                            }
                        });
                    }

                    function renderGroupCodeTable() {
                        const tbody = $('#groupCodeTableBody');
                        tbody.empty();

                        groupCodeData.forEach(function (item, index) {
                            const row = $('<tr>')
                                .attr('data-index', index)
                                .attr('data-group-code', item.groupCode)
                                .click(function () {
                                    selectGroupCode($(this));
                                });

                            row.append($('<td>').html('<input type="text" class="form-control form-control-sm" value="' + (item.groupCode || '') + '">'));
                            row.append($('<td>').html('<input type="text" class="form-control form-control-sm" value="' + (item.groupCodeName || '') + '">'));
                            row.append($('<td>').html('<input type="text" class="form-control form-control-sm" value="' + (item.useYn || '사용') + '">'));

                            tbody.append(row);
                        });
                    }

                    function selectGroupCode(row) {
                        $('#groupCodeTableBody tr').removeClass('selected');
                        row.addClass('selected');

                        const groupCode = row.find('td:eq(0) input').val();
                        selectedGroupCode = groupCode;

                        if (groupCode) {
                            loadCodes(groupCode);
                        } else {
                            $('#codeTableBody').empty();
                            $('#detailCodeTableBody').empty();
                        }
                    }

                    function addGroupCodeRow() {
                        const newRow = {
                            groupCode: '',
                            groupCodeName: '',
                            useYn: '사용'
                        };
                        groupCodeData.push(newRow);
                        renderGroupCodeTable();
                    }

                    function deleteGroupCodeRow() {
                        const selected = $('#groupCodeTableBody tr.selected');
                        if (selected.length === 0) {
                            alert('삭제할 행을 선택하세요.');
                            return;
                        }

                        const groupCode = selected.find('td:eq(0) input').val();
                        if (groupCode && confirm('정말 삭제하시겠습니까?')) {
                            $.ajax({
                                url: '<c:url value="/admin/code/deleteGroupCode.do"/>',
                                type: 'POST',
                                data: { groupCode: groupCode },
                                success: function (response) {
                                    if (response.success) {
                                        alert(response.message);
                                        loadGroupCodes();
                                    } else {
                                        alert(response.message);
                                    }
                                }
                            });
                        } else {
                            const index = selected.data('index');
                            groupCodeData.splice(index, 1);
                            renderGroupCodeTable();
                        }
                    }

                    function saveGroupCodes() {
                        const rows = $('#groupCodeTableBody tr');
                        let saveCount = 0;
                        let errorCount = 0;

                        rows.each(function () {
                            const groupCode = $(this).find('td:eq(0) input').val().trim();
                            const groupCodeName = $(this).find('td:eq(1) input').val().trim();
                            const useYn = $(this).find('td:eq(2) input').val().trim();

                            if (!groupCode || !groupCodeName) {
                                return; // skip empty rows
                            }

                            const data = {
                                groupCode: groupCode,
                                groupCodeName: groupCodeName,
                                useYn: useYn
                            };

                            $.ajax({
                                url: '<c:url value="/admin/code/saveGroupCode.do"/>',
                                type: 'POST',
                                data: data,
                                async: false,
                                success: function (response) {
                                    if (response.success) {
                                        saveCount++;
                                    } else {
                                        errorCount++;
                                    }
                                },
                                error: function () {
                                    errorCount++;
                                }
                            });
                        });

                        if (errorCount > 0) {
                            alert('저장 중 오류가 발생했습니다. (성공: ' + saveCount + ', 실패: ' + errorCount + ')');
                        } else {
                            alert(saveCount + '건 저장되었습니다.');
                        }
                        loadGroupCodes();
                    }

                    // ========== 코드 관련 함수 ==========
                    function loadCodes(groupCode) {
                        $.ajax({
                            url: '<c:url value="/admin/code/codeList.do"/>',
                            type: 'GET',
                            data: { groupCode: groupCode },
                            success: function (response) {
                                if (response.success) {
                                    codeData = response.data || [];
                                    renderCodeTable();
                                    $('#detailCodeTableBody').empty();
                                }
                            }
                        });
                    }

                    function renderCodeTable() {
                        const tbody = $('#codeTableBody');
                        tbody.empty();

                        codeData.forEach(function (item, index) {
                            const row = $('<tr>')
                                .attr('data-index', index)
                                .click(function () {
                                    selectCode($(this));
                                });

                            row.append($('<td>').html('<input type="text" class="form-control form-control-sm" value="' + (item.code || '') + '">'));
                            row.append($('<td>').html('<input type="number" class="form-control form-control-sm" value="' + (item.sortOrder || 0) + '">'));
                            row.append($('<td>').html('<input type="text" class="form-control form-control-sm" value="' + (item.codeName || '') + '">'));
                            row.append($('<td>').html('<input type="text" class="form-control form-control-sm" value="' + (item.useYn || '사용') + '">'));

                            tbody.append(row);
                        });
                    }

                    function selectCode(row) {
                        $('#codeTableBody tr').removeClass('selected');
                        row.addClass('selected');

                        const code = row.find('td:eq(0) input').val();
                        selectedCode = code;

                        if (selectedGroupCode && code) {
                            loadDetailCodes(selectedGroupCode, code);
                        } else {
                            $('#detailCodeTableBody').empty();
                        }
                    }

                    function addCodeRow() {
                        if (!selectedGroupCode) {
                            alert('그룹코드를 먼저 선택하세요.');
                            return;
                        }

                        const newRow = {
                            groupCode: selectedGroupCode,
                            code: '',
                            codeName: '',
                            sortOrder: 0,
                            useYn: '사용'
                        };
                        codeData.push(newRow);
                        renderCodeTable();
                    }

                    function deleteCodeRow() {
                        const selected = $('#codeTableBody tr.selected');
                        if (selected.length === 0) {
                            alert('삭제할 행을 선택하세요.');
                            return;
                        }

                        const code = selected.find('td:eq(0) input').val();
                        if (code && selectedGroupCode && confirm('정말 삭제하시겠습니까?')) {
                            $.ajax({
                                url: '<c:url value="/admin/code/deleteCode.do"/>',
                                type: 'POST',
                                data: {
                                    groupCode: selectedGroupCode,
                                    code: code
                                },
                                success: function (response) {
                                    alert(response.message);
                                    if (response.success) {
                                        loadCodes(selectedGroupCode);
                                    }
                                }
                            });
                        } else {
                            const index = selected.data('index');
                            codeData.splice(index, 1);
                            renderCodeTable();
                        }
                    }

                    function saveCodes() {
                        if (!selectedGroupCode) {
                            alert('그룹코드를 먼저 선택하세요.');
                            return;
                        }

                        const rows = $('#codeTableBody tr');
                        let saveCount = 0;
                        let errorCount = 0;

                        rows.each(function () {
                            const code = $(this).find('td:eq(0) input').val().trim();
                            const sortOrder = $(this).find('td:eq(1) input').val().trim();
                            const codeName = $(this).find('td:eq(2) input').val().trim();
                            const useYn = $(this).find('td:eq(3) input').val().trim();

                            if (!code || !codeName) {
                                return;
                            }

                            const data = {
                                groupCode: selectedGroupCode,
                                code: code,
                                codeName: codeName,
                                sortOrder: sortOrder,
                                useYn: useYn
                            };

                            $.ajax({
                                url: '<c:url value="/admin/code/saveCode.do"/>',
                                type: 'POST',
                                data: data,
                                async: false,
                                success: function (response) {
                                    if (response.success) {
                                        saveCount++;
                                    } else {
                                        errorCount++;
                                    }
                                },
                                error: function () {
                                    errorCount++;
                                }
                            });
                        });

                        if (errorCount > 0) {
                            alert('저장 중 오류가 발생했습니다. (성공: ' + saveCount + ', 실패: ' + errorCount + ')');
                        } else {
                            alert(saveCount + '건 저장되었습니다.');
                        }
                        loadCodes(selectedGroupCode);
                    }

                    // ========== 상세코드 관련 함수 ==========
                    function loadDetailCodes(groupCode, code) {
                        $.ajax({
                            url: '<c:url value="/admin/code/detailCodeList.do"/>',
                            type: 'GET',
                            data: {
                                groupCode: groupCode,
                                code: code
                            },
                            success: function (response) {
                                if (response.success) {
                                    detailCodeData = response.data || [];
                                    renderDetailCodeTable();
                                }
                            }
                        });
                    }

                    function renderDetailCodeTable() {
                        const tbody = $('#detailCodeTableBody');
                        tbody.empty();

                        detailCodeData.forEach(function (item, index) {
                            const row = $('<tr>').attr('data-index', index);

                            row.append($('<td>').html('<input type="text" class="form-control form-control-sm" value="' + (item.detailCode || '') + '">'));
                            row.append($('<td>').html('<input type="number" class="form-control form-control-sm" value="' + (item.sortOrder || 0) + '">'));
                            row.append($('<td>').html('<input type="text" class="form-control form-control-sm" value="' + (item.detailCodeName || '') + '">'));
                            row.append($('<td>').html('<input type="text" class="form-control form-control-sm" value="' + (item.useYn || '사용') + '">'));

                            tbody.append(row);
                        });
                    }

                    function addDetailCodeRow() {
                        if (!selectedGroupCode || !selectedCode) {
                            alert('코드를 먼저 선택하세요.');
                            return;
                        }

                        const newRow = {
                            groupCode: selectedGroupCode,
                            code: selectedCode,
                            detailCode: '',
                            detailCodeName: '',
                            sortOrder: 0,
                            useYn: '사용'
                        };
                        detailCodeData.push(newRow);
                        renderDetailCodeTable();
                    }

                    function deleteDetailCodeRow() {
                        const selected = $('#detailCodeTableBody tr.selected');
                        if (selected.length === 0) {
                            // 선택된 행이 없으면 마지막 행 삭제
                            const lastRow = $('#detailCodeTableBody tr:last');
                            if (lastRow.length > 0) {
                                const detailCode = lastRow.find('td:eq(0) input').val();
                                if (detailCode && confirm('정말 삭제하시겠습니까?')) {
                                    $.ajax({
                                        url: '<c:url value="/admin/code/deleteDetailCode.do"/>',
                                        type: 'POST',
                                        data: {
                                            groupCode: selectedGroupCode,
                                            code: selectedCode,
                                            detailCode: detailCode
                                        },
                                        success: function (response) {
                                            alert(response.message);
                                            if (response.success) {
                                                loadDetailCodes(selectedGroupCode, selectedCode);
                                            }
                                        }
                                    });
                                } else {
                                    detailCodeData.splice(detailCodeData.length - 1, 1);
                                    renderDetailCodeTable();
                                }
                            }
                            return;
                        }

                        const detailCode = selected.find('td:eq(0) input').val();
                        if (detailCode && confirm('정말 삭제하시겠습니까?')) {
                            $.ajax({
                                url: '<c:url value="/admin/code/deleteDetailCode.do"/>',
                                type: 'POST',
                                data: {
                                    groupCode: selectedGroupCode,
                                    code: selectedCode,
                                    detailCode: detailCode
                                },
                                success: function (response) {
                                    alert(response.message);
                                    if (response.success) {
                                        loadDetailCodes(selectedGroupCode, selectedCode);
                                    }
                                }
                            });
                        } else {
                            const index = selected.data('index');
                            detailCodeData.splice(index, 1);
                            renderDetailCodeTable();
                        }
                    }

                    function saveDetailCodes() {
                        if (!selectedGroupCode || !selectedCode) {
                            alert('코드를 먼저 선택하세요.');
                            return;
                        }

                        const rows = $('#detailCodeTableBody tr');
                        let saveCount = 0;
                        let errorCount = 0;

                        rows.each(function () {
                            const detailCode = $(this).find('td:eq(0) input').val().trim();
                            const sortOrder = $(this).find('td:eq(1) input').val().trim();
                            const detailCodeName = $(this).find('td:eq(2) input').val().trim();
                            const useYn = $(this).find('td:eq(3) input').val().trim();

                            if (!detailCode || !detailCodeName) {
                                return;
                            }

                            const data = {
                                groupCode: selectedGroupCode,
                                code: selectedCode,
                                detailCode: detailCode,
                                detailCodeName: detailCodeName,
                                sortOrder: sortOrder,
                                useYn: useYn
                            };

                            $.ajax({
                                url: '<c:url value="/admin/code/saveDetailCode.do"/>',
                                type: 'POST',
                                data: data,
                                async: false,
                                success: function (response) {
                                    if (response.success) {
                                        saveCount++;
                                    } else {
                                        errorCount++;
                                    }
                                },
                                error: function () {
                                    errorCount++;
                                }
                            });
                        });

                        if (errorCount > 0) {
                            alert('저장 중 오류가 발생했습니다. (성공: ' + saveCount + ', 실패: ' + errorCount + ')');
                        } else {
                            alert(saveCount + '건 저장되었습니다.');
                        }
                        loadDetailCodes(selectedGroupCode, selectedCode);
                    }

                    // 상세코드 행 선택
                    $(document).on('click', '#detailCodeTableBody tr', function () {
                        $('#detailCodeTableBody tr').removeClass('selected');
                        $(this).addClass('selected');
                    });
                </script>
            </body>

            </html>