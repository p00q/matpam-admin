# USER MANAGER
> **MATPAM B2B 폐쇄 플랫폼 — 회원 관리 설계 문서**
> 최초 작성: 2025-01 / **최종 업데이트: 2026-05-01** (matpam_manager.md 설계 검토 반영 — 3개 도메인 분리, 권한/승인 워크플로우 확정)

---

## 변경 이력

| 날짜 | 변경 내용 | 관련 파일 |
|------|-----------|-----------|
| 2025-01 | 최초 설계 (9개 테이블, 4개 역할 정의) | USER_MANAGER.md |
| 2025-01 | SQL DDL 확정 | USER_MANAGER_SQL_FINAL.sql |
| 2026-05-01 | **SUPER_ADMIN 역할 추가**, 역할별 NULL 규칙 확정, tb_user CHECK 제약 추가 | USER_MANAGER_SQL_FINAL.sql |
| 2026-05-01 | **UserVO 보조 필드 추가** — passwordConfirm, createContactYn, contactRole, isPrimaryContact / 조인 필드 — companyName, tenantName, channelName, channelCode | UserVO.java |
| 2026-05-01 | **UserServiceImpl 전면 개편** — applyRoleConstraints(), insertUser() 저장 순서 확정, selectFormOptions() 신규, defaultContactRole() 헬퍼 추가 | UserServiceImpl.java |
| 2026-05-01 | **UserMapper.xml 쿼리 5개 신규 추가** — selectActiveTenantList, selectChannelListByTenant, selectBuyerCompanyListByTenant, selectSellerCompanyIdByTenant, insertCompanyContact | UserMapper.xml, UserMapper.java |
| 2026-05-01 | **UserController AJAX 엔드포인트 4개 추가** — formOptions, saveUser, checkLoginId, updateStatus, userStats | UserController.java |
| 2026-05-01 | **UserForm.jsp 전면 재설계** — 역할 카드 UI, 동적 소속 섹션, 비밀번호 강도 바, 담당자 동시 생성 토글 | UserForm.jsp |
| 2026-05-01 | **UserList.jsp 전면 재설계** — KPI 카드 4개, 4필터 검색, 상태 인라인 드롭다운 변경, 페이지 단위 선택(10/20/50/100) | UserList.jsp |
| 2026-05-01 | **matpam_manager.md 설계 검토 반영** — 3개 도메인 분리 원칙 확정, tb_permission/tb_role_permission/tb_user_permission_override/tb_approval_request 명세 확정, 감사로그 확장(reason_code/approval_request_id/trace_id), 권한 매트릭스 전체 정의, tb_company.seller_type 및 default_tax_type 역할 재정의 | USER_MANAGER.md, MATPAM_MANAGER.md, MATPAM_MANAGER_DDL.sql |

---

## 1. 기본 구상

### 운영 구조
- 플랫폼은 판매업체별로 **1개씩 분양** (테넌트 = 플랫폼 인스턴스)
- 하나의 테넌트에 **판매업체 1개**
- 그 테넌트 안에 **구매업체 여러 개**
- 채널은 **전국택배(PARCEL) / 화물직송(FREIGHT) / 공장수령(PICKUP)** 3종

### 핵심 원칙 — 절대 합치면 안 되는 3가지

| 개념 | 정의 | 이유 |
|------|------|------|
| **업체 (Company)** | 법적 거래주체 | 사업자등록번호·세금계산서 주체 |
| **사용자 (User)** | 로그인 계정 | 접속자 식별·권한 관리 |
| **채널 (Channel)** | 운영 범위 | 전국택배/화물직송/공장수령 구분 |

> 이 3개를 합쳐버리면 "이 주문의 공급자가 누구냐", "채널관리자가 왜 거래 주체처럼 보이냐"가 꼬입니다.

---

## 2. 데이터 원칙

| 원칙 | 내용 |
|------|------|
| **원칙 A** | 업체는 법적 거래주체다 |
| **원칙 B** | 사용자는 로그인 계정이다 |
| **원칙 C** | 채널은 운영/권한 범위다 |
| **원칙 D** | 세금계산서의 공급자/공급받는자는 반드시 **업체** 기준이다 |
| **원칙 E** | `default_tax_type`은 **UI 기본값 힌트**이지 최종 세율 확정값이 아니다. 최종 세율은 반드시 **상품(SKU) 단위(tb_product.tax_category)**로 결정하고 **주문 라인(tb_order_line)에 스냅샷** 저장 |
| **원칙 F** | 비밀번호·계좌번호는 평문 저장 금지. 반드시 암호화 (BCrypt / AES) |
| **원칙 G** | 플랫폼은 자금 수취자가 아니다. 입금은 판매업체 계좌로 직접 수취, 플랫폼은 원장(ledger)만 기록 |
| **원칙 H** | 여신한도(credit_limit)는 플랫폼 대출이 아니라 판매업체가 구매업체에게 부여하는 외상한도 |
| **원칙 I** | 권한(permission)은 역할(role)에 기본값이 있고, 개별 오버라이드는 반드시 승인 절차 필요 |

---

## 3. 역할 정의 (최종 확정 — 4개)

> **2026-05-01 변경**: 기존 3개 역할(SELLER_ADMIN / CHANNEL_ADMIN / BUYER_ADMIN)에서 **SUPER_ADMIN 추가**하여 4개 역할로 확정

### 3-1. 역할별 정의

| 역할 | 한글명 | 권한 범위 |
|------|--------|-----------|
| `SUPER_ADMIN` | 수퍼관리자 | 플랫폼 전체 — 테넌트 생성·수정, 판매업체 등록, 전체 감사로그 조회 |
| `SELLER_ADMIN` | 판매처관리자 | 자기 테넌트 전체 — 채널관리자·구매업체 등록/수정, 여신한도 관리 |
| `CHANNEL_ADMIN` | 채널관리자 | 자기 채널 범위 — 담당 채널의 구매업체만 등록/수정/조회 |
| `BUYER_ADMIN` | 구매처관리자 | 자기 구매업체 — 업체 정보 조회/수정, 담당자 관리 |

### 3-2. 역할별 소속 정보 규칙 ★ 핵심

| 역할 | tenant_id | company_id | channel_id |
|------|-----------|------------|------------|
| `SUPER_ADMIN` | **NULL** | **NULL** | **NULL** |
| `SELLER_ADMIN` | NOT NULL | 판매업체 (서버 자동세팅) | **NULL** |
| `CHANNEL_ADMIN` | NOT NULL | 판매업체 (서버 자동세팅) | NOT NULL |
| `BUYER_ADMIN` | NOT NULL | 구매업체 (직접선택) | **NULL** |

> - `SELLER_ADMIN`, `CHANNEL_ADMIN`의 `company_id`는 `tb_tenant.seller_company_id`에서 **서버(applyRoleConstraints)가 자동 조회·세팅** (화면에서 직접 선택 불가)
> - `BUYER_ADMIN`의 `company_id`는 `company_type = 'BUYER'`인 업체만 선택 가능

### 3-3. 등록 권한 매트릭스 (누가 어떤 역할을 생성할 수 있는가)

| 로그인 사용자 | 생성 가능 역할 | 범위 제한 |
|---------------|---------------|-----------|
| `SUPER_ADMIN` | 4개 전체 | 제한 없음 |
| `SELLER_ADMIN` | SELLER_ADMIN, CHANNEL_ADMIN, BUYER_ADMIN | 자기 테넌트만 |
| `CHANNEL_ADMIN` | BUYER_ADMIN | 자기 채널에 속한 구매업체만 |
| `BUYER_ADMIN` | 없음 | 1단계에서는 생성 권한 없음 |

---

## 4. 테이블 명세 (최종 확정 — 13개)

> **2026-05-01 변경**: 9개 → 13개 (matpam_manager.md 설계 검토 반영)
> 권한/승인 4개 테이블 추가: tb_permission, tb_role_permission, tb_user_permission_override, tb_approval_request

```
tb_tenant                    — 플랫폼 분양 단위
tb_channel                   — 운영 채널
tb_company                   — 업체 마스터 (법적 거래주체)
tb_company_contact           — 업체 담당자
tb_user                      — 로그인 사용자 계정
tb_buyer_channel             — 구매업체 채널 소속
tb_company_bank_account      — 업체 계좌정보
tb_buyer_financial           — 구매업체 금융 정보
tb_audit_log                 — 감사 로그
tb_permission                — 권한 마스터 (신규)
tb_role_permission           — 역할별 기본 권한 (신규)
tb_user_permission_override  — 사용자 개별 권한 오버라이드 (신규)
tb_approval_request          — 승인 요청 (신규)

> 상품/주문/재고/자금/여신 테이블(도메인 2·3) → MATPAM_MANAGER.md §12 참조
```

---

### 4-1. tb_tenant — 플랫폼 분양 단위

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| tenant_id | BIGINT | 테넌트 ID | PK, AUTO_INCREMENT |
| tenant_code | VARCHAR(50) | 테넌트 코드 | UNIQUE, NOT NULL |
| tenant_name | VARCHAR(200) | 플랫폼명 | NOT NULL |
| seller_company_id | BIGINT | 대표 판매업체 ID | FK → tb_company, NULL 가능 (초기 생성 시) |
| status | ENUM('ACTIVE','INACTIVE') | 상태 | NOT NULL, DEFAULT 'ACTIVE' |
| created_at | DATETIME | 생성일시 | NOT NULL |
| updated_at | DATETIME | 수정일시 | NOT NULL |

**운영 규칙**
- 테넌트당 대표 판매업체는 **1개**
- `seller_company_id`는 반드시 **같은 테넌트 소속의 SELLER 업체**여야 함
- 순환 참조 해결 절차: ① tb_tenant 먼저 생성 (seller_company_id = NULL) → ② tb_company에 SELLER 업체 생성 → ③ tb_tenant.seller_company_id 업데이트

