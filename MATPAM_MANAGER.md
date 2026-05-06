# MATPAM B2B 플랫폼 — 전체 시스템 설계 문서
> **문서 위치**: 회원/권한(USER_MANAGER.md) + **상품/주문/재고/자금/여신 전체(본 문서)**
> 최초 작성: 2026-05-01 (matpam_manager.md 리뷰 기반 전면 설계)

---

## 변경 이력

| 날짜 | 내용 | 관련 파일 |
|------|------|-----------|
| 2026-05-01 | 최초 작성 — 3개 도메인 분리 설계, P0 우선순위 기반 전체 테이블 정의 | MATPAM_MANAGER.md |
| 2026-05-01 | 상품 마스터 3종 분리 (RAW/PROCESSED/PROCESS_SERVICE), 세금규칙 버전 관리, 상품 연관 테이블 | MATPAM_MANAGER_DDL.sql |
| 2026-05-01 | 주문 라인 세금 스냅샷, 세금문서 분리, 출고 라인 설계 | MATPAM_MANAGER_DDL.sql |
| 2026-05-01 | 재고 원장(처리 배치 + 재고 원장) 설계 | MATPAM_MANAGER_DDL.sql |
| 2026-05-01 | 자금 흐름 Model A (직접 입금 + 원장 기록), 선급금/여신/매출채권 설계 | MATPAM_MANAGER_DDL.sql |
| 2026-05-01 | 권한/승인 워크플로우 테이블 (USER_MANAGER.md §4-10~13 연계) | MATPAM_MANAGER_DDL.sql |

---

## 0. 플랫폼 정체성 — 이것이 핵심

> MATPAM은 **"결제 처리 시스템"이 아니라 "판매자-구매자에게 특화된 B2B 거래 플랫폼"** 입니다.

| 역할 | 실체 |
|------|------|
| MATPAM | 플랫폼/SaaS/중개 시스템 운영자 |
| 판매 당사자 | 판매업체(tb_company, company_type=SELLER) |
| 구매 당사자 | 구매업체(tb_company, company_type=BUYER) |

**플랫폼이 하지 않는 것**
- 플랫폼 자체 전자지갑/머니 보유 ❌
- 결제금액 직접 수취 ❌
- 금융회사/PG 직접 운영 ❌
- 환불/취소 단독 결정 ❌

**플랫폼이 하는 것**
- 주문/정산/세금 처리 시스템 제공
- 입금 사실을 읽어 원장(ledger)에 반영
- 환불/승인은 판매자와 연계한 업무 흐름만 담당

---

## 1. 3개 도메인 분리 원칙

```
┌─────────────────────────────────────────────────────────────┐
│  도메인 1: 회원/권한 (USER_MANAGER.md 참조)                  │
│  tb_tenant / tb_channel / tb_company / tb_company_contact   │
│  tb_user / tb_buyer_channel / tb_permission / tb_approval   │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│  도메인 2: 상품/세금/주문 (본 문서 §2~§4)                    │
│  tb_product / tb_product_tax_rule / tb_product_relation     │
│  tb_order / tb_order_line / tb_tax_document / tb_shipment   │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│  도메인 3: 자금/여신/선급 (본 문서 §5~§6)                    │
│  tb_external_payment_txn / tb_buyer_advance_ledger          │
│  tb_payment_allocation / tb_buyer_credit_policy             │
│  tb_buyer_credit_limit_history / tb_receivable_ledger       │
└─────────────────────────────────────────────────────────────┘
```

> **도메인 간 참조 규칙**
> - 도메인 2는 도메인 1의 `tb_company`, `tb_tenant`를 FK로 참조
> - 도메인 3은 도메인 1의 `tb_company`, 도메인 2의 `tb_order`를 참조
> - 도메인 간 직접 JOIN은 최소화 — 집계·보고서는 별도 뷰/배치 활용

---

## 2. 도메인 2: 상품/세금

### 2-1. 상품 3종 분류 원칙

> **왜 3종인가?** 같은 "냉동삼겹살"이라도 원물(RAW), 가공품(PROCESSED), 가공대행서비스(PROCESS_SERVICE)는 세금 체계와 재고 추적 방식이 완전히 다르다.

| item_kind | processing_type | 예시 | 부가세 가능성 | 재고 추적 |
|-----------|-----------------|------|--------------|-----------|
| GOODS | RAW | 삼겹살 원물, 수산물 | TAX_FREE 가능 | 있음 (lot 단위) |
| GOODS | PROCESSED | 냉동가공품, 양념육 | TAXABLE | 있음 (lot 단위) |
| SERVICE | PROCESS_SERVICE | 발골작업, 포장대행 | TAXABLE | 없음 (실행이력만) |

**세율 결정 원칙 (3단계)**
```
1단계: 상품(SKU) → tax_category 결정 (tb_product.tax_category)
2단계: 세금 규칙 버전 확인 (tb_product_tax_rule.tax_rule_version_id)
3단계: 주문 시 스냅샷 저장 (tb_order_line.tax_category_snapshot)
```

> ❌ **tb_company.default_tax_type으로 세금 결정 금지**
> - `tb_company.default_tax_type` → UI 기본값/대략적 분류 힌트 용도만 사용
> - 최종 세율은 반드시 **상품(SKU) 단위**로 결정, **주문 라인에 스냅샷**

---

### 2-2. tb_product — 상품 마스터

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| product_id | BIGINT | 상품 ID | PK, AUTO_INCREMENT |
| tenant_id | BIGINT | 테넌트 ID | FK → tb_tenant, NOT NULL |
| seller_company_id | BIGINT | 판매업체 ID | FK → tb_company, NOT NULL |
| product_code | VARCHAR(100) | 상품 코드 | UNIQUE(tenant_id, product_code) |
| product_name | VARCHAR(300) | 상품명 | NOT NULL |
| item_kind | ENUM('GOODS','SERVICE') | 상품 종류 | NOT NULL |
| processing_type | ENUM('RAW','PROCESSED','PROCESS_SERVICE') | 가공 유형 | NOT NULL |
| tax_category | ENUM('EXEMPT','TAXABLE') | 과세 구분 | NOT NULL |
| tax_rule_version_id | BIGINT | 적용 세금규칙 버전 ID | FK → tb_product_tax_rule, NULL 가능 |
| independent_sale_yn | CHAR(1) | 단독 판매 가능 여부 | NOT NULL, DEFAULT 'Y' |
| status | ENUM('ACTIVE','INACTIVE','DISCONTINUED') | 상태 | NOT NULL, DEFAULT 'ACTIVE' |
| created_at | DATETIME | 생성일시 | NOT NULL |
| updated_at | DATETIME | 수정일시 | NOT NULL |
| created_by | BIGINT | 등록 사용자 ID | FK → tb_user, NULL |
| updated_by | BIGINT | 수정 사용자 ID | FK → tb_user, NULL |

