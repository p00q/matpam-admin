<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 등록</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body>
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h2 class="mb-0">회원 등록</h2>
            <p class="text-muted mb-0">담당자를 원하는 만큼 추가하거나 제거할 수 있습니다.</p>
        </div>
    </div>

    <form action="/admin/member/insertMember.do" method="post">
        <input type="hidden" name="approvalYn" value="N"/>

        <div class="card mb-4">
            <div class="card-body">
                <h5 class="card-title mb-3">기본 정보</h5>
                <div class="row g-3 align-items-end">
                    <div class="col-md-6">
                        <label class="form-label" for="memberType">회원 타입</label>
                        <select class="form-select" id="memberType" name="memberType" required>
                            <option value="">선택</option>
                            <option value="BUYER">구매자</option>
                            <option value="SELLER">판매자</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="region">지역</label>
                        <select class="form-select" id="region" name="region" required>
                            <option value="">선택</option>
                            <option value="SEOUL">서울</option>
                            <option value="BUSAN">부산</option>
                            <option value="DAEJEON">대전</option>
                        </select>
                    </div>
                </div>
                <div class="row g-3 align-items-end mt-1">
                    <div class="col-md-4">
                        <label class="form-label" for="memberId">아이디</label>
                        <input type="text" class="form-control" id="memberId" name="memberId" placeholder="회원 아이디" required />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label" for="locId">LOCID</label>
                        <input type="text" class="form-control" id="locId" name="locId" placeholder="예: 1001" required />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label" for="memberGrade">회원등급</label>
                        <select class="form-select" id="memberGrade" name="memberGrade">
                            <option value="">선택</option>
                            <option value="VIP">VIP</option>
                            <option value="GOLD">Gold</option>
                            <option value="SILVER">Silver</option>
                        </select>
                    </div>
                </div>
                <div class="row g-3 align-items-end mt-1">
                    <div class="col-md-4">
                        <label class="form-label" for="status">가입상태</label>
                        <select class="form-select" id="status" name="status">
                            <option value="PENDING">대기</option>
                            <option value="ACTIVE">가입</option>
                            <option value="INACTIVE">탈퇴</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>

        <div class="card mb-4">
            <div class="card-body">
                <h5 class="card-title mb-3">사업자 정보</h5>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label" for="companyName">업체명</label>
                        <input type="text" class="form-control" id="companyName" name="companyName" placeholder="업체명" required />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="businessNumber">사업자번호</label>
                        <input type="text" class="form-control" id="businessNumber" name="businessNumber" placeholder="000-00-00000" required />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="ceoName">대표명</label>
                        <input type="text" class="form-control" id="ceoName" name="ceoName" placeholder="대표자" required />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="contactNumber">대표 연락처</label>
                        <input type="text" class="form-control" id="contactNumber" name="contactNumber" placeholder="010-0000-0000" required />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label" for="creditLimit">여신한도</label>
                        <input type="number" class="form-control" id="creditLimit" name="creditLimit" placeholder="숫자만 입력" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label" for="meatMoney">미트머니</label>
                        <input type="number" class="form-control" id="meatMoney" name="meatMoney" placeholder="숫자만 입력" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label" for="joinDate">가입일</label>
                        <input type="date" class="form-control" id="joinDate" name="joinDate" value="<%=new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>" />
                    </div>
                </div>
            </div>
        </div>

        <div class="card mb-4">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <h5 class="card-title mb-0">담당자 정보</h5>
                        <p class="text-muted mb-0">필요한 만큼 담당자를 추가하거나 삭제할 수 있습니다.</p>
                    </div>
                    <button type="button" id="addManagerBtn" class="btn btn-outline-primary">담당자 생성</button>
                </div>
                <div id="managerList">
                    <div class="card manager-card mb-3">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="card-title manager-title mb-0">담당자 1</h5>
                                <button type="button" class="btn btn-outline-danger btn-sm btn-remove-manager" aria-label="담당자 삭제">삭제</button>
                            </div>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label" data-label-for="name" for="manager-1-name">담당자명</label>
                                    <input type="text" class="form-control" data-field="name" id="manager-1-name" name="managerName" placeholder="담당자명을 입력하세요"/>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" data-label-for="phone" for="manager-1-phone">연락처</label>
                                    <input type="text" class="form-control" data-field="phone" id="manager-1-phone" name="managerContact" placeholder="010-0000-0000"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="text-end mb-5">
            <a href="/admin/member/memberList.do" class="btn btn-outline-secondary me-2">목록</a>
            <button type="submit" class="btn btn-primary">등록</button>
        </div>
    </form>
</div>

