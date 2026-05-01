-- =========================================================
-- 맛팜 B2B 폐쇄 플랫폼 - 1단계 회원관리 경량 모델 (최종 확정본)
-- MySQL 8.0+
-- =========================================================

-- CONNECT;

use matpam_new;

-- 권장 세션 설정
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ---------------------------------------------------------
-- 기존 구 스키마(matpam_mody.sql) 잔재 제거
-- ---------------------------------------------------------
DROP TABLE IF EXISTS tb_member_channel_role;
DROP TABLE IF EXISTS tb_buyer_profile;
DROP TABLE IF EXISTS tb_seller_profile;
DROP TABLE IF EXISTS tb_seller_settlement_account;
DROP TABLE IF EXISTS tb_member_contact;
DROP TABLE IF EXISTS tb_admin_profile;
DROP TABLE IF EXISTS tb_member_master;
DROP TABLE IF EXISTS tb_company_master;

-- ---------------------------------------------------------
-- 신규 스키마 초기화 (종속성 역순)
-- ---------------------------------------------------------
DROP TABLE IF EXISTS tb_audit_log;
DROP TABLE IF EXISTS tb_buyer_financial;
DROP TABLE IF EXISTS tb_company_bank_account;
DROP TABLE IF EXISTS tb_buyer_channel;
DROP TABLE IF EXISTS tb_company_contact;
DROP TABLE IF EXISTS tb_user;
-- tb_tenant와 tb_company의 순환 참조 해결을 위해 FK 먼저 제거
ALTER TABLE tb_tenant DROP FOREIGN KEY fk_tb_tenant_01;
DROP TABLE IF EXISTS tb_company;
DROP TABLE IF EXISTS tb_channel;
DROP TABLE IF EXISTS tb_tenant;

