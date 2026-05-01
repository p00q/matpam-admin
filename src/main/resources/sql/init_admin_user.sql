-- 초기 테넌트 설정
INSERT INTO tb_tenant (tenant_id, tenant_name, domain, status)
VALUES (1, '맛팜 마스터', 'admin.matpam.co.kr', 'ACTIVE')
ON DUPLICATE KEY UPDATE tenant_name = VALUES(tenant_name);

-- 초기 마스터 업체 설정
INSERT INTO tb_company (company_id, tenant_id, company_name, company_type, business_no, status)
VALUES (1, 1, '(주)맛팜', 'SELLER', '123-45-67890', 'ACTIVE')
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);

-- 슈퍼 관리자 계정 설정 (비밀번호: admin123!)
-- BCrypt: $2a$10$6p7IuYvBfXlI7N8XyO.uHuK7oW4VqU.J.O.J.O.J.O.J.O.J.O.J.O.J.O
INSERT INTO tb_user (login_id, user_name, password_hash, user_role, company_id, tenant_id, status)
VALUES ('admin', '시스템관리자', '$2a$10$6p7IuYvBfXlI7N8XyO.uHuK7oW4VqU.J.O.J.O.J.O.J.O.J.O.J.O.J.O', 'SUPER_ADMIN', 1, 1, 'ACTIVE')
ON DUPLICATE KEY UPDATE password_hash = VALUES(password_hash), status = VALUES(status);