<template id="managerTemplate">
    <div class="card manager-card mb-3">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="card-title manager-title mb-0">담당자</h5>
                <button type="button" class="btn btn-outline-danger btn-sm btn-remove-manager" aria-label="담당자 삭제">삭제</button>
            </div>
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label" data-label-for="name" for="">담당자명</label>
                    <input type="text" class="form-control" data-field="name" placeholder="담당자명을 입력하세요"/>
                </div>
                <div class="col-md-6">
                    <label class="form-label" data-label-for="phone" for="">연락처</label>
                    <input type="text" class="form-control" data-field="phone" placeholder="010-0000-0000"/>
                </div>
            </div>
        </div>
    </div>
</template>

    <script type="text/javascript">
        (function () {
            function ready(callback) {
                if (document.readyState === 'loading') {
                    document.addEventListener('DOMContentLoaded', callback);
                } else {
                    callback();
                }
            }

            ready(function () {
                var managerList = document.getElementById('managerList');
                var addManagerBtn = document.getElementById('addManagerBtn');
                var managerTemplate = document.getElementById('managerTemplate');

                if (!managerList) {
                    return;
                }

                function hasClass(element, className) {
                    return !!(element && element.classList && element.classList.contains(className));
                }

                function findClosestCard(element) {
                    var current = element;
                    while (current && current !== managerList) {
                        if (hasClass(current, 'manager-card')) {
                            return current;
                        }
                        current = current.parentNode;
                    }
                    return null;
                }

                function createCardFromTemplate() {
                    if (!managerTemplate) {
                        return null;
                    }

                    var source = managerTemplate.content ? managerTemplate.content : managerTemplate;
                    var cardInTemplate = source.querySelector ? source.querySelector('.manager-card') : null;

                    if (cardInTemplate) {
                        return cardInTemplate.cloneNode(true);
                    }

                    var wrapper = document.createElement('div');
                    wrapper.innerHTML = managerTemplate.innerHTML;
                    return wrapper.firstElementChild;
                }

                function cloneBaseCard() {
                    var existingCard = managerList.querySelector('.manager-card');
                    return existingCard ? existingCard.cloneNode(true) : null;
                }

                function buildManagerCard() {
                    return createCardFromTemplate() || cloneBaseCard();
                }

                function clearCardInputs(card) {
                    if (!card) {
                        return;
                    }
                    var inputs = card.querySelectorAll('[data-field]');
                    for (var i = 0; i < inputs.length; i++) {
                        inputs[i].value = '';
                    }
                }

                function createManagerCard() {
                    var card = buildManagerCard();
                    if (!card) {
                        return;
                    }

                    clearCardInputs(card);
                    managerList.appendChild(card);
                    updateManagerCards();

                    var firstInput = card.querySelector('[data-field="name"]');
                    if (firstInput) {
                        firstInput.focus();
                    }
                }

                function updateManagerCards() {
                    var cards = managerList.querySelectorAll('.manager-card');
                    var isSingleCard = cards.length === 1;

                    for (var i = 0; i < cards.length; i++) {
                        var card = cards[i];
                        var number = i + 1;
                        var title = card.querySelector('.manager-title');
                        if (title) {
                            title.textContent = '담당자 ' + number;
                        }

                        var inputs = card.querySelectorAll('[data-field]');
                        for (var j = 0; j < inputs.length; j++) {
                            var input = inputs[j];
                        var field = input.getAttribute('data-field');
                        var inputId = 'manager-' + number + '-' + field;
                        input.id = inputId;
                        input.name = field === 'name' ? 'managerName' : 'managerContact';

                            var label = card.querySelector('[data-label-for="' + field + '"]');
                            if (label) {
                                label.setAttribute('for', inputId);
                            }
                        }

                        var removeButton = card.querySelector('.btn-remove-manager');
                        if (removeButton) {
                            removeButton.disabled = isSingleCard;
                        }
                    }
                }

                if (addManagerBtn) {
                    addManagerBtn.addEventListener('click', function () {
                        createManagerCard();
                    });
                }

                managerList.addEventListener('click', function (event) {
                    var target = event.target;
                    while (target && target !== managerList && !hasClass(target, 'btn-remove-manager')) {
                        target = target.parentNode;
                    }

                    if (!target || !hasClass(target, 'btn-remove-manager')) {
                        return;
                    }

                    var card = findClosestCard(target);
                    var hasSingleCard = managerList.querySelectorAll('.manager-card').length === 1;
                    if (card && !hasSingleCard) {
                        var nextSibling = card.nextElementSibling ? card.nextElementSibling.querySelector('[data-field="name"]') : null;
                        var previousSibling = card.previousElementSibling ? card.previousElementSibling.querySelector('[data-field="name"]') : null;
                        var nextFocusCandidate = nextSibling || previousSibling;

                        card.parentNode.removeChild(card);
                        updateManagerCards();

                        if (nextFocusCandidate) {
                            nextFocusCandidate.focus();
                        }
                    }
                });

                updateManagerCards();
            });
        })();
    </script>
</body>
</html>
