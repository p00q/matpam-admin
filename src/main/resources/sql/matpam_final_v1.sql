-- =========================================================
-- 맛팜(Matpam) 최종 스키마 보정 및 신규 테이블 생성
-- =========================================================

-- 1. 주문 테이블 (TB_ORDER) OP_TYPE 컬럼 추가 및 격리 준비
-- 기존 테이블이 있다면 컬럼 추가, 없으면 생성 (여기서는 추가 시나리오)
ALTER TABLE tb_order ADD COLUMN op_type VARCHAR(20) DEFAULT 'NATIONAL' COMMENT '운영타입(NATIONAL, LOCAL, FACTORY)';

-- 2. 판매상품 테이블 (TB_SALES_PRODUCT) OP_TYPE 컬럼 추가
ALTER TABLE tb_sales_product ADD COLUMN op_type VARCHAR(20) DEFAULT 'NATIONAL' COMMENT '운영타입(NATIONAL, LOCAL, FACTORY)';

-- 3. 회원 테이블 (TB_MEMBER) OP_TYPE 명시적 관리 (기존 ROLE_ID/MEMBER_TYPE 활용 가능하지만 격리용으로 명시)
-- 이미 NewTable_NewData.sql에서 member_type_cd가 있음. 
-- 여기서는 코드와의 매핑을 명확히 하기 위해 op_type 컬럼을 별도로 두어 격리 쿼리에서 활용.
ALTER TABLE tb_member ADD COLUMN op_type VARCHAR(20) DEFAULT 'NATIONAL' COMMENT '격리용 운영타입 코드';

-- 4. 일간 정산 테이블 (TB_SETTLEMENT) 생성
DROP TABLE IF EXISTS tb_settlement;
CREATE TABLE tb_settlement (
    settle_id           BIGINT        NOT NULL AUTO_INCREMENT COMMENT '정산ID',
    settle_date         DATE          NOT NULL COMMENT '정산기준일자',
    op_type             VARCHAR(20)   NOT NULL COMMENT '운영타입',
    
    order_count         INT           NOT NULL DEFAULT 0 COMMENT '총 주문 건수',
    total_sales_amt     DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '총 매출액(부가세 포함)',
    total_goods_amt     DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '총 상품액(할인 전)',
    total_discount_amt  DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '총 할인액',
    total_vat_amt       DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '총 부가세액',
    total_pay_amt       DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '총 실결제액(머니)',
    
    raw_material_ratio  DECIMAL(5,2)           COMMENT '원물 비중(비과세/전체)',
    processed_ratio     DECIMAL(5,2)           COMMENT '가공품 비중(과세/전체)',
    
    reg_dt              DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    mod_dt              DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    
    PRIMARY KEY (settle_id),
    UNIQUE KEY UQ_SETTLE_DATE_TYPE (settle_date, op_type),
    KEY IX_SETTLE_DATE (settle_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='일간 자동 정산 데이터';

-- 5. 맛팜 머니 거래 타입 코드 추가 (TB_DETAIL_CODE)
-- MEATMONEY_TXN_TYPE 등 필요한 코드는 이미 insert_code_data.sql에 있을 수 있으나 확인 필요.
