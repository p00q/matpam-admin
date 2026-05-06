SET FOREIGN_KEY_CHECKS = 0;

CREATE OR REPLACE VIEW tb_member AS
SELECT 
    company_id AS member_id,
    tenant_id,
    company_name,
    business_no,
    ceo_name,
    ceo_name AS user_name,
    phone AS mobile_no,
    email,
    status,
    'Y' AS use_yn,
    'N' AS del_yn
FROM tb_company;

DROP TABLE IF EXISTS tb_order_item;
CREATE TABLE tb_order_item (
    order_item_id       BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_id            BIGINT NOT NULL,
    line_no             INT NOT NULL,
    sales_prod_id       BIGINT,
    sales_prod_name     VARCHAR(200) NOT NULL,
    sale_unit_price     DECIMAL(18,2) NOT NULL DEFAULT 0,
    order_qty           DECIMAL(12,3) NOT NULL DEFAULT 0,
    supply_amt          DECIMAL(18,2) NOT NULL DEFAULT 0,
    vat_amt             DECIMAL(18,2) NOT NULL DEFAULT 0,
    pay_amt             DECIMAL(18,2) NOT NULL DEFAULT 0,
    del_yn              CHAR(1) DEFAULT 'N',
    reg_dt              DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tb_order_item_01 FOREIGN KEY (order_id) REFERENCES tb_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS tb_order_delivery_parcel;
CREATE TABLE tb_order_delivery_parcel (
    order_id BIGINT NOT NULL PRIMARY KEY, courier_cd VARCHAR(20), tracking_no VARCHAR(50), delivery_region_cd VARCHAR(20), shipped_dt VARCHAR(20), use_yn CHAR(1) DEFAULT 'Y', del_yn CHAR(1) DEFAULT 'N', reg_id VARCHAR(50), reg_dt DATETIME DEFAULT CURRENT_TIMESTAMP, op_type VARCHAR(20)
);

DROP TABLE IF EXISTS tb_order_delivery_freight;
CREATE TABLE tb_order_delivery_freight (
    order_id BIGINT NOT NULL PRIMARY KEY, shipping_method_cd VARCHAR(20), freight_company_name VARCHAR(100), driver_name VARCHAR(50), driver_mobile VARCHAR(20), truck_no VARCHAR(20), delivery_region_cd VARCHAR(20), shipped_dt VARCHAR(20), use_yn CHAR(1) DEFAULT 'Y', del_yn CHAR(1) DEFAULT 'N', reg_id VARCHAR(50), reg_dt DATETIME DEFAULT CURRENT_TIMESTAMP, op_type VARCHAR(20)
);

DROP TABLE IF EXISTS tb_order_delivery_factory;
CREATE TABLE tb_order_delivery_factory (
    order_id BIGINT NOT NULL PRIMARY KEY, pickup_place_cd VARCHAR(20), pickup_dt VARCHAR(20), contact_name VARCHAR(50), contact_mobile VARCHAR(20), use_yn CHAR(1) DEFAULT 'Y', del_yn CHAR(1) DEFAULT 'N', reg_id VARCHAR(50), reg_dt DATETIME DEFAULT CURRENT_TIMESTAMP, op_type VARCHAR(20)
);

DROP TABLE IF EXISTS tb_order_line;
DROP TABLE IF EXISTS tb_order;
CREATE TABLE tb_order (
    order_id           BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_no           VARCHAR(50) NOT NULL UNIQUE,
    tenant_id          BIGINT NOT NULL DEFAULT 1,
    seller_company_id  BIGINT NOT NULL DEFAULT 1,
    buyer_company_id   BIGINT NOT NULL DEFAULT 1,
    buyer_member_id    BIGINT,
    order_dt           DATETIME DEFAULT CURRENT_TIMESTAMP,
    order_status_cd    VARCHAR(20) DEFAULT 'RECEIVED',
    delivery_type_cd   VARCHAR(20) DEFAULT 'PARCEL',
    delivery_status_cd VARCHAR(20) DEFAULT 'READY',
    goods_total_amt    DECIMAL(18,2) DEFAULT 0,
    delivery_total_amt DECIMAL(18,2) DEFAULT 0,
    discount_total_amt DECIMAL(18,2) DEFAULT 0,
    vat_total_amt      DECIMAL(18,2) DEFAULT 0,
    pay_total_amt      DECIMAL(18,2) DEFAULT 0,
    receiver_name      VARCHAR(50),
    receiver_mobile    VARCHAR(20),
    region_sido_cd     VARCHAR(10),
    region_sigungu_cd  VARCHAR(10),
    op_type            VARCHAR(20) DEFAULT 'NATIONAL',
    use_yn             CHAR(1) DEFAULT 'Y',
    del_yn             CHAR(1) DEFAULT 'N',
    reg_id             VARCHAR(50),
    reg_dt             DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO tb_order (order_no, buyer_member_id, buyer_company_id, seller_company_id, tenant_id, order_status_cd, goods_total_amt, pay_total_amt, op_type, receiver_name)
VALUES ('ORD-20260503-001', 1, 1, 1, 1, 'RECEIVED', 50000, 55000, 'NATIONAL', 'Tester');

INSERT INTO tb_order_item (order_id, line_no, sales_prod_name, sale_unit_price, order_qty, supply_amt, pay_amt)
VALUES (LAST_INSERT_ID(), 1, 'Premium Beef Set', 50000, 1, 50000, 55000);

SET FOREIGN_KEY_CHECKS = 1;
