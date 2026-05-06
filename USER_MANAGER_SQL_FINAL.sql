-- =========================================================
-- 맛팜 B2B 폐쇄 플랫폼 - 1단계 회원관리 경량 모델 (최종 확정본 - MariaDB 10.3 최적화)
-- =========================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 기존 테이블 제거
DROP TABLE IF EXISTS tb_audit_log;
DROP TABLE IF EXISTS tb_buyer_financial;
DROP TABLE IF EXISTS tb_company_bank_account;
DROP TABLE IF EXISTS tb_buyer_channel;
DROP TABLE IF EXISTS tb_company_contact;
DROP TABLE IF EXISTS tb_user;
DROP TABLE IF EXISTS tb_company;
DROP TABLE IF EXISTS tb_channel;
DROP TABLE IF EXISTS tb_tenant;

-- 1. 테넌트
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='플랫폼 분양 단위';

-- 2. 채널
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
    CONSTRAINT fk_tb_channel_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='테넌트별 운영 채널';

-- 3. 업체
CREATE TABLE IF NOT EXISTS tb_company (
    company_id              BIGINT NOT NULL AUTO_INCREMENT COMMENT '업체 ID',
    tenant_id               BIGINT NOT NULL COMMENT '테넌트 ID',
    company_type            ENUM('SELLER','BUYER') NOT NULL COMMENT '업체유형',
    seller_type             ENUM('RAW','PROCESSED','FINISHED') NULL COMMENT '판매업체유형',
    company_name            VARCHAR(200) NOT NULL COMMENT '업체명',
    business_no             VARCHAR(20) NOT NULL COMMENT '사업자등록번호',
    ceo_name                VARCHAR(100) NOT NULL COMMENT '대표자명',
    postal_code             VARCHAR(10) NULL COMMENT '우편번호',
    address1                VARCHAR(255) NULL COMMENT '주소',
    address2                VARCHAR(255) NULL COMMENT '상세주소',
    phone                   VARCHAR(30) NULL COMMENT '대표전화',
    email                   VARCHAR(150) NULL COMMENT '대표이메일',
    default_tax_type        ENUM('TAX_FREE','TAXABLE') NOT NULL COMMENT '기본 과세구분',
    biz_status              ENUM('ACTIVE','SUSPENDED','CLOSED') NOT NULL DEFAULT 'ACTIVE' COMMENT '사업자 상태',
    biz_checked_at          DATETIME NULL COMMENT '사업자 상태 확인일시',
    biz_checked_result      VARCHAR(100) NULL COMMENT '사업자 상태 확인 결과',
    status                  ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '사용 상태',
    created_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (company_id),
    UNIQUE KEY uk_tb_company_01 (tenant_id, business_no),
    UNIQUE KEY uk_tb_company_02 (tenant_id, company_id),
    KEY idx_tb_company_01 (company_type),
    KEY idx_tb_company_02 (status),
    KEY idx_tb_company_03 (seller_type),
    CONSTRAINT fk_tb_company_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT chk_tb_company_01 CHECK (
        (company_type = 'SELLER' AND seller_type IS NOT NULL)
        OR
        (company_type = 'BUYER' AND seller_type IS NULL)
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='법적 거래주체 업체 마스터';

-- 4. 사용자
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
    CONSTRAINT fk_tb_user_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_user_02 FOREIGN KEY (tenant_id, company_id) REFERENCES tb_company (tenant_id, company_id),
    CONSTRAINT fk_tb_user_03 FOREIGN KEY (tenant_id, channel_id) REFERENCES tb_channel (tenant_id, channel_id),
    CONSTRAINT chk_tb_user_01 CHECK (
        (user_role = 'SUPER_ADMIN'  AND tenant_id IS NULL     AND company_id IS NULL     AND channel_id IS NULL)
        OR
        (user_role = 'SELLER_ADMIN' AND tenant_id IS NOT NULL AND company_id IS NOT NULL AND channel_id IS NULL)
        OR
        (user_role = 'CHANNEL_ADMIN'AND tenant_id IS NOT NULL AND company_id IS NOT NULL AND channel_id IS NOT NULL)
        OR
        (user_role = 'BUYER_ADMIN'  AND tenant_id IS NOT NULL AND company_id IS NOT NULL AND channel_id IS NULL)
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='로그인 사용자 계정';

-- 5. 업체 담당자
CREATE TABLE IF NOT EXISTS tb_company_contact (
    contact_id            BIGINT NOT NULL AUTO_INCREMENT COMMENT '담당자 ID',
    company_id            BIGINT NOT NULL COMMENT '업체 ID',
    contact_name          VARCHAR(100) NOT NULL COMMENT '담당자명',
    contact_role          ENUM('ADMIN','SALES','TAX','SETTLEMENT','SHIPPING','PURCHASE') NOT NULL COMMENT '담당 역할',
    mobile                VARCHAR(30) NULL COMMENT '휴대전화',
    email                 VARCHAR(150) NULL COMMENT '이메일',
    is_primary            CHAR(1) NOT NULL DEFAULT 'N' COMMENT '대표 담당자 여부',
    linked_user_id        BIGINT NULL COMMENT '연결 사용자 ID',
    status                ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    created_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (contact_id),
    KEY idx_tb_company_contact_01 (company_id),
    KEY idx_tb_company_contact_02 (linked_user_id),
    KEY idx_tb_company_contact_03 (status),
    KEY idx_tb_company_contact_04 (contact_role),
    CONSTRAINT fk_tb_company_contact_01 FOREIGN KEY (company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_company_contact_02 FOREIGN KEY (linked_user_id) REFERENCES tb_user (user_id),
    CONSTRAINT chk_tb_company_contact_01 CHECK (is_primary IN ('Y','N'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='업체 담당자 정보';

-- 6. 구매업체 채널 소속
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
    CONSTRAINT fk_tb_buyer_channel_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_buyer_channel_02 FOREIGN KEY (tenant_id, buyer_company_id) REFERENCES tb_company (tenant_id, company_id),
    CONSTRAINT fk_tb_buyer_channel_03 FOREIGN KEY (tenant_id, channel_id) REFERENCES tb_channel (tenant_id, channel_id),
    CONSTRAINT fk_tb_buyer_channel_04 FOREIGN KEY (created_by) REFERENCES tb_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='구매업체별 채널 소속 정보';

-- 7. 업체 계좌정보
CREATE TABLE IF NOT EXISTS tb_company_bank_account (
    bank_account_id         BIGINT NOT NULL AUTO_INCREMENT COMMENT '계좌 ID',
    company_id              BIGINT NOT NULL COMMENT '업체 ID',
    bank_name               VARCHAR(100) NOT NULL COMMENT '은행명',
    account_no_enc          VARCHAR(255) NOT NULL COMMENT '암호화 계좌번호',
    account_holder          VARCHAR(100) NOT NULL COMMENT '예금주',
    is_default              CHAR(1) NOT NULL DEFAULT 'N' COMMENT '기본계좌 여부',
    status                  ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    created_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (bank_account_id),
    KEY idx_tb_company_bank_account_01 (company_id),
    KEY idx_tb_company_bank_account_02 (status),
    CONSTRAINT fk_tb_company_bank_account_01 FOREIGN KEY (company_id) REFERENCES tb_company (company_id),
    CONSTRAINT chk_tb_company_bank_account_01 CHECK (is_default IN ('Y','N'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='업체 계좌정보';

-- 8. 구매업체 금융정보
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
    CONSTRAINT fk_tb_buyer_financial_01 FOREIGN KEY (buyer_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_buyer_financial_02 FOREIGN KEY (updated_by) REFERENCES tb_user (user_id),
    CONSTRAINT chk_tb_buyer_financial_01 CHECK (meat_money_enabled IN ('Y','N')),
    CONSTRAINT chk_tb_buyer_financial_02 CHECK (credit_limit_amount >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='구매업체 금융 기본정보';

-- 9. 감사 로그
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
    CONSTRAINT fk_tb_audit_log_01 FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_audit_log_02 FOREIGN KEY (actor_user_id) REFERENCES tb_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='주요 마스터 변경 및 로그인 감사 로그';

-- 순환참조 처리
ALTER TABLE tb_tenant
    ADD CONSTRAINT fk_tb_tenant_01
        FOREIGN KEY (tenant_id, seller_company_id)
        REFERENCES tb_company (tenant_id, company_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT;

SET FOREIGN_KEY_CHECKS = 1;