**폼 옵션 조회 쿼리 (UserMapper.xml)**
```sql
-- selectActiveTenantList (신규 추가)
SELECT tenant_id, tenant_code, tenant_name, seller_company_id, status, created_at, updated_at
FROM tb_tenant
WHERE status = 'ACTIVE'
ORDER BY tenant_name ASC
```

---

### 4-2. tb_channel — 운영 채널

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| channel_id | BIGINT | 채널 ID | PK, AUTO_INCREMENT |
| tenant_id | BIGINT | 테넌트 ID | FK → tb_tenant, NOT NULL |
| channel_code | ENUM('PARCEL','FREIGHT','PICKUP') | 채널코드 | NOT NULL |
| channel_name | VARCHAR(100) | 채널명 | NOT NULL |
| status | ENUM('ACTIVE','INACTIVE') | 상태 | NOT NULL |
| sort_order | INT | 정렬순서 | DEFAULT 0 |
| created_at | DATETIME | 생성일시 | NOT NULL |
| updated_at | DATETIME | 수정일시 | NOT NULL |

**제약**
- `UNIQUE (tenant_id, channel_code)` — 테넌트당 같은 채널코드 중복 불가

**채널 코드 매핑**

| 코드 | 한글명 |
|------|--------|
| PARCEL | 전국택배 |
| FREIGHT | 화물직송 |
| PICKUP | 공장수령 |

**폼 옵션 조회 쿼리 (UserMapper.xml)**
```sql
-- selectChannelListByTenant (신규 추가)
SELECT channel_id, tenant_id, channel_code, channel_name, status, sort_order
FROM tb_channel
WHERE tenant_id = #{tenantId}
  AND status = 'ACTIVE'
ORDER BY sort_order ASC
```

---

### 4-3. tb_company — 업체 마스터 (법적 거래주체)

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| company_id | BIGINT | 업체 ID | PK, AUTO_INCREMENT |
| tenant_id | BIGINT | 테넌트 ID | FK → tb_tenant, NOT NULL |
| company_type | ENUM('SELLER','BUYER') | 업체유형 | NOT NULL |
| seller_type | ENUM('RAW','PROCESSED','FINISHED') | 판매업체 취급 품목 범위 힌트 | SELLER일 때만 사용, BUYER면 NULL |
| company_name | VARCHAR(200) | 업체명 | NOT NULL |
| business_no | VARCHAR(20) | 사업자등록번호 | NOT NULL |
| ceo_name | VARCHAR(100) | 대표자명 | NOT NULL |
| postal_code | VARCHAR(10) | 우편번호 | NULL |
| address1 | VARCHAR(255) | 주소 | NULL |
| address2 | VARCHAR(255) | 상세주소 | NULL |
| phone | VARCHAR(30) | 대표전화 | NULL |
| email | VARCHAR(150) | 대표이메일 | NULL |
| default_tax_type | ENUM('TAX_FREE','TAXABLE') | **UI 기본값 힌트** (최종 세율은 상품 SKU 단위로 결정) | NOT NULL |
| biz_status | ENUM('ACTIVE','SUSPENDED','CLOSED') | 사업자 상태 | NOT NULL, DEFAULT 'ACTIVE' |
| biz_checked_at | DATETIME | 사업자 상태 확인 일시 | NULL |
| biz_checked_result | VARCHAR(100) | 확인 결과 | NULL |
| status | ENUM('ACTIVE','INACTIVE') | 사용 상태 | NOT NULL |
| seller_tenant_guard | BIGINT GENERATED | SELLER 1개 제한용 가드 컬럼 | UNIQUE (NULL 허용으로 BUYER는 중복 무시) |
| created_at | DATETIME | 생성일시 | NOT NULL |
| updated_at | DATETIME | 수정일시 | NOT NULL |

**운영 규칙**
- `company_type = SELLER` → `seller_type` 필수, `seller_tenant_guard` = tenant_id (UNIQUE 적용)
- `company_type = BUYER` → `seller_type` NULL, `seller_tenant_guard` = NULL (UNIQUE 비적용)
- `seller_type`은 판매업체의 **취급 품목 분류 힌트**이며, 실제 세율은 개별 상품(tb_product.tax_category)에서 결정
- `default_tax_type`은 **회원 등록 UI의 기본값 힌트**로만 활용 — 주문·세금계산서 발행 로직에서 직접 참조 금지

**제약**
- `UNIQUE (tenant_id, business_no)` — 테넌트 내 사업자번호 중복 불가
- `CHECK: (SELLER AND seller_type IS NOT NULL) OR (BUYER AND seller_type IS NULL)`

**폼 옵션 조회 쿼리 (UserMapper.xml)**
```sql
-- selectBuyerCompanyListByTenant (신규 추가)
SELECT
    company_id   AS companyId,
    company_name AS companyName,
    business_no  AS businessNo
FROM tb_company
WHERE tenant_id    = #{tenantId}
  AND company_type = 'BUYER'
  AND status       = 'ACTIVE'
ORDER BY company_name ASC

-- selectSellerCompanyIdByTenant (신규 추가)
SELECT seller_company_id
FROM tb_tenant
WHERE tenant_id = #{tenantId}
```

---

### 4-4. tb_company_contact — 업체 담당자

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| contact_id | BIGINT | 담당자 ID | PK, AUTO_INCREMENT |
| company_id | BIGINT | 업체 ID | FK → tb_company, NOT NULL |
| contact_name | VARCHAR(100) | 담당자명 | NOT NULL |
| contact_role | ENUM('ADMIN','SALES','TAX','SETTLEMENT','SHIPPING','PURCHASE') | 담당 역할 | NOT NULL |
| mobile | VARCHAR(30) | 휴대전화 | NULL |
| email | VARCHAR(150) | 이메일 | NULL |
| is_primary | CHAR(1) | 대표 담당자 여부 | DEFAULT 'N' |
| linked_user_id | BIGINT | 연결 사용자 ID | FK → tb_user, NULL 가능 |
| status | ENUM('ACTIVE','INACTIVE') | 상태 | NOT NULL |
| primary_company_guard | BIGINT GENERATED | 대표 담당자 1명 제한용 가드 | UNIQUE (is_primary='Y'일 때만 company_id 세팅) |
| created_at | DATETIME | 생성일시 | NOT NULL |
| updated_at | DATETIME | 수정일시 | NOT NULL |

**설명**
- 로그인 없는 담당자도 등록 가능 (`linked_user_id = NULL`)
- 세금계산서(TAX) / 정산(SETTLEMENT) / 출고(SHIPPING) 담당자 분리 가능
- **회원 등록 시 `createContactYn = 'Y'`이면 tb_company_contact 동시 생성** (이번 작업 구현 완료)

**담당자 역할 기본값 — `defaultContactRole()` 메서드 (UserServiceImpl)**

| 사용자 역할 | 기본 담당자 역할 | 근거 |
|-------------|-----------------|------|
| SELLER_ADMIN | ADMIN | 판매처 전체 관리 |
| CHANNEL_ADMIN | ADMIN | 채널 운영 관리 |
| BUYER_ADMIN | PURCHASE | 구매 담당 |
| 기타 (SUPER_ADMIN 등) | ADMIN | 기본값 |

**담당자 동시 생성 쿼리 (UserMapper.xml)**
```sql
-- insertCompanyContact (신규 추가)
INSERT INTO tb_company_contact (
    company_id, contact_name, contact_role,
    mobile, email, is_primary, linked_user_id,
    status, created_at, updated_at
) VALUES (
    #{companyId}, #{contactName}, #{contactRole},
    #{mobile}, #{email}, #{isPrimary}, #{linkedUserId},
    'ACTIVE', NOW(), NOW()
)
```

---

### 4-5. tb_user — 로그인 사용자 계정 ★ 이번 작업 주요 변경

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| user_id | BIGINT | 사용자 ID | PK, AUTO_INCREMENT |
| tenant_id | BIGINT | 테넌트 ID | FK → tb_tenant, **NULL 가능** (SUPER_ADMIN) |
| company_id | BIGINT | 소속 업체 ID | FK → tb_company, **NULL 가능** (SUPER_ADMIN) |
| login_id | VARCHAR(100) | 로그인 ID | UNIQUE, NOT NULL |
| password_hash | VARCHAR(255) | 비밀번호 해시 (BCrypt) | NOT NULL |
| user_name | VARCHAR(100) | 이름 | NOT NULL |
| mobile | VARCHAR(30) | 휴대전화 | NULL |
| email | VARCHAR(150) | 이메일 | NULL |
| user_role | ENUM('SUPER_ADMIN','SELLER_ADMIN','CHANNEL_ADMIN','BUYER_ADMIN') | 역할 | NOT NULL |
| channel_id | BIGINT | 채널 ID | FK → tb_channel, **NULL 가능** (CHANNEL_ADMIN만 사용) |
| status | ENUM('ACTIVE','LOCKED','INACTIVE') | 상태 | NOT NULL, DEFAULT 'ACTIVE' |
| last_login_at | DATETIME | 마지막 로그인 | NULL |
| created_at | DATETIME | 생성일시 | NOT NULL |
| updated_at | DATETIME | 수정일시 | NOT NULL |

**역할별 CHECK 제약 (DB 레벨 1차 방어)**
```sql
CONSTRAINT chk_tb_user_01 CHECK (
    (user_role = 'SUPER_ADMIN'   AND tenant_id IS NULL     AND company_id IS NULL     AND channel_id IS NULL)
    OR
    (user_role = 'SELLER_ADMIN'  AND tenant_id IS NOT NULL AND company_id IS NOT NULL AND channel_id IS NULL)
    OR
    (user_role = 'CHANNEL_ADMIN' AND tenant_id IS NOT NULL AND company_id IS NOT NULL AND channel_id IS NOT NULL)
    OR
    (user_role = 'BUYER_ADMIN'   AND tenant_id IS NOT NULL AND company_id IS NOT NULL AND channel_id IS NULL)
)
```

