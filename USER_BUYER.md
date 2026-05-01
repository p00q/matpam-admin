# USER BUYER

아니요. **앞선 설명은 구매자를 “회원 개인 계정”처럼 표현한 부분이 있어, B2B 몰 기준으로는 보완이 필요합니다.**

정확히는 이렇게 봐야 합니다.

```text
구매자 = 개인 회원이 아니라 구매업체
구매자 담당자 = 구매업체 소속 로그인 계정
```

따라서 구조는 이렇게 가야 합니다.

```text
수퍼관리자
 └─ 판매/공급 업체 등록
      └─ 업체관리자 등록
           └─ 채널관리자 등록
                └─ 구매업체 등록
                     └─ 구매업체 담당자 계정 등록
```

또는 단순화하면:

```text
채널관리자
 └─ 구매업체 등록
 └─ 구매업체 담당자 등록
```

DB도 구매자를 `tb_member_master` 하나로만 보면 부족합니다.

필요 구조는:

```sql
tb_company_master
- company_id
- company_name
- biz_reg_no
- company_type_cd  -- SUPPLIER / BUYER / BOTH
- tax_type_cd

tb_member_master
- member_id
- company_id
- member_role_cd
- channel_cd
- login_id
- login_pwd
- member_name
- mobile_no
```

구매자 전용 정보는 별도 테이블로 둡니다.

```sql
tb_buyer_company_profile
- buyer_company_id
- company_id
- managing_supplier_company_id
- managing_channel_cd
- buyer_grade_cd
- credit_use_yn
- credit_limit_amt
- meatmoney_balance_amt
- use_yn
```

즉, 기존 `tb_buyer_profile`은 이름을 바꾸거나 의미를 명확히 해야 합니다.

추천:

```text
기존 tb_buyer_profile
→ tb_buyer_company_profile 로 변경
```

화면도 이렇게 수정해야 합니다.

## 채널관리자의 구매자 등록 화면

기존:

```text
구매자명
휴대폰
이메일
```

수정:

```text
구매업체 정보
- 업체명
- 사업자등록번호
- 대표자명
- 사업장 주소
- 회사 전화번호
- 업태/종목
- 과세유형

구매업체 담당자 정보
- 담당자명
- 로그인ID
- 휴대폰번호
- 이메일
- 비밀번호 초기화

거래 정보
- 담당 공급업체
- 담당 채널
- 구매자 등급
- 여신 사용 여부
- 여신 한도
- 미트머니 사용 여부
- 배송지
```

핵심 결론은 이겁니다.

**B2B 몰에서는 “구매자 = 업체”이고, 로그인하는 사람은 “구매업체 담당자”입니다.**

그래서 회원 구조는 반드시:

```text
업체 테이블
+
업체 소속 로그인 계정 테이블
+
구매업체 거래 프로필 테이블
```

로 분리하는 게 맞습니다.
