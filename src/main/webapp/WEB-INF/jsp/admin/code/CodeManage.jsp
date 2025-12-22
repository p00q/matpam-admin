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
                    justify-content: flex-end;
                    align-items: center;
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

                .panel-table input {
                    width: 100%;
                    border: none;
                    background: transparent;
                    text-align: center;
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
                            <div class="col-md-3">
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text fw-bold">그룹코드</span>
                                    <input type="text" id="filterGroupCode" class="form-control" list="groupCodeList"
                                        placeholder="입력/선택">
                                    <datalist id="groupCodeList"></datalist>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text fw-bold">코드</span>
                                    <input type="text" id="filterCode" class="form-control" list="codeOptionsList"
                                        placeholder="입력/선택">
                                    <datalist id="codeOptionsList"></datalist>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text fw-bold">상세코드</span>
                                    <input type="text" id="filterDetailCode" class="form-control"
                                        list="detailOptionsList" placeholder="입력/선택">
                                    <datalist id="detailOptionsList"></datalist>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text fw-bold">사용여부</span>
                                    <select id="searchUseYn" class="form-select">
                                        <option value="">전체</option>
                                        <option value="Y">사용</option>
                                        <option value="N">미사용</option>
                                    </select>
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
                            <button class="btn btn-secondary btn-circle" onclick="fn_addRow('group')">+</button>
                            <button class="btn btn-secondary btn-circle" onclick="fn_removeRow('group')">-</button>
                        </div>
                        <div class="panel-body">
                            <table class="table panel-table table-bordered text-center" id="groupTable">
                                <thead>
                                    <tr>
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
                            <button class="btn btn-secondary btn-circle" onclick="fn_addRow('code')">+</button>
                            <button class="btn btn-secondary btn-circle" onclick="fn_removeRow('code')">-</button>
                        </div>
                        <div class="panel-body">
                            <table class="table panel-table table-bordered text-center" id="codeTable">
                                <thead>
                                    <tr>
                                        <th width="35%">코드</th>
                                        <th width="40%">코드명</th>
                                        <th width="10%">순서</th>
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
                            <button class="btn btn-secondary btn-circle" onclick="fn_addRow('detail')">+</button>
                            <button class="btn btn-secondary btn-circle" onclick="fn_removeRow('detail')">-</button>
                        </div>
                        <div class="panel-body">
                            <table class="table panel-table table-bordered text-center" id="detailTable">
                                <thead>
                                    <tr>
                                        <th width="25%">코드</th>
                                        <th width="20%">순서</th>
                                        <th width="35%">상세코드명</th>
                                        <th width="20%">사용여부</th>
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
                    fn_search();

                    $('#btnSearch').on('click', function () {
                        console.log('Search button clicked');
                        fn_search();
                    });
                    $('#btnSave').on('click', function () {
                        console.log('Save button clicked');
                        fn_saveAll();
                    });

                    $('#filterGroupCode').on('change', function () {
                        const val = $(this).val();
                        console.log('Group filter changed:', val);
                        fn_renderCodeSelect([]);
                        fn_renderDetailSelect([]);
                        if (val) fn_loadCodeOptions(val);
                    });

                    $('#filterCode').on('change', function () {
                        const gVal = $('#filterGroupCode').val();
                        const cVal = $(this).val();
                        console.log('Code filter changed:', cVal);
                        fn_renderDetailSelect([]);
                        if (gVal && cVal) fn_loadDetailOptions(gVal, cVal);
                    });
                });

                function fn_search() {
                    console.log('fn_search execution started');
                    const groupCodeVal = $('#filterGroupCode').val();
                    const codeVal = $('#filterCode').val();
                    const detailCodeVal = $('#filterDetailCode').val();
                    const useYnVal = $('#searchUseYn').val();

                    // 검색 조건에 따라 적절한 테이블 조회
                    if (detailCodeVal) {
                        // 상세코드가 있으면 상세코드 테이블 조회
                        fn_searchDetailCodes(groupCodeVal, codeVal, detailCodeVal, useYnVal);
                    } else if (codeVal) {
                        // 코드가 있으면 코드 테이블 조회
                        fn_searchCodes(groupCodeVal, codeVal, useYnVal);
                    } else {
                        // 그룹코드만 있으면 그룹코드 테이블 조회
                        fn_searchGroupCodes(groupCodeVal, useYnVal);
                    }
                }

                function fn_searchGroupCodes(groupCodeVal, useYnVal) {
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
                                fn_renderGroupSelect();
                                // 코드와 상세코드 목록 초기화
                                codeList = [];
                                detailList = [];
                                fn_renderCodeTable();
                                fn_renderDetailTable();
                            } else {
                                alert(res.message);
                            }
                        },
                        error: function (xhr, status, err) {
                            console.error('fn_searchGroupCodes error:', err);
                        }
                    });
                }

                function fn_searchCodes(groupCodeVal, codeVal, useYnVal) {
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
                                // 상세코드 목록 초기화
                                detailList = [];
                                fn_renderDetailTable();
                                // 그룹코드 목록도 업데이트 (해당 코드가 속한 그룹만)
                                fn_updateGroupListFromCodes(res.list);
                            } else {
                                alert(res.message);
                            }
                        },
                        error: function (xhr, status, err) {
                            console.error('fn_searchCodes error:', err);
                        }
                    });
                }

                function fn_searchDetailCodes(groupCodeVal, codeVal, detailCodeVal, useYnVal) {
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
                                // 코드와 그룹코드 목록도 업데이트
                                fn_updateCodeListFromDetails(res.list);
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
                        const tdCode = $('<td>');
                        if (item.status === 'NEW') {
                            tdCode.append($('<input>').val(item.code).on('change', function () { item.code = $(this).val(); }));
                        } else {
                            tdCode.text(item.code);
                        }
                        tr.append(tdCode);

                        tr.append($('<td>').append($('<input type="number">').val(item.sortOrder).on('change', function () { item.sortOrder = $(this).val(); if (item.status === 'NORMAL') item.status = 'UPDATED'; })));
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
                        const tdCode = $('<td>');
                        if (item.status === 'NEW') {
                            tdCode.append($('<input>').val(item.detailCode).on('change', function () { item.detailCode = $(this).val(); }));
                        } else {
                            tdCode.text(item.detailCode);
                        }
                        tr.append(tdCode);

                        tr.append($('<td>').append($('<input type="number">').val(item.sortOrder).on('change', function () { item.sortOrder = $(this).val(); if (item.status === 'NORMAL') item.status = 'UPDATED'; })));
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

                    const selectedTr = tbody.find('tr.selected');
                    if (selectedTr.length === 0) {
                        alert('삭제할 행을 선택해주세요.');
                        return;
                    }

                    const index = selectedTr.attr('data-index');

                    if (index >= 0) {
                        const item = list[index];
                        if (item.status === 'NEW') {
                            list.splice(index, 1);
                        } else {
                            item.status = 'DELETED';
                        }
                        renderFn();
                    }
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