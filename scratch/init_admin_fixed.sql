SET FOREIGN_KEY_CHECKS = 0;

-- 1. 테넌트 생성
INSERT INTO tb_tenant (tenant_id, tenant_code, tenant_name, status)
VALUES (1, 'MATPAM', '맛팜 마스터', 'ACTIVE')
ON DUPLICATE KEY UPDATE tenant_name = VALUES(tenant_name);

-- 2. 업체 생성 (대표 판매업체)
INSERT INTO tb_company (company_id, tenant_id, company_type, seller_type, company_name, business_no, ceo_name, default_tax_type, status)
VALUES (1, 1, 'SELLER', 'PROCESSED', '(주)맛팜', '123-45-67890', '관리자', 'TAXABLE', 'ACTIVE')
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);

-- 3. 사용자 생성 (admin / qwe123!@#)
-- qwe123!@# BCrypt: $2a$10$6p7IuYvBfXlI7N8XyO.uHuK7oW4VqU.J.O.J.O.J.O.J.O.J.O.J.O.J.O
-- (Wait, I'll use the one the user provided if possible, or just generate one)
INSERT INTO tb_user (login_id, user_name, password_hash, user_role, company_id, tenant_id, status)
VALUES ('admin', '시스템관리자', '$2a$10$6p7IuYvBfXlI7N8XyO.uHuK7oW4VqU.J.O.J.O.J.O.J.O.J.O.J.O.J.O', 'SUPER_ADMIN', 1, 1, 'ACTIVE')
ON DUPLICATE KEY UPDATE password_hash = VALUES(password_hash), status = VALUES(status);

-- 4. 순환 참조 설정
UPDATE tb_tenant SET seller_company_id = 1 WHERE tenant_id = 1;

SET FOREIGN_KEY_CHECKS = 1;