**운영 규칙**
- `item_kind = SERVICE` → 재고 없음, `processing_type = PROCESS_SERVICE` 강제
- `processing_type = RAW` → `tax_category = EXEMPT` 기본값 (변경 가능, 단 승인 필요)
- `independent_sale_yn = 'N'` → 단독 주문 불가, 반드시 연관 상품과 묶어 주문

**제약**
```sql
CHECK (
    (item_kind = 'SERVICE' AND processing_type = 'PROCESS_SERVICE')
    OR
    (item_kind = 'GOODS' AND processing_type IN ('RAW','PROCESSED'))
)
```

---

### 2-3. tb_product_tax_rule — 상품 세금 규칙 버전

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| tax_rule_version_id | BIGINT | 버전 ID | PK, AUTO_INCREMENT |
| product_id | BIGINT | 상품 ID | FK → tb_product, NOT NULL |
| tax_category | ENUM('EXEMPT','TAXABLE') | 이 버전의 과세 구분 | NOT NULL |
| legal_basis_memo | VARCHAR(1000) | 법적 근거 메모 | NOT NULL |
| effective_from | DATE | 유효 시작일 | NOT NULL |
| effective_to | DATE | 유효 종료일 | NULL (NULL = 현재 유효) |
| approved_by | BIGINT | 승인자 user_id | FK → tb_user, NOT NULL |
| approved_at | DATETIME | 승인일시 | NOT NULL |
| created_at | DATETIME | 생성일시 | NOT NULL |

**운영 규칙**
- 상품 당 `effective_to IS NULL`인 레코드는 **1개만** 허용 (현재 유효 버전)
- 세금 구분 변경 시: ① 기존 버전 `effective_to` 업데이트 → ② 신규 버전 INSERT → ③ tb_product.tax_rule_version_id 갱신
- **변경 워크플로우**: 요청(tb_approval_request, PRODUCT_TAX_CHANGE) → 승인(SUPER_ADMIN) → 적용

**감사 로그 필수**
- `entity_name = 'tb_product'`, `action_type = 'UPDATE'`
- `before_json`: 이전 tax_category, tax_rule_version_id
- `after_json`: 새 tax_category, tax_rule_version_id, legal_basis_memo

---

### 2-4. tb_product_relation — 상품 연관관계

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| relation_id | BIGINT | 연관관계 ID | PK, AUTO_INCREMENT |
| base_product_id | BIGINT | 기준 상품 ID | FK → tb_product, NOT NULL |
| related_product_id | BIGINT | 연관 상품 ID | FK → tb_product, NOT NULL |
| relation_kind | ENUM('RAW_TO_PROCESSED','RAW_TO_PROCESS_SERVICE','PROCESSED_TO_RAW','BUNDLE') | 관계 유형 | NOT NULL |
| bundle_mode | ENUM('RECOMMENDED','OPTIONAL','REQUIRED') | 묶음 모드 | NOT NULL, DEFAULT 'RECOMMENDED' |
| display_order | INT | 표시 순서 | DEFAULT 0 |
| effective_from | DATE | 유효 시작일 | NOT NULL |
| effective_to | DATE | 유효 종료일 | NULL (NULL = 현재 유효) |
| status | ENUM('ACTIVE','INACTIVE') | 상태 | NOT NULL, DEFAULT 'ACTIVE' |
| created_at | DATETIME | 생성일시 | NOT NULL |
| created_by | BIGINT | 등록 사용자 | FK → tb_user, NULL |

**bundle_mode 의미**

| 모드 | 의미 | 주문 시 동작 |
|------|------|-------------|
| `RECOMMENDED` | 추천 연관 — 선택 가능 | 주문 화면에 추천으로 표시, 선택 안 해도 주문 가능 |
| `OPTIONAL` | 선택 추가 — 가격 변동 있음 | 추가 시 해당 상품 단가 합산 |
| `REQUIRED` | 필수 묶음 — 반드시 함께 | 기준 상품 주문 시 연관 상품 자동 포함, 별도 선택 불가 |

> ⚠️ **P0 주의**: 처음에는 RECOMMENDED / OPTIONAL 중심으로 구현, REQUIRED는 추후 도입 (주문 플로우 복잡도 증가)

**제약**
- `UNIQUE (base_product_id, related_product_id, relation_kind, effective_from)` — 같은 조합 중복 불가
- `CHECK (base_product_id != related_product_id)` — 자기 자신 연관 불가

---

## 3. 도메인 2: 주문

### 3-1. 주문 구조 원칙

```
tb_order (주문 헤더 — 1개)
  └── tb_order_line (주문 라인 — N개, 라인별 세금 스냅샷)
        ├── tb_tax_document (세금 문서 — 라인 단위 또는 주문 단위)
        └── tb_shipment_line (출고 라인 — 라인 단위)
```

> **UX**: 주문번호는 1개로 단일 노출
> **내부**: 과세/면세 라인이 혼재할 수 있으므로 세금 문서는 라인 또는 그룹 단위 분리 발행

---

