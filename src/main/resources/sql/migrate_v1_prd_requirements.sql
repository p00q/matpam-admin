/* =========================================================
 * Matpam 프로젝트 PRD 반영 마이그레이션 SQL
 * =======================================================*/

USE matpam;

-- 1. 회원 테이블: 운영 타입(배송유형) 컬럼 추가
-- 전국택배(DELIVERY_PARCEL), 전북직배송(DELIVERY_FREIGHT), 공장직판(DELIVERY_FACTORY) 구분용
ALTER TABLE tb_member 
ADD COLUMN delivery_type_cd VARCHAR(30) NULL COMMENT '배송/운영유형코드(공통코드: DELIVERY_TYPE)' AFTER member_type_cd;

-- 2. 구성상품 테이블: 부가세 처리 고도화
-- 기존 vat_rate (부가세율) 필드가 있으나, 명시적인 비과세 여부 플래그 추가 (필요 시)
-- 여기서는 기존 sale_type_cd (SALE_RAW: 원물/비과세, SALE_PROCESS: 가공/과세)를 활용하기로 결정.
-- 별도의 비과세 여부 필드가 필요하다면 아래 주석 해제 후 실행
-- ALTER TABLE tb_component_product ADD COLUMN tax_free_yn CHAR(1) DEFAULT 'N' COMMENT '비과세여부(Y/N)';

-- 3. 머니 이용 내역 테이블 (사용자별 예치금 히스토리)
CREATE TABLE IF NOT EXISTS tb_money_history (
    money_hist_id   BIGINT         NOT NULL AUTO_INCREMENT COMMENT '머니이력ID',
    member_id       BIGINT         NOT NULL COMMENT '회원ID',
    trx_type_cd     VARCHAR(30)    NOT NULL COMMENT '거래유형(CHARGE:충전, PAYMENT:결제, CANCEL:취소)',
    change_amt      DECIMAL(18,2)  NOT NULL COMMENT '변동금액',
    balance         DECIMAL(18,2)  NOT NULL COMMENT '거래후잔액',
    ref_order_no    VARCHAR(50)             COMMENT '참조주문번호',
    remark          VARCHAR(500)            COMMENT '비고',
    
    reg_id          VARCHAR(20)    NOT NULL COMMENT '등록자ID',
    reg_dt          DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    
    PRIMARY KEY (money_hist_id),
    CONSTRAINT FK_MONEY_HIST_MEMBER FOREIGN KEY (member_id) REFERENCES tb_member(member_id),
    KEY IX_MONEY_HIST_MEMBER_DT (member_id, reg_dt)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='머니 변동 이력';

-- 4. 일 단위 정산 테이블
CREATE TABLE IF NOT EXISTS tb_settlement (
    settle_id       BIGINT         NOT NULL AUTO_INCREMENT COMMENT '정산ID',
    settle_date     DATE           NOT NULL COMMENT '정산일자(YYYY-MM-DD)',
    seller_id       BIGINT         NOT NULL COMMENT '판매자ID',
    
    total_sale_amt  DECIMAL(18,2)  NOT NULL DEFAULT 0 COMMENT '총판매금액(부가세포함)',
    supply_amt      DECIMAL(18,2)  NOT NULL DEFAULT 0 COMMENT '공급가액합계',
    vat_amt         DECIMAL(18,2)  NOT NULL DEFAULT 0 COMMENT '부가세합계',
    order_cnt       INT            NOT NULL DEFAULT 0 COMMENT '주문건수',
    
    status_cd       VARCHAR(30)    NOT NULL DEFAULT 'READY' COMMENT '정산상태(READY, COMPLETED)',
    
    reg_dt          DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    mod_dt          DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    
    PRIMARY KEY (settle_id),
    UNIQUE KEY UQ_SETTLE_DATE_SELLER (settle_date, seller_id),
    KEY IX_SETTLE_DATE (settle_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='일 단위 정산 정보';
