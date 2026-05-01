-- 26.04.28 회원 구조 변경 반영 (matpam_new)

-- 1. 회원 공통 마스터
select * from `member_master`;
drop table `member_master`;
CREATE TABLE `tb_member_master` (
  `member_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '회원ID',
  `member_type_cd` varchar(30) NOT NULL COMMENT '회원타입(BUYER, SELLER, ADMIN)',
  `channel_cd` varchar(30) NOT NULL COMMENT '배송채널(PARCEL, FREIGHT, PICKUP)',
  `login_id` varchar(50) NOT NULL COMMENT '로그인ID',
  `login_pwd` varchar(200) NOT NULL COMMENT '비밀번호해시',
  `company_name` varchar(200) DEFAULT NULL COMMENT '업체명',
  `ceo_name` varchar(100) DEFAULT NULL COMMENT '대표명',
  `biz_reg_no` varchar(20) DEFAULT NULL COMMENT '사업자등록번호',
  `company_tel_no` varchar(20) DEFAULT NULL COMMENT '회사전화번호',
  `ceo_mobile_no` varchar(20) DEFAULT NULL COMMENT '대표자 휴대폰번호',
  `email` varchar(200) DEFAULT NULL COMMENT '이메일주소',
  `zip_code` varchar(10) DEFAULT NULL COMMENT '우편번호',
  `addr1` varchar(200) DEFAULT NULL COMMENT '기본주소',
  `addr2` varchar(200) DEFAULT NULL COMMENT '상세주소',
  `last_login_dt` datetime DEFAULT NULL COMMENT '최근접속일시',
  `join_status_cd` varchar(30) DEFAULT NULL COMMENT '가입상태코드',
  `join_dt` datetime DEFAULT current_timestamp() COMMENT '가입일시',
  `withdraw_dt` datetime DEFAULT NULL COMMENT '탈퇴일시',
  `use_yn` char(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  `del_yn` char(1) NOT NULL DEFAULT 'N' COMMENT '삭제여부',
  `reg_id` varchar(20) DEFAULT NULL COMMENT '등록자ID',
  `reg_dt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '등록일시',
  `mod_id` varchar(20) DEFAULT NULL COMMENT '수정자ID',
  `mod_dt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '수정일시',
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `UQ_MEMBER_LOGIN_ID` (`login_id`),
  UNIQUE KEY `UQ_MEMBER_BIZ_REG_NO` (`biz_reg_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='회원 마스터';

-- 2. 구매자 프로필
select * from `buyer_profile`;
drop table `buyer_profile`;
CREATE TABLE `tb_buyer_profile` (
  `member_id` bigint(20) NOT NULL COMMENT '회원ID',
  `member_grade_cd` varchar(30) DEFAULT NULL COMMENT '구매자 등급',
  `credit_balance_amt` decimal(18,2) NOT NULL DEFAULT 0.00 COMMENT '현재 여신잔액',
  `meatmoney_balance_amt` decimal(18,2) NOT NULL DEFAULT 0.00 COMMENT '미트머니 잔액',
  `total_available_amt` decimal(18,2) NOT NULL DEFAULT 0.00 COMMENT '구매 가능 금액',
  `month_order_amt` decimal(18,2) DEFAULT 0.00 COMMENT '월 누적 주문금액',
  `year_order_amt` decimal(18,2) DEFAULT 0.00 COMMENT '연 누적 주문금액',
  `total_order_amt` decimal(18,2) DEFAULT 0.00 COMMENT '총 누적 주문금액',
  `use_yn` char(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  `reg_dt` datetime DEFAULT current_timestamp(),
  `mod_dt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`member_id`),
  CONSTRAINT `FK_TB_BUYER_PROFILE_MEMBER` FOREIGN KEY (`member_id`) REFERENCES `tb_member_master` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='구매자 프로필';

-- 3. 판매자 프로필
select * from `seller_profile`;
drop table `seller_profile`;
CREATE TABLE `tb_seller_profile` (
  `member_id` bigint(20) NOT NULL COMMENT '회원ID',
  `seller_type_cd` varchar(30) DEFAULT NULL COMMENT '판매자타입(RAW, PROC)',
  `tax_type_cd` varchar(30) DEFAULT NULL COMMENT '과세유형',
  `use_yn` char(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  `reg_dt` datetime DEFAULT current_timestamp(),
  `mod_dt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`member_id`),
  CONSTRAINT `FK_TB_SELLER_PROFILE_MEMBER` FOREIGN KEY (`member_id`) REFERENCES `tb_member_master` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='판매자 프로필';

-- 4. 판매자 정산 계좌
select * from `seller_settlement_account`;
drop table `seller_settlement_account`;
CREATE TABLE `tb_seller_settlement_account` (
  `settlement_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '정산ID',
  `member_id` bigint(20) NOT NULL COMMENT '회원ID',
  `bank_cd` varchar(30) DEFAULT NULL COMMENT '은행코드',
  `account_no` varchar(100) DEFAULT NULL COMMENT '계좌번호',
  `account_name` varchar(100) DEFAULT NULL COMMENT '계좌명',
  `use_yn` char(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  `reg_dt` datetime DEFAULT current_timestamp(),
  `mod_dt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`settlement_id`),
  CONSTRAINT `FK_TB_SELLER_SETTLE_MEMBER` FOREIGN KEY (`member_id`) REFERENCES `tb_member_master` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='판매자 정산 계좌';

-- 5. 관리자 프로필
select * from `admin_profile`;
drop table `admin_profile`;
CREATE TABLE `tb_admin_profile` (
  `member_id` bigint(20) NOT NULL,
  `admin_role_cd` varchar(30) DEFAULT NULL COMMENT '관리자역할',
  `use_yn` char(1) NOT NULL DEFAULT 'Y',
  `reg_dt` datetime DEFAULT current_timestamp(),
  `mod_dt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`member_id`),
  CONSTRAINT `FK_TB_ADMIN_PROFILE_MEMBER` FOREIGN KEY (`member_id`) REFERENCES `tb_member_master` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='관리자 프로필';

-- 6. 담당자 정보
select * from `tb_member_contact`;
drop table `tb_member_contact`;
CREATE TABLE `tb_member_contact` (
  `CONTACT_ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '담당자ID',
  `MEMBER_ID` bigint(20) NOT NULL COMMENT '회원ID',
  `NAME` varchar(100) NOT NULL COMMENT '담당자명',
  `MOBILE_NO` varchar(30) DEFAULT NULL COMMENT '담당자 휴대폰번호',
  `PHONE_NO` varchar(30) DEFAULT NULL COMMENT '담당자 유선전화번호',
  `EMAIL` varchar(100) DEFAULT NULL COMMENT '담당자 이메일',
  `CONTACT_TYPE_CD` varchar(20) NOT NULL COMMENT '담당자유형',
  `USE_YN` char(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  `REG_DT` datetime NOT NULL DEFAULT current_timestamp(),
  `MOD_DT` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`CONTACT_ID`),
  CONSTRAINT `FK_TB_MEMBER_CONTACT_MASTER` FOREIGN KEY (`MEMBER_ID`) REFERENCES `tb_member_master` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='회원 담당자 정보';

-- 7. 거래 내역 (미트머니)
select * from `tb_meatmoney_txn`;
drop table `tb_meatmoney_txn`;
CREATE TABLE `tb_meatmoney_txn` (
  `txn_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '거래ID',
  `member_id` bigint(20) NOT NULL COMMENT '회원ID',
  `txn_dt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '거래일시',
  `txn_type_cd` varchar(30) NOT NULL COMMENT '거래유형코드',
  `io_type_cd` char(1) NOT NULL COMMENT '입출금구분(I/O)',
  `summary` varchar(200) NOT NULL COMMENT '내역 요약',
  `use_amt` decimal(18,2) NOT NULL DEFAULT 0.00 COMMENT '사용 금액',
  `earn_amt` decimal(18,2) NOT NULL DEFAULT 0.00 COMMENT '적립 금액',
  `balance_amt` decimal(18,2) NOT NULL DEFAULT 0.00 COMMENT '거래 후 잔액',
  `use_yn` char(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  `reg_dt` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`txn_id`),
  CONSTRAINT `FK_TB_MEATMONEY_TXN_MEMBER` FOREIGN KEY (`member_id`) REFERENCES `tb_member_master` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='미트머니 거래 내역';

-- 8. 미트머니 충전 요청(입금 확인/내역)
select * from `tb_meatmoney_deposit_req`;
drop table `tb_meatmoney_deposit_req`;
CREATE TABLE `tb_meatmoney_deposit_req` (
  `deposit_req_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '충전요청ID',
  `member_id` bigint(20) NOT NULL COMMENT '회원ID',
  `req_dt` datetime NOT NULL COMMENT '요청일시',
  `amount` decimal(18,2) NOT NULL COMMENT '요청 금액',
  `status_cd` varchar(30) NOT NULL COMMENT '상태코드(PENDING/APPROVED/CANCELED)',
  `approve_dt` datetime DEFAULT NULL COMMENT '승인일시',
  `approve_admin_id` bigint(20) DEFAULT NULL COMMENT '승인관리자ID(t-b-admin 등)',
  `cancel_dt` datetime DEFAULT NULL COMMENT '취소일시',
  `cancel_admin_id` bigint(20) DEFAULT NULL COMMENT '취소관리자ID',
  `cancel_reason` varchar(500) DEFAULT NULL COMMENT '취소사유',
  `note` varchar(500) DEFAULT NULL COMMENT '비고(입금 계좌, 입금자명 등 필요시)',
  `use_yn` char(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  `del_yn` char(1) NOT NULL DEFAULT 'N' COMMENT '삭제여부',
  `reg_id` varchar(20) NOT NULL COMMENT '등록자ID',
  `reg_dt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '등록일시',
  `mod_id` varchar(20) DEFAULT NULL COMMENT '수정자ID',
  `mod_dt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '수정일시',
  PRIMARY KEY (`deposit_req_id`),
  KEY `IX_MEATMONEY_DEPOSIT_MEMBER` (`member_id`,`req_dt`),
  KEY `IX_MEATMONEY_DEPOSIT_STATUS` (`status_cd`),
  CONSTRAINT `FK_TB_MEATMONEY_DEPOSIT_REQ_MEMBER` FOREIGN KEY (`member_id`) REFERENCES `tb_member_master` (`MEMBER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='미트머니 충전 요청(입금 확인/내역)';

-- 9. 여신 테이블
select * from `tb_credit_account`;
drop table `tb_credit_account`;
CREATE TABLE `tb_credit_account` (
  `credit_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '여신계정ID',
  `member_id` bigint(20) NOT NULL COMMENT '회원ID',
  `contract_dt` date NOT NULL COMMENT '여신 약정일',
  `credit_balance_amt` decimal(18,2) NOT NULL DEFAULT 0.00 COMMENT '현재 여신잔액',
  `status_cd` varchar(30) NOT NULL DEFAULT 'ACTIVE' COMMENT '상태코드',
  `expire_dt` date DEFAULT NULL COMMENT '만료일',
  `use_yn` char(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  `del_yn` char(1) NOT NULL DEFAULT 'N' COMMENT '삭제여부',
  `reg_id` varchar(20) NOT NULL COMMENT '등록자ID',
  `reg_dt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '등록일시',
  `mod_id` varchar(20) DEFAULT NULL COMMENT '수정자ID',
  `mod_dt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '수정일시',
  PRIMARY KEY (`credit_id`),
  KEY `IX_CREDIT_ACCOUNT_MEMBER` (`member_id`),
  KEY `IX_CREDIT_ACCOUNT_STATUS` (`status_cd`),
  CONSTRAINT `FK_TB_CREDIT_ACCOUNT_MEMBER` FOREIGN KEY (`member_id`) REFERENCES `tb_member_master` (`MEMBER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='여신 계정';

-- 10. 여신 히스토리
select * from `tb_credit_history`;
drop table `tb_credit_history`;
CREATE TABLE `tb_credit_history` (
  `credit_hist_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '여신이력ID',
  `credit_id` bigint(20) NOT NULL COMMENT '여신계정ID',
  `member_id` bigint(20) NOT NULL COMMENT '회원ID',
  `hist_dt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '이력일시',
  `hist_type_cd` varchar(30) NOT NULL COMMENT '이력유형',
  `amount` decimal(18,2) NOT NULL COMMENT '변경금액',
  `before_balance_amt` decimal(18,2) NOT NULL COMMENT '변경 전 여신잔액',
  `after_balance_amt` decimal(18,2) NOT NULL COMMENT '변경 후 여신잔액',
  `description` varchar(100) DEFAULT NULL COMMENT '처리내용',
  `admin_id` varchar(20) DEFAULT NULL COMMENT '처리관리자ID',
  `reason` varchar(500) DEFAULT NULL COMMENT '처리사유',
  `use_yn` char(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  `del_yn` char(1) NOT NULL DEFAULT 'N' COMMENT '삭제여부',
  `reg_id` varchar(20) NOT NULL COMMENT '등록자ID',
  `reg_dt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '등록일시',
  `mod_id` varchar(20) DEFAULT NULL COMMENT '수정자ID',
  `mod_dt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '수정일시',
  PRIMARY KEY (`credit_hist_id`),
  KEY `IX_CREDIT_HISTORY_MEMBER_DT` (`member_id`,`hist_dt`),
  KEY `IX_CREDIT_HISTORY_ACCOUNT_DT` (`credit_id`,`hist_dt`),
  CONSTRAINT `FK_TB_CREDIT_HISTORY_ACCOUNT` FOREIGN KEY (`credit_id`) REFERENCES `tb_credit_account` (`credit_id`),
  CONSTRAINT `FK_TB_CREDIT_HISTORY_MEMBER` FOREIGN KEY (`member_id`) REFERENCES `tb_member_master` (`MEMBER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='여신 부여/증액/감소 내역';

-- 11. tb_meatmoney_account 는 삭제
drop table tb_meatmoney_account ;
drop table tb_member ;

-- 12. 회원 약관 동의
select * from `tb_member_agree`;
drop table `tb_member_agree`;
CREATE TABLE `tb_member_agree` (
  `agree_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '동의ID',
  `member_id` bigint(20) NOT NULL COMMENT '회원ID',
  `agree_type_cd` varchar(30) NOT NULL COMMENT '동의유형코드(공통코드: AGREE_TYPE)',
  `agree_yn` char(1) NOT NULL DEFAULT 'Y' COMMENT '동의여부(Y/N)',
  `agree_dt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '동의일시',
  `expire_dt` datetime DEFAULT NULL COMMENT '만료/철회일시',
  `use_yn` char(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  `del_yn` char(1) NOT NULL DEFAULT 'N' COMMENT '삭제여부',
  `reg_id` varchar(20) NOT NULL COMMENT '등록자ID',
  `reg_dt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '등록일시',
  `mod_id` varchar(20) DEFAULT NULL COMMENT '수정자ID',
  `mod_dt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '수정일시',
  PRIMARY KEY (`agree_id`),
  KEY `IX_TB_MEMBER_AGREE_MEMBER_TYPE` (`member_id`,`agree_type_cd`,`agree_yn`),
  CONSTRAINT `FK_TB_MEMBER_AGREE_MEMBER` FOREIGN KEY (`member_id`) REFERENCES `tb_member_master` (`MEMBER_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='회원 약관/동의 정보';

-- 13. 회원 상태 히스토리
select * from `tb_member_status_hist`;
drop table `tb_member_status_hist`;
CREATE TABLE `tb_member_status_hist` (
  `status_hist_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '회원상태이력ID',
  `member_id` bigint(20) NOT NULL COMMENT '회원ID',
  `prev_status_cd` varchar(30) DEFAULT NULL COMMENT '이전 상태코드(JOIN_STATUS)',
  `status_cd` varchar(30) NOT NULL COMMENT '변경 상태코드(JOIN_STATUS)',
  `change_reason_cd` varchar(30) DEFAULT NULL COMMENT '변경사유코드(공통코드: MEMBER_STATUS_REASON 등)',
  `change_reason_desc` varchar(1000) DEFAULT NULL COMMENT '변경사유 상세(자유기술)',
  `change_type_cd` varchar(30) DEFAULT NULL COMMENT '변경유형코드(JOIN, UPDATE, WITHDRAW 등 선택사항)',
  `change_admin_id` varchar(20) DEFAULT NULL COMMENT '처리관리자ID',
  `change_dt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '상태변경일시',
  `use_yn` char(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  `del_yn` char(1) NOT NULL DEFAULT 'N' COMMENT '삭제여부',
  `reg_id` varchar(20) NOT NULL COMMENT '등록자ID',
  `reg_dt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '등록일시',
  `mod_id` varchar(20) DEFAULT NULL COMMENT '수정자ID',
  `mod_dt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '수정일시',
  PRIMARY KEY (`status_hist_id`),
  KEY `IX_TB_MEMBER_STATUS_MEMBER` (`member_id`,`status_cd`,`change_dt`),
  CONSTRAINT `FK_TB_MEMBER_STATUS_MEMBER` FOREIGN KEY (`member_id`) REFERENCES `tb_member_master` (`MEMBER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='회원 상태/탈퇴 이력';

-- 14. 그룹 코드
select * from `tb_group_code`;
drop table `tb_group_code`;
CREATE TABLE `tb_group_code` (
  `CODE_GROUP_ID` varchar(30) NOT NULL COMMENT '코드그룹ID',
  `CODE_GROUP_NAME` varchar(100) NOT NULL COMMENT '코드그룹명',
  `USE_YN` char(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  `REG_ID` varchar(20) NOT NULL COMMENT '등록자ID',
  `MOD_ID` varchar(20) DEFAULT NULL COMMENT '수정자ID',
  `REG_DATE` datetime NOT NULL DEFAULT current_timestamp() COMMENT '등록일시',
  `MOD_DATE` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '수정일시',
  `DEL_YN` char(1) NOT NULL DEFAULT 'N' COMMENT '삭제여부',
  PRIMARY KEY (`CODE_GROUP_ID`),
  UNIQUE KEY `UQ_TB_GROUP_CODE_NAME` (`CODE_GROUP_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='공통 코드그룹';

-- 15. 코드
select * from `tb_code`;
drop table `tb_code`;
CREATE TABLE `tb_code` (
  `CODE_GROUP_ID` varchar(30) NOT NULL COMMENT '코드그룹ID',
  `CODE_ID` varchar(30) NOT NULL COMMENT '코드ID',
  `CODE_NAME` varchar(100) NOT NULL COMMENT '코드명',
  `SORT_ORDER` int(11) NOT NULL DEFAULT 0 COMMENT '정렬순서',
  `USE_YN` char(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  `REG_ID` varchar(20) NOT NULL COMMENT '등록자ID',
  `MOD_ID` varchar(20) DEFAULT NULL COMMENT '수정자ID',
  `REG_DATE` datetime NOT NULL DEFAULT current_timestamp() COMMENT '등록일시',
  `MOD_DATE` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '수정일시',
  `DEL_YN` char(1) NOT NULL DEFAULT 'N' COMMENT '삭제여부',
  PRIMARY KEY (`CODE_GROUP_ID`,`CODE_ID`),
  KEY `IX_TB_CODE_GROUP_USE` (`CODE_GROUP_ID`,`USE_YN`,`SORT_ORDER`),
  CONSTRAINT `FK_TB_CODE_GROUP` FOREIGN KEY (`CODE_GROUP_ID`) REFERENCES `tb_group_code` (`CODE_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='공통 코드';

-- 16. 상세 코드
select * from `tb_detail_code`;
drop table `tb_detail_code`;
CREATE TABLE `tb_detail_code` (
  `CODE_GROUP_ID` varchar(30) NOT NULL COMMENT '코드그룹ID',
  `CODE_ID` varchar(30) NOT NULL COMMENT '코드ID',
  `DETAIL_CODE_ID` varchar(30) NOT NULL COMMENT '상세코드ID',
  `DETAIL_CODE_NAME` varchar(100) NOT NULL COMMENT '상세코드명',
  `SORT_ORDER` int(11) NOT NULL DEFAULT 0 COMMENT '정렬순서',
  `USE_YN` char(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  `REG_ID` varchar(20) NOT NULL COMMENT '등록자ID',
  `MOD_ID` varchar(20) DEFAULT NULL COMMENT '수정자ID',
  `REG_DATE` datetime NOT NULL DEFAULT current_timestamp() COMMENT '등록일시',
  `MOD_DATE` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '수정일시',
  `DEL_YN` char(1) NOT NULL DEFAULT 'N' COMMENT '삭제여부',
  PRIMARY KEY (`CODE_GROUP_ID`,`CODE_ID`,`DETAIL_CODE_ID`),
  KEY `IX_TB_DETAIL_CODE_GROUP_USE` (`CODE_GROUP_ID`,`CODE_ID`,`USE_YN`,`SORT_ORDER`),
  CONSTRAINT `FK_TB_DETAIL_CODE_CODE` FOREIGN KEY (`CODE_GROUP_ID`, `CODE_ID`) REFERENCES `tb_code` (`CODE_GROUP_ID`, `CODE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='공통 상세코드';


-- code data 
CODE_GROUP_ID	CODE_GROUP_NAME	CODE_ID	CODE_NAME	DETAIL_CODE_ID	DETAIL_CODE_NAME
CATEGORY	카테고리	BEEF_CATEGORY	소고기	BEEF_HEAD	소머리
CATEGORY	카테고리	BEEF_CATEGORY	소고기	BEEF_MEAT	소정육
CATEGORY	카테고리	BEEF_CATEGORY	소고기	BEEF_TRIM	정형
CATEGORY	카테고리	BEEF_CATEGORY	소고기	BEEF_TRIPES	소내장
CATEGORY	카테고리	BEEF_CATEGORY	소고기	BEEF_WASH_TRIM	세척손질
CATEGORY	카테고리	FINISHED_PRODUCT_CAT	완가공품	CAT_EXHIBITION	전열상품
CATEGORY	카테고리	FINISHED_PRODUCT_CAT	완가공품	CAT_READY_TO_COOK	즉석조리식품
CATEGORY	카테고리	FINISHED_PRODUCT_CAT	완가공품	CAT_SUNDAE	순대류
CATEGORY	카테고리	INQUIRY_TYPE	문의	DUPE	Dupe
CATEGORY	카테고리	INQUIRY_TYPE	문의	INQ_DELIVERY	배송
CATEGORY	카테고리	INQUIRY_TYPE	문의	INQ_LIVE	환불
CATEGORY	카테고리	INQUIRY_TYPE	문의	INQ_ORDER	주문
CATEGORY	카테고리	INQUIRY_TYPE	문의	INQ_PRODUCT	상품
CATEGORY	카테고리	MISC_CATEGORY	기타	MISC_BEEF	소고기
CATEGORY	카테고리	MISC_CATEGORY	기타	MISC_BOILED	삶은
CATEGORY	카테고리	MISC_CATEGORY	기타	MISC_BUNSIK	분식용
CATEGORY	카테고리	MISC_CATEGORY	기타	MISC_CHEEK	볼
CATEGORY	카테고리	MISC_CATEGORY	기타	MISC_EAR	귀
CATEGORY	카테고리	MISC_CATEGORY	기타	MISC_ETC	기타
CATEGORY	카테고리	MISC_CATEGORY	기타	MISC_GANJANG	간장
CATEGORY	카테고리	MISC_CATEGORY	기타	MISC_GOCHUJANG	고추장
CATEGORY	카테고리	MISC_CATEGORY	기타	MISC_GRILL	구이용
CATEGORY	카테고리	MISC_CATEGORY	기타	MISC_OIL	오일
CATEGORY	카테고리	MISC_CATEGORY	기타	MISC_PORK	돼지고기
CATEGORY	카테고리	MISC_CATEGORY	기타	MISC_SOUP	국밥
CATEGORY	카테고리	MISC_CATEGORY	기타	MISC_SPECIAL_PART	특수부위
CATEGORY	카테고리	MISC_CATEGORY	기타	MISC_SUNDAE	순대
CATEGORY	카테고리	MISC_CATEGORY	기타	MISC_TONGUE	혀
CATEGORY	카테고리	PORK_CATEGORY	돼지고기	PORK_HEAD	돼지머리
CATEGORY	카테고리	PORK_CATEGORY	돼지고기	PORK_MEAT	돼지정육
CATEGORY	카테고리	PORK_CATEGORY	돼지고기	PORK_TRIPES	돼지내장
CATEGORY	카테고리	PRODUCT_CATEGORY	상품	CAT_BEEF	소고기
CATEGORY	카테고리	PRODUCT_CATEGORY	상품	CAT_FINISHED	완가공품
CATEGORY	카테고리	PRODUCT_CATEGORY	상품	CAT_PORK	돼지고기
CATEGORY	카테고리	PRODUCT_CATEGORY	상품	CAT_PROCESS_METHOD	가공방법
CATEGORY	카테고리	QNA_TYPE	QNA	QNA_DELIVERY	배송
CATEGORY	카테고리	QNA_TYPE	QNA	QNA_ETC	기타
CATEGORY	카테고리	QNA_TYPE	QNA	QNA_LIVE	환불
CATEGORY	카테고리	QNA_TYPE	QNA	QNA_ORDER	주문
CATEGORY	카테고리	QNA_TYPE	QNA	QNA_PRODUCT	상품
CHANNEL_TYPE	채널유형	CHANNEL_TYPE	채널유형	ADMIN	수퍼관리자
CHANNEL_TYPE	채널유형	CHANNEL_TYPE	채널유형	COURIER_SERVICE	전국택배
CHANNEL_TYPE	채널유형	CHANNEL_TYPE	채널유형	DIRECT_DELIVERY	직배송
CHANNEL_TYPE	채널유형	CHANNEL_TYPE	채널유형	FACTORY_PICKUP	공장수령
JOIN_STATUS	가입상태	JOIN_STATUS	가입상태	JOIN_ACTIVE	가입
JOIN_STATUS	가입상태	JOIN_STATUS	가입상태	JOIN_DORMANT	휴면
JOIN_STATUS	가입상태	JOIN_STATUS	가입상태	JOIN_LEAVE	회원탈퇴
JOIN_STATUS	가입상태	JOIN_STATUS	가입상태	JOIN_WAIT	승인대기
MEMBER_GRADE	회원등급	MEMBER_GRADE	회원등급	GRADE_DIAMOND	다이아몬드
MEMBER_GRADE	회원등급	MEMBER_GRADE	회원등급	GRADE_GOLD	골드
MEMBER_GRADE	회원등급	MEMBER_GRADE	회원등급	GRADE_NORMAL	일반
MEMBER_GRADE	회원등급	MEMBER_GRADE	회원등급	GRADE_SILVER	실버
MEMBER_GRADE	회원등급	MEMBER_GRADE	회원등급	GRADE_VVIP	VVIP
MEMBER_TYPE	회원타입	ADMIN_ROLE	관리자타입	ADMIN_FREIGHT	화물관리자
MEMBER_TYPE	회원타입	ADMIN_ROLE	관리자타입	ADMIN_PARCEL	택배관리자
MEMBER_TYPE	회원타입	ADMIN_ROLE	관리자타입	ADMIN_PICKUP	직접수령관리자
MEMBER_TYPE	회원타입	MEMBER_ROLE	회원타입	ROLE_ADMIN	관리자
MEMBER_TYPE	회원타입	MEMBER_ROLE	회원타입	ROLE_BUYER	구매자
MEMBER_TYPE	회원타입	MEMBER_ROLE	회원타입	ROLE_SELLER	판매자
MEMBER_TYPE	회원타입	SELLER_ROLE	판매자타입	SELLER_PROCESS	가공판매자
MEMBER_TYPE	회원타입	SELLER_ROLE	판매자타입	SELLER_RAW	원물판매자
PRODUCT_TYPE	상품유형	CUT_TYPE	분리유형	CUT_BULSAL	불살
PRODUCT_TYPE	상품유형	CUT_TYPE	분리유형	CUT_BULSAL_HEOMIL	불살+허밑살
PRODUCT_TYPE	상품유형	CUT_TYPE	분리유형	CUT_DAECHANG	대창
PRODUCT_TYPE	상품유형	CUT_TYPE	분리유형	CUT_DUHANGJUNG	두항정
PRODUCT_TYPE	상품유형	CUT_TYPE	분리유형	CUT_DWITGOGI	뒷고기
PRODUCT_TYPE	상품유형	CUT_TYPE	분리유형	CUT_DWITMI	뒷미
PRODUCT_TYPE	상품유형	CUT_TYPE	분리유형	CUT_HEAD	머리
PRODUCT_TYPE	상품유형	CUT_TYPE	분리유형	CUT_HEART	염통
PRODUCT_TYPE	상품유형	CUT_TYPE	분리유형	CUT_HEOPA	허파
PRODUCT_TYPE	상품유형	CUT_TYPE	분리유형	CUT_INTESTINE_MIX	내장모듬
PRODUCT_TYPE	상품유형	CUT_TYPE	분리유형	CUT_LIVER	간
PRODUCT_TYPE	상품유형	CUT_TYPE	분리유형	CUT_MAKCHANG	막창
PRODUCT_TYPE	상품유형	CUT_TYPE	분리유형	CUT_OSORI	오소리감투
PRODUCT_TYPE	상품유형	CUT_TYPE	분리유형	CUT_SAEKKIBO	새끼보
PRODUCT_TYPE	상품유형	CUT_TYPE	분리유형	CUT_SOUP_KIT	국밥키트
PRODUCT_TYPE	상품유형	CUT_TYPE	분리유형	CUT_SUNDAE	순대
PRODUCT_TYPE	상품유형	PROCESS_TYPE	처리유형	PROC_COOKED	가열
PRODUCT_TYPE	상품유형	PROCESS_TYPE	처리유형	PROC_COOKED_SLICE	가열세절
PRODUCT_TYPE	상품유형	PROCESS_TYPE	처리유형	PROC_FINISHED	완가공품
PRODUCT_TYPE	상품유형	PROCESS_TYPE	처리유형	PROC_MARINATED	양념
PRODUCT_TYPE	상품유형	PROCESS_TYPE	처리유형	PROC_TRIM	정형
PRODUCT_TYPE	상품유형	PROCESS_TYPE	처리유형	PROC_WASH_TRIM	세척손질
PRODUCT_TYPE	상품유형	STORAGE_TYPE	저장유형	CHILLED	냉장
PRODUCT_TYPE	상품유형	STORAGE_TYPE	저장유형	FROZEN	냉동
PRODUCT_TYPE	상품유형	UNIT_TYPE	단위구분유형	UNIT_EA	EA
PRODUCT_TYPE	상품유형	UNIT_TYPE	단위구분유형	UNIT_G	G
PRODUCT_TYPE	상품유형	UNIT_TYPE	단위구분유형	UNIT_KG	KG
SALE_STATUS	판매상태	SALE_STATUS	판매상태	SALE_END	판매종료
SALE_STATUS	판매상태	SALE_STATUS	판매상태	SALE_ON	판매중
SALE_STATUS	판매상태	SALE_STATUS	판매상태	SALE_STOP	판매중지
SALE_STATUS	판매상태	SALE_TYPE	판매유형	SALE_PROCESS	가공
SALE_STATUS	판매상태	SALE_TYPE	판매유형	SALE_RAW	원물