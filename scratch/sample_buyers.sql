SET FOREIGN_KEY_CHECKS = 0;

-- 1. 테넌트 MATPAM (ID=1)이 이미 있다고 가정

-- 2. 구매업체 샘플 데이터 (BUYER)
INSERT INTO tb_company (tenant_id, company_type, company_name, business_no, ceo_name, default_tax_type, status)
VALUES 
(1, 'BUYER', 'A유통', '111-11-11111', '홍길동', 'TAXABLE', 'ACTIVE'),
(1, 'BUYER', 'B상사', '222-22-22222', '이순신', 'TAXABLE', 'ACTIVE'),
(1, 'BUYER', 'C마트', '333-33-33333', '김철수', 'TAX_FREE', 'ACTIVE')
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);

SET FOREIGN_KEY_CHECKS = 1;
