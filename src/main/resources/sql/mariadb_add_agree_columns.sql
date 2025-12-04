-- MariaDB용 TB_MEMBER 마케팅/SMS 수신 동의 컬럼 추가 스크립트
-- 실행 전에 반드시 테이블 백업을 진행하세요.

ALTER TABLE TB_MEMBER
    ADD COLUMN AGREE_MARKETING CHAR(1) NOT NULL DEFAULT 'N' COMMENT '마케팅 정보 수신 동의 여부';

ALTER TABLE TB_MEMBER
    ADD COLUMN AGREE_SMS CHAR(1) NOT NULL DEFAULT 'N' COMMENT 'SMS 수신 동의 여부';

-- 실행 후
-- DESC TB_MEMBER; -- 컬럼 추가 확인
