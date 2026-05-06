-- =============================================================================
-- MATPAM B2B 플랫폼 — 자금/여신 도메인 DDL
-- 작성일: 2026-05-01
-- 참조: MATPAM_MANAGER.md §5~§6
-- 대상 DB: MariaDB 10.5+
-- =============================================================================
-- ⚠️ 실행 전 확인 사항:
--   1) tb_tenant, tb_company, tb_user, tb_order 가 먼저 생성되어 있어야 함
--   2) 자금 모델 A 확정: 플랫폼은 원장 기록자. 입금처는 판매업체 계좌
--   3) 계좌번호 등 민감정보 평문 저장 금지 (AES 암호화 후 저장)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. tb_external_payment_txn — 외부 결제·입금 거래
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_external_payment_txn (
    payment_txn_id      BIGINT          NOT NULL AUTO_INCREMENT   COMMENT '결제거래 ID',
    tenant_id           BIGINT          NOT NULL                  COMMENT '테넌트 ID',
    seller_company_id   BIGINT          NOT NULL                  COMMENT '판매업체 ID',
    buyer_company_id    BIGINT          NOT NULL                  COMMENT '구매업체 ID',
    txn_type            ENUM('ADVANCE_DEPOSIT','REFUND','CREDIT_PAYMENT','ADJUSTMENT')
                                        NOT NULL                  COMMENT '거래유형',
    amount              DECIMAL(18,2)   NOT NULL                  COMMENT '금액 (항상 양수)',
    bank_name           VARCHAR(100)    NULL                      COMMENT '입금 은행명',
    account_no_masked   VARCHAR(50)     NULL                      COMMENT '입금 계좌번호 (마스킹: ****-****-1234)',
    depositor_name      VARCHAR(100)    NULL                      COMMENT '입금자명',
    txn_memo            VARCHAR(500)    NULL                      COMMENT '거래 메모',
    confirmed_by        BIGINT          NULL                      COMMENT '확인자 user_id',
    confirmed_at        DATETIME        NULL                      COMMENT '확인 일시',
    created_by          BIGINT          NOT NULL                  COMMENT '등록자 user_id',
    created_at          DATETIME        NOT NULL DEFAULT NOW()     COMMENT '생성일시',

    PRIMARY KEY (payment_txn_id),

    CONSTRAINT chk_tb_ept_amount CHECK (amount > 0),

    CONSTRAINT fk_tb_ept_tenant
        FOREIGN KEY (tenant_id)         REFERENCES tb_tenant  (tenant_id),
    CONSTRAINT fk_tb_ept_seller
        FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_ept_buyer
        FOREIGN KEY (buyer_company_id)  REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_ept_confirmer
        FOREIGN KEY (confirmed_by)      REFERENCES tb_user    (user_id),
    CONSTRAINT fk_tb_ept_creator
        FOREIGN KEY (created_by)        REFERENCES tb_user    (user_id)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='외부 결제·입금 거래 기록 (모델 A: 판매사 직접 수금)';

CREATE INDEX idx_tb_ept_tenant_seller ON tb_external_payment_txn (tenant_id, seller_company_id);
CREATE INDEX idx_tb_ept_buyer         ON tb_external_payment_txn (buyer_company_id, created_at DESC);
CREATE INDEX idx_tb_ept_txn_type      ON tb_external_payment_txn (txn_type);

-- -----------------------------------------------------------------------------
-- 2. tb_buyer_advance_ledger — 구매업체 선급금 원장
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_buyer_advance_ledger (
    ledger_id           BIGINT          NOT NULL AUTO_INCREMENT   COMMENT '원장 ID',
    tenant_id           BIGINT          NOT NULL                  COMMENT '테넌트 ID',
    seller_company_id   BIGINT          NOT NULL                  COMMENT '판매업체 ID',
    buyer_company_id    BIGINT          NOT NULL                  COMMENT '구매업체 ID',
    txn_type            ENUM('DEPOSIT','USE','REFUND','ADJUST')
                                        NOT NULL                  COMMENT '거래유형: DEPOSIT=입금, USE=주문사용, REFUND=환불, ADJUST=조정',
    amount              DECIMAL(18,2)   NOT NULL                  COMMENT '금액 (양수=증가, 음수=감소)',
    balance_after       DECIMAL(18,2)   NOT NULL                  COMMENT '거래 후 선급금 잔액',
    ref_table           VARCHAR(100)    NULL                      COMMENT '참조 테이블명',
    ref_id              BIGINT          NULL                      COMMENT '참조 ID',
    txn_memo            VARCHAR(500)    NULL                      COMMENT '거래 메모',
    created_by          BIGINT          NOT NULL                  COMMENT '작성자 user_id',
    created_at          DATETIME        NOT NULL DEFAULT NOW()     COMMENT '생성일시',

    PRIMARY KEY (ledger_id),

    -- 잔액은 음수 불가 (정책: 선급금 초과 사용 금지)
    CONSTRAINT chk_tb_bal_balance CHECK (balance_after >= 0),

    CONSTRAINT fk_tb_bal_tenant
        FOREIGN KEY (tenant_id)         REFERENCES tb_tenant  (tenant_id),
    CONSTRAINT fk_tb_bal_seller
        FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_bal_buyer
        FOREIGN KEY (buyer_company_id)  REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_bal_creator
        FOREIGN KEY (created_by)        REFERENCES tb_user    (user_id)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='구매업체 선급금 원장 (판매사별)';

CREATE INDEX idx_tb_bal_seller_buyer ON tb_buyer_advance_ledger (seller_company_id, buyer_company_id, created_at DESC);
CREATE INDEX idx_tb_bal_ref          ON tb_buyer_advance_ledger (ref_table, ref_id);

-- -----------------------------------------------------------------------------
-- 3. tb_payment_allocation — 결제 배분 기록 ★ 핵심
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_payment_allocation (
    allocation_id       BIGINT          NOT NULL AUTO_INCREMENT   COMMENT '배분 ID',
    order_id            BIGINT          NOT NULL                  COMMENT '주문 ID',
    tenant_id           BIGINT          NOT NULL                  COMMENT '테넌트 ID',
    seller_company_id   BIGINT          NOT NULL                  COMMENT '판매업체 ID',
    buyer_company_id    BIGINT          NOT NULL                  COMMENT '구매업체 ID',
    source_type         ENUM('ADVANCE','CREDIT','EXTERNAL_PAYMENT')
                                        NOT NULL                  COMMENT '재원유형: ADVANCE=선급금, CREDIT=여신, EXTERNAL_PAYMENT=외부직접결제',
    source_ref_id       BIGINT          NULL                      COMMENT '재원 참조 ID (ledger_id 또는 payment_txn_id)',
    allocated_amount    DECIMAL(18,2)   NOT NULL                  COMMENT '배분 금액',
    allocated_at        DATETIME        NOT NULL                  COMMENT '배분 일시',
    created_by          BIGINT          NOT NULL                  COMMENT '작성자 user_id',
    created_at          DATETIME        NOT NULL DEFAULT NOW()     COMMENT '생성일시',

    PRIMARY KEY (allocation_id),

    CONSTRAINT chk_tb_pa_amount CHECK (allocated_amount > 0),

    CONSTRAINT fk_tb_pa_order
        FOREIGN KEY (order_id)          REFERENCES tb_order   (order_id),
    CONSTRAINT fk_tb_pa_tenant
        FOREIGN KEY (tenant_id)         REFERENCES tb_tenant  (tenant_id),
    CONSTRAINT fk_tb_pa_seller
        FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_pa_buyer
        FOREIGN KEY (buyer_company_id)  REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_pa_creator
        FOREIGN KEY (created_by)        REFERENCES tb_user    (user_id)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='결제 배분 기록 (선급금/여신/외부결제 혼합 지원)';

-- 결제 배분 우선순위 정책:
--   1순위: ADVANCE (선급금)
--   2순위: CREDIT (여신한도)
--   3순위: EXTERNAL_PAYMENT (외부 직접 결제)
-- 주문 1건에 여러 재원이 혼합될 수 있어 source_type별 행을 분리 기록

CREATE INDEX idx_tb_pa_order       ON tb_payment_allocation (order_id, source_type);
CREATE INDEX idx_tb_pa_seller_buyer ON tb_payment_allocation (seller_company_id, buyer_company_id);

-- -----------------------------------------------------------------------------
-- 4. tb_buyer_credit_policy — 구매업체 여신 정책
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_buyer_credit_policy (
    policy_id           BIGINT          NOT NULL AUTO_INCREMENT   COMMENT '정책 ID',
    tenant_id           BIGINT          NOT NULL                  COMMENT '테넌트 ID',
    seller_company_id   BIGINT          NOT NULL                  COMMENT '판매업체 ID (채권자)',
    buyer_company_id    BIGINT          NOT NULL                  COMMENT '구매업체 ID (채무자)',
    credit_limit_amount DECIMAL(18,2)   NOT NULL DEFAULT 0        COMMENT '여신한도 금액',
    payment_terms_days  INT             NOT NULL DEFAULT 30       COMMENT '결제 조건 일수',
    status              ENUM('ACTIVE','SUSPENDED','TERMINATED')
                                        NOT NULL DEFAULT 'ACTIVE' COMMENT '정책 상태',
    approved_by         BIGINT          NULL                      COMMENT '승인자 user_id',
    approved_at         DATETIME        NULL                      COMMENT '승인일시',
    created_by          BIGINT          NOT NULL                  COMMENT '등록자 user_id',
    created_at          DATETIME        NOT NULL DEFAULT NOW()     COMMENT '생성일시',
    updated_at          DATETIME        NOT NULL DEFAULT NOW()
                                        ON UPDATE NOW()           COMMENT '수정일시',

    PRIMARY KEY (policy_id),

    -- 판매사-구매사 간 정책 1건 제한
    CONSTRAINT uq_tb_bcp_pair
        UNIQUE (tenant_id, seller_company_id, buyer_company_id),

    CONSTRAINT chk_tb_bcp_limit CHECK (credit_limit_amount >= 0),
    CONSTRAINT chk_tb_bcp_days  CHECK (payment_terms_days  >= 0),

    CONSTRAINT fk_tb_bcp_tenant
        FOREIGN KEY (tenant_id)         REFERENCES tb_tenant  (tenant_id),
    CONSTRAINT fk_tb_bcp_seller
        FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_bcp_buyer
        FOREIGN KEY (buyer_company_id)  REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_bcp_approver
        FOREIGN KEY (approved_by)       REFERENCES tb_user    (user_id),
    CONSTRAINT fk_tb_bcp_creator
        FOREIGN KEY (created_by)        REFERENCES tb_user    (user_id)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='구매업체 여신 정책 (판매사가 구매사에 부여하는 외상 한도)';

CREATE INDEX idx_tb_bcp_seller_buyer ON tb_buyer_credit_policy (seller_company_id, buyer_company_id);
CREATE INDEX idx_tb_bcp_status       ON tb_buyer_credit_policy (status);

-- -----------------------------------------------------------------------------
-- 5. tb_buyer_credit_limit_history — 여신한도 변경 이력
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_buyer_credit_limit_history (
    history_id              BIGINT          NOT NULL AUTO_INCREMENT   COMMENT '이력 ID',
    policy_id               BIGINT          NOT NULL                  COMMENT '정책 ID',
    old_limit               DECIMAL(18,2)   NOT NULL                  COMMENT '변경 전 한도',
    new_limit               DECIMAL(18,2)   NOT NULL                  COMMENT '변경 후 한도',
    reason                  VARCHAR(500)    NOT NULL                  COMMENT '변경 사유',
    requested_by            BIGINT          NOT NULL                  COMMENT '요청자 user_id',
    approved_by             BIGINT          NULL                      COMMENT '승인자 user_id',
    approved_at             DATETIME        NULL                      COMMENT '승인일시',
    approval_request_id     BIGINT          NULL                      COMMENT '승인요청 ID',
    created_at              DATETIME        NOT NULL DEFAULT NOW()     COMMENT '생성일시',

    PRIMARY KEY (history_id),

    CONSTRAINT chk_tb_bclh_limits CHECK (
        old_limit >= 0 AND new_limit >= 0
    ),

    CONSTRAINT fk_tb_bclh_policy
        FOREIGN KEY (policy_id)     REFERENCES tb_buyer_credit_policy (policy_id),
    CONSTRAINT fk_tb_bclh_requester
        FOREIGN KEY (requested_by)  REFERENCES tb_user (user_id),
    CONSTRAINT fk_tb_bclh_approver
        FOREIGN KEY (approved_by)   REFERENCES tb_user (user_id)
    -- approval_request_id FK는 tb_approval_request 생성 후 별도 ALTER로 추가

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='여신한도 변경 이력';

CREATE INDEX idx_tb_bclh_policy ON tb_buyer_credit_limit_history (policy_id, created_at DESC);

-- -----------------------------------------------------------------------------
-- 6. tb_receivable_ledger — 외상매출금 원장
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_receivable_ledger (
    receivable_id       BIGINT          NOT NULL AUTO_INCREMENT   COMMENT '원장 ID',
    tenant_id           BIGINT          NOT NULL                  COMMENT '테넌트 ID',
    seller_company_id   BIGINT          NOT NULL                  COMMENT '판매업체 ID (채권자)',
    buyer_company_id    BIGINT          NOT NULL                  COMMENT '구매업체 ID (채무자)',
    txn_type            ENUM('ORDER_USE','PAYMENT_RECEIPT','ADJUST','REFUND')
                                        NOT NULL                  COMMENT '거래유형',
    amount              DECIMAL(18,2)   NOT NULL                  COMMENT '금액 (양수=채권증가, 음수=채권감소)',
    balance_after       DECIMAL(18,2)   NOT NULL                  COMMENT '거래 후 채권 잔액',
    ref_table           VARCHAR(100)    NULL                      COMMENT '참조 테이블명',
    ref_id              BIGINT          NULL                      COMMENT '참조 ID',
    txn_memo            VARCHAR(500)    NULL                      COMMENT '거래 메모',
    created_by          BIGINT          NOT NULL                  COMMENT '작성자 user_id',
    created_at          DATETIME        NOT NULL DEFAULT NOW()     COMMENT '생성일시',

    PRIMARY KEY (receivable_id),

    CONSTRAINT fk_tb_rl_tenant
        FOREIGN KEY (tenant_id)         REFERENCES tb_tenant  (tenant_id),
    CONSTRAINT fk_tb_rl_seller
        FOREIGN KEY (seller_company_id) REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_rl_buyer
        FOREIGN KEY (buyer_company_id)  REFERENCES tb_company (company_id),
    CONSTRAINT fk_tb_rl_creator
        FOREIGN KEY (created_by)        REFERENCES tb_user    (user_id)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='외상매출금 원장 (여신 사용·수금·환불 전체 기록)';

-- txn_type 의미:
--   ORDER_USE      : 주문으로 여신 사용 (+ 채권 증가)
--   PAYMENT_RECEIPT: 대금 수령    (- 채권 감소)
--   ADJUST         : 조정          (± 채권 변동)
--   REFUND         : 환불 처리    (- 채권 감소)

CREATE INDEX idx_tb_rl_seller_buyer ON tb_receivable_ledger (seller_company_id, buyer_company_id, created_at DESC);
CREATE INDEX idx_tb_rl_ref          ON tb_receivable_ledger (ref_table, ref_id);
CREATE INDEX idx_tb_rl_txn_type     ON tb_receivable_ledger (txn_type);

-- =============================================================================
-- END OF matpam_finance.sql
-- =============================================================================