-- =========================================================
-- 1. 테넌트
-- =========================================================
CREATE TABLE IF NOT EXISTS tb_tenant (
    tenant_id            BIGINT NOT NULL AUTO_INCREMENT COMMENT '테넌트 ID',
    tenant_code          VARCHAR(50) NOT NULL COMMENT '테넌트 코드',
    tenant_name          VARCHAR(200) NOT NULL COMMENT '테넌트명',
    seller_company_id    BIGINT NULL COMMENT '대표 판매업체 ID',
    status               ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (tenant_id),
    UNIQUE KEY uk_tb_tenant_01 (tenant_code),
    KEY idx_tb_tenant_01 (seller_company_id),
    KEY idx_tb_tenant_02 (status)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='플랫폼 분양 단위';

-- =========================================================
-- 2. 채널
-- =========================================================
CREATE TABLE IF NOT EXISTS tb_channel (
    channel_id           BIGINT NOT NULL AUTO_INCREMENT COMMENT '채널 ID',
    tenant_id            BIGINT NOT NULL COMMENT '테넌트 ID',
    channel_code         ENUM('PARCEL','FREIGHT','PICKUP') NOT NULL COMMENT '채널코드',
    channel_name         VARCHAR(100) NOT NULL COMMENT '채널명',
    status               ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    sort_order           INT NOT NULL DEFAULT 0 COMMENT '정렬순서',
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (channel_id),
    UNIQUE KEY uk_tb_channel_01 (tenant_id, channel_code),
    UNIQUE KEY uk_tb_channel_02 (tenant_id, channel_id),
    KEY idx_tb_channel_01 (status),
    CONSTRAINT fk_tb_channel_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='테넌트별 운영 채널';

-- =========================================================
-- 3. 업체 -- 수정
-- =========================================================
CREATE TABLE IF NOT EXISTS tb_company (
    company_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '업체 ID',
    tenant_id BIGINT NOT NULL COMMENT '테넌트 ID',
    company_type ENUM('SELLER','BUYER') NOT NULL COMMENT '업체유형',
    seller_type ENUM('RAW','PROCESSED','FINISHED') NULL COMMENT '판매업체유형',
    company_name VARCHAR(200) NOT NULL COMMENT '업체명',
    business_no VARCHAR(20) NOT NULL COMMENT '사업자등록번호',
    ceo_name VARCHAR(100) NOT NULL COMMENT '대표자명',
    postal_code VARCHAR(10) NULL COMMENT '우편번호',
    address1 VARCHAR(255) NULL COMMENT '주소',
    address2 VARCHAR(255) NULL COMMENT '상세주소',
    phone VARCHAR(30) NULL COMMENT '대표전화',
    email VARCHAR(150) NULL COMMENT '대표이메일',
    default_tax_type ENUM('TAX_FREE','TAXABLE') NOT NULL COMMENT '기본 과세구분',
    biz_status ENUM('ACTIVE','SUSPENDED','CLOSED') NOT NULL DEFAULT 'ACTIVE' COMMENT '사업자 상태',
    biz_checked_at DATETIME NULL COMMENT '사업자 상태 확인일시',
    biz_checked_result VARCHAR(100) NULL COMMENT '사업자 상태 확인 결과',
    status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '사용 상태',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (company_id),
    UNIQUE KEY uk_tb_company_01 (tenant_id, business_no),
    UNIQUE KEY uk_tb_company_02 (tenant_id, company_id),
    KEY idx_tb_company_01 (company_type),
    KEY idx_tb_company_02 (status),
    KEY idx_tb_company_03 (seller_type),
    CONSTRAINT fk_tb_company_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_tb_company_01 CHECK (
        (company_type = 'SELLER' AND seller_type IS NOT NULL)
        OR
        (company_type = 'BUYER' AND seller_type IS NULL)
    )
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='법적 거래주체 업체 마스터';

-- GENERATED ALWAYS AS 방식은 빼세요.
-- 1단계에서는 tb_tenant.seller_company_id로 판매업체 1개 제한을 관리하는 방식이 더 안전하고 단순합니다.

-- =========================================================
-- 4. 사용자-- 수정
-- =========================================================
-- CHECK 제약을 제거하고, 이 규칙은 서비스 로직 또는 트리거에서 처리하세요.
-- 가장 간단한 수정본은 아래입니다.

CREATE TABLE IF NOT EXISTS tb_user (
    user_id               BIGINT NOT NULL AUTO_INCREMENT COMMENT '사용자 ID',
    tenant_id             BIGINT NULL COMMENT '테넌트 ID',
    company_id            BIGINT NULL COMMENT '소속 업체 ID',
    login_id              VARCHAR(100) NOT NULL COMMENT '로그인 ID',
    password_hash         VARCHAR(255) NOT NULL COMMENT '비밀번호 해시',
    user_name             VARCHAR(100) NOT NULL COMMENT '사용자명',
    mobile                VARCHAR(30) NULL COMMENT '휴대전화',
    email                 VARCHAR(150) NULL COMMENT '이메일',
    user_role             ENUM('SUPER_ADMIN','SELLER_ADMIN','CHANNEL_ADMIN','BUYER_ADMIN') NOT NULL COMMENT '역할',
    channel_id            BIGINT NULL COMMENT '채널 ID',
    status                ENUM('ACTIVE','LOCKED','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    last_login_at         DATETIME NULL COMMENT '마지막 로그인 일시',
    created_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (user_id),
    UNIQUE KEY uk_tb_user_01 (login_id),
    KEY idx_tb_user_01 (tenant_id, company_id),
    KEY idx_tb_user_02 (channel_id),
    KEY idx_tb_user_03 (user_role),
    KEY idx_tb_user_04 (status),
    CONSTRAINT fk_tb_user_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_tb_user_02
        FOREIGN KEY (tenant_id, company_id) REFERENCES tb_company (tenant_id, company_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_tb_user_03
        FOREIGN KEY (tenant_id, channel_id) REFERENCES tb_channel (tenant_id, channel_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='로그인 사용자 계정';

-- 역할별 필수값 검증은 이렇게 처리
-- 애플리케이션에서 저장 전 검증하세요.

-- SUPER_ADMIN  → tenant_id NULL, company_id NULL, channel_id NULL
-- SELLER_ADMIN → tenant_id 필수, company_id 필수, channel_id NULL
-- CHANNEL_ADMIN → tenant_id 필수, company_id 필수, channel_id 필수
-- BUYER_ADMIN → tenant_id 필수, company_id 필수, channel_id NULL

-- 참고

-- 지금 DB에서는 GENERATED COLUMN, CHECK 둘 다 계속 막히고 있으므로,
-- DB 제약은 FK/UNIQUE까지만 두고 복잡한 업무 규칙은 Java 서비스에서 검증하는 방식이 가장 안전합니다.

-- =========================================================
-- 5. 업체 담당자-- 수정
-- =========================================================
-- 같은 원인입니다. 현재 DB에서는 GENERATED ALWAYS AS에서 다른 컬럼(company_id)을 참조할 수 없어서 에러가 납니다.

CREATE TABLE IF NOT EXISTS tb_company_contact (
    contact_id     BIGINT NOT NULL AUTO_INCREMENT COMMENT '담당자 ID',
    company_id     BIGINT NOT NULL COMMENT '업체 ID',
    contact_name   VARCHAR(100) NOT NULL COMMENT '담당자명',
    contact_role   ENUM('ADMIN','SALES','TAX','SETTLEMENT','SHIPPING','PURCHASE') NOT NULL COMMENT '담당 역할',
    mobile         VARCHAR(30) NULL COMMENT '휴대전화',
    email          VARCHAR(150) NULL COMMENT '이메일',
    is_primary     CHAR(1) NOT NULL DEFAULT 'N' COMMENT '대표 담당자 여부',
    linked_user_id BIGINT NULL COMMENT '연결 사용자 ID',
    status         ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (contact_id),
    KEY idx_tb_company_contact_01 (company_id),
    KEY idx_tb_company_contact_02 (linked_user_id),
    KEY idx_tb_company_contact_03 (status),
    KEY idx_tb_company_contact_04 (contact_role),
    CONSTRAINT fk_tb_company_contact_01
        FOREIGN KEY (company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_tb_company_contact_02
        FOREIGN KEY (linked_user_id) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='업체 담당자 정보';
    
--    -- 대표 담당자 1명 제한은 DB 제약 대신 저장 로직에서 검사하세요.

SELECT COUNT(*)
FROM tb_company_contact
WHERE company_id = ?
  AND is_primary = 'Y'
  AND status = 'ACTIVE';
    
-- =========================================================
-- 6. 구매업체 채널 소속
-- =========================================================
CREATE TABLE IF NOT EXISTS tb_buyer_channel (
    buyer_channel_id      BIGINT NOT NULL AUTO_INCREMENT COMMENT '구매업체 채널 소속 ID',
    tenant_id             BIGINT NOT NULL COMMENT '테넌트 ID',
    buyer_company_id      BIGINT NOT NULL COMMENT '구매업체 ID',
    channel_id            BIGINT NOT NULL COMMENT '채널 ID',
    status                ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    joined_at             DATETIME NULL COMMENT '참여일시',
    created_by            BIGINT NULL COMMENT '등록 사용자 ID',
    created_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    PRIMARY KEY (buyer_channel_id),
    UNIQUE KEY uk_tb_buyer_channel_01 (tenant_id, buyer_company_id, channel_id),
    KEY idx_tb_buyer_channel_01 (buyer_company_id),
    KEY idx_tb_buyer_channel_02 (channel_id),
    KEY idx_tb_buyer_channel_03 (created_by),
    KEY idx_tb_buyer_channel_04 (status),
    CONSTRAINT fk_tb_buyer_channel_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_tb_buyer_channel_02
        FOREIGN KEY (tenant_id, buyer_company_id) REFERENCES tb_company (tenant_id, company_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_tb_buyer_channel_03
        FOREIGN KEY (tenant_id, channel_id) REFERENCES tb_channel (tenant_id, channel_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_tb_buyer_channel_04
        FOREIGN KEY (created_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='구매업체별 채널 소속 정보';

-- =========================================================
-- 7. 업체 계좌정보-- 수정
-- =========================================================
CREATE TABLE IF NOT EXISTS tb_company_bank_account (
    bank_account_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '계좌 ID',
    company_id BIGINT NOT NULL COMMENT '업체 ID',
    bank_name VARCHAR(100) NOT NULL COMMENT '은행명',
    account_no_enc VARCHAR(255) NOT NULL COMMENT '암호화 계좌번호',
    account_holder VARCHAR(100) NOT NULL COMMENT '예금주',
    is_default CHAR(1) NOT NULL DEFAULT 'N' COMMENT '기본계좌 여부',
    status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (bank_account_id),
    KEY idx_tb_company_bank_account_01 (company_id),
    KEY idx_tb_company_bank_account_02 (status),
    CONSTRAINT fk_tb_company_bank_account_01
        FOREIGN KEY (company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='업체 계좌정보';
    
-- 기본계좌 1개 제한은 저장 전에 이렇게 검사하세요.
-- 
-- SELECT COUNT(*)
-- FROM tb_company_bank_account
-- WHERE company_id = ?
--   AND is_default = 'Y'
--   AND status = 'ACTIVE';

-- 또는 신규 기본계좌 저장 시 기존 기본계좌를 먼저 해제하세요.
-- 
-- UPDATE tb_company_bank_account
-- SET is_default = 'N'
-- WHERE company_id = ?
--   AND is_default = 'Y';
-- 
-- 그 다음 새 계좌를 is_default = 'Y'로 등록하면 됩니다.    

-- =========================================================
-- 8. 구매업체 금융정보
-- =========================================================
CREATE TABLE IF NOT EXISTS tb_buyer_financial (
    buyer_financial_id     BIGINT NOT NULL AUTO_INCREMENT COMMENT '구매업체 금융정보 ID',
    buyer_company_id       BIGINT NOT NULL COMMENT '구매업체 ID',
    credit_limit_amount    DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '여신한도',
    meat_money_enabled     CHAR(1) NOT NULL DEFAULT 'N' COMMENT '미트머니 사용 여부',
    status                 ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    created_at             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    updated_by             BIGINT NULL COMMENT '수정 사용자 ID',
    PRIMARY KEY (buyer_financial_id),
    UNIQUE KEY uk_tb_buyer_financial_01 (buyer_company_id),
    KEY idx_tb_buyer_financial_01 (updated_by),
    KEY idx_tb_buyer_financial_02 (status),
    CONSTRAINT fk_tb_buyer_financial_01
        FOREIGN KEY (buyer_company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_tb_buyer_financial_02
        FOREIGN KEY (updated_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CONSTRAINT chk_tb_buyer_financial_01 CHECK (meat_money_enabled IN ('Y','N')),
    CONSTRAINT chk_tb_buyer_financial_02 CHECK (credit_limit_amount >= 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='구매업체 금융 기본정보';

-- =========================================================
-- 9. 감사 로그
-- =========================================================
CREATE TABLE IF NOT EXISTS tb_audit_log (
    audit_id              BIGINT NOT NULL AUTO_INCREMENT COMMENT '감사로그 ID',
    tenant_id             BIGINT NULL COMMENT '테넌트 ID',
    entity_name           VARCHAR(50) NOT NULL COMMENT '대상 엔티티명',
    entity_id             BIGINT NOT NULL COMMENT '대상 엔티티 PK',
    action_type           ENUM('INSERT','UPDATE','DELETE','LOGIN') NOT NULL COMMENT '작업유형',
    before_json           JSON NULL COMMENT '변경 전 값',
    after_json            JSON NULL COMMENT '변경 후 값',
    actor_user_id         BIGINT NULL COMMENT '작업 사용자 ID',
    acted_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작업일시',
    ip_address            VARCHAR(50) NULL COMMENT 'IP 주소',
    PRIMARY KEY (audit_id),
    KEY idx_tb_audit_log_01 (tenant_id),
    KEY idx_tb_audit_log_02 (entity_name, entity_id),
    KEY idx_tb_audit_log_03 (actor_user_id),
    KEY idx_tb_audit_log_04 (acted_at),
    CONSTRAINT fk_tb_audit_log_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CONSTRAINT fk_tb_audit_log_02
        FOREIGN KEY (actor_user_id) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='주요 마스터 변경 및 로그인 감사 로그';

-- =========================================================
-- 순환참조 처리: tb_tenant.seller_company_id -> tb_company
-- 같은 tenant 소속 company만 대표 판매업체로 지정되도록 composite FK 사용
-- =========================================================
ALTER TABLE tb_tenant
    ADD CONSTRAINT fk_tb_tenant_01
        FOREIGN KEY (tenant_id, seller_company_id)
        REFERENCES tb_company (tenant_id, company_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT;

-- =========================================================
-- 초기 기초 데이터 등록 (SUPER_ADMIN 및 기본 테넌트)
-- =========================================================
-- 1. 수퍼관리자 계정 (비밀번호는 'admin123' 가정. 실제 적용 시 Bcrypt 등 암호화된 해시로 변경 필요)
INSERT INTO tb_user (login_id, password_hash, user_name, user_role, status)
VALUES ('superadmin', 'admin123', '최상위 수퍼관리자', 'SUPER_ADMIN', 'ACTIVE');

-- 2. 기본 개발용 테넌트 생성
INSERT INTO tb_tenant (tenant_code, tenant_name, status)
VALUES ('MATPAM_DEV', '맛팜 플랫폼 (개발/기본)', 'ACTIVE');

-- 3. 기본 채널 3종 생성
INSERT INTO tb_channel (tenant_id, channel_code, channel_name, sort_order)
VALUES 
    (1, 'PARCEL', '전국택배', 1),
    (1, 'FREIGHT', '화물직송', 2),
    (1, 'PICKUP', '공장수령', 3);

SET FOREIGN_KEY_CHECKS = 1;


-- =========================================================
-- 맛팜 B2B 폐쇄 플랫폼 - 1단계 회원관리 공통코드 마이그레이션
-- =========================================================
SET NAMES utf8mb4;
-- ---------------------------------------------------------
-- 1. 기존 레거시 코드 비활성화 (USE_YN = 'N')
-- ---------------------------------------------------------

-- select * from tb_group_code tgc 

-- ROLE_TYPE, MEMBER_TYPE 비활성화
UPDATE tb_group_code SET USE_YN = 'N', MOD_ID = 'SYSTEM', MOD_DATE = CURRENT_TIMESTAMP WHERE CODE_GROUP_ID IN ('ROLE_TYPE', 'MEMBER_TYPE', 'JOIN_STATUS');
UPDATE tb_code       SET USE_YN = 'N', MOD_ID = 'SYSTEM', MOD_DATE = CURRENT_TIMESTAMP WHERE CODE_GROUP_ID IN ('ROLE_TYPE', 'MEMBER_TYPE', 'JOIN_STATUS');
UPDATE tb_detail_code SET USE_YN = 'N', MOD_ID = 'SYSTEM', MOD_DATE = CURRENT_TIMESTAMP WHERE CODE_GROUP_ID IN ('ROLE_TYPE', 'MEMBER_TYPE', 'JOIN_STATUS');
-- CHANNEL_TYPE 내 구버전 코드 비활성화 (ADMIN, SUPER, COURIER_SERVICE 등)
UPDATE tb_detail_code SET USE_YN = 'N', MOD_ID = 'SYSTEM', MOD_DATE = CURRENT_TIMESTAMP 
WHERE CODE_GROUP_ID = 'CHANNEL_TYPE' AND DETAIL_CODE_ID IN ('ADMIN', 'SUPER', 'COURIER_SERVICE', 'DIRECT_DELIVERY', 'FACTORY_PICKUP');
-- INQUIRY_TYPE.DUPE 비활성화
UPDATE tb_detail_code SET USE_YN = 'N', MOD_ID = 'SYSTEM', MOD_DATE = CURRENT_TIMESTAMP 
WHERE CODE_GROUP_ID = 'INQUIRY_TYPE' AND DETAIL_CODE_ID = 'DUPE';
-- COMPANY_STATUS 구버전 코드 비활성화
UPDATE tb_detail_code SET USE_YN = 'N', MOD_ID = 'SYSTEM', MOD_DATE = CURRENT_TIMESTAMP 
WHERE CODE_GROUP_ID = 'COMPANY_STATUS';
-- ---------------------------------------------------------
-- 2. 신규 그룹코드 (tb_group_code) 등록
-- ---------------------------------------------------------
INSERT INTO tb_group_code (CODE_GROUP_ID, CODE_GROUP_NAME, USE_YN, REG_ID, DEL_YN) VALUES
('USER_ROLE', '사용자역할', 'Y', 'SYSTEM', 'N'),
('COMPANY_TYPE', '업체유형', 'Y', 'SYSTEM', 'N'),
('SELLER_TYPE', '판매업체유형', 'Y', 'SYSTEM', 'N'),
('BIZ_STATUS', '사업자상태', 'Y', 'SYSTEM', 'N'),
('USER_STATUS', '사용자상태', 'Y', 'SYSTEM', 'N'),
('CONTACT_ROLE', '담당자역할', 'Y', 'SYSTEM', 'N')
ON DUPLICATE KEY UPDATE CODE_GROUP_NAME = VALUES(CODE_GROUP_NAME), USE_YN = 'Y';
-- 기존 그룹코드 명칭 업데이트
UPDATE tb_group_code SET CODE_GROUP_NAME = '사용상태' WHERE CODE_GROUP_ID = 'COMPANY_STATUS';
-- ---------------------------------------------------------
-- 3. 신규 코드 (tb_code) 등록
-- ---------------------------------------------------------
INSERT INTO tb_code (CODE_GROUP_ID, CODE_ID, CODE_NAME, SORT_ORDER, USE_YN, REG_ID, DEL_YN) VALUES
('USER_ROLE', 'USER_ROLE', '사용자역할', 1, 'Y', 'SYSTEM', 'N'),
('COMPANY_TYPE', 'COMPANY_TYPE', '업체유형', 1, 'Y', 'SYSTEM', 'N'),
('SELLER_TYPE', 'SELLER_TYPE', '판매업체유형', 1, 'Y', 'SYSTEM', 'N'),
('BIZ_STATUS', 'BIZ_STATUS', '사업자상태', 1, 'Y', 'SYSTEM', 'N'),
('USER_STATUS', 'USER_STATUS', '사용자상태', 1, 'Y', 'SYSTEM', 'N'),
('CONTACT_ROLE', 'CONTACT_ROLE', '담당자역할', 1, 'Y', 'SYSTEM', 'N')
ON DUPLICATE KEY UPDATE CODE_NAME = VALUES(CODE_NAME), USE_YN = 'Y';
-- ---------------------------------------------------------
-- 4. 신규 상세코드 (tb_detail_code) 등록
-- ---------------------------------------------------------
INSERT INTO tb_detail_code (CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID, DEL_YN) VALUES
-- USER_ROLE
('USER_ROLE', 'USER_ROLE', 'SUPER_ADMIN', '수퍼관리자', 1, 'Y', 'SYSTEM', 'N'),
('USER_ROLE', 'USER_ROLE', 'SELLER_ADMIN', '판매업체관리자', 2, 'Y', 'SYSTEM', 'N'),
('USER_ROLE', 'USER_ROLE', 'CHANNEL_ADMIN', '채널관리자', 3, 'Y', 'SYSTEM', 'N'),
('USER_ROLE', 'USER_ROLE', 'BUYER_ADMIN', '구매업체관리자', 4, 'Y', 'SYSTEM', 'N'),
-- COMPANY_TYPE
('COMPANY_TYPE', 'COMPANY_TYPE', 'SELLER', '판매업체', 1, 'Y', 'SYSTEM', 'N'),
('COMPANY_TYPE', 'COMPANY_TYPE', 'BUYER', '구매업체', 2, 'Y', 'SYSTEM', 'N'),
-- SELLER_TYPE
('SELLER_TYPE', 'SELLER_TYPE', 'RAW', '원물', 1, 'Y', 'SYSTEM', 'N'),
('SELLER_TYPE', 'SELLER_TYPE', 'PROCESSED', '가공', 2, 'Y', 'SYSTEM', 'N'),
('SELLER_TYPE', 'SELLER_TYPE', 'FINISHED', '완제품', 3, 'Y', 'SYSTEM', 'N'),
-- BIZ_STATUS
('BIZ_STATUS', 'BIZ_STATUS', 'ACTIVE', '정상', 1, 'Y', 'SYSTEM', 'N'),
('BIZ_STATUS', 'BIZ_STATUS', 'SUSPENDED', '휴업', 2, 'Y', 'SYSTEM', 'N'),
('BIZ_STATUS', 'BIZ_STATUS', 'CLOSED', '폐업', 3, 'Y', 'SYSTEM', 'N'),
-- USER_STATUS
('USER_STATUS', 'USER_STATUS', 'ACTIVE', '정상', 1, 'Y', 'SYSTEM', 'N'),
('USER_STATUS', 'USER_STATUS', 'LOCKED', '잠김', 2, 'Y', 'SYSTEM', 'N'),
('USER_STATUS', 'USER_STATUS', 'INACTIVE', '비활성', 3, 'Y', 'SYSTEM', 'N'),
-- CONTACT_ROLE
('CONTACT_ROLE', 'CONTACT_ROLE', 'ADMIN', '대표담당', 1, 'Y', 'SYSTEM', 'N'),
('CONTACT_ROLE', 'CONTACT_ROLE', 'SALES', '영업', 2, 'Y', 'SYSTEM', 'N'),
('CONTACT_ROLE', 'CONTACT_ROLE', 'TAX', '세무', 3, 'Y', 'SYSTEM', 'N'),
('CONTACT_ROLE', 'CONTACT_ROLE', 'SETTLEMENT', '정산', 4, 'Y', 'SYSTEM', 'N'),
('CONTACT_ROLE', 'CONTACT_ROLE', 'SHIPPING', '출고', 5, 'Y', 'SYSTEM', 'N'),
('CONTACT_ROLE', 'CONTACT_ROLE', 'PURCHASE', '구매', 6, 'Y', 'SYSTEM', 'N'),
-- CHANNEL_TYPE (기존 그룹코드 재사용, 신규 상세코드 추가)
('CHANNEL_TYPE', 'CHANNEL_TYPE', 'PARCEL', '전국택배', 1, 'Y', 'SYSTEM', 'N'),
('CHANNEL_TYPE', 'CHANNEL_TYPE', 'FREIGHT', '화물직송', 2, 'Y', 'SYSTEM', 'N'),
('CHANNEL_TYPE', 'CHANNEL_TYPE', 'PICKUP', '공장수령', 3, 'Y', 'SYSTEM', 'N'),
-- COMPANY_STATUS (기존 그룹코드 재사용, 신규 상세코드 추가)
('COMPANY_STATUS', 'COMPANY_STATUS', 'ACTIVE', '정상', 1, 'Y', 'SYSTEM', 'N'),
('COMPANY_STATUS', 'COMPANY_STATUS', 'INACTIVE', '비활성', 2, 'Y', 'SYSTEM', 'N')
ON DUPLICATE KEY UPDATE DETAIL_CODE_NAME = VALUES(DETAIL_CODE_NAME), USE_YN = 'Y', SORT_ORDER = VALUES(SORT_ORDER);
