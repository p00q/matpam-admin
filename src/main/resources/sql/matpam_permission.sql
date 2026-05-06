-- =============================================================================
-- MATPAM B2B 플랫폼 — 권한/승인 도메인 DDL
-- 작성일: 2026-05-01
-- 참조: MATPAM_MANAGER.md §7, USER_MANAGER.md §4-10~§4-13
-- 대상 DB: MariaDB 10.5+
-- =============================================================================
-- ⚠️ 실행 전 확인 사항:
--   1) tb_tenant, tb_user 가 먼저 생성되어 있어야 함
--   2) tb_audit_log 에 reason_code / approval_request_id / trace_id 컬럼 추가 필요
--      → ALTER TABLE 구문은 이 파일 하단 §ALTER 섹션 참조
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. tb_permission — 권한 마스터
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_permission (
    permission_id   BIGINT          NOT NULL AUTO_INCREMENT   COMMENT '권한 ID',
    permission_code VARCHAR(100)    NOT NULL                  COMMENT '권한 코드 (예: PRODUCT_TAX_EDIT)',
    permission_name VARCHAR(200)    NOT NULL                  COMMENT '권한명',
    description     VARCHAR(500)    NULL                      COMMENT '설명',
    domain          ENUM('PRODUCT','ORDER','FINANCE','USER','AUDIT','SYSTEM')
                                    NOT NULL                  COMMENT '도메인',
    created_at      DATETIME        NOT NULL DEFAULT NOW()    COMMENT '생성일시',

    PRIMARY KEY (permission_id),
    CONSTRAINT uq_tb_perm_code UNIQUE (permission_code)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='권한 마스터';

CREATE INDEX idx_tb_perm_domain ON tb_permission (domain);

-- 기본 권한 데이터 INSERT
INSERT INTO tb_permission (permission_code, permission_name, description, domain) VALUES
-- PRODUCT 도메인
('PRODUCT_VIEW',          '상품 조회',              '상품 목록/상세 조회',                                    'PRODUCT'),
('PRODUCT_EDIT',          '상품 등록/수정',          '상품 마스터 등록·수정·비활성화',                          'PRODUCT'),
('PRODUCT_TAX_EDIT',      '상품 세금구분 변경 요청', '상품 tax_category 변경 요청 (승인 필요)',                  'PRODUCT'),
('PRODUCT_TAX_APPROVE',   '상품 세금구분 변경 승인', 'PRODUCT_TAX_EDIT 요청 최종 승인',                         'PRODUCT'),
('PRODUCT_RELATION_EDIT', '상품 연관관계 수정',      'tb_product_relation 등록·수정',                           'PRODUCT'),
-- ORDER 도메인
('ORDER_VIEW',            '주문 조회',              '주문 목록/상세 조회',                                      'ORDER'),
('ORDER_EDIT',            '주문 생성/수정',          '주문 생성·수정',                                          'ORDER'),
('ORDER_CANCEL',          '주문 취소',              '주문 취소 처리',                                           'ORDER'),
('TAX_DOCUMENT_ISSUE',    '계산서 발행',            '세금계산서/계산서 발행',                                   'ORDER'),
('TAX_DOCUMENT_REISSUE',  '계산서 재발행',          '계산서 재발행 (취소+신규, 승인 필요)',                       'ORDER'),
-- FINANCE 도메인
('CREDIT_LIMIT_EDIT',     '여신한도 변경 요청',      '여신한도 변경 요청 (승인 필요)',                           'FINANCE'),
('CREDIT_LIMIT_APPROVE',  '여신한도 변경 승인',      'CREDIT_LIMIT_EDIT 요청 최종 승인',                        'FINANCE'),
('ADVANCE_DEPOSIT',       '선급금 입금 등록',        '구매업체 선급금 입금 확인 및 원장 등록',                   'FINANCE'),
('REFUND_APPROVE',        '환불 승인',              '환불 요청 최종 승인',                                      'FINANCE'),
('BANK_ACCOUNT_EDIT',     '계좌정보 변경',          '업체 계좌정보 변경 (승인 필요)',                           'FINANCE'),
-- USER 도메인
('USER_VIEW',             '사용자 조회',            '사용자 목록/상세 조회',                                    'USER'),
('USER_EDIT',             '사용자 등록/수정',        '사용자 등록·수정',                                        'USER'),
('USER_STATUS_CHANGE',    '사용자 상태 변경',        '사용자 ACTIVE/LOCKED/INACTIVE 변경',                      'USER'),
-- AUDIT 도메인
('AUDIT_LOG_VIEW',        '감사로그 조회',          'tb_audit_log 전체 조회 (민감 정보 마스킹 포함)',             'AUDIT'),
-- SYSTEM 도메인
('SYSTEM_TENANT_MANAGE',  '테넌트 관리',            '테넌트 생성·수정 (SUPER_ADMIN 전용)',                      'SYSTEM');

-- -----------------------------------------------------------------------------
-- 2. tb_role_permission — 역할별 기본 권한
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_role_permission (
    role_permission_id  BIGINT      NOT NULL AUTO_INCREMENT   COMMENT 'ID',
    user_role           ENUM('SUPER_ADMIN','SELLER_ADMIN','CHANNEL_ADMIN','BUYER_ADMIN')
                                    NOT NULL                  COMMENT '역할',
    permission_id       BIGINT      NOT NULL                  COMMENT '권한 ID',
    granted             CHAR(1)     NOT NULL DEFAULT 'Y'      COMMENT '부여 여부 (Y/N)',
    created_at          DATETIME    NOT NULL DEFAULT NOW()    COMMENT '생성일시',

    PRIMARY KEY (role_permission_id),

    CONSTRAINT uq_tb_rp_role_perm UNIQUE (user_role, permission_id),
    CONSTRAINT chk_tb_rp_granted  CHECK (granted IN ('Y','N')),

    CONSTRAINT fk_tb_rp_permission
        FOREIGN KEY (permission_id) REFERENCES tb_permission (permission_id)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='역할별 기본 권한 매트릭스';

CREATE INDEX idx_tb_rp_role ON tb_role_permission (user_role);

-- 역할별 기본 권한 INSERT
-- 권한 매트릭스 (MATPAM_MANAGER.md §7-3 참조)
-- ┌────────────────────────┬─────────────┬──────────────┬───────────────┬─────────────┐
-- │ 권한 코드               │ SUPER_ADMIN │ SELLER_ADMIN │ CHANNEL_ADMIN │ BUYER_ADMIN │
-- ├────────────────────────┼─────────────┼──────────────┼───────────────┼─────────────┤
-- │ PRODUCT_VIEW           │      Y      │      Y       │       Y       │      Y      │
-- │ PRODUCT_EDIT           │      Y      │      Y       │       N       │      N      │
-- │ PRODUCT_TAX_EDIT       │      Y      │      Y       │       N       │      N      │
-- │ PRODUCT_TAX_APPROVE    │      Y      │      N       │       N       │      N      │
-- │ PRODUCT_RELATION_EDIT  │      Y      │      Y       │       N       │      N      │
-- │ ORDER_VIEW             │      Y      │      Y       │       Y       │      Y      │
-- │ ORDER_EDIT             │      Y      │      Y       │       Y       │      Y      │
-- │ ORDER_CANCEL           │      Y      │      Y       │       Y       │      N      │
-- │ TAX_DOCUMENT_ISSUE     │      Y      │      Y       │       N       │      N      │
-- │ TAX_DOCUMENT_REISSUE   │      Y      │      N       │       N       │      N      │
-- │ CREDIT_LIMIT_EDIT      │      Y      │      Y       │       N       │      N      │
-- │ CREDIT_LIMIT_APPROVE   │      Y      │      N       │       N       │      N      │
-- │ ADVANCE_DEPOSIT        │      Y      │      Y       │       N       │      N      │
-- │ REFUND_APPROVE         │      Y      │      N       │       N       │      N      │
-- │ BANK_ACCOUNT_EDIT      │      Y      │      Y       │       N       │      N      │
-- │ USER_VIEW              │      Y      │      Y       │       Y       │      N      │
-- │ USER_EDIT              │      Y      │      Y       │       Y       │      N      │
-- │ USER_STATUS_CHANGE     │      Y      │      Y       │       N       │      N      │
-- │ AUDIT_LOG_VIEW         │      Y      │      Y       │       N       │      N      │
-- │ SYSTEM_TENANT_MANAGE   │      Y      │      N       │       N       │      N      │
-- └────────────────────────┴─────────────┴──────────────┴───────────────┴─────────────┘

INSERT INTO tb_role_permission (user_role, permission_id, granted)
SELECT r.role, p.permission_id, r.granted
FROM tb_permission p
JOIN (
    SELECT 'SUPER_ADMIN' AS role, 'PRODUCT_VIEW'          AS code, 'Y' AS granted UNION ALL
    SELECT 'SUPER_ADMIN',         'PRODUCT_EDIT',                   'Y' UNION ALL
    SELECT 'SUPER_ADMIN',         'PRODUCT_TAX_EDIT',               'Y' UNION ALL
    SELECT 'SUPER_ADMIN',         'PRODUCT_TAX_APPROVE',            'Y' UNION ALL
    SELECT 'SUPER_ADMIN',         'PRODUCT_RELATION_EDIT',          'Y' UNION ALL
    SELECT 'SUPER_ADMIN',         'ORDER_VIEW',                     'Y' UNION ALL
    SELECT 'SUPER_ADMIN',         'ORDER_EDIT',                     'Y' UNION ALL
    SELECT 'SUPER_ADMIN',         'ORDER_CANCEL',                   'Y' UNION ALL
    SELECT 'SUPER_ADMIN',         'TAX_DOCUMENT_ISSUE',             'Y' UNION ALL
    SELECT 'SUPER_ADMIN',         'TAX_DOCUMENT_REISSUE',           'Y' UNION ALL
    SELECT 'SUPER_ADMIN',         'CREDIT_LIMIT_EDIT',              'Y' UNION ALL
    SELECT 'SUPER_ADMIN',         'CREDIT_LIMIT_APPROVE',           'Y' UNION ALL
    SELECT 'SUPER_ADMIN',         'ADVANCE_DEPOSIT',                'Y' UNION ALL
    SELECT 'SUPER_ADMIN',         'REFUND_APPROVE',                 'Y' UNION ALL
    SELECT 'SUPER_ADMIN',         'BANK_ACCOUNT_EDIT',              'Y' UNION ALL
    SELECT 'SUPER_ADMIN',         'USER_VIEW',                      'Y' UNION ALL
    SELECT 'SUPER_ADMIN',         'USER_EDIT',                      'Y' UNION ALL
    SELECT 'SUPER_ADMIN',         'USER_STATUS_CHANGE',             'Y' UNION ALL
    SELECT 'SUPER_ADMIN',         'AUDIT_LOG_VIEW',                 'Y' UNION ALL
    SELECT 'SUPER_ADMIN',         'SYSTEM_TENANT_MANAGE',           'Y' UNION ALL

    SELECT 'SELLER_ADMIN',        'PRODUCT_VIEW',                   'Y' UNION ALL
    SELECT 'SELLER_ADMIN',        'PRODUCT_EDIT',                   'Y' UNION ALL
    SELECT 'SELLER_ADMIN',        'PRODUCT_TAX_EDIT',               'Y' UNION ALL
    SELECT 'SELLER_ADMIN',        'PRODUCT_RELATION_EDIT',          'Y' UNION ALL
    SELECT 'SELLER_ADMIN',        'ORDER_VIEW',                     'Y' UNION ALL
    SELECT 'SELLER_ADMIN',        'ORDER_EDIT',                     'Y' UNION ALL
    SELECT 'SELLER_ADMIN',        'ORDER_CANCEL',                   'Y' UNION ALL
    SELECT 'SELLER_ADMIN',        'TAX_DOCUMENT_ISSUE',             'Y' UNION ALL
    SELECT 'SELLER_ADMIN',        'CREDIT_LIMIT_EDIT',              'Y' UNION ALL
    SELECT 'SELLER_ADMIN',        'ADVANCE_DEPOSIT',                'Y' UNION ALL
    SELECT 'SELLER_ADMIN',        'BANK_ACCOUNT_EDIT',              'Y' UNION ALL
    SELECT 'SELLER_ADMIN',        'USER_VIEW',                      'Y' UNION ALL
    SELECT 'SELLER_ADMIN',        'USER_EDIT',                      'Y' UNION ALL
    SELECT 'SELLER_ADMIN',        'USER_STATUS_CHANGE',             'Y' UNION ALL
    SELECT 'SELLER_ADMIN',        'AUDIT_LOG_VIEW',                 'Y' UNION ALL

    SELECT 'CHANNEL_ADMIN',       'PRODUCT_VIEW',                   'Y' UNION ALL
    SELECT 'CHANNEL_ADMIN',       'ORDER_VIEW',                     'Y' UNION ALL
    SELECT 'CHANNEL_ADMIN',       'ORDER_EDIT',                     'Y' UNION ALL
    SELECT 'CHANNEL_ADMIN',       'ORDER_CANCEL',                   'Y' UNION ALL
    SELECT 'CHANNEL_ADMIN',       'USER_VIEW',                      'Y' UNION ALL
    SELECT 'CHANNEL_ADMIN',       'USER_EDIT',                      'Y' UNION ALL

    SELECT 'BUYER_ADMIN',         'PRODUCT_VIEW',                   'Y' UNION ALL
    SELECT 'BUYER_ADMIN',         'ORDER_VIEW',                     'Y' UNION ALL
    SELECT 'BUYER_ADMIN',         'ORDER_EDIT',                     'Y'
) r ON p.permission_code = r.code;

-- -----------------------------------------------------------------------------
-- 3. tb_user_permission_override — 사용자 개별 권한 오버라이드
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_user_permission_override (
    override_id     BIGINT          NOT NULL AUTO_INCREMENT   COMMENT 'ID',
    user_id         BIGINT          NOT NULL                  COMMENT '사용자 ID',
    permission_id   BIGINT          NOT NULL                  COMMENT '권한 ID',
    override_type   ENUM('GRANT','DENY')
                                    NOT NULL                  COMMENT '오버라이드 유형: GRANT=추가부여, DENY=명시적차단',
    reason          VARCHAR(500)    NOT NULL                  COMMENT '사유',
    approved_by     BIGINT          NOT NULL                  COMMENT '승인자 user_id',
    effective_from  DATE            NOT NULL                  COMMENT '유효 시작일',
    effective_to    DATE            NULL                      COMMENT '유효 종료일 (NULL=무기한)',
    created_at      DATETIME        NOT NULL DEFAULT NOW()    COMMENT '생성일시',

    PRIMARY KEY (override_id),

    -- 동일 사용자+권한 중복 오버라이드 불가
    CONSTRAINT uq_tb_upo_user_perm UNIQUE (user_id, permission_id),

    CONSTRAINT fk_tb_upo_user
        FOREIGN KEY (user_id)       REFERENCES tb_user       (user_id),
    CONSTRAINT fk_tb_upo_permission
        FOREIGN KEY (permission_id) REFERENCES tb_permission (permission_id),
    CONSTRAINT fk_tb_upo_approver
        FOREIGN KEY (approved_by)   REFERENCES tb_user       (user_id)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='사용자 개별 권한 오버라이드 (역할 기본값 예외 처리)';

CREATE INDEX idx_tb_upo_user      ON tb_user_permission_override (user_id);
CREATE INDEX idx_tb_upo_effective ON tb_user_permission_override (effective_from, effective_to);

-- -----------------------------------------------------------------------------
-- 4. tb_approval_request — 승인 요청
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_approval_request (
    approval_request_id BIGINT          NOT NULL AUTO_INCREMENT   COMMENT '승인요청 ID',
    tenant_id           BIGINT          NULL                      COMMENT '테넌트 ID (SUPER_ADMIN 요청 시 NULL)',
    request_type        ENUM(
                            'PRODUCT_TAX_CHANGE',
                            'CREDIT_LIMIT_CHANGE',
                            'REFUND',
                            'TAX_DOCUMENT_REISSUE',
                            'USER_PERMISSION_OVERRIDE',
                            'BANK_ACCOUNT_CHANGE'
                        )               NOT NULL                  COMMENT '요청유형',
    ref_table           VARCHAR(100)    NOT NULL                  COMMENT '참조 테이블명',
    ref_id              BIGINT          NOT NULL                  COMMENT '참조 ID',
    request_summary     VARCHAR(1000)   NOT NULL                  COMMENT '요청 요약',
    before_json         LONGTEXT        NULL                      COMMENT '변경 전 데이터 JSON (민감정보 마스킹 필수)',
    after_json          LONGTEXT        NOT NULL                  COMMENT '변경 후 데이터 JSON (민감정보 마스킹 필수)',
    status              ENUM('PENDING','APPROVED','REJECTED','CANCELLED')
                                        NOT NULL DEFAULT 'PENDING'COMMENT '상태',
    requested_by        BIGINT          NOT NULL                  COMMENT '요청자 user_id',
    requested_at        DATETIME        NOT NULL DEFAULT NOW()    COMMENT '요청일시',
    reviewed_by         BIGINT          NULL                      COMMENT '검토자 user_id',
    reviewed_at         DATETIME        NULL                      COMMENT '검토일시',
    review_comment      VARCHAR(1000)   NULL                      COMMENT '검토 의견',
    created_at          DATETIME        NOT NULL DEFAULT NOW()    COMMENT '생성일시',
    updated_at          DATETIME        NOT NULL DEFAULT NOW()
                                        ON UPDATE NOW()          COMMENT '수정일시',

    PRIMARY KEY (approval_request_id),

    CONSTRAINT fk_tb_ar_tenant
        FOREIGN KEY (tenant_id)     REFERENCES tb_tenant (tenant_id),
    CONSTRAINT fk_tb_ar_requester
        FOREIGN KEY (requested_by)  REFERENCES tb_user   (user_id),
    CONSTRAINT fk_tb_ar_reviewer
        FOREIGN KEY (reviewed_by)   REFERENCES tb_user   (user_id)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='승인 요청 (세금변경/여신한도변경/환불/계산서재발행/권한오버라이드/계좌변경)';

CREATE INDEX idx_tb_ar_status      ON tb_approval_request (status, requested_at DESC);
CREATE INDEX idx_tb_ar_requester   ON tb_approval_request (requested_by, status);
CREATE INDEX idx_tb_ar_ref         ON tb_approval_request (ref_table, ref_id);
CREATE INDEX idx_tb_ar_type_tenant ON tb_approval_request (request_type, tenant_id);

-- 승인요청 생성 후 — tb_buyer_credit_limit_history FK 추가
ALTER TABLE tb_buyer_credit_limit_history
    ADD CONSTRAINT fk_tb_bclh_approval
        FOREIGN KEY (approval_request_id) REFERENCES tb_approval_request (approval_request_id);

-- =============================================================================
-- §ALTER — 기존 tb_audit_log 컬럼 확장
-- =============================================================================
-- ⚠️ 기존 tb_audit_log 테이블이 있는 경우에만 실행
--    없다면 USER_MANAGER_SQL_FINAL.sql의 tb_audit_log DDL에 아래 컬럼을 포함시킬 것

ALTER TABLE tb_audit_log
    -- action_type ENUM에 APPROVE, REJECT 추가
    MODIFY COLUMN action_type
        ENUM('INSERT','UPDATE','DELETE','LOGIN','APPROVE','REJECT')
        NOT NULL
        COMMENT '작업유형',

    -- 변경 사유 코드 (신규)
    ADD COLUMN reason_code VARCHAR(100) NULL
        COMMENT '변경 사유 코드'
        AFTER ip_address,

    -- 연관 승인요청 ID (신규)
    ADD COLUMN approval_request_id BIGINT NULL
        COMMENT '연관 승인요청 ID'
        AFTER reason_code,

    -- 분산추적 트레이스 ID (신규)
    ADD COLUMN trace_id VARCHAR(100) NULL
        COMMENT '분산추적 트레이스 ID'
        AFTER approval_request_id;

-- approval_request 생성 후 FK 추가
ALTER TABLE tb_audit_log
    ADD CONSTRAINT fk_tb_al_approval
        FOREIGN KEY (approval_request_id) REFERENCES tb_approval_request (approval_request_id);

CREATE INDEX idx_tb_al_approval ON tb_audit_log (approval_request_id);
CREATE INDEX idx_tb_al_trace    ON tb_audit_log (trace_id);

-- =============================================================================
-- 승인 요청 처리 흐름 (참고 주석)
-- =============================================================================
-- [요청]  tb_approval_request INSERT (status=PENDING)
--       + tb_audit_log INSERT (action_type=INSERT, approval_request_id 기록)
--
-- [승인]  tb_approval_request UPDATE (status=APPROVED, reviewed_by, reviewed_at)
--       + 대상 레코드 실제 변경 (예: tb_buyer_credit_policy.credit_limit_amount)
--       + tb_audit_log INSERT (action_type=APPROVE, before_json/after_json, approval_request_id)
--
-- [반려]  tb_approval_request UPDATE (status=REJECTED, review_comment)
--       + tb_audit_log INSERT (action_type=REJECT, review_comment)
--
-- [취소]  tb_approval_request UPDATE (status=CANCELLED)
--       + tb_audit_log INSERT (action_type=UPDATE)
-- =============================================================================
-- END OF matpam_permission.sql
-- =============================================================================