> ⚠️ **MariaDB 버전 주의**: CHECK 제약은 MariaDB 10.3.10+ 부터 실제 강제됨.
> 서비스 레이어 `applyRoleConstraints()`로 2차 방어 병행 필수.

**추가 검증 (서비스 레이어 — applyRoleConstraints)**
- `CHANNEL_ADMIN.company_id`는 반드시 해당 테넌트의 `seller_company_id`와 동일 (자동 세팅)
- `BUYER_ADMIN.company_id`는 `company_type = 'BUYER'`여야 함 (1단계 서비스 검증)

---

### 4-6. tb_buyer_channel — 구매업체 채널 소속

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| buyer_channel_id | BIGINT | PK | PK, AUTO_INCREMENT |
| tenant_id | BIGINT | 테넌트 ID | FK → tb_tenant, NOT NULL |
| buyer_company_id | BIGINT | 구매업체 ID | FK → tb_company, NOT NULL |
| channel_id | BIGINT | 채널 ID | FK → tb_channel, NOT NULL |
| status | ENUM('ACTIVE','INACTIVE') | 상태 | NOT NULL |
| joined_at | DATETIME | 참여일시 | NULL |
| created_by | BIGINT | 등록 사용자 ID | FK → tb_user, NULL |
| created_at | DATETIME | 생성일시 | NOT NULL |

**제약**
- `UNIQUE (tenant_id, buyer_company_id, channel_id)` — 동일 구매업체·채널 중복 소속 불가

---

### 4-7. tb_company_bank_account — 업체 계좌정보

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| bank_account_id | BIGINT | 계좌 ID | PK, AUTO_INCREMENT |
| company_id | BIGINT | 업체 ID | FK → tb_company, NOT NULL |
| bank_name | VARCHAR(100) | 은행명 | NOT NULL |
| account_no_enc | VARCHAR(255) | **암호화 계좌번호** (AES) | NOT NULL |
| account_holder | VARCHAR(100) | 예금주 | NOT NULL |
| is_default | CHAR(1) | 기본계좌 여부 | DEFAULT 'N' |
| default_company_guard | BIGINT GENERATED | 기본계좌 1개 제한용 가드 | UNIQUE |
| status | ENUM('ACTIVE','INACTIVE') | 상태 | NOT NULL |
| created_at | DATETIME | 생성일시 | NOT NULL |
| updated_at | DATETIME | 수정일시 | NOT NULL |

**운영 규칙**
- 업체당 `is_default = 'Y'` 계좌는 **1개만** 허용 (`default_company_guard` UNIQUE)
- 계좌번호 **평문 저장 금지** — AES 암호화 후 저장

---

### 4-8. tb_buyer_financial — 구매업체 금융 정보

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| buyer_financial_id | BIGINT | PK | PK, AUTO_INCREMENT |
| buyer_company_id | BIGINT | 구매업체 ID | FK → tb_company (BUYER만), UNIQUE |
| credit_limit_amount | DECIMAL(18,2) | 여신한도 | NOT NULL, DEFAULT 0, >= 0 |
| meat_money_enabled | CHAR(1) | 미트머니 사용 여부 | DEFAULT 'N' |
| status | ENUM('ACTIVE','INACTIVE') | 상태 | NOT NULL |
| created_at | DATETIME | 생성일시 | NOT NULL |
| updated_at | DATETIME | 수정일시 | NOT NULL |
| updated_by | BIGINT | 수정 사용자 ID | FK → tb_user, NULL |

**설명**
- 구매업체당 **1개** (UNIQUE on buyer_company_id)
- 미트머니 잔액·입출금 원장은 2단계에서 별도 테이블로 분리

---

### 4-9. tb_audit_log — 감사 로그 (2026-05-01 확장)

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| audit_id | BIGINT | 감사로그 ID | PK, AUTO_INCREMENT |
| tenant_id | BIGINT | 테넌트 ID | FK → tb_tenant, NULL 가능 (SUPER_ADMIN 작업) |
| entity_name | VARCHAR(50) | 대상 테이블명 | NOT NULL |
| entity_id | BIGINT | 대상 PK | NOT NULL |
| action_type | ENUM('INSERT','UPDATE','DELETE','LOGIN','APPROVE','REJECT') | 작업유형 | NOT NULL |
| before_json | JSON | 변경 전 값 (민감정보 마스킹 필수) | NULL |
| after_json | JSON | 변경 후 값 (민감정보 마스킹 필수) | NULL |
| actor_user_id | BIGINT | 작업 사용자 ID | FK → tb_user, NULL |
| acted_at | DATETIME | 작업일시 | NOT NULL |
| ip_address | VARCHAR(50) | 접속 IP | NULL |
| reason_code | VARCHAR(100) | 변경 사유 코드 (신규) | NULL |
| approval_request_id | BIGINT | 연관 승인요청 ID (신규) | FK → tb_approval_request, NULL |
| trace_id | VARCHAR(100) | 분산추적 트레이스 ID (신규) | NULL |

**반드시 로그 남길 항목 (확장)**

| 이벤트 | entity_name | 필수 기록 항목 |
|--------|-------------|----------------|
| 사업자등록번호 변경 | tb_company | before/after |
| 기본 과세구분 변경 | tb_company | before/after |
| 여신한도 변경 | tb_buyer_credit_policy | before/after, approval_request_id |
| 계좌정보 변경 | tb_company_bank_account | (계좌번호 마스킹) |
| 사용자 역할 변경 | tb_user | before/after |
| 로그인 성공/실패 | tb_user | actor_user_id, ip_address |
| 상품 세금구분 변경 | tb_product | tax_category before/after, approval_request_id |
| 상품 연관관계 변경 | tb_product_relation | relation 정보 before/after |
| 선급금 조정 | tb_buyer_advance_ledger | amount, reason_code |
| 환불 처리/취소 | tb_payment_allocation | amount, source_type, reason_code |
| 세금계산서 재발행 | tb_tax_document | document_id, reason_code, approval_request_id |
| 주문 취소 시도 | tb_order | order_id, status, reason_code |

> ⚠️ `before_json`/`after_json`에 비밀번호·계좌번호·전화번호·이메일·사업자번호 **평문 저장 절대 금지**
> - 계좌번호: `"****-****-1234"` 형식으로 마스킹
> - 사업자번호: 앞 3자리 표시 후 나머지 마스킹

---

---

### 4-10. tb_permission — 권한 마스터 (신규)

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| permission_id | BIGINT | 권한 ID | PK, AUTO_INCREMENT |
| permission_code | VARCHAR(100) | 권한 코드 | UNIQUE, NOT NULL |
| permission_name | VARCHAR(200) | 권한명 | NOT NULL |
| description | VARCHAR(500) | 설명 | NULL |
| domain | ENUM('PRODUCT','ORDER','FINANCE','USER','AUDIT','SYSTEM') | 도메인 | NOT NULL |
| created_at | DATETIME | 생성일시 | NOT NULL |

> 상세 권한 코드 목록 및 역할별 매트릭스 → **MATPAM_MANAGER.md §7** 참조

**기본 권한 코드 목록 (도메인별 요약)**

| permission_code | domain | 기본 보유 역할 |
|-----------------|--------|----------------|
| PRODUCT_TAX_EDIT | PRODUCT | SELLER_ADMIN |
| PRODUCT_TAX_APPROVE | PRODUCT | SUPER_ADMIN |
| PRODUCT_RELATION_EDIT | PRODUCT | SELLER_ADMIN |
| ORDER_VIEW | ORDER | 전체 역할 |
| ORDER_CANCEL_APPROVE | ORDER | SUPER_ADMIN, SELLER_ADMIN |
| CREDIT_LIMIT_EDIT | FINANCE | SELLER_ADMIN |
| CREDIT_LIMIT_APPROVE | FINANCE | SUPER_ADMIN, SELLER_ADMIN |
| REFUND_APPROVE | FINANCE | SELLER_ADMIN |
| TAX_DOCUMENT_REISSUE_APPROVE | ORDER | SUPER_ADMIN |
| BANK_ACCOUNT_APPROVE | FINANCE | SUPER_ADMIN |
| AUDIT_LOG_VIEW | AUDIT | SUPER_ADMIN |
| AUDIT_LOG_VIEW_OWN | AUDIT | SUPER_ADMIN, SELLER_ADMIN |
| USER_PERMISSION_OVERRIDE | USER | SUPER_ADMIN |

> 전체 25개 권한 코드 및 역할별 매트릭스 → MATPAM_MANAGER.md §7-1, §7-2

---

### 4-11. tb_role_permission — 역할별 기본 권한 (신규)

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| role_permission_id | BIGINT | ID | PK, AUTO_INCREMENT |
| user_role | ENUM('SUPER_ADMIN','SELLER_ADMIN','CHANNEL_ADMIN','BUYER_ADMIN') | 역할 | NOT NULL |
| permission_id | BIGINT | 권한 ID | FK → tb_permission, NOT NULL |
| granted | CHAR(1) | 부여 여부 | DEFAULT 'Y' |
| created_at | DATETIME | 생성일시 | NOT NULL |

**제약**
- `UNIQUE (user_role, permission_id)` — 역할별 동일 권한 중복 불가

---

### 4-12. tb_user_permission_override — 사용자 개별 권한 오버라이드 (신규)

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| override_id | BIGINT | ID | PK, AUTO_INCREMENT |
| user_id | BIGINT | 사용자 ID | FK → tb_user, NOT NULL |
| permission_id | BIGINT | 권한 ID | FK → tb_permission, NOT NULL |
| override_type | ENUM('GRANT','DENY') | 오버라이드 유형 | NOT NULL |
| reason | VARCHAR(500) | 사유 | NOT NULL |
| approved_by | BIGINT | 승인자 user_id | FK → tb_user, NOT NULL |
| effective_from | DATE | 유효 시작일 | NOT NULL |
| effective_to | DATE | 유효 종료일 | NULL |
| created_at | DATETIME | 생성일시 | NOT NULL |

