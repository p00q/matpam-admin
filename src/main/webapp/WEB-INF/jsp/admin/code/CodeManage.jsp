<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    /* Premium 3-Column Dashboard Layout */
    .dashboard-container {
        display: grid;
        grid-template-columns: 320px 1fr 1.2fr;
        gap: 1.5rem;
        height: calc(100vh - 220px);
        min-height: 600px;
    }

    .column-panel {
        display: flex;
        flex-direction: column;
        background: white;
        border-radius: var(--radius-md);
        box-shadow: var(--shadow-sm);
        border: 1px solid var(--border-color);
        overflow: hidden;
        transition: var(--transition);
    }

    .column-panel:hover {
        box-shadow: var(--shadow-md);
    }

    .panel-header {
        padding: 1.25rem;
        background: #fcfcfd;
        border-bottom: 1px solid var(--border-color);
        display: flex;
        flex-direction: column;
        gap: 0.75rem;
    }

    .panel-title {
        font-weight: 700;
        font-size: 0.95rem;
        color: var(--primary);
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .panel-body {
        flex: 1;
        overflow-y: auto;
        padding: 0;
    }

    /* List Item Styles */
    .code-item {
        padding: 1rem 1.25rem;
        border-bottom: 1px solid var(--border-color);
        cursor: pointer;
        transition: all 0.2s ease;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .code-item:hover {
        background-color: #f8f9fa;
    }

    .code-item.active {
        background-color: rgba(234, 179, 8, 0.05);
        border-right: 4px solid var(--accent);
    }

    .code-item.active .code-label {
        font-weight: 700;
        color: var(--primary);
    }

    .code-name {
        font-size: 0.9rem;
        color: var(--text-muted);
        margin-top: 0.25rem;
    }

    /* Table Adjustments for Panels */
    .panel-table {
        width: 100%;
        font-size: 0.9rem;
    }

    .panel-table th {
        background: #f8f9fa;
        padding: 0.75rem 0.5rem;
        font-weight: 600;
        font-size: 0.8rem;
        color: var(--text-muted);
        text-transform: uppercase;
        letter-spacing: 0.5px;
        position: sticky;
        top: 0;
        z-index: 10;
        border-bottom: 1px solid var(--border-color);
    }

    .panel-table td {
        padding: 0.75rem 0.5rem;
        border-bottom: 1px solid var(--border-color);
        vertical-align: middle;
    }

    .status-dot {
        width: 8px;
        height: 8px;
        border-radius: 50%;
        display: inline-block;
        margin-right: 5px;
    }

    .status-new { background-color: var(--accent); }
    .status-updated { background-color: var(--primary); }
</style>

<div class="animate-fade-in">
    <!-- Page Header & Global Actions -->
    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1" style="font-size: 0.85rem;">
                    <li class="breadcrumb-item text-muted">시스템 설정</li>
                    <li class="breadcrumb-item active">공통코드 관리</li>
                </ol>
            </nav>
            <h3 class="fw-bold mb-0" style="letter-spacing: -1px; color: var(--primary);">시스템 <span class="text-accent" style="color:var(--accent)">공통코드 대시보드</span></h3>
        </div>
        <div class="gap-2 d-flex">
            <button type="button" class="btn btn-outline-secondary btn-premium px-4 shadow-sm" onclick="fn_searchAll()">
                <i class="bi bi-arrow-clockwise me-2"></i>초기화
            </button>
            <button type="button" class="btn btn-primary btn-premium px-4 shadow-sm" onclick="fn_saveAll()">
                <i class="bi bi-check-all me-2"></i>모든 변경사항 저장
            </button>
        </div>
    </div>

    <!-- Global Filter Card -->
    <div class="premium-card p-3 mb-4 bg-white border-0 shadow-sm">
        <div class="row g-3 align-items-center">
            <div class="col-md-4">
                <div class="input-group">
                    <span class="input-group-text bg-light border-0"><i class="bi bi-search"></i></span>
                    <input type="text" id="filterCode" class="form-control border-0 bg-light bg-opacity-50" placeholder="그룹/코드명 통합 검색...">
                </div>
            </div>
            <div class="col-md-3">
                <div class="btn-group w-100" role="group">
                    <input type="radio" class="btn-check" name="topUseYn" id="topUseYnY" value="Y" checked onclick="fn_searchAll()">
                    <label class="btn btn-outline-secondary" for="topUseYnY">사용 중</label>
                    <input type="radio" class="btn-check" name="topUseYn" id="topUseYnN" value="N" onclick="fn_searchAll()">
                    <label class="btn btn-outline-secondary" for="topUseYnN">미사용</label>
                </div>
            </div>
            <div class="col-auto ms-auto">
                <button type="button" class="btn btn-primary btn-premium px-4" onclick="fn_searchAll()">조회</button>
            </div>
        </div>
    </div>

    <!-- 3-Column Dashboard -->
    <div class="dashboard-container">
        <!-- 1. Group Codes (Sidebar-style List) -->
        <div class="column-panel">
            <div class="panel-header">
                <div class="panel-title text-uppercase tracking-wider">
                    <i class="bi bi-grid-3x3-gap-fill"></i> 그룹 코드
                    <span class="badge bg-light text-primary ms-auto" id="group_count">0</span>
                </div>
                <div class="d-flex gap-2">
                    <div class="input-group input-group-sm">
                        <input type="text" id="groupSearchCode" class="form-control border-light-subtle" placeholder="필터...">
                        <button class="btn btn-light border-light-subtle" onclick="fn_addRow('group')"><i class="bi bi-plus-lg"></i></button>
                    </div>
                </div>
            </div>
            <div class="panel-body" id="groupListBody">
                <!-- Group items rendered here -->
            </div>
        </div>

        <!-- 2. Codes (Master List) -->
        <div class="column-panel">
            <div class="panel-header">
                <div class="panel-title text-uppercase tracking-wider">
                    <i class="bi bi-list-ul"></i> 상세 분류 코드
                    <span class="badge bg-light text-primary ms-auto" id="code_count">0</span>
                </div>
                <div class="d-flex gap-2">
                    <div class="input-group input-group-sm">
                        <input type="text" id="codeSearchCode" class="form-control border-light-subtle" placeholder="코드명 검색...">
                        <button class="btn btn-light border-light-subtle" onclick="fn_addRow('code')"><i class="bi bi-plus-lg"></i></button>
                    </div>
                </div>
            </div>
            <div class="panel-body">
                <table class="panel-table text-center" id="codeTable">
                    <thead>
                        <tr>
                            <th width="15%">순서</th>
                            <th width="35%">코드</th>
                            <th width="40%">코드명</th>
                            <th width="10%"><i class="bi bi-trash"></i></th>
                        </tr>
                    </thead>
                    <tbody id="codeTbody">
                        <!-- Code items rendered here -->
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 3. Detail Codes (Configuration) -->
        <div class="column-panel">
            <div class="panel-header">
                <div class="panel-title text-uppercase tracking-wider">
                    <i class="bi bi-gear-wide-connected"></i> 실행상세값 (Detail)
                    <span class="badge bg-light text-primary ms-auto" id="detail_count">0</span>
                </div>
                <div class="d-flex gap-2">
                    <div class="input-group input-group-sm">
                        <input type="text" id="detailSearchCode" class="form-control border-light-subtle" placeholder="상세코드 필터...">
                        <button class="btn btn-light border-light-subtle" onclick="fn_addRow('detail')"><i class="bi bi-plus-lg"></i></button>
                    </div>
                </div>
            </div>
            <div class="panel-body">
                <table class="panel-table text-center" id="detailTable">
                    <thead>
                        <tr>
                            <th width="12%">순서</th>
                            <th width="30%">상세코드</th>
                            <th width="35%">상세코드명</th>
                            <th width="15%">사용</th>
                            <th width="8%"><i class="bi bi-trash"></i></th>
                        </tr>
                    </thead>
                    <tbody id="detailTbody">
                        <!-- Detail items rendered here -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    let currentGroupCode = null;
    let currentCode = null;
    
    let groupList = [];
    let codeList = [];
    let detailList = [];

    $(document).ready(function() {
        fn_searchAll();
        
        // 실시간 필터링 바인딩
        $('#groupSearchCode').on('keyup', function() { fn_renderGroupList(); });
        $('#codeSearchCode').on('keyup', function() { fn_renderCodeTable(); });
        $('#detailSearchCode').on('keyup', function() { fn_renderDetailTable(); });
    });

    /**
     * 전역 검색 실행
     */
    function fn_searchAll() {
        const keyword = $('#filterCode').val();
        const useYn = $('input[name="topUseYn"]:checked').val();

        $.ajax({
            url: '<c:url value="/admin/basic/selectGroupCodeList.ajax"/>',
            type: 'POST',
            data: { groupCode: keyword, useYn: useYn },
            success: function(res) {
                if (res.success) {
                    groupList = res.list.map(item => ({ ...item, status: 'NORMAL' }));
                    fn_renderGroupList();
                    // 초기화 시 첫번째 그룹 자동 선택 방지 (안정성)
                    $('#codeTbody').empty();
                    $('#detailTbody').empty();
                    $('#code_count, #detail_count').text('0');
                }
            }
        });
    }

    /**
     * 1. 그룹 목록 렌더링 (사이드바 스타일)
     */
    function fn_renderGroupList() {
        const container = $('#groupListBody');
        const filter = $('#groupSearchCode').val().toLowerCase();
        container.empty();
        
        let displayCount = 0;
        groupList.forEach((item, index) => {
            if (item.status === 'DELETED') return;
            if (filter && !item.groupCode.toLowerCase().includes(filter) && !item.groupCodeName.toLowerCase().includes(filter)) return;

            displayCount++;
            const isActive = currentGroupCode === item.groupCode;
            let statusBadge = '';
            if (item.status === 'NEW') statusBadge = '<span class="status-dot status-new"></span>';
            else if (item.status === 'UPDATED') statusBadge = '<span class="status-dot status-updated"></span>';

            const itemHtml = `
                <div class="code-item ${isActive ? 'active' : ''}" onclick="fn_selectGroup(${index})">
                    <div>
                        <div class="code-label fs-6">${statusBadge}${item.groupCodeName || '(신규)'}</div>
                        <div class="code-name small">${item.groupCode || 'NEW_CODE'}</div>
                    </div>
                    <i class="bi bi-chevron-right text-muted small"></i>
                </div>
            `;
            container.append(itemHtml);
        });
        $('#group_count').text(displayCount);
    }

    function fn_selectGroup(index) {
        const item = groupList[index];
        currentGroupCode = item.groupCode;
        currentCode = null;
        
        fn_renderGroupList();
        fn_loadCodeList(currentGroupCode);
    }

    /**
     * 2. 코드 목록 렌더링 (테이블)
     */
    function fn_loadCodeList(groupCode) {
        $.ajax({
            url: '<c:url value="/admin/basic/selectCodeList.ajax"/>',
            type: 'POST',
            data: { groupCode: groupCode },
            success: function(res) {
                if (res.success) {
                    codeList = res.list.map(item => ({ ...item, status: 'NORMAL' }));
                    fn_renderCodeTable();
                    $('#detailTbody').empty();
                    $('#detail_count').text('0');
                }
            }
        });
    }

    function fn_renderCodeTable() {
        const tbody = $('#codeTbody');
        const filter = $('#codeSearchCode').val().toLowerCase();
        tbody.empty();

        let displayCount = 0;
        codeList.forEach((item, index) => {
            if (item.status === 'DELETED') return;
            if (filter && !item.code.toLowerCase().includes(filter) && !item.codeName.toLowerCase().includes(filter)) return;

            displayCount++;
            const isActive = currentCode === item.code;
            const rowClass = isActive ? 'bg-light fw-bold' : '';

            const tr = `
                <tr class="${rowClass}" onclick="fn_selectCode(${index})">
                    <td><input type="number" class="form-control form-control-sm text-center border-0 bg-transparent" value="${item.sortOrder}" onchange="fn_updateItem('code', ${index}, 'sortOrder', this.value)"></td>
                    <td class="small">${item.status === 'NEW' ? `<input type='text' class='form-control form-control-sm' value='${item.code}' onchange="fn_updateItem('code', ${index}, 'code', this.value)">` : item.code}</td>
                    <td><input type="text" class="form-control form-control-sm text-center border-0 bg-transparent" value="${item.codeName}" onchange="fn_updateItem('code', ${index}, 'codeName', this.value)"></td>
                    <td><button class="btn btn-link link-danger p-0" onclick="fn_deleteItem('code', ${index})"><i class="bi bi-x-circle"></i></button></td>
                </tr>
            `;
            tbody.append(tr);
        });
        $('#code_count').text(displayCount);
    }

    function fn_selectCode(index) {
        const item = codeList[index];
        currentCode = item.code;
        fn_renderCodeTable();
        fn_loadDetailCodeList(currentGroupCode, currentCode);
    }

    /**
     * 3. 상세 코드 렌더링 (테이블)
     */
    function fn_loadDetailCodeList(groupCode, code) {
        $.ajax({
            url: '<c:url value="/admin/basic/selectDetailCodeList.ajax"/>',
            type: 'POST',
            data: { groupCode: groupCode, code: code },
            success: function(res) {
                if (res.success) {
                    detailList = res.list.map(item => ({ ...item, status: 'NORMAL' }));
                    fn_renderDetailTable();
                }
            }
        });
    }

    function fn_renderDetailTable() {
        const tbody = $('#detailTbody');
        const filter = $('#detailSearchCode').val().toLowerCase();
        tbody.empty();

        let displayCount = 0;
        detailList.forEach((item, index) => {
            if (item.status === 'DELETED') return;
            if (filter && !item.detailCode.toLowerCase().includes(filter) && !item.detailCodeName.toLowerCase().includes(filter)) return;

            displayCount++;
            const checked = (item.useYn === 'Y' || item.useYn === '사용') ? 'checked' : '';

            const tr = `
                <tr>
                    <td><input type="number" class="form-control form-control-sm text-center border-0 bg-transparent" value="${item.sortOrder}" onchange="fn_updateItem('detail', ${index}, 'sortOrder', this.value)"></td>
                    <td class="small">${item.status === 'NEW' ? `<input type='text' class='form-control form-control-sm' value='${item.detailCode}' onchange="fn_updateItem('detail', ${index}, 'detailCode', this.value)">` : item.detailCode}</td>
                    <td><input type="text" class="form-control form-control-sm text-center border-0 bg-transparent" value="${item.detailCodeName}" onchange="fn_updateItem('detail', ${index}, 'detailCodeName', this.value)"></td>
                    <td><div class="form-check form-switch d-flex justify-content-center"><input class="form-check-input" type="checkbox" ${checked} onchange="fn_updateItem('detail', ${index}, 'useYn', this.checked ? 'Y' : 'N')"></div></td>
                    <td><button class="btn btn-link link-danger p-0" onclick="fn_deleteItem('detail', ${index})"><i class="bi bi-x-circle"></i></button></td>
                </tr>
            `;
            tbody.append(tr);
        });
        $('#detail_count').text(displayCount);
    }

    /**
     * Common Utilities
     */
    function fn_addRow(type) {
        if (type === 'group') {
            // 그룹 추가는 모달이나 프롬프트를 사용하는 것이 안전 (코드가 필수이므로)
            const code = prompt('새 그룹 코드를 입력하세요:');
            const name = prompt('새 그룹 코드명을 입력하세요:');
            if (code && name) {
                groupList.push({ groupCode: code, groupCodeName: name, useYn: 'Y', status: 'NEW' });
                fn_renderGroupList();
            }
        } else if (type === 'code') {
            if (!currentGroupCode) { fn_toast('그룹 코드를 먼저 선택하세요.', 'danger'); return; }
            codeList.push({ groupCode: currentGroupCode, code: '', codeName: '신규 코드', sortOrder: codeList.length + 1, useYn: 'Y', status: 'NEW' });
            fn_renderCodeTable();
        } else if (type === 'detail') {
            if (!currentCode) { fn_toast('코드를 먼저 선택하세요.', 'danger'); return; }
            detailList.push({ groupCode: currentGroupCode, code: currentCode, detailCode: '', detailCodeName: '신규 상세코드', sortOrder: detailList.length + 1, useYn: 'Y', status: 'NEW' });
            fn_renderDetailTable();
        }
    }

    function fn_updateItem(type, index, field, value) {
        let list = (type === 'group') ? groupList : (type === 'code' ? codeList : detailList);
        list[index][field] = value;
        if (list[index].status === 'NORMAL') list[index].status = 'UPDATED';
        
        if (type === 'group') fn_renderGroupList();
    }

    function fn_deleteItem(type, index) {
        if (!confirm('삭제하시겠습니까? (저장 시 반영됩니다)')) return;
        let list = (type === 'group') ? groupList : (type === 'code' ? codeList : detailList);
        
        if (list[index].status === 'NEW') list.splice(index, 1);
        else list[index].status = 'DELETED';

        if (type === 'code') fn_renderCodeTable();
        else if (type === 'detail') fn_renderDetailTable();
    }

    function fn_saveAll() {
        if (!confirm('모든 변경사항을 저장하시겠습니까?')) return;

        const savePromises = [];
        groupList.filter(i => i.status !== 'NORMAL').forEach(i => {
            savePromises.push($.ajax({ url: i.status === 'DELETED' ? '<c:url value="/admin/basic/deleteGroupCode.ajax"/>' : '<c:url value="/admin/basic/saveGroupCode.ajax"/>', type: 'POST', data: i }));
        });
        codeList.filter(i => i.status !== 'NORMAL').forEach(i => {
            savePromises.push($.ajax({ url: '<c:url value="/admin/basic/saveCode.ajax"/>', type: 'POST', data: i }));
        });
        detailList.filter(i => i.status !== 'NORMAL').forEach(i => {
            savePromises.push($.ajax({ url: '<c:url value="/admin/basic/saveDetailCode.ajax"/>', type: 'POST', data: i }));
        });

        if (savePromises.length === 0) { fn_toast('변경사항이 없습니다.', 'info'); return; }

        Promise.all(savePromises).then(() => {
            fn_toast('모든 데이터가 성공적으로 저장되었습니다.', 'success');
            fn_searchAll();
        }).catch(() => {
            fn_toast('저장 중 오류가 발생했습니다.', 'danger');
        });
    }
</script>