### 3-2. tb_order — 주문 헤더

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| order_id | BIGINT | 주문 ID | PK, AUTO_INCREMENT |
| tenant_id | BIGINT | 테넌트 ID | FK → tb_tenant, NOT NULL |
| order_no | VARCHAR(50) | 주문번호 (표시용) | UNIQUE, NOT NULL |
| seller_company_id | BIGINT | 판매업체 ID | FK → tb_company, NOT NULL |
| buyer_company_id | BIGINT | 구매업체 ID | FK → tb_company, NOT NULL |
| channel_id | BIGINT | 채널 ID | FK → tb_channel, NOT NULL |
| order_status | ENUM('DRAFT','CONFIRMED','PROCESSING','SHIPPED','COMPLETED','CANCELLED') | 주문 상태 | NOT NULL, DEFAULT 'DRAFT' |
| order_date | DATE | 주문일 | NOT NULL |
| total_supply_amount | DECIMAL(18,2) | 공급가액 합계 | NOT NULL, DEFAULT 0 |
| total_vat_amount | DECIMAL(18,2) | 부가세 합계 | NOT NULL, DEFAULT 0 |
| total_amount | DECIMAL(18,2) | 합계금액 (공급가액+부가세) | NOT NULL, DEFAULT 0 |
| memo | VARCHAR(1000) | 주문 메모 | NULL |
| created_by | BIGINT | 주문 생성 사용자 | FK → tb_user, NULL |
| created_at | DATETIME | 생성일시 | NOT NULL |
| updated_at | DATETIME | 수정일시 | NOT NULL |

**주문번호 생성 규칙 (예시)**
```
ORD-{YYYYMMDD}-{채널코드 3자리}-{시퀀스 6자리}
예: ORD-20260501-PAR-000001
```

---

### 3-3. tb_order_line — 주문 라인 (세금 스냅샷 포함)

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| order_line_id | BIGINT | 주문 라인 ID | PK, AUTO_INCREMENT |
| order_id | BIGINT | 주문 ID | FK → tb_order, NOT NULL |
| product_id | BIGINT | 상품 ID | FK → tb_product, NOT NULL |
| line_no | INT | 라인 번호 (주문 내 순서) | NOT NULL |
| item_kind | ENUM('GOODS','SERVICE') | 상품 종류 스냅샷 | NOT NULL |
| processing_type_snapshot | ENUM('RAW','PROCESSED','PROCESS_SERVICE') | 가공유형 스냅샷 | NOT NULL |
| product_name_snapshot | VARCHAR(300) | 주문 시점 상품명 스냅샷 | NOT NULL |
| tax_category_snapshot | ENUM('EXEMPT','TAXABLE') | **주문 시점 과세구분 스냅샷** | NOT NULL |
| tax_rule_version_id | BIGINT | 적용 세금규칙 버전 ID | FK → tb_product_tax_rule, NULL |
| legal_basis_snapshot_memo | VARCHAR(1000) | 주문 시점 법적 근거 메모 스냅샷 | NULL |
| unit_price | DECIMAL(18,2) | 단가 스냅샷 | NOT NULL |
| qty | DECIMAL(18,3) | 수량 | NOT NULL |
| supply_amount | DECIMAL(18,2) | 공급가액 (unit_price × qty) | NOT NULL |
| vat_amount | DECIMAL(18,2) | 부가세액 | NOT NULL, DEFAULT 0 |
| total_amount | DECIMAL(18,2) | 라인 합계 (supply + vat) | NOT NULL |
| relation_group_id | VARCHAR(50) | 묶음 그룹 ID (REQUIRED 묶음 추적용) | NULL |
| line_status | ENUM('ACTIVE','CANCELLED') | 라인 상태 | NOT NULL, DEFAULT 'ACTIVE' |
| created_at | DATETIME | 생성일시 | NOT NULL |
| updated_at | DATETIME | 수정일시 | NOT NULL |

> ⭐ **스냅샷 원칙**: 주문 후 상품 정보(이름, 세금, 단가)가 변경되어도 **주문 라인의 스냅샷은 불변**
> 감사 추적 및 세금계산서 재발행 근거로 활용

**금액 계산 규칙**
```
supply_amount  = unit_price × qty
vat_amount     = (tax_category_snapshot = 'TAXABLE') ? supply_amount × 0.1 : 0
total_amount   = supply_amount + vat_amount
```

---

### 3-4. tb_tax_document — 세금 문서

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| tax_document_id | BIGINT | 세금문서 ID | PK, AUTO_INCREMENT |
| tenant_id | BIGINT | 테넌트 ID | FK → tb_tenant, NOT NULL |
| order_id | BIGINT | 주문 ID | FK → tb_order, NOT NULL |
| document_type | ENUM('TAX_INVOICE','INVOICE','STATEMENT') | 문서 유형 | NOT NULL |
| tax_category | ENUM('EXEMPT','TAXABLE','MIXED') | 문서 내 과세 구분 | NOT NULL |
| supplier_company_id | BIGINT | 공급자 업체 ID | FK → tb_company, NOT NULL |
| receiver_company_id | BIGINT | 공급받는자 업체 ID | FK → tb_company, NOT NULL |
| supply_amount | DECIMAL(18,2) | 공급가액 | NOT NULL |
| vat_amount | DECIMAL(18,2) | 세액 | NOT NULL, DEFAULT 0 |
| total_amount | DECIMAL(18,2) | 합계 | NOT NULL |
| issue_status | ENUM('PENDING','ISSUED','CANCELLED','REISSUED') | 발행 상태 | NOT NULL, DEFAULT 'PENDING' |
| issued_at | DATETIME | 발행일시 | NULL |
| cancelled_at | DATETIME | 취소일시 | NULL |
| reissue_reason | VARCHAR(500) | 재발행 사유 | NULL |
| approval_request_id | BIGINT | 재발행 승인 요청 ID | FK → tb_approval_request, NULL |
| created_at | DATETIME | 생성일시 | NOT NULL |
| updated_at | DATETIME | 수정일시 | NOT NULL |

**문서 유형 결정 규칙**

| 주문 라인 과세 구분 | 발행 문서 |
|---------------------|-----------|
| 전체 TAXABLE | TAX_INVOICE (세금계산서) |
| 전체 EXEMPT | INVOICE (거래명세서) |
| TAXABLE + EXEMPT 혼재 | 분리 발행 (TAXABLE → TAX_INVOICE, EXEMPT → INVOICE) |

**재발행 워크플로우**
```
재발행 요청(SELLER_ADMIN) → tb_approval_request(TAX_DOCUMENT_REISSUE)
→ SUPER_ADMIN 승인 → tb_tax_document 신규 행 INSERT (status=ISSUED)
→ 기존 행 status=REISSUED, tb_audit_log 기록
```

---