**제약**
- `UNIQUE (user_id, permission_id)` — 동일 권한 중복 오버라이드 불가
- 오버라이드는 반드시 승인자 필요 (SUPER_ADMIN 또는 SELLER_ADMIN)

---

### 4-13. tb_approval_request — 승인 요청 (신규)

| 컬럼명 | 타입 | 설명 | 제약 |
|--------|------|------|------|
| approval_request_id | BIGINT | 승인요청 ID | PK, AUTO_INCREMENT |
| tenant_id | BIGINT | 테넌트 ID | FK → tb_tenant, NULL (SUPER_ADMIN 요청) |
| request_type | ENUM('PRODUCT_TAX_CHANGE','CREDIT_LIMIT_CHANGE','REFUND','TAX_DOCUMENT_REISSUE','USER_PERMISSION_OVERRIDE','BANK_ACCOUNT_CHANGE') | 요청유형 | NOT NULL |
| ref_table | VARCHAR(100) | 참조 테이블명 | NOT NULL |
| ref_id | BIGINT | 참조 ID | NOT NULL |
| request_summary | VARCHAR(1000) | 요청 요약 | NOT NULL |
| before_json | LONGTEXT | 변경 전 데이터 (JSON) | NULL |
| after_json | LONGTEXT | 변경 후 데이터 (JSON) | NOT NULL |
| status | ENUM('PENDING','APPROVED','REJECTED','CANCELLED') | 상태 | NOT NULL, DEFAULT 'PENDING' |
| requested_by | BIGINT | 요청자 user_id | FK → tb_user, NOT NULL |
| requested_at | DATETIME | 요청일시 | NOT NULL |
| reviewed_by | BIGINT | 검토자 user_id | FK → tb_user, NULL |
| reviewed_at | DATETIME | 검토일시 | NULL |
| review_comment | VARCHAR(1000) | 검토 의견 | NULL |
| created_at | DATETIME | 생성일시 | NOT NULL |
| updated_at | DATETIME | 수정일시 | NOT NULL |

**승인 요청 유형별 담당 승인자**

| request_type | 요청 주체 | 승인 주체 | 상세 |
|-------------|-----------|----------|------|
| PRODUCT_TAX_CHANGE | SELLER_ADMIN | SUPER_ADMIN | MATPAM_MANAGER.md §2-3 |
| CREDIT_LIMIT_CHANGE | SELLER_ADMIN | SUPER_ADMIN / SELLER_ADMIN | MATPAM_MANAGER.md §6-3 |
| REFUND | CHANNEL_ADMIN / SELLER_ADMIN | SELLER_ADMIN | MATPAM_MANAGER.md §5-4 |
| TAX_DOCUMENT_REISSUE | SELLER_ADMIN | SUPER_ADMIN | MATPAM_MANAGER.md §3-4 |
| USER_PERMISSION_OVERRIDE | SELLER_ADMIN | SUPER_ADMIN | §4-12 |
| BANK_ACCOUNT_CHANGE | SELLER_ADMIN | SUPER_ADMIN | §4-7 |

---

## 5. 운영 규칙 (7가지 핵심 제약)

| # | 규칙 | 강제 방법 |
|---|------|-----------|
| ① | 테넌트당 판매업체(SELLER) **1개** | `seller_tenant_guard` GENERATED 컬럼 + UNIQUE |
| ② | SUPER_ADMIN만 tenant/company/channel **NULL** 허용 | DB CHECK 제약 + `applyRoleConstraints()` |
| ③ | CHANNEL_ADMIN은 **channel_id NOT NULL** | DB CHECK 제약 + `applyRoleConstraints()` |
| ④ | BUYER_ADMIN의 company_id는 **company_type = BUYER**만 | 서비스 레이어 검증 |
| ⑤ | 구매업체 채널 소속 **중복 금지** | `UNIQUE (tenant_id, buyer_company_id, channel_id)` |
| ⑥ | 업체당 기본계좌 **1개** | `default_company_guard` GENERATED 컬럼 + UNIQUE |
| ⑦ | 업체당 대표 담당자 **1명** | `primary_company_guard` GENERATED 컬럼 + UNIQUE |

---

## 6. 회원 등록 화면 설계 (이번 작업 구현 완료)

### 6-1. 화면 구성 (UserForm.jsp — 전면 재설계)

```
[STEP 1] 회원 유형 선택 (역할 카드 UI — 4개 카드)
  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
  │  🛡️     │ │  🏭     │ │  📦     │ │  🛒     │
  │수퍼관리자│ │판매처관리│ │채널관리자│ │구매처관리│
  └──────────┘ └──────────┘ └──────────┘ └──────────┘
  → 선택 시 역할별 안내 메시지(hint-box) 노출

[STEP 2] 기본 정보
  로그인 ID     [____________] [중복확인]  → AJAX /admin/user/checkLoginId.ajax
  사용자 이름   [____________]
  비밀번호      [____________] [눈 아이콘] → 강도 바 실시간 표시
  비밀번호 확인 [____________]             → 일치 여부 실시간 표시
  휴대폰 번호   [____________]             → 자동 하이픈 포맷
  이메일        [____________]
  상태          ● 활성  ○ 잠금  ○ 비활성  (기본값: ACTIVE)

[STEP 3] 소속 정보 (역할에 따라 동적 표시 — applyRoleSection())
  테넌트        [드롭다운]          ← SUPER_ADMIN은 섹션 전체 숨김
  소속 업체     [자동세팅 박스]     ← SELLER/CHANNEL_ADMIN: sellerCompanyId 자동세팅
                [구매업체 드롭다운] ← BUYER_ADMIN: BUYER 업체만 직접 선택
  담당 채널     [드롭다운]          ← CHANNEL_ADMIN만 표시

[STEP 4] 담당자 동시 생성 (선택사항 — 토글 스위치)
  → SUPER_ADMIN은 섹션 숨김
  담당자 역할   [드롭다운]  (기본값: 역할별 자동 설정)
  대표 담당자   ● 대표  ○ 일반
```

### 6-2. 역할별 화면 동작 규칙

| 역할 | 소속 섹션 | 테넌트 | 소속 업체 | 채널 | 담당자 섹션 |
|------|-----------|--------|-----------|------|-------------|
| SUPER_ADMIN | **숨김** | - | - | - | **숨김** |
| SELLER_ADMIN | 표시 | 필수 | 자동세팅 (읽기전용) | 숨김 | 표시 |
| CHANNEL_ADMIN | 표시 | 필수 | 자동세팅 (읽기전용) | **필수** | 표시 |
| BUYER_ADMIN | 표시 | 필수 | **직접선택** (BUYER만) | 숨김 | 표시 |

### 6-3. JavaScript 주요 함수 (UserForm.jsp)

| 함수명 | 역할 |
|--------|------|
| `applyRoleSection(role)` | 역할에 따라 소속·담당자 섹션 동적 표시/숨김 |
| `loadFormOptions(role, tenantId)` | `/admin/user/formOptions.ajax` 호출 → 채널·구매업체 드롭다운 갱신 |
| `checkDuplId()` | `/admin/user/checkLoginId.ajax` 호출 → 중복 여부 표시 |
| `checkPasswordStrength(pw)` | 실시간 비밀번호 강도 바 업데이트 |
| `validateForm()` | 저장 전 프론트 1차 전체 검증 |
| `saveUser()` | `/admin/user/saveUser.ajax` POST 후 성공/오류 처리 |

---

## 7. 회원 목록 화면 설계 (이번 작업 구현 완료)

### 7-1. 화면 구성 (UserList.jsp — 전면 재설계)

```
[KPI 카드 4개]  ← GET /admin/user/userStats.ajax 비동기 로드 (fn_loadStats)
  전체 사용자  |  활성 계정  |  잠금/비활성  |  역할 분포
  (total)       (activeCount)  (lockedCount)   (seller/channel/buyer Count)

[검색 패널 — 4개 필터]
  테넌트 [드롭다운] | 역할 [드롭다운] | 상태 [드롭다운] | 검색어 [입력] | [검색] [초기화]
  → 검색 파라미터: tenantId, userRole, status, searchKeyword

[목록 테이블]
  No | 사용자(아바타+ID+이름) | 역할 뱃지 | 소속정보 | 연락처 | 상태 | 최근로그인 | 등록일 | 관리
  → 역할별 컬러 아바타 (SUPER:다크, SELLER:블루, CHANNEL:퍼플, BUYER:그린)
  → 상태 뱃지 클릭 → 드롭다운 인라인 변경 (fn_changeStatus) — 페이지 새로고침 없음
  → 수정 아이콘 → UserForm.jsp 이동 (?userId=xxx)

[페이지네이션]
  첫/이전/번호/다음/마지막 | 페이지당 건수 선택 (10/20/50/100)
  → fn_egov_link_page(pageNo), fn_changePageUnit(unit)
```

### 7-2. JavaScript 주요 함수 (UserList.jsp)

| 함수명 | 역할 |
|--------|------|
| `fn_loadStats()` | `/admin/user/userStats.ajax` 호출 → KPI 카드 값 업데이트 |
| `fn_changeStatus(userId, newStatus)` | `/admin/user/updateStatus.ajax` POST → 상태 뱃지 인라인 변경 |
| `fn_updateStatusCell(userId, status)` | 상태 변경 후 UI 뱃지·드롭다운 갱신 |
| `fn_egov_link_page(pageNo)` | 폼 제출로 페이지 이동 |
| `fn_changePageUnit(unit)` | 페이지 단위 변경 후 재조회 |

