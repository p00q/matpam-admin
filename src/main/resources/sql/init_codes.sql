-- 공통 코드 테이블 생성 (Mapper 기준)
DROP TABLE IF EXISTS `tb_detail_code`;
DROP TABLE IF EXISTS `tb_code`;
DROP TABLE IF EXISTS `tb_group_code`;

CREATE TABLE IF NOT EXISTS `tb_group_code` (
  `CODE_GROUP_ID` varchar(30) NOT NULL COMMENT '그룹코드',
  `CODE_GROUP_NAME` varchar(100) NOT NULL COMMENT '그룹코드명',
  `USE_YN` char(1) DEFAULT 'Y' COMMENT '사용여부',
  `DEL_YN` char(1) DEFAULT 'N' COMMENT '삭제여부',
  `REG_ID` varchar(20) DEFAULT 'SYSTEM',
  `REG_DATE` datetime DEFAULT current_timestamp() COMMENT '등록일시',
  `MOD_ID` varchar(20) DEFAULT 'SYSTEM',
  `MOD_DATE` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '수정일시',
  PRIMARY KEY (`CODE_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='그룹코드';

CREATE TABLE IF NOT EXISTS `tb_code` (
  `CODE_GROUP_ID` varchar(30) NOT NULL COMMENT '그룹코드',
  `CODE_ID` varchar(30) NOT NULL COMMENT '코드',
  `CODE_NAME` varchar(100) NOT NULL COMMENT '코드명',
  `SORT_ORDER` int(11) DEFAULT 0 COMMENT '정렬순서',
  `USE_YN` char(1) DEFAULT 'Y' COMMENT '사용여부',
  `DEL_YN` char(1) DEFAULT 'N' COMMENT '삭제여부',
  `REG_ID` varchar(20) DEFAULT 'SYSTEM',
  `REG_DATE` datetime DEFAULT current_timestamp() COMMENT '등록일시',
  `MOD_ID` varchar(20) DEFAULT 'SYSTEM',
  `MOD_DATE` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '수정일시',
  PRIMARY KEY (`CODE_GROUP_ID`,`CODE_ID`),
  CONSTRAINT `FK_CODE_GROUP` FOREIGN KEY (`CODE_GROUP_ID`) REFERENCES `tb_group_code` (`CODE_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='코드';

CREATE TABLE IF NOT EXISTS `tb_detail_code` (
  `CODE_GROUP_ID` varchar(30) NOT NULL COMMENT '그룹코드',
  `CODE_ID` varchar(30) NOT NULL COMMENT '코드',
  `DETAIL_CODE_ID` varchar(30) NOT NULL COMMENT '상세코드',
  `DETAIL_CODE_NAME` varchar(100) NOT NULL COMMENT '상세코드명',
  `SORT_ORDER` int(11) DEFAULT 0 COMMENT '정렬순서',
  `USE_YN` char(1) DEFAULT 'Y' COMMENT '사용여부',
  `DEL_YN` char(1) DEFAULT 'N' COMMENT '삭제여부',
  `REG_ID` varchar(20) DEFAULT 'SYSTEM',
  `REG_DATE` datetime DEFAULT current_timestamp() COMMENT '등록일시',
  `MOD_ID` varchar(20) DEFAULT 'SYSTEM',
  `MOD_DATE` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '수정일시',
  PRIMARY KEY (`CODE_GROUP_ID`,`CODE_ID`,`DETAIL_CODE_ID`),
  CONSTRAINT `FK_DETAIL_CODE` FOREIGN KEY (`CODE_GROUP_ID`, `CODE_ID`) REFERENCES `tb_code` (`CODE_GROUP_ID`, `CODE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='상세코드';

-- 기본 데이터 삽입 (회원 관리용)

-- 그룹코드
INSERT INTO `tb_group_code` (CODE_GROUP_ID, CODE_GROUP_NAME) VALUES
('003', '회원타입'),
('004', '가입상태'),
('005', '회원등급'),
('006', '배송유형'),
('007', '판매자상세유형'),
('008', '과세유형'),
('SALE_STATUS', '판매상태');

-- 코드
INSERT INTO `tb_code` (CODE_GROUP_ID, CODE_ID, CODE_NAME, SORT_ORDER) VALUES
('003', '003001', '회원유형구분', 1),
('004', '004001', '가입상태구분', 1),
('005', '005001', '회원등급구분', 1),
('006', '006001', '배송채널구분', 1),
('007', '007001', '판매자상세유형구분', 1),
('008', '008001', '과세유형구분', 1),
('SALE_STATUS', 'SALE_STATUS', '판매상태구분', 1);

-- 상세코드
INSERT INTO `tb_detail_code` (CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, DETAIL_CODE_NAME, SORT_ORDER) VALUES
-- 회원타입
('003', '003001', 'BUYER', '구매자', 1),
('003', '003001', 'SELLER', '판매자', 2),
('003', '003001', 'ADMIN', '관리자', 3),
-- 가입상태
('004', '004001', 'JOIN', '정상', 1),
('004', '004001', 'WAIT', '승인대기', 2),
('004', '004001', 'BLOCK', '차단', 3),
('004', '004001', 'WITHDRAW', '탈퇴', 4),
-- 회원등급
('005', '005001', 'BRONZE', '브론즈', 1),
('005', '005001', 'SILVER', '실버', 2),
('005', '005001', 'GOLD', '골드', 3),
('005', '005001', 'PLATINUM', '플래티넘', 4),
-- 판매자 상세유형
('007', '007001', 'RAW', '원물판매자', 1),
('007', '007001', 'PROC', '가공판매자', 2),
-- 과세유형
('008', '008001', 'TAX', '과세', 1),
('008', '008001', 'FREE', '면세', 2),
('008', '008001', 'ZERO', '영세', 3),
-- 배송유형 (채널)
('006', '006001', 'PARCEL', '전국택배', 1),
('006', '006001', 'FREIGHT', '직배송', 2),
('006', '006001', 'PICKUP', '공장수령', 3),
-- 판매상태
('SALE_STATUS', 'SALE_STATUS', 'LIVE', '판매중', 1),
('SALE_STATUS', 'SALE_STATUS', 'STOP', '판매중지', 2),
('SALE_STATUS', 'SALE_STATUS', 'SOLDOUT', '품절', 3);