### 3-5. tb_shipment_line — 출고 라인

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| shipment_line_id | BIGINT | 출고 라인 ID | PK, AUTO_INCREMENT |
| order_id | BIGINT | 주문 ID | FK → tb_order, NOT NULL |
| order_line_id | BIGINT | 주문 라인 ID | FK → tb_order_line, NOT NULL |
| product_id | BIGINT | 상품 ID | FK → tb_product, NOT NULL |
| lot_id | VARCHAR(100) | 로트 번호 | NULL (PROCESS_SERVICE는 NULL) |
| scheduled_qty | DECIMAL(18,3) | 출고 예정 수량 | NOT NULL |
| shipped_qty | DECIMAL(18,3) | 실제 출고 수량 | NULL |
| shipment_status | ENUM('PENDING','PARTIAL','SHIPPED','CANCELLED') | 출고 상태 | NOT NULL, DEFAULT 'PENDING' |
| scheduled_at | DATE | 출고 예정일 | NULL |
| shipped_at | DATETIME | 실제 출고일시 | NULL |
| created_at | DATETIME | 생성일시 | NOT NULL |
| updated_at | DATETIME | 수정일시 | NOT NULL |
| created_by | BIGINT | 생성 사용자 | FK → tb_user, NULL |

**운영 규칙**
- `item_kind = SERVICE` (PROCESS_SERVICE) → `lot_id = NULL`, 재고 차감 없음, 서비스 실행이력만 기록
- `shipment_status = PARTIAL` → `shipped_qty < scheduled_qty` (부분 출고 허용)
- 채널별 출고 처리 주체:
  - PARCEL (전국택배): 운송장 번호 연계 (추후 확장)
  - FREIGHT (화물직송): 차량 배정 연계 (추후 확장)
  - PICKUP (공장수령): 수령 확인서 연계 (추후 확장)

---

## 4. 재고 추적 (도메인 2 연장)

### 4-1. 재고 추적 원칙

```
원물(RAW) 입고
    └── tb_stock_ledger (txn_type=IN)
          │
          ▼ 가공 처리
    tb_process_batch (input_qty → output_qty, loss_qty)
          │
          ▼
    가공품(PROCESSED) 생성
    └── tb_stock_ledger (RAW: txn_type=CONSUME, PROCESSED: txn_type=PRODUCE)
          │
          ▼ 출고 (주문)
    tb_stock_ledger (txn_type=OUT, ref_table=tb_shipment_line)
```

---

### 4-2. tb_process_batch — 가공 처리 배치

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| process_batch_id | BIGINT | 배치 ID | PK, AUTO_INCREMENT |
| tenant_id | BIGINT | 테넌트 ID | FK → tb_tenant, NOT NULL |
| seller_company_id | BIGINT | 판매업체 ID | FK → tb_company, NOT NULL |
| source_product_id | BIGINT | 원물 상품 ID | FK → tb_product (RAW), NOT NULL |
| target_product_id | BIGINT | 가공품 상품 ID | FK → tb_product (PROCESSED), NOT NULL |
| process_service_product_id | BIGINT | 가공서비스 상품 ID | FK → tb_product (PROCESS_SERVICE), NULL |
| source_lot_id | VARCHAR(100) | 원물 로트 번호 | NULL |
| target_lot_id | VARCHAR(100) | 가공품 로트 번호 | NULL |
| input_qty | DECIMAL(18,3) | 투입 수량 (원물) | NOT NULL |
| output_qty | DECIMAL(18,3) | 생산 수량 (가공품) | NOT NULL |
| loss_qty | DECIMAL(18,3) | 손실 수량 | NOT NULL, DEFAULT 0 |
| batch_status | ENUM('PLANNED','IN_PROGRESS','COMPLETED','CANCELLED') | 배치 상태 | NOT NULL |
| processed_at | DATETIME | 가공 완료일시 | NULL |
| processed_by | BIGINT | 처리 사용자 | FK → tb_user, NULL |
| created_at | DATETIME | 생성일시 | NOT NULL |
| updated_at | DATETIME | 수정일시 | NOT NULL |

**검증 규칙**
```
input_qty = output_qty + loss_qty  (완료 시 검증)
```

---

### 4-3. tb_stock_ledger — 재고 원장

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| stock_txn_id | BIGINT | 재고 거래 ID | PK, AUTO_INCREMENT |
| tenant_id | BIGINT | 테넌트 ID | FK → tb_tenant, NOT NULL |
| product_id | BIGINT | 상품 ID | FK → tb_product, NOT NULL |
| lot_id | VARCHAR(100) | 로트 번호 | NULL |
| txn_type | ENUM('IN','OUT','ADJUST','CONSUME','PRODUCE') | 거래 유형 | NOT NULL |
| qty | DECIMAL(18,3) | 수량 (IN/PRODUCE = 양수, OUT/CONSUME = 음수) | NOT NULL |
| balance_after | DECIMAL(18,3) | 거래 후 잔량 | NOT NULL |
| ref_table | VARCHAR(100) | 참조 테이블명 | NOT NULL |
| ref_id | BIGINT | 참조 ID | NOT NULL |
| txn_at | DATETIME | 거래일시 | NOT NULL |
| created_by | BIGINT | 생성 사용자 | FK → tb_user, NULL |
| memo | VARCHAR(500) | 메모 | NULL |

**txn_type 매핑**

| txn_type | 참조 테이블 | 설명 |
|----------|-------------|------|
| IN | tb_order_line (구매 입고) / 직접 입고 | 재고 증가 |
| OUT | tb_shipment_line | 판매 출고 |
| CONSUME | tb_process_batch | 가공 투입 (원물 차감) |
| PRODUCE | tb_process_batch | 가공 완료 (가공품 증가) |
| ADJUST | (직접 조정) | 재고 실사/조정 |

> ⚠️ **서비스(PROCESS_SERVICE) 상품은 재고 없음** — tb_stock_ledger 레코드 생성 안 함
> 서비스 실행 기록은 tb_process_batch에서 관리 (input/output 수량으로 추적)

---

## 5. 도메인 3: 자금 흐름

### 5-1. 자금 모델 선택: Model A (권장)

> **Model A: 판매사 직접 입금 + 플랫폼 원장 기록**

```
구매업체 → [직접 송금] → 판매업체 계좌 (tb_company_bank_account)
                              │
                              ▼ 입금 확인 후
              플랫폼 원장에 기록 (tb_buyer_advance_ledger)
                              │
                              ▼ 주문 확정 시
              선급금/여신 할당 (tb_payment_allocation)
```

