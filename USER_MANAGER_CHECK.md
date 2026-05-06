회원관리 방안 검토사항

# 핵심 결론

```text
1. 업체관리
2. 판매업체관리
3. 구매업체관리
4. 회원관리
```

다만 여기서 **“회원관리”는 업체 자체를 관리하는 메뉴가 아니라, 로그인 계정/담당자/권한을 관리하는 메뉴**로 봐야 합니다.

관리자 화면설계서에도 운영자가 구매자의 신청을 받아 계정을 직접 등록하고, 구매자별 여신·환불계좌·담당자 정보를 관리하는 흐름이 있습니다. 또한 입출금내역 화면에서는 “사용자의 여신과 입금액 합이 미트머니가 됨”이라고 되어 있어 구매업체 관리는 여신/미트머니와 연결되어야 합니다. 

---

# 권장 업무 구분

## 1. 업체관리

**몰 운영 주체 관리 영역**입니다.

대상:

```text
슈퍼관리자가 생성하는 업체
업체 담당자
몰 관리자
```

필요 테이블:

```text
tb_company
tb_company_manager
tb_admin_profile
tb_admin_role
tb_admin_menu_auth
```

역할:

```text
슈퍼관리자 → 업체 생성
슈퍼관리자 → 업체 담당자 부여
업체 담당자 → 해당 몰 관리자 역할 수행
```

---

## 2. 판매업체관리

**상품을 공급하는 판매자 관리 영역**입니다.

대상:

```text
원물 판매자
가공/완제품 판매자
판매업체 담당자
정산계좌
과세유형
```

필요 테이블:

```text
tb_seller_profile
tb_seller_settlement_account
tb_member_contact
tb_sales_product
tb_sales_product_detail
tb_sales_product_price_hist
```

역할:

```text
업체 담당자 → 판매업체 등록
업체 담당자 → 판매유형 등록
업체 담당자 → 판매업체 담당자 계정 부여
```

---

## 3. 구매업체관리

**구매자, 여신, 미트머니, 구매조건 관리 영역**입니다.

대상:

```text
구매업체
구매업체 담당자
여신
미트머니
가입상태
배송지
거래내역
```

필요 테이블:

```text
tb_buyer_profile
tb_credit_account
tb_credit_history
tb_meatmoney_account
tb_meatmoney_txn
tb_meatmoney_deposit_req
tb_member_contact
tb_member_status_hist
```

역할:

```text
채널 담당자 → 구매업체 등록
채널 담당자 → 구매업체 담당자 계정 부여
채널 담당자 → 여신 부여
채널 담당자 → 구매/출고/재고/정산 관리
```

현재 `matpam_new` 구조에도 `tb_member_master`, `tb_buyer_profile`, `tb_seller_profile`, `tb_seller_settlement_account`, `tb_credit_account`, `tb_meatmoney_account` 등이 이미 분리되어 있어 이 방향과 맞습니다. 

---

## 4. 회원관리

**로그인 계정과 권한 관리 영역**입니다.

대상:

```text
업체 담당자 계정
판매업체 담당자 계정
구매업체 담당자 계정
채널 담당자 계정
슈퍼관리자 계정
```

필요 테이블:

```text
tb_member_master
tb_member_contact
tb_admin_profile
tb_admin_role
tb_admin_menu
tb_admin_menu_auth
tb_admin_role_scope
```

중요한 점:

```text
업체관리 = 회사/조직 관리
회원관리 = 로그인 계정/담당자/권한 관리
```

---

# 최종 구조

```text
슈퍼관리자
 └─ 업체관리
     └─ 업체 담당자

업체 담당자
 ├─ 판매업체관리
 │   ├─ 판매업체 등록
 │   ├─ 판매유형 등록
 │   ├─ 정산계좌 등록
 │   └─ 판매업체 담당자 계정 생성
 │
 └─ 채널 담당자 관리
     ├─ 전국택배 담당자
     ├─ 화물운송 담당자
     └─ 공장수령 담당자

채널 담당자
 ├─ 구매업체관리
 │   ├─ 구매업체 등록
 │   ├─ 구매업체 담당자 계정 생성
 │   ├─ 여신 부여
 │   └─ 미트머니/입출금 관리
 │
 ├─ 상품등록 대행
 ├─ 구매관리
 ├─ 출고관리
 ├─ 재고관리
 └─ 정산관리
```

# 결론

네, **업체관리 / 판매업체관리 / 구매업체관리 / 회원관리**로 나누는 것이 맞습니다.

단, “회원관리”는 사업체 정보를 관리하는 메뉴가 아니라 **로그인 계정, 담당자, 권한, 메뉴 접근 범위를 관리하는 공통 계정관리 영역**으로 정의하는 것이 좋습니다.
