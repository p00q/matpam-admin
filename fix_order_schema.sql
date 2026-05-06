SET FOREIGN_KEY_CHECKS = 0;

-- 1. 기존 주문 테이블 삭제 (백업이 필요하면 별도 보관)
DROP TABLE IF EXISTS tb_order_line;
DROP TABLE IF EXISTS tb_order;

-- 2. 신규 주문 테이블 생성 (B2B 통합 스키마)
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
    KEY idx_tb_order_01 (tenant_id, buyer_company_id, order_status),
    KEY idx_tb_order_02 (tenant_id, seller_company_id, payment_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='통합 주문 마스터';

CREATE TABLE tb_order_line (
    order_line_id               BIGINT NOT NULL AUTO_INCREMENT,
    order_id                    BIGINT NOT NULL,
    line_no                     INT NOT NULL,
    product_id                  BIGINT NOT NULL,
    relation_group_id           VARCHAR(50) NULL,
    product_name_snapshot       VARCHAR(200) NOT NULL,
    item_kind_snapshot          VARCHAR(50) NULL,
    processing_type_snapshot    VARCHAR(50) NULL,
    tax_category_snapshot       VARCHAR(50) NULL,
    tax_rule_id_snapshot        BIGINT NULL,
    unit_name_snapshot          VARCHAR(20) NULL,
    qty                         DECIMAL(12,3) NOT NULL DEFAULT 0,
    unit_price                  DECIMAL(18,2) NOT NULL DEFAULT 0,
    supply_amount               DECIMAL(18,2) NOT NULL DEFAULT 0,
    vat_amount                  DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_amount                DECIMAL(18,2) NOT NULL DEFAULT 0,
    shipment_status             VARCHAR(20) NOT NULL DEFAULT 'WAITING',
    created_at                  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (order_line_id),
    KEY idx_tb_order_line_01 (order_id),
    CONSTRAINT fk_tb_order_line_01 FOREIGN KEY (order_id) REFERENCES tb_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='주문 품목 상세';

-- 3. 통합 상품 테이블 존재 여부 확인 및 보강 (없을 시 생성)
CREATE TABLE IF NOT EXISTS tb_product (
    product_id                 BIGINT NOT NULL AUTO_INCREMENT,
    tenant_id                  BIGINT NOT NULL,
    product_code               VARCHAR(50) NOT NULL,
    product_name               VARCHAR(200) NOT NULL,
    item_kind                  VARCHAR(50) NULL,
    processing_type            VARCHAR(50) NULL,
    independent_sale_yn        CHAR(1) NOT NULL DEFAULT 'Y',
    stock_managed_yn           CHAR(1) NOT NULL DEFAULT 'Y',
    sale_status                VARCHAR(20) NOT NULL DEFAULT 'ON_SALE',
    created_at                 DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (product_id),
    UNIQUE KEY uq_tb_product_01 (tenant_id, product_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='통합 상품 마스터';

SET FOREIGN_KEY_CHECKS = 1;