**Model A 선택 이유**
- 플랫폼이 자금 수취자가 아니므로 금융업/PG 라이선스 불필요
- 정산 복잡도 최소화
- 구매업체의 seller_advance_balance(선급 잔액)만 추적

---

### 5-2. tb_external_payment_txn — 외부 입금 거래

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| payment_txn_id | BIGINT | 거래 ID | PK, AUTO_INCREMENT |
| tenant_id | BIGINT | 테넌트 ID | FK → tb_tenant, NOT NULL |
| seller_company_id | BIGINT | 판매업체 ID | FK → tb_company, NOT NULL |
| buyer_company_id | BIGINT | 구매업체 ID | FK → tb_company, NOT NULL |
| txn_type | ENUM('ADVANCE_DEPOSIT','CREDIT_PAYMENT','REFUND_OUT') | 거래 유형 | NOT NULL |
| amount | DECIMAL(18,2) | 금액 | NOT NULL |
| bank_name | VARCHAR(100) | 입금 은행 | NULL |
| depositor_name | VARCHAR(100) | 입금자명 | NULL |
| deposited_at | DATETIME | 입금 확인 일시 | NOT NULL |
| confirm_status | ENUM('PENDING','CONFIRMED','REJECTED') | 확인 상태 | NOT NULL, DEFAULT 'PENDING' |
| confirmed_by | BIGINT | 확인 사용자 | FK → tb_user, NULL |
| confirmed_at | DATETIME | 확인 일시 | NULL |
| memo | VARCHAR(500) | 메모 | NULL |
| created_at | DATETIME | 생성일시 | NOT NULL |
| updated_at | DATETIME | 수정일시 | NOT NULL |

---

### 5-3. tb_buyer_advance_ledger — 구매업체 선급금 원장

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| advance_ledger_id | BIGINT | 원장 ID | PK, AUTO_INCREMENT |
| tenant_id | BIGINT | 테넌트 ID | FK → tb_tenant, NOT NULL |
| buyer_company_id | BIGINT | 구매업체 ID | FK → tb_company, NOT NULL |
| seller_company_id | BIGINT | 판매업체 ID | FK → tb_company, NOT NULL |
| txn_type | ENUM('DEPOSIT','USE','REFUND','ADJUST') | 거래 유형 | NOT NULL |
| amount | DECIMAL(18,2) | 금액 (DEPOSIT/ADJUST 양수, USE 음수) | NOT NULL |
| balance_after | DECIMAL(18,2) | 거래 후 잔액 | NOT NULL |
| ref_table | VARCHAR(100) | 참조 테이블명 | NULL |
| ref_id | BIGINT | 참조 ID | NULL |
| reason_code | VARCHAR(100) | 사유 코드 | NULL |
| approval_request_id | BIGINT | 승인 요청 ID | FK → tb_approval_request, NULL |
| txn_at | DATETIME | 거래일시 | NOT NULL |
| created_by | BIGINT | 생성 사용자 | FK → tb_user, NULL |
| memo | VARCHAR(500) | 메모 | NULL |

---

### 5-4. tb_payment_allocation — 결제 할당 원장

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| allocation_id | BIGINT | 할당 ID | PK, AUTO_INCREMENT |
| tenant_id | BIGINT | 테넌트 ID | FK → tb_tenant, NOT NULL |
| order_id | BIGINT | 주문 ID | FK → tb_order, NOT NULL |
| source_type | ENUM('ADVANCE','CREDIT','EXTERNAL_PAYMENT') | 결제 재원 유형 | NOT NULL |
| source_ref_id | BIGINT | 재원 참조 ID (선급원장ID/외부결제ID) | NOT NULL |
| allocated_amount | DECIMAL(18,2) | 할당 금액 | NOT NULL |
| allocated_at | DATETIME | 할당 일시 | NOT NULL |
| created_by | BIGINT | 할당 사용자 | FK → tb_user, NULL |

**할당 우선순위 정책 (Policy 1 — 권장)**
```
1순위: 선급금(ADVANCE) 먼저 차감
2순위: 여신한도(CREDIT) 사용
3순위: 직접 외부 결제(EXTERNAL_PAYMENT)
```

> 이 정책은 서비스 레이어에서 강제 — DB 레벨 제약 아님

**환불 정책**
- 환불은 반드시 **원래 납부자** 기준으로만 처리
- 여신 사용분 → 여신 한도 복구 (tb_receivable_ledger, txn_type=REFUND)
- 선급금 사용분 → 선급금 복구 (tb_buyer_advance_ledger, txn_type=REFUND)
- 제3자 계좌 환불 ❌ 절대 금지
- 판매자 승인 + tb_audit_log 필수

---

## 6. 도메인 3: 여신 (외상 한도)

### 6-1. 여신 개념 원칙

> **여신 = 플랫폼 대출이 아니라 판매업체가 구매업체에게 부여하는 외상 한도**

| 역할 | 책임 |
|------|------|
| 채권자 | 판매업체 (tb_company, SELLER) |
| 채무자 | 구매업체 (tb_company, BUYER) |
| 플랫폼 | 한도 설정/승인/원장 기록 중간 역할만 수행 |

**여신 3대 원칙**
- 테넌트/판매업체별 분리 — 타 판매업체 여신 공유 불가
- 타 구매업체 양도 불가
- 현금화(환금) 불가

---

### 6-2. tb_buyer_credit_policy — 구매업체 여신 정책

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| credit_policy_id | BIGINT | 정책 ID | PK, AUTO_INCREMENT |
| tenant_id | BIGINT | 테넌트 ID | FK → tb_tenant, NOT NULL |
| seller_company_id | BIGINT | 판매업체 ID | FK → tb_company, NOT NULL |
| buyer_company_id | BIGINT | 구매업체 ID | FK → tb_company, NOT NULL |
| credit_limit_amount | DECIMAL(18,2) | 여신 한도 금액 | NOT NULL, DEFAULT 0 |
| payment_terms_days | INT | 결제 기한 (일수) | NOT NULL, DEFAULT 30 |
| status | ENUM('ACTIVE','SUSPENDED','CLOSED') | 정책 상태 | NOT NULL, DEFAULT 'ACTIVE' |
| created_at | DATETIME | 생성일시 | NOT NULL |
| updated_at | DATETIME | 수정일시 | NOT NULL |
| created_by | BIGINT | 생성 사용자 | FK → tb_user, NULL |

