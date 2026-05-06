<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<div class="container-fluid px-4">
    <h1 class="mt-4">상품 상세 정보</h1>
    <ol class="breadcrumb mb-4">
        <li class="breadcrumb-item"><a href="<c:url value='/admin/dashboard/main.do'/>">대시보드</a></li>
        <li class="breadcrumb-item"><a href="<c:url value='/admin/product/productList.do'/>">상품 마스터</a></li>
        <li class="breadcrumb-item active">상품 상세</li>
    </ol>

    <div class="row">
        <div class="col-lg-12">
            <!-- 탭 메뉴 -->
            <ul class="nav nav-tabs mb-4" id="productTab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="basic-tab" data-bs-toggle="tab" data-bs-target="#basic" type="button" role="tab">기본 정보</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="price-tab" data-bs-toggle="tab" data-bs-target="#price" type="button" role="tab" ${empty product.productId ? 'disabled' : ''}>가격 정책</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="relation-tab" data-bs-toggle="tab" data-bs-target="#relation" type="button" role="tab" ${empty product.productId ? 'disabled' : ''}>관계 및 세금</button>
                </li>
            </ul>

            <div class="tab-content" id="productTabContent">
                <!-- 1. 기본 정보 탭 -->
                <div class="tab-pane fade show active" id="basic" role="tabpanel">
                    <div class="card shadow-sm border-0 mb-4">
                        <div class="card-header bg-white py-3">
                            <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i>상품 기본 설정</h5>
                        </div>
                        <div class="card-body p-4">
                            <form:form modelAttribute="product" action="/admin/product/saveProduct.do" method="post">
                                <form:hidden path="productId" />
                                <form:hidden path="tenantId" />
                                
                                <div class="row mb-3">
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">상품 코드 <span class="text-danger">*</span></label>
                                        <form:input path="productCode" class="form-control" placeholder="PRD-00000" required="true" readonly="${not empty product.productId}" />
                                    </div>
                                    <div class="col-md-8">
                                        <label class="form-label fw-bold">상품명 <span class="text-danger">*</span></label>
                                        <form:input path="productName" class="form-control" required="true" />
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">상품 구분 <span class="text-danger">*</span></label>
                                        <form:select path="itemKind" class="form-select">
                                            <form:option value="GOODS" label="물품 (Goods)" />
                                            <form:option value="SERVICE" label="서비스 (Service)" />
                                        </form:select>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">처리 유형 <span class="text-danger">*</span></label>
                                        <form:select path="processingType" class="form-select">
                                            <form:option value="RAW_GOODS" label="원물 (Raw)" />
                                            <form:option value="PROCESSED_GOODS" label="가공품 (Processed)" />
                                            <form:option value="PROCESS_SERVICE" label="가공 서비스 (Service)" />
                                        </form:select>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">과세 구분 <span class="text-danger">*</span></label>
                                        <form:select path="taxCategory" class="form-select">
                                            <form:option value="TAXABLE" label="과세" />
                                            <form:option value="TAX_FREE" label="면세" />
                                        </form:select>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">단위 명칭 <span class="text-danger">*</span></label>
                                        <form:input path="unitName" class="form-control" placeholder="kg, 박스, 건 등" required="true" />
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">재고 관리 여부 <span class="text-danger">*</span></label>
                                        <div class="pt-2">
                                            <form:radiobutton path="stockManagedYn" value="Y" label="사용" class="form-check-input me-1" />
                                            <form:radiobutton path="stockManagedYn" value="N" label="미사용" class="form-check-input ms-3 me-1" />
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">판매 상태 <span class="text-danger">*</span></label>
                                        <form:select path="saleStatus" class="form-select text-primary fw-bold">
                                            <form:option value="ON_SALE" label="판매중" />
                                            <form:option value="STOPPED" label="판매중지" />
                                            <form:option value="HIDDEN" label="숨김" />
                                        </form:select>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold">상품 설명</label>
                                    <form:textarea path="description" class="form-control" rows="4" />
                                </div>

                                <div class="d-flex justify-content-end gap-2 mt-4 pt-4 border-top">
                                    <a href="<c:url value='/admin/product/productList.do'/>" class="btn btn-light px-4">목록으로</a>
                                    <button type="submit" class="btn btn-primary px-4">저장하기</button>
                                </div>
                            </form:form>
                        </div>
                    </div>
                </div>

                <!-- 2. 가격 정책 탭 -->
                <div class="tab-pane fade" id="price" role="tabpanel">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-white d-flex justify-content-between align-items-center py-3">
                            <h5 class="mb-0"><i class="fas fa-coins me-2"></i>업체별/채널별 맞춤 단가</h5>
                            <button type="button" class="btn btn-outline-success btn-sm"><i class="fas fa-plus"></i> 가격 정책 추가</button>
                        </div>
                        <div class="card-body p-0">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>적용 채널</th>
                                        <th>적용 업체 (구매사)</th>
                                        <th class="text-end">공급 단가</th>
                                        <th class="text-center">적용 기간</th>
                                        <th class="text-center">상태</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="price" items="${priceList}">
                                        <tr>
                                            <td>${empty price.channelName ? '전체 채널' : price.channelName}</td>
                                            <td>${empty price.buyerCompanyName ? '전체 업체' : price.buyerCompanyName}</td>
                                            <td class="text-end fw-bold text-dark">
                                                <fmt:formatNumber value="${price.unitPrice}" type="currency" currencySymbol="" /> 원
                                            </td>
                                            <td class="text-center">
                                                <fmt:formatDate value="${price.effectiveFrom}" pattern="yyyy-MM-dd" /> 
                                                ~ <fmt:formatDate value="${price.effectiveTo}" pattern="yyyy-MM-dd" />
                                            </td>
                                            <td class="text-center">
                                                <span class="badge ${price.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">${price.status}</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty priceList}">
                                        <tr>
                                            <td colspan="5" class="text-center py-5 text-muted">등록된 가격 정책이 없습니다.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- 3. 관계 및 세금 탭 (Placeholder) -->
                <div class="tab-pane fade" id="relation" role="tabpanel">
                    <div class="alert alert-info">
                        <i class="fas fa-tools me-2"></i> 상품 관계(BOM) 및 상세 세금 규칙 설정 기능은 현재 준비 중입니다.
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