---

## 8. AJAX 엔드포인트 명세 (UserController.java — 이번 작업 확정)

### 8-1. 폼 옵션 조회

```
GET /admin/user/formOptions.ajax
  파라미터: userRole (optional), tenantId (optional)
  응답:
  {
    "success": true,
    "tenants": [{ "tenantId": 1, "tenantName": "맛팜 본사" }],
    "channels": [{ "channelId": 1, "channelCode": "PARCEL", "channelName": "전국택배" }],
    "buyerCompanies": [{ "companyId": 2, "companyName": "대전정육" }],
    "sellerCompanyId": 10
  }
  - tenants: 항상 포함
  - channels, sellerCompanyId: SELLER_ADMIN / CHANNEL_ADMIN + tenantId 있을 때
  - buyerCompanies: BUYER_ADMIN + tenantId 있을 때
```

### 8-2. 사용자 저장

```
POST /admin/user/saveUser.ajax
  Body (UserVO): loginId, passwordHash, userName, mobile, email,
                 userRole, tenantId, companyId, channelId, status,
                 createContactYn, contactRole, isPrimaryContact, userId(수정 시)
  응답:
  { "success": true,  "message": "사용자가 등록되었습니다.", "userId": 5 }
  { "success": false, "errorCode": "USER_001", "message": "이미 사용 중인 로그인 ID입니다." }
```

### 8-3. 로그인 ID 중복 확인

```
GET /admin/user/checkLoginId.ajax
  파라미터: loginId
  응답:
  { "success": true, "duplicated": false }
```

### 8-4. 사용자 상태 변경 (인라인)

```
POST /admin/user/updateStatus.ajax
  파라미터: userId (Long), status (ACTIVE|LOCKED|INACTIVE)
  응답:
  { "success": true, "status": "LOCKED", "message": "상태가 변경되었습니다." }
  - status 값 서버 측 정규식 검증: status.matches("ACTIVE|LOCKED|INACTIVE")
```

### 8-5. KPI 통계 조회

```
GET /admin/user/userStats.ajax
  응답:
  {
    "success": true,
    "total":        100,   // 전체 사용자 수
    "activeCount":   85,   // ACTIVE 상태
    "lockedCount":    5,   // LOCKED 상태
    "superCount":     1,   // SUPER_ADMIN 수
    "sellerCount":   10,   // SELLER_ADMIN 수
    "channelCount":  20,   // CHANNEL_ADMIN 수
    "buyerCount":    69    // BUYER_ADMIN 수
  }
  - 각 카운트는 selectUserListTotCnt(UserVO) 재활용 (역할/상태 필터)
```

---

## 9. UserVO 필드 정의 (이번 작업 확장 완료)

### 9-1. DB 매핑 필드 (tb_user 컬럼)

| 필드명 | 타입 | 컬럼 | 비고 |
|--------|------|-------|------|
| userId | Long | user_id | PK |
| tenantId | Long | tenant_id | SUPER_ADMIN이면 NULL |
| companyId | Long | company_id | SUPER_ADMIN이면 NULL |
| loginId | String | login_id | UNIQUE |
| passwordHash | String | password_hash | BCrypt 해시값 저장. 화면에서는 평문 입력 → 서비스에서 해시 |
| userName | String | user_name | - |
| mobile | String | mobile | - |
| email | String | email | - |
| userRole | String | user_role | SUPER_ADMIN / SELLER_ADMIN / CHANNEL_ADMIN / BUYER_ADMIN |
| channelId | Long | channel_id | CHANNEL_ADMIN만 NOT NULL |
| status | String | status | ACTIVE / LOCKED / INACTIVE |
| lastLoginAt | Date | last_login_at | NULL 가능 |
| createdAt | Date | created_at | - |
| updatedAt | Date | updated_at | - |

### 9-2. 화면/저장 보조 필드 (DB 미저장 — 이번 작업 신규 추가)

| 필드명 | 타입 | 용도 |
|--------|------|------|
| **passwordConfirm** | String | 화면 비밀번호 확인용 (JS 검증 전용) |
| **createContactYn** | String | 담당자 동시 생성 여부 Y/N (기본 N) |
| **contactRole** | String | 담당자 역할 (ADMIN/SALES/TAX/SETTLEMENT/SHIPPING/PURCHASE) |
| **isPrimaryContact** | String | 대표 담당자 여부 Y/N (기본 N) |

### 9-3. 조회 조인 필드 (이번 작업 신규 추가)

| 필드명 | 타입 | 조인 테이블 | 용도 |
|--------|------|-------------|------|
| **companyName** | String | tb_company | 목록/상세 업체명 표시 |
| **tenantName** | String | tb_tenant | 목록/상세 테넌트명 표시 |
| **channelName** | String | tb_channel | 목록/상세 채널명 표시 |
| **channelCode** | String | tb_channel | 채널코드 (PARCEL / FREIGHT / PICKUP) |

---

## 10. UserMapper.xml 쿼리 목록 (이번 작업 확장 완료)

| 쿼리 ID | 구분 | 설명 | 변경 여부 |
|---------|------|------|-----------|
| selectUserList | SELECT | 사용자 목록 (tb_company·tb_tenant·tb_channel LEFT JOIN) | **수정** — JOIN 추가 |
| selectUserListTotCnt | SELECT | 목록 건수 (공통 WHERE 절 재사용) | 유지 |
| selectUserDetail | SELECT | 사용자 상세 (JOIN 포함) | **수정** — JOIN 추가 |
| selectUserByLoginId | SELECT | 로그인 ID 중복 확인 | 유지 |
| insertUser | INSERT | 사용자 등록 (useGeneratedKeys=true, keyProperty=userId) | 유지 |
| updateUser | UPDATE | 사용자 수정 (passwordHash conditional, status 컬럼 추가) | **수정** |
| updateUserStatus | UPDATE | 상태만 변경 | 유지 |
| **selectActiveTenantList** | SELECT | **활성 테넌트 목록 (status=ACTIVE, 이름 오름차순)** | **신규** |
| **selectChannelListByTenant** | SELECT | **테넌트별 채널 목록 (status=ACTIVE, sort_order 오름차순)** | **신규** |
| **selectBuyerCompanyListByTenant** | SELECT | **테넌트별 구매업체 목록 (company_type=BUYER, status=ACTIVE)** | **신규** |
| **selectSellerCompanyIdByTenant** | SELECT | **테넌트 대표 판매업체 ID (tb_tenant.seller_company_id)** | **신규** |
| **insertCompanyContact** | INSERT | **담당자 동시 생성 (파라미터 타입: Map)** | **신규** |

**공통 WHERE 절 (`<sql id="userWhere">`) — 검색 필터**

| 파라미터 | 조건 |
|----------|------|
| tenantId | u.tenant_id = #{tenantId} |
| companyId | u.company_id = #{companyId} |
| userRole | u.user_role = #{userRole} |
| channelId | u.channel_id = #{channelId} |
| status | u.status = #{status} |
| searchKeyword | login_id LIKE '%keyword%' OR user_name LIKE '%keyword%' |

---

## 11. UserServiceImpl 핵심 로직 (이번 작업 구현 완료)

### 11-1. insertUser() 저장 순서

```java
@Transactional
public void insertUser(UserVO vo) throws Exception {
    // ① 역할별 조합 강제 세팅
    applyRoleConstraints(vo);

    // ② 로그인ID 중복 확인 → USER_001 에러
    if (userMapper.selectUserByLoginId(vo.getLoginId()) != null)
        throw new IllegalArgumentException("USER_001:이미 사용 중인 로그인 ID입니다.");

    // ③ 비밀번호 필수 확인 → USER_002 에러
    if (vo.getPasswordHash() == null || vo.getPasswordHash().isEmpty())
        throw new IllegalArgumentException("USER_002:비밀번호는 필수입니다.");

    // ④ BCrypt 해시 적용 (평문 → 해시)
    vo.setPasswordHash(passwordEncoder.encode(vo.getPasswordHash()));

    // ⑤ tb_user INSERT (useGeneratedKeys → vo.userId 세팅)
    userMapper.insertUser(vo);

    // ⑥ 담당자 동시 생성 (createContactYn=Y & companyId 존재 시)
    if ("Y".equals(vo.getCreateContactYn()) && vo.getCompanyId() != null) {
        Map<String, Object> contactParam = new HashMap<>();
        contactParam.put("companyId",    vo.getCompanyId());
        contactParam.put("contactName",  vo.getUserName());
        contactParam.put("contactRole",  defaultContactRole(vo.getUserRole(), vo.getContactRole()));
        contactParam.put("mobile",       vo.getMobile());
        contactParam.put("email",        vo.getEmail());
        contactParam.put("isPrimary",    "Y".equals(vo.getIsPrimaryContact()) ? "Y" : "N");
        contactParam.put("linkedUserId", vo.getUserId());   // ⑤에서 세팅된 PK
        userMapper.insertCompanyContact(contactParam);
    }
}
```

### 11-2. applyRoleConstraints() — 역할별 조합 강제 세팅