**제약**
- `UNIQUE (tenant_id, seller_company_id, buyer_company_id)` — 판매-구매 조합당 정책 1개

---

### 6-3. tb_buyer_credit_limit_history — 여신 한도 변경 이력

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| credit_history_id | BIGINT | 이력 ID | PK, AUTO_INCREMENT |
| credit_policy_id | BIGINT | 정책 ID | FK → tb_buyer_credit_policy, NOT NULL |
| old_limit | DECIMAL(18,2) | 변경 전 한도 | NOT NULL |
| new_limit | DECIMAL(18,2) | 변경 후 한도 | NOT NULL |
| reason | VARCHAR(500) | 변경 사유 | NOT NULL |
| requested_by | BIGINT | 요청자 user_id | FK → tb_user, NOT NULL |
| approved_by | BIGINT | 승인자 user_id | FK → tb_user, NULL |
| approved_at | DATETIME | 승인 일시 | NULL |
| approval_request_id | BIGINT | 승인 요청 ID | FK → tb_approval_request, NULL |
| created_at | DATETIME | 생성일시 | NOT NULL |

**변경 워크플로우**
```
SELLER_ADMIN 한도 변경 요청
  → tb_approval_request (CREDIT_LIMIT_CHANGE) INSERT
  → SUPER_ADMIN 또는 SELLER_ADMIN 승인
  → tb_buyer_credit_policy.credit_limit_amount 업데이트
  → tb_buyer_credit_limit_history INSERT
  → tb_audit_log 기록 (before/after)
```

---

### 6-4. tb_receivable_ledger — 매출채권 원장

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| receivable_id | BIGINT | 원장 ID | PK, AUTO_INCREMENT |
| tenant_id | BIGINT | 테넌트 ID | FK → tb_tenant, NOT NULL |
| buyer_company_id | BIGINT | 구매업체 ID | FK → tb_company, NOT NULL |
| seller_company_id | BIGINT | 판매업체 ID | FK → tb_company, NOT NULL |
| txn_type | ENUM('ORDER_USE','PAYMENT_RECEIPT','ADJUST','REFUND') | 거래 유형 | NOT NULL |
| amount | DECIMAL(18,2) | 금액 (ORDER_USE 양수=채권 발생, PAYMENT_RECEIPT 음수=채권 감소) | NOT NULL |
| balance_after | DECIMAL(18,2) | 거래 후 채권 잔액 | NOT NULL |
| ref_order_id | BIGINT | 참조 주문 ID | FK → tb_order, NULL |
| ref_payment_id | BIGINT | 참조 결제 거래 ID | FK → tb_external_payment_txn, NULL |
| txn_at | DATETIME | 거래일시 | NOT NULL |
| created_by | BIGINT | 생성 사용자 | FK → tb_user, NULL |
| memo | VARCHAR(500) | 메모 | NULL |

**원장 흐름**

| 이벤트 | txn_type | amount 부호 |
|--------|----------|-------------|
| 여신으로 주문 확정 | ORDER_USE | + (채권 발생) |
| 결제 수령 확인 | PAYMENT_RECEIPT | - (채권 감소) |
| 환불 처리 | REFUND | - (채권 감소) |
| 수동 조정 | ADJUST | ± |

---

## 7. 권한/승인 워크플로우

> 상세 테이블 명세 → **USER_MANAGER.md §4-10~13** 참조

### 7-1. 권한 코드 전체 목록

| permission_code | domain | 설명 | 기본 보유 역할 |
|-----------------|--------|------|----------------|
| PRODUCT_CREATE | PRODUCT | 상품 생성 | SELLER_ADMIN |
| PRODUCT_EDIT | PRODUCT | 상품 수정 | SELLER_ADMIN |
| PRODUCT_TAX_EDIT | PRODUCT | 상품 세금구분 변경 요청 | SELLER_ADMIN |
| PRODUCT_TAX_APPROVE | PRODUCT | 상품 세금구분 변경 승인 | SUPER_ADMIN |
| PRODUCT_RELATION_EDIT | PRODUCT | 상품 연관관계 변경 | SELLER_ADMIN |
| ORDER_VIEW | ORDER | 주문 조회 | SELLER_ADMIN, CHANNEL_ADMIN, BUYER_ADMIN |
| ORDER_CREATE | ORDER | 주문 생성 | BUYER_ADMIN, CHANNEL_ADMIN |
| ORDER_CANCEL | ORDER | 주문 취소 요청 | BUYER_ADMIN |
| ORDER_CANCEL_APPROVE | ORDER | 주문 취소 승인 | SELLER_ADMIN |
| CREDIT_LIMIT_EDIT | FINANCE | 여신한도 변경 요청 | SELLER_ADMIN |
| CREDIT_LIMIT_APPROVE | FINANCE | 여신한도 변경 승인 | SUPER_ADMIN, SELLER_ADMIN |
| ADVANCE_DEPOSIT_CONFIRM | FINANCE | 선급금 입금 확인 | SELLER_ADMIN |
| ADVANCE_ADJUST | FINANCE | 선급금 조정 | SUPER_ADMIN |
| REFUND_APPROVE | FINANCE | 환불 승인 | SELLER_ADMIN |
| TAX_DOCUMENT_VIEW | ORDER | 세금 문서 조회 | SELLER_ADMIN, BUYER_ADMIN |
| TAX_DOCUMENT_ISSUE | ORDER | 세금계산서 발행 | SELLER_ADMIN |
| TAX_DOCUMENT_REISSUE_REQUEST | ORDER | 세금계산서 재발행 요청 | SELLER_ADMIN |
| TAX_DOCUMENT_REISSUE_APPROVE | ORDER | 세금계산서 재발행 승인 | SUPER_ADMIN |
| BANK_ACCOUNT_EDIT | FINANCE | 계좌정보 변경 요청 | SELLER_ADMIN |
| BANK_ACCOUNT_APPROVE | FINANCE | 계좌정보 변경 승인 | SUPER_ADMIN |
| AUDIT_LOG_VIEW | AUDIT | 감사로그 조회 | SUPER_ADMIN |
| AUDIT_LOG_VIEW_OWN | AUDIT | 자기 테넌트 감사로그 조회 | SELLER_ADMIN |
| USER_CREATE | USER | 사용자 생성 | SUPER_ADMIN, SELLER_ADMIN |
| USER_PERMISSION_OVERRIDE | USER | 사용자 권한 개별 오버라이드 | SUPER_ADMIN |
| STOCK_ADJUST | PRODUCT | 재고 조정 | SELLER_ADMIN |
| PROCESS_BATCH_CREATE | PRODUCT | 가공 배치 생성 | SELLER_ADMIN |

