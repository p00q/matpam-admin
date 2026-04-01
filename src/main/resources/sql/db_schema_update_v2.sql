-- =========================================================
-- 맛팜(Matpam) 백엔드 V2 로직 반영 스키마 보정
-- =========================================================

-- 1. 구성상품 테이블 (TB_COMPONENT_PRODUCT) 신규 컬럼
ALTER TABLE TB_COMPONENT_PRODUCT ADD COLUMN TAX_TYPE VARCHAR(20) DEFAULT 'TAXABLE' COMMENT '과세여부 (TAXABLE, FREE)';

-- 2. 판매상품 테이블 (TB_SALES_PRODUCT) 신규 컬럼
ALTER TABLE TB_SALES_PRODUCT ADD COLUMN DISCOUNT_AMT DECIMAL(18,2) DEFAULT 0 COMMENT '할인금액';

-- 3. 주문 상세 테이블 (TB_ORDER_ITEM) 신규 컬럼 (TB_ORDER는 v1 적용됨)
ALTER TABLE TB_ORDER_ITEM ADD COLUMN OP_TYPE VARCHAR(20) DEFAULT 'NATIONAL' COMMENT '운영타입(NATIONAL, LOCAL, FACTORY)';

-- 4. 맛팜 머니 거래 이력 테이블 (TB_MONEY_HISTORY)
DROP TABLE IF EXISTS tb_money_history;
CREATE TABLE tb_money_history (
    money_hist_id       BIGINT        NOT NULL AUTO_INCREMENT COMMENT '머니이력ID',
    member_id           BIGINT        NOT NULL COMMENT '회원ID',
    trx_type_cd         VARCHAR(20)   NOT NULL COMMENT '거래유형 (CHARGE, PAYMENT, REFUND)',
    change_amt          DECIMAL(18,2) NOT NULL COMMENT '변동금액 (+/-)',
    balance             DECIMAL(18,2) NOT NULL COMMENT '변동후 잔액',
    ref_order_no        VARCHAR(50)   COMMENT '관련 주문번호',
    remark              VARCHAR(200)  COMMENT '변동사유',
    reg_id              VARCHAR(50)   NOT NULL COMMENT '등록자ID',
    reg_dt              DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    PRIMARY KEY (money_hist_id),
    KEY IX_MEMBER_ID (member_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='맛팜머니 변동 로그';

-- 5. 일간 정산 테이블 (TB_SETTLEMENT) 백엔드 VO/Mapper 동기화 
-- (v1에서 생성된 tb_settlement를 Mapper 필드명에 맞추어 재생성)
DROP TABLE IF EXISTS tb_settlement;
CREATE TABLE tb_settlement (
    settle_id           BIGINT        NOT NULL AUTO_INCREMENT COMMENT '정산ID',
    settle_date         VARCHAR(8)    NOT NULL COMMENT '정산기준일자(yyyyMMdd)',
    seller_member_id    BIGINT        NOT NULL COMMENT '판매자회원ID(입점업체)',
    op_type             VARCHAR(20)   NOT NULL COMMENT '운영타입',
    
    order_count         INT           NOT NULL DEFAULT 0 COMMENT '총 주문 건수',
    settle_amt          DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '정산금액(공급가액)',
    vat_amt             DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '부가세 합계',
    total_settle_amt    DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '총 정산금액(결제금액)',
    
    settle_status_cd    VARCHAR(20)   NOT NULL DEFAULT 'WAIT' COMMENT '정산상태(WAIT, COMPLETE)',
    
    reg_id              VARCHAR(50)   NOT NULL COMMENT '등록자',
    reg_dt              DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    mod_id              VARCHAR(50)   COMMENT '수정자',
    mod_dt              DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    
    PRIMARY KEY (settle_id),
    UNIQUE KEY UQ_SETTLE_DATE_SELLER (settle_date, seller_member_id, op_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='일간 자동 정산 데이터';

-- 6. 테스트용 샘플 데이터 추가
-- (이미 TB_MEMBER 계정이 있다고 가정, 머니 충전 마중물 데이터)
UPDATE TB_MEMBER SET MEAT_MONEY = 1000000 WHERE MEMBER_ID = 2; -- 테스트 구매자 머니 지급
