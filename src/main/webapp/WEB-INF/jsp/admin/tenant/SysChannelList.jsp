<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

    <div class="container-fluid py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h4 class="fw-bold mb-1"><i class="bi bi-truck me-2"></i>채널 관리</h4>
                <p class="text-muted mb-0 small">배송/운송 채널을 등록하고 관리합니다.</p>
            </div>
            <button class="btn btn-primary premium-btn px-4" onclick="openChannelModal()">
                <i class="bi bi-plus-lg me-1"></i> 신규 채널 등록
            </button>
        </div>

        <!-- Search Area -->
        <div class="premium-card mb-4 p-3">
            <form id="searchForm" action="<c:url value='/admin/sysChannel/channelList.do'/>" method="get" class="row g-2 align-items-center">
                <c:if test="${sessionScope.loginVO.memberType eq 'SUPER_ADMIN' or sessionScope.loginVO.memberType eq 'SUPER' or sessionScope.loginVO.roleCd eq 'SUPER'}">
                    <div class="col-md-2">
                        <select name="companyId" class="form-select">
                            <option value="">-- 업체 선택 (전체) --</option>
                            <c:forEach var="comp" items="${companyList}">
                                <option value="${comp.companyId}" ${searchVO.companyId eq comp.companyId ? 'selected' : ''}>${comp.companyName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </c:if>
                <div class="col-md-2">
                    <select name="channelType" class="form-select">
                        <option value="">-- 채널 유형 --</option>
                        <option value="COURIER" ${searchVO.channelType eq 'COURIER' ? 'selected' : ''}>전국택배</option>
                        <option value="DIRECT" ${searchVO.channelType eq 'DIRECT' ? 'selected' : ''}>화물직송</option>
                        <option value="COLLECT" ${searchVO.channelType eq 'COLLECT' ? 'selected' : ''}>공장수령</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <input type="text" name="searchKeyword" class="form-control" placeholder="채널명 검색" value="${searchVO.searchKeyword}">
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-dark px-4">검색</button>
                </div>
            </form>
        </div>

        <!-- List Area -->
        <div class="premium-card">
            <div class="table-responsive">
                <table class="table premium-table mb-0">
                    <thead>
                        <tr>
                            <th width="8%">NO</th>
                            <c:if test="${sessionScope.loginVO.memberType eq 'SUPER_ADMIN' or sessionScope.loginVO.memberType eq 'SUPER' or sessionScope.loginVO.roleCd eq 'SUPER'}">
                                <th width="15%">소유 업체명</th>
                            </c:if>
                            <th width="15%">채널 유형</th>
                            <th width="25%">채널명</th>
                            <th width="20%">담당자</th>
                            <th width="12%">상태</th>
                            <th width="20%" class="text-center">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${resultList}" varStatus="status">
                            <tr>
                                <td>${paginationInfo.totalRecordCount - ((searchVO.pageIndex-1) * searchVO.pageUnit) - status.index}</td>
                                <c:if test="${sessionScope.loginVO.memberType eq 'SUPER_ADMIN' or sessionScope.loginVO.memberType eq 'SUPER' or sessionScope.loginVO.roleCd eq 'SUPER'}">
                                    <td class="text-primary fw-bold">${item.companyName}</td>
                                </c:if>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.channelType eq 'COURIER'}"><span class="badge bg-secondary">전국택배</span></c:when>
                                        <c:when test="${item.channelType eq 'DIRECT'}"><span class="badge bg-secondary">화물직송</span></c:when>
                                        <c:when test="${item.channelType eq 'COLLECT'}"><span class="badge bg-secondary">공장수령</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">${item.channelType}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="fw-bold">${item.channelName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty item.managerName}">
                                            <i class="bi bi-person-circle text-muted me-1"></i> ${item.managerName}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted small">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.status eq 'ACTIVE'}">
                                            <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1 rounded-pill"><i class="bi bi-check-circle-fill me-1"></i>정상</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 px-2 py-1 rounded-pill"><i class="bi bi-x-circle-fill me-1"></i>삭제/중지</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-outline-primary" onclick="editChannel('${item.channelId}', '${item.channelType}', '${item.channelName}', '${item.managerId}', '${item.companyId}')">
                                        수정
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger ms-1" onclick="deleteChannel('${item.channelId}')">
                                        삭제
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty resultList}">
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">등록된 채널이 없습니다.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            
            <div class="card-footer bg-white border-top border-light d-flex justify-content-between align-items-center py-3">
                <span class="text-muted small">총 <strong class="text-primary">${paginationInfo.totalRecordCount}</strong>건</span>
                <div class="premium-pagination">
                    <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_link_page" />
                </div>
            </div>
        </div>
    </div>

    <!-- Channel Modal -->
    <div class="modal fade" id="channelModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-light border-bottom-0">
                    <h5 class="modal-title fw-bold" id="modalTitle">신규 채널 등록</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <form id="channelForm" onsubmit="event.preventDefault(); saveChannel();">
                        <input type="hidden" id="modalChannelId" name="channelId">
                        
                        <c:if test="${sessionScope.loginVO.memberType eq 'SUPER_ADMIN' or sessionScope.loginVO.memberType eq 'SUPER' or sessionScope.loginVO.roleCd eq 'SUPER'}">
                            <div class="mb-4">
                                <label class="form-label fw-bold text-dark">대상 업체 <span class="text-danger">*</span></label>
                                <select class="form-select bg-light" id="modalCompanyId" name="companyId" required>
                                    <option value="">업체 선택</option>
                                    <c:forEach var="comp" items="${companyList}">
                                        <option value="${comp.companyId}">${comp.companyName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </c:if>
                        
                        <div class="mb-4">
                            <label class="form-label fw-bold text-dark">채널 유형 <span class="text-danger">*</span></label>
                            <select class="form-select bg-light" id="modalChannelType" name="channelType" required>
                                <option value="">유형 선택</option>
                                <option value="COURIER">전국택배</option>
                                <option value="DIRECT">화물직송</option>
                                <option value="COLLECT">공장수령</option>
                            </select>
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label fw-bold text-dark">채널명 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control bg-light" id="modalChannelName" name="channelName" placeholder="예: 로젠택배, 용달, 공장직접수령" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold text-dark">담당자 지정 <span class="text-muted fw-normal">(선택)</span></label>
                            <select class="form-select bg-light" id="modalManagerId" name="managerId">
                                <option value="">-- 담당자 없음 --</option>
                                <c:forEach var="mgr" items="${managerList}">
                                    <option value="${mgr.userId}">${mgr.userName} (${mgr.userId})</option>
                                </c:forEach>
                            </select>
                            <div class="form-text">선택하지 않아도 등록 가능합니다.</div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-top-0 bg-light p-3">
                    <button type="button" class="btn btn-light px-4 border" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary px-4 shadow-sm" onclick="saveChannel()">저장하기</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        function fn_link_page(pageNo) {
            document.getElementById("searchForm").action = "<c:url value='/admin/sysChannel/channelList.do'/>";
            const input = document.createElement("input");
            input.type = "hidden";
            input.name = "pageIndex";
            input.value = pageNo;
            document.getElementById("searchForm").appendChild(input);
            document.getElementById("searchForm").submit();
        }

        const channelModal = new bootstrap.Modal(document.getElementById('channelModal'));

        function openChannelModal() {
            document.getElementById('channelForm').reset();
            document.getElementById('modalChannelId').value = '';
            if (document.getElementById('modalCompanyId')) {
                document.getElementById('modalCompanyId').value = '';
            }
            document.getElementById('modalTitle').innerText = '신규 채널 등록';
            channelModal.show();
        }

        function editChannel(id, type, name, managerId, companyId) {
            document.getElementById('channelForm').reset();
            document.getElementById('modalChannelId').value = id;
            if (document.getElementById('modalCompanyId')) {
                document.getElementById('modalCompanyId').value = companyId;
            }
            document.getElementById('modalChannelType').value = type;
            document.getElementById('modalChannelName').value = name;
            
            if(managerId && managerId !== 'null' && managerId !== '') {
                document.getElementById('modalManagerId').value = managerId;
            } else {
                document.getElementById('modalManagerId').value = '';
            }
            
            document.getElementById('modalTitle').innerText = '채널 정보 수정';
            channelModal.show();
        }

        function saveChannel() {
            const form = document.getElementById('channelForm');
            if(!form.checkValidity()) {
                form.reportValidity();
                return;
            }
            
            const formData = $(form).serialize();
            
            $.ajax({
                url: "<c:url value='/admin/sysChannel/saveChannel.ajax'/>",
                type: "POST",
                data: formData,
                success: function(res) {
                    if(res.status === 'SUCCESS') {
                        fn_toast('채널이 성공적으로 저장되었습니다.', 'success');
                        setTimeout(() => location.reload(), 1000);
                    } else {
                        fn_toast('저장 실패: ' + res.message, 'danger');
                    }
                },
                error: function(err) {
                    fn_toast('통신 에러가 발생했습니다.', 'danger');
                }
            });
        }

        function deleteChannel(id) {
            if(!confirm('해당 채널을 삭제(상태 비활성화) 처리하시겠습니까?')) return;
            
            $.ajax({
                url: "<c:url value='/admin/sysChannel/deleteChannel.ajax'/>",
                type: "POST",
                data: { channelId: id },
                success: function(res) {
                    if(res.status === 'SUCCESS') {
                        fn_toast('채널이 삭제 처리되었습니다.', 'success');
                        setTimeout(() => location.reload(), 1000);
                    } else {
                        fn_toast('삭제 실패: ' + res.message, 'danger');
                    }
                },
                error: function(err) {
                    fn_toast('통신 에러가 발생했습니다.', 'danger');
                }
            });
        }
    </script>