### 7-2. 역할별 기본 권한 매트릭스

| 권한 코드 | SUPER_ADMIN | SELLER_ADMIN | CHANNEL_ADMIN | BUYER_ADMIN |
|-----------|:-----------:|:------------:|:-------------:|:-----------:|
| PRODUCT_CREATE | ✅ | ✅ | ❌ | ❌ |
| PRODUCT_TAX_EDIT | ✅ | ✅ | ❌ | ❌ |
| PRODUCT_TAX_APPROVE | ✅ | ❌ | ❌ | ❌ |
| ORDER_VIEW | ✅ | ✅ | ✅ | ✅ |
| ORDER_CREATE | ✅ | ✅ | ✅ | ✅ |
| ORDER_CANCEL_APPROVE | ✅ | ✅ | ❌ | ❌ |
| CREDIT_LIMIT_EDIT | ✅ | ✅ | ❌ | ❌ |
| CREDIT_LIMIT_APPROVE | ✅ | ✅ | ❌ | ❌ |
| ADVANCE_DEPOSIT_CONFIRM | ✅ | ✅ | ❌ | ❌ |
| REFUND_APPROVE | ✅ | ✅ | ❌ | ❌ |
| TAX_DOCUMENT_REISSUE_APPROVE | ✅ | ❌ | ❌ | ❌ |
| BANK_ACCOUNT_APPROVE | ✅ | ❌ | ❌ | ❌ |
| AUDIT_LOG_VIEW | ✅ | ❌ | ❌ | ❌ |
| AUDIT_LOG_VIEW_OWN | ✅ | ✅ | ❌ | ❌ |
| USER_PERMISSION_OVERRIDE | ✅ | ❌ | ❌ | ❌ |
| STOCK_ADJUST | ✅ | ✅ | ❌ | ❌ |

### 7-3. 승인 워크플로우 요약

| 요청 유형 | 요청 주체 | 승인 주체 | 참조 |
|-----------|-----------|-----------|------|
| PRODUCT_TAX_CHANGE | SELLER_ADMIN | SUPER_ADMIN | §2-3 |
| CREDIT_LIMIT_CHANGE | SELLER_ADMIN | SUPER_ADMIN / SELLER_ADMIN | §6-3 |
| REFUND | CHANNEL_ADMIN / SELLER_ADMIN | SELLER_ADMIN | §5-4 |
| TAX_DOCUMENT_REISSUE | SELLER_ADMIN | SUPER_ADMIN | §3-4 |
| USER_PERMISSION_OVERRIDE | SELLER_ADMIN | SUPER_ADMIN | USER_MANAGER.md §4-12 |
| BANK_ACCOUNT_CHANGE | SELLER_ADMIN | SUPER_ADMIN | USER_MANAGER.md §4-7 |

---

## 8. 감사 로그 확장 이벤트 목록

> 기본 구조: USER_MANAGER.md §4-9 (tb_audit_log) 참조
> 여기서는 도메인 2/3 추가 이벤트 정의

| 이벤트 | entity_name | action_type | 필수 필드 |
|--------|-------------|-------------|-----------|
| 상품 세금구분 변경 | tb_product | UPDATE | before/after tax_category, tax_rule_version_id, approval_request_id |
| 상품 연관관계 변경 | tb_product_relation | INSERT/UPDATE | relation_kind, bundle_mode, before/after |
| 가격 정책 변경 | tb_product | UPDATE | before/after unit_price, reason_code |
| 주문 취소 시도 | tb_order | UPDATE | order_id, status before/after, reason_code |
| 세금계산서 재발행 | tb_tax_document | UPDATE | document_id, reissue_reason, approval_request_id |
| 여신한도 변경 | tb_buyer_credit_policy | UPDATE | old_limit, new_limit, approval_request_id |
| 선급금 조정 | tb_buyer_advance_ledger | INSERT | amount, reason_code |
| 환불 처리 | tb_payment_allocation | INSERT | amount, source_type, reason_code, approval_request_id |
| 재고 조정 | tb_stock_ledger | INSERT | product_id, qty before/after, reason_code |
| 외부 입금 확인 | tb_external_payment_txn | UPDATE | confirm_status, confirmed_by |

**공통 민감정보 마스킹 원칙** (before_json / after_json 적용)

| 데이터 | 마스킹 규칙 |
|--------|-------------|
| 계좌번호 | `"****-****-1234"` (뒤 4자리만 표시) |
| 사업자등록번호 | `"123-**-*****"` (앞 3자리만) |
| 전화번호 | `"010-****-5678"` (앞 3자리, 뒤 4자리) |
| 이메일 | `"us***@domain.com"` (앞 2자리만) |
| 비밀번호 | 절대 기록 금지 (`[REDACTED]`) |

---

## 9. 계약서 / 이용약관 반영 요구사항

> **법무 검토 필수 항목** — 플랫폼이 자금 중개자가 아님을 명시

| 항목 | 내용 |
|------|------|
| 자금 수취 주체 | 플랫폼이 아닌 판매업체가 직접 수취함을 명시 |
| 여신 주체 | 여신은 판매업체가 구매업체에게 부여하는 외상 한도이며 플랫폼 대출이 아님 |
| 환불 주체 | 환불은 판매업체 승인 후 처리, 플랫폼은 원장 기록만 관리 |
| 개인정보 | 전화번호, 이메일, 사업자번호, 계좌번호는 암호화/마스킹 처리 명시 |
| 감사 로그 | 주요 변경사항은 감사 로그에 기록되며 최소 N년 보존 |

---

## 10. 구현 우선순위 (P0 → P2)

### P0 — 즉시 구현 (이번 스프린트)

