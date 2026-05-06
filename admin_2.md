-- ======================================================================
-- FILE : PRODUCT_ORDER_FINANCE_SQL_DRAFT.sql
-- DESC : MATPAM B2B 폐쇄 플랫폼
--        상품 / 주문 / 출고 / 재고 / 정산 / 여신·입금 DDL 초안
-- DB   : MariaDB 10.3.10+ 권장
-- NOTE :
--   1) 본 스크립트는 USER_MANAGER_SQL_FINAL.sql 적용 이후 실행 전제
--   2) 기존 테이블 의존:
--      - tb_tenant
--      - tb_channel
--      - tb_company
--      - tb_company_bank_account
--      - tb_user
--   3) CHECK 제약은 MariaDB 10.3.10+ 실제 강제
-- ======================================================================

SET NAMES utf8mb4;

-- ======================================================================
-- 1. 상품 마스터
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_product (
    product_id           BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id            BIGINT NOT NULL,
    seller_company_id    BIGINT NOT NULL,
    product_code         VARCHAR(50) NOT NULL,
    product_name         VARCHAR(200) NOT NULL,
    item_kind            ENUM('GOODS','SERVICE') NOT NULL,
    processing_type      ENUM('RAW_GOODS','PROCESSED_GOODS','PROCESS_SERVICE') NOT NULL,
    tax_category         ENUM('TAX_FREE','TAXABLE') NOT NULL,
    unit_name            VARCHAR(30) NOT NULL,
    independent_sale_yn  CHAR(1) NOT NULL DEFAULT 'Y',
    stock_managed_yn     CHAR(1) NOT NULL,
    sale_status          ENUM('ON_SALE','STOPPED','HIDDEN') NOT NULL DEFAULT 'ON_SALE',
    description          TEXT NULL,
    image_url            VARCHAR(500) NULL,
    created_by           BIGINT NULL,
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (product_id),
    UNIQUE KEY uq_tb_product_01 (tenant_id, product_code),
    KEY idx_tb_product_01 (tenant_id, seller_company_id, sale_status),
    KEY idx_tb_product_02 (tenant_id, processing_type, tax_category),
    KEY idx_tb_product_03 (seller_company_id),
    CONSTRAINT fk_tb_product_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_product_02 FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_product_03 FOREIGN KEY (created_by) REFERENCES tb_user (user_id),
    CONSTRAINT chk_tb_product_01 CHECK (independent_sale_yn IN ('Y','N')),
    CONSTRAINT chk_tb_product_02 CHECK (stock_managed_yn IN ('Y','N')),
    CONSTRAINT chk_tb_product_03 CHECK (
        (processing_type = 'PROCESS_SERVICE' AND item_kind = 'SERVICE' AND stock_managed_yn = 'N')
        OR
        (processing_type IN ('RAW_GOODS','PROCESSED_GOODS') AND item_kind = 'GOODS' AND stock_managed_yn = 'Y')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='상품 마스터';

-- ======================================================================
-- 2. 상품 세금 규칙 버전
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_product_tax_rule (
    tax_rule_id         BIGINT NOT NULL AUTO_INCREMENT,
    product_id          BIGINT NOT NULL,
    rule_version        INT NOT NULL,
    tax_category        ENUM('TAX_FREE','TAXABLE') NOT NULL,
    legal_basis_memo    VARCHAR(1000) NOT NULL,
    effective_from      DATETIME NOT NULL,
    effective_to        DATETIME NULL,
    approval_status     ENUM('DRAFT','APPROVED','REJECTED') NOT NULL DEFAULT 'DRAFT',
    requested_by        BIGINT NULL,
    approved_by         BIGINT NULL,
    approved_at         DATETIME NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (tax_rule_id),
    UNIQUE KEY uq_tb_product_tax_rule_01 (product_id, rule_version),
    KEY idx_tb_product_tax_rule_01 (product_id, approval_status, effective_from),
    KEY idx_tb_product_tax_rule_02 (approved_by),
    CONSTRAINT fk_tb_product_tax_rule_01 FOREIGN KEY (product_id) REFERENCES tb_product (product_id),
    CONSTRAINT fk_tb_product_tax_rule_02 FOREIGN KEY (requested_by) REFERENCES tb_user (user_id),
    CONSTRAINT fk_tb_product_tax_rule_03 FOREIGN KEY (approved_by) REFERENCES tb_user (user_id),
    CONSTRAINT chk_tb_product_tax_rule_01 CHECK (rule_version >= 1),
    CONSTRAINT chk_tb_product_tax_rule_02 CHECK (effective_to IS NULL OR effective_to > effective_from)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='상품 세금 규칙 버전';

-- ======================================================================
-- 3. 상품 연관/매칭 관계
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_product_relation (
    relation_id         BIGINT NOT NULL AUTO_INCREMENT,
    base_product_id     BIGINT NOT NULL,
    related_product_id  BIGINT NOT NULL,
    relation_kind       ENUM('RAW_TO_PROCESSED_GOODS','RAW_TO_PROCESS_SERVICE','PROCESSED_TO_RAW','SERVICE_TO_RAW') NOT NULL,
    bundle_mode         ENUM('RECOMMENDED','OPTIONAL','REQUIRED') NOT NULL DEFAULT 'RECOMMENDED',
    sort_order          INT NOT NULL DEFAULT 0,
    effective_from      DATETIME NOT NULL,
    effective_to        DATETIME NULL,
    status              ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    created_by          BIGINT NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (relation_id),
    UNIQUE KEY uq_tb_product_relation_01 (base_product_id, related_product_id, relation_kind, effective_from),
    KEY idx_tb_product_relation_01 (base_product_id, status, effective_from),
    KEY idx_tb_product_relation_02 (related_product_id),
    CONSTRAINT fk_tb_product_relation_01 FOREIGN KEY (base_product_id) REFERENCES tb_product (product_id),
    CONSTRAINT fk_tb_product_relation_02 FOREIGN KEY (related_product_id) REFERENCES tb_product (product_id),
    CONSTRAINT fk_tb_product_relation_03 FOREIGN KEY (created_by) REFERENCES tb_user (user_id),
    CONSTRAINT chk_tb_product_relation_01 CHECK (base_product_id <> related_product_id),
    CONSTRAINT chk_tb_product_relation_02 CHECK (effective_to IS NULL OR effective_to > effective_from)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='상품 연관/매칭 관계';

-- ======================================================================
-- 4. 상품 가격 정책
--    우선순위: 구매업체 개별가 > 채널가 > 테넌트 기본가
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_product_price (
    price_id            BIGINT NOT NULL AUTO_INCREMENT,
    product_id          BIGINT NOT NULL,
    tenant_id           BIGINT NOT NULL,
    channel_id          BIGINT NULL,
    buyer_company_id    BIGINT NULL,
    unit_price          DECIMAL(18,2) NOT NULL,
    currency_code       VARCHAR(10) NOT NULL DEFAULT 'KRW',
    effective_from      DATETIME NOT NULL,
    effective_to        DATETIME NULL,
    status              ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    approved_by         BIGINT NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (price_id),
    KEY idx_tb_product_price_01 (product_id, status, effective_from),
    KEY idx_tb_product_price_02 (tenant_id, channel_id),
    KEY idx_tb_product_price_03 (tenant_id, buyer_company_id),
    CONSTRAINT fk_tb_product_price_01 FOREIGN KEY (product_id) REFERENCES tb_product (product_id),
    CONSTRAINT fk_tb_product_price_02 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_product_price_03 FOREIGN KEY (channel_id) REFERENCES tb_channel (channel_id),
    CONSTRAINT fk_tb_product_price_04 FOREIGN KEY (buyer_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_product_price_05 FOREIGN KEY (approved_by) REFERENCES tb_user (user_id),
    CONSTRAINT chk_tb_product_price_01 CHECK (unit_price >= 0),
    CONSTRAINT chk_tb_product_price_02 CHECK (effective_to IS NULL OR effective_to > effective_from),
    CONSTRAINT chk_tb_product_price_03 CHECK (NOT (channel_id IS NOT NULL AND buyer_company_id IS NOT NULL))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='상품 가격 정책';

-- ======================================================================
-- 5. 원물↔가공 레시피/전환 규칙
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_product_process_recipe (
    recipe_id             BIGINT NOT NULL AUTO_INCREMENT,
    source_product_id     BIGINT NOT NULL,
    target_product_id     BIGINT NOT NULL,
    standard_input_qty    DECIMAL(18,3) NOT NULL,
    standard_output_qty   DECIMAL(18,3) NOT NULL,
    loss_rate             DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    memo                  VARCHAR(500) NULL,
    status                ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    PRIMARY KEY (recipe_id),
    UNIQUE KEY uq_tb_product_process_recipe_01 (source_product_id, target_product_id),
    KEY idx_tb_product_process_recipe_01 (target_product_id),
    CONSTRAINT fk_tb_product_process_recipe_01 FOREIGN KEY (source_product_id) REFERENCES tb_product (product_id),
    CONSTRAINT fk_tb_product_process_recipe_02 FOREIGN KEY (target_product_id) REFERENCES tb_product (product_id),
    CONSTRAINT chk_tb_product_process_recipe_01 CHECK (source_product_id <> target_product_id),
    CONSTRAINT chk_tb_product_process_recipe_02 CHECK (standard_input_qty > 0),
    CONSTRAINT chk_tb_product_process_recipe_03 CHECK (standard_output_qty > 0),
    CONSTRAINT chk_tb_product_process_recipe_04 CHECK (loss_rate >= 0 AND loss_rate <= 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='원물↔가공 레시피/전환 규칙';

-- ======================================================================
-- 6. 주문 헤더
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_order (
    order_id                   BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id                  BIGINT NOT NULL,
    seller_company_id          BIGINT NOT NULL,
    buyer_company_id           BIGINT NOT NULL,
    channel_id                 BIGINT NULL,
    order_no                   VARCHAR(50) NOT NULL,
    order_status               ENUM('DRAFT','PLACED','CONFIRMED','PARTIAL_SHIPPED','SHIPPED','COMPLETED','CANCELED') NOT NULL DEFAULT 'DRAFT',
    payment_status             ENUM('UNPAID','PARTIAL_ALLOCATED','ALLOCATED','REFUNDED') NOT NULL DEFAULT 'UNPAID',
    tax_free_supply_amount     DECIMAL(18,2) NOT NULL DEFAULT 0,
    taxable_supply_amount      DECIMAL(18,2) NOT NULL DEFAULT 0,
    vat_amount                 DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_amount               DECIMAL(18,2) NOT NULL DEFAULT 0,
    allocated_advance_amount   DECIMAL(18,2) NOT NULL DEFAULT 0,
    allocated_credit_amount    DECIMAL(18,2) NOT NULL DEFAULT 0,
    allocated_cash_amount      DECIMAL(18,2) NOT NULL DEFAULT 0,
    ordered_by_user_id         BIGINT NULL,
    ordered_at                 DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at                 DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                 DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (order_id),
    UNIQUE KEY uq_tb_order_01 (order_no),
    KEY idx_tb_order_01 (tenant_id, buyer_company_id, order_status),
    KEY idx_tb_order_02 (tenant_id, seller_company_id, payment_status),
    KEY idx_tb_order_03 (ordered_at),
    CONSTRAINT fk_tb_order_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_order_02 FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_order_03 FOREIGN KEY (buyer_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_order_04 FOREIGN KEY (channel_id) REFERENCES tb_channel (channel_id),
    CONSTRAINT fk_tb_order_05 FOREIGN KEY (ordered_by_user_id) REFERENCES tb_user (user_id),
    CONSTRAINT chk_tb_order_01 CHECK (tax_free_supply_amount >= 0),
    CONSTRAINT chk_tb_order_02 CHECK (taxable_supply_amount >= 0),
    CONSTRAINT chk_tb_order_03 CHECK (vat_amount >= 0),
    CONSTRAINT chk_tb_order_04 CHECK (total_amount >= 0),
    CONSTRAINT chk_tb_order_05 CHECK (allocated_advance_amount >= 0),
    CONSTRAINT chk_tb_order_06 CHECK (allocated_credit_amount >= 0),
    CONSTRAINT chk_tb_order_07 CHECK (allocated_cash_amount >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='주문 헤더';

-- ======================================================================
-- 7. 주문 상세 (세금 snapshot 핵심)
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_order_line (
    order_line_id               BIGINT NOT NULL AUTO_INCREMENT,
    order_id                    BIGINT NOT NULL,
    line_no                     INT NOT NULL,
    product_id                  BIGINT NOT NULL,
    relation_group_id           VARCHAR(50) NULL,
    product_name_snapshot       VARCHAR(200) NOT NULL,
    item_kind_snapshot          ENUM('GOODS','SERVICE') NOT NULL,
    processing_type_snapshot    ENUM('RAW_GOODS','PROCESSED_GOODS','PROCESS_SERVICE') NOT NULL,
    tax_category_snapshot       ENUM('TAX_FREE','TAXABLE') NOT NULL,
    tax_rule_id_snapshot        BIGINT NOT NULL,
    unit_name_snapshot          VARCHAR(30) NOT NULL,
    qty                         DECIMAL(18,3) NOT NULL,
    unit_price                  DECIMAL(18,2) NOT NULL,
    supply_amount               DECIMAL(18,2) NOT NULL,
    vat_amount                  DECIMAL(18,2) NOT NULL,
    total_amount                DECIMAL(18,2) NOT NULL,
    shipment_status             ENUM('WAITING','PARTIAL','DONE','NOT_APPLICABLE') NOT NULL DEFAULT 'WAITING',
    created_at                  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (order_line_id),
    UNIQUE KEY uq_tb_order_line_01 (order_id, line_no),
    KEY idx_tb_order_line_01 (product_id),
    KEY idx_tb_order_line_02 (relation_group_id),
    KEY idx_tb_order_line_03 (tax_category_snapshot),
    CONSTRAINT fk_tb_order_line_01 FOREIGN KEY (order_id) REFERENCES tb_order (order_id),
    CONSTRAINT fk_tb_order_line_02 FOREIGN KEY (product_id) REFERENCES tb_product (product_id),
    CONSTRAINT fk_tb_order_line_03 FOREIGN KEY (tax_rule_id_snapshot) REFERENCES tb_product_tax_rule (tax_rule_id),
    CONSTRAINT chk_tb_order_line_01 CHECK (line_no >= 1),
    CONSTRAINT chk_tb_order_line_02 CHECK (qty > 0),
    CONSTRAINT chk_tb_order_line_03 CHECK (unit_price >= 0),
    CONSTRAINT chk_tb_order_line_04 CHECK (supply_amount >= 0),
    CONSTRAINT chk_tb_order_line_05 CHECK (vat_amount >= 0),
    CONSTRAINT chk_tb_order_line_06 CHECK (total_amount >= 0),
    CONSTRAINT chk_tb_order_line_07 CHECK (
        (item_kind_snapshot = 'SERVICE' AND processing_type_snapshot = 'PROCESS_SERVICE')
        OR
        (item_kind_snapshot = 'GOODS' AND processing_type_snapshot IN ('RAW_GOODS','PROCESSED_GOODS'))
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='주문 상세';

-- ======================================================================
-- 8. 세금문서 / 계산서 발행 단위
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_tax_document (
    tax_document_id   BIGINT NOT NULL AUTO_INCREMENT,
    order_id          BIGINT NOT NULL,
    buyer_company_id  BIGINT NOT NULL,
    seller_company_id BIGINT NOT NULL,
    document_type     ENUM('TAX_INVOICE','INVOICE','STATEMENT') NOT NULL,
    tax_category      ENUM('TAX_FREE','TAXABLE') NOT NULL,
    document_no       VARCHAR(100) NULL,
    issue_status      ENUM('READY','ISSUED','FAILED','CANCELED') NOT NULL DEFAULT 'READY',
    supply_amount     DECIMAL(18,2) NOT NULL DEFAULT 0,
    vat_amount        DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_amount      DECIMAL(18,2) NOT NULL DEFAULT 0,
    issued_at         DATETIME NULL,
    created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (tax_document_id),
    UNIQUE KEY uq_tb_tax_document_01 (document_no),
    KEY idx_tb_tax_document_01 (order_id, tax_category),
    KEY idx_tb_tax_document_02 (buyer_company_id, seller_company_id),
    KEY idx_tb_tax_document_03 (issue_status),
    CONSTRAINT fk_tb_tax_document_01 FOREIGN KEY (order_id) REFERENCES tb_order (order_id),
    CONSTRAINT fk_tb_tax_document_02 FOREIGN KEY (buyer_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_tax_document_03 FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT chk_tb_tax_document_01 CHECK (supply_amount >= 0),
    CONSTRAINT chk_tb_tax_document_02 CHECK (vat_amount >= 0),
    CONSTRAINT chk_tb_tax_document_03 CHECK (total_amount >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='세금문서/계산서 발행 단위';

-- ======================================================================
-- 9. 출고 헤더
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_shipment (
    shipment_id        BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id          BIGINT NOT NULL,
    order_id           BIGINT NOT NULL,
    shipment_no        VARCHAR(50) NOT NULL,
    shipment_status    ENUM('READY','PARTIAL','DONE','CANCELED') NOT NULL DEFAULT 'READY',
    shipping_company   VARCHAR(100) NULL,
    tracking_no        VARCHAR(100) NULL,
    shipped_at         DATETIME NULL,
    created_by         BIGINT NULL,
    created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (shipment_id),
    UNIQUE KEY uq_tb_shipment_01 (shipment_no),
    KEY idx_tb_shipment_01 (order_id, shipment_status),
    KEY idx_tb_shipment_02 (tenant_id, shipped_at),
    CONSTRAINT fk_tb_shipment_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_shipment_02 FOREIGN KEY (order_id) REFERENCES tb_order (order_id),
    CONSTRAINT fk_tb_shipment_03 FOREIGN KEY (created_by) REFERENCES tb_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='출고 헤더';

-- ======================================================================
-- 10. 재고 LOT
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_stock_lot (
    lot_id              BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id           BIGINT NOT NULL,
    product_id          BIGINT NOT NULL,
    lot_no              VARCHAR(100) NOT NULL,
    manufacture_date    DATE NULL,
    expiry_date         DATE NULL,
    current_qty         DECIMAL(18,3) NOT NULL DEFAULT 0,
    status              ENUM('ACTIVE','CLOSED') NOT NULL DEFAULT 'ACTIVE',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (lot_id),
    UNIQUE KEY uq_tb_stock_lot_01 (tenant_id, lot_no),
    KEY idx_tb_stock_lot_01 (product_id, status),
    CONSTRAINT fk_tb_stock_lot_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_stock_lot_02 FOREIGN KEY (product_id) REFERENCES tb_product (product_id),
    CONSTRAINT chk_tb_stock_lot_01 CHECK (current_qty >= 0),
    CONSTRAINT chk_tb_stock_lot_02 CHECK (expiry_date IS NULL OR manufacture_date IS NULL OR expiry_date >= manufacture_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='재고 LOT';

-- ======================================================================
-- 11. 출고 상세
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_shipment_line (
    shipment_line_id    BIGINT NOT NULL AUTO_INCREMENT,
    shipment_id         BIGINT NOT NULL,
    order_line_id       BIGINT NOT NULL,
    product_id          BIGINT NOT NULL,
    lot_id              BIGINT NULL,
    shipped_qty         DECIMAL(18,3) NOT NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (shipment_line_id),
    KEY idx_tb_shipment_line_01 (shipment_id),
    KEY idx_tb_shipment_line_02 (order_line_id),
    KEY idx_tb_shipment_line_03 (product_id, lot_id),
    CONSTRAINT fk_tb_shipment_line_01 FOREIGN KEY (shipment_id) REFERENCES tb_shipment (shipment_id),
    CONSTRAINT fk_tb_shipment_line_02 FOREIGN KEY (order_line_id) REFERENCES tb_order_line (order_line_id),
    CONSTRAINT fk_tb_shipment_line_03 FOREIGN KEY (product_id) REFERENCES tb_product (product_id),
    CONSTRAINT fk_tb_shipment_line_04 FOREIGN KEY (lot_id) REFERENCES tb_stock_lot (lot_id),
    CONSTRAINT chk_tb_shipment_line_01 CHECK (shipped_qty > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='출고 상세';

-- ======================================================================
-- 12. 재고 원장
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_stock_ledger (
    stock_txn_id      BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id         BIGINT NOT NULL,
    product_id        BIGINT NOT NULL,
    lot_id            BIGINT NULL,
    txn_type          ENUM('IN','OUT','ADJUST','CONSUME','PRODUCE') NOT NULL,
    qty               DECIMAL(18,3) NOT NULL,
    ref_table         VARCHAR(50) NOT NULL,
    ref_id            BIGINT NOT NULL,
    memo              VARCHAR(500) NULL,
    txn_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by        BIGINT NULL,
    PRIMARY KEY (stock_txn_id),
    KEY idx_tb_stock_ledger_01 (product_id, txn_at),
    KEY idx_tb_stock_ledger_02 (lot_id, txn_at),
    KEY idx_tb_stock_ledger_03 (ref_table, ref_id),
    CONSTRAINT fk_tb_stock_ledger_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_stock_ledger_02 FOREIGN KEY (product_id) REFERENCES tb_product (product_id),
    CONSTRAINT fk_tb_stock_ledger_03 FOREIGN KEY (lot_id) REFERENCES tb_stock_lot (lot_id),
    CONSTRAINT fk_tb_stock_ledger_04 FOREIGN KEY (created_by) REFERENCES tb_user (user_id),
    CONSTRAINT chk_tb_stock_ledger_01 CHECK (qty > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='재고 원장';

-- ======================================================================
-- 13. 가공 배치/전환 이력
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_process_batch (
    process_batch_id   BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id          BIGINT NOT NULL,
    seller_company_id  BIGINT NOT NULL,
    source_product_id  BIGINT NOT NULL,
    target_product_id  BIGINT NOT NULL,
    input_qty          DECIMAL(18,3) NOT NULL,
    output_qty         DECIMAL(18,3) NOT NULL,
    loss_qty           DECIMAL(18,3) NOT NULL DEFAULT 0,
    processed_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    processed_by       BIGINT NULL,
    memo               VARCHAR(500) NULL,
    PRIMARY KEY (process_batch_id),
    KEY idx_tb_process_batch_01 (tenant_id, processed_at),
    KEY idx_tb_process_batch_02 (source_product_id, target_product_id),
    CONSTRAINT fk_tb_process_batch_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_process_batch_02 FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_process_batch_03 FOREIGN KEY (source_product_id) REFERENCES tb_product (product_id),
    CONSTRAINT fk_tb_process_batch_04 FOREIGN KEY (target_product_id) REFERENCES tb_product (product_id),
    CONSTRAINT fk_tb_process_batch_05 FOREIGN KEY (processed_by) REFERENCES tb_user (user_id),
    CONSTRAINT chk_tb_process_batch_01 CHECK (source_product_id <> target_product_id),
    CONSTRAINT chk_tb_process_batch_02 CHECK (input_qty > 0),
    CONSTRAINT chk_tb_process_batch_03 CHECK (output_qty >= 0),
    CONSTRAINT chk_tb_process_batch_04 CHECK (loss_qty >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='가공 배치/전환 이력';

-- ======================================================================
-- 14. 구매업체 여신 정책
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_buyer_credit_policy (
    credit_policy_id      BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id             BIGINT NOT NULL,
    seller_company_id     BIGINT NOT NULL,
    buyer_company_id      BIGINT NOT NULL,
    credit_limit_amount   DECIMAL(18,2) NOT NULL DEFAULT 0,
    payment_terms_days    INT NOT NULL DEFAULT 0,
    status                ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    approved_by           BIGINT NULL,
    approved_at           DATETIME NULL,
    created_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (credit_policy_id),
    UNIQUE KEY uq_tb_buyer_credit_policy_01 (tenant_id, seller_company_id, buyer_company_id),
    KEY idx_tb_buyer_credit_policy_01 (buyer_company_id, status),
    CONSTRAINT fk_tb_buyer_credit_policy_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_buyer_credit_policy_02 FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_buyer_credit_policy_03 FOREIGN KEY (buyer_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_buyer_credit_policy_04 FOREIGN KEY (approved_by) REFERENCES tb_user (user_id),
    CONSTRAINT chk_tb_buyer_credit_policy_01 CHECK (credit_limit_amount >= 0),
    CONSTRAINT chk_tb_buyer_credit_policy_02 CHECK (payment_terms_days >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='구매업체 여신 정책';

-- ======================================================================
-- 15. 여신한도 변경 이력
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_buyer_credit_limit_history (
    credit_limit_hist_id  BIGINT NOT NULL AUTO_INCREMENT,
    credit_policy_id      BIGINT NOT NULL,
    old_limit_amount      DECIMAL(18,2) NOT NULL,
    new_limit_amount      DECIMAL(18,2) NOT NULL,
    reason                VARCHAR(1000) NOT NULL,
    requested_by          BIGINT NULL,
    approved_by           BIGINT NULL,
    approved_at           DATETIME NOT NULL,
    created_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (credit_limit_hist_id),
    KEY idx_tb_buyer_credit_limit_history_01 (credit_policy_id, approved_at),
    CONSTRAINT fk_tb_buyer_credit_limit_history_01 FOREIGN KEY (credit_policy_id) REFERENCES tb_buyer_credit_policy (credit_policy_id),
    CONSTRAINT fk_tb_buyer_credit_limit_history_02 FOREIGN KEY (requested_by) REFERENCES tb_user (user_id),
    CONSTRAINT fk_tb_buyer_credit_limit_history_03 FOREIGN KEY (approved_by) REFERENCES tb_user (user_id),
    CONSTRAINT chk_tb_buyer_credit_limit_history_01 CHECK (old_limit_amount >= 0),
    CONSTRAINT chk_tb_buyer_credit_limit_history_02 CHECK (new_limit_amount >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='여신한도 변경 이력';

-- ======================================================================
-- 16. 여신 사용 원장
--     amount / balance_after는 "사용잔액 기준"으로 운용 권장
--     예) ORDER_USE = +, PAYMENT_OFFSET = -, CANCEL_RESTORE = -
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_buyer_credit_ledger (
    credit_ledger_id    BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id           BIGINT NOT NULL,
    seller_company_id   BIGINT NOT NULL,
    buyer_company_id    BIGINT NOT NULL,
    txn_type            ENUM('ORDER_USE','CANCEL_RESTORE','MANUAL_ADJUST','PAYMENT_OFFSET') NOT NULL,
    order_id            BIGINT NULL,
    amount              DECIMAL(18,2) NOT NULL,
    balance_after       DECIMAL(18,2) NOT NULL,
    memo                VARCHAR(500) NULL,
    txn_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by          BIGINT NULL,
    PRIMARY KEY (credit_ledger_id),
    KEY idx_tb_buyer_credit_ledger_01 (tenant_id, seller_company_id, buyer_company_id, txn_at),
    KEY idx_tb_buyer_credit_ledger_02 (order_id),
    CONSTRAINT fk_tb_buyer_credit_ledger_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_buyer_credit_ledger_02 FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_buyer_credit_ledger_03 FOREIGN KEY (buyer_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_buyer_credit_ledger_04 FOREIGN KEY (order_id) REFERENCES tb_order (order_id),
    CONSTRAINT fk_tb_buyer_credit_ledger_05 FOREIGN KEY (created_by) REFERENCES tb_user (user_id),
    CONSTRAINT chk_tb_buyer_credit_ledger_01 CHECK (amount <> 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='여신 사용 원장';

-- ======================================================================
-- 17. 외부입금 거래
--     수납계좌는 판매업체 계좌 사용 권장
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_external_payment_txn (
    external_payment_id     BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id               BIGINT NOT NULL,
    seller_company_id       BIGINT NOT NULL,
    buyer_company_id        BIGINT NULL,
    receipt_bank_account_id BIGINT NOT NULL,
    bank_txn_ref            VARCHAR(100) NOT NULL,
    payer_name              VARCHAR(100) NULL,
    deposited_amount        DECIMAL(18,2) NOT NULL,
    deposited_at            DATETIME NOT NULL,
    payment_type            ENUM('ADVANCE_DEPOSIT','ORDER_PAYMENT','CREDIT_SETTLEMENT') NOT NULL,
    match_status            ENUM('UNMATCHED','MATCHED','PARTIAL','CANCELED') NOT NULL DEFAULT 'UNMATCHED',
    matched_order_id        BIGINT NULL,
    created_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (external_payment_id),
    UNIQUE KEY uq_tb_external_payment_txn_01 (bank_txn_ref),
    KEY idx_tb_external_payment_txn_01 (tenant_id, seller_company_id, deposited_at),
    KEY idx_tb_external_payment_txn_02 (buyer_company_id, payment_type),
    KEY idx_tb_external_payment_txn_03 (matched_order_id),
    CONSTRAINT fk_tb_external_payment_txn_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_external_payment_txn_02 FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_external_payment_txn_03 FOREIGN KEY (buyer_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_external_payment_txn_04 FOREIGN KEY (receipt_bank_account_id) REFERENCES tb_company_bank_account (bank_account_id),
    CONSTRAINT fk_tb_external_payment_txn_05 FOREIGN KEY (matched_order_id) REFERENCES tb_order (order_id),
    CONSTRAINT chk_tb_external_payment_txn_01 CHECK (deposited_amount > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='외부입금 거래';

-- ======================================================================
-- 18. 선수금 원장
--     amount / balance_after는 "선수금 잔액 기준"으로 운용 권장
--     예) DEPOSIT_CONFIRMED = +, ORDER_ALLOCATED = -, ORDER_CANCEL_RESTORE = +
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_buyer_advance_ledger (
    advance_ledger_id     BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id             BIGINT NOT NULL,
    seller_company_id     BIGINT NOT NULL,
    buyer_company_id      BIGINT NOT NULL,
    txn_type              ENUM('DEPOSIT_CONFIRMED','ORDER_ALLOCATED','ORDER_CANCEL_RESTORE','REFUND','MANUAL_ADJUST') NOT NULL,
    external_payment_id   BIGINT NULL,
    order_id              BIGINT NULL,
    amount                DECIMAL(18,2) NOT NULL,
    balance_after         DECIMAL(18,2) NOT NULL,
    memo                  VARCHAR(500) NULL,
    txn_at                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by            BIGINT NULL,
    PRIMARY KEY (advance_ledger_id),
    KEY idx_tb_buyer_advance_ledger_01 (tenant_id, seller_company_id, buyer_company_id, txn_at),
    KEY idx_tb_buyer_advance_ledger_02 (external_payment_id),
    KEY idx_tb_buyer_advance_ledger_03 (order_id),
    CONSTRAINT fk_tb_buyer_advance_ledger_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_buyer_advance_ledger_02 FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_buyer_advance_ledger_03 FOREIGN KEY (buyer_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_buyer_advance_ledger_04 FOREIGN KEY (external_payment_id) REFERENCES tb_external_payment_txn (external_payment_id),
    CONSTRAINT fk_tb_buyer_advance_ledger_05 FOREIGN KEY (order_id) REFERENCES tb_order (order_id),
    CONSTRAINT fk_tb_buyer_advance_ledger_06 FOREIGN KEY (created_by) REFERENCES tb_user (user_id),
    CONSTRAINT chk_tb_buyer_advance_ledger_01 CHECK (amount <> 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='선수금 원장';

-- ======================================================================
-- 19. 주문 충당 내역
--     source_ref_id는 source_type에 따라 참조 대상이 달라짐
--     - ADVANCE        -> tb_buyer_advance_ledger.advance_ledger_id
--     - CREDIT         -> tb_buyer_credit_ledger.credit_ledger_id
--     - EXTERNAL_PAYMENT -> tb_external_payment_txn.external_payment_id
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_payment_allocation (
    allocation_id      BIGINT NOT NULL AUTO_INCREMENT,
    order_id           BIGINT NOT NULL,
    source_type        ENUM('ADVANCE','CREDIT','EXTERNAL_PAYMENT') NOT NULL,
    source_ref_id      BIGINT NOT NULL,
    allocated_amount   DECIMAL(18,2) NOT NULL,
    allocated_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by         BIGINT NULL,
    PRIMARY KEY (allocation_id),
    KEY idx_tb_payment_allocation_01 (order_id, allocated_at),
    KEY idx_tb_payment_allocation_02 (source_type, source_ref_id),
    CONSTRAINT fk_tb_payment_allocation_01 FOREIGN KEY (order_id) REFERENCES tb_order (order_id),
    CONSTRAINT fk_tb_payment_allocation_02 FOREIGN KEY (created_by) REFERENCES tb_user (user_id),
    CONSTRAINT chk_tb_payment_allocation_01 CHECK (allocated_amount > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='주문 충당 내역';

-- ======================================================================
-- 20. 정산/마감 헤더
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_settlement (
    settlement_id        BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id            BIGINT NOT NULL,
    seller_company_id    BIGINT NOT NULL,
    buyer_company_id     BIGINT NOT NULL,
    period_from          DATE NOT NULL,
    period_to            DATE NOT NULL,
    opening_balance      DECIMAL(18,2) NOT NULL DEFAULT 0,
    sales_amount         DECIMAL(18,2) NOT NULL DEFAULT 0,
    vat_amount           DECIMAL(18,2) NOT NULL DEFAULT 0,
    received_amount      DECIMAL(18,2) NOT NULL DEFAULT 0,
    credit_used_amount   DECIMAL(18,2) NOT NULL DEFAULT 0,
    closing_balance      DECIMAL(18,2) NOT NULL DEFAULT 0,
    settlement_status    ENUM('OPEN','CLOSED','CONFIRMED') NOT NULL DEFAULT 'OPEN',
    closed_at            DATETIME NULL,
    closed_by            BIGINT NULL,
    PRIMARY KEY (settlement_id),
    UNIQUE KEY uq_tb_settlement_01 (tenant_id, seller_company_id, buyer_company_id, period_from, period_to),
    KEY idx_tb_settlement_01 (buyer_company_id, settlement_status),
    KEY idx_tb_settlement_02 (seller_company_id, period_from, period_to),
    CONSTRAINT fk_tb_settlement_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_settlement_02 FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_settlement_03 FOREIGN KEY (buyer_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_settlement_04 FOREIGN KEY (closed_by) REFERENCES tb_user (user_id),
    CONSTRAINT chk_tb_settlement_01 CHECK (period_to >= period_from),
    CONSTRAINT chk_tb_settlement_02 CHECK (sales_amount >= 0),
    CONSTRAINT chk_tb_settlement_03 CHECK (vat_amount >= 0),
    CONSTRAINT chk_tb_settlement_04 CHECK (received_amount >= 0),
    CONSTRAINT chk_tb_settlement_05 CHECK (credit_used_amount >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='정산/마감 헤더';

-- ======================================================================
-- 21. 정산 상세
-- ======================================================================
CREATE TABLE IF NOT EXISTS tb_settlement_line (
    settlement_line_id   BIGINT NOT NULL AUTO_INCREMENT,
    settlement_id        BIGINT NOT NULL,
    line_type            ENUM('ORDER','PAYMENT','CREDIT','REFUND','ADJUST') NOT NULL,
    ref_table            VARCHAR(50) NOT NULL,
    ref_id               BIGINT NOT NULL,
    amount               DECIMAL(18,2) NOT NULL,
    memo                 VARCHAR(500) NULL,
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (settlement_line_id),
    KEY idx_tb_settlement_line_01 (settlement_id),
    KEY idx_tb_settlement_line_02 (ref_table, ref_id),
    CONSTRAINT fk_tb_settlement_line_01 FOREIGN KEY (settlement_id) REFERENCES tb_settlement (settlement_id),
    CONSTRAINT chk_tb_settlement_line_01 CHECK (amount <> 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='정산 상세';


-- ======================================================================
-- [선택] 추천 VIEW / QUERY 힌트
-- 실제 운영 전 EXPLAIN으로 인덱스 확인 권장
-- ======================================================================

-- 현재 승인된 상품 세금 규칙 조회 예시
-- SELECT *
--   FROM tb_product_tax_rule
--  WHERE product_id = ?
--    AND approval_status = 'APPROVED'
--    AND effective_from <= NOW()
--    AND (effective_to IS NULL OR effective_to > NOW())
--  ORDER BY rule_version DESC
--  LIMIT 1;

-- 구매업체별 가용 여신 예시
-- SELECT
--     p.credit_limit_amount                                                AS credit_limit_amount,
--     COALESCE((SELECT balance_after
--                 FROM tb_buyer_credit_ledger l
--                WHERE l.tenant_id = p.tenant_id
--                  AND l.seller_company_id = p.seller_company_id
--                  AND l.buyer_company_id = p.buyer_company_id
--                ORDER BY l.txn_at DESC, l.credit_ledger_id DESC
--                LIMIT 1), 0)                                              AS used_credit_amount,
--     p.credit_limit_amount -
--     COALESCE((SELECT balance_after
--                 FROM tb_buyer_credit_ledger l
--                WHERE l.tenant_id = p.tenant_id
--                  AND l.seller_company_id = p.seller_company_id
--                  AND l.buyer_company_id = p.buyer_company_id
--                ORDER BY l.txn_at DESC, l.credit_ledger_id DESC
--                LIMIT 1), 0)                                              AS available_credit_amount
-- FROM tb_buyer_credit_policy p
-- WHERE p.tenant_id = ?
--   AND p.seller_company_id = ?
--   AND p.buyer_company_id = ?
--   AND p.status = 'ACTIVE';

-- 구매업체별 선수금 잔액 예시
-- SELECT COALESCE(balance_after, 0)
--   FROM tb_buyer_advance_ledger
--  WHERE tenant_id = ?
--    AND seller_company_id = ?
--    AND buyer_company_id = ?
--  ORDER BY txn_at DESC, advance_ledger_id DESC
--  LIMIT 1;

바로 참고하실 포인트 5개
1. 기존 9개 테이블은 건드리지 않고 확장하는 구조입니다.
2. tb_buyer_financial은 당장 유지 가능하지만, 중장기적으로는 tb_buyer_credit_policy + tb_buyer_credit_ledger 조합이 더 안전합니다.
3. tb_payment_allocation.source_ref_id는 다형 참조라 FK를 못 걸었습니다. 이건 서비스 레이어에서 2차 검증 필수입니다.
4. tb_product_price는 구매업체 전용가와 채널가 동시지정 금지 CHECK를 넣었습니다. 
5. 세무조사 방어의 핵심은 여전히 tb_order_line snapshot + tb_product_tax_rule 버전관리입니다.