```java
private void applyRoleConstraints(UserVO vo) throws Exception {
    String role = vo.getUserRole();
    if (role == null)
        throw new IllegalArgumentException("USER_002:회원 타입은 필수입니다.");

    switch (role) {
        case "SUPER_ADMIN":
            vo.setTenantId(null);   // 강제 NULL
            vo.setCompanyId(null);  // 강제 NULL
            vo.setChannelId(null);  // 강제 NULL
            break;

        case "SELLER_ADMIN":
            require(vo.getTenantId() != null, "USER_002:테넌트는 필수입니다.");
            Long sellerId = userMapper.selectSellerCompanyIdByTenant(vo.getTenantId());
            require(sellerId != null, "USER_004:해당 테넌트에 대표 판매업체가 지정되지 않았습니다.");
            vo.setCompanyId(sellerId);  // 서버에서 자동 세팅
            vo.setChannelId(null);
            break;

        case "CHANNEL_ADMIN":
            require(vo.getTenantId() != null, "USER_002:테넌트는 필수입니다.");
            require(vo.getChannelId() != null, "USER_002:담당 채널은 필수입니다.");
            Long sellerIdCh = userMapper.selectSellerCompanyIdByTenant(vo.getTenantId());
            require(sellerIdCh != null, "USER_004:해당 테넌트에 대표 판매업체가 지정되지 않았습니다.");
            vo.setCompanyId(sellerIdCh); // 서버에서 자동 세팅
            break;

        case "BUYER_ADMIN":
            require(vo.getTenantId() != null, "USER_002:테넌트는 필수입니다.");
            require(vo.getCompanyId() != null, "USER_002:구매업체는 필수입니다.");
            vo.setChannelId(null);
            break;

        default:
            throw new IllegalArgumentException("USER_002:지원하지 않는 회원 타입입니다.");
    }
}
```

### 11-3. selectFormOptions() — 폼 옵션 한 번에 조회

```java
public Map<String, Object> selectFormOptions(String userRole, Long tenantId) throws Exception {
    Map<String, Object> result = new HashMap<>();

    // 항상 포함: 활성 테넌트 목록
    result.put("tenants", userMapper.selectActiveTenantList());

    if (tenantId != null) {
        // SELLER_ADMIN / CHANNEL_ADMIN: 채널 목록 + 판매업체 ID
        if ("CHANNEL_ADMIN".equals(userRole) || "SELLER_ADMIN".equals(userRole)) {
            result.put("channels",        userMapper.selectChannelListByTenant(tenantId));
            result.put("sellerCompanyId", userMapper.selectSellerCompanyIdByTenant(tenantId));
        }
        // BUYER_ADMIN: 구매업체 목록
        if ("BUYER_ADMIN".equals(userRole)) {
            result.put("buyerCompanies", userMapper.selectBuyerCompanyListByTenant(tenantId));
        }
    }
    return result;
}
```

---

## 12. 서버 검증 규칙 및 에러코드

### 12-1. 공통 검증

| 항목 | 규칙 |
|------|------|
| login_id | 공백 금지, 중복 금지, 영문·숫자 4~20자 |
| password | 신규 등록 시 필수, 영문+숫자+특수문자 8자 이상 권장 (BCrypt 해시) |
| email | 이메일 형식 검증 |
| mobile | 휴대폰 형식 검증 |
| user_role | SUPER_ADMIN / SELLER_ADMIN / CHANNEL_ADMIN / BUYER_ADMIN 중 하나 |
| status | ACTIVE / LOCKED / INACTIVE 중 하나 (updateStatus.ajax 정규식 검증) |

### 12-2. 역할별 서버 검증 (applyRoleConstraints)

| 역할 | 검증 항목 |
|------|-----------|
| SUPER_ADMIN | tenant/company/channel 모두 강제 NULL |
| SELLER_ADMIN | tenantId 필수, sellerCompanyId DB 조회 후 자동 세팅, channelId 강제 NULL |
| CHANNEL_ADMIN | tenantId 필수, channelId 필수, sellerCompanyId DB 조회 후 자동 세팅 |
| BUYER_ADMIN | tenantId 필수, companyId 필수, channelId 강제 NULL |

### 12-3. 에러코드

| 코드 | 메시지 | 발생 위치 |
|------|--------|-----------|
| USER_001 | 이미 사용 중인 로그인 ID입니다 | insertUser — 로그인 ID 중복 |
| USER_002 | 회원 타입별 필수 값이 누락되었습니다 | applyRoleConstraints — 각 역할 필수값 미입력 |
| USER_003 | 생성 권한이 없습니다 | (2단계 구현 예정 — 권한 매트릭스 검증) |
| USER_004 | 유효하지 않은 테넌트입니다 (또는 대표 판매업체 미지정) | applyRoleConstraints — seller_company_id NULL |
| USER_005 | 유효하지 않은 업체입니다 | (2단계 구현 예정 — BUYER 타입 검증 강화) |
| USER_006 | 유효하지 않은 채널입니다 | (2단계 구현 예정 — 채널-테넌트 소속 검증) |
| USER_007 | 구매업체만 선택할 수 있습니다 | (2단계 구현 예정 — company_type BUYER 검증) |
| USER_008 | 채널관리자는 본인 채널의 구매업체만 등록할 수 있습니다 | (2단계 구현 예정 — tb_buyer_channel 검증) |

---

## 13. SQL 초기 데이터

```sql
-- 1. 수퍼관리자 계정 (비밀번호 실 운영 시 BCrypt 해시로 교체 필수)
INSERT INTO tb_user (login_id, password_hash, user_name, user_role, status, created_at, updated_at)
VALUES ('superadmin', '$2a$10$...bcrypt해시...', '최상위 수퍼관리자', 'SUPER_ADMIN', 'ACTIVE', NOW(), NOW());

-- 2. 기본 개발용 테넌트 (seller_company_id는 이후 업데이트)
INSERT INTO tb_tenant (tenant_code, tenant_name, status, created_at, updated_at)
VALUES ('MATPAM_DEV', '맛팜 플랫폼 (개발/기본)', 'ACTIVE', NOW(), NOW());

-- 3. 기본 채널 3종 (tenant_id=1 기준)
INSERT INTO tb_channel (tenant_id, channel_code, channel_name, status, sort_order, created_at, updated_at)
VALUES
    (1, 'PARCEL',  '전국택배', 'ACTIVE', 1, NOW(), NOW()),
    (1, 'FREIGHT', '화물직송', 'ACTIVE', 2, NOW(), NOW()),
    (1, 'PICKUP',  '공장수령', 'ACTIVE', 3, NOW(), NOW());
```

---

## 14. 테스트 코드 (JUnit 5 + Mockito)

> 패키지: `kr.co.matpam.admin.user.service.impl`
> 의존: `spring-test`, `junit-jupiter`, `mockito-core`, `spring-security-crypto`

### 14-1. UserServiceImpl 단위 테스트 (전체)

