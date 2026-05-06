SET FOREIGN_KEY_CHECKS = 0;

-- 1. 기존 테이블 일괄 삭제
DROP TABLE IF EXISTS tb_settlement_line;
DROP TABLE IF EXISTS tb_settlement;
DROP TABLE IF EXISTS tb_payment_allocation;
DROP TABLE IF EXISTS tb_shipment_line;
DROP TABLE IF EXISTS tb_shipment;
DROP TABLE IF EXISTS tb_order_line;
DROP TABLE IF EXISTS tb_order;
DROP TABLE IF EXISTS tb_buyer_advance_ledger;
DROP TABLE IF EXISTS tb_buyer_credit_ledger;
DROP TABLE IF EXISTS tb_buyer_credit_policy;
DROP TABLE IF EXISTS tb_external_payment_txn;
DROP TABLE IF EXISTS tb_product;
DROP TABLE IF EXISTS tb_channel;
DROP TABLE IF EXISTS tb_user;
DROP TABLE IF EXISTS tb_company_contact;
DROP TABLE IF EXISTS tb_company;
DROP TABLE IF EXISTS tb_tenant;

-- ======================================================================
-- 1. 테넌트 (Tenant)
-- ======================================================================
CREATE TABLE tb_tenant (
    tenant_id          BIGINT NOT NULL AUTO_INCREMENT,
    tenant_name        VARCHAR(100) NOT NULL,
    domain             VARCHAR(100) NULL,
    status             ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (tenant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='테넌트(최상위 그룹)';

-- ======================================================================
-- 2. 업체 (Company)
-- ======================================================================
CREATE TABLE tb_company (
    company_id         BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id          BIGINT NOT NULL,
    company_name       VARCHAR(100) NOT NULL,
    company_type       ENUM('SELLER','BUYER','BOTH') NOT NULL,
    seller_type        VARCHAR(20) NULL,
    business_no        VARCHAR(20) NULL,
    ceo_name           VARCHAR(50) NULL,
    postal_code        VARCHAR(10) NULL,
    address1           VARCHAR(200) NULL,
    address2           VARCHAR(200) NULL,
    phone              VARCHAR(20) NULL,
    email              VARCHAR(100) NULL,
    default_tax_type   ENUM('TAXABLE','TAX_FREE') NULL,
    biz_status         VARCHAR(20) NULL,
    status             ENUM('ACTIVE','INACTIVE','SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
    created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (company_id),
    KEY idx_tb_company_01 (tenant_id, company_type),
    CONSTRAINT fk_tb_company_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='업체 정보';

CREATE TABLE tb_company_contact (
    contact_id         BIGINT NOT NULL AUTO_INCREMENT,
    company_id         BIGINT NOT NULL,
    contact_name       VARCHAR(50) NOT NULL,
    contact_role       VARCHAR(50) NULL,
    mobile             VARCHAR(20) NULL,
    email              VARCHAR(100) NULL,
    is_primary         CHAR(1) DEFAULT 'N',
    linked_user_id     BIGINT NULL,
    status             ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (contact_id),
    CONSTRAINT fk_tb_company_contact_01 FOREIGN KEY (company_id) REFERENCES tb_company (company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='업체 담당자';

-- ======================================================================
-- 3. 사용자 (User)
-- ======================================================================
CREATE TABLE tb_user (
    user_id            BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id          BIGINT NOT NULL,
    company_id         BIGINT NOT NULL,
    login_id           VARCHAR(50) NOT NULL,
    password_hash      VARCHAR(200) NOT NULL,
    user_name          VARCHAR(50) NOT NULL,
    email              VARCHAR(100) NULL,
    mobile             VARCHAR(20) NULL,
    channel_id         BIGINT NULL,
    role               VARCHAR(20) NOT NULL DEFAULT 'USER',
    status             ENUM('ACTIVE','INACTIVE','LOCKED') NOT NULL DEFAULT 'ACTIVE',
    created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id),
    UNIQUE KEY uq_tb_user_01 (login_id),
    KEY idx_tb_user_01 (tenant_id, company_id),
    CONSTRAINT fk_tb_user_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_user_02 FOREIGN KEY (company_id) REFERENCES tb_company (company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='사용자 정보';

-- ======================================================================
-- 4. 판매 채널 (Channel)
-- ======================================================================
CREATE TABLE tb_channel (
    channel_id         BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id          BIGINT NOT NULL,
    seller_company_id  BIGINT NOT NULL,
    channel_name       VARCHAR(100) NOT NULL,
    channel_type       ENUM('DIRECT','COURIER','COLLECT') NOT NULL DEFAULT 'DIRECT',
    status             ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    PRIMARY KEY (channel_id),
    CONSTRAINT fk_tb_channel_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_channel_02 FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='판매 채널';

-- ======================================================================
-- 5. 상품 (Product)
-- ======================================================================
CREATE TABLE tb_product (
    product_id         BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id          BIGINT NOT NULL,
    product_code       VARCHAR(50) NOT NULL,
    product_name       VARCHAR(200) NOT NULL,
    seller_company_id  BIGINT NULL,
    item_kind          VARCHAR(50) NULL,
    processing_type    VARCHAR(50) NULL,
    sale_status        VARCHAR(20) NOT NULL DEFAULT 'ON_SALE',
    created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (product_id),
    UNIQUE KEY uq_tb_product_01 (tenant_id, product_code),
    CONSTRAINT fk_tb_product_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_product_02 FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='통합 상품 마스터';

-- 기존 코드 호환용 View (tb_member_master -> tb_company)
CREATE OR REPLACE VIEW tb_member_master AS
SELECT 
    company_id AS member_id,
    tenant_id,
    company_name,
    business_no,
    ceo_name,
    'ACTIVE' AS status
FROM tb_company;

-- 기존 코드 호환용 테이블 (가공/원물 분리 대응 - tb_product 구조 복사)
CREATE TABLE IF NOT EXISTS tb_sales_product (
    SALES_PROD_ID      BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    SALES_PROD_CODE    VARCHAR(50),
    SALES_PROD_NAME    VARCHAR(200),
    SELLER_MEMBER_ID   BIGINT,
    LIST_PRICE         DECIMAL(18,2),
    SALE_PRICE         DECIMAL(18,2),
    COST_PRICE         DECIMAL(18,2),
    VAT_RATE           DECIMAL(5,2),
    EXPOSURE_STATUS_CD CHAR(1) DEFAULT 'Y',
    SALE_STATUS_CD     VARCHAR(20) DEFAULT 'LIVE',
    USE_YN             CHAR(1) DEFAULT 'Y',
    DEL_YN             CHAR(1) DEFAULT 'N',
    OP_TYPE            VARCHAR(20),
    REG_DT             DATETIME DEFAULT CURRENT_TIMESTAMP,
    MOD_DT             DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tb_component_product (
    COMPONENT_PROD_ID      BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    COMPONENT_PROD_CODE    VARCHAR(50),
    COMPONENT_PROD_NAME    VARCHAR(200),
    SELLER_MEMBER_ID       BIGINT,
    LIST_PRICE             DECIMAL(18,2),
    COST_PRICE             DECIMAL(18,2),
    VAT_RATE               DECIMAL(5,2),
    VAT_AMOUNT             DECIMAL(18,2),
    EXPOSURE_STATUS_CD     CHAR(1) DEFAULT 'Y',
    SALE_STATUS_CD         VARCHAR(20) DEFAULT 'LIVE',
    USE_YN                 CHAR(1) DEFAULT 'Y',
    DEL_YN                 CHAR(1) DEFAULT 'N',
    OP_TYPE                VARCHAR(20),
    REG_DT                 DATETIME DEFAULT CURRENT_TIMESTAMP,
    MOD_DT                 DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- ======================================================================
-- 6. 주문 (Order)
-- ======================================================================
CREATE TABLE tb_order (
    order_id                   BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id                  BIGINT NOT NULL,
    seller_company_id          BIGINT NOT NULL,
    buyer_company_id           BIGINT NOT NULL,
    channel_id                 BIGINT NULL,
    order_no                   VARCHAR(50) NOT NULL,
    order_status               ENUM('RECEIVED','CONFIRMED','COMPLETED','CANCELLED') NOT NULL DEFAULT 'RECEIVED',
    payment_status             ENUM('UNPAID','PAID','PARTIAL_PAID') NOT NULL DEFAULT 'UNPAID',
    shipment_status            ENUM('NOT_STARTED','PARTIAL','SHIPPED','DELIVERED') NOT NULL DEFAULT 'NOT_STARTED',
    total_supply_amount        DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_vat_amount           DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_order_amount         DECIMAL(18,2) NOT NULL DEFAULT 0,
    description                TEXT NULL,
    created_by                 BIGINT NULL,
    created_at                 DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                 DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (order_id),
    UNIQUE KEY uq_tb_order_01 (order_no),
    CONSTRAINT fk_tb_order_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_order_02 FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_order_03 FOREIGN KEY (buyer_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_order_04 FOREIGN KEY (channel_id) REFERENCES tb_channel (channel_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='주문 마스터';

CREATE TABLE tb_order_line (
    order_line_id               BIGINT NOT NULL AUTO_INCREMENT,
    order_id                    BIGINT NOT NULL,
    line_no                     INT NOT NULL,
    product_id                  BIGINT NOT NULL,
    product_name_snapshot       VARCHAR(200) NOT NULL,
    qty                         DECIMAL(12,3) NOT NULL DEFAULT 0,
    unit_price                  DECIMAL(18,2) NOT NULL DEFAULT 0,
    supply_amount               DECIMAL(18,2) NOT NULL DEFAULT 0,
    vat_amount                  DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_amount                DECIMAL(18,2) NOT NULL DEFAULT 0,
    created_at                  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (order_line_id),
    CONSTRAINT fk_tb_order_line_01 FOREIGN KEY (order_id) REFERENCES tb_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='주문 상세';

-- ======================================================================
-- 7. 금융 (Financials - Meat Money)
-- ======================================================================
-- 여신 정책/한도 (Credit Policy)
CREATE TABLE tb_buyer_credit_policy (
    tenant_id            BIGINT NOT NULL,
    seller_company_id    BIGINT NOT NULL,
    buyer_company_id     BIGINT NOT NULL,
    credit_limit_amount  DECIMAL(18,2) NOT NULL DEFAULT 0,
    status               ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (tenant_id, seller_company_id, buyer_company_id),
    CONSTRAINT fk_tb_buyer_credit_policy_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_buyer_credit_policy_02 FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_buyer_credit_policy_03 FOREIGN KEY (buyer_company_id) REFERENCES tb_company (company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='여신 정책';

-- 여신 원장 (Credit Ledger)
CREATE TABLE tb_buyer_credit_ledger (
    credit_ledger_id     BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id            BIGINT NOT NULL,
    seller_company_id    BIGINT NOT NULL,
    buyer_company_id     BIGINT NOT NULL,
    txn_type             ENUM('GRANT','REVOKE','ORDER_PAY','ORDER_CANCEL','ADJUST') NOT NULL,
    amount               DECIMAL(18,2) NOT NULL,
    balance_after        DECIMAL(18,2) NOT NULL,
    ref_table            VARCHAR(50) NULL,
    ref_id               BIGINT NULL,
    memo                 VARCHAR(500) NULL,
    created_by           BIGINT NULL,
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (credit_ledger_id),
    CONSTRAINT fk_tb_buyer_credit_ledger_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='여신 원장';

-- 선수금 원장 (Advance Ledger)
CREATE TABLE tb_buyer_advance_ledger (
    advance_ledger_id    BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id            BIGINT NOT NULL,
    seller_company_id    BIGINT NOT NULL,
    buyer_company_id     BIGINT NOT NULL,
    txn_type             ENUM('DEPOSIT','WITHDRAW','ORDER_PAY','ORDER_CANCEL','ADJUST') NOT NULL,
    amount               DECIMAL(18,2) NOT NULL,
    balance_after        DECIMAL(18,2) NOT NULL,
    ref_table            VARCHAR(50) NULL,
    ref_id               BIGINT NULL,
    memo                 VARCHAR(500) NULL,
    created_by           BIGINT NULL,
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (advance_ledger_id),
    CONSTRAINT fk_tb_buyer_advance_ledger_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='선수금 원장';

-- 외부 결제 트랜잭션 (External Payment)
CREATE TABLE tb_external_payment_txn (
    external_payment_id  BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id            BIGINT NOT NULL,
    seller_company_id    BIGINT NOT NULL,
    buyer_company_id     BIGINT NOT NULL,
    payment_method       ENUM('BANK_TRANSFER','VIRTUAL_ACCOUNT','CARD') NOT NULL,
    amount               DECIMAL(18,2) NOT NULL,
    txn_no               VARCHAR(100) NULL,
    status               ENUM('PENDING','COMPLETED','CANCELLED') NOT NULL DEFAULT 'PENDING',
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (external_payment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='외부 결제 내역';

-- ======================================================================
-- 8. 물류 (Shipments)
-- ======================================================================
CREATE TABLE tb_shipment (
    shipment_id          BIGINT NOT NULL AUTO_INCREMENT,
    order_id             BIGINT NOT NULL,
    shipment_no          VARCHAR(50) NOT NULL,
    tracking_no          VARCHAR(100) NULL,
    courier_name         VARCHAR(50) NULL,
    shipment_status      ENUM('PREPARING','SHIPPED','DELIVERED','CANCELLED') NOT NULL DEFAULT 'PREPARING',
    shipped_at           DATETIME NULL,
    delivered_at         DATETIME NULL,
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (shipment_id),
    UNIQUE KEY uq_tb_shipment_01 (shipment_no),
    CONSTRAINT fk_tb_shipment_01 FOREIGN KEY (order_id) REFERENCES tb_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='배송 마스터';

CREATE TABLE tb_shipment_line (
    shipment_line_id     BIGINT NOT NULL AUTO_INCREMENT,
    shipment_id          BIGINT NOT NULL,
    order_line_id        BIGINT NOT NULL,
    shipped_qty          DECIMAL(12,3) NOT NULL,
    PRIMARY KEY (shipment_line_id),
    CONSTRAINT fk_tb_shipment_line_01 FOREIGN KEY (shipment_id) REFERENCES tb_shipment (shipment_id),
    CONSTRAINT fk_tb_shipment_line_02 FOREIGN KEY (order_line_id) REFERENCES tb_order_line (order_line_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='배송 상세';

-- ======================================================================
-- 9. 정산 (Settlement)
-- ======================================================================
CREATE TABLE tb_settlement (
    settlement_id        BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id            BIGINT NOT NULL,
    seller_company_id    BIGINT NOT NULL,
    buyer_company_id     BIGINT NOT NULL,
    period_from          DATE NOT NULL,
    period_to            DATE NOT NULL,
    sales_amount         DECIMAL(18,2) NOT NULL DEFAULT 0,
    vat_amount           DECIMAL(18,2) NOT NULL DEFAULT 0,
    settlement_status    ENUM('OPEN','CLOSED','CONFIRMED') NOT NULL DEFAULT 'OPEN',
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (settlement_id),
    CONSTRAINT fk_tb_settlement_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='정산 마스터';

CREATE TABLE tb_settlement_line (
    settlement_line_id   BIGINT NOT NULL AUTO_INCREMENT,
    settlement_id        BIGINT NOT NULL,
    order_id             BIGINT NOT NULL,
    amount               DECIMAL(18,2) NOT NULL,
    PRIMARY KEY (settlement_line_id),
    CONSTRAINT fk_tb_settlement_line_01 FOREIGN KEY (settlement_id) REFERENCES tb_settlement (settlement_id),
    CONSTRAINT fk_tb_settlement_line_02 FOREIGN KEY (order_id) REFERENCES tb_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='정산 상세';

SET FOREIGN_KEY_CHECKS = 1;

-- ======================================================================
-- [초기 데이터]
-- ======================================================================
INSERT INTO tb_tenant (tenant_id, tenant_name) VALUES (1, '맛팜 통합 시스템');

INSERT INTO tb_company (company_id, tenant_id, company_name, company_type, status) 
VALUES (1, 1, '본사(마스터)', 'BOTH', 'ACTIVE');

-- 관리자 계정 (admin / admin1234)
INSERT INTO `tb_user` (`user_id`, `tenant_id`, `company_id`, `login_id`, `password_hash`, `user_name`, `mobile`, `email`, `channel_id`, `status`, `role`, `created_at`) VALUES
(1, 1, 1, 'admin', '$2a$10$/.AXKAKYYACzRzbcy2roLuuTxBZ.k/trsKAXF1nwOQpM9MtXLK.xm', '관리자', '010-1234-5678', 'admin@matpam.com', NULL, 'ACTIVE', 'SUPER', NOW());

-- 기본 채널 (전국택배)
INSERT INTO tb_channel (channel_id, tenant_id, seller_company_id, channel_name, channel_type)
VALUES (1, 1, 1, '전국택배', 'COURIER');
