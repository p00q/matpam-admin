<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <style>
                .code-container {
                    display: flex;
                    gap: 20px;
                    height: calc(100vh - 350px);
                    min-height: 500px;
                }

                .code-panel {
                    flex: 1;
                    display: flex;
                    flex-direction: column;
                    border: 1px solid #dee2e6;
                    border-radius: 4px;
                    background: #fff;
                }

                .panel-header {
                    background-color: #f8f9fa;
                    padding: 10px 15px;
                    border-bottom: 1px solid #dee2e6;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .panel-search {
                    display: flex;
                    align-items: center;
                    gap: 6px;
                }

                .panel-search .form-control,
                .panel-search .form-select {
                    min-width: 120px;
                }

                .panel-search .btn {
                    min-width: 56px;
                    white-space: nowrap;
                }

                .panel-body {
                    flex: 1;
                    overflow-y: auto;
                }

                .panel-table {
                    width: 100%;
                    margin-bottom: 0;
                    table-layout: fixed;
                }

                .panel-table th {
                    background-color: #f1f3f5;
                    position: sticky;
                    top: 0;
                    z-index: 10;
                    text-align: center;
                    font-weight: 600;
                    border-bottom: 2px solid #dee2e6;
                }

                .panel-table td {
                    vertical-align: middle;
                    padding: 8px;
                }

                .panel-table tr.selected {
                    background-color: #e9ecef;
                    font-weight: bold;
                }

                .panel-table tr:hover {
                    background-color: #f8f9fa;
                    cursor: pointer;
                }

                .panel-table input[type="text"],
                .panel-table input[type="number"] {
                    width: 100%;
                    border: none;
                    background: transparent;
                    text-align: center;
                }

                .panel-table input[type="checkbox"] {
                    width: auto;
                }

                .panel-table input:focus {
                    background: #fff;
                    outline: 1px solid #0d6efd;
                }

                .btn-circle {
                    width: 24px;
                    height: 24px;
                    padding: 0;
                    border-radius: 50%;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 14px;
                    margin-left: 5px;
                }
            </style>

            <div class="container-fluid p-4">
                <!-- Breadcrumb & Header -->
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="mb-0">기본정보관리</h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><i class="bi bi-house-door-fill"></i> 홈</li>
                            <li class="breadcrumb-item">기본정보관리</li>
                            <li class="breadcrumb-item active">공통코드</li>
                        </ol>
                    </nav>
                </div>

                <!-- Main Tabs -->
                <ul class="nav nav-tabs mb-4">
                    <li class="nav-item">
                        <a class="nav-link active" href="#">코드관리</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">지역관리</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">배송기사관리</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">회원등급관리</a>
                    </li>
                </ul>

                <!-- Filter Bar -->
                <div class="card mb-3">
                    <div class="card-body p-3">
                        <div class="row g-2 align-items-center">
                            <div class="col-md-4">
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text fw-bold">코드</span>
                                    <input type="text" id="filterCode" class="form-control" placeholder="입력">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="d-flex align-items-center gap-3">
                                    <span class="fw-bold">사용여부</span>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="topUseYn" id="topUseYnY"
                                            value="Y" checked>
                                        <label class="form-check-label" for="topUseYnY">사용</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="topUseYn" id="topUseYnN"
                                            value="N">
                                        <label class="form-check-label" for="topUseYnN">미사용</label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-auto">
                                <button type="button" id="btnSearch" class="btn btn-secondary btn-sm px-3">조회</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Bar -->
                <div class="d-flex justify-content-end mb-3">
                    <button type="button" id="btnSave" class="btn btn-dark btn-sm px-4">저장</button>
                </div>

                <!-- 3-Column Content -->
                <div class="code-container">
                    <!-- 1. Group Code Panel -->
                    <div class="code-panel">
                        <div class="panel-header">
                            <div class="panel-search">
                                <input type="text" id="groupSearchCode" class="form-control form-control-sm"
                                    list="groupCodeList" placeholder="그룹코드">
                                <datalist id="groupCodeList"></datalist>
                                <select id="groupSearchUseYn" class="form-select form-select-sm">
                                    <option value="">전체</option>
                                    <option value="Y">사용</option>
                                    <option value="N">미사용</option>
                                </select>
                                <button type="button" id="btnGroupSearch"
                                    class="btn btn-outline-secondary btn-sm">검색</button>
                            </div>
                            <div>
                                <button type="button" class="btn btn-secondary btn-circle btn-add"
                                    data-type="group">+</button>
                                <button type="button" class="btn btn-secondary btn-circle btn-remove"
                                    data-type="group">-</button>
                            </div>
                        </div>
                        <div class="panel-body">
                            <table class="table panel-table table-bordered text-center" id="groupTable">
                                <thead>
                                    <tr>
                                        <th width="5%">선택</th>
                                        <th width="30%">그룹코드</th>
                                        <th width="45%">그룹코드명</th>
                                        <th width="25%">사용여부</th>
                                    </tr>
                                </thead>
                                <tbody id="groupTbody">
                                    <!-- Data will be loaded here -->
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- 2. Code Panel -->
                    <div class="code-panel">
                        <div class="panel-header">
                            <div class="panel-search">
                                <input type="text" id="codeSearchCode" class="form-control form-control-sm"
                                    placeholder="코드">
                                <select id="codeSearchUseYn" class="form-select form-select-sm">
                                    <option value="">전체</option>
                                    <option value="Y">사용</option>
                                    <option value="N">미사용</option>
                                </select>
                                <button type="button" id="btnCodeSearch"
                                    class="btn btn-outline-secondary btn-sm">검색</button>
                            </div>
                            <div>
                                <button type="button" class="btn btn-secondary btn-circle btn-add"
                                    data-type="code">+</button>
                                <button type="button" class="btn btn-secondary btn-circle btn-remove"
                                    data-type="code">-</button>
                            </div>
                        </div>
                        <div class="panel-body">
                            <table class="table panel-table table-bordered text-center" id="codeTable">
                                <thead>
                                    <tr>
                                        <th width="5%">선택</th>
                                        <th width="10%">순서</th>
                                        <th width="35%">코드</th>
                                        <th width="40%">코드명</th>
                                        <th width="15%">사용여부</th>
                                    </tr>
                                </thead>
                                <tbody id="codeTbody">
                                    <!-- Data will be loaded here -->
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- 3. Detail Code Panel -->
                    <div class="code-panel">
                        <div class="panel-header">
                            <div class="panel-search">
                                <input type="text" id="detailSearchCode" class="form-control form-control-sm"
                                    placeholder="상세코드">
                                <select id="detailSearchUseYn" class="form-select form-select-sm">
                                    <option value="">전체</option>
                                    <option value="Y">사용</option>
                                    <option value="N">미사용</option>
                                </select>
                                <button type="button" id="btnDetailSearch"
                                    class="btn btn-outline-secondary btn-sm">검색</button>
                            </div>
                            <div>
                                <button type="button" class="btn btn-secondary btn-circle btn-add"
                                    data-type="detail">+</button>
                                <button type="button" class="btn btn-secondary btn-circle btn-remove"
                                    data-type="detail">-</button>
                            </div>
                        </div>
                        <div class="panel-body">
                            <table class="table panel-table table-bordered text-center" id="detailTable">
                                <thead>
                                    <tr>
                                        <th width="5%">선택</th>
                                        <th width="10%">순서</th>
                                        <th width="35%">상세코드</th>
                                        <th width="40%">상세코드명</th>
                                        <th width="15%">사용여부</th>
                                    </tr>
                                </thead>
                                <tbody id="detailTbody">
                                    <!-- Data will be loaded here -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                let currentGroupCode = null;
                let currentCode = null;
                let currentDetailCode = null;

                // Arrays to hold local state (including new items)
                let groupList = [];
                let codeList = [];
                let detailList = [];

                $(document).ready(function () {
                    fn_searchAll();

                    $('#btnSearch').on('click', function () {
                        console.log('Search button clicked');
                        fn_searchAll();
                    });
                    $('#btnSave').on('click', function () {
                        console.log('Save button clicked');
                        fn_saveAll();
                    });
                    $('.btn-add').off('click').on('click', function () {
                        fn_addRow($(this).data('type'));
                    });
                    $('.btn-remove').off('click').on('click', function () {
                        fn_removeRow($(this).data('type'));
                    });

                    $('#btnGroupSearch').on('click', function () {
                        const groupCodeVal = $('#groupSearchCode').val();
                        const useYnVal = $('#groupSearchUseYn').val();
                        fn_searchGroupCodes(groupCodeVal, useYnVal);
                    });

                    $('#btnCodeSearch').on('click', function () {
                        const groupCodeVal = $('#groupSearchCode').val();
                        const codeVal = $('#codeSearchCode').val();
                        const useYnVal = $('#codeSearchUseYn').val();
                        const searchGroupCode = groupCodeVal ? groupCodeVal : '';
                        fn_searchCodes(searchGroupCode, codeVal, useYnVal);
                    });

                    $('#btnDetailSearch').on('click', function () {
                        const groupCodeVal = $('#groupSearchCode').val();
                        const detailCodeVal = $('#detailSearchCode').val();
                        const useYnVal = $('#detailSearchUseYn').val();
                        const searchGroupCode = groupCodeVal ? groupCodeVal : '';
                        fn_searchDetailCodes(searchGroupCode, '', detailCodeVal, useYnVal);
                    });
                });

                function fn_searchAll() {
                    console.log('fn_searchAll execution started');
                    const codeVal = $('#filterCode').val();
                    const useYnVal = $('input[name="topUseYn"]:checked').val();

                    fn_searchGroupCodes(codeVal, useYnVal, { resetDependents: false });
                    fn_searchCodes('', codeVal, useYnVal, { resetDetail: false, updateGroupFromCodes: false });
                    fn_searchDetailCodes('', '', codeVal, useYnVal, { updateCodeFromDetails: false });
                }

                function fn_searchGroupCodes(groupCodeVal, useYnVal, options = {}) {
                    const settings = {
                        resetDependents: true,
                        updateSelect: true,
                        ...options
                    };
                    const searchVO = {
                        groupCode: groupCodeVal,
                        useYn: useYnVal
                    };

                    $.ajax({
                        url: '<c:url value="/admin/basic/selectGroupCodeList.ajax"/>',
                        type: 'POST',
                        data: searchVO,
                        dataType: 'json',
                        success: function (res) {
                            if (res.success) {
                                groupList = res.list.map(item => ({ ...item, status: 'NORMAL' }));
                                fn_renderGroupTable();
                                if (settings.updateSelect) {
                                    fn_renderGroupSelect();
                                }
                                if (settings.resetDependents) {
                                    // 코드와 상세코드 목록 초기화
                                    codeList = [];
                                    detailList = [];
                                    fn_renderCodeTable();
                                    fn_renderDetailTable();
                                }
                            } else {
                                alert(res.message);
                            }
                        },
                        error: function (xhr, status, err) {
                            console.error('fn_searchGroupCodes error:', err);
                        }
                    });
                }

                function fn_searchCodes(groupCodeVal, codeVal, useYnVal, options = {}) {
                    const settings = {
                        resetDetail: true,
                        updateGroupFromCodes: true,
                        ...options
                    };
                    const searchVO = {
                        groupCode: groupCodeVal,
                        code: codeVal,
                        useYn: useYnVal
                    };

                    $.ajax({
                        url: '<c:url value="/admin/basic/searchCodeList.ajax"/>',
                        type: 'POST',
                        data: searchVO,
                        dataType: 'json',
                        success: function (res) {
                            if (res.success) {
                                codeList = res.list.map(item => ({ ...item, status: 'NORMAL' }));
                                fn_renderCodeTable();
                                if (settings.resetDetail) {
                                    // 상세코드 목록 초기화
                                    detailList = [];
                                    fn_renderDetailTable();
                                }
                                if (settings.updateGroupFromCodes) {
                                    // 그룹코드 목록도 업데이트 (해당 코드가 속한 그룹만)
                                    fn_updateGroupListFromCodes(res.list);
                                }
                            } else {
                                alert(res.message);
                            }
                        },
                        error: function (xhr, status, err) {
                            console.error('fn_searchCodes error:', err);
                        }
                    });
                }

                function fn_searchDetailCodes(groupCodeVal, codeVal, detailCodeVal, useYnVal, options = {}) {
                    const settings = {
                        updateCodeFromDetails: true,
                        ...options
                    };
                    const searchVO = {
                        groupCode: groupCodeVal,
                        code: codeVal,
                        detailCode: detailCodeVal,
                        useYn: useYnVal
                    };

                    $.ajax({
                        url: '<c:url value="/admin/basic/searchDetailCodeList.ajax"/>',
                        type: 'POST',
                        data: searchVO,
                        dataType: 'json',
                        success: function (res) {
                            if (res.success) {
                                detailList = res.list.map(item => ({ ...item, status: 'NORMAL' }));
                                fn_renderDetailTable();
                                if (settings.updateCodeFromDetails) {
                                    // 코드와 그룹코드 목록도 업데이트
                                    fn_updateCodeListFromDetails(res.list);
                                }
                            } else {
                                alert(res.message);
                            }
                        },
                        error: function (xhr, status, err) {
                            console.error('fn_searchDetailCodes error:', err);
                        }
                    });
                }

                function fn_updateGroupListFromCodes(codes) {
                    const uniqueGroups = [...new Set(codes.map(c => c.groupCode))];
                    groupList = uniqueGroups.map(gc => ({ groupCode: gc, status: 'NORMAL' }));
                    fn_renderGroupTable();
                    fn_renderGroupSelect();
                }

                function fn_updateCodeListFromDetails(details) {
                    const uniqueCodes = [...new Set(details.map(d => ({ groupCode: d.groupCode, code: d.code })))];
                    codeList = uniqueCodes.map(c => ({ ...c, status: 'NORMAL' }));
                    fn_renderCodeTable();

                    const uniqueGroups = [...new Set(details.map(d => d.groupCode))];
                    groupList = uniqueGroups.map(gc => ({ groupCode: gc, status: 'NORMAL' }));
                    fn_renderGroupTable();
                    fn_renderGroupSelect();
                }

                function fn_renderGroupTable() {
                    const tbody = $('#groupTbody');
                    tbody.empty();
                    groupList.forEach((item, index) => {
                        if (item.status === 'DELETED') return;

                        const tr = $('<tr>').attr('data-index', index);
                        if (currentGroupCode === item.groupCode && item.groupCode) tr.addClass('selected');

                        const tdSelect = $('<td>').append($('<input type="checkbox" class="row-select">'));
                        tr.append(tdSelect);

                        // Group Code (Editable if NEW)
                        const tdCode = $('<td>');
                        if (item.status === 'NEW') {
                            tdCode.append($('<input>').val(item.groupCode).on('change', function () { item.groupCode = $(this).val(); }));
                        } else {
                            tdCode.text(item.groupCode);
                        }
                        tr.append(tdCode);

                        tr.append($('<td>').append($('<input>').val(item.groupCodeName).on('change', function () { item.groupCodeName = $(this).val(); if (item.status === 'NORMAL') item.status = 'UPDATED'; })));

                        const selUseYn = $('<select class="form-select form-select-sm">')
                            .append('<option value="Y">사용</option>')
                            .append('<option value="N">미사용</option>')
                            .val((item.useYn === '사용' || item.useYn === 'Y') ? 'Y' : 'N')
                            .on('change', function () { item.useYn = $(this).val(); if (item.status === 'NORMAL') item.status = 'UPDATED'; });
                        tr.append($('<td>').append(selUseYn));

                        tr.on('click', function (e) {
                            if ($(e.target).is('input, select')) return;
                            tbody.find('tr').removeClass('selected');
                            $(this).addClass('selected');

                            if (item.status === 'NEW' && !item.groupCode) {
                                alert('그룹코드를 먼저 입력해주세요.');
                                return;
                            }

                            currentGroupCode = item.groupCode;
                            fn_loadCodeList(currentGroupCode);
                        });

                        tbody.append(tr);
                    });

                    if (!currentGroupCode) {
                        $('#codeTbody').empty();
                        $('#detailTbody').empty();
                    }
                }

                function fn_renderGroupSelect() {
                    const datalist = $('#groupCodeList');
                    datalist.empty();

                    groupList.forEach(item => {
                        if (item.status === 'DELETED') return;
                        const label = item.groupCodeName ? item.groupCodeName + ' (' + item.groupCode + ')' : item.groupCode;
                        datalist.append('<option value="' + item.groupCode + '">' + label + '</option>');
                    });
                }

                function fn_loadCodeList(groupCode) {
                    $.ajax({
                        url: '<c:url value="/admin/basic/selectCodeList.ajax"/>',
                        type: 'POST',
                        data: { groupCode: groupCode },
                        dataType: 'json',
                        success: function (res) {
                            if (res.success) {
                                codeList = res.list.map(item => ({ ...item, status: 'NORMAL' }));
                                fn_renderCodeTable();
                            }
                        }
                    });
                }

                function fn_renderCodeTable() {
                    const tbody = $('#codeTbody');
                    tbody.empty();
                    codeList.forEach((item, index) => {
                        if (item.status === 'DELETED') return;

                        const tr = $('<tr>').attr('data-index', index);
                        if (currentCode === item.code && item.code) tr.addClass('selected');

                        // Code (Editable if NEW)
                        tr.append($('<td>').append($('<input type="checkbox" class="row-select">')));
                        tr.append($('<td>').append($('<input type="number">').val(item.sortOrder).on('change', function () { item.sortOrder = $(this).val(); if (item.status === 'NORMAL') item.status = 'UPDATED'; })));

                        const tdCode = $('<td>');
                        if (item.status === 'NEW') {
                            tdCode.append($('<input>').val(item.code).on('change', function () { item.code = $(this).val(); }));
                        } else {
                            tdCode.text(item.code);
                        }
                        tr.append(tdCode);
                        tr.append($('<td>').append($('<input>').val(item.codeName).on('change', function () { item.codeName = $(this).val(); if (item.status === 'NORMAL') item.status = 'UPDATED'; })));

                        const selUseYn = $('<select class="form-select form-select-sm">')
                            .append('<option value="Y">사용</option>')
                            .append('<option value="N">미사용</option>')
                            .val((item.useYn === '사용' || item.useYn === 'Y') ? 'Y' : 'N')
                            .on('change', function () { item.useYn = $(this).val(); if (item.status === 'NORMAL') item.status = 'UPDATED'; });
                        tr.append($('<td>').append(selUseYn));

                        tr.on('click', function (e) {
                            if ($(e.target).is('input, select')) return;
                            tbody.find('tr').removeClass('selected');
                            $(this).addClass('selected');

                            if (item.status === 'NEW' && !item.code) {
                                alert('코드를 먼저 입력해주세요.');
                                return;
                            }

                            currentCode = item.code;
                            fn_loadDetailCodeList(currentGroupCode, currentCode);
                        });
                        tbody.append(tr);
                    });
                    if (!currentCode) $('#detailTbody').empty();
                }

                function fn_loadCodeOptions(groupCode) {
                    $.ajax({
                        url: '<c:url value="/admin/basic/selectCodeList.ajax"/>',
                        type: 'POST',
                        data: { groupCode: groupCode },
                        dataType: 'json',
                        success: function (res) {
                            if (res.success) {
                                fn_renderCodeSelect(res.list || []);
                            }
                        }
                    });
                }

                function fn_renderCodeSelect(list) {
                    const datalist = $('#codeOptionsList');
                    datalist.empty();

                    list.forEach(item => {
                        const label = item.codeName ? item.codeName + ' (' + item.code + ')' : item.code;
                        datalist.append('<option value="' + item.code + '">' + label + '</option>');
                    });
                }

                function fn_loadDetailCodeList(groupCode, code) {
                    $.ajax({
                        url: '<c:url value="/admin/basic/selectDetailCodeList.ajax"/>',
                        type: 'POST',
                        data: { groupCode: groupCode, code: code },
                        dataType: 'json',
                        success: function (res) {
                            if (res.success) {
                                detailList = res.list.map(item => ({ ...item, status: 'NORMAL' }));
                                fn_renderDetailTable();
                            }
                        }
                    });
                }

                function fn_loadDetailOptions(groupCode, code) {
                    $.ajax({
                        url: '<c:url value="/admin/basic/selectDetailCodeList.ajax"/>',
                        type: 'POST',
                        data: { groupCode: groupCode, code: code },
                        dataType: 'json',
                        success: function (res) {
                            if (res.success) {
                                fn_renderDetailSelect(res.list || []);
                            }
                        }
                    });
                }

                function fn_renderDetailSelect(list) {
                    const datalist = $('#detailOptionsList');
                    datalist.empty();

                    list.forEach(item => {
                        const label = item.detailCodeName ? item.detailCodeName + ' (' + item.detailCode + ')' : item.detailCode;
                        datalist.append('<option value="' + item.detailCode + '">' + label + '</option>');
                    });
                }

                function fn_renderDetailTable() {
                    const tbody = $('#detailTbody');
                    tbody.empty();
                    detailList.forEach((item, index) => {
                        if (item.status === 'DELETED') return;

                        const tr = $('<tr>').attr('data-index', index);
                        if (currentDetailCode === item.detailCode && item.detailCode) tr.addClass('selected');

                        // Detail Code (Editable if NEW)
                        tr.append($('<td>').append($('<input type="checkbox" class="row-select">')));
                        tr.append($('<td>').append($('<input type="number">').val(item.sortOrder).on('change', function () { item.sortOrder = $(this).val(); if (item.status === 'NORMAL') item.status = 'UPDATED'; })));

                        const tdCode = $('<td>');
                        if (item.status === 'NEW') {
                            tdCode.append($('<input>').val(item.detailCode).on('change', function () { item.detailCode = $(this).val(); }));
                        } else {
                            tdCode.text(item.detailCode);
                        }
                        tr.append(tdCode);
                        tr.append($('<td>').append($('<input>').val(item.detailCodeName).on('change', function () { item.detailCodeName = $(this).val(); if (item.status === 'NORMAL') item.status = 'UPDATED'; })));

                        const selUseYn = $('<select class="form-select form-select-sm">')
                            .append('<option value="Y">사용</option>')
                            .append('<option value="N">미사용</option>')
                            .val((item.useYn === '사용' || item.useYn === 'Y') ? 'Y' : 'N')
                            .on('change', function () { item.useYn = $(this).val(); if (item.status === 'NORMAL') item.status = 'UPDATED'; });
                        tr.append($('<td>').append(selUseYn));

                        tr.on('click', function (e) {
                            if ($(e.target).is('input, select')) return;
                            tbody.find('tr').removeClass('selected');
                            $(this).addClass('selected');
                            currentDetailCode = item.detailCode;
                        });

                        tbody.append(tr);
                    });
                }

                function fn_addRow(type) {
                    if (type === 'group') {
                        groupList.push({ groupCode: '', groupCodeName: '', useYn: 'Y', status: 'NEW' });
                        fn_renderGroupTable();
                    } else if (type === 'code') {
                        if (!currentGroupCode) { alert('그룹코드를 선택해주세요.'); return; }
                        codeList.push({ groupCode: currentGroupCode, code: '', codeName: '', sortOrder: codeList.length + 1, useYn: 'Y', status: 'NEW' });
                        fn_renderCodeTable();
                    } else if (type === 'detail') {
                        if (!currentCode) { alert('코드를 선택해주세요.'); return; }
                        detailList.push({ groupCode: currentGroupCode, code: currentCode, detailCode: '', detailCodeName: '', sortOrder: detailList.length + 1, useYn: 'Y', status: 'NEW' });
                        fn_renderDetailTable();
                    }
                }

                function fn_removeRow(type) {
                    let list, renderFn, tbody;
                    if (type === 'group') { list = groupList; renderFn = fn_renderGroupTable; tbody = $('#groupTbody'); }
                    else if (type === 'code') { list = codeList; renderFn = fn_renderCodeTable; tbody = $('#codeTbody'); }
                    else if (type === 'detail') { list = detailList; renderFn = fn_renderDetailTable; tbody = $('#detailTbody'); }

                    const selectedRows = tbody.find('input.row-select:checked').closest('tr');
                    if (selectedRows.length === 0) {
                        alert('삭제할 행을 선택해주세요.');
                        return;
                    }

                    const indices = selectedRows.map(function () { return Number($(this).attr('data-index')); }).get().sort((a, b) => b - a);
                    indices.forEach(index => {
                        if (Number.isNaN(index) || index < 0) return;
                        const item = list[index];
                        if (!item) return;
                        if (item.status === 'NEW') {
                            list.splice(index, 1);
                        } else {
                            item.status = 'DELETED';
                        }
                        if (type === 'group' && item.groupCode === currentGroupCode) {
                            currentGroupCode = null;
                            currentCode = null;
                            currentDetailCode = null;
                            codeList = [];
                            detailList = [];
                            fn_renderCodeTable();
                            fn_renderDetailTable();
                        }
                        if (type === 'code' && item.code === currentCode) {
                            currentCode = null;
                            currentDetailCode = null;
                            detailList = [];
                            fn_renderDetailTable();
                        }
                        if (type === 'detail' && item.detailCode === currentDetailCode) {
                            currentDetailCode = null;
                        }
                    });
                    renderFn();
                }

                function fn_saveAll() {
                    console.log('fn_saveAll execution started');
                    if (!confirm('모든 변경사항을 저장하시겠습니까?')) return;

                    const groupsToSave = groupList.filter(item => item.status !== 'NORMAL');
                    const codesToSave = codeList.filter(item => item.status !== 'NORMAL');
                    const detailsToSave = detailList.filter(item => item.status !== 'NORMAL');

                    if (groupsToSave.length === 0 && codesToSave.length === 0 && detailsToSave.length === 0) {
                        alert('변경사항이 없습니다.');
                        return;
                    }

                    const savePromises = [];

                    groupsToSave.forEach(item => {
                        let url = '<c:url value="/admin/basic/saveGroupCode.ajax"/>';
                        if (item.status === 'DELETED') url = '<c:url value="/admin/basic/deleteGroupCode.ajax"/>';
                        savePromises.push($.ajax({ url: url, type: 'POST', data: item, dataType: 'json' }));
                    });

                    codesToSave.forEach(item => {
                        savePromises.push($.ajax({ url: '<c:url value="/admin/basic/saveCode.ajax"/>', type: 'POST', data: item, dataType: 'json' }));
                    });

                    detailsToSave.forEach(item => {
                        savePromises.push($.ajax({ url: '<c:url value="/admin/basic/saveDetailCode.ajax"/>', type: 'POST', data: item, dataType: 'json' }));
                    });

                    Promise.all(savePromises).then(() => {
                        alert('저장되었습니다.');
                        fn_search();
                    }).catch(err => {
                        alert('저장 중 오류가 발생했습니다.');
                        console.error('fn_saveAll error:', err);
                    });
                }
            </script>
