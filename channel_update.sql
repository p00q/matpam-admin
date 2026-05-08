-- 1. 소유권 컬럼 변경 (tenant_id -> company_id)
-- 레거시 tenant_id가 아직 남아있을 경우 대비하여 컬럼명 변경 (MariaDB/MySQL)
ALTER TABLE tb_channel CHANGE tenant_id company_id BIGINT NOT NULL COMMENT '몰 운영 업체 ID';

-- 2. 중복 역할(채널 유형) 방지 제약조건 추가 (한 업체당 동일 채널 1개만 허용)
-- 먼저 중복된 (company_id, channel_type) 데이터가 있다면 정리해야 제약조건 생성이 성공합니다.
-- 이 스크립트는 기존 데이터 정리가 완료되었다고 가정합니다.
ALTER TABLE tb_channel ADD CONSTRAINT uidx_company_channel_type UNIQUE (company_id, channel_type);

-- 3. 업체 테이블과의 외래키 제약
ALTER TABLE tb_channel ADD CONSTRAINT fk_channel_company FOREIGN KEY (company_id) REFERENCES tb_company(company_id) ON DELETE CASCADE;
