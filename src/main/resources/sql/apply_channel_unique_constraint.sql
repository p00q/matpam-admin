-- tb_channel 테이블 채널 유형 중복 방지 제약 조건 추가
-- 업체(company_id)별로 활성화된(status='ACTIVE') 채널 중 동일한 유형(channel_type)이 존재하지 않도록 보장합니다.

-- 1. 기존 유니크 키 확인 및 필요시 삭제 (기존에 tenant_id 기반 키가 있다면 비즈니스 로직에 맞춰 교체 권장)
-- ALTER TABLE tb_channel DROP INDEX uk_tb_channel_01;

-- 2. 신규 유니크 인덱스 추가
-- 주의: 기존 데이터에 중복이 있을 경우 생성이 실패하므로 사전에 데이터 정리가 필요합니다.
ALTER TABLE tb_channel ADD UNIQUE KEY uk_tb_channel_company_type (company_id, channel_type);
