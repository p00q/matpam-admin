<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>구성상품 조회</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        body {
            padding: 20px;
            font-size: 0.9rem;
            background-color: #f8f9fa;
        }

        .card {
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            border: none;
        }

        .form-table th {
            background-color: #f1f3f5;
            width: 15%;
            text-align: center;
            vertical-align: middle;
        }

        .form-table td {
            vertical-align: middle;
        }

        .table-hover tbody tr:hover {
            background-color: #f8f9fa;
        }
    </style>
</head>

<body>

<div class="container-fluid">

    <div class="card mb-4">
        <div class="card-header bg-primary text-white fw-bold">
            구성상품 조회
        </div>
        <div class="card-body">
            <form name="searchForm" id="searchForm" method="post"
                  action="<c:url value='/admin/product/popup/componentList.do'/>">

                <input type="hidden" name="pageIndex" value="<c:out value='${searchVO.pageIndex}' default='1'/>"/>

                <h6 class="fw-bold mb-3">조회조건입력</h6>
                <table class="table table-bordered form-table mb-3">
                    <tr>
                        <th>판매유형</th>
                        <td>
                            <select name="saleTypeCd" class="form-select form-select-sm">
                                <option value="">전체</option>
                                <c:forEach var="code" items="${saleTypes}">
                                    <option value="${code.detailCode}" <c:if test="${searchVO.saleTypeCd eq code.detailCode}">selected</c:if>>
                                        ${code.detailCodeName}
                                    </option>
                                </c:forEach>
                            </select>
                        </td>
                        <th>업체명</th>
                        <td>
                            <select name="sellerMemberId" class="form-select form-select-sm">
                                <option value="">전체</option>
                                <c:forEach var="seller" items="${sellers}">
                                    <c:set var="sellerKey" value="${not empty seller.memberNo ? seller.memberNo : seller.memberId}" />
                                    <option value="${sellerKey}" <c:if test="${searchVO.sellerMemberId eq sellerKey}">selected</c:if>>
                                        ${seller.companyName}
                                    </option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>저장유형</th>
                        <td>
                            <select name="storageTypeCd" class="form-select form-select-sm">
                                <option value="">전체</option>
                                <c:forEach var="code" items="${storageTypes}">
                                    <option value="${code.detailCode}" <c:if test="${searchVO.storageTypeCd eq code.detailCode}">selected</c:if>>
                                        ${code.detailCodeName}
                                    </option>
                                </c:forEach>
                            </select>
                        </td>
                        <th>판매상태</th>
                        <td>
                            <select name="saleStatusCd" class="form-select form-select-sm">
                                <option value="">전체</option>
                                <c:forEach var="code" items="${saleStatuses}">
                                    <option value="${code.detailCode}" <c:if test="${searchVO.saleStatusCd eq code.detailCode}">selected</c:if>>
                                        ${code.detailCodeName}
                                    </option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>처리유형</th>
                        <td>
                            <select name="processTypeCd" class="form-select form-select-sm">
                                <option value="">전체</option>
                                <c:forEach var="code" items="${processTypes}">
                                    <option value="${code.detailCode}" <c:if test="${searchVO.processTypeCd eq code.detailCode}">selected</c:if>>
                                        ${code.detailCodeName}
                                    </option>
                                </c:forEach>
                            </select>
                        </td>
                        <th>단위유형</th>
                        <td>
                            <select name="unitTypeCd" class="form-select form-select-sm">
                                <option value="">전체</option>
                                <c:forEach var="code" items="${unitTypes}">
                                    <option value="${code.detailCode}" <c:if test="${searchVO.unitTypeCd eq code.detailCode}">selected</c:if>>
                                        ${code.detailCodeName}
                                    </option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>검색어</th>
                        <td colspan="3">
                            <input type="text" name="searchKeyword" class="form-control form-control-sm"
                                   value="<c:out value='${searchVO.searchKeyword}'/>" placeholder="상품명 또는 코드"/>
                        </td>
                    </tr>
                </table>

                <div class="text-center">
                    <button type="submit" class="btn btn-secondary px-4">검색</button>
                    <button type="button" class="btn btn-secondary px-4"
                            onclick="location.href='<c:url value='/admin/product/popup/componentList.do'/>'">초기화</button>
                </div>
            </form>
        </div>
    </div>

    <div class="card">
        <div class="card-body p-0">
            <table class="table table-bordered table-hover text-center align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th style="width: 50px;"><input type="checkbox" id="checkAll"/></th>
                    <th>판매유형</th>
                    <th>상품코드</th>
                    <th>상품명</th>
                    <th>업체명</th>
                    <th>저장유형</th>
                    <th>처리유형</th>
                    <th>단위유형</th>
                    <th>판매가격</th>
                    <th style="width: 100px;">부가세</th>
                    <th>판매상태</th>
                    <th>노출상태</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${componentList}" varStatus="status">
                    <tr>
                        <td>
                            <input type="checkbox" name="checkItem" value="${item.componentProdId}"/>
                        </td>
                        <td>${item.saleTypeName}</td>
                        <td class="text-start">${item.componentProdCode}</td>
                        <td class="text-start">${item.componentProdName}</td>
                        <td>${item.sellerName}</td>
                        <td>${item.storageTypeName}</td>
                        <td>${item.processTypeName}</td>
                        <td>${item.unitTypeName}</td>
                        <td class="text-end">
                            <fmt:formatNumber value="${item.listPrice}" type="number"/>
                        </td>
                        <td class="text-end">
                            <fmt:formatNumber value="${item.vatAmount}" type="number"/>
                        </td>
                        <td>${item.saleStatusName}</td>
                        <td>
                            <c:choose>
                                <c:when test="${item.exposureStatusCd eq 'Y'}">노출</c:when>
                                <c:otherwise>비노출</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty componentList}">
                    <tr>
                        <td colspan="12" class="py-4 text-center text-muted">검색된 결과가 없습니다.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <div class="card-footer bg-white border-top-0">
            <c:if test="${not empty paginationInfo}">
                <div class="d-flex justify-content-center">
                    <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_page"/>
                </div>
            </c:if>
        </div>
    </div>

    <div class="d-flex justify-content-center gap-2 mt-4 mb-4">
        <button type="button" class="btn btn-secondary px-4" onclick="fn_register()">등록</button>
        <button type="button" class="btn btn-secondary px-4" onclick="window.close()">취소</button>
    </div>

