<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>

<div class="animate-fade-in">
    <!-- Breadcrumb & Title -->
    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1" style="font-size: 0.85rem;">
                    <li class="breadcrumb-item text-muted">회원 관리</li>
                    <li class="breadcrumb-item active">회원 목록</li>
                </ol>
            </nav>
            <h3 class="fw-bold mb-0" style="letter-spacing: -1px; color: var(--primary);">회원 <span class="text-accent" style="color:var(--accent)">현황</span></h3>
        </div>
        <div>
            <button type="button" class="btn btn-primary btn-premium px-4 shadow-sm" onclick="fn_register()">
                <i class="bi bi-person-plus-fill me-2"></i>신규 회원 등록
            </button>
        </div>
    </div>

    <!-- Search Filter Section -->
    <div class="premium-card mb-4">
        <form name="searchForm" action="<c:url value='/admin/member/memberList.do'/>" method="get">
            <input type="hidden" name="menu" value="member" />
            <div class="row g-3">
                <div class="col-md-3">
                    <label class="form-label fw-bold small">가입 상태</label>
                    <select name="status" class="form-select">
                        <option value="">전체</option>
                        <c:forEach var="st" items="${statusCodes}">
                            <option value="${st.detailCode}" <c:if test="${searchVO.status eq st.detailCode}">selected</c:if>>
                                ${st.detailCodeName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold small">회원 등급</label>
                    <select name="memberGrade" class="form-select">
                        <option value="">전체</option>
                        <c:forEach var="grade" items="${memberGrades}">
                            <option value="${grade.detailCode}" <c:if test="${searchVO.memberGrade eq grade.detailCode}">selected</c:if>>
                                ${grade.detailCodeName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold small">운영 유형</label>
                    <select name="deliveryTypeCd" class="form-select">
                        <option value="">전체</option>
                        <c:forEach var="dt" items="${deliveryTypes}">
                            <option value="${dt.detailCode}" <c:if test="${searchVO.deliveryTypeCd eq dt.detailCode}">selected</c:if>>
                                ${dt.detailCodeName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold small">가입일 기간</label>
                    <div class="d-flex align-items-center gap-2">
                        <input type="date" name="joinDateFrom" class="form-control" value="${searchVO.joinDateFrom}" />
                        <span class="text-muted">~</span>
                        <input type="date" name="joinDateTo" class="form-control" value="${searchVO.joinDateTo}" />
                    </div>
                </div>
                <div class="col-md-12 mt-3">
                    <label class="form-label fw-bold small">검색어</label>
                    <div class="d-flex gap-2">
                        <select name="searchCondition" class="form-select" style="max-width: 150px;">
                            <option value="companyName" <c:if test="${searchVO.searchCondition eq 'companyName'}">selected</c:if>>업체명</option>
                            <option value="memberId" <c:if test="${searchVO.searchCondition eq 'memberId'}">selected</c:if>>아이디</option>
                            <option value="ceoName" <c:if test="${searchVO.searchCondition eq 'ceoName'}">selected</c:if>>대표명</option>
                        </select>
                        <input type="text" name="searchKeyword" class="form-control" placeholder="검색어를 입력하세요." value="${searchVO.searchKeyword}" />
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-center gap-2 mt-4">
                <button type="button" class="btn btn-outline-secondary px-4 btn-premium" onclick="fn_reset_filter()">
                    <i class="bi bi-arrow-counterclockwise me-1"></i>초기화
                </button>
                <button type="submit" class="btn btn-primary px-5 btn-premium">
                    <i class="bi bi-search me-2"></i>회원 검색
                </button>
            </div>
        </form>
    </div>

    <!-- Data Table Section -->
    <div class="premium-card">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h5 class="fw-bold mb-0"><i class="bi bi-people-fill me-2 text-primary"></i>회원 목록</h5>
            <div class="text-muted small">
                검색 결과: <span class="text-primary fw-bold"><fmt:formatNumber value="${paginationInfo.totalRecordCount}" type="number" /></span> 명
            </div>
        </div>

        <div class="table-responsive">
            <table class="premium-table">
                <thead>
                    <tr>
                        <th style="width: 5%;">순번</th>
                        <th style="width: 12%;">아이디 / 타입</th>
                                            <th class="text-end" style="width: 10%;">여신</th>
                        <th class="text-end" style="width: 12%;">미트머니</th>
                        <th class="text-center" style="width: 8%;">운영 유형</th>
                        <th class="text-center" style="width: 8%;">상태</th>
                        <th class="text-center" style="width: 10%;">관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="member" items="${resultList}" varStatus="status">
                        <tr>
                            <td>
                                <c:out value="${paginationInfo.totalRecordCount - ((searchVO.pageIndex-1) * searchVO.pageUnit + status.index)}" />
                            </td>
                            <td>
                                <div class="fw-bold text-dark">${member.memberId}</div>
                                <div class="text-muted mini-text" style="font-size: 0.7rem;">${member.memberTypeName}</div>
                            </td>
                            <td>
                                <div class="fw-semibold text-primary">${member.companyName}</div>
                                <div class="mt-1">
                                    <span class="badge rounded-pill bg-soft-secondary text-secondary border border-secondary mini-text" style="font-size: 0.65rem;">${member.memberGradeName}</span>
                                </div>
                            </td>
                            <td>
                                <div class="text-dark small">${member.contactNumber}</div>
                                <div class="text-muted mini-text">${member.ceoName}</div>
                            </td>
                            <td>
                                <div class="text-dark small">${member.managerName}</div>
                                <div class="text-muted mini-text">${member.managerContact}</div>
                            </td>
                            <td class="text-end fw-bold text-muted">
                                <fmt:formatNumber value="${member.creditLimit}" type="number" /> <span class="small fw-normal">원</span>
                            </td>
                            <td class="text-end">
                                <div class="fw-bold text-accent mb-1" style="color:var(--accent)" id="balance_${member.memberPk}">
                                    <fmt:formatNumber value="${member.meatMoney}" type="number" /> <span class="small fw-normal text-dark">원</span>
                                </div>
                                <div class="d-flex justify-content-end gap-1">
                                    <button type="button" class="btn btn-outline-accent btn-xs" style="padding: 1px 4px; font-size: 0.65rem;" 
                                            onclick="fn_open_money_modal('${member.memberPk}', '${member.companyName}', '${member.meatMoney}')">
                                        <i class="bi bi-plus-slash-minus"></i> 관리
                                    </button>
                                    <button type="button" class="btn btn-outline-info btn-xs" style="padding: 1px 4px; font-size: 0.65rem;" 
                                            onclick="fn_open_history_modal('${member.memberPk}', '${member.companyName}')">
                                        <i class="bi bi-clock-history"></i> 이력
                                    </button>
                                </div>
                            </td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${member.deliveryTypeCd eq 'NATIONAL'}">
                                        <span class="badge rounded-pill bg-soft-primary text-primary border border-primary mini-text">전국</span>
                                    </c:when>
                                    <c:when test="${member.deliveryTypeCd eq 'LOCAL'}">
                                        <span class="badge rounded-pill bg-soft-success text-success border border-success mini-text">로컬</span>
                                    </c:when>
                                    <c:when test="${member.deliveryTypeCd eq 'FACTORY'}">
                                        <span class="badge rounded-pill bg-soft-warning text-warning border border-warning mini-text">공장</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted small">${member.deliveryTypeName}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${member.status eq 'NORMAL'}">
                                        <span class="badge rounded-pill bg-soft-success text-success border border-success">정상</span>
                                    </c:when>
                                    <c:when test="${member.status eq 'STOP'}">
                                        <span class="badge rounded-pill bg-soft-danger text-danger border border-danger">정지</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge rounded-pill bg-soft-secondary text-secondary border border-secondary">${member.statusName}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <button type="button" class="btn btn-outline-primary btn-sm p-1 px-2 mb-1" onclick="fn_edit_member('${member.memberId}')" title="수정">
                                    <i class="bi bi-pencil-square"></i>
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty resultList}">
                        <tr>
                            <td colspan="10" class="py-5 text-center text-muted">
                                <i class="bi bi-person-x fs-2 d-block mb-3 opacity-25"></i>
                                검색된 결과가 없습니다.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="mt-4 pb-2">
            <nav class="d-flex justify-content-center">
                <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_page" />
            </nav>
        </div>
    </div>
</div>

<!-- Meat Money Management Modal -->
<div class="modal fade" id="moneyModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-light border-0 py-3">
                <h5 class="modal-title fw-bold"><i class="bi bi-wallet2 me-2 text-primary"></i>미트머니 <span class="text-accent">수동 관리</span></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <div class="mb-4 p-3 bg-soft-secondary rounded-3">
                    <div class="small text-muted mb-1">대상 업체명</div>
                    <div class="fw-bold fs-5" id="modalCompanyName">-</div>
                    <input type="hidden" id="modalMemberPk" />
                </div>
                
                <div class="mb-4">
                    <label class="form-label fw-bold small">현재 잔액</label>
                    <div class="fs-4 fw-bold text-accent" id="modalCurrentBalance">0 <span class="small fw-normal text-dark">원</span></div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold small">처리 유형</label>
                    <div class="d-flex gap-2">
                        <input type="radio" name="moneyType" id="typeCharge" value="CHARGE" class="btn-check" checked>
                        <label class="btn btn-outline-primary flex-fill" for="typeCharge">충전 (+)</label>
                        
                        <input type="radio" name="moneyType" id="typeDeduct" value="DEDUCT" class="btn-check">
                        <label class="btn btn-outline-danger flex-fill" for="typeDeduct">차감 (-)</label>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold small">금액 입력</label>
                    <div class="input-group">
                        <input type="number" id="moneyAmount" class="form-control form-control-lg text-end" placeholder="0" />
                        <span class="input-group-text">원</span>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold small">사유 입력 <span class="text-danger">*</span></label>
                    <textarea id="moneyRemark" class="form-control" rows="2" placeholder="처리 사유를 입력하세요. (예: 정산 보정, 이벤트 지급 등)"></textarea>
                </div>
            </div>
            <div class="modal-footer border-0 p-3 bg-light">
                <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary px-4 fw-bold" onclick="fn_update_money()">변동 반영하기</button>
            </div>
        </div>
    </div>
</div>

<!-- Money History Modal -->
<div class="modal fade" id="historyModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow-lg" style="height: 600px;">
            <div class="modal-header bg-light border-0 py-3">
                <h5 class="modal-title fw-bold"><i class="bi bi-clock-history me-2 text-info"></i>머니 <span class="text-info">변동 이력</span></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-0 overflow-auto">
                <div class="p-3 bg-white sticky-top border-bottom">
                    <span class="text-muted">업체명: </span><span class="fw-bold" id="historyCompanyName">-</span>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" style="font-size: 0.85rem;">
                        <thead class="bg-light text-muted small uppercase fw-bold">
                            <tr>
                                <th class="ps-4">일시</th>
                                <th>유형</th>
                                <th class="text-end">증감</th>
                                <th class="text-end">최종 잔액</th>
                                <th class="ps-3 w-40">내용</th>
                            </tr>
                        </thead>
                        <tbody id="historyTableBody">
                            <!-- Ajax Load -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<form name="pageForm" action="<c:url value='/admin/member/memberList.do'/>" method="get">
    <input type="hidden" name="menu" value="member" />
    <input type="hidden" name="pageIndex" value="${searchVO.pageIndex}" />
    <input type="hidden" name="status" value="${searchVO.status}" />
    <input type="hidden" name="deliveryTypeCd" value="${searchVO.deliveryTypeCd}" />
    <input type="hidden" name="joinDateFrom" value="${searchVO.joinDateFrom}" />
    <input type="hidden" name="joinDateTo" value="${searchVO.joinDateTo}" />
    <input type="hidden" name="memberGrade" value="${searchVO.memberGrade}" />
    <input type="hidden" name="searchCondition" value="${searchVO.searchCondition}" />
    <input type="hidden" name="searchKeyword" value="${searchVO.searchKeyword}" />
</form>

<script>
    function fn_reset_filter() {
        var form = document.searchForm;
        form.status.value = "";
        form.deliveryTypeCd.value = "";
        form.joinDateFrom.value = "";
        form.joinDateTo.value = "";
        form.memberGrade.value = "";
        form.searchCondition.value = "companyName";
        form.searchKeyword.value = "";
        form.submit();
    }

    function fn_page(pageNo) {
        document.pageForm.pageIndex.value = pageNo;
        document.pageForm.submit();
    }

    function fn_register() {
        location.href = '<c:url value="/admin/member/memberRegisterForm.do?menu=member"/>';
    }

    function fn_edit_member(id) {
        location.href = '<c:url value="/admin/member/memberDetail.do?menu=member"/>&memberId=' + id;
    }

    // Money Modal functions
    var moneyModal;
    var historyModal;

    $(document).ready(function() {
        moneyModal = new bootstrap.Modal(document.getElementById('moneyModal'));
        historyModal = new bootstrap.Modal(document.getElementById('historyModal'));
    });

    function fn_open_money_modal(id, name, balance) {
        $('#modalMemberPk').val(id);
        $('#modalCompanyName').text(name);
        $('#modalCurrentBalance').html(new Intl.NumberFormat().format(balance) + ' <span class="small fw-normal text-dark">원</span>');
        $('#moneyAmount').val('');
        $('#moneyRemark').val('');
        moneyModal.show();
    }

    function fn_update_money() {
        var id = $('#modalMemberPk').val();
        var amount = $('#moneyAmount').val();
        var type = $('input[name="moneyType"]:checked').val();
        var remark = $('#moneyRemark').val();

        if (!amount || amount <= 0) {
            alert('금액을 입력하세요.');
            return;
        }
        if (!remark) {
            alert('사유를 입력하세요.');
            return;
        }

        if(!confirm('해당 금액을 ' + (type === 'CHARGE' ? '충전' : '차감') + '하시겠습니까?')) return;

        $.ajax({
            url: '<c:url value="/admin/member/updateMeatMoney.ajax"/>',
            type: 'POST',
            data: {
                memberId: id,
                amount: amount,
                type: type,
                remark: remark
            },
            success: function(res) {
                if (res.status === 'success') {
                    alert(res.message);
                    moneyModal.hide();
                    // Update UI row balance
                    $('#balance_' + id).html(new Intl.NumberFormat().format(res.newBalance) + ' <span class="small fw-normal text-dark">원</span>');
                } else {
                    alert('오류 발생: ' + res.message);
                }
            },
            error: function() {
                alert('서버 통신 중 오류가 발생했습니다.');
            }
        });
    }

    function fn_open_history_modal(id, name) {
        $('#historyCompanyName').text(name);
        $('#historyTableBody').html('<tr><td colspan="5" class="py-5 text-center"><div class="spinner-border spinner-border-sm text-primary"></div></td></tr>');
        historyModal.show();

        $.ajax({
            url: '<c:url value="/admin/member/moneyHistoryList.ajax"/>',
            type: 'GET',
            data: { memberId: id },
            success: function(res) {
                if (res.status === 'success') {
                    var html = '';
                    if (res.data.length === 0) {
                        html = '<tr><td colspan="5" class="py-5 text-center text-muted">변동 이력이 없습니다.</td></tr>';
                    } else {
                        res.data.forEach(function(item) {
                            var typeClass = item.MEAT_MONEY_TYPE === 'CHARGE' ? 'text-primary' : 'text-danger';
                            var typeText = item.MEAT_MONEY_TYPE === 'CHARGE' ? '충전' : '차감';
                            var amountSign = item.MEAT_MONEY_TYPE === 'CHARGE' ? '+' : '-';
                            
                            html += '<tr>';
                            html += ' <td class="ps-4 text-muted">' + item.REG_DT + '</td>';
                            html += ' <td><span class="badge ' + (item.MEAT_MONEY_TYPE === 'CHARGE' ? 'bg-soft-primary text-primary' : 'bg-soft-danger text-danger') + '">' + typeText + '</span></td>';
                            html += ' <td class="text-end fw-bold ' + typeClass + '">' + amountSign + new Intl.NumberFormat().format(item.AMT) + '</td>';
                            html += ' <td class="text-end fw-bold">' + new Intl.NumberFormat().format(item.TOTAL_AMT) + '</td>';
                            html += ' <td class="ps-3 text-truncate" style="max-width: 250px;" title="' + (item.REMARK || '') + '">' + (item.REMARK || '-') + '</td>';
                            html += '</tr>';
                        });
                    }
                    $('#historyTableBody').html(html);
                } else {
                    alert('이력 조회 중 오류 발생: ' + res.message);
                }
            }
        });
    }
</script>
o?menu=member"/>';
                    }

                    function fn_edit_member(id) {
                        location.href = '<c:url value="/admin/member/memberDetail.do?menu=member"/>&memberId=' + id;
                    }
                </script>