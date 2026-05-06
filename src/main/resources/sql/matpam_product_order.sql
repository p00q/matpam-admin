-- =============================================================================
-- MATPAM B2B 플랫폼 — 상품/세금/주문/재고/가공 도메인 DDL
-- 작성일: 2026-05-01
-- 참조: MATPAM_MANAGER.md §1~§4
-- 대상 DB: MariaDB 10.5+
-- =============================================================================
-- ⚠️ 실행 전 확인 사항:
--   1) MariaDB 버전: SELECT VERSION();  →  10.3.10 이상 권장 (CHECK 제약 강제 적용)
--   2) tb_tenant, tb_company, tb_channel, tb_user 가 먼저 생성되어 있어야 함
--   3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci 확인
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. tb_product — 상품 마스터
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_product (
    product_id          BIGINT          NOT NULL AUTO_INCREMENT   COMMENT '상품 ID',
    tenant_id           BIGINT          NOT NULL                  COMMENT '테넌트 ID',
    seller_company_id   BIGINT          NOT NULL                  COMMENT '판매업체 ID',
    product_code        VARCHAR(100)    NOT NULL                  COMMENT '상품코드 (업체 내 고유)',
    product_name        VARCHAR(300)    NOT NULL                  COMMENT '상품명',
    item_kind           ENUM('GOODS','SERVICE')
                                        NOT NULL                  COMMENT '상품종류: GOODS=실물, SERVICE=용역',
    processing_type     ENUM('RAW','PROCESSED','PROCESS_SERVICE')
                                        NOT NULL                  COMMENT '가공유형: RAW=원재료, PROCESSED=가공품, PROCESS_SERVICE=가공서비스',
    tax_category        ENUM('EXEMPT','TAXABLE')
                                        NOT NULL                  COMMENT '과세구분 (현재 유효값)',
    tax_rule_version_id BIGINT          NULL                      COMMENT '현재 적용 세금규칙 버전 ID',
    independent_sale_yn CHAR(1)         NOT NULL DEFAULT 'Y'      COMMENT '단독 판매 가능 여부 (N=세트 전용)',
    status              ENUM('ACTIVE','INACTIVE','DISCONTINUED')
                                        NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    created_by          BIGINT          NOT NULL                  COMMENT '등록자 user_id',
    created_at          DATETIME        NOT NULL DEFAULT NOW()     COMMENT '생성일시',
    updated_at          DATETIME        NOT NULL DEFAULT NOW()
                                        ON UPDATE NOW()           COMMENT '수정일시',

    PRIMARY KEY (product_id),

    CONSTRAINT uq_tb_product_code
        UNIQUE (tenant_id, seller_company_id, product_code),

    -- SERVICE 타입은 반드시 PROCESS_SERVICE
    CONSTRAINT chk_tb_product_service_type CHECK (
        (item_kind = 'SERVICE' AND processing_type = 'PROCESS_SERVICE')
        OR item_kind = 'GOODS'
    ),
    -- independent_sale_yn 값 제한
    CONSTRAINT chk_tb_product_sale_yn CHECK (
        independent_sale_yn IN ('Y', 'N')
    ),

    CONSTRAINT fk_tb_product_tenant
        FOREIGN KEY (tenant_id)          REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_product_seller
        FOREIGN KEY (seller_company_id)  REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_product_creator
        FOREIGN KEY (created_by)         REFERENCES tb_user (user_id)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='상품 마스터';

CREATE INDEX idx_tb_product_tenant_seller ON tb_product (tenant_id, seller_company_id);
CREATE INDEX idx_tb_product_status       ON tb_product (status);
CREATE INDEX idx_tb_product_item_kind    ON tb_product (item_kind, processing_type);

-- -----------------------------------------------------------------------------
-- 2. tb_product_tax_rule — 상품 세금규칙 이력 (버전 관리)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_product_tax_rule (
    tax_rule_version_id BIGINT          NOT NULL AUTO_INCREMENT   COMMENT '세금규칙 버전 ID',
    product_id          BIGINT          NOT NULL                  COMMENT '상품 ID',
    tax_category        ENUM('EXEMPT','TAXABLE')
                                        NOT NULL                  COMMENT '과세구분',
    legal_basis_memo    VARCHAR(500)    NULL                      COMMENT '법적 근거 메모',
    effective_from      DATE            NOT NULL                  COMMENT '적용 시작일',
    effective_to        DATE            NULL                      COMMENT '적용 종료일 (NULL=현재 유효)',
    approved_by         BIGINT          NULL                      COMMENT '승인자 user_id',
    approved_at         DATETIME        NULL                      COMMENT '승인일시',
    created_by          BIGINT          NOT NULL                  COMMENT '작성자 user_id',
    created_at          DATETIME        NOT NULL DEFAULT NOW()     COMMENT '생성일시',

    PRIMARY KEY (tax_rule_version_id),

    CONSTRAINT fk_tb_ptr_product
        FOREIGN KEY (product_id)   REFERENCES tb_product (product_id),
    CONSTRAINT fk_tb_ptr_approver
        FOREIGN KEY (approved_by)  REFERENCES tb_user (user_id),
    CONSTRAINT fk_tb_ptr_creator
        FOREIGN KEY (created_by)   REFERENCES tb_user (user_id)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='상품 세금규칙 버전 이력';

-- 현재 유효 규칙 조회용 인덱스 (product_id + effective_to IS NULL)
CREATE INDEX idx_tb_ptr_product_current ON tb_product_tax_rule (product_id, effective_to);

-- 세금규칙 생성 후 tb_product.tax_rule_version_id FK 추가
ALTER TABLE tb_product
    ADD CONSTRAINT fk_tb_product_tax_rule
        FOREIGN KEY (tax_rule_version_id) REFERENCES tb_product_tax_rule (tax_rule_version_id);

-- -----------------------------------------------------------------------------
-- 3. tb_product_relation — 상품 연관 관계
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_product_relation (
    relation_id         BIGINT          NOT NULL AUTO_INCREMENT   COMMENT '연관관계 ID',
    base_product_id     BIGINT          NOT NULL                  COMMENT '기준 상품 ID',
    related_product_id  BIGINT          NOT NULL                  COMMENT '연관 상품 ID',
    relation_kind       ENUM('RAW_TO_PROCESSED','RAW_TO_PROCESS_SERVICE','PROCESSED_TO_RAW')
                                        NOT NULL                  COMMENT '관계 유형',
    bundle_mode         ENUM('RECOMMENDED','OPTIONAL','REQUIRED')
                                        NOT NULL DEFAULT 'RECOMMENDED'
                                                                  COMMENT '세트 모드',
    display_order       INT             NOT NULL DEFAULT 0        COMMENT '표시 순서',
    effective_from      DATE            NOT NULL                  COMMENT '유효 시작일',
    effective_to        DATE            NULL                      COMMENT '유효 종료일 (NULL=현재 유효)',
    status              ENUM('ACTIVE','INACTIVE')
                                        NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    created_by          BIGINT          NOT NULL                  COMMENT '작성자 user_id',
    created_at          DATETIME        NOT NULL DEFAULT NOW()     COMMENT '생성일시',
    updated_at          DATETIME        NOT NULL DEFAULT NOW()
                                        ON UPDATE NOW()           COMMENT '수정일시',

    PRIMARY KEY (relation_id),

    -- 동일 기준-연관 상품 쌍은 중복 불가
    CONSTRAINT uq_tb_pr_pair
        UNIQUE (base_product_id, related_product_id),

    -- 자기 참조 금지
    CONSTRAINT chk_tb_pr_no_self_ref CHECK (
        base_product_id <> related_product_id
    ),

    CONSTRAINT fk_tb_pr_base
        FOREIGN KEY (base_product_id)    REFERENCES tb_product (product_id),
    CONSTRAINT fk_tb_pr_related
        FOREIGN KEY (related_product_id) REFERENCES tb_product (product_id),
    CONSTRAINT fk_tb_pr_creator
        FOREIGN KEY (created_by)         REFERENCES tb_user (user_id)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='상품 연관 관계';

CREATE INDEX idx_tb_pr_base    ON tb_product_relation (base_product_id, status);
CREATE INDEX idx_tb_pr_related ON tb_product_relation (related_product_id);

-- -----------------------------------------------------------------------------
-- 4. tb_order — 주문 헤더
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_order (
    order_id            BIGINT          NOT NULL AUTO_INCREMENT   COMMENT '주문 ID',
    order_no            VARCHAR(50)     NOT NULL                  COMMENT '주문번호 (사용자 표시용)',
    tenant_id           BIGINT          NOT NULL                  COMMENT '테넌트 ID',
    seller_company_id   BIGINT          NOT NULL                  COMMENT '판매업체 ID',
    buyer_company_id    BIGINT          NOT NULL                  COMMENT '구매업체 ID',
    channel_id          BIGINT          NOT NULL                  COMMENT '채널 ID',
    ordered_by          BIGINT          NOT NULL                  COMMENT '주문자 user_id',
    order_status        ENUM('DRAFT','CONFIRMED','PROCESSING','SHIPPED','DELIVERED','CANCELLED','PARTIAL_CANCEL')
                                        NOT NULL DEFAULT 'DRAFT'  COMMENT '주문상태',
    total_supply_amount DECIMAL(18,2)   NOT NULL DEFAULT 0        COMMENT '공급가액 합계',
    total_vat_amount    DECIMAL(18,2)   NOT NULL DEFAULT 0        COMMENT '세액 합계',
    total_amount        DECIMAL(18,2)   NOT NULL DEFAULT 0        COMMENT '총 금액 합계',
    order_memo          TEXT            NULL                      COMMENT '주문 메모',
    ordered_at          DATETIME        NOT NULL                  COMMENT '주문일시',
    confirmed_at        DATETIME        NULL                      COMMENT '확정일시',
    created_at          DATETIME        NOT NULL DEFAULT NOW()     COMMENT '생성일시',
    updated_at          DATETIME        NOT NULL DEFAULT NOW()
                                        ON UPDATE NOW()           COMMENT '수정일시',

    PRIMARY KEY (order_id),

    CONSTRAINT uq_tb_order_no UNIQUE (order_no),

    CONSTRAINT fk_tb_order_tenant
        FOREIGN KEY (tenant_id)         REFERENCES tb_tenant  (tenant_id),
    CONSTRAINT fk_tb_order_seller
        FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_order_buyer
        FOREIGN KEY (buyer_company_id)  REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_order_channel
        FOREIGN KEY (channel_id)        REFERENCES tb_channel (channel_id),
    CONSTRAINT fk_tb_order_user
        FOREIGN KEY (ordered_by)        REFERENCES tb_user    (user_id)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='주문 헤더';

CREATE INDEX idx_tb_order_tenant_status  ON tb_order (tenant_id, order_status);
CREATE INDEX idx_tb_order_buyer          ON tb_order (buyer_company_id, ordered_at DESC);
CREATE INDEX idx_tb_order_seller         ON tb_order (seller_company_id, ordered_at DESC);

-- -----------------------------------------------------------------------------
-- 5. tb_order_line — 주문 라인 (세금 snapshot 핵심)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_order_line (
    line_id                 BIGINT          NOT NULL AUTO_INCREMENT   COMMENT '라인 ID',
    order_id                BIGINT          NOT NULL                  COMMENT '주문 ID',
    product_id              BIGINT          NULL                      COMMENT '상품 ID (삭제 시 NULL 허용)',
    -- ── snapshot 컬럼 (주문 시점 고정, 이후 변경 금지) ──────────────────────
    item_kind               ENUM('GOODS','SERVICE')
                                            NOT NULL                  COMMENT '상품종류 snapshot',
    processing_type         ENUM('RAW','PROCESSED','PROCESS_SERVICE')
                                            NOT NULL                  COMMENT '가공유형 snapshot',
    product_name_snapshot   VARCHAR(300)    NOT NULL                  COMMENT '주문 시점 상품명',
    tax_category_snapshot   ENUM('EXEMPT','TAXABLE')
                                            NOT NULL                  COMMENT '주문 시점 과세구분 ★불변',
    tax_rule_version_id     BIGINT          NULL                      COMMENT '적용된 세금규칙 버전',
    legal_basis_snapshot    VARCHAR(500)    NULL                      COMMENT '주문 시점 법적 근거 메모',
    unit_price              DECIMAL(18,4)   NOT NULL                  COMMENT '단가 snapshot',
    -- ── 계산 컬럼 ───────────────────────────────────────────────────────────
    qty                     DECIMAL(18,4)   NOT NULL                  COMMENT '수량',
    supply_amount           DECIMAL(18,2)   NOT NULL                  COMMENT '공급가액 (단가×수량)',
    vat_amount              DECIMAL(18,2)   NOT NULL DEFAULT 0        COMMENT '세액 (EXEMPT=0)',
    total_amount            DECIMAL(18,2)   NOT NULL                  COMMENT '합계',
    -- ── 연관 세트 그룹 ───────────────────────────────────────────────────────
    relation_group_id       VARCHAR(50)     NULL                      COMMENT '연관 세트 그룹 ID (세트 주문 시 동일값)',
    line_status             ENUM('ACTIVE','CANCELLED')
                                            NOT NULL DEFAULT 'ACTIVE' COMMENT '라인 상태',
    created_at              DATETIME        NOT NULL DEFAULT NOW()     COMMENT '생성일시',

    PRIMARY KEY (line_id),

    CONSTRAINT chk_tb_ol_amounts CHECK (
        supply_amount >= 0 AND vat_amount >= 0 AND total_amount >= 0
    ),

    CONSTRAINT fk_tb_ol_order
        FOREIGN KEY (order_id)              REFERENCES tb_order           (order_id),
    CONSTRAINT fk_tb_ol_product
        FOREIGN KEY (product_id)            REFERENCES tb_product         (product_id),
    CONSTRAINT fk_tb_ol_tax_rule
        FOREIGN KEY (tax_rule_version_id)   REFERENCES tb_product_tax_rule(tax_rule_version_id)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='주문 라인 (세금 snapshot 포함)';

CREATE INDEX idx_tb_ol_order      ON tb_order_line (order_id);
CREATE INDEX idx_tb_ol_product    ON tb_order_line (product_id);
CREATE INDEX idx_tb_ol_tax_cat    ON tb_order_line (tax_category_snapshot);

-- -----------------------------------------------------------------------------
-- 6. tb_tax_document — 세금/계산서 문서
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_tax_document (
    document_id     BIGINT          NOT NULL AUTO_INCREMENT   COMMENT '문서 ID',
    order_id        BIGINT          NOT NULL                  COMMENT '주문 ID',
    document_type   ENUM('TAX_INVOICE','INVOICE','STATEMENT')
                                    NOT NULL                  COMMENT '문서유형: TAX_INVOICE=세금계산서, INVOICE=계산서, STATEMENT=거래명세서',
    tax_category    ENUM('EXEMPT','TAXABLE')
                                    NOT NULL                  COMMENT '과세구분',
    supply_amount   DECIMAL(18,2)   NOT NULL                  COMMENT '공급가액',
    vat_amount      DECIMAL(18,2)   NOT NULL DEFAULT 0        COMMENT '세액',
    total_amount    DECIMAL(18,2)   NOT NULL                  COMMENT '합계',
    issue_status    ENUM('DRAFT','ISSUED','CANCELLED','REISSUED')
                                    NOT NULL DEFAULT 'DRAFT'  COMMENT '발행상태',
    issued_at       DATETIME        NULL                      COMMENT '발행일시',
    cancelled_at    DATETIME        NULL                      COMMENT '취소일시',
    issued_by       BIGINT          NULL                      COMMENT '발행자 user_id',
    created_at      DATETIME        NOT NULL DEFAULT NOW()     COMMENT '생성일시',
    updated_at      DATETIME        NOT NULL DEFAULT NOW()
                                    ON UPDATE NOW()           COMMENT '수정일시',

    PRIMARY KEY (document_id),

    -- 과세(TAXABLE) → TAX_INVOICE만 허용
    CONSTRAINT chk_tb_td_taxable CHECK (
        (tax_category = 'TAXABLE'  AND document_type = 'TAX_INVOICE')
        OR (tax_category = 'EXEMPT')
    ),

    CONSTRAINT fk_tb_td_order
        FOREIGN KEY (order_id)    REFERENCES tb_order (order_id),
    CONSTRAINT fk_tb_td_issuer
        FOREIGN KEY (issued_by)   REFERENCES tb_user  (user_id)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='세금/계산서 문서';

CREATE INDEX idx_tb_td_order      ON tb_tax_document (order_id, tax_category);
CREATE INDEX idx_tb_td_status     ON tb_tax_document (issue_status);

-- -----------------------------------------------------------------------------
-- 7. tb_shipment_line — 출고 라인
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_shipment_line (
    shipment_line_id    BIGINT          NOT NULL AUTO_INCREMENT   COMMENT '출고라인 ID',
    order_id            BIGINT          NOT NULL                  COMMENT '주문 ID',
    line_id             BIGINT          NOT NULL                  COMMENT '주문라인 ID',
    product_id          BIGINT          NOT NULL                  COMMENT '상품 ID',
    lot_id              VARCHAR(100)    NULL                      COMMENT '로트 번호',
    qty                 DECIMAL(18,4)   NOT NULL                  COMMENT '출고 수량',
    shipment_status     ENUM('PENDING','PICKING','SHIPPED','DELIVERED','RETURNED')
                                        NOT NULL DEFAULT 'PENDING'COMMENT '출고 상태',
    shipped_at          DATETIME        NULL                      COMMENT '출고일시',
    delivered_at        DATETIME        NULL                      COMMENT '배달완료일시',
    created_at          DATETIME        NOT NULL DEFAULT NOW()     COMMENT '생성일시',
    updated_at          DATETIME        NOT NULL DEFAULT NOW()
                                        ON UPDATE NOW()           COMMENT '수정일시',

    PRIMARY KEY (shipment_line_id),

    CONSTRAINT fk_tb_sl_order
        FOREIGN KEY (order_id)   REFERENCES tb_order      (order_id),
    CONSTRAINT fk_tb_sl_line
        FOREIGN KEY (line_id)    REFERENCES tb_order_line (line_id),
    CONSTRAINT fk_tb_sl_product
        FOREIGN KEY (product_id) REFERENCES tb_product    (product_id)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='출고 라인';

CREATE INDEX idx_tb_sl_order   ON tb_shipment_line (order_id);
CREATE INDEX idx_tb_sl_status  ON tb_shipment_line (shipment_status);

-- -----------------------------------------------------------------------------
-- 8. tb_process_batch — 가공 배치
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_process_batch (
    process_batch_id    BIGINT          NOT NULL AUTO_INCREMENT   COMMENT '가공배치 ID',
    tenant_id           BIGINT          NOT NULL                  COMMENT '테넌트 ID',
    seller_company_id   BIGINT          NOT NULL                  COMMENT '판매업체 ID',
    source_product_id   BIGINT          NOT NULL                  COMMENT '원재료 상품 ID',
    target_product_id   BIGINT          NOT NULL                  COMMENT '완제품 상품 ID',
    input_qty           DECIMAL(18,4)   NOT NULL                  COMMENT '투입 수량',
    output_qty          DECIMAL(18,4)   NOT NULL                  COMMENT '산출 수량',
    loss_qty            DECIMAL(18,4)   NOT NULL DEFAULT 0        COMMENT '손실 수량',
    batch_status        ENUM('PLANNED','IN_PROGRESS','COMPLETED','CANCELLED')
                                        NOT NULL DEFAULT 'PLANNED'COMMENT '배치 상태',
    processed_at        DATETIME        NULL                      COMMENT '가공 완료 일시',
    processed_by        BIGINT          NULL                      COMMENT '처리자 user_id',
    created_by          BIGINT          NOT NULL                  COMMENT '등록자 user_id',
    created_at          DATETIME        NOT NULL DEFAULT NOW()     COMMENT '생성일시',
    updated_at          DATETIME        NOT NULL DEFAULT NOW()
                                        ON UPDATE NOW()           COMMENT '수정일시',

    PRIMARY KEY (process_batch_id),

    -- 투입 수량 > 0, 손실 수량 >= 0
    CONSTRAINT chk_tb_pb_qty CHECK (
        input_qty > 0 AND output_qty >= 0 AND loss_qty >= 0
        AND (input_qty >= output_qty + loss_qty)
    ),
    -- 원재료와 완제품은 달라야 함
    CONSTRAINT chk_tb_pb_diff_product CHECK (
        source_product_id <> target_product_id
    ),

    CONSTRAINT fk_tb_pb_tenant
        FOREIGN KEY (tenant_id)         REFERENCES tb_tenant  (tenant_id),
    CONSTRAINT fk_tb_pb_seller
        FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_pb_source
        FOREIGN KEY (source_product_id) REFERENCES tb_product (product_id),
    CONSTRAINT fk_tb_pb_target
        FOREIGN KEY (target_product_id) REFERENCES tb_product (product_id),
    CONSTRAINT fk_tb_pb_processor
        FOREIGN KEY (processed_by)      REFERENCES tb_user    (user_id),
    CONSTRAINT fk_tb_pb_creator
        FOREIGN KEY (created_by)        REFERENCES tb_user    (user_id)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='가공 배치 (원재료→완제품 변환 추적)';

CREATE INDEX idx_tb_pb_tenant_seller ON tb_process_batch (tenant_id, seller_company_id);
CREATE INDEX idx_tb_pb_status        ON tb_process_batch (batch_status);

-- -----------------------------------------------------------------------------
-- 9. tb_stock_ledger — 재고 원장
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_stock_ledger (
    stock_txn_id        BIGINT          NOT NULL AUTO_INCREMENT   COMMENT '재고거래 ID',
    tenant_id           BIGINT          NOT NULL                  COMMENT '테넌트 ID',
    seller_company_id   BIGINT          NOT NULL                  COMMENT '판매업체 ID',
    product_id          BIGINT          NOT NULL                  COMMENT '상품 ID',
    lot_id              VARCHAR(100)    NULL                      COMMENT '로트 번호',
    txn_type            ENUM('IN','OUT','ADJUST','CONSUME','PRODUCE')
                                        NOT NULL                  COMMENT '거래 유형',
    qty                 DECIMAL(18,4)   NOT NULL                  COMMENT '수량 (양수=증가, 음수=감소)',
    balance_after       DECIMAL(18,4)   NOT NULL                  COMMENT '거래 후 잔고',
    ref_table           VARCHAR(100)    NULL                      COMMENT '참조 테이블명',
    ref_id              BIGINT          NULL                      COMMENT '참조 ID',
    txn_memo            VARCHAR(500)    NULL                      COMMENT '거래 메모',
    txn_at              DATETIME        NOT NULL                  COMMENT '거래 일시',
    created_by          BIGINT          NULL                      COMMENT '작성자 user_id',
    created_at          DATETIME        NOT NULL DEFAULT NOW()     COMMENT '생성일시',

    PRIMARY KEY (stock_txn_id),

    CONSTRAINT fk_tb_stk_tenant
        FOREIGN KEY (tenant_id)         REFERENCES tb_tenant  (tenant_id),
    CONSTRAINT fk_tb_stk_seller
        FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_stk_product
        FOREIGN KEY (product_id)        REFERENCES tb_product (product_id),
    CONSTRAINT fk_tb_stk_creator
        FOREIGN KEY (created_by)        REFERENCES tb_user    (user_id)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='재고 원장 (입출고·조정·가공 전체 기록)';

CREATE INDEX idx_tb_stk_product     ON tb_stock_ledger (product_id, txn_at DESC);
CREATE INDEX idx_tb_stk_lot         ON tb_stock_ledger (lot_id);
CREATE INDEX idx_tb_stk_ref         ON tb_stock_ledger (ref_table, ref_id);
CREATE INDEX idx_tb_stk_seller_date ON tb_stock_ledger (seller_company_id, txn_at DESC);

-- =============================================================================
-- END OF matpam_product_order.sql
-- =============================================================================