</div>

<script>
    var componentMap = {};

    // JS Map 초기화
    <c:forEach var="item" items="${componentList}">
        componentMap["${item.componentProdId}"] = {
            componentProdId: "${item.componentProdId}",
            componentProdCode: "${item.componentProdCode}",
            componentProdName: "<c:out value='${item.componentProdName}'/>",

            saleType: "${item.saleTypeCd}",
            saleTypeName: "${item.saleTypeName}",

            sellerMemberId: "${item.sellerMemberId}",
            sellerName: "<c:out value='${item.sellerName}'/>",

            listPrice: <c:out value="${item.listPrice}" default="0"/>,
            costPrice: <c:out value="${item.costPrice}" default="0"/>,
            vatRate: <c:out value="${item.vatRate}" default="0"/>,
            vatAmount: <c:out value="${item.vatAmount}" default="0"/>,

            storageTypeName: "${item.storageTypeName}",
            processTypeName: "${item.processTypeName}",
            unitTypeName: "${item.unitTypeName}",

            saleStatusName: "${item.saleStatusName}",
            exposureStatusCd: "${item.exposureStatusCd}",

            saleStartDt: "<fmt:formatDate value='${item.saleStartDt}' pattern='yyyy-MM-dd' />",
            saleEndDt: "<fmt:formatDate value='${item.saleEndDt}' pattern='yyyy-MM-dd' />",
            regDt: "<fmt:formatDate value='${item.regDt}' pattern='yyyy-MM-dd' />",
            modDt: "<fmt:formatDate value='${item.modDt}' pattern='yyyy-MM-dd' />"
        };
    </c:forEach>

    function fn_page(pageNo) {
        var form = document.getElementById("searchForm");
        form.pageIndex.value = pageNo;
        form.submit();
    }

    // 전체 선택/해제
    document.getElementById('checkAll').addEventListener('change', function () {
        var checkboxes = document.querySelectorAll('input[name="checkItem"]');
        for (var checkbox of checkboxes) {
            checkbox.checked = this.checked;
        }
    });

    function fn_register() {
        var checkboxes = document.querySelectorAll('input[name="checkItem"]:checked');
        if (checkboxes.length === 0) {
            alert('구성상품을 선택해주세요.');
            return;
        }

        checkboxes.forEach(function (checkbox) {
            var componentProdId = checkbox.value;
            var data = componentMap[componentProdId];

            if (data && window.opener && !window.opener.closed) {
                // 부모창에서 받는 함수명(기존 흐름 유지)
                if (typeof window.opener.addComponentRow === 'function') {
                    window.opener.addComponentRow(data);
                } else {
                    console.error('부모창에 addComponentRow 함수가 없습니다.');
                }
            }
        });

        window.close();
    }
</script>

</body>
</html>
