/*
  matpam_new 회원/채널/권한 구조 보완 패치
  목적: 슈퍼관리자 -> 업체별 채널관리자(전국택배/직배송/공장수령) -> 채널 담당자의 구매자/상품/주문/출고/정산 관리 구조 반영
  적용 기준: 기존 tb_member_master, tb_buyer_profile, tb_seller_profile, tb_admin_profile, tb_member_contact, tb_code 체계 보완
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

/* 1. 업체 마스터: 한 업체 안에 여러 채널 관리자/구매자/판매자 계정을 둘 수 있도록 분리 */
DROP TABLE IF EXISTS tb_company_master;
CREATE TABLE tb_company_master (
  company_id        BIGINT NOT NULL AUTO_INCREMENT COMMENT '업체ID',
  company_name      VARCHAR(200) NOT NULL COMMENT '업체명',
  biz_reg_no        VARCHAR(20) DEFAULT NULL COMMENT '사업자등록번호',
  ceo_name          VARCHAR(100) DEFAULT NULL COMMENT '대표자명',
  company_tel_no    VARCHAR(20) DEFAULT NULL COMMENT '회사전화번호',
  ceo_mobile_no     VARCHAR(20) DEFAULT NULL COMMENT '대표자 휴대폰번호',
  email             VARCHAR(200) DEFAULT NULL COMMENT '대표 이메일',
  zip_code          VARCHAR(10) DEFAULT NULL COMMENT '우편번호',
  addr1             VARCHAR(200) DEFAULT NULL COMMENT '기본주소',
  addr2             VARCHAR(200) DEFAULT NULL COMMENT '상세주소',
  company_status_cd VARCHAR(30) NOT NULL DEFAULT 'COMPANY_ACTIVE' COMMENT '업체상태코드',
  use_yn            CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  del_yn            CHAR(1) NOT NULL DEFAULT 'N' COMMENT '삭제여부',
  reg_id            VARCHAR(20) DEFAULT NULL COMMENT '등록자ID',
  reg_dt            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  mod_id            VARCHAR(20) DEFAULT NULL COMMENT '수정자ID',
  mod_dt            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
  PRIMARY KEY (company_id),
  UNIQUE KEY UQ_COMPANY_BIZ_REG_NO (biz_reg_no),
  KEY IX_COMPANY_STATUS (company_status_cd, use_yn, del_yn)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='업체 마스터';

/* 2. 회원 마스터: 회원은 로그인 계정, 업체는 company_id로 연결. 채널/역할은 별도 매핑으로 관리 */
DROP TABLE IF EXISTS tb_member_master;
CREATE TABLE tb_member_master (
  member_id        BIGINT NOT NULL AUTO_INCREMENT COMMENT '회원ID',
  company_id       BIGINT DEFAULT NULL COMMENT '소속 업체ID. 슈퍼관리자는 NULL 가능',
  member_type_cd   VARCHAR(30) NOT NULL COMMENT '회원유형: SUPER_ADMIN, COMPANY_ADMIN, BUYER, RAW_SELLER, PROCESS_SELLER',
  login_id         VARCHAR(50) NOT NULL COMMENT '로그인ID',
  login_pwd        VARCHAR(200) NOT NULL COMMENT '비밀번호해시',
  member_name      VARCHAR(100) DEFAULT NULL COMMENT '회원/담당자명',
  mobile_no        VARCHAR(30) DEFAULT NULL COMMENT '휴대폰번호',
  email            VARCHAR(200) DEFAULT NULL COMMENT '이메일주소',
  join_status_cd   VARCHAR(30) NOT NULL DEFAULT 'JOIN_ACTIVE' COMMENT '가입상태코드',
  last_login_dt    DATETIME DEFAULT NULL COMMENT '최근접속일시',
  join_dt          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '가입일시',
  withdraw_dt      DATETIME DEFAULT NULL COMMENT '탈퇴일시',
  created_by_member_id BIGINT DEFAULT NULL COMMENT '계정 생성 관리자 회원ID',
  use_yn           CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  del_yn           CHAR(1) NOT NULL DEFAULT 'N' COMMENT '삭제여부',
  reg_id           VARCHAR(20) DEFAULT NULL COMMENT '등록자ID',
  reg_dt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  mod_id           VARCHAR(20) DEFAULT NULL COMMENT '수정자ID',
  mod_dt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
  PRIMARY KEY (member_id),
  UNIQUE KEY UQ_MEMBER_LOGIN_ID (login_id),
  KEY IX_MEMBER_COMPANY_TYPE (company_id, member_type_cd, use_yn, del_yn),
  KEY IX_MEMBER_CREATED_BY (created_by_member_id),
  CONSTRAINT FK_MEMBER_COMPANY FOREIGN KEY (company_id) REFERENCES tb_company_master (company_id),
  CONSTRAINT FK_MEMBER_CREATED_BY FOREIGN KEY (created_by_member_id) REFERENCES tb_member_master (member_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='회원 로그인 계정 마스터';

/* 3. 회원 채널 권한 범위: 한 계정이 어느 업체의 어느 채널에서 어떤 역할로 일하는지 관리 */
DROP TABLE IF EXISTS tb_member_channel_role;
CREATE TABLE tb_member_channel_role (
  member_channel_role_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '회원채널역할ID',
  member_id        BIGINT NOT NULL COMMENT '회원ID',
  company_id       BIGINT DEFAULT NULL COMMENT '업체ID. 슈퍼관리자 전역권한은 NULL 가능',
  channel_cd       VARCHAR(30) NOT NULL COMMENT '채널코드: SUPER, COURIER_SERVICE, DIRECT_DELIVERY, FACTORY_PICKUP',
  role_cd          VARCHAR(30) NOT NULL COMMENT '역할코드: SUPER_ADMIN, CHANNEL_ADMIN, BUYER_MANAGER, PRODUCT_MANAGER, ORDER_MANAGER, SHIPMENT_MANAGER, SETTLEMENT_MANAGER, SELLER',
  scope_cd         VARCHAR(30) NOT NULL DEFAULT 'CHANNEL' COMMENT '권한범위: GLOBAL, COMPANY, CHANNEL',
  use_yn           CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  del_yn           CHAR(1) NOT NULL DEFAULT 'N' COMMENT '삭제여부',
  reg_id           VARCHAR(20) DEFAULT NULL COMMENT '등록자ID',
  reg_dt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  mod_id           VARCHAR(20) DEFAULT NULL COMMENT '수정자ID',
  mod_dt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
  PRIMARY KEY (member_channel_role_id),
  UNIQUE KEY UQ_MEMBER_CHANNEL_ROLE (member_id, company_id, channel_cd, role_cd),
  KEY IX_CHANNEL_ROLE_LOOKUP (company_id, channel_cd, role_cd, use_yn, del_yn),
  CONSTRAINT FK_MCR_MEMBER FOREIGN KEY (member_id) REFERENCES tb_member_master (member_id),
  CONSTRAINT FK_MCR_COMPANY FOREIGN KEY (company_id) REFERENCES tb_company_master (company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='회원별 업체/채널/업무권한 매핑';

/* 4. 구매자 프로필: 구매자는 특정 업체/채널 담당자가 등록하며, 운영 채널을 명시 */
DROP TABLE IF EXISTS tb_buyer_profile;
CREATE TABLE tb_buyer_profile (
  member_id          BIGINT NOT NULL COMMENT '회원ID',
  company_id         BIGINT NOT NULL COMMENT '구매자 업체ID',
  managing_channel_cd VARCHAR(30) NOT NULL COMMENT '담당 운영채널',
  member_grade_cd    VARCHAR(30) DEFAULT NULL COMMENT '구매자 등급',
  credit_balance_amt DECIMAL(18,2) NOT NULL DEFAULT 0.00 COMMENT '현재 여신잔액',
  meatmoney_balance_amt DECIMAL(18,2) NOT NULL DEFAULT 0.00 COMMENT '미트머니 잔액',
  total_available_amt DECIMAL(18,2) NOT NULL DEFAULT 0.00 COMMENT '구매 가능 금액',
  month_order_amt    DECIMAL(18,2) DEFAULT 0.00 COMMENT '월 누적 주문금액',
  year_order_amt     DECIMAL(18,2) DEFAULT 0.00 COMMENT '연 누적 주문금액',
  total_order_amt    DECIMAL(18,2) DEFAULT 0.00 COMMENT '총 누적 주문금액',
  created_by_member_id BIGINT DEFAULT NULL COMMENT '등록한 채널 담당자 회원ID',
  use_yn             CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  reg_dt             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  mod_dt             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
  PRIMARY KEY (member_id),
  KEY IX_BUYER_COMPANY_CHANNEL (company_id, managing_channel_cd, use_yn),
  KEY IX_BUYER_CREATED_BY (created_by_member_id),
  CONSTRAINT FK_BUYER_MEMBER FOREIGN KEY (member_id) REFERENCES tb_member_master (member_id),
  CONSTRAINT FK_BUYER_COMPANY FOREIGN KEY (company_id) REFERENCES tb_company_master (company_id),
  CONSTRAINT FK_BUYER_CREATED_BY FOREIGN KEY (created_by_member_id) REFERENCES tb_member_master (member_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='구매자 프로필';

/* 5. 판매자 프로필: 원물/가공 판매자를 업체와 연결 */
DROP TABLE IF EXISTS tb_seller_profile;
CREATE TABLE tb_seller_profile (
  member_id        BIGINT NOT NULL COMMENT '회원ID',
  company_id       BIGINT NOT NULL COMMENT '판매자 업체ID',
  seller_type_cd   VARCHAR(30) NOT NULL COMMENT '판매자타입: SELLER_RAW, SELLER_PROCESS',
  tax_type_cd      VARCHAR(30) DEFAULT NULL COMMENT '과세유형',
  created_by_member_id BIGINT DEFAULT NULL COMMENT '등록한 관리자 회원ID',
  use_yn           CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  reg_dt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  mod_dt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
  PRIMARY KEY (member_id),
  KEY IX_SELLER_COMPANY_TYPE (company_id, seller_type_cd, use_yn),
  CONSTRAINT FK_SELLER_MEMBER FOREIGN KEY (member_id) REFERENCES tb_member_master (member_id),
  CONSTRAINT FK_SELLER_COMPANY FOREIGN KEY (company_id) REFERENCES tb_company_master (company_id),
  CONSTRAINT FK_SELLER_CREATED_BY FOREIGN KEY (created_by_member_id) REFERENCES tb_member_master (member_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='판매자 프로필';

/* 6. 판매자 정산 계좌: 업체 기준 대표 정산계좌 관리 */
DROP TABLE IF EXISTS tb_seller_settlement_account;
CREATE TABLE tb_seller_settlement_account (
  settlement_id    BIGINT NOT NULL AUTO_INCREMENT COMMENT '정산ID',
  company_id       BIGINT NOT NULL COMMENT '판매자 업체ID',
  seller_member_id BIGINT DEFAULT NULL COMMENT '판매자 회원ID. 업체 공통계좌이면 NULL 가능',
  bank_cd          VARCHAR(30) DEFAULT NULL COMMENT '은행코드',
  account_no       VARCHAR(100) DEFAULT NULL COMMENT '계좌번호',
  account_name     VARCHAR(100) DEFAULT NULL COMMENT '예금주',
  default_yn       CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '기본계좌여부',
  use_yn           CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  reg_dt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  mod_dt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
  PRIMARY KEY (settlement_id),
  KEY IX_SELLER_SETTLE_COMPANY (company_id, default_yn, use_yn),
  CONSTRAINT FK_SELLER_SETTLE_COMPANY FOREIGN KEY (company_id) REFERENCES tb_company_master (company_id),
  CONSTRAINT FK_SELLER_SETTLE_MEMBER FOREIGN KEY (seller_member_id) REFERENCES tb_member_master (member_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='판매자 정산 계좌';

/* 7. 담당자 정보: 회원 또는 업체 담당자 모두 수용 */
DROP TABLE IF EXISTS tb_member_contact;
CREATE TABLE tb_member_contact (
  contact_id       BIGINT NOT NULL AUTO_INCREMENT COMMENT '담당자ID',
  company_id       BIGINT DEFAULT NULL COMMENT '업체ID',
  member_id        BIGINT DEFAULT NULL COMMENT '회원ID',
  name             VARCHAR(100) NOT NULL COMMENT '담당자명',
  mobile_no        VARCHAR(30) DEFAULT NULL COMMENT '담당자 휴대폰번호',
  phone_no         VARCHAR(30) DEFAULT NULL COMMENT '담당자 유선전화번호',
  email            VARCHAR(100) DEFAULT NULL COMMENT '담당자 이메일',
  contact_type_cd  VARCHAR(30) NOT NULL COMMENT '담당자유형',
  channel_cd       VARCHAR(30) DEFAULT NULL COMMENT '담당 채널',
  use_yn           CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  reg_dt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  mod_dt           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
  PRIMARY KEY (contact_id),
  KEY IX_CONTACT_COMPANY (company_id, contact_type_cd, channel_cd, use_yn),
  KEY IX_CONTACT_MEMBER (member_id, contact_type_cd, use_yn),
  CONSTRAINT FK_CONTACT_COMPANY FOREIGN KEY (company_id) REFERENCES tb_company_master (company_id),
  CONSTRAINT FK_CONTACT_MEMBER FOREIGN KEY (member_id) REFERENCES tb_member_master (member_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='회원/업체 담당자 정보';

SET FOREIGN_KEY_CHECKS = 1;

/* 8. 공통코드 보완: 기존 tb_group_code/tb_code/tb_detail_code가 생성된 뒤 실행 */
INSERT INTO tb_group_code (CODE_GROUP_ID, CODE_GROUP_NAME, USE_YN, REG_ID, DEL_YN)
VALUES
  ('COMPANY_STATUS', '업체상태', 'Y', 'SYSTEM', 'N'),
  ('MEMBER_TYPE', '회원유형', 'Y', 'SYSTEM', 'N'),
  ('CHANNEL_TYPE', '채널유형', 'Y', 'SYSTEM', 'N'),
  ('ROLE_TYPE', '업무권한유형', 'Y', 'SYSTEM', 'N'),
  ('AUTH_SCOPE', '권한범위', 'Y', 'SYSTEM', 'N')
ON DUPLICATE KEY UPDATE CODE_GROUP_NAME = VALUES(CODE_GROUP_NAME), USE_YN = 'Y', DEL_YN = 'N';

INSERT INTO tb_code (CODE_GROUP_ID, CODE_ID, CODE_NAME, SORT_ORDER, USE_YN, REG_ID, DEL_YN)
VALUES
  ('COMPANY_STATUS', 'COMPANY_STATUS', '업체상태', 1, 'Y', 'SYSTEM', 'N'),
  ('MEMBER_TYPE', 'MEMBER_TYPE', '회원유형', 1, 'Y', 'SYSTEM', 'N'),
  ('CHANNEL_TYPE', 'CHANNEL_TYPE', '채널유형', 1, 'Y', 'SYSTEM', 'N'),
  ('ROLE_TYPE', 'ROLE_TYPE', '업무권한유형', 1, 'Y', 'SYSTEM', 'N'),
  ('AUTH_SCOPE', 'AUTH_SCOPE', '권한범위', 1, 'Y', 'SYSTEM', 'N')
ON DUPLICATE KEY UPDATE CODE_NAME = VALUES(CODE_NAME), USE_YN = 'Y', DEL_YN = 'N';

INSERT INTO tb_detail_code (CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER, USE_YN, REG_ID, DEL_YN)
VALUES
  ('COMPANY_STATUS', 'COMPANY_STATUS', 'COMPANY_ACTIVE', '정상', 1, 'Y', 'SYSTEM', 'N'),
  ('COMPANY_STATUS', 'COMPANY_STATUS', 'COMPANY_STOP', '거래중지', 2, 'Y', 'SYSTEM', 'N'),

  ('MEMBER_TYPE', 'MEMBER_TYPE', 'SUPER_ADMIN', '수퍼관리자', 1, 'Y', 'SYSTEM', 'N'),
  ('MEMBER_TYPE', 'MEMBER_TYPE', 'COMPANY_ADMIN', '업체관리자', 2, 'Y', 'SYSTEM', 'N'),
  ('MEMBER_TYPE', 'MEMBER_TYPE', 'BUYER', '구매자', 3, 'Y', 'SYSTEM', 'N'),
  ('MEMBER_TYPE', 'MEMBER_TYPE', 'RAW_SELLER', '원물판매자', 4, 'Y', 'SYSTEM', 'N'),
  ('MEMBER_TYPE', 'MEMBER_TYPE', 'PROCESS_SELLER', '가공판매자', 5, 'Y', 'SYSTEM', 'N'),

  ('CHANNEL_TYPE', 'CHANNEL_TYPE', 'SUPER', '수퍼관리', 0, 'Y', 'SYSTEM', 'N'),
  ('CHANNEL_TYPE', 'CHANNEL_TYPE', 'COURIER_SERVICE', '전국택배', 1, 'Y', 'SYSTEM', 'N'),
  ('CHANNEL_TYPE', 'CHANNEL_TYPE', 'DIRECT_DELIVERY', '직배송', 2, 'Y', 'SYSTEM', 'N'),
  ('CHANNEL_TYPE', 'CHANNEL_TYPE', 'FACTORY_PICKUP', '공장수령', 3, 'Y', 'SYSTEM', 'N'),

  ('ROLE_TYPE', 'ROLE_TYPE', 'SUPER_ADMIN', '수퍼관리자', 1, 'Y', 'SYSTEM', 'N'),
  ('ROLE_TYPE', 'ROLE_TYPE', 'CHANNEL_ADMIN', '채널관리자', 2, 'Y', 'SYSTEM', 'N'),
  ('ROLE_TYPE', 'ROLE_TYPE', 'BUYER_MANAGER', '구매자관리', 3, 'Y', 'SYSTEM', 'N'),
  ('ROLE_TYPE', 'ROLE_TYPE', 'PRODUCT_MANAGER', '상품관리', 4, 'Y', 'SYSTEM', 'N'),
  ('ROLE_TYPE', 'ROLE_TYPE', 'ORDER_MANAGER', '주문관리', 5, 'Y', 'SYSTEM', 'N'),
  ('ROLE_TYPE', 'ROLE_TYPE', 'SHIPMENT_MANAGER', '출고관리', 6, 'Y', 'SYSTEM', 'N'),
  ('ROLE_TYPE', 'ROLE_TYPE', 'SETTLEMENT_MANAGER', '정산관리', 7, 'Y', 'SYSTEM', 'N'),
  ('ROLE_TYPE', 'ROLE_TYPE', 'SELLER', '판매자', 8, 'Y', 'SYSTEM', 'N'),

  ('AUTH_SCOPE', 'AUTH_SCOPE', 'GLOBAL', '전체', 1, 'Y', 'SYSTEM', 'N'),
  ('AUTH_SCOPE', 'AUTH_SCOPE', 'COMPANY', '업체', 2, 'Y', 'SYSTEM', 'N'),
  ('AUTH_SCOPE', 'AUTH_SCOPE', 'CHANNEL', '채널', 3, 'Y', 'SYSTEM', 'N')
ON DUPLICATE KEY UPDATE DETAIL_CODE_NAME = VALUES(DETAIL_CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = 'Y', DEL_YN = 'N';

/* 9. 권장 초기 권한 예시
   - 수퍼관리자: tb_member_master.company_id NULL, tb_member_channel_role channel_cd='SUPER', role_cd='SUPER_ADMIN', scope_cd='GLOBAL'
   - 업체별 전국택배 관리자: company_id 지정, channel_cd='COURIER_SERVICE', role_cd='CHANNEL_ADMIN', scope_cd='CHANNEL'
   - 업체별 직배송 관리자: company_id 지정, channel_cd='DIRECT_DELIVERY', role_cd='CHANNEL_ADMIN', scope_cd='CHANNEL'
   - 업체별 공장수령 관리자: company_id 지정, channel_cd='FACTORY_PICKUP', role_cd='CHANNEL_ADMIN', scope_cd='CHANNEL'
*/
