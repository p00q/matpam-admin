-- ========================================
-- 코드 데이터 INSERT 쿼리 (이미지 기반)
-- ========================================

-- 기존 샘플 데이터 삭제 (선택사항)
-- DELETE FROM TB_DETAIL_CODE;
-- DELETE FROM TB_CODE;
-- DELETE FROM TB_GROUP_CODE;

-- ========================================
-- 그룹코드 등록
-- ========================================
INSERT INTO TB_GROUP_CODE (GROUP_CODE, GROUP_CODE_NAME, USE_YN) VALUES
('001', '상품유형', 'Y'),
('002', '거래고객', 'Y'),
('003', '회원타입', 'Y'),
('004', '가입상태', 'Y'),
('005', '회원등급', 'Y'),
('006', '배송유형', 'Y'),
('007', '판매상태', 'Y')
ON DUPLICATE KEY UPDATE GROUP_CODE_NAME = VALUES(GROUP_CODE_NAME), USE_YN = VALUES(USE_YN);

-- ========================================
-- 코드 등록 - 001 (상품유형)
-- ========================================
INSERT INTO TB_CODE (GROUP_CODE, CODE, CODE_NAME, SORT_ORDER, USE_YN) VALUES
('001', '001001', '저장유형', 1, 'Y'),
('001', '001002', '분리유형', 2, 'Y'),
('001', '001003', '처리유형', 3, 'Y'),
('001', '001004', '단위구분유형', 4, 'Y')
ON DUPLICATE KEY UPDATE CODE_NAME = VALUES(CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 코드 등록 - 002 (거래고객)
-- ========================================
INSERT INTO TB_CODE (GROUP_CODE, CODE, CODE_NAME, SORT_ORDER, USE_YN) VALUES
('002', '002001', '문의', 1, 'Y'),
('002', '002002', 'QNA', 2, 'Y'),
('002', '002003', '상품', 3, 'Y'),
('002', '002004', '완가공품', 4, 'Y'),
('002', '002005', '가공방법', 5, 'Y'),
('002', '002005', '소고기', 5, 'Y'),
('002', '002006', '돼지고기', 6, 'Y'),
('002', '002007', '기타', 7, 'Y')
ON DUPLICATE KEY UPDATE CODE_NAME = VALUES(CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 상세코드 등록 - 001001 (저장유형)
-- ========================================
INSERT INTO TB_DETAIL_CODE (GROUP_CODE, CODE, DETAIL_CODE, DETAIL_CODE_NAME, SORT_ORDER, USE_YN) VALUES
('001', '001001', '001001001', '냉장', 1, 'Y'),
('001', '001001', '001001002', '냉동', 2, 'Y')
ON DUPLICATE KEY UPDATE DETAIL_CODE_NAME = VALUES(DETAIL_CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 상세코드 등록 - 001002 (분리유형)
-- ========================================
INSERT INTO TB_DETAIL_CODE (GROUP_CODE, CODE, DETAIL_CODE, DETAIL_CODE_NAME, SORT_ORDER, USE_YN) VALUES
('001', '001002', '001002001', '볼살+혀밑살', 1, 'Y'),
('001', '001002', '001002002', '두항정', 2, 'Y'),
('001', '001002', '001002003', '덜미', 3, 'Y'),
('001', '001002', '001002004', '내장모듬', 4, 'Y'),
('001', '001002', '001002005', '새끼보', 5, 'Y'),
('001', '001002', '001002006', '국밥키트', 6, 'Y'),
('001', '001002', '001002007', '순대', 7, 'Y'),
('001', '001002', '001002008', '허파', 8, 'Y'),
('001', '001002', '001002009', '간', 9, 'Y'),
('001', '001002', '001002010', '오소리감투', 10, 'Y'),
('001', '001002', '001002011', '염통', 11, 'Y'),
('001', '001002', '001002012', '볼살', 12, 'Y'),
('001', '001002', '001002013', '대창', 13, 'Y'),
('001', '001002', '001002014', '뒷고기', 14, 'Y'),
('001', '001002', '001002015', '머리', 15, 'Y'),
('001', '001002', '001002016', '막창', 16, 'Y')
ON DUPLICATE KEY UPDATE DETAIL_CODE_NAME = VALUES(DETAIL_CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 상세코드 등록 - 001003 (처리유형)
-- ========================================
INSERT INTO TB_DETAIL_CODE (GROUP_CODE, CODE, DETAIL_CODE, DETAIL_CODE_NAME, SORT_ORDER, USE_YN) VALUES
('001', '001003', '001003001', '완가공품', 1, 'Y'),
('001', '001003', '001003002', '양념', 2, 'Y'),
('001', '001003', '001003003', '가열세절', 3, 'Y'),
('001', '001003', '001003004', '가열', 4, 'Y'),
('001', '001003', '001003005', '정형', 5, 'Y'),
('001', '001003', '001003006', '세척손질', 6, 'Y')
ON DUPLICATE KEY UPDATE DETAIL_CODE_NAME = VALUES(DETAIL_CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 상세코드 등록 - 001004 (단위구분유형)
-- ========================================
INSERT INTO TB_DETAIL_CODE (GROUP_CODE, CODE, DETAIL_CODE, DETAIL_CODE_NAME, SORT_ORDER, USE_YN) VALUES
('001', '001004', '001004001', 'EA', 1, 'Y'),
('001', '001004', '001004002', 'G', 2, 'Y'),
('001', '001004', '001004003', 'KG', 3, 'Y')
ON DUPLICATE KEY UPDATE DETAIL_CODE_NAME = VALUES(DETAIL_CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 상세코드 등록 - 002001 (운의)
-- ========================================
INSERT INTO TB_DETAIL_CODE (GROUP_CODE, CODE, DETAIL_CODE, DETAIL_CODE_NAME, SORT_ORDER, USE_YN) VALUES
('002', '002001', '002001001', '주문', 1, 'Y'),
('002', '002001', '002001002', '배송', 2, 'Y'),
('002', '002001', '002001003', '환불', 3, 'Y'),
('002', '002001', '002001004', '상품', 4, 'Y')
ON DUPLICATE KEY UPDATE DETAIL_CODE_NAME = VALUES(DETAIL_CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 상세코드 등록 - 002002 (QNA)
-- ========================================
INSERT INTO TB_DETAIL_CODE (GROUP_CODE, CODE, DETAIL_CODE, DETAIL_CODE_NAME, SORT_ORDER, USE_YN) VALUES
('002', '002002', '002002001', '주문', 1, 'Y'),
('002', '002002', '002002002', '배송', 2, 'Y'),
('002', '002002', '002002003', '환불', 3, 'Y'),
('002', '002002', '002002004', '상품', 4, 'Y'),
('002', '002002', '002002005', '기타', 5, 'Y')
ON DUPLICATE KEY UPDATE DETAIL_CODE_NAME = VALUES(DETAIL_CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 상세코드 등록 - 002003 (상품)
-- ========================================
INSERT INTO TB_DETAIL_CODE (GROUP_CODE, CODE, DETAIL_CODE, DETAIL_CODE_NAME, SORT_ORDER, USE_YN) VALUES
('002', '002003', '002003001', '가공방법', 1, 'Y'),
('002', '002003', '002003002', '돼지고기', 2, 'Y'),
('002', '002003', '002003003', '소고기', 3, 'Y'),
('002', '002003', '002003004', '완가공품', 4, 'Y')
ON DUPLICATE KEY UPDATE DETAIL_CODE_NAME = VALUES(DETAIL_CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 상세코드 등록 - 002004 (완가공품)
-- ========================================
INSERT INTO TB_DETAIL_CODE (GROUP_CODE, CODE, DETAIL_CODE, DETAIL_CODE_NAME, SORT_ORDER, USE_YN) VALUES
('002', '002004', '002004001', '순대류', 1, 'Y'),
('002', '002004', '002004002', '즉석조리식품', 2, 'Y'),
('002', '002004', '002004003', '진열상품', 3, 'Y')
ON DUPLICATE KEY UPDATE DETAIL_CODE_NAME = VALUES(DETAIL_CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 상세코드 등록 - 002005 (가공방법)
-- ========================================
INSERT INTO TB_DETAIL_CODE (GROUP_CODE, CODE, DETAIL_CODE, DETAIL_CODE_NAME, SORT_ORDER, USE_YN) VALUES
('002', '002005', '002005001', '양념', 1, 'Y'),
('002', '002005', '002005002', '가열세절', 2, 'Y'),
('002', '002005', '002005003', '가열', 3, 'Y'),
('002', '002005', '002005004', '정형', 4, 'Y'),
('002', '002005', '002005005', '세척손질', 5, 'Y')
ON DUPLICATE KEY UPDATE DETAIL_CODE_NAME = VALUES(DETAIL_CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 상세코드 등록 - 002005 (소고기) - 동일 코드 002005 재사용
-- ========================================
INSERT INTO TB_DETAIL_CODE (GROUP_CODE, CODE, DETAIL_CODE, DETAIL_CODE_NAME, SORT_ORDER, USE_YN) VALUES
('002', '002005', '002005001', '소정육', 1, 'Y'),
('002', '002005', '002005002', '소내장', 2, 'Y'),
('002', '002005', '002005003', '소머리', 3, 'Y')
ON DUPLICATE KEY UPDATE DETAIL_CODE_NAME = VALUES(DETAIL_CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 상세코드 등록 - 002006 (대지고기)
-- ========================================
INSERT INTO TB_DETAIL_CODE (GROUP_CODE, CODE, DETAIL_CODE, DETAIL_CODE_NAME, SORT_ORDER, USE_YN) VALUES
('002', '002006', '002006001', '돼지정육', 1, 'Y'),
('002', '002006', '002006002', '돼지내장', 2, 'Y'),
('002', '002006', '002006003', '돼지머리', 3, 'Y')
ON DUPLICATE KEY UPDATE DETAIL_CODE_NAME = VALUES(DETAIL_CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 상세코드 등록 - 002007 (기타)
-- ========================================
INSERT INTO TB_DETAIL_CODE (GROUP_CODE, CODE, DETAIL_CODE, DETAIL_CODE_NAME, SORT_ORDER, USE_YN) VALUES
('002', '002007', '002007001', '삶은', 1, 'Y'),
('002', '002007', '002007002', '오일', 2, 'Y'),
('002', '002007', '002007003', '기타', 3, 'Y'),
('002', '002007', '002007004', '특수부위', 4, 'Y'),
('002', '002007', '002007005', '스고기', 5, 'Y'),
('002', '002007', '002007006', '귀', 6, 'Y'),
('002', '002007', '002007007', '볼', 7, 'Y'),
('002', '002007', '002007008', '혀', 8, 'Y'),
('002', '002007', '002007009', '순대', 9, 'Y'),
('002', '002007', '002007010', '돼지고기', 10, 'Y'),
('002', '002007', '002007011', '국밥', 11, 'Y'),
('002', '002007', '002007012', '구이올', 12, 'Y'),
('002', '002007', '002007013', '분식용', 13, 'Y'),
('002', '002007', '002007014', '고추장', 14, 'Y'),
('002', '002007', '002007015', '간장', 15, 'Y')
ON DUPLICATE KEY UPDATE DETAIL_CODE_NAME = VALUES(DETAIL_CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 코드 등록 - 003 (회원타입)
-- ========================================
INSERT INTO TB_CODE (GROUP_CODE, CODE, CODE_NAME, SORT_ORDER, USE_YN) VALUES
('003', '003001', '회원타입', 1, 'Y')
ON DUPLICATE KEY UPDATE CODE_NAME = VALUES(CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 상세코드 등록 - 003001 (회원타입)
-- ========================================

INSERT INTO TB_DETAIL_CODE (GROUP_CODE, CODE, DETAIL_CODE, DETAIL_CODE_NAME, SORT_ORDER, USE_YN) VALUES
('003', '003001', '003001001', '관리자', 1, 'Y'),
('003', '003001', '003001002', '택배 관리자', 2, 'Y'),
('003', '003001', '003001003', '화물직송 관리자', 3, 'Y'),
('003', '003001', '003001004', '공장수령 관리자', 4, 'Y'),
('003', '003001', '003001005', '가공 판매자', 5, 'Y'),
('003', '003001', '003001006', '원물 판매자', 6, 'Y'),
('003', '003001', '003001007', '구매자', 7, 'Y')
ON DUPLICATE KEY UPDATE DETAIL_CODE_NAME = VALUES(DETAIL_CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 코드 등록 - 004 (가입상태)
-- ========================================
INSERT INTO TB_CODE (GROUP_CODE, CODE, CODE_NAME, SORT_ORDER, USE_YN) VALUES
('004', '004001', '가입상태', 1, 'Y')
ON DUPLICATE KEY UPDATE CODE_NAME = VALUES(CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 상세코드 등록 - 004001 (회원타입)
-- ========================================
INSERT INTO TB_DETAIL_CODE (GROUP_CODE, CODE, DETAIL_CODE, DETAIL_CODE_NAME, SORT_ORDER, USE_YN) VALUES
('004', '004001', '004001001', '승인대기', 1, 'Y'),
('004', '004001', '004001002', '가입완료', 2, 'Y'),
('004', '004001', '004001003', '휴먼', 3, 'Y'),
('004', '004001', '004001004', '회원탈퇴', 4, 'Y')
ON DUPLICATE KEY UPDATE DETAIL_CODE_NAME = VALUES(DETAIL_CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 코드 등록 - 005 (회원등급)
-- ========================================
INSERT INTO TB_CODE (GROUP_CODE, CODE, CODE_NAME, SORT_ORDER, USE_YN) VALUES
('005', '005001', '회원등급', 1, 'Y')
ON DUPLICATE KEY UPDATE CODE_NAME = VALUES(CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 상세코드 등록 - 005001 (회원등급)
-- ========================================
INSERT INTO TB_DETAIL_CODE (GROUP_CODE, CODE, DETAIL_CODE, DETAIL_CODE_NAME, SORT_ORDER, USE_YN) VALUES
('005', '005001', '005001001', '일반', 1, 'Y'),
('005', '005001', '005001002', '실버', 2, 'Y'),
('005', '005001', '005001003', '골드', 3, 'Y'),
('005', '005001', '005001004', '다이아몬드', 4, 'Y'),
('005', '005001', '005001005', 'VVIP', 5, 'Y')
ON DUPLICATE KEY UPDATE DETAIL_CODE_NAME = VALUES(DETAIL_CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 코드 등록 - 006 (배송유형)
-- ========================================
INSERT INTO TB_CODE (GROUP_CODE, CODE, CODE_NAME, SORT_ORDER, USE_YN) VALUES
('006', '006001', '배송유형', 1, 'Y')
ON DUPLICATE KEY UPDATE CODE_NAME = VALUES(CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 상세코드 등록 - 006001 (배송유형)
-- ========================================
INSERT INTO TB_DETAIL_CODE (GROUP_CODE, CODE, DETAIL_CODE, DETAIL_CODE_NAME, SORT_ORDER, USE_YN) VALUES
('006', '006001', '006001001', '전국택배', 1, 'Y'),
('006', '006001', '006001002', '직배송', 2, 'Y'),
('006', '006001', '006001003', '공장수령', 3, 'Y')
ON DUPLICATE KEY UPDATE DETAIL_CODE_NAME = VALUES(DETAIL_CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 코드 등록 - 007 (판매상태)
-- ========================================
INSERT INTO TB_CODE (GROUP_CODE, CODE, CODE_NAME, SORT_ORDER, USE_YN) VALUES
('007', '007001', '판매상태', 1, 'Y')
ON DUPLICATE KEY UPDATE CODE_NAME = VALUES(CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 상세코드 등록 - 007001 (판매상태)
-- ========================================
INSERT INTO TB_DETAIL_CODE (GROUP_CODE, CODE, DETAIL_CODE, DETAIL_CODE_NAME, SORT_ORDER, USE_YN) VALUES
('007', '007001', '007001001', '판매중', 1, 'Y'),
('007', '007001', '007001002', '판매중지', 2, 'Y'),
('007', '007001', '007001003', '판매종료', 3, 'Y'),
('007', '007001', '007001004', '품절', 3, 'Y')
ON DUPLICATE KEY UPDATE DETAIL_CODE_NAME = VALUES(DETAIL_CODE_NAME), SORT_ORDER = VALUES(SORT_ORDER), USE_YN = VALUES(USE_YN);

-- ========================================
-- 데이터 확인
-- ========================================
SELECT '그룹코드' as 구분, COUNT(*) as 개수 FROM TB_GROUP_CODE
UNION ALL
SELECT '코드', COUNT(*) FROM TB_CODE
UNION ALL
SELECT '상세코드', COUNT(*) FROM TB_DETAIL_CODE;

-- 계층 구조 확인
SELECT 
    g.GROUP_CODE,
    g.GROUP_CODE_NAME,
    c.CODE,
    c.CODE_NAME,
    COUNT(d.DETAIL_CODE) as 상세코드수
FROM TB_GROUP_CODE g
LEFT JOIN TB_CODE c ON g.GROUP_CODE = c.GROUP_CODE
LEFT JOIN TB_DETAIL_CODE d ON c.GROUP_CODE = d.GROUP_CODE AND c.CODE = d.CODE
GROUP BY g.GROUP_CODE, g.GROUP_CODE_NAME, c.CODE, c.CODE_NAME
ORDER BY g.GROUP_CODE, c.CODE;