```java
package kr.co.matpam.admin.user.service.impl;

import kr.co.matpam.admin.user.service.UserVO;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("UserServiceImpl 단위 테스트")
class UserServiceImplTest {

    @Mock UserMapper userMapper;
    @Mock BCryptPasswordEncoder passwordEncoder;
    @InjectMocks UserServiceImpl userService;

    // ─────────────────────────────────────────────────
    // SUPER_ADMIN 등록
    // ─────────────────────────────────────────────────

    @Test
    @DisplayName("SUPER_ADMIN — 입력에 tenant/company/channel 값이 있어도 강제 NULL 세팅")
    void insertUser_superAdmin_forcesNullFields() throws Exception {
        UserVO vo = superAdminVO("supertest");
        vo.setTenantId(99L);   // 입력값 있어도
        vo.setCompanyId(99L);
        vo.setChannelId(99L);

        when(userMapper.selectUserByLoginId("supertest")).thenReturn(null);
        when(passwordEncoder.encode(any())).thenReturn("$2a$10$hash");

        userService.insertUser(vo);

        assertNull(vo.getTenantId(),  "SUPER_ADMIN tenantId 강제 NULL");
        assertNull(vo.getCompanyId(), "SUPER_ADMIN companyId 강제 NULL");
        assertNull(vo.getChannelId(), "SUPER_ADMIN channelId 강제 NULL");
        verify(userMapper).insertUser(vo);
    }

    @Test
    @DisplayName("SUPER_ADMIN — 로그인ID 중복 시 USER_001 에러")
    void insertUser_superAdmin_duplicateLoginId() throws Exception {
        UserVO vo = superAdminVO("supertest");
        when(userMapper.selectUserByLoginId("supertest")).thenReturn(new UserVO()); // 중복

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class,
            () -> userService.insertUser(vo));
        assertTrue(ex.getMessage().startsWith("USER_001"), "에러코드 USER_001 포함");
    }

    @Test
    @DisplayName("SUPER_ADMIN — 비밀번호 미입력 시 USER_002 에러")
    void insertUser_superAdmin_emptyPassword() throws Exception {
        UserVO vo = superAdminVO("supertest");
        vo.setPasswordHash(""); // 빈 값
        when(userMapper.selectUserByLoginId("supertest")).thenReturn(null);

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class,
            () -> userService.insertUser(vo));
        assertTrue(ex.getMessage().startsWith("USER_002"), "에러코드 USER_002 포함");
    }

    // ─────────────────────────────────────────────────
    // SELLER_ADMIN 등록
    // ─────────────────────────────────────────────────

    @Test
    @DisplayName("SELLER_ADMIN — companyId는 sellerCompanyId로 자동 세팅, channelId 강제 NULL")
    void insertUser_sellerAdmin_autoCompanyId() throws Exception {
        UserVO vo = baseVO("SELLER_ADMIN", "seller_new");
        vo.setTenantId(1L);
        vo.setChannelId(5L); // 입력해도 NULL 되어야 함

        when(userMapper.selectUserByLoginId("seller_new")).thenReturn(null);
        when(userMapper.selectSellerCompanyIdByTenant(1L)).thenReturn(10L);
        when(passwordEncoder.encode(any())).thenReturn("$2a$10$hash");

        userService.insertUser(vo);

        assertEquals(10L, vo.getCompanyId(), "companyId 자동 세팅 확인");
        assertNull(vo.getChannelId(), "SELLER_ADMIN channelId 강제 NULL");
        verify(userMapper).insertUser(vo);
    }

    @Test
    @DisplayName("SELLER_ADMIN — tenantId 미입력 시 USER_002 에러")
    void insertUser_sellerAdmin_noTenantId() {
        UserVO vo = baseVO("SELLER_ADMIN", "seller_err");
        vo.setTenantId(null); // 미입력

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class,
            () -> userService.insertUser(vo));
        assertTrue(ex.getMessage().startsWith("USER_002"));
    }

    @Test
    @DisplayName("SELLER_ADMIN — 대표 판매업체 미지정 시 USER_004 에러")
    void insertUser_sellerAdmin_noSellerCompany() throws Exception {
        UserVO vo = baseVO("SELLER_ADMIN", "seller_err2");
        vo.setTenantId(1L);

        when(userMapper.selectUserByLoginId("seller_err2")).thenReturn(null);
        when(userMapper.selectSellerCompanyIdByTenant(1L)).thenReturn(null); // 미지정

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class,
            () -> userService.insertUser(vo));
        assertTrue(ex.getMessage().startsWith("USER_004"));
    }

    // ─────────────────────────────────────────────────
    // CHANNEL_ADMIN 등록
    // ─────────────────────────────────────────────────

    @Test
    @DisplayName("CHANNEL_ADMIN — 정상 등록: companyId 자동 세팅, channelId 유지")
    void insertUser_channelAdmin_success() throws Exception {
        UserVO vo = baseVO("CHANNEL_ADMIN", "ch_ok");
        vo.setTenantId(1L);
        vo.setChannelId(2L);

        when(userMapper.selectUserByLoginId("ch_ok")).thenReturn(null);
        when(userMapper.selectSellerCompanyIdByTenant(1L)).thenReturn(10L);
        when(passwordEncoder.encode(any())).thenReturn("$2a$10$hash");

        userService.insertUser(vo);

        assertEquals(10L, vo.getCompanyId(), "companyId 자동 세팅 확인");
        assertEquals(2L,  vo.getChannelId(), "channelId 유지 확인");
        verify(userMapper).insertUser(vo);
    }

    @Test
    @DisplayName("CHANNEL_ADMIN — channelId 미입력 시 USER_002 에러")
    void insertUser_channelAdmin_noChannelId() throws Exception {
        UserVO vo = baseVO("CHANNEL_ADMIN", "ch_err");
        vo.setTenantId(1L);
        vo.setChannelId(null); // 미입력

        when(userMapper.selectUserByLoginId("ch_err")).thenReturn(null);

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class,
            () -> userService.insertUser(vo));
        assertTrue(ex.getMessage().startsWith("USER_002"));
    }

    @Test
    @DisplayName("CHANNEL_ADMIN — tenantId 미입력 시 USER_002 에러")
    void insertUser_channelAdmin_noTenantId() {
        UserVO vo = baseVO("CHANNEL_ADMIN", "ch_err2");
        vo.setTenantId(null);
        vo.setChannelId(2L);

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class,
            () -> userService.insertUser(vo));
        assertTrue(ex.getMessage().startsWith("USER_002"));
    }

    // ─────────────────────────────────────────────────
    // BUYER_ADMIN 등록
    // ─────────────────────────────────────────────────

    @Test
    @DisplayName("BUYER_ADMIN — 정상 등록: channelId 강제 NULL")
    void insertUser_buyerAdmin_success() throws Exception {
        UserVO vo = baseVO("BUYER_ADMIN", "buyer_ok");
        vo.setTenantId(1L);
        vo.setCompanyId(3L);
        vo.setChannelId(9L); // 입력해도 NULL 되어야 함

        when(userMapper.selectUserByLoginId("buyer_ok")).thenReturn(null);
        when(passwordEncoder.encode(any())).thenReturn("$2a$10$hash");

        userService.insertUser(vo);

        assertEquals(3L, vo.getCompanyId(), "companyId 직접선택 유지");
        assertNull(vo.getChannelId(), "BUYER_ADMIN channelId 강제 NULL");
        verify(userMapper).insertUser(vo);
    }

    @Test
    @DisplayName("BUYER_ADMIN — companyId 미입력 시 USER_002 에러")
    void insertUser_buyerAdmin_noCompanyId() throws Exception {
        UserVO vo = baseVO("BUYER_ADMIN", "buyer_err");
        vo.setTenantId(1L);
        vo.setCompanyId(null); // 미입력

        when(userMapper.selectUserByLoginId("buyer_err")).thenReturn(null);

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class,
            () -> userService.insertUser(vo));
        assertTrue(ex.getMessage().startsWith("USER_002"));
    }

    // ─────────────────────────────────────────────────
    // 담당자 동시 생성
    // ─────────────────────────────────────────────────

    @Test
    @DisplayName("createContactYn=Y 이고 companyId 있으면 insertCompanyContact 호출")
    void insertUser_withContact_callsInsertCompanyContact() throws Exception {
        UserVO vo = baseVO("BUYER_ADMIN", "buyer_contact");
        vo.setTenantId(1L);
        vo.setCompanyId(3L);
        vo.setCreateContactYn("Y");
        vo.setContactRole("PURCHASE");
        vo.setIsPrimaryContact("Y");

        when(userMapper.selectUserByLoginId("buyer_contact")).thenReturn(null);
        when(passwordEncoder.encode(any())).thenReturn("$2a$10$hash");

        userService.insertUser(vo);

        verify(userMapper, times(1)).insertCompanyContact(any(Map.class));
    }

    @Test
    @DisplayName("createContactYn=N 이면 insertCompanyContact 미호출")
    void insertUser_noContact_skipsInsertCompanyContact() throws Exception {
        UserVO vo = baseVO("BUYER_ADMIN", "buyer_nocontact");
        vo.setTenantId(1L);
        vo.setCompanyId(3L);
        vo.setCreateContactYn("N");

        when(userMapper.selectUserByLoginId("buyer_nocontact")).thenReturn(null);
        when(passwordEncoder.encode(any())).thenReturn("$2a$10$hash");

        userService.insertUser(vo);

        verify(userMapper, never()).insertCompanyContact(any());
    }

    // ─────────────────────────────────────────────────
    // selectFormOptions 테스트
    // ─────────────────────────────────────────────────

    @Test
    @DisplayName("CHANNEL_ADMIN + tenantId → tenants + channels + sellerCompanyId 반환")
    void selectFormOptions_channelAdmin_withTenantId() throws Exception {
        when(userMapper.selectActiveTenantList()).thenReturn(java.util.Collections.emptyList());
        when(userMapper.selectChannelListByTenant(1L)).thenReturn(java.util.Collections.emptyList());
        when(userMapper.selectSellerCompanyIdByTenant(1L)).thenReturn(10L);

        Map<String, Object> result = userService.selectFormOptions("CHANNEL_ADMIN", 1L);

        assertTrue(result.containsKey("tenants"));
        assertTrue(result.containsKey("channels"));
        assertTrue(result.containsKey("sellerCompanyId"));
        assertFalse(result.containsKey("buyerCompanies"), "CHANNEL_ADMIN에는 buyerCompanies 없음");
    }

    @Test
    @DisplayName("BUYER_ADMIN + tenantId → tenants + buyerCompanies 반환")
    void selectFormOptions_buyerAdmin_withTenantId() throws Exception {
        when(userMapper.selectActiveTenantList()).thenReturn(java.util.Collections.emptyList());
        when(userMapper.selectBuyerCompanyListByTenant(1L)).thenReturn(java.util.Collections.emptyList());

        Map<String, Object> result = userService.selectFormOptions("BUYER_ADMIN", 1L);

        assertTrue(result.containsKey("tenants"));
        assertTrue(result.containsKey("buyerCompanies"));
        assertFalse(result.containsKey("channels"), "BUYER_ADMIN에는 channels 없음");
    }

    @Test
    @DisplayName("tenantId = null → tenants만 반환 (역할 무관)")
    void selectFormOptions_noTenantId_returnsTenantsOnly() throws Exception {
        when(userMapper.selectActiveTenantList()).thenReturn(java.util.Collections.emptyList());

        Map<String, Object> result = userService.selectFormOptions("CHANNEL_ADMIN", null);

        assertTrue(result.containsKey("tenants"));
        assertFalse(result.containsKey("channels"));
        assertFalse(result.containsKey("buyerCompanies"));
        assertFalse(result.containsKey("sellerCompanyId"));
    }

    // ─────────────────────────────────────────────────
    // 지원하지 않는 역할
    // ─────────────────────────────────────────────────

    @Test
    @DisplayName("알 수 없는 userRole 입력 시 USER_002 에러")
    void insertUser_unknownRole_throwsError() throws Exception {
        UserVO vo = baseVO("UNKNOWN_ROLE", "unknown");
        when(userMapper.selectUserByLoginId("unknown")).thenReturn(null);

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class,
            () -> userService.insertUser(vo));
        assertTrue(ex.getMessage().startsWith("USER_002"));
    }

    @Test
    @DisplayName("userRole = null 입력 시 USER_002 에러")
    void insertUser_nullRole_throwsError() {
        UserVO vo = new UserVO();
        vo.setLoginId("nullrole");
        vo.setPasswordHash("Test1234!");
        vo.setUserName("테스트");
        vo.setStatus("ACTIVE");
        // userRole 미설정

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class,
            () -> userService.insertUser(vo));
        assertTrue(ex.getMessage().startsWith("USER_002"));
    }

    // ─────────────────────────────────────────────────
    // 헬퍼 메서드
    // ─────────────────────────────────────────────────

    private UserVO superAdminVO(String loginId) {
        UserVO vo = new UserVO();
        vo.setUserRole("SUPER_ADMIN");
        vo.setLoginId(loginId);
        vo.setPasswordHash("Test1234!");
        vo.setUserName("수퍼관리자");
        vo.setStatus("ACTIVE");
        return vo;
    }

    private UserVO baseVO(String role, String loginId) {
        UserVO vo = new UserVO();
        vo.setUserRole(role);
        vo.setLoginId(loginId);
        vo.setPasswordHash("Test1234!");
        vo.setUserName("테스트사용자");
        vo.setStatus("ACTIVE");
        return vo;
    }
}
```