| 항목 | 설명 | 관련 테이블 |
|------|------|-------------|
| 상품 마스터 3종 분리 | RAW/PROCESSED/PROCESS_SERVICE | tb_product |
| 상품-상품 연관 테이블 | RECOMMENDED/OPTIONAL 중심 | tb_product_relation |
| 주문 라인 세금 스냅샷 | 주문 시 tax_category/unit_price 불변 저장 | tb_order_line |
| 선급금/여신/결제 원장 | Model A 기반 원장 구조 | tb_buyer_advance_ledger, tb_payment_allocation, tb_receivable_ledger |
| 회사 레벨 세금 기본값 격하 | tb_company.default_tax_type → UI 힌트 전용 | tb_company (운영 규칙 변경) |

### P1 — 다음 스프린트

| 항목 | 설명 |
|------|------|
| 세금 규칙 버전 관리 | tb_product_tax_rule 활성화 + 승인 워크플로우 연계 |
| 재고 입고/출고/조정 | tb_stock_ledger + 가공 배치 |
| 결제 할당 정책 | 선급→여신 순서 서비스 레이어 구현 |
| 승인 워크플로우 | tb_approval_request 전체 유형 처리 UI |
| 감사 로그 뷰 화면 | AUDIT_LOG_VIEW 권한 기반 조회 화면 |

### P2 — 추후 확장

| 항목 | 설명 |
|------|------|
| 판매업체 정산 보고서 | 기간별 매출/세금 정산 리포트 |
| 외부결제/PG 연동 | tb_external_payment_txn 기반 PG 연결 |
| 세금계산서 재발행 UI | 승인 워크플로우 연계 발행 화면 |
| 환불 처리 화면 | REFUND_APPROVE 권한 기반 처리 화면 |
| 채널별 출고 연동 | 운송장/차량배정/수령확인서 연계 |

---

## 11. 앞으로 절대 하면 안 되는 6가지

| # | 금지 사항 | 이유 |
|---|-----------|------|
| 1 | 단일 SKU로 과세/면세 동시 처리 | 세금계산서 발행 오류, 세무 리스크 |
| 2 | 확정 주문 후 주문라인 세금구분 변경 | 세금계산서 소급 변경 불가 |
| 3 | REQUIRED 묶음 없이 단품으로 주문 허용 | 업무 규칙 위반, 매출 누락 |
| 4 | 플랫폼이 자금 수취 후 판매자에게 이체 | 전자금융업/PG 라이선스 문제 |
| 5 | 판매자 계좌가 아닌 플랫폼 계좌로 환불 | 자금 중개 리스크 |
| 6 | 확정 주문의 tax_category 수정 | 불변 스냅샷 원칙 위반 |

---

## 12. 테이블 전체 목록 요약

### 도메인 1: 회원/권한 (USER_MANAGER.md)
```
tb_tenant, tb_channel, tb_company, tb_company_contact
tb_user, tb_buyer_channel, tb_company_bank_account, tb_buyer_financial
tb_audit_log, tb_permission, tb_role_permission
tb_user_permission_override, tb_approval_request
```

### 도메인 2: 상품/세금/주문/재고
```
tb_product              — 상품 마스터 (RAW/PROCESSED/PROCESS_SERVICE)
tb_product_tax_rule     — 상품 세금 규칙 버전
tb_product_relation     — 상품 연관관계
tb_order                — 주문 헤더
tb_order_line           — 주문 라인 (세금 스냅샷 포함)
tb_tax_document         — 세금 문서 (세금계산서/거래명세서)
tb_shipment_line        — 출고 라인
tb_process_batch        — 가공 처리 배치
tb_stock_ledger         — 재고 원장
```

### 도메인 3: 자금/여신/선급
```
tb_external_payment_txn         — 외부 입금 거래 기록
tb_buyer_advance_ledger         — 구매업체 선급금 원장
tb_payment_allocation           — 결제 할당 원장 (선급/여신/직접결제)
tb_buyer_credit_policy          — 구매업체 여신 정책
tb_buyer_credit_limit_history   — 여신 한도 변경 이력
tb_receivable_ledger            — 매출채권 원장
```

**전체 합계: 도메인 1 (13개) + 도메인 2 (9개) + 도메인 3 (6개) = 28개 테이블**

---

## 13. 테스트 코드 가이드라인

### 13-1. 도메인 2 핵심 테스트 케이스

```java
// ProductServiceTest — 상품 세금 스냅샷 검증
@Test
void orderLine_taxSnapshot_isImmutableAfterProductChange() {
    // 주문 라인 생성 시 tax_category_snapshot 저장 확인
    // 이후 tb_product.tax_category 변경 → 주문 라인 스냅샷 불변 확인
}

@Test
void product_taxChange_requiresApprovalWorkflow() {
    // SELLER_ADMIN이 tax_category 변경 요청 → PENDING 상태 approval_request 생성
    // SUPER_ADMIN 승인 전까지 tb_product.tax_category 변경 안 됨 확인
}

@Test
void productRelation_required_preventsStandaloneOrder() {
    // REQUIRED 연관 상품이 있는 경우 단품 주문 시 예외 발생 확인
}
```

### 13-2. 도메인 3 핵심 테스트 케이스

```java
// PaymentServiceTest — 할당 우선순위 검증
@Test
void paymentAllocation_advanceFirst_thenCredit() {
    // 선급금 잔액 있을 때: ADVANCE 먼저 차감 후 CREDIT 사용 확인
}

@Test
void refund_onlyToOriginalPayer_notThirdParty() {
    // 환불 시 원래 납부처 이외 계좌 지정 불가 확인
}

@Test
void creditLimit_change_requiresApproval() {
    // CREDIT_LIMIT_CHANGE 요청 → PENDING 상태 확인
    // 승인 전 credit_limit_amount 변경 안 됨 확인
}

@Test
void receivableLedger_balanceAfter_isConsistent() {
    // ORDER_USE → PAYMENT_RECEIPT 순서로 원장 잔액 일관성 검증
}
```

---

> **연관 문서**
> - 회원/권한 상세: `USER_MANAGER.md`
> - DDL 전체: `MATPAM_MANAGER_DDL.sql`
> - 초기 데이터: `USER_MANAGER_SQL_FINAL.sql`
