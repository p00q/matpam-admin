-- ========================================
-- 회원 데이터 마이그레이션 스크립트
-- 기존 영문 코드를 새 코드 테이블 값으로 변환
-- ========================================

-- ========================================
-- 1. 회원타입 변환 (MEMBER_TYPE)
-- ========================================
-- ADMIN → 003001001 (관리자)
UPDATE TB_MEMBER SET MEMBER_TYPE = '003001001' WHERE MEMBER_TYPE = 'ADMIN';

-- SELLER_PROCESSED → 003001005 (가공 판매자)
UPDATE TB_MEMBER SET MEMBER_TYPE = '003001005' WHERE MEMBER_TYPE = 'SELLER_PROCESSED';

-- SELLER_RAW → 003001006 (원물 판매자)
UPDATE TB_MEMBER SET MEMBER_TYPE = '003001006' WHERE MEMBER_TYPE = 'SELLER_RAW';

-- BUYER → 003001007 (구매자)
UPDATE TB_MEMBER SET MEMBER_TYPE = '003001007' WHERE MEMBER_TYPE = 'BUYER';

-- ========================================
-- 2. 가입상태 변환 (STATUS)
-- ========================================
-- PENDING → 004001001 (승인대기)
UPDATE TB_MEMBER SET STATUS = '004001001' WHERE STATUS = 'PENDING';

-- ACTIVE → 004001002 (가입완료)
UPDATE TB_MEMBER SET STATUS = '004001002' WHERE STATUS = 'ACTIVE';

-- INACTIVE → 004001004 (회원탈퇴)
UPDATE TB_MEMBER SET STATUS = '004001004' WHERE STATUS = 'INACTIVE';

-- ========================================
-- 3. 회원등급 변환 (MEMBER_GRADE)
-- ========================================
-- GENERAL → 005001001 (일반)
UPDATE TB_MEMBER SET MEMBER_GRADE = '005001001' WHERE MEMBER_GRADE = 'GENERAL';

-- SILVER → 005001002 (실버)
UPDATE TB_MEMBER SET MEMBER_GRADE = '005001002' WHERE MEMBER_GRADE = 'SILVER';

-- GOLD → 005001003 (골드)
UPDATE TB_MEMBER SET MEMBER_GRADE = '005001003' WHERE MEMBER_GRADE = 'GOLD';

-- VIP → 005001005 (VVIP)
UPDATE TB_MEMBER SET MEMBER_GRADE = '005001005' WHERE MEMBER_GRADE = 'VIP';

-- ========================================
-- 4. 변환 결과 확인
-- ========================================
SELECT 
    '회원타입' as 구분,
    MEMBER_TYPE as 코드값,
    COUNT(*) as 건수
FROM TB_MEMBER
GROUP BY MEMBER_TYPE

UNION ALL

SELECT 
    '가입상태',
    STATUS,
    COUNT(*)
FROM TB_MEMBER
GROUP BY STATUS

UNION ALL

SELECT 
    '회원등급',
    MEMBER_GRADE,
    COUNT(*)
FROM TB_MEMBER
GROUP BY MEMBER_GRADE;

-- ========================================
-- 5. 코드 테이블과 조인하여 검증
-- ========================================
SELECT 
    m.MEMBER_ID,
    m.COMPANY_NAME,
    m.MEMBER_TYPE,
    mt.DETAIL_CODE_NAME as 회원타입명,
    m.STATUS,
    st.DETAIL_CODE_NAME as 가입상태명,
    m.MEMBER_GRADE,
    mg.DETAIL_CODE_NAME as 회원등급명
FROM TB_MEMBER m
LEFT JOIN TB_DETAIL_CODE mt ON m.MEMBER_TYPE = mt.DETAIL_CODE AND mt.GROUP_CODE = '003' AND mt.CODE = '003001'
LEFT JOIN TB_DETAIL_CODE st ON m.STATUS = st.DETAIL_CODE AND st.GROUP_CODE = '004' AND st.CODE = '004001'
LEFT JOIN TB_DETAIL_CODE mg ON m.MEMBER_GRADE = mg.DETAIL_CODE AND mg.GROUP_CODE = '005' AND mg.CODE = '005001'
LIMIT 10;