### 14-2. 테스트 파일 위치

```
src/test/java/
  kr/co/matpam/admin/user/service/impl/
    UserServiceImplTest.java   ← 위 테스트 클래스
```

### 14-3. 테스트 케이스 요약

| 분류 | 케이스 | 검증 내용 |
|------|--------|-----------|
| SUPER_ADMIN | 정상 등록 | tenant/company/channel 강제 NULL |
| SUPER_ADMIN | 로그인ID 중복 | USER_001 에러 |
| SUPER_ADMIN | 비밀번호 빈값 | USER_002 에러 |
| SELLER_ADMIN | 정상 등록 | companyId 자동 세팅, channelId NULL |
| SELLER_ADMIN | tenantId 미입력 | USER_002 에러 |
| SELLER_ADMIN | 대표판매업체 없음 | USER_004 에러 |
| CHANNEL_ADMIN | 정상 등록 | companyId 자동 세팅, channelId 유지 |
| CHANNEL_ADMIN | channelId 미입력 | USER_002 에러 |
| CHANNEL_ADMIN | tenantId 미입력 | USER_002 에러 |
| BUYER_ADMIN | 정상 등록 | companyId 직접선택, channelId NULL |
| BUYER_ADMIN | companyId 미입력 | USER_002 에러 |
| 담당자 동시생성 | createContactYn=Y | insertCompanyContact 호출 확인 |
| 담당자 동시생성 | createContactYn=N | insertCompanyContact 미호출 확인 |
| formOptions | CHANNEL_ADMIN+tenantId | tenants+channels+sellerCompanyId |
| formOptions | BUYER_ADMIN+tenantId | tenants+buyerCompanies |
| formOptions | tenantId=null | tenants만 반환 |
| 역할 오류 | 알 수 없는 역할 | USER_002 에러 |
| 역할 오류 | userRole=null | USER_002 에러 |

---

## 15. 공통코드 정의 (확정)

### 15-1. 회원/권한 도메인

| 코드 그룹 | 값 | 한글명 |
|-----------|-----|--------|
| USER_ROLE | SUPER_ADMIN | 수퍼관리자 |
| USER_ROLE | SELLER_ADMIN | 판매처관리자 |
| USER_ROLE | CHANNEL_ADMIN | 채널관리자 |
| USER_ROLE | BUYER_ADMIN | 구매처관리자 |
| COMPANY_TYPE | SELLER | 판매업체 |
| COMPANY_TYPE | BUYER | 구매업체 |
| SELLER_TYPE | RAW | 원물 |
| SELLER_TYPE | PROCESSED | 가공 |
| SELLER_TYPE | FINISHED | 완제품 |
| CHANNEL_TYPE | PARCEL | 전국택배 |
| CHANNEL_TYPE | FREIGHT | 화물직송 |
| CHANNEL_TYPE | PICKUP | 공장수령 |
| BIZ_STATUS | ACTIVE | 정상 |
| BIZ_STATUS | SUSPENDED | 휴업 |
| BIZ_STATUS | CLOSED | 폐업 |
| USER_STATUS | ACTIVE | 활성 |
| USER_STATUS | LOCKED | 잠금 |
| USER_STATUS | INACTIVE | 비활성 |
| CONTACT_ROLE | ADMIN | 총괄담당 |
| CONTACT_ROLE | SALES | 영업담당 |
| CONTACT_ROLE | TAX | 세금계산서담당 |
| CONTACT_ROLE | SETTLEMENT | 정산담당 |
| CONTACT_ROLE | SHIPPING | 출고담당 |
| CONTACT_ROLE | PURCHASE | 구매담당 |

### 15-2. 권한/승인 도메인 (신규)

| 코드 그룹 | 값 | 한글명 |
|-----------|-----|--------|
| PERMISSION_DOMAIN | PRODUCT | 상품 |
| PERMISSION_DOMAIN | ORDER | 주문 |
| PERMISSION_DOMAIN | FINANCE | 자금/여신 |
| PERMISSION_DOMAIN | USER | 사용자 |
| PERMISSION_DOMAIN | AUDIT | 감사로그 |
| PERMISSION_DOMAIN | SYSTEM | 시스템 |
| OVERRIDE_TYPE | GRANT | 권한 추가 부여 |
| OVERRIDE_TYPE | DENY | 권한 명시적 차단 |
| APPROVAL_STATUS | PENDING | 대기 |
| APPROVAL_STATUS | APPROVED | 승인 |
| APPROVAL_STATUS | REJECTED | 반려 |
| APPROVAL_STATUS | CANCELLED | 취소 |

### 15-3. 상품/재고 도메인 (MATPAM_MANAGER.md §2)

| 코드 그룹 | 값 | 한글명 |
|-----------|-----|--------|
| ITEM_KIND | GOODS | 상품(재고있음) |
| ITEM_KIND | SERVICE | 서비스(재고없음) |
| PROCESSING_TYPE | RAW | 원물 |
| PROCESSING_TYPE | PROCESSED | 가공품 |
| PROCESSING_TYPE | PROCESS_SERVICE | 가공서비스 |
| TAX_CATEGORY | EXEMPT | 면세 |
| TAX_CATEGORY | TAXABLE | 과세(부가세 10%) |
| BUNDLE_MODE | RECOMMENDED | 추천 연관 |
| BUNDLE_MODE | OPTIONAL | 선택 추가 |
| BUNDLE_MODE | REQUIRED | 필수 묶음 |
| STOCK_TXN_TYPE | IN | 입고 |
| STOCK_TXN_TYPE | OUT | 출고 |
| STOCK_TXN_TYPE | CONSUME | 가공 투입 |
| STOCK_TXN_TYPE | PRODUCE | 가공 완료 |
| STOCK_TXN_TYPE | ADJUST | 재고 조정 |

### 15-4. 자금/여신 도메인 (MATPAM_MANAGER.md §5~§6)

| 코드 그룹 | 값 | 한글명 |
|-----------|-----|--------|
| ADVANCE_TXN_TYPE | DEPOSIT | 선급금 입금 |
| ADVANCE_TXN_TYPE | USE | 선급금 사용 |
| ADVANCE_TXN_TYPE | REFUND | 환불 |
| ADVANCE_TXN_TYPE | ADJUST | 조정 |
| PAYMENT_SOURCE_TYPE | ADVANCE | 선급금 |
| PAYMENT_SOURCE_TYPE | CREDIT | 여신 |
| PAYMENT_SOURCE_TYPE | EXTERNAL_PAYMENT | 직접 결제 |
| RECEIVABLE_TXN_TYPE | ORDER_USE | 주문 여신 사용 |
| RECEIVABLE_TXN_TYPE | PAYMENT_RECEIPT | 결제 수령 |
| RECEIVABLE_TXN_TYPE | ADJUST | 조정 |
| RECEIVABLE_TXN_TYPE | REFUND | 환불 |

---

## 16. 보안 및 운영 주의사항

| 항목 | 규칙 |
|------|------|
| 비밀번호 저장 | BCrypt 해시 후 저장. `password_hash` 필드에 평문 절대 금지 |
| 계좌번호 저장 | AES 암호화 후 `account_no_enc` 컬럼에 저장 |
| 감사로그 | `before_json`, `after_json`에 비밀번호·계좌번호 원문 포함 금지 |
| DB CHECK 제약 | MariaDB 10.3.10+ 필수. 서비스 레이어 이중 검증 병행 |
| GENERATED 컬럼 | `seller_tenant_guard`, `primary_company_guard`, `default_company_guard` — 버전별 테스트 필요 |
| 개인정보 마스킹 | 목록 화면 휴대폰·이메일 마스킹 처리 권장 (2단계) |
| 감사로그 보관 | 장기 보관 주기·아카이빙 정책 별도 수립 필요 (2단계) |

---

## 17. 향후 구현 예정 (2단계)

| 항목 | 설명 |
|------|------|
| 권한 매트릭스 적용 | 로그인한 역할에 따라 생성 가능 역할 카드 제한 (USER_003) |
| BUYER_ADMIN company_type 검증 강화 | selectBuyerCompanyListByTenant에서 이미 BUYER 필터 중, 저장 시 재확인 (USER_005/007) |
| CHANNEL_ADMIN 구매업체 채널 소속 검증 | tb_buyer_channel 조회로 자기 채널 구매업체만 등록 (USER_008) |
| 회원 상세/수정 화면 | UserForm.jsp 수정 모드 (userId 파라미터 존재 시 기존 데이터 로드) |
| 개인정보 마스킹 | 목록/상세 화면 휴대폰·이메일 마스킹 |
| 감사로그 저장 | insertUser / updateUser / updateUserStatus 시 tb_audit_log INSERT |
| 업체(Company) 관리 화면 | CompanyForm.jsp / CompanyList.jsp 재설계 |
| 테넌트(Tenant) 관리 화면 | TenantForm.jsp / TenantList.jsp 재설계 |
| **권한/승인 워크플로우** | tb_permission + tb_role_permission + tb_approval_request 기반 승인 처리 화면 |
| **상품 도메인 연계** | MATPAM_MANAGER.md P0 기준 — 상품 마스터 3종 분리, 주문 라인 세금 스냅샷 구현 |
| **자금 원장 연계** | MATPAM_MANAGER.md Model A — tb_buyer_advance_ledger, tb_payment_allocation, tb_receivable_ledger 화면 |
| **여신 한도 관리** | tb_buyer_credit_policy + tb_buyer_credit_limit_history + 승인 워크플로우 UI |
| **감사로그 조회 화면** | AUDIT_LOG_VIEW 권한 기반 — entity_name/action_type 필터, before/after JSON diff 표시 |
