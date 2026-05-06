-- =========================================================
-- MATPAM B2B 플랫폼 — 도메인 2/3 신규 테이블 DDL
-- 설계 기준: MATPAM_MANAGER.md (2026-05-01)
-- 대상: 상품/세금/주문/재고/자금/여신 + 권한/승인 워크플로우
-- DB: MariaDB 10.3.10+ (CHECK 제약 강제 버전)
-- =========================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =========================================================
-- [전제] 도메인 1 테이블 (USER_MANAGER_SQL_FINAL.sql 먼저 실행)
--   tb_tenant / tb_channel / tb_company / tb_user
--   tb_company_contact / tb_buyer_channel / tb_company_bank_account
--   tb_buyer_financial / tb_audit_log
-- =========================================================

-- =========================================================
-- [도메인 1 확장] 권한/승인 워크플로우 테이블
-- =========================================================

-- ---------------------------------------------------------
-- A-1. tb_permission — 권한 마스터
-- ---------------------------------------------------------
DROP TABLE IF EXISTS tb_user_permission_override;
DROP TABLE IF EXISTS tb_role_permission;
DROP TABLE IF EXISTS tb_approval_request;
DROP TABLE IF EXISTS tb_permission;

CREATE TABLE IF NOT EXISTS tb_permission (
    permission_id       BIGINT NOT NULL AUTO_INCREMENT COMMENT '권한 ID',
    permission_code     VARCHAR(100) NOT NULL COMMENT '권한 코드 (예: PRODUCT_TAX_EDIT)',
    permission_name     VARCHAR(200) NOT NULL COMMENT '권한명',
    description         VARCHAR(500) NULL COMMENT '설명',
    domain              ENUM('PRODUCT','ORDER','FINANCE','USER','AUDIT','SYSTEM') NOT NULL COMMENT '도메인',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    PRIMARY KEY (permission_id),
    UNIQUE KEY uk_tb_permission_01 (permission_code),
    KEY idx_tb_permission_01 (domain)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='권한 마스터';

-- ---------------------------------------------------------
-- A-2. tb_role_permission — 역할별 기본 권한
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_role_permission (
    role_permission_id  BIGINT NOT NULL AUTO_INCREMENT COMMENT '역할권한 ID',
    user_role           ENUM('SUPER_ADMIN','SELLER_ADMIN','CHANNEL_ADMIN','BUYER_ADMIN') NOT NULL COMMENT '역할',
    permission_id       BIGINT NOT NULL COMMENT '권한 ID',
    granted             CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '부여 여부 (Y=부여/N=명시적 거부)',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    PRIMARY KEY (role_permission_id),
    UNIQUE KEY uk_tb_role_permission_01 (user_role, permission_id),
    KEY idx_tb_role_permission_01 (permission_id),
    CONSTRAINT fk_tb_role_permission_01
        FOREIGN KEY (permission_id) REFERENCES tb_permission (permission_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_tb_role_permission_01 CHECK (granted IN ('Y','N'))
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='역할별 기본 권한 매핑';

-- ---------------------------------------------------------
-- A-3. tb_approval_request — 승인 요청
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_approval_request (
    approval_request_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '승인요청 ID',
    tenant_id           BIGINT NULL COMMENT '테넌트 ID (SUPER_ADMIN 요청은 NULL)',
    request_type        ENUM(
                            'PRODUCT_TAX_CHANGE',
                            'CREDIT_LIMIT_CHANGE',
                            'REFUND',
                            'TAX_DOCUMENT_REISSUE',
                            'USER_PERMISSION_OVERRIDE',
                            'BANK_ACCOUNT_CHANGE'
                        ) NOT NULL COMMENT '요청 유형',
    ref_table           VARCHAR(100) NOT NULL COMMENT '참조 테이블명',
    ref_id              BIGINT NOT NULL COMMENT '참조 PK',
    request_summary     VARCHAR(1000) NOT NULL COMMENT '요청 요약',
    before_json         LONGTEXT NULL COMMENT '변경 전 데이터 (JSON, 민감정보 마스킹)',
    after_json          LONGTEXT NOT NULL COMMENT '변경 후 데이터 (JSON, 민감정보 마스킹)',
    status              ENUM('PENDING','APPROVED','REJECTED','CANCELLED') NOT NULL DEFAULT 'PENDING' COMMENT '상태',
    requested_by        BIGINT NOT NULL COMMENT '요청자 user_id',
    requested_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '요청일시',
    reviewed_by         BIGINT NULL COMMENT '검토자 user_id',
    reviewed_at         DATETIME NULL COMMENT '검토일시',
    review_comment      VARCHAR(1000) NULL COMMENT '검토 의견',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (approval_request_id),
    KEY idx_tb_approval_request_01 (tenant_id, status),
    KEY idx_tb_approval_request_02 (request_type, status),
    KEY idx_tb_approval_request_03 (requested_by),
    KEY idx_tb_approval_request_04 (reviewed_by),
    KEY idx_tb_approval_request_05 (ref_table, ref_id),
    CONSTRAINT fk_tb_approval_request_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_tb_approval_request_02
        FOREIGN KEY (requested_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_approval_request_03
        FOREIGN KEY (reviewed_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='변경 사항 승인 요청 (2-depth 워크플로우)';

-- ---------------------------------------------------------
-- A-4. tb_user_permission_override — 사용자 개별 권한 오버라이드
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_user_permission_override (
    override_id         BIGINT NOT NULL AUTO_INCREMENT COMMENT '오버라이드 ID',
    user_id             BIGINT NOT NULL COMMENT '사용자 ID',
    permission_id       BIGINT NOT NULL COMMENT '권한 ID',
    override_type       ENUM('GRANT','DENY') NOT NULL COMMENT '오버라이드 유형',
    reason              VARCHAR(500) NOT NULL COMMENT '사유',
    approved_by         BIGINT NOT NULL COMMENT '승인자 user_id',
    effective_from      DATE NOT NULL COMMENT '유효 시작일',
    effective_to        DATE NULL COMMENT '유효 종료일 (NULL=무기한)',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    PRIMARY KEY (override_id),
    UNIQUE KEY uk_tb_user_permission_override_01 (user_id, permission_id),
    KEY idx_tb_user_permission_override_01 (permission_id),
    KEY idx_tb_user_permission_override_02 (approved_by),
    KEY idx_tb_user_permission_override_03 (effective_from, effective_to),
    CONSTRAINT fk_tb_user_perm_override_01
        FOREIGN KEY (user_id) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_tb_user_perm_override_02
        FOREIGN KEY (permission_id) REFERENCES tb_permission (permission_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_user_perm_override_03
        FOREIGN KEY (approved_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='사용자 개별 권한 오버라이드 (역할 기본값 예외 처리)';

-- =========================================================
-- [감사로그 컬럼 확장] tb_audit_log에 필드 추가
-- USER_MANAGER_SQL_FINAL.sql의 tb_audit_log에 없는 컬럼 추가
-- =========================================================
ALTER TABLE tb_audit_log
    MODIFY COLUMN action_type ENUM(
        'INSERT','UPDATE','DELETE','LOGIN','APPROVE','REJECT'
    ) NOT NULL COMMENT '작업유형',
    ADD COLUMN IF NOT EXISTS reason_code          VARCHAR(100) NULL COMMENT '변경 사유 코드' AFTER ip_address,
    ADD COLUMN IF NOT EXISTS approval_request_id  BIGINT NULL COMMENT '연관 승인요청 ID' AFTER reason_code,
    ADD COLUMN IF NOT EXISTS trace_id             VARCHAR(100) NULL COMMENT '분산추적 트레이스 ID' AFTER approval_request_id;

-- tb_audit_log → tb_approval_request FK (순환 참조 방지: tb_approval_request가 먼저 생성된 후 추가)
ALTER TABLE tb_audit_log
    ADD CONSTRAINT fk_tb_audit_log_03
        FOREIGN KEY IF NOT EXISTS (approval_request_id) REFERENCES tb_approval_request (approval_request_id)
        ON UPDATE CASCADE ON DELETE SET NULL;

-- =========================================================
-- [도메인 2] 상품 / 세금 / 주문 / 재고
-- =========================================================

-- ---------------------------------------------------------
-- B-1. tb_product — 상품 마스터 (RAW / PROCESSED / PROCESS_SERVICE)
-- ---------------------------------------------------------
DROP TABLE IF EXISTS tb_shipment_line;
DROP TABLE IF EXISTS tb_stock_ledger;
DROP TABLE IF EXISTS tb_process_batch;
DROP TABLE IF EXISTS tb_tax_document;
DROP TABLE IF EXISTS tb_order_line;
DROP TABLE IF EXISTS tb_order;
DROP TABLE IF EXISTS tb_product_relation;
DROP TABLE IF EXISTS tb_product_tax_rule;
DROP TABLE IF EXISTS tb_product;

CREATE TABLE IF NOT EXISTS tb_product (
    product_id              BIGINT NOT NULL AUTO_INCREMENT COMMENT '상품 ID',
    tenant_id               BIGINT NOT NULL COMMENT '테넌트 ID',
    seller_company_id       BIGINT NOT NULL COMMENT '판매업체 ID',
    product_code            VARCHAR(100) NOT NULL COMMENT '상품 코드',
    product_name            VARCHAR(300) NOT NULL COMMENT '상품명',
    item_kind               ENUM('GOODS','SERVICE') NOT NULL COMMENT '상품 종류',
    processing_type         ENUM('RAW','PROCESSED','PROCESS_SERVICE') NOT NULL COMMENT '가공 유형',
    tax_category            ENUM('EXEMPT','TAXABLE') NOT NULL COMMENT '과세 구분',
    tax_rule_version_id     BIGINT NULL COMMENT '현재 적용 세금규칙 버전 ID',
    independent_sale_yn     CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '단독 판매 가능 여부',
    status                  ENUM('ACTIVE','INACTIVE','DISCONTINUED') NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    created_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    created_by              BIGINT NULL COMMENT '등록 사용자 ID',
    updated_by              BIGINT NULL COMMENT '수정 사용자 ID',
    PRIMARY KEY (product_id),
    UNIQUE KEY uk_tb_product_01 (tenant_id, product_code),
    KEY idx_tb_product_01 (seller_company_id),
    KEY idx_tb_product_02 (item_kind, processing_type),
    KEY idx_tb_product_03 (tax_category),
    KEY idx_tb_product_04 (status),
    KEY idx_tb_product_05 (created_by),
    CONSTRAINT fk_tb_product_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_product_02
        FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_product_03
        FOREIGN KEY (created_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_tb_product_04
        FOREIGN KEY (updated_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    -- SERVICE 타입은 반드시 PROCESS_SERVICE
    CONSTRAINT chk_tb_product_01 CHECK (
        (item_kind = 'SERVICE' AND processing_type = 'PROCESS_SERVICE')
        OR
        (item_kind = 'GOODS' AND processing_type IN ('RAW','PROCESSED'))
    ),
    CONSTRAINT chk_tb_product_02 CHECK (independent_sale_yn IN ('Y','N'))
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='상품 마스터 (원물/가공품/가공서비스 3종)';

-- ---------------------------------------------------------
-- B-2. tb_product_tax_rule — 상품 세금 규칙 버전 이력
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_product_tax_rule (
    tax_rule_version_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '세금규칙 버전 ID',
    product_id          BIGINT NOT NULL COMMENT '상품 ID',
    tax_category        ENUM('EXEMPT','TAXABLE') NOT NULL COMMENT '이 버전의 과세 구분',
    legal_basis_memo    VARCHAR(1000) NOT NULL COMMENT '법적 근거 메모',
    effective_from      DATE NOT NULL COMMENT '유효 시작일',
    effective_to        DATE NULL COMMENT '유효 종료일 (NULL=현재 유효)',
    approved_by         BIGINT NOT NULL COMMENT '승인자 user_id',
    approved_at         DATETIME NOT NULL COMMENT '승인일시',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    PRIMARY KEY (tax_rule_version_id),
    KEY idx_tb_product_tax_rule_01 (product_id, effective_to),
    KEY idx_tb_product_tax_rule_02 (approved_by),
    CONSTRAINT fk_tb_product_tax_rule_01
        FOREIGN KEY (product_id) REFERENCES tb_product (product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_product_tax_rule_02
        FOREIGN KEY (approved_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='상품 세금 규칙 버전 이력 (변경 시 신규 버전 INSERT)';

-- tb_product.tax_rule_version_id FK (순환 참조 해결: 테이블 생성 후 추가)
ALTER TABLE tb_product
    ADD CONSTRAINT fk_tb_product_05
        FOREIGN KEY (tax_rule_version_id) REFERENCES tb_product_tax_rule (tax_rule_version_id)
        ON UPDATE CASCADE ON DELETE SET NULL;

-- ---------------------------------------------------------
-- B-3. tb_product_relation — 상품 연관관계
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_product_relation (
    relation_id         BIGINT NOT NULL AUTO_INCREMENT COMMENT '연관관계 ID',
    base_product_id     BIGINT NOT NULL COMMENT '기준 상품 ID',
    related_product_id  BIGINT NOT NULL COMMENT '연관 상품 ID',
    relation_kind       ENUM(
                            'RAW_TO_PROCESSED',
                            'RAW_TO_PROCESS_SERVICE',
                            'PROCESSED_TO_RAW',
                            'BUNDLE'
                        ) NOT NULL COMMENT '관계 유형',
    bundle_mode         ENUM('RECOMMENDED','OPTIONAL','REQUIRED') NOT NULL DEFAULT 'RECOMMENDED' COMMENT '묶음 모드',
    display_order       INT NOT NULL DEFAULT 0 COMMENT '표시 순서',
    effective_from      DATE NOT NULL COMMENT '유효 시작일',
    effective_to        DATE NULL COMMENT '유효 종료일 (NULL=현재 유효)',
    status              ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    created_by          BIGINT NULL COMMENT '등록 사용자 ID',
    PRIMARY KEY (relation_id),
    UNIQUE KEY uk_tb_product_relation_01 (base_product_id, related_product_id, relation_kind, effective_from),
    KEY idx_tb_product_relation_01 (related_product_id),
    KEY idx_tb_product_relation_02 (status, effective_to),
    KEY idx_tb_product_relation_03 (created_by),
    CONSTRAINT fk_tb_product_relation_01
        FOREIGN KEY (base_product_id) REFERENCES tb_product (product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_product_relation_02
        FOREIGN KEY (related_product_id) REFERENCES tb_product (product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_product_relation_03
        FOREIGN KEY (created_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    -- 자기 자신 연관 불가
    CONSTRAINT chk_tb_product_relation_01 CHECK (base_product_id != related_product_id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='상품 연관관계 (원물-가공품-서비스 묶음)';

-- ---------------------------------------------------------
-- B-4. tb_order — 주문 헤더
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_order (
    order_id                BIGINT NOT NULL AUTO_INCREMENT COMMENT '주문 ID',
    tenant_id               BIGINT NOT NULL COMMENT '테넌트 ID',
    order_no                VARCHAR(50) NOT NULL COMMENT '주문번호 (표시용, 예: ORD-20260501-PAR-000001)',
    seller_company_id       BIGINT NOT NULL COMMENT '판매업체 ID',
    buyer_company_id        BIGINT NOT NULL COMMENT '구매업체 ID',
    channel_id              BIGINT NOT NULL COMMENT '채널 ID',
    order_status            ENUM('DRAFT','CONFIRMED','PROCESSING','SHIPPED','COMPLETED','CANCELLED') NOT NULL DEFAULT 'DRAFT' COMMENT '주문 상태',
    order_date              DATE NOT NULL COMMENT '주문일',
    total_supply_amount     DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '공급가액 합계',
    total_vat_amount        DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '부가세 합계',
    total_amount            DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '합계금액',
    memo                    VARCHAR(1000) NULL COMMENT '주문 메모',
    created_by              BIGINT NULL COMMENT '주문 생성 사용자 ID',
    created_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (order_id),
    UNIQUE KEY uk_tb_order_01 (order_no),
    KEY idx_tb_order_01 (tenant_id, order_status),
    KEY idx_tb_order_02 (seller_company_id),
    KEY idx_tb_order_03 (buyer_company_id),
    KEY idx_tb_order_04 (channel_id),
    KEY idx_tb_order_05 (order_date),
    KEY idx_tb_order_06 (created_by),
    CONSTRAINT fk_tb_order_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_order_02
        FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_order_03
        FOREIGN KEY (buyer_company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_order_04
        FOREIGN KEY (channel_id) REFERENCES tb_channel (channel_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_order_05
        FOREIGN KEY (created_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT chk_tb_order_01 CHECK (total_supply_amount >= 0),
    CONSTRAINT chk_tb_order_02 CHECK (total_vat_amount >= 0),
    CONSTRAINT chk_tb_order_03 CHECK (total_amount >= 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='주문 헤더';

-- ---------------------------------------------------------
-- B-5. tb_order_line — 주문 라인 (세금 스냅샷 포함)
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_order_line (
    order_line_id               BIGINT NOT NULL AUTO_INCREMENT COMMENT '주문 라인 ID',
    order_id                    BIGINT NOT NULL COMMENT '주문 ID',
    product_id                  BIGINT NOT NULL COMMENT '상품 ID (참조용, 스냅샷은 아래 컬럼)',
    line_no                     INT NOT NULL COMMENT '라인 번호 (주문 내 순서)',
    item_kind                   ENUM('GOODS','SERVICE') NOT NULL COMMENT '상품 종류 스냅샷',
    processing_type_snapshot    ENUM('RAW','PROCESSED','PROCESS_SERVICE') NOT NULL COMMENT '가공유형 스냅샷',
    product_name_snapshot       VARCHAR(300) NOT NULL COMMENT '주문 시점 상품명 스냅샷',
    tax_category_snapshot       ENUM('EXEMPT','TAXABLE') NOT NULL COMMENT '주문 시점 과세구분 스냅샷 (확정 후 불변)',
    tax_rule_version_id         BIGINT NULL COMMENT '적용 세금규칙 버전 ID 스냅샷',
    legal_basis_snapshot_memo   VARCHAR(1000) NULL COMMENT '주문 시점 법적 근거 메모 스냅샷',
    unit_price                  DECIMAL(18,2) NOT NULL COMMENT '단가 스냅샷',
    qty                         DECIMAL(18,3) NOT NULL COMMENT '수량',
    supply_amount               DECIMAL(18,2) NOT NULL COMMENT '공급가액 (unit_price × qty)',
    vat_amount                  DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '부가세액',
    total_amount                DECIMAL(18,2) NOT NULL COMMENT '라인 합계',
    relation_group_id           VARCHAR(50) NULL COMMENT '묶음 그룹 ID (REQUIRED 묶음 추적)',
    line_status                 ENUM('ACTIVE','CANCELLED') NOT NULL DEFAULT 'ACTIVE' COMMENT '라인 상태',
    created_at                  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at                  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (order_line_id),
    UNIQUE KEY uk_tb_order_line_01 (order_id, line_no),
    KEY idx_tb_order_line_01 (product_id),
    KEY idx_tb_order_line_02 (tax_category_snapshot),
    KEY idx_tb_order_line_03 (line_status),
    KEY idx_tb_order_line_04 (relation_group_id),
    CONSTRAINT fk_tb_order_line_01
        FOREIGN KEY (order_id) REFERENCES tb_order (order_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_order_line_02
        FOREIGN KEY (product_id) REFERENCES tb_product (product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_order_line_03
        FOREIGN KEY (tax_rule_version_id) REFERENCES tb_product_tax_rule (tax_rule_version_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT chk_tb_order_line_01 CHECK (qty > 0),
    CONSTRAINT chk_tb_order_line_02 CHECK (unit_price >= 0),
    CONSTRAINT chk_tb_order_line_03 CHECK (supply_amount >= 0),
    CONSTRAINT chk_tb_order_line_04 CHECK (vat_amount >= 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='주문 라인 (세금 스냅샷 포함, 확정 후 불변)';

-- ---------------------------------------------------------
-- B-6. tb_tax_document — 세금 문서 (세금계산서/거래명세서)
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_tax_document (
    tax_document_id         BIGINT NOT NULL AUTO_INCREMENT COMMENT '세금문서 ID',
    tenant_id               BIGINT NOT NULL COMMENT '테넌트 ID',
    order_id                BIGINT NOT NULL COMMENT '주문 ID',
    document_type           ENUM('TAX_INVOICE','INVOICE','STATEMENT') NOT NULL COMMENT '문서 유형',
    tax_category            ENUM('EXEMPT','TAXABLE','MIXED') NOT NULL COMMENT '과세 구분',
    supplier_company_id     BIGINT NOT NULL COMMENT '공급자 업체 ID',
    receiver_company_id     BIGINT NOT NULL COMMENT '공급받는자 업체 ID',
    supply_amount           DECIMAL(18,2) NOT NULL COMMENT '공급가액',
    vat_amount              DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '세액',
    total_amount            DECIMAL(18,2) NOT NULL COMMENT '합계',
    issue_status            ENUM('PENDING','ISSUED','CANCELLED','REISSUED') NOT NULL DEFAULT 'PENDING' COMMENT '발행 상태',
    issued_at               DATETIME NULL COMMENT '발행일시',
    cancelled_at            DATETIME NULL COMMENT '취소일시',
    reissue_reason          VARCHAR(500) NULL COMMENT '재발행 사유',
    approval_request_id     BIGINT NULL COMMENT '재발행 승인 요청 ID',
    created_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (tax_document_id),
    KEY idx_tb_tax_document_01 (order_id, issue_status),
    KEY idx_tb_tax_document_02 (supplier_company_id),
    KEY idx_tb_tax_document_03 (receiver_company_id),
    KEY idx_tb_tax_document_04 (tenant_id, issued_at),
    KEY idx_tb_tax_document_05 (approval_request_id),
    CONSTRAINT fk_tb_tax_document_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_tax_document_02
        FOREIGN KEY (order_id) REFERENCES tb_order (order_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_tax_document_03
        FOREIGN KEY (supplier_company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_tax_document_04
        FOREIGN KEY (receiver_company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_tax_document_05
        FOREIGN KEY (approval_request_id) REFERENCES tb_approval_request (approval_request_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT chk_tb_tax_document_01 CHECK (supply_amount >= 0),
    CONSTRAINT chk_tb_tax_document_02 CHECK (vat_amount >= 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='세금 문서 (세금계산서/거래명세서/지불명세서)';

-- ---------------------------------------------------------
-- B-7. tb_shipment_line — 출고 라인
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_shipment_line (
    shipment_line_id    BIGINT NOT NULL AUTO_INCREMENT COMMENT '출고 라인 ID',
    order_id            BIGINT NOT NULL COMMENT '주문 ID',
    order_line_id       BIGINT NOT NULL COMMENT '주문 라인 ID',
    product_id          BIGINT NOT NULL COMMENT '상품 ID',
    lot_id              VARCHAR(100) NULL COMMENT '로트 번호 (SERVICE는 NULL)',
    scheduled_qty       DECIMAL(18,3) NOT NULL COMMENT '출고 예정 수량',
    shipped_qty         DECIMAL(18,3) NULL COMMENT '실제 출고 수량',
    shipment_status     ENUM('PENDING','PARTIAL','SHIPPED','CANCELLED') NOT NULL DEFAULT 'PENDING' COMMENT '출고 상태',
    scheduled_at        DATE NULL COMMENT '출고 예정일',
    shipped_at          DATETIME NULL COMMENT '실제 출고일시',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    created_by          BIGINT NULL COMMENT '생성 사용자 ID',
    PRIMARY KEY (shipment_line_id),
    KEY idx_tb_shipment_line_01 (order_id, shipment_status),
    KEY idx_tb_shipment_line_02 (order_line_id),
    KEY idx_tb_shipment_line_03 (product_id),
    KEY idx_tb_shipment_line_04 (scheduled_at),
    KEY idx_tb_shipment_line_05 (created_by),
    CONSTRAINT fk_tb_shipment_line_01
        FOREIGN KEY (order_id) REFERENCES tb_order (order_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_shipment_line_02
        FOREIGN KEY (order_line_id) REFERENCES tb_order_line (order_line_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_shipment_line_03
        FOREIGN KEY (product_id) REFERENCES tb_product (product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_shipment_line_04
        FOREIGN KEY (created_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT chk_tb_shipment_line_01 CHECK (scheduled_qty > 0),
    CONSTRAINT chk_tb_shipment_line_02 CHECK (shipped_qty IS NULL OR shipped_qty >= 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='주문 라인별 출고 이력';

-- ---------------------------------------------------------
-- B-8. tb_process_batch — 가공 처리 배치
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_process_batch (
    process_batch_id            BIGINT NOT NULL AUTO_INCREMENT COMMENT '배치 ID',
    tenant_id                   BIGINT NOT NULL COMMENT '테넌트 ID',
    seller_company_id           BIGINT NOT NULL COMMENT '판매업체 ID',
    source_product_id           BIGINT NOT NULL COMMENT '원물 상품 ID (RAW)',
    target_product_id           BIGINT NOT NULL COMMENT '가공품 상품 ID (PROCESSED)',
    process_service_product_id  BIGINT NULL COMMENT '가공서비스 상품 ID (PROCESS_SERVICE, 없으면 NULL)',
    source_lot_id               VARCHAR(100) NULL COMMENT '원물 로트 번호',
    target_lot_id               VARCHAR(100) NULL COMMENT '가공품 로트 번호',
    input_qty                   DECIMAL(18,3) NOT NULL COMMENT '투입 수량 (원물)',
    output_qty                  DECIMAL(18,3) NOT NULL DEFAULT 0 COMMENT '생산 수량 (가공품)',
    loss_qty                    DECIMAL(18,3) NOT NULL DEFAULT 0 COMMENT '손실 수량',
    batch_status                ENUM('PLANNED','IN_PROGRESS','COMPLETED','CANCELLED') NOT NULL DEFAULT 'PLANNED' COMMENT '배치 상태',
    processed_at                DATETIME NULL COMMENT '가공 완료일시',
    processed_by                BIGINT NULL COMMENT '처리 사용자 ID',
    created_at                  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at                  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (process_batch_id),
    KEY idx_tb_process_batch_01 (tenant_id, batch_status),
    KEY idx_tb_process_batch_02 (source_product_id),
    KEY idx_tb_process_batch_03 (target_product_id),
    KEY idx_tb_process_batch_04 (processed_by),
    CONSTRAINT fk_tb_process_batch_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_process_batch_02
        FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_process_batch_03
        FOREIGN KEY (source_product_id) REFERENCES tb_product (product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_process_batch_04
        FOREIGN KEY (target_product_id) REFERENCES tb_product (product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_process_batch_05
        FOREIGN KEY (process_service_product_id) REFERENCES tb_product (product_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_tb_process_batch_06
        FOREIGN KEY (processed_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT chk_tb_process_batch_01 CHECK (input_qty > 0),
    CONSTRAINT chk_tb_process_batch_02 CHECK (output_qty >= 0),
    CONSTRAINT chk_tb_process_batch_03 CHECK (loss_qty >= 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='원물→가공품 처리 배치 이력';

-- ---------------------------------------------------------
-- B-9. tb_stock_ledger — 재고 원장
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_stock_ledger (
    stock_txn_id    BIGINT NOT NULL AUTO_INCREMENT COMMENT '재고 거래 ID',
    tenant_id       BIGINT NOT NULL COMMENT '테넌트 ID',
    product_id      BIGINT NOT NULL COMMENT '상품 ID',
    lot_id          VARCHAR(100) NULL COMMENT '로트 번호',
    txn_type        ENUM('IN','OUT','ADJUST','CONSUME','PRODUCE') NOT NULL COMMENT '거래 유형',
    qty             DECIMAL(18,3) NOT NULL COMMENT '수량 (IN/PRODUCE=양수, OUT/CONSUME=음수)',
    balance_after   DECIMAL(18,3) NOT NULL COMMENT '거래 후 잔량',
    ref_table       VARCHAR(100) NOT NULL COMMENT '참조 테이블명',
    ref_id          BIGINT NOT NULL COMMENT '참조 ID',
    txn_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '거래일시',
    created_by      BIGINT NULL COMMENT '생성 사용자 ID',
    memo            VARCHAR(500) NULL COMMENT '메모',
    PRIMARY KEY (stock_txn_id),
    KEY idx_tb_stock_ledger_01 (tenant_id, product_id, txn_at),
    KEY idx_tb_stock_ledger_02 (product_id, lot_id),
    KEY idx_tb_stock_ledger_03 (txn_type),
    KEY idx_tb_stock_ledger_04 (ref_table, ref_id),
    KEY idx_tb_stock_ledger_05 (created_by),
    CONSTRAINT fk_tb_stock_ledger_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_stock_ledger_02
        FOREIGN KEY (product_id) REFERENCES tb_product (product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_stock_ledger_03
        FOREIGN KEY (created_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='재고 원장 (입고/출고/가공투입/가공완료/조정)';

-- =========================================================
-- [도메인 3] 자금 / 여신 / 선급금
-- =========================================================

-- ---------------------------------------------------------
-- C-1. tb_external_payment_txn — 외부 입금 거래 기록
-- ---------------------------------------------------------
DROP TABLE IF EXISTS tb_receivable_ledger;
DROP TABLE IF EXISTS tb_payment_allocation;
DROP TABLE IF EXISTS tb_buyer_advance_ledger;
DROP TABLE IF EXISTS tb_buyer_credit_limit_history;
DROP TABLE IF EXISTS tb_buyer_credit_policy;
DROP TABLE IF EXISTS tb_external_payment_txn;

CREATE TABLE IF NOT EXISTS tb_external_payment_txn (
    payment_txn_id      BIGINT NOT NULL AUTO_INCREMENT COMMENT '거래 ID',
    tenant_id           BIGINT NOT NULL COMMENT '테넌트 ID',
    seller_company_id   BIGINT NOT NULL COMMENT '판매업체 ID (수취 계좌 보유)',
    buyer_company_id    BIGINT NOT NULL COMMENT '구매업체 ID (납부 주체)',
    txn_type            ENUM('ADVANCE_DEPOSIT','CREDIT_PAYMENT','REFUND_OUT') NOT NULL COMMENT '거래 유형',
    amount              DECIMAL(18,2) NOT NULL COMMENT '금액',
    bank_name           VARCHAR(100) NULL COMMENT '입금 은행',
    depositor_name      VARCHAR(100) NULL COMMENT '입금자명',
    deposited_at        DATETIME NOT NULL COMMENT '입금 확인 일시',
    confirm_status      ENUM('PENDING','CONFIRMED','REJECTED') NOT NULL DEFAULT 'PENDING' COMMENT '확인 상태',
    confirmed_by        BIGINT NULL COMMENT '확인 사용자 ID',
    confirmed_at        DATETIME NULL COMMENT '확인 일시',
    memo                VARCHAR(500) NULL COMMENT '메모',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (payment_txn_id),
    KEY idx_tb_ext_payment_01 (tenant_id, confirm_status),
    KEY idx_tb_ext_payment_02 (buyer_company_id),
    KEY idx_tb_ext_payment_03 (seller_company_id),
    KEY idx_tb_ext_payment_04 (deposited_at),
    KEY idx_tb_ext_payment_05 (confirmed_by),
    CONSTRAINT fk_tb_ext_payment_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_ext_payment_02
        FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_ext_payment_03
        FOREIGN KEY (buyer_company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_ext_payment_04
        FOREIGN KEY (confirmed_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT chk_tb_ext_payment_01 CHECK (amount > 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='외부 입금 거래 기록 (Model A: 판매업체 계좌 직접 수취)';

-- ---------------------------------------------------------
-- C-2. tb_buyer_credit_policy — 구매업체 여신 정책
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_buyer_credit_policy (
    credit_policy_id    BIGINT NOT NULL AUTO_INCREMENT COMMENT '정책 ID',
    tenant_id           BIGINT NOT NULL COMMENT '테넌트 ID',
    seller_company_id   BIGINT NOT NULL COMMENT '판매업체 ID (채권자)',
    buyer_company_id    BIGINT NOT NULL COMMENT '구매업체 ID (채무자)',
    credit_limit_amount DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '여신 한도 금액',
    payment_terms_days  INT NOT NULL DEFAULT 30 COMMENT '결제 기한 (일수)',
    status              ENUM('ACTIVE','SUSPENDED','CLOSED') NOT NULL DEFAULT 'ACTIVE' COMMENT '정책 상태',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    created_by          BIGINT NULL COMMENT '생성 사용자 ID',
    PRIMARY KEY (credit_policy_id),
    UNIQUE KEY uk_tb_buyer_credit_policy_01 (tenant_id, seller_company_id, buyer_company_id),
    KEY idx_tb_buyer_credit_policy_01 (buyer_company_id),
    KEY idx_tb_buyer_credit_policy_02 (status),
    CONSTRAINT fk_tb_buyer_credit_policy_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_buyer_credit_policy_02
        FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_buyer_credit_policy_03
        FOREIGN KEY (buyer_company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_buyer_credit_policy_04
        FOREIGN KEY (created_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT chk_tb_buyer_credit_policy_01 CHECK (credit_limit_amount >= 0),
    CONSTRAINT chk_tb_buyer_credit_policy_02 CHECK (payment_terms_days > 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='구매업체 여신 정책 (판매업체가 부여하는 외상한도)';

-- ---------------------------------------------------------
-- C-3. tb_buyer_credit_limit_history — 여신 한도 변경 이력
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_buyer_credit_limit_history (
    credit_history_id   BIGINT NOT NULL AUTO_INCREMENT COMMENT '이력 ID',
    credit_policy_id    BIGINT NOT NULL COMMENT '정책 ID',
    old_limit           DECIMAL(18,2) NOT NULL COMMENT '변경 전 한도',
    new_limit           DECIMAL(18,2) NOT NULL COMMENT '변경 후 한도',
    reason              VARCHAR(500) NOT NULL COMMENT '변경 사유',
    requested_by        BIGINT NOT NULL COMMENT '요청자 user_id',
    approved_by         BIGINT NULL COMMENT '승인자 user_id',
    approved_at         DATETIME NULL COMMENT '승인 일시',
    approval_request_id BIGINT NULL COMMENT '승인 요청 ID',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    PRIMARY KEY (credit_history_id),
    KEY idx_tb_credit_limit_hist_01 (credit_policy_id),
    KEY idx_tb_credit_limit_hist_02 (requested_by),
    KEY idx_tb_credit_limit_hist_03 (approved_by),
    KEY idx_tb_credit_limit_hist_04 (approval_request_id),
    CONSTRAINT fk_tb_credit_limit_hist_01
        FOREIGN KEY (credit_policy_id) REFERENCES tb_buyer_credit_policy (credit_policy_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_credit_limit_hist_02
        FOREIGN KEY (requested_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_credit_limit_hist_03
        FOREIGN KEY (approved_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_tb_credit_limit_hist_04
        FOREIGN KEY (approval_request_id) REFERENCES tb_approval_request (approval_request_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT chk_tb_credit_limit_hist_01 CHECK (old_limit >= 0),
    CONSTRAINT chk_tb_credit_limit_hist_02 CHECK (new_limit >= 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='여신 한도 변경 이력 (승인 워크플로우 연계)';

-- ---------------------------------------------------------
-- C-4. tb_buyer_advance_ledger — 구매업체 선급금 원장
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_buyer_advance_ledger (
    advance_ledger_id   BIGINT NOT NULL AUTO_INCREMENT COMMENT '원장 ID',
    tenant_id           BIGINT NOT NULL COMMENT '테넌트 ID',
    buyer_company_id    BIGINT NOT NULL COMMENT '구매업체 ID',
    seller_company_id   BIGINT NOT NULL COMMENT '판매업체 ID',
    txn_type            ENUM('DEPOSIT','USE','REFUND','ADJUST') NOT NULL COMMENT '거래 유형',
    amount              DECIMAL(18,2) NOT NULL COMMENT '금액 (DEPOSIT=양수, USE=음수)',
    balance_after       DECIMAL(18,2) NOT NULL COMMENT '거래 후 잔액',
    ref_table           VARCHAR(100) NULL COMMENT '참조 테이블명',
    ref_id              BIGINT NULL COMMENT '참조 ID',
    reason_code         VARCHAR(100) NULL COMMENT '사유 코드',
    approval_request_id BIGINT NULL COMMENT '승인 요청 ID',
    txn_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '거래일시',
    created_by          BIGINT NULL COMMENT '생성 사용자 ID',
    memo                VARCHAR(500) NULL COMMENT '메모',
    PRIMARY KEY (advance_ledger_id),
    KEY idx_tb_advance_ledger_01 (tenant_id, buyer_company_id, seller_company_id),
    KEY idx_tb_advance_ledger_02 (txn_type),
    KEY idx_tb_advance_ledger_03 (txn_at),
    KEY idx_tb_advance_ledger_04 (approval_request_id),
    KEY idx_tb_advance_ledger_05 (created_by),
    CONSTRAINT fk_tb_advance_ledger_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_advance_ledger_02
        FOREIGN KEY (buyer_company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_advance_ledger_03
        FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_advance_ledger_04
        FOREIGN KEY (approval_request_id) REFERENCES tb_approval_request (approval_request_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_tb_advance_ledger_05
        FOREIGN KEY (created_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='구매업체 선급금 원장 (입금/사용/환불/조정)';

-- ---------------------------------------------------------
-- C-5. tb_payment_allocation — 결제 할당 원장
-- (주문별 어떤 재원에서 얼마를 할당했는지)
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_payment_allocation (
    allocation_id       BIGINT NOT NULL AUTO_INCREMENT COMMENT '할당 ID',
    tenant_id           BIGINT NOT NULL COMMENT '테넌트 ID',
    order_id            BIGINT NOT NULL COMMENT '주문 ID',
    source_type         ENUM('ADVANCE','CREDIT','EXTERNAL_PAYMENT') NOT NULL COMMENT '결제 재원 유형',
    source_ref_id       BIGINT NOT NULL COMMENT '재원 참조 ID (선급원장ID/여신정책ID/외부결제ID)',
    allocated_amount    DECIMAL(18,2) NOT NULL COMMENT '할당 금액',
    allocated_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '할당 일시',
    created_by          BIGINT NULL COMMENT '할당 사용자 ID',
    PRIMARY KEY (allocation_id),
    KEY idx_tb_payment_allocation_01 (order_id, source_type),
    KEY idx_tb_payment_allocation_02 (source_type, source_ref_id),
    KEY idx_tb_payment_allocation_03 (created_by),
    CONSTRAINT fk_tb_payment_allocation_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_payment_allocation_02
        FOREIGN KEY (order_id) REFERENCES tb_order (order_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_payment_allocation_03
        FOREIGN KEY (created_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT chk_tb_payment_allocation_01 CHECK (allocated_amount > 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='주문별 결제 할당 원장 (선급/여신/직접결제 순서 적용)';

-- ---------------------------------------------------------
-- C-6. tb_receivable_ledger — 매출채권 원장
-- (여신 사용 주문의 채권 발생 및 회수 추적)
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_receivable_ledger (
    receivable_id       BIGINT NOT NULL AUTO_INCREMENT COMMENT '원장 ID',
    tenant_id           BIGINT NOT NULL COMMENT '테넌트 ID',
    buyer_company_id    BIGINT NOT NULL COMMENT '구매업체 ID (채무자)',
    seller_company_id   BIGINT NOT NULL COMMENT '판매업체 ID (채권자)',
    txn_type            ENUM('ORDER_USE','PAYMENT_RECEIPT','ADJUST','REFUND') NOT NULL COMMENT '거래 유형',
    amount              DECIMAL(18,2) NOT NULL COMMENT '금액 (ORDER_USE=양수 채권발생, PAYMENT_RECEIPT=음수 채권감소)',
    balance_after       DECIMAL(18,2) NOT NULL COMMENT '거래 후 채권 잔액',
    ref_order_id        BIGINT NULL COMMENT '참조 주문 ID',
    ref_payment_id      BIGINT NULL COMMENT '참조 외부결제 거래 ID',
    txn_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '거래일시',
    created_by          BIGINT NULL COMMENT '생성 사용자 ID',
    memo                VARCHAR(500) NULL COMMENT '메모',
    PRIMARY KEY (receivable_id),
    KEY idx_tb_receivable_ledger_01 (tenant_id, buyer_company_id, seller_company_id),
    KEY idx_tb_receivable_ledger_02 (txn_type),
    KEY idx_tb_receivable_ledger_03 (ref_order_id),
    KEY idx_tb_receivable_ledger_04 (ref_payment_id),
    KEY idx_tb_receivable_ledger_05 (txn_at),
    CONSTRAINT fk_tb_receivable_ledger_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_receivable_ledger_02
        FOREIGN KEY (buyer_company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_receivable_ledger_03
        FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tb_receivable_ledger_04
        FOREIGN KEY (ref_order_id) REFERENCES tb_order (order_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_tb_receivable_ledger_05
        FOREIGN KEY (ref_payment_id) REFERENCES tb_external_payment_txn (payment_txn_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_tb_receivable_ledger_06
        FOREIGN KEY (created_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='매출채권 원장 (여신 사용 주문의 채권 발생 및 회수)';

-- =========================================================
-- 권한 초기 데이터 (tb_permission + tb_role_permission)
-- =========================================================

-- 권한 마스터 INSERT
INSERT INTO tb_permission (permission_code, permission_name, domain) VALUES
-- PRODUCT 도메인
('PRODUCT_CREATE',                'PRODUCT',       '상품 생성'),
('PRODUCT_EDIT',                  'PRODUCT',       '상품 수정'),
('PRODUCT_TAX_EDIT',              'PRODUCT',       '상품 세금구분 변경 요청'),
('PRODUCT_TAX_APPROVE',           'PRODUCT',       '상품 세금구분 변경 승인'),
('PRODUCT_RELATION_EDIT',         'PRODUCT',       '상품 연관관계 변경'),
('STOCK_ADJUST',                  'PRODUCT',       '재고 조정'),
('PROCESS_BATCH_CREATE',          'PRODUCT',       '가공 배치 생성'),
-- ORDER 도메인
('ORDER_VIEW',                    'ORDER',         '주문 조회'),
('ORDER_CREATE',                  'ORDER',         '주문 생성'),
('ORDER_CANCEL',                  'ORDER',         '주문 취소 요청'),
('ORDER_CANCEL_APPROVE',          'ORDER',         '주문 취소 승인'),
('TAX_DOCUMENT_VIEW',             'ORDER',         '세금 문서 조회'),
('TAX_DOCUMENT_ISSUE',            'ORDER',         '세금계산서 발행'),
('TAX_DOCUMENT_REISSUE_REQUEST',  'ORDER',         '세금계산서 재발행 요청'),
('TAX_DOCUMENT_REISSUE_APPROVE',  'ORDER',         '세금계산서 재발행 승인'),
-- FINANCE 도메인
('CREDIT_LIMIT_EDIT',             'FINANCE',       '여신한도 변경 요청'),
('CREDIT_LIMIT_APPROVE',          'FINANCE',       '여신한도 변경 승인'),
('ADVANCE_DEPOSIT_CONFIRM',       'FINANCE',       '선급금 입금 확인'),
('ADVANCE_ADJUST',                'FINANCE',       '선급금 조정'),
('REFUND_APPROVE',                'FINANCE',       '환불 승인'),
('BANK_ACCOUNT_EDIT',             'FINANCE',       '계좌정보 변경 요청'),
('BANK_ACCOUNT_APPROVE',          'FINANCE',       '계좌정보 변경 승인'),
-- USER 도메인
('USER_CREATE',                   'USER',          '사용자 생성'),
('USER_PERMISSION_OVERRIDE',      'USER',          '사용자 권한 개별 오버라이드'),
-- AUDIT 도메인
('AUDIT_LOG_VIEW',                'AUDIT',         '전체 감사로그 조회'),
('AUDIT_LOG_VIEW_OWN',            'AUDIT',         '자기 테넌트 감사로그 조회');

-- 역할별 기본 권한 매핑
-- SUPER_ADMIN — 전체 권한
INSERT INTO tb_role_permission (user_role, permission_id, granted)
SELECT 'SUPER_ADMIN', permission_id, 'Y'
FROM tb_permission;

-- SELLER_ADMIN 권한
INSERT INTO tb_role_permission (user_role, permission_id, granted)
SELECT 'SELLER_ADMIN', permission_id, 'Y'
FROM tb_permission
WHERE permission_code IN (
    'PRODUCT_CREATE','PRODUCT_EDIT','PRODUCT_TAX_EDIT','PRODUCT_RELATION_EDIT',
    'STOCK_ADJUST','PROCESS_BATCH_CREATE',
    'ORDER_VIEW','ORDER_CREATE','ORDER_CANCEL_APPROVE',
    'TAX_DOCUMENT_VIEW','TAX_DOCUMENT_ISSUE','TAX_DOCUMENT_REISSUE_REQUEST',
    'CREDIT_LIMIT_EDIT','CREDIT_LIMIT_APPROVE',
    'ADVANCE_DEPOSIT_CONFIRM',
    'REFUND_APPROVE',
    'BANK_ACCOUNT_EDIT',
    'USER_CREATE',
    'AUDIT_LOG_VIEW_OWN'
);

-- CHANNEL_ADMIN 권한
INSERT INTO tb_role_permission (user_role, permission_id, granted)
SELECT 'CHANNEL_ADMIN', permission_id, 'Y'
FROM tb_permission
WHERE permission_code IN (
    'ORDER_VIEW','ORDER_CREATE','ORDER_CANCEL',
    'TAX_DOCUMENT_VIEW'
);

-- BUYER_ADMIN 권한
INSERT INTO tb_role_permission (user_role, permission_id, granted)
SELECT 'BUYER_ADMIN', permission_id, 'Y'
FROM tb_permission
WHERE permission_code IN (
    'ORDER_VIEW','ORDER_CREATE','ORDER_CANCEL',
    'TAX_DOCUMENT_VIEW'
);

SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================
-- 실행 순서 안내
-- =========================================================
-- 1. USER_MANAGER_SQL_FINAL.sql  → 도메인 1 기본 테이블 생성
-- 2. MATPAM_MANAGER_DDL.sql      → 도메인 1 확장 + 도메인 2/3 생성
--
-- DROP 순서 (참조 역순):
--   tb_receivable_ledger → tb_payment_allocation → tb_buyer_advance_ledger
--   → tb_buyer_credit_limit_history → tb_buyer_credit_policy
--   → tb_external_payment_txn
--   → tb_shipment_line → tb_stock_ledger → tb_process_batch
--   → tb_tax_document → tb_order_line → tb_order
--   → tb_product_relation → (tb_product.tax_rule_version_id FK 먼저 DROP)
--   → tb_product_tax_rule → tb_product
--   → tb_user_permission_override → tb_role_permission
--   → tb_approval_request → tb_permission
-- =========================================================
