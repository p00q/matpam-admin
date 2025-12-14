/* =========================================================
 * 1. 기존 테이블 삭제 (FK 의존성 순서: 상세 → 코드 → 그룹)
 * =======================================================*/

use MATPam;

DROP TABLE IF EXISTS tb_detail_code;
DROP TABLE IF EXISTS tb_code;
DROP TABLE IF EXISTS tb_group_code;

/* =========================================================
 * 2. 그룹코드 테이블
 * =======================================================*/
CREATE TABLE tb_group_code (
    CODE_GROUP_ID    VARCHAR(30)  NOT NULL COMMENT '코드그룹ID',
    CODE_GROUP_NAME  VARCHAR(100) NOT NULL COMMENT '코드그룹명',
    USE_YN           CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    REG_ID           VARCHAR(20)  NOT NULL COMMENT '등록자ID',
    MOD_ID           VARCHAR(20)  NULL COMMENT '수정자ID',
    REG_DATE         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    MOD_DATE         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
                                   ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    DEL_YN           CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (CODE_GROUP_ID),
    UNIQUE KEY UQ_TB_GROUP_CODE_NAME (CODE_GROUP_NAME)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='공통 코드그룹';

/* =========================================================
 * 3. 코드 테이블
 * =======================================================*/
CREATE TABLE tb_code (
    CODE_GROUP_ID   VARCHAR(30)   NOT NULL COMMENT '코드그룹ID',
    CODE_ID         VARCHAR(30)   NOT NULL COMMENT '코드ID',
    CODE_NAME       VARCHAR(100)  NOT NULL COMMENT '코드명',
    SORT_ORDER      INT           NOT NULL DEFAULT 0 COMMENT '정렬순서',
    USE_YN          CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    REG_ID          VARCHAR(20)   NOT NULL COMMENT '등록자ID',
    MOD_ID          VARCHAR(20)   NULL COMMENT '수정자ID',
    REG_DATE        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    MOD_DATE        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
                                   ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    DEL_YN          CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',

    PRIMARY KEY (CODE_GROUP_ID, CODE_ID),

    CONSTRAINT FK_TB_CODE_GROUP
        FOREIGN KEY (CODE_GROUP_ID)
        REFERENCES tb_group_code (CODE_GROUP_ID)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='공통 코드';

/* 인덱스 추가 (조회용) */
CREATE INDEX IX_TB_CODE_GROUP_USE
    ON tb_code (CODE_GROUP_ID, USE_YN, SORT_ORDER);

/* =========================================================
 * 4. 상세코드 테이블
 * =======================================================*/
CREATE TABLE tb_detail_code (
    CODE_GROUP_ID      VARCHAR(30)   NOT NULL COMMENT '코드그룹ID',
    CODE_ID            VARCHAR(30)   NOT NULL COMMENT '코드ID',
    DETAIL_CODE_ID     VARCHAR(30)   NOT NULL COMMENT '상세코드ID',
    DETAIL_CODE_NAME   VARCHAR(100)  NOT NULL COMMENT '상세코드명',
    SORT_ORDER         INT           NOT NULL DEFAULT 0 COMMENT '정렬순서',
    USE_YN             CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    REG_ID             VARCHAR(20)   NOT NULL COMMENT '등록자ID',
    MOD_ID             VARCHAR(20)   NULL COMMENT '수정자ID',
    REG_DATE           DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    MOD_DATE           DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
                                      ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    DEL_YN             CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',

    PRIMARY KEY (CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID),

    CONSTRAINT FK_TB_DETAIL_CODE_CODE
        FOREIGN KEY (CODE_GROUP_ID, CODE_ID)
        REFERENCES tb_code (CODE_GROUP_ID, CODE_ID)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='공통 상세코드';

/* 인덱스 추가 (조회용) */
CREATE INDEX IX_TB_DETAIL_CODE_GROUP_USE
    ON tb_detail_code (CODE_GROUP_ID, CODE_ID, USE_YN, SORT_ORDER);




INSERT INTO tb_group_code
(CODE_GROUP_ID, CODE_GROUP_NAME, USE_YN, REG_ID)
VALUES
('PRODUCT_TYPE',  '상품유형',   'Y', 'SYSTEM'),
('CATEGORY',      '카테고리',   'Y', 'SYSTEM'),
('MEMBER_TYPE',   '회원타입',   'Y', 'SYSTEM'),
('JOIN_STATUS',   '가입상태',   'Y', 'SYSTEM'),
('MEMBER_GRADE',  '회원등급',   'Y', 'SYSTEM'),
('DELIVERY_TYPE', '배송유형',   'Y', 'SYSTEM'),
('SALE_STATUS',   '판매상태',   'Y', 'SYSTEM');


INSERT INTO tb_code
(CODE_GROUP_ID, CODE_ID, CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('PRODUCT_TYPE', 'STORAGE_TYPE',   '저장유형',       10, 'Y', 'SYSTEM'),
('PRODUCT_TYPE', 'CUT_TYPE',       '분리유형',       20, 'Y', 'SYSTEM'),
('PRODUCT_TYPE', 'PROCESS_TYPE',   '처리유형',       30, 'Y', 'SYSTEM'),
('PRODUCT_TYPE', 'UNIT_TYPE',      '단위구분유형',   40, 'Y', 'SYSTEM');


INSERT INTO tb_code
(CODE_GROUP_ID, CODE_ID, CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('CATEGORY', 'INQUIRY_TYPE',            '문의',             10, 'Y', 'SYSTEM'),
('CATEGORY', 'QNA_TYPE',                'QNA',              20, 'Y', 'SYSTEM'),
('CATEGORY', 'PRODUCT_CATEGORY',        '상품',             30, 'Y', 'SYSTEM'),
('CATEGORY', 'FINISHED_PRODUCT_CAT',    '완가공품',         40, 'Y', 'SYSTEM'),
('CATEGORY', 'BEEF_CATEGORY',           '소고기',           50, 'Y', 'SYSTEM'),
('CATEGORY', 'PORK_CATEGORY',           '돼지고기',         60, 'Y', 'SYSTEM'),
('CATEGORY', 'MISC_CATEGORY',           '기타',             70, 'Y', 'SYSTEM');

INSERT INTO tb_code
(CODE_GROUP_ID, CODE_ID, CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('MEMBER_TYPE', 'MEMBER_ROLE',   '회원타입',    10, 'Y', 'SYSTEM'),
('MEMBER_TYPE', 'ADMIN_ROLE',    '관리자타입',  20, 'Y', 'SYSTEM'),
('MEMBER_TYPE', 'SELLER_ROLE',   '판매자타입',  30, 'Y', 'SYSTEM'),
('MEMBER_TYPE', 'PROCESSOR_ROLE','가공자타입',  40, 'Y', 'SYSTEM');


INSERT INTO tb_code
(CODE_GROUP_ID, CODE_ID, CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('JOIN_STATUS',   'JOIN_STATUS',   '가입상태',   10, 'Y', 'SYSTEM'),
('MEMBER_GRADE',  'MEMBER_GRADE',  '회원등급',   10, 'Y', 'SYSTEM');


INSERT INTO tb_code
(CODE_GROUP_ID, CODE_ID, CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('DELIVERY_TYPE', 'DELIVERY_PARCEL',   '택배',       10, 'Y', 'SYSTEM'),
('DELIVERY_TYPE', 'DELIVERY_FREIGHT',  '화물',       20, 'Y', 'SYSTEM'),
('DELIVERY_TYPE', 'DELIVERY_FACTORY',  '공장',       30, 'Y', 'SYSTEM'),
('SALE_STATUS',   'SALE_STATUS',       '판매상태',   10, 'Y', 'SYSTEM'),
('SALE_STATUS',   'SALE_TYPE',         '판매유형',   20, 'Y', 'SYSTEM');

INSERT INTO tb_detail_code
(CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('PRODUCT_TYPE','STORAGE_TYPE','CHILLED', '냉장', 1, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','STORAGE_TYPE','FROZEN',  '냉동', 2, 'Y', 'SYSTEM');


INSERT INTO tb_detail_code
(CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('PRODUCT_TYPE','CUT_TYPE','CUT_BULSAL_HEOMIL',   '불살+허밑살',  1, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','CUT_TYPE','CUT_DUHANGJUNG',      '두항정',       2, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','CUT_TYPE','CUT_DWITMI',          '뒷미',         3, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','CUT_TYPE','CUT_INTESTINE_MIX',   '내장모듬',     4, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','CUT_TYPE','CUT_SAEKKIBO',        '새끼보',       5, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','CUT_TYPE','CUT_SOUP_KIT',        '국밥키트',     6, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','CUT_TYPE','CUT_SUNDAE',          '순대',         7, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','CUT_TYPE','CUT_HEOPA',           '허파',         8, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','CUT_TYPE','CUT_LIVER',           '간',           9, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','CUT_TYPE','CUT_OSORI',           '오소리감투',  10, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','CUT_TYPE','CUT_HEART',           '염통',        11, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','CUT_TYPE','CUT_BULSAL',          '불살',        12, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','CUT_TYPE','CUT_DAECHANG',        '대창',        13, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','CUT_TYPE','CUT_DWITGOGI',        '뒷고기',      14, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','CUT_TYPE','CUT_HEAD',            '머리',        15, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','CUT_TYPE','CUT_MAKCHANG',        '막창',        16, 'Y', 'SYSTEM');

INSERT INTO tb_detail_code
(CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('PRODUCT_TYPE','PROCESS_TYPE','PROC_FINISHED',    '완가공품', 1, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','PROCESS_TYPE','PROC_MARINATED',   '양념',     2, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','PROCESS_TYPE','PROC_COOKED_SLICE','가열세절', 3, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','PROCESS_TYPE','PROC_COOKED',      '가열',     4, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','PROCESS_TYPE','PROC_TRIM',        '정형',     5, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','PROCESS_TYPE','PROC_WASH_TRIM',   '세척손질', 6, 'Y', 'SYSTEM');

INSERT INTO tb_detail_code
(CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('PRODUCT_TYPE','UNIT_TYPE','UNIT_EA', 'EA', 1, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','UNIT_TYPE','UNIT_G',  'G',  2, 'Y', 'SYSTEM'),
('PRODUCT_TYPE','UNIT_TYPE','UNIT_KG', 'KG', 3, 'Y', 'SYSTEM');



INSERT INTO tb_detail_code
(CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('CATEGORY','INQUIRY_TYPE','INQ_ORDER',    '주문', 1, 'Y', 'SYSTEM'),
('CATEGORY','INQUIRY_TYPE','INQ_DELIVERY', '배송', 2, 'Y', 'SYSTEM'),
('CATEGORY','INQUIRY_TYPE','INQ_LIVE',     '환불', 3, 'Y', 'SYSTEM'),
('CATEGORY','INQUIRY_TYPE','INQ_PRODUCT',  '상품', 4, 'Y', 'SYSTEM');


INSERT INTO tb_detail_code
(CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('CATEGORY','QNA_TYPE','QNA_ORDER',    '주문', 1, 'Y', 'SYSTEM'),
('CATEGORY','QNA_TYPE','QNA_DELIVERY', '배송', 2, 'Y', 'SYSTEM'),
('CATEGORY','QNA_TYPE','QNA_LIVE',     '환불', 3, 'Y', 'SYSTEM'),
('CATEGORY','QNA_TYPE','QNA_PRODUCT',  '상품', 4, 'Y', 'SYSTEM'),
('CATEGORY','QNA_TYPE','QNA_ETC',      '기타', 5, 'Y', 'SYSTEM');


INSERT INTO tb_detail_code
(CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('CATEGORY','PRODUCT_CATEGORY','CAT_PROCESS_METHOD', '가공방법', 1, 'Y', 'SYSTEM'),
('CATEGORY','PRODUCT_CATEGORY','CAT_PORK',           '돼지고기', 2, 'Y', 'SYSTEM'),
('CATEGORY','PRODUCT_CATEGORY','CAT_BEEF',           '소고기',   3, 'Y', 'SYSTEM'),
('CATEGORY','PRODUCT_CATEGORY','CAT_FINISHED',       '완가공품', 4, 'Y', 'SYSTEM');

INSERT INTO tb_detail_code
(CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('CATEGORY','FINISHED_PRODUCT_CAT','CAT_SUNDAE',       '순대류',        1, 'Y', 'SYSTEM'),
('CATEGORY','FINISHED_PRODUCT_CAT','CAT_READY_TO_COOK','즉석조리식품',  2, 'Y', 'SYSTEM'),
('CATEGORY','FINISHED_PRODUCT_CAT','CAT_EXHIBITION',   '전열상품',      3, 'Y', 'SYSTEM');

INSERT INTO tb_detail_code
(CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('CATEGORY','BEEF_CATEGORY','BEEF_MEAT',      '소정육',    1, 'Y', 'SYSTEM'),
('CATEGORY','BEEF_CATEGORY','BEEF_TRIPES',    '소내장',    2, 'Y', 'SYSTEM'),
('CATEGORY','BEEF_CATEGORY','BEEF_HEAD',      '소머리',    3, 'Y', 'SYSTEM'),
('CATEGORY','BEEF_CATEGORY','BEEF_TRIM',      '정형',      4, 'Y', 'SYSTEM'),
('CATEGORY','BEEF_CATEGORY','BEEF_WASH_TRIM', '세척손질',  5, 'Y', 'SYSTEM');

INSERT INTO tb_detail_code
(CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('CATEGORY','PORK_CATEGORY','PORK_MEAT',   '돼지정육', 1, 'Y', 'SYSTEM'),
('CATEGORY','PORK_CATEGORY','PORK_TRIPES', '돼지내장', 2, 'Y', 'SYSTEM'),
('CATEGORY','PORK_CATEGORY','PORK_HEAD',   '돼지머리', 3, 'Y', 'SYSTEM');

INSERT INTO tb_detail_code
(CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('CATEGORY','MISC_CATEGORY','MISC_BOILED',        '삶은',      1,  'Y', 'SYSTEM'),
('CATEGORY','MISC_CATEGORY','MISC_OIL',           '오일',      2,  'Y', 'SYSTEM'),
('CATEGORY','MISC_CATEGORY','MISC_ETC',           '기타',      3,  'Y', 'SYSTEM'),
('CATEGORY','MISC_CATEGORY','MISC_SPECIAL_PART',  '특수부위',  4,  'Y', 'SYSTEM'),
('CATEGORY','MISC_CATEGORY','MISC_BEEF',          '소고기',    5,  'Y', 'SYSTEM'),
('CATEGORY','MISC_CATEGORY','MISC_EAR',           '귀',        6,  'Y', 'SYSTEM'),
('CATEGORY','MISC_CATEGORY','MISC_CHEEK',         '볼',        7,  'Y', 'SYSTEM'),
('CATEGORY','MISC_CATEGORY','MISC_TONGUE',        '혀',        8,  'Y', 'SYSTEM'),
('CATEGORY','MISC_CATEGORY','MISC_SUNDAE',        '순대',      9,  'Y', 'SYSTEM'),
('CATEGORY','MISC_CATEGORY','MISC_PORK',          '돼지고기', 10,  'Y', 'SYSTEM'),
('CATEGORY','MISC_CATEGORY','MISC_SOUP',          '국밥',     11,  'Y', 'SYSTEM'),
('CATEGORY','MISC_CATEGORY','MISC_GRILL',         '구이용',   12,  'Y', 'SYSTEM'),
('CATEGORY','MISC_CATEGORY','MISC_BUNSIK',        '분식용',   13,  'Y', 'SYSTEM'),
('CATEGORY','MISC_CATEGORY','MISC_GOCHUJANG',     '고추장',   14,  'Y', 'SYSTEM'),
('CATEGORY','MISC_CATEGORY','MISC_GANJANG',       '간장',     15,  'Y', 'SYSTEM');


-- MEMBER_ROLE (회원타입)
INSERT INTO tb_detail_code
(CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('MEMBER_TYPE','MEMBER_ROLE','ROLE_ADMIN',  '관리자', 1, 'Y', 'SYSTEM'),
('MEMBER_TYPE','MEMBER_ROLE','ROLE_SELLER', '판매자', 2, 'Y', 'SYSTEM'),
('MEMBER_TYPE','MEMBER_ROLE','ROLE_BUYER',  '구매자', 3, 'Y', 'SYSTEM');

-- ADMIN_ROLE (관리자타입)
INSERT INTO tb_detail_code
(CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('MEMBER_TYPE','ADMIN_ROLE','ADMIN_PARCEL',  '택배관리자',      1, 'Y', 'SYSTEM'),
('MEMBER_TYPE','ADMIN_ROLE','ADMIN_FREIGHT', '화물관리자',      2, 'Y', 'SYSTEM'),
('MEMBER_TYPE','ADMIN_ROLE','ADMIN_PICKUP',  '직접수령관리자',  3, 'Y', 'SYSTEM');

-- SELLER_ROLE (판매자타입)
INSERT INTO tb_detail_code
(CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('MEMBER_TYPE','SELLER_ROLE','SELLER_RAW',     '원물판매자', 1, 'Y', 'SYSTEM'),
('MEMBER_TYPE','SELLER_ROLE','SELLER_PROCESS', '가공판매자', 2, 'Y', 'SYSTEM');


INSERT INTO tb_detail_code
(CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('JOIN_STATUS','JOIN_STATUS','JOIN_WAIT',    '승인대기', 1, 'Y', 'SYSTEM'),
('JOIN_STATUS','JOIN_STATUS','JOIN_ACTIVE',  '가입',     2, 'Y', 'SYSTEM'),
('JOIN_STATUS','JOIN_STATUS','JOIN_DORMANT', '휴면',     3, 'Y', 'SYSTEM'),
('JOIN_STATUS','JOIN_STATUS','JOIN_LEAVE',   '회원탈퇴', 4, 'Y', 'SYSTEM');

INSERT INTO tb_detail_code
(CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('MEMBER_GRADE','MEMBER_GRADE','GRADE_NORMAL',  '일반',       1, 'Y', 'SYSTEM'),
('MEMBER_GRADE','MEMBER_GRADE','GRADE_SILVER',  '실버',       2, 'Y', 'SYSTEM'),
('MEMBER_GRADE','MEMBER_GRADE','GRADE_GOLD',    '골드',       3, 'Y', 'SYSTEM'),
('MEMBER_GRADE','MEMBER_GRADE','GRADE_DIAMOND', '다이아몬드', 4, 'Y', 'SYSTEM'),
('MEMBER_GRADE','MEMBER_GRADE','GRADE_VVIP',    'VVIP',       5, 'Y', 'SYSTEM');

INSERT INTO tb_detail_code
(CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('DELIVERY_TYPE','DELIVERY_PARCEL',  'DELIVERY_PARCEL',  '택배',   1, 'Y', 'SYSTEM'),
('DELIVERY_TYPE','DELIVERY_FREIGHT', 'DELIVERY_FREIGHT', '화물',   1, 'Y', 'SYSTEM'),
('DELIVERY_TYPE','DELIVERY_FACTORY', 'DELIVERY_FACTORY', '공장',   1, 'Y', 'SYSTEM');

-- 판매상태
INSERT INTO tb_detail_code
(CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('SALE_STATUS','SALE_STATUS','SALE_ON',   '판매중',   1, 'Y', 'SYSTEM'),
('SALE_STATUS','SALE_STATUS','SALE_STOP', '판매중지', 2, 'Y', 'SYSTEM'),
('SALE_STATUS','SALE_STATUS','SALE_END',  '판매종료', 3, 'Y', 'SYSTEM');

-- 판매유형
INSERT INTO tb_detail_code
(CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID)
VALUES
('SALE_STATUS','SALE_TYPE','SALE_RAW',     '원물', 1, 'Y', 'SYSTEM'),
('SALE_STATUS','SALE_TYPE','SALE_PROCESS', '가공', 2, 'Y', 'SYSTEM');




/* =========================================================
 * 1. 회원 마스터
 * =======================================================*/
DROP TABLE IF EXISTS tb_member;
DROP TABLE IF EXISTS tb_member_leave_hist;
DROP TABLE IF EXISTS tb_member_login_hist;
DROP TABLE IF EXISTS tb_bundle_product;

CREATE TABLE tb_member (
    member_id        BIGINT       NOT NULL AUTO_INCREMENT COMMENT '회원ID',
    member_type_cd   VARCHAR(30)  NOT NULL COMMENT '회원타입코드(공통코드: MEMBER_TYPE)',
    login_id         VARCHAR(50)  NOT NULL COMMENT '로그인ID',
    login_pwd        VARCHAR(200) NOT NULL COMMENT '비밀번호해시',
    company_name     VARCHAR(200) NOT NULL COMMENT '업체명',
    ceo_name         VARCHAR(100) NOT NULL COMMENT '대표명',
    biz_reg_no       VARCHAR(20)  NOT NULL COMMENT '사업자등록번호',
    company_tel_no   VARCHAR(20)           COMMENT '회사전화번호',
    ceo_mobile_no    VARCHAR(20)           COMMENT '대표자 휴대폰번호',
    email            VARCHAR(200)          COMMENT '대표 이메일주소',
    zip_code         VARCHAR(10)           COMMENT '우편번호',
    addr1            VARCHAR(200)          COMMENT '기본주소',
    addr2            VARCHAR(200)          COMMENT '상세주소',
    last_login_dt    DATETIME              COMMENT '최근접속일시',
    member_grade_cd  VARCHAR(30)  NOT NULL COMMENT '회원등급코드(공통코드: MEMBER_GRADE)',
    join_status_cd   VARCHAR(30)  NOT NULL COMMENT '가입상태코드(공통코드: JOIN_STATUS)',
    join_dt          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '가입일시',
    withdraw_dt      DATETIME              COMMENT '탈퇴일시',
    remark           VARCHAR(500)          COMMENT '비고',

    use_yn           CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn           CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id           VARCHAR(20)  NOT NULL COMMENT '등록자ID',
    reg_dt           DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id           VARCHAR(20)           COMMENT '수정자ID',
    mod_dt           DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
                                              ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_MEMBER PRIMARY KEY (member_id),

    CONSTRAINT UQ_TB_MEMBER_LOGIN_ID  UNIQUE (login_id),
    CONSTRAINT UQ_TB_MEMBER_BIZ_REG_NO UNIQUE (biz_reg_no),

    KEY IX_TB_MEMBER_TYPE_STATUS (member_type_cd, join_status_cd, member_grade_cd),
    KEY IX_TB_MEMBER_COMPANY     (company_name),
    KEY IX_TB_MEMBER_JOIN_DT     (join_dt)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='회원 마스터';
  

/* =========================================================
 * 2. 회원 여신/미트머니 정보
 * =======================================================*/
DROP TABLE IF EXISTS tb_member_credit;

CREATE TABLE tb_member_credit (
    member_id           BIGINT        NOT NULL COMMENT '회원ID',
    credit_contract_dt  DATE                   COMMENT '여신약정일',
    credit_limit_amt    DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '여신제공액',
    meat_money_balance  DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '미트머니 잔액',
    total_order_amt     DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '누적주문금액',
    month_order_amt     DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '월구매금액',
    year_order_amt      DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '연간구매금액',
    last_calc_ym        CHAR(6)                COMMENT '마지막집계년월(YYYYMM)',

    use_yn              CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn              CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id              VARCHAR(20)   NOT NULL COMMENT '등록자ID',
    reg_dt              DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id              VARCHAR(20)            COMMENT '수정자ID',
    mod_dt              DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
                                                ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_MEMBER_CREDIT PRIMARY KEY (member_id),

    CONSTRAINT FK_TB_MEMBER_CREDIT_MEMBER
        FOREIGN KEY (member_id)
        REFERENCES tb_member (member_id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='회원 여신/미트머니 정보';


/* =========================================================
 * 3. 회원 담당자 정보
 * =======================================================*/
DROP TABLE IF EXISTS tb_member_contact;

CREATE TABLE tb_member_contact (
    contact_id        BIGINT       NOT NULL AUTO_INCREMENT COMMENT '담당자ID',
    member_id         BIGINT       NOT NULL COMMENT '회원ID',
    contact_type_cd   VARCHAR(30)  NOT NULL COMMENT '담당자유형코드(예: 대표, 담당1, 담당2 등 공통코드)',
    contact_name      VARCHAR(100) NOT NULL COMMENT '담당자명',
    mobile_no         VARCHAR(20)          COMMENT '휴대폰번호',
    tel_no            VARCHAR(20)          COMMENT '전화번호',
    email             VARCHAR(200)         COMMENT '이메일주소',
    is_main_yn        CHAR(1)     NOT NULL DEFAULT 'N' COMMENT '메인담당여부(Y/N)',

    use_yn            CHAR(1)     NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn            CHAR(1)     NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id            VARCHAR(20) NOT NULL COMMENT '등록자ID',
    reg_dt            DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id            VARCHAR(20)          COMMENT '수정자ID',
    mod_dt            DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP
                                            ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_MEMBER_CONTACT PRIMARY KEY (contact_id),

    CONSTRAINT FK_TB_MEMBER_CONTACT_MEMBER
        FOREIGN KEY (member_id)
        REFERENCES tb_member (member_id),

    KEY IX_TB_MEMBER_CONTACT_MEMBER  (member_id),
    KEY IX_TB_MEMBER_CONTACT_MAIN    (member_id, is_main_yn)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='회원 담당자 정보';


/* =========================================================
 * 4. 회원 약관/동의 정보
 * =======================================================*/
DROP TABLE IF EXISTS tb_member_agree;

CREATE TABLE tb_member_agree (
    agree_id        BIGINT       NOT NULL AUTO_INCREMENT COMMENT '동의ID',
    member_id       BIGINT       NOT NULL COMMENT '회원ID',
    agree_type_cd   VARCHAR(30)  NOT NULL COMMENT '동의유형코드(공통코드: AGREE_TYPE)',
    agree_yn        CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '동의여부(Y/N)',
    agree_dt        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '동의일시',
    expire_dt       DATETIME              COMMENT '만료/철회일시',

    use_yn          CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn          CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id          VARCHAR(20)  NOT NULL COMMENT '등록자ID',
    reg_dt          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id          VARCHAR(20)           COMMENT '수정자ID',
    mod_dt          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
                                            ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_MEMBER_AGREE PRIMARY KEY (agree_id),

    CONSTRAINT FK_TB_MEMBER_AGREE_MEMBER
        FOREIGN KEY (member_id)
        REFERENCES tb_member (member_id),

    KEY IX_TB_MEMBER_AGREE_MEMBER_TYPE (member_id, agree_type_cd, agree_yn)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='회원 약관/동의 정보';

    
    /* =========================================================
 * 회원 상태/탈퇴 이력
 * =======================================================*/
    
use matpam;

DROP TABLE IF EXISTS tb_member_status_hist;

CREATE TABLE tb_member_status_hist (
    status_hist_id      BIGINT       NOT NULL AUTO_INCREMENT COMMENT '회원상태이력ID',
    member_id           BIGINT       NOT NULL COMMENT '회원ID',
    prev_status_cd      VARCHAR(30)           COMMENT '이전 상태코드(JOIN_STATUS)',
    status_cd           VARCHAR(30)  NOT NULL COMMENT '변경 상태코드(JOIN_STATUS)',
    change_reason_cd    VARCHAR(30)           COMMENT '변경사유코드(공통코드: MEMBER_STATUS_REASON 등)',
    change_reason_desc  VARCHAR(1000)         COMMENT '변경사유 상세(자유기술)',
    change_type_cd      VARCHAR(30)           COMMENT '변경유형코드(JOIN, UPDATE, WITHDRAW 등 선택사항)',
    change_admin_id     VARCHAR(20)           COMMENT '처리관리자ID',
    change_dt           DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '상태변경일시',

    use_yn              CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn              CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id              VARCHAR(20)  NOT NULL COMMENT '등록자ID',
    reg_dt              DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id              VARCHAR(20)           COMMENT '수정자ID',
    mod_dt              DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
                                                ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_MEMBER_STATUS_HIST PRIMARY KEY (status_hist_id),

    CONSTRAINT FK_TB_MEMBER_STATUS_MEMBER
        FOREIGN KEY (member_id)
        REFERENCES tb_member (member_id),

    KEY IX_TB_MEMBER_STATUS_MEMBER (member_id, status_cd, change_dt)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='회원 상태/탈퇴 이력';

/* =========================================================
 * 1. 관리자 역할 마스터 (TB_ADMIN_ROLE)
 * =======================================================*/
DROP TABLE IF EXISTS tb_admin_role;

CREATE TABLE tb_admin_role (
    role_id        VARCHAR(30)   NOT NULL COMMENT '역할ID (예: SUPER_ADMIN, PARCEL_ADMIN)',
    role_name      VARCHAR(100)  NOT NULL COMMENT '역할명',
    role_desc      VARCHAR(500)           COMMENT '역할설명',
    is_system_yn   CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '시스템역할여부(Y:기본역할)',

    use_yn         CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn         CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id         VARCHAR(20)   NOT NULL COMMENT '등록자ID',
    reg_dt         DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id         VARCHAR(20)            COMMENT '수정자ID',
    mod_dt         DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
                                            ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_ADMIN_ROLE PRIMARY KEY (role_id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='관리자 역할 마스터';


/* =========================================================
 * 2. 관리자 메뉴 마스터 (TB_ADMIN_MENU)
 * =======================================================*/
DROP TABLE IF EXISTS tb_admin_menu;

CREATE TABLE tb_admin_menu (
    menu_id         VARCHAR(50)   NOT NULL COMMENT '메뉴ID',
    parent_menu_id  VARCHAR(50)            COMMENT '부모메뉴ID',
    menu_name       VARCHAR(100)  NOT NULL COMMENT '메뉴명',
    menu_path       VARCHAR(200)           COMMENT '메뉴경로(URL 또는 ROUTE)',
    sort_order      INT           NOT NULL DEFAULT 0 COMMENT '정렬순서',
    depth           INT           NOT NULL DEFAULT 1 COMMENT '메뉴레벨(1:대,2:중,3:소)',

    use_yn          CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn          CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id          VARCHAR(20)   NOT NULL COMMENT '등록자ID',
    reg_dt          DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id          VARCHAR(20)            COMMENT '수정자ID',
    mod_dt          DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
                                             ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_ADMIN_MENU PRIMARY KEY (menu_id),

    CONSTRAINT FK_TB_ADMIN_MENU_PARENT
        FOREIGN KEY (parent_menu_id)
        REFERENCES tb_admin_menu (menu_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='관리자 메뉴 마스터';


/* =========================================================
 * 3. 관리자 계정 (TB_ADMIN)
 * =======================================================*/
DROP TABLE IF EXISTS tb_admin;

CREATE TABLE tb_admin (
    admin_no        BIGINT        NOT NULL AUTO_INCREMENT COMMENT '관리자번호',
    admin_login_id  VARCHAR(50)   NOT NULL COMMENT '관리자로그인ID',
    admin_login_pw  VARCHAR(200)  NOT NULL COMMENT '비밀번호해시',
    admin_name      VARCHAR(100)  NOT NULL COMMENT '관리자명',
    admin_email     VARCHAR(200)           COMMENT '이메일',
    admin_mobile_no VARCHAR(20)            COMMENT '휴대폰번호',

    role_id         VARCHAR(30)   NOT NULL COMMENT '역할ID(FK: TB_ADMIN_ROLE)',

    status_cd       VARCHAR(30)   NOT NULL DEFAULT 'ACTIVE' COMMENT '관리자상태코드(공통코드: ADMIN_STATUS)',
    last_login_dt   DATETIME               COMMENT '최근로그인일시',

    use_yn          CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn          CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id          VARCHAR(20)   NOT NULL COMMENT '등록자ID',
    reg_dt          DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id          VARCHAR(20)            COMMENT '수정자ID',
    mod_dt          DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
                                             ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_ADMIN PRIMARY KEY (admin_no),

    CONSTRAINT UQ_TB_ADMIN_LOGIN_ID UNIQUE (admin_login_id),

    CONSTRAINT FK_TB_ADMIN_ROLE
        FOREIGN KEY (role_id)
        REFERENCES tb_admin_role (role_id),

    KEY IX_TB_ADMIN_STATUS (status_cd),
    KEY IX_TB_ADMIN_ROLE   (role_id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='관리자 계정';


/* =========================================================
 * 4. 역할별 메뉴 권한 (TB_ADMIN_ROLE_MENU_AUTH)
 * =======================================================*/
DROP TABLE IF EXISTS tb_admin_role_menu_auth;

CREATE TABLE tb_admin_role_menu_auth (
    role_id         VARCHAR(30)  NOT NULL COMMENT '역할ID',
    menu_id         VARCHAR(50)  NOT NULL COMMENT '메뉴ID',

    can_view_yn     CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '조회권한여부',
    can_create_yn   CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '등록권한여부',
    can_update_yn   CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '수정권한여부',
    can_delete_yn   CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제권한여부',
    can_approve_yn  CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '승인권한여부',

    use_yn          CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn          CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id          VARCHAR(20)  NOT NULL COMMENT '등록자ID',
    reg_dt          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id          VARCHAR(20)           COMMENT '수정자ID',
    mod_dt          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
                                            ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_ADMIN_ROLE_MENU_AUTH PRIMARY KEY (role_id, menu_id),

    CONSTRAINT FK_TB_ADMIN_ROLE_MENU_AUTH_ROLE
        FOREIGN KEY (role_id)
        REFERENCES tb_admin_role (role_id),

    CONSTRAINT FK_TB_ADMIN_ROLE_MENU_AUTH_MENU
        FOREIGN KEY (menu_id)
        REFERENCES tb_admin_menu (menu_id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='역할별 메뉴 권한';


/* =========================================================
 * 5. 역할별 배송유형 범위 (TB_ADMIN_ROLE_SCOPE)
 * =======================================================*/
DROP TABLE IF EXISTS tb_admin_role_scope;

CREATE TABLE tb_admin_role_scope (
    role_id          VARCHAR(30)  NOT NULL COMMENT '역할ID',
    delivery_type_cd VARCHAR(30)  NOT NULL COMMENT '배송유형코드(공통코드: DELIVERY_TYPE)',

    use_yn           CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn           CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id           VARCHAR(20)  NOT NULL COMMENT '등록자ID',
    reg_dt           DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id           VARCHAR(20)           COMMENT '수정자ID',
    mod_dt           DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
                                             ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_ADMIN_ROLE_SCOPE PRIMARY KEY (role_id, delivery_type_cd),

    CONSTRAINT FK_TB_ADMIN_ROLE_SCOPE_ROLE
        FOREIGN KEY (role_id)
        REFERENCES tb_admin_role (role_id)

    -- delivery_type_cd는 공통코드(TB_DETAIL_CODE)와 논리 FK 관계.
    -- 실제 FK는 그룹 조건(GROUP_ID='DELIVERY_TYPE')을 걸 수 없어서 논리적으로만 사용.
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='역할별 배송유형 권한 범위';
    

INSERT INTO tb_admin_role
(role_id, role_name, role_desc, is_system_yn, use_yn, del_yn, reg_id)
VALUES
('SUPER_ADMIN',   '수퍼관리자',        '전체 시스템 및 모든 기능을 관리하는 최상위 관리자', 'Y', 'Y', 'N', 'SYSTEM'),
('PARCEL_ADMIN',  '택배관리자',        '택배 배송유형의 상품/주문/회원 관련 기능만 관리',   'N', 'Y', 'N', 'SYSTEM'),
('FREIGHT_ADMIN', '화물관리자',        '화물 배송유형의 상품/주문/회원 관련 기능만 관리',   'N', 'Y', 'N', 'SYSTEM'),
('FACTORY_ADMIN', '공장수령관리자',    '공장수령 배송유형의 상품/주문/회원 관련 기능만 관리', 'N', 'Y', 'N', 'SYSTEM');
    
/* =========================================================
 * 1. 구성상품 마스터
 * =======================================================*/
DROP TABLE IF EXISTS tb_sales_product_detail;
DROP TABLE IF EXISTS tb_sales_product_image;
DROP TABLE IF EXISTS tb_sales_product_comp;
DROP TABLE IF EXISTS tb_sales_product;
DROP TABLE IF EXISTS tb_component_product;

CREATE TABLE tb_component_product (
    component_prod_id     BIGINT        NOT NULL AUTO_INCREMENT COMMENT '구성상품ID',
    component_prod_code   VARCHAR(50)   NOT NULL COMMENT '구성상품번호',
    component_prod_name   VARCHAR(200)  NOT NULL COMMENT '구성상품명',
    seller_member_id      BIGINT        NOT NULL COMMENT '판매자회원ID(FK: tb_member.member_id)',

    sale_type_cd          VARCHAR(30)   NOT NULL COMMENT '판매유형코드(원물/가공 등 공통코드)',
    storage_type_cd       VARCHAR(30)   NOT NULL COMMENT '저장유형코드(냉동/냉장 등)',
    cut_type_cd           VARCHAR(30)            COMMENT '분리유형코드(머리/내장모듬 등)',
    process_type_cd       VARCHAR(30)            COMMENT '처리유형코드(세척손질/가열 등)',
    unit_type_cd          VARCHAR(30)   NOT NULL COMMENT '단위구분코드(EA, KG, G 등)',

    list_price            DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '판매가격',
    cost_price            DECIMAL(18,2)          COMMENT '원가',
    vat_rate              DECIMAL(5,2)  NOT NULL DEFAULT 0 COMMENT '부가세율(예: 0.00, 10.00)',

    exposure_status_cd    VARCHAR(30)   NOT NULL COMMENT '노출상태코드(노출/비노출 등)',
    sale_status_cd        VARCHAR(30)   NOT NULL COMMENT '판매상태코드(판매중/중지/종료 등)',

    sale_start_dt         DATE                   COMMENT '판매시작일',
    sale_end_dt           DATE                   COMMENT '판매종료일',

    total_sale_qty        BIGINT       NOT NULL DEFAULT 0 COMMENT '총판매수량(반정규화)',

    use_yn                CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn                CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id                VARCHAR(20)  NOT NULL COMMENT '등록자ID',
    reg_dt                DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id                VARCHAR(20)           COMMENT '수정자ID',
    mod_dt                DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
                                              ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_COMPONENT_PRODUCT PRIMARY KEY (component_prod_id),
    CONSTRAINT UQ_TB_COMPONENT_PRODUCT_CODE UNIQUE (component_prod_code),

    CONSTRAINT FK_TB_COMPONENT_PRODUCT_MEMBER
        FOREIGN KEY (seller_member_id)
        REFERENCES tb_member (member_id),

    KEY IX_COMPONENT_SELLER_STATUS (seller_member_id, sale_status_cd, exposure_status_cd),
    KEY IX_COMPONENT_FILTER       (sale_type_cd, storage_type_cd, cut_type_cd, process_type_cd),
    KEY IX_COMPONENT_NAME         (component_prod_name)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='구성상품 마스터';


/* =========================================================
 * 2. 판매상품 마스터
 *    (화면 상단: 상품명/상품번호/판매가격/부가세/원가/노출여부/판매기간/조회수/판매자/상품요약/MD코멘트)
 * =======================================================*/
CREATE TABLE tb_sales_product (
    sales_prod_id      BIGINT        NOT NULL AUTO_INCREMENT COMMENT '판매상품ID',
    sales_prod_code    VARCHAR(50)   NOT NULL COMMENT '판매상품번호',
    sales_prod_name    VARCHAR(200)  NOT NULL COMMENT '판매상품명',
    seller_member_id   BIGINT        NOT NULL COMMENT '판매자회원ID(FK: tb_member.member_id)',

    list_price         DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '판매가격',
    cost_price         DECIMAL(18,2)          COMMENT '원가',
    vat_rate           DECIMAL(5,2)  NOT NULL DEFAULT 0 COMMENT '부가세율(0 또는 10 등)',
    exposure_status_cd VARCHAR(30)   NOT NULL COMMENT '노출상태코드',
    sale_status_cd     VARCHAR(30)   NOT NULL COMMENT '판매상태코드',

    sale_start_dt      DATE                   COMMENT '판매시작일',
    sale_end_dt        DATE                   COMMENT '판매종료일',

    view_cnt           BIGINT        NOT NULL DEFAULT 0 COMMENT '조회수',
    summary            VARCHAR(1000)          COMMENT '상품요약',
    md_comment         VARCHAR(2000)          COMMENT 'MD 코멘트',

    use_yn             CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn             CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id             VARCHAR(20)   NOT NULL COMMENT '등록자ID',
    reg_dt             DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id             VARCHAR(20)            COMMENT '수정자ID',
    mod_dt             DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
                                               ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_SALES_PRODUCT PRIMARY KEY (sales_prod_id),
    CONSTRAINT UQ_TB_SALES_PRODUCT_CODE UNIQUE (sales_prod_code),

    CONSTRAINT FK_TB_SALES_PRODUCT_MEMBER
        FOREIGN KEY (seller_member_id)
        REFERENCES tb_member (member_id),

    KEY IX_SALES_PRODUCT_STATUS (sale_status_cd, exposure_status_cd),
    KEY IX_SALES_PRODUCT_SELLER (seller_member_id),
    KEY IX_SALES_PRODUCT_NAME   (sales_prod_name)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='판매상품 마스터';


/* =========================================================
 * 3. 판매상품 구성상품 매핑 (상품 구성 목록 그리드)
 *    한 판매상품이 여러 구성상품으로 구성될 수 있음
 * =======================================================*/
CREATE TABLE tb_sales_product_comp (
    sales_prod_id       BIGINT        NOT NULL COMMENT '판매상품ID',
    component_prod_id   BIGINT        NOT NULL COMMENT '구성상품ID',
    comp_qty            DECIMAL(12,3) NOT NULL DEFAULT 1 COMMENT '구성수량(예: 4KG면 4, 1EA면 1 등)',
    sort_order          INT           NOT NULL DEFAULT 1 COMMENT '표시순서',

    use_yn              CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn              CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id              VARCHAR(20)   NOT NULL COMMENT '등록자ID',
    reg_dt              DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id              VARCHAR(20)            COMMENT '수정자ID',
    mod_dt              DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
                                                ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_SALES_PRODUCT_COMP PRIMARY KEY (sales_prod_id, component_prod_id),

    CONSTRAINT FK_TB_SALES_PRODUCT_COMP_SALES
        FOREIGN KEY (sales_prod_id)
        REFERENCES tb_sales_product (sales_prod_id)
        ON DELETE CASCADE,

    CONSTRAINT FK_TB_SALES_PRODUCT_COMP_COMPONENT
        FOREIGN KEY (component_prod_id)
        REFERENCES tb_component_product (component_prod_id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='판매상품-구성상품 매핑';


/* =========================================================
 * 4. 판매상품 이미지
 *    (UI: 이미지 5장까지 업로드 영역)
 * =======================================================*/
CREATE TABLE tb_sales_product_image (
    img_id          BIGINT        NOT NULL AUTO_INCREMENT COMMENT '이미지ID',
    sales_prod_id   BIGINT        NOT NULL COMMENT '판매상품ID',
    img_url         VARCHAR(500)  NOT NULL COMMENT '이미지경로(URL 또는 상대경로)',
    sort_order      INT           NOT NULL DEFAULT 1 COMMENT '정렬순서',
    is_main_yn      CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '대표이미지여부',

    use_yn          CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn          CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id          VARCHAR(20)   NOT NULL COMMENT '등록자ID',
    reg_dt          DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id          VARCHAR(20)            COMMENT '수정자ID',
    mod_dt          DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
                                            ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_SALES_PRODUCT_IMAGE PRIMARY KEY (img_id),

    CONSTRAINT FK_TB_SALES_PRODUCT_IMAGE
        FOREIGN KEY (sales_prod_id)
        REFERENCES tb_sales_product (sales_prod_id)
        ON DELETE CASCADE,

    KEY IX_SALES_PRODUCT_IMAGE (sales_prod_id, sort_order)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='판매상품 이미지';


/* =========================================================
 * 5. 판매상품 상세 설명/정책
 *    (상품 상세 설명 에디터 + 결제/배송/교환/환불 안내)
 * =======================================================*/
CREATE TABLE tb_sales_product_detail (
    sales_prod_id        BIGINT        NOT NULL COMMENT '판매상품ID',
    detail_html          LONGTEXT               COMMENT '상품 상세 설명(에디터 HTML)',

    payment_info         TEXT                   COMMENT '상품 결제 정보',
    delivery_info        TEXT                   COMMENT '배송 정보',
    return_info          TEXT                   COMMENT '교환/반품 정보',
    refund_info          TEXT                   COMMENT '환불 정보',

    use_yn               CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn               CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id               VARCHAR(20)   NOT NULL COMMENT '등록자ID',
    reg_dt               DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id               VARCHAR(20)            COMMENT '수정자ID',
    mod_dt               DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
                                                 ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_SALES_PRODUCT_DETAIL PRIMARY KEY (sales_prod_id),

    CONSTRAINT FK_TB_SALES_PRODUCT_DETAIL
        FOREIGN KEY (sales_prod_id)
        REFERENCES tb_sales_product (sales_prod_id)
        ON DELETE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='판매상품 상세 설명 및 정책';

    
    
/* =========================================================
 * 주문/배송 관련 테이블 삭제 (존재 시)
 * =======================================================*/
DROP TABLE IF EXISTS tb_order_delivery_factory;
DROP TABLE IF EXISTS tb_order_delivery_freight;
DROP TABLE IF EXISTS tb_order_delivery_parcel;
DROP TABLE IF EXISTS tb_order_item;
DROP TABLE IF EXISTS tb_order;


/* =========================================================
 * 1. 주문 헤더 (tb_order)
 * =======================================================*/
CREATE TABLE tb_order (
    order_id            BIGINT        NOT NULL AUTO_INCREMENT COMMENT '주문ID',
    order_no            VARCHAR(30)   NOT NULL COMMENT '주문번호(표시용)',
    buyer_member_id     BIGINT        NOT NULL COMMENT '구매회원ID(FK: tb_member.member_id)',
    order_dt            DATETIME      NOT NULL COMMENT '주문일시',

    order_status_cd     VARCHAR(30)   NOT NULL COMMENT '주문상태코드(ORDER_STATUS)',
    delivery_type_cd    VARCHAR(30)   NOT NULL COMMENT '배송유형코드(DELIVERY_TYPE: 택배/화물/공장수령 등)',
    delivery_status_cd  VARCHAR(30)   NOT NULL COMMENT '배송상태코드(DELIVERY_STATUS)',
    shipping_method_cd  VARCHAR(30)            COMMENT '배송방법코드(DIRECT/PARCEL 등)',
    payment_method_cd   VARCHAR(30)            COMMENT '결제수단코드(미트머니/계좌이체 등)',
    payment_status_cd   VARCHAR(30)            COMMENT '결제상태코드',

    goods_total_amt     DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '총주문금액(상품합계)',
    delivery_total_amt  DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '총배송비',
    discount_total_amt  DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '총할인금액',
    vat_total_amt       DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '총부가세액',
    pay_total_amt       DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '총결제금액',

    receiver_name       VARCHAR(100)  NOT NULL COMMENT '수취인명',
    receiver_mobile     VARCHAR(20)   NOT NULL COMMENT '수취인휴대폰',
    receiver_tel        VARCHAR(20)            COMMENT '수취인전화',
    zip_code            VARCHAR(10)   NOT NULL COMMENT '우편번호',
    addr1               VARCHAR(200)  NOT NULL COMMENT '기본주소',
    addr2               VARCHAR(200)           COMMENT '상세주소',
    region_sido_cd      VARCHAR(30)           COMMENT '시도코드',
    region_sigungu_cd   VARCHAR(30)           COMMENT '시군구코드',
    delivery_req_msg    VARCHAR(500)          COMMENT '배송요구사항',

    use_yn              CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn              CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id              VARCHAR(20)   NOT NULL COMMENT '등록자ID',
    reg_dt              DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id              VARCHAR(20)            COMMENT '수정자ID',
    mod_dt              DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
                                                ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_ORDER PRIMARY KEY (order_id),
    CONSTRAINT UQ_TB_ORDER_NO UNIQUE (order_no),

    CONSTRAINT FK_TB_ORDER_BUYER
        FOREIGN KEY (buyer_member_id)
        REFERENCES tb_member (member_id),

    KEY IX_TB_ORDER_DT_STATUS (order_dt, order_status_cd),
    KEY IX_TB_ORDER_DELIVERY  (delivery_type_cd, delivery_status_cd),
    KEY IX_TB_ORDER_BUYER     (buyer_member_id, order_dt)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='주문 헤더';


/* =========================================================
 * 2. 주문상품 라인 (tb_order_item)
 * =======================================================*/
CREATE TABLE tb_order_item (
    order_item_id       BIGINT        NOT NULL AUTO_INCREMENT COMMENT '주문상품ID',
    order_id            BIGINT        NOT NULL COMMENT '주문ID',
    line_no             INT           NOT NULL COMMENT '라인번호',

    sales_prod_id       BIGINT        NOT NULL COMMENT '판매상품ID',
    seller_member_id    BIGINT        NOT NULL COMMENT '판매자회원ID',

    sales_prod_name     VARCHAR(200)  NOT NULL COMMENT '판매상품명 스냅샷',
    storage_type_cd     VARCHAR(30)           COMMENT '저장유형코드(냉동/냉장)',
    process_type_cd     VARCHAR(30)           COMMENT '처리유형코드(세척손질 등)',
    cut_type_cd         VARCHAR(30)           COMMENT '분리유형코드(오소리감투 등)',
    unit_type_cd        VARCHAR(30)           COMMENT '단위구분코드(KG/EA 등)',
    unit_qty            DECIMAL(12,3) NOT NULL DEFAULT 1 COMMENT '단량(예: 2KG의 2)',
    order_qty           DECIMAL(12,3) NOT NULL DEFAULT 0 COMMENT '주문수량',

    list_unit_price     DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '정가단가',
    discount_unit_amt   DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '할인단가',
    sale_unit_price     DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '실판매단가',
    goods_amt           DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '상품금액',
    delivery_amt        DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '배송비(라인귀속분 또는 0)',
    vat_amt             DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '부가세액',
    pay_amt             DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '결제금액',

    use_yn              CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn              CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id              VARCHAR(20)   NOT NULL COMMENT '등록자ID',
    reg_dt              DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id              VARCHAR(20)            COMMENT '수정자ID',
    mod_dt              DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
                                                ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_ORDER_ITEM PRIMARY KEY (order_item_id),

    CONSTRAINT FK_TB_ORDER_ITEM_ORDER
        FOREIGN KEY (order_id)
        REFERENCES tb_order (order_id)
        ON DELETE CASCADE,

    CONSTRAINT FK_TB_ORDER_ITEM_SALES_PROD
        FOREIGN KEY (sales_prod_id)
        REFERENCES tb_sales_product (sales_prod_id),

    CONSTRAINT FK_TB_ORDER_ITEM_SELLER
        FOREIGN KEY (seller_member_id)
        REFERENCES tb_member (member_id),

    KEY IX_TB_ORDER_ITEM_ORDER   (order_id, line_no),
    KEY IX_TB_ORDER_ITEM_SALES   (sales_prod_id),
    KEY IX_TB_ORDER_ITEM_SELLER  (seller_member_id),
    KEY IX_TB_ORDER_ITEM_PRODUCT (storage_type_cd, process_type_cd, cut_type_cd, unit_type_cd)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='주문상품 라인';


/* =========================================================
 * 3. 택배 배송 정보 (tb_order_delivery_parcel)
 *    DELIVERY_TYPE = PARCEL 주문만 row 존재
 * =======================================================*/
CREATE TABLE tb_order_delivery_parcel (
    order_id            BIGINT       NOT NULL COMMENT '주문ID',
    courier_cd          VARCHAR(30)  NOT NULL COMMENT '택배사코드',
    tracking_no         VARCHAR(50)  NOT NULL COMMENT '운송장번호',
    delivery_region_cd  VARCHAR(30)          COMMENT '배송지역코드',
    shipped_dt          DATETIME             COMMENT '발송일시',
    delivered_dt        DATETIME             COMMENT '배송완료일시',

    use_yn              CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn              CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id              VARCHAR(20)  NOT NULL COMMENT '등록자ID',
    reg_dt              DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id              VARCHAR(20)          COMMENT '수정자ID',
    mod_dt              DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
                                              ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_ORDER_DELIVERY_PARCEL PRIMARY KEY (order_id),

    CONSTRAINT FK_TB_ORDER_DELIVERY_PARCEL
        FOREIGN KEY (order_id)
        REFERENCES tb_order (order_id)
        ON DELETE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='택배 배송 정보';


/* =========================================================
 * 4. 화물/직접배송 정보 (tb_order_delivery_freight)
 *    DELIVERY_TYPE = FREIGHT 주문만 row 존재
 * =======================================================*/
CREATE TABLE tb_order_delivery_freight (
    order_id            BIGINT       NOT NULL COMMENT '주문ID',
    shipping_method_cd  VARCHAR(30)  NOT NULL COMMENT '배송방법코드(DIRECT/THIRD_PARTY 등)',
    freight_company_name VARCHAR(100)         COMMENT '화물업체명',
    driver_name         VARCHAR(100)          COMMENT '운전기사명',
    driver_mobile       VARCHAR(20)           COMMENT '운전기사휴대폰',
    truck_no            VARCHAR(30)           COMMENT '차량번호',
    delivery_region_cd  VARCHAR(30)           COMMENT '배송지역코드',
    shipped_dt          DATETIME              COMMENT '출차일시',
    arrived_dt          DATETIME              COMMENT '도착일시',

    use_yn              CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn              CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id              VARCHAR(20)  NOT NULL COMMENT '등록자ID',
    reg_dt              DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id              VARCHAR(20)          COMMENT '수정자ID',
    mod_dt              DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
                                              ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_ORDER_DELIVERY_FREIGHT PRIMARY KEY (order_id),

    CONSTRAINT FK_TB_ORDER_DELIVERY_FREIGHT
        FOREIGN KEY (order_id)
        REFERENCES tb_order (order_id)
        ON DELETE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='화물/직접배송 정보';


/* =========================================================
 * 5. 공장수령 정보 (tb_order_delivery_factory)
 *    DELIVERY_TYPE = FACTORY_PICKUP 주문만 row 존재
 * =======================================================*/
CREATE TABLE tb_order_delivery_factory (
    order_id         BIGINT       NOT NULL COMMENT '주문ID',
    pickup_place_cd  VARCHAR(30)  NOT NULL COMMENT '픽업장소코드',
    pickup_dt        DATETIME             COMMENT '픽업일시',
    contact_name     VARCHAR(100)         COMMENT '담당자명',
    contact_mobile   VARCHAR(20)          COMMENT '담당자휴대폰',

    use_yn           CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn           CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id           VARCHAR(20)  NOT NULL COMMENT '등록자ID',
    reg_dt           DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id           VARCHAR(20)          COMMENT '수정자ID',
    mod_dt           DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
                                           ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_ORDER_DELIVERY_FACTORY PRIMARY KEY (order_id),

    CONSTRAINT FK_TB_ORDER_DELIVERY_FACTORY
        FOREIGN KEY (order_id)
        REFERENCES tb_order (order_id)
        ON DELETE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='공장수령(픽업) 정보';
    
    
/* =========================================================
 * 기존 테이블이 있으면 제거
 * =======================================================*/
DROP TABLE IF EXISTS tb_credit_history;
DROP TABLE IF EXISTS tb_credit_account;
DROP TABLE IF EXISTS tb_meatmoney_refund;
DROP TABLE IF EXISTS tb_meatmoney_deposit_req;
DROP TABLE IF EXISTS tb_meatmoney_txn;


/* =========================================================
 * 1. 미트머니 통합 내역(사용/적립/환불/여신정산) - 통장 개념
 *    화면: 미트머니관리 > 사용 내역
 * =======================================================*/
CREATE TABLE tb_meatmoney_txn (
    txn_id           BIGINT        NOT NULL AUTO_INCREMENT COMMENT '거래ID',
    member_id        BIGINT        NOT NULL COMMENT '회원ID(FK: tb_member.member_id)',
    txn_dt           DATETIME      NOT NULL COMMENT '거래일시',

    txn_type_cd      VARCHAR(30)   NOT NULL COMMENT '거래유형코드(MEAT_DEPOSIT, MEAT_WITHDRAW, ORDER_PAY, ORDER_CANCEL, CREDIT_USE, CREDIT_REPAY 등 공통코드)',
    io_type_cd       CHAR(1)       NOT NULL COMMENT '입출금구분(I:적립, O:사용)',
    summary          VARCHAR(200)  NOT NULL COMMENT '내역 요약(화면의 "내용")',

    order_id         BIGINT                 COMMENT '주문ID(상품구매/취소 시 연계)',
    deposit_req_id   BIGINT                 COMMENT '충전요청ID(입금 승인 시 연계)',
    refund_id        BIGINT                 COMMENT '환불ID(환불 처리 시 연계)',
    credit_hist_id   BIGINT                 COMMENT '여신이력ID(여신 정산/사용 연계)',

    use_amt          DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '사용 금액(출금액, 화면의 사용 금액)',
    earn_amt         DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '적립 금액(입금/증액, 화면의 적립 금액)',
    balance_amt      DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '거래 후 미트머니 잔액',

    use_yn           CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn           CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id           VARCHAR(20)   NOT NULL COMMENT '등록자ID',
    reg_dt           DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id           VARCHAR(20)            COMMENT '수정자ID',
    mod_dt           DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
                                             ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_MEATMONEY_TXN PRIMARY KEY (txn_id),

    CONSTRAINT FK_TB_MEATMONEY_TXN_MEMBER
        FOREIGN KEY (member_id)
        REFERENCES tb_member (member_id),

    KEY IX_MEATMONEY_TXN_MEMBER_DT (member_id, txn_dt),
    KEY IX_MEATMONEY_TXN_TYPE      (txn_type_cd),
    KEY IX_MEATMONEY_TXN_ORDER     (order_id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='미트머니 거래 내역(사용/충전/환불/여신정산 통합)';


/* =========================================================
 * 2. 미트머니 충전 요청(입금 확인/입금 내역 확인 탭)
 *    상태: PENDING(입금대기중), APPROVED(입금), CANCELED(취소)
 * =======================================================*/
CREATE TABLE tb_meatmoney_deposit_req (
    deposit_req_id   BIGINT        NOT NULL AUTO_INCREMENT COMMENT '충전요청ID',
    member_id        BIGINT        NOT NULL COMMENT '회원ID',
    req_dt           DATETIME      NOT NULL COMMENT '요청일시',
    amount           DECIMAL(18,2) NOT NULL COMMENT '요청 금액',
    status_cd        VARCHAR(30)   NOT NULL COMMENT '상태코드(PENDING/APPROVED/CANCELED)',

    approve_dt       DATETIME               COMMENT '승인일시',
    approve_admin_id BIGINT                 COMMENT '승인관리자ID(t-b-admin 등)',
    cancel_dt        DATETIME               COMMENT '취소일시',
    cancel_admin_id  BIGINT                 COMMENT '취소관리자ID',
    cancel_reason    VARCHAR(500)           COMMENT '취소사유',

    note             VARCHAR(500)           COMMENT '비고(입금 계좌, 입금자명 등 필요시)',

    use_yn           CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn           CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id           VARCHAR(20)   NOT NULL COMMENT '등록자ID',
    reg_dt           DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id           VARCHAR(20)            COMMENT '수정자ID',
    mod_dt           DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
                                             ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_MEATMONEY_DEPOSIT_REQ PRIMARY KEY (deposit_req_id),

    CONSTRAINT FK_TB_MEATMONEY_DEPOSIT_REQ_MEMBER
        FOREIGN KEY (member_id)
        REFERENCES tb_member (member_id),

    KEY IX_MEATMONEY_DEPOSIT_MEMBER (member_id, req_dt),
    KEY IX_MEATMONEY_DEPOSIT_STATUS (status_cd)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='미트머니 충전 요청(입금 확인/내역)';


/* =========================================================
 * 3. 미트머니 환불 처리 이력 (환불 처리 탭)
 * =======================================================*/
CREATE TABLE tb_meatmoney_refund (
    refund_id        BIGINT        NOT NULL AUTO_INCREMENT COMMENT '환불ID',
    member_id        BIGINT        NOT NULL COMMENT '회원ID',
    refund_dt        DATETIME      NOT NULL COMMENT '환불일시',
    amount           DECIMAL(18,2) NOT NULL COMMENT '환불 금액(출금액)',
    status_cd        VARCHAR(30)   NOT NULL DEFAULT 'COMPLETED' COMMENT '상태코드(REQUESTED/COMPLETED/CANCELED 등 확장 가능)',
    order_id         BIGINT                 COMMENT '관련 주문ID(주문 취소 환불 시)',
    reason           VARCHAR(500)           COMMENT '환불 사유/메모',

    use_yn           CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn           CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id           VARCHAR(20)   NOT NULL COMMENT '등록자ID',
    reg_dt           DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id           VARCHAR(20)            COMMENT '수정자ID',
    mod_dt           DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
                                             ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_MEATMONEY_REFUND PRIMARY KEY (refund_id),

    CONSTRAINT FK_TB_MEATMONEY_REFUND_MEMBER
        FOREIGN KEY (member_id)
        REFERENCES tb_member (member_id),

    CONSTRAINT FK_TB_MEATMONEY_REFUND_ORDER
        FOREIGN KEY (order_id)
        REFERENCES tb_order (order_id),

    KEY IX_MEATMONEY_REFUND_MEMBER_DT (member_id, refund_dt)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='미트머니 환불 처리 이력';


/* =========================================================
 * 4. 여신 계좌(한도/잔액) - 여신 설정 탭
 *    한 회원에 ACTIVE 상태 1건을 기본으로 가정
 * =======================================================*/
CREATE TABLE tb_credit_account (
    credit_id        BIGINT        NOT NULL AUTO_INCREMENT COMMENT '여신계정ID',
    member_id        BIGINT        NOT NULL COMMENT '회원ID',
    contract_dt      DATE          NOT NULL COMMENT '여신 약정일',
    credit_limit_amt DECIMAL(18,2) NOT NULL COMMENT '여신 한도',
    credit_used_amt  DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '여신 사용량(누적 사용, 상환 전 기준)',
    credit_balance_amt DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '여신 잔액(미상환 금액)',
    status_cd        VARCHAR(30)   NOT NULL DEFAULT 'ACTIVE' COMMENT '상태코드(ACTIVE/STOP/CLOSED)',
    expire_dt        DATE                   COMMENT '만료일(옵션)',
    use_yn           CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부(화면의 사용여부)',

    del_yn           CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id           VARCHAR(20)   NOT NULL COMMENT '등록자ID',
    reg_dt           DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id           VARCHAR(20)            COMMENT '수정자ID',
    mod_dt           DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
                                             ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_CREDIT_ACCOUNT PRIMARY KEY (credit_id),

    CONSTRAINT FK_TB_CREDIT_ACCOUNT_MEMBER
        FOREIGN KEY (member_id)
        REFERENCES tb_member (member_id),

    KEY IX_CREDIT_ACCOUNT_MEMBER (member_id),
    KEY IX_CREDIT_ACCOUNT_STATUS (status_cd)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='여신 계정(한도/잔액 관리)';


/* =========================================================
 * 5. 여신 사용/증액/상환 내역 - 여신 내역 탭
 *    화면: 여신 사용일시, 사용내용, 주문번호, 여신 사용금액, 여신 잔액
 * =======================================================*/
CREATE TABLE tb_credit_history (
    credit_hist_id   BIGINT        NOT NULL AUTO_INCREMENT COMMENT '여신이력ID',
    credit_id        BIGINT        NOT NULL COMMENT '여신계정ID',
    member_id        BIGINT        NOT NULL COMMENT '회원ID(조회용 중복 보관)',
    hist_dt          DATETIME      NOT NULL COMMENT '이력일시',

    hist_type_cd     VARCHAR(30)   NOT NULL COMMENT '이력유형(USE:사용, INCREASE:증액, REPAY:상환 등)',
    description      VARCHAR(200)  NOT NULL COMMENT '사용 내용(상품구매, 여신 증액 등)',
    order_id         BIGINT                 COMMENT '주문ID(상품구매 시)',
    amount           DECIMAL(18,2) NOT NULL COMMENT '여신 사용/변경 금액(+기준)',
    balance_amt      DECIMAL(18,2) NOT NULL COMMENT '거래 후 여신 잔액',

    use_yn           CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    del_yn           CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    reg_id           VARCHAR(20)   NOT NULL COMMENT '등록자ID',
    reg_dt           DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    mod_id           VARCHAR(20)            COMMENT '수정자ID',
    mod_dt           DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
                                             ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    CONSTRAINT PK_TB_CREDIT_HISTORY PRIMARY KEY (credit_hist_id),

    CONSTRAINT FK_TB_CREDIT_HISTORY_ACCOUNT
        FOREIGN KEY (credit_id)
        REFERENCES tb_credit_account (credit_id),

    CONSTRAINT FK_TB_CREDIT_HISTORY_MEMBER
        FOREIGN KEY (member_id)
        REFERENCES tb_member (member_id),

    CONSTRAINT FK_TB_CREDIT_HISTORY_ORDER
        FOREIGN KEY (order_id)
        REFERENCES tb_order (order_id),

    KEY IX_CREDIT_HISTORY_MEMBER_DT (member_id, hist_dt),
    KEY IX_CREDIT_HISTORY_ACCOUNT_DT (credit_id, hist_dt)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='여신 사용/증액/상환 내역';
    
CREATE TABLE tb_wishlist (
    wishlist_id   BIGINT      NOT NULL AUTO_INCREMENT,
    member_id     BIGINT      NOT NULL COMMENT '회원ID',
    sales_prod_id BIGINT      NOT NULL COMMENT '판매상품ID',
    created_dt    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '찜한일시',

    use_yn        CHAR(1)     NOT NULL DEFAULT 'Y',
    del_yn        CHAR(1)     NOT NULL DEFAULT 'N',
    reg_id        VARCHAR(20) NOT NULL,
    reg_dt        DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    mod_id        VARCHAR(20),
    mod_dt        DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP
                                 ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT PK_TB_WISHLIST PRIMARY KEY (wishlist_id),
    UNIQUE KEY UX_WISHLIST_MEMBER_PROD (member_id, sales_prod_id)
);
    
    
ALTER TABLE tb_order
    ADD COLUMN agree_third_party_yn  CHAR(1) NOT NULL DEFAULT 'N' COMMENT '개인정보 제3자 제공 동의',
    ADD COLUMN agree_safe_service_yn CHAR(1) NOT NULL DEFAULT 'N' COMMENT '구매안전 서비스 안내 동의';


use matpam;

DROP TABLE IF EXISTS TB_MEMBER_CONTACT;

CREATE TABLE TB_MEMBER_CONTACT (
    CONTACT_ID      BIGINT       NOT NULL AUTO_INCREMENT COMMENT '담당자ID',
    MEMBER_ID       BIGINT       NOT NULL COMMENT '회원ID(FK: TB_MEMBER.MEMBER_ID 혹은 MEMBER_NO)',
    NAME            VARCHAR(100) NOT NULL COMMENT '담당자명',
    MOBILE_NO       VARCHAR(30)          COMMENT '담당자 휴대폰번호',
    PHONE_NO        VARCHAR(30)          COMMENT '담당자 유선전화번호',
    EMAIL           VARCHAR(100)         COMMENT '담당자 이메일',
    CONTACT_TYPE_CD VARCHAR(20) NOT NULL COMMENT '담당자유형(MAIN/SUB 등)',
    USE_YN          CHAR(1)     NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    REG_DT          DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    MOD_DT          DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP
                                        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT PK_TB_MEMBER_CONTACT PRIMARY KEY (CONTACT_ID),
    KEY IX_MEMBER_CONTACT_MEMBER (MEMBER_ID, CONTACT_TYPE_CD, USE_YN)
);



ALTER TABLE TB_MEMBER
    ADD COLUMN CREDIT_LIMIT DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '여신 한도',
    ADD COLUMN MEAT_MONEY   DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '미트머니 잔액';




delete from tb_member;
delete from tb_member_agree;
select * from tb_member_contact;
select * from tb_member_credit;
select * from tb_member_status_hist;

