# USER MANAGER

# 기본 구상

운영 구조
플랫폼은 판매업체별로 1개씩 분양
하나의 플랫폼(테넌트)에는 판매업체 1개
그 플랫폼 안에 구매업체 여러 개
채널은 전국택배 / 화물직송 / 공장수령
판매업체 소속 사용자는
업체관리자
채널관리자
구매업체 소속 사용자는
구매업체 관리자
여기서 중요한 건,
채널은 사업자 주체가 아니라 운영 단위라는 점입니다.
세금계산서나 거래 주체는 반드시 업체 기준으로 잡아야 안전합니다. 위탁·대리 구조에서도 세금계산서 당사자는 실제 거래당사자 기준으로 식별되는 것이 핵심입니다. Source

1. 1단계에서 꼭 남겨야 하는 최소 분리
복잡한 구조는 빼도 되지만, 아래 3개는 절대 합치면 안 됩니다.

업체
법적 거래주체입니다.
사업자등록번호, 대표자명, 주소, 과세 기본값 등이 들어갑니다.

사용자
로그인 계정입니다.
누가 접속했고, 어떤 권한을 갖는지 관리합니다.

채널
전국택배/화물직송/공장수령 같은 운영 범위입니다.
채널관리자는 이 범위에서만 구매업체를 관리합니다.

이 3개를 합쳐버리면 개발은 처음엔 쉬워 보여도,
나중에 “이 주문의 공급자가 누구냐”, “채널관리자가 왜 거래 주체처럼 보이냐”, “사업자 상태 확인은 누가 책임졌냐”가 꼬입니다.

1. 1단계용 가장 가벼운 권한 모델
정말 가볍게 가려면 한 사용자 = 한 역할로 두는 게 낫습니다.

역할 정의
SELLER_ADMIN : 판매업체 관리자
CHANNEL_ADMIN : 채널관리자
BUYER_ADMIN : 구매업체 관리자
권한 규칙
SELLER_ADMIN
구매업체 등록/수정 가능
채널관리자 등록/수정 가능
여신한도 관리 가능
업체 기본정보 관리 가능
CHANNEL_ADMIN
자기 채널의 구매업체만 등록/수정 가능
자기 채널에 속한 구매업체만 조회 가능
BUYER_ADMIN
자기 업체 정보 조회/수정 가능
자기 업체 담당자 관리 가능
이 구조면 별도 권한 매트릭스 엔진 없이도 바로 개발 가능합니다.

1. 세무조사 대응 기준으로 회원정보에 꼭 필요한 것
회원정보까지만 본다면, 최소한 아래는 남겨야 합니다.

업체 기준
사업자등록번호
대표자명
사업장 주소
업체 구분: 판매업체 / 구매업체
판매업체인 경우 판매 유형: 원물 / 가공 / 완제품
기본 과세구분: 면세 / 과세
사업자 상태 확인 일시 및 결과
거래처의 사업자 상태 확인 이력은 꼭 남기는 게 좋습니다. 홈택스에서 사업자등록 상태 조회가 가능하므로, 등록 시점과 변경 시점의 확인 흔적이 있으면 좋습니다. Source

사용자 기준
로그인 ID
비밀번호 해시
이름
휴대폰/이메일
역할
소속 업체
채널관리자인 경우 담당 채널
금융/정산 기본정보
계좌정보
구매업체 여신한도
미트머니 사용 여부
변경 추적
누가 만들었는지
누가 수정했는지
언제 바꿨는지
국세기본법상 장부 및 증빙은 성실하게 작성·비치·보존해야 하므로, 최소한 주요 마스터 변경 이력은 남기는 쪽이 안전합니다. Source

1. 1단계 추천 테이블 구조
아래 구조가 가장 단순하면서도 실무적으로 안 무너지는 버전입니다.

5-1. tenants
판매업체별 분양 플랫폼

컬럼명 타입 설명 제약
tenant_id BIGINT PK 테넌트 ID PK
tenant_code VARCHAR(50) 플랫폼 코드 UNIQUE, NOT NULL
tenant_name VARCHAR(200) 플랫폼명 NOT NULL
status VARCHAR(20) ACTIVE / INACTIVE NOT NULL
created_at DATETIME 생성일시 NOT NULL
updated_at DATETIME 수정일시 NOT NULL
설명
플랫폼 분양 단위
판매업체 1개가 1개 tenant를 가짐
5-2. channels
테넌트의 운영 채널

컬럼명 타입 설명 제약
channel_id BIGINT PK 채널 ID PK
tenant_id BIGINT 테넌트 ID FK, NOT NULL
channel_code VARCHAR(30) PARCEL / FREIGHT / PICKUP NOT NULL
channel_name VARCHAR(100) 전국택배 / 화물직송 / 공장수령 NOT NULL
status VARCHAR(20) ACTIVE / INACTIVE NOT NULL
sort_order INT 정렬순서
created_at DATETIME 생성일시 NOT NULL
권장 제약
UNIQUE (tenant_id, channel_code)
5-3. companies
업체 마스터
1단계에서는 판매업체/구매업체만 구분합니다.

컬럼명 타입 설명 제약
company_id BIGINT PK 업체 ID PK
tenant_id BIGINT 테넌트 ID FK, NOT NULL
company_type VARCHAR(20) SELLER / BUYER NOT NULL
seller_type VARCHAR(20) RAW / PROCESSED / FINISHED, 구매업체면 NULL
company_name VARCHAR(200) 업체명 NOT NULL
business_no VARCHAR(20) 사업자등록번호 NOT NULL
ceo_name VARCHAR(100) 대표자명 NOT NULL
postal_code VARCHAR(10) 우편번호
address1 VARCHAR(255) 주소
address2 VARCHAR(255) 상세주소
phone VARCHAR(30) 대표전화
email VARCHAR(150) 대표 이메일
default_tax_type VARCHAR(20) TAX_FREE / TAXABLE NOT NULL
biz_status VARCHAR(20) ACTIVE / SUSPENDED / CLOSED NOT NULL
biz_checked_at DATETIME 사업자 상태 확인일시
biz_checked_result VARCHAR(100) 확인 결과
status VARCHAR(20) ACTIVE / INACTIVE NOT NULL
created_at DATETIME 생성일시 NOT NULL
updated_at DATETIME 수정일시 NOT NULL
1단계 운영 규칙
company_type = SELLER 이면 seller_type 필수
company_type = BUYER 이면 seller_type NULL
default_tax_type
RAW → 기본값 TAX_FREE
PROCESSED / FINISHED → 기본값 TAXABLE
중요한 주석
이 default_tax_type은 기본값이지 최종 세율 확정값은 아닙니다.
최종 판단은 상품/주문에서 하도록 남겨두는 게 안전합니다. Source

권장 제약
UNIQUE (tenant_id, business_no)
5-4. company_contacts
업체 담당자

컬럼명 타입 설명 제약
contact_id BIGINT PK 담당자 ID PK
company_id BIGINT 업체 ID FK, NOT NULL
contact_name VARCHAR(100) 담당자명 NOT NULL
contact_role VARCHAR(30) ADMIN / SALES / TAX / SETTLEMENT / SHIPPING / PURCHASE NOT NULL
mobile VARCHAR(30) 휴대전화
email VARCHAR(150) 이메일
is_primary CHAR(1) 대표 담당자 여부 DEFAULT 'N'
linked_user_id BIGINT 연결된 사용자 ID FK, NULL 가능
status VARCHAR(20) ACTIVE / INACTIVE NOT NULL
created_at DATETIME 생성일시 NOT NULL
updated_at DATETIME 수정일시 NOT NULL
설명
로그인 없는 담당자도 등록 가능
세금계산서 담당자, 정산 담당자, 출고 담당자 분리 가능
5-5. users
로그인 사용자

컬럼명 타입 설명 제약
user_id BIGINT PK 사용자 ID PK
tenant_id BIGINT 테넌트 ID FK, NOT NULL
company_id BIGINT 소속 업체 ID FK, NOT NULL
login_id VARCHAR(100) 로그인 ID UNIQUE, NOT NULL
password_hash VARCHAR(255) 비밀번호 해시 NOT NULL
user_name VARCHAR(100) 이름 NOT NULL
mobile VARCHAR(30) 휴대전화
email VARCHAR(150) 이메일
user_role VARCHAR(20) SELLER_ADMIN / CHANNEL_ADMIN / BUYER_ADMIN NOT NULL
channel_id BIGINT 채널관리자일 때만 채널 ID FK, NULL 가능
status VARCHAR(20) ACTIVE / LOCKED / INACTIVE NOT NULL
last_login_at DATETIME 마지막 로그인
created_at DATETIME 생성일시 NOT NULL
updated_at DATETIME 수정일시 NOT NULL
1단계 규칙
SELLER_ADMIN → channel_id NULL
CHANNEL_ADMIN → channel_id NOT NULL
BUYER_ADMIN → channel_id NULL
사용자 1명은 역할 1개만
이렇게 하면 중간 권한 테이블 없이도 바로 구현 가능합니다.

5-6. buyer_channels
구매업체 채널 소속

컬럼명 타입 설명 제약
buyer_channel_id BIGINT PK PK PK
tenant_id BIGINT 테넌트 ID FK, NOT NULL
buyer_company_id BIGINT 구매업체 ID FK, NOT NULL
channel_id BIGINT 채널 ID FK, NOT NULL
status VARCHAR(20) ACTIVE / INACTIVE NOT NULL
joined_at DATETIME 등록일시
created_by BIGINT 등록자 사용자 ID FK
created_at DATETIME 생성일시 NOT NULL
권장 제약
UNIQUE (tenant_id, buyer_company_id, channel_id)
설명
채널관리자는 자기 채널 데이터만 등록/관리
판매업체 관리자는 전체 채널 가능
5-7. company_bank_accounts
업체 계좌정보

컬럼명 타입 설명 제약
bank_account_id BIGINT PK 계좌 ID PK
company_id BIGINT 업체 ID FK, NOT NULL
bank_name VARCHAR(100) 은행명 NOT NULL
account_no_enc VARCHAR(255) 암호화 계좌번호 NOT NULL
account_holder VARCHAR(100) 예금주 NOT NULL
is_default CHAR(1) 기본계좌 여부 DEFAULT 'N'
status VARCHAR(20) ACTIVE / INACTIVE NOT NULL
created_at DATETIME 생성일시 NOT NULL
updated_at DATETIME 수정일시 NOT NULL
설명
계좌번호는 평문 저장 금지 권장
업체당 기본계좌 1개만 허용
5-8. buyer_financials
구매업체 금융 기본정보

컬럼명 타입 설명 제약
buyer_financial_id BIGINT PK PK PK
buyer_company_id BIGINT 구매업체 ID FK, NOT NULL
credit_limit_amount DECIMAL(18,2) 여신한도 NOT NULL DEFAULT 0
meat_money_enabled CHAR(1) 미트머니 사용 여부 DEFAULT 'N'
status VARCHAR(20) ACTIVE / INACTIVE NOT NULL
updated_at DATETIME 수정일시 NOT NULL
updated_by BIGINT 수정자 사용자 ID FK
설명
1단계에서는 여기까지면 충분합니다.
미트머니 잔액/입출금 내역 원장은 회원정보가 아니라 금융거래 영역이라서 나중에 별도 테이블로 빼는 게 맞습니다.

5-9. audit_logs
감사 로그

컬럼명 타입 설명 제약
audit_id BIGINT PK PK PK
tenant_id BIGINT 테넌트 ID FK, NOT NULL
entity_name VARCHAR(50) 테이블명 NOT NULL
entity_id BIGINT 대상 ID NOT NULL
action_type VARCHAR(20) INSERT / UPDATE / DELETE / LOGIN NOT NULL
before_json JSON 변경 전
after_json JSON 변경 후
actor_user_id BIGINT 작업자 FK
acted_at DATETIME 작업일시 NOT NULL
ip_address VARCHAR(50) IP
설명
가볍게 가더라도 이건 남기는 걸 추천합니다.
특히 아래 항목은 반드시 로그:

사업자번호 변경
기본 과세구분 변경
여신한도 변경
계좌정보 변경
사용자 권한 변경
장부·증빙 보존 관점에서 변경흔적은 꽤 중요한 방어선입니다. Source

1. 이 버전이 왜 1단계에 잘 맞는가
이 설계는 꽤 영리하게 가볍습니다.

첫째, 다중 역할을 버렸습니다
회사도 단순합니다: SELLER 또는 BUYER
사용자도 단순합니다: 역할 1개
그래서 개발이 빠릅니다
둘째, 그런데도 세무 핵심은 살렸습니다
업체와 사용자를 분리
채널은 운영 범위로만 처리
사업자 검증 이력 보존
기본 과세구분 보유
감사로그 확보
셋째, 2단계 확장 여지도 남아 있습니다
나중에 필요해지면:

users에서 역할을 별도 매핑 테이블로 분리
companies에서 다중 역할 매핑 테이블 추가
buyer_financials에서 미트머니 원장 분리
즉, 지금은 경량 엔진으로 출발하고, 나중에 터보를 붙일 수 있습니다.

1. 1단계에서 버려도 되는 것, 버리면 안 되는 것
지금 버려도 되는 것
업체 다중 역할 매핑
사용자 다중 권한 매핑
복잡한 권한 정책 엔진
채널별 세부 권한 테이블
세금 프로필 이력 테이블
계좌 유효기간 이력 테이블
절대 버리면 안 되는 것
사업자등록번호
업체와 사용자 분리
채널 분리
기본 과세구분
여신한도 정보
계좌정보
변경 로그
2. 1단계 운영 규칙까지 같이 박아두면 더 좋습니다
개발 전에 아래 규칙을 문서에 명시해두면, 구현이 훨씬 덜 흔들립니다.

규칙 A
한 테넌트에는 판매업체 1개만 존재

규칙 B
구매업체는 판매업체 테넌트 안에서만 생성

규칙 C
채널관리자는 오직 1개 채널만 담당

규칙 D
구매업체는 여러 채널에 속할 수 있음

이건 단순한데 유연합니다
buyer_channels 하나면 해결
규칙 E
기본 과세구분은 회사 기본값일 뿐, 최종 거래 세금판정은 상품/주문에서 확정

규칙 F
세금계산서 주체는 항상 업체

채널 아님
사용자 아님
9. 최종 추천
1단계라면 저는 이렇게 추천합니다.

“테이블 9개로 시작하되, 사용자·업체·채널만은 확실히 분리한다.”

그게 가장 가볍고, 가장 덜 위험합니다.

특히 지금 같은 구조에서는
companies + users + buyer_channels + buyer_financials + audit_logs
이 다섯 축만 제대로 잡아도 훨씬 안정적입니다.

# 보안 필요

보완 필요
수퍼관리자 역할 누락
현재 역할이 SELLER_ADMIN / CHANNEL_ADMIN / BUYER_ADMIN만 있습니다.
수퍼관리자가 플랫폼 전체를 관리하므로 SUPER_ADMIN은 추가해야 합니다.
SUPER_ADMIN
SELLER_ADMIN
CHANNEL_ADMIN
BUYER_ADMIN
테넌트와 판매업체 연결 컬럼 필요
tenants에 판매업체 1개가 붙는 구조라면 아래 컬럼이 있어야 합니다.
seller_company_id

또는 companies에서 company_type = SELLER인 업체를 테넌트 대표 판매업체로 지정해야 합니다.

추천:

tenants.seller_company_id
판매업체 담당자 역할 이름
SELLER_ADMIN은 판매업체 관리자라서 괜찮습니다.
다만 앞서 말한 SELLER_MANAGER와 용어가 충돌하지 않게 하나로 정해야 합니다.

1단계에서는 더 쉬운 명칭인 아래 추천합니다.

SUPER_ADMIN
SELLER_ADMIN
CHANNEL_ADMIN
BUYER_ADMIN
채널 코드 명칭 통일
본문에서는 PARCEL / FREIGHT / PICKUP이고, 이전 설계에서는 COURIER_SERVICE / DIRECT_DELIVERY / FACTORY_PICKUP이었습니다.

둘 중 하나로 통일해야 합니다.

간단한 1단계라면:

PARCEL      전국택배
FREIGHT     화물직송
PICKUP      공장수령

추천합니다.

최종 1단계 테이블

이렇게 정리하면 됩니다.

tb_tenant
tb_channel
tb_company
tb_company_contact
tb_user
tb_buyer_channel
tb_company_bank_account
tb_buyer_financial
tb_audit_log
최종 판단

네, 이렇게 하면 됩니다.

단, 최종 확정 시 아래 원칙만 반드시 유지하세요.

업체 = 법적 거래주체
사용자 = 로그인 계정
채널 = 운영/권한 범위
구매업체 = company_type BUYER
판매업체 = company_type SELLER
세금계산서 주체 = 업체
과세 기본값 = 회사 기본값, 최종 확정은 상품/주문

이 정도면 1단계 개발 범위로 충분히 단순하고, 나중에 확장도 가능합니다.

# 최종 적용안

최종 검토 결과: 제안 내용 적용 “적합”
주신 수정안 중 핵심 포인트는 모두 맞습니다.

1. SUPER_ADMIN 추가
이건 반드시 있어야 합니다.
지금 구조는 폐쇄형 B2B 플랫폼이고, 플랫폼을 판매업체별로 분양하므로 테넌트 전체를 생성·관리·감사할 수 있는 상위 관리자가 필요합니다.

다만 여기서 한 가지 운영 규칙을 같이 박아두면 더 좋습니다.

SUPER_ADMIN은 특정 테넌트 전용이 아니라 전체 테넌트 접근 가능
따라서 tb_user.tenant_id는 SUPER_ADMIN일 때 NULL 허용 또는 별도 공용 테넌트 개념 사용
1단계에서는 더 단순하게:

SUPER_ADMIN → tenant_id = NULL
나머지 역할 → tenant_id NOT NULL
로 가는 걸 추천합니다.

1. tb_tenant.seller_company_id 추가
이것도 맞습니다.
“이 플랫폼이 누구의 것인가?”를 시스템적으로 한 방에 보여주는 컬럼이 필요합니다.

즉:

tb_tenant는 플랫폼 인스턴스
tb_company의 company_type = SELLER인 업체 중 하나가
그 테넌트의 대표 판매업체
이 관계를 명시하려면 seller_company_id가 가장 직관적입니다.

다만 구현 시 순환 참조만 조심하면 됩니다.

추천 방식
tb_tenant 먼저 생성
tb_company에 판매업체 생성
tb_tenant.seller_company_id 업데이트
또는 FK를 나중에 추가해도 됩니다.

1. 역할명 통일
이 부분도 맞습니다.
1단계에서는 용어가 많아질수록 혼란만 커집니다.

최종 통일안은 아래로 가면 됩니다.

SUPER_ADMIN
SELLER_ADMIN
CHANNEL_ADMIN
BUYER_ADMIN
깔끔하고, 화면/권한/API 모두에 쓰기 좋습니다.

1. 채널 코드 통일
이 역시 맞습니다.
1단계는 명확하고 짧은 코드가 최고입니다.

최종 통일 추천:

PARCEL = 전국택배
FREIGHT = 화물직송
PICKUP = 공장수령
이 정도면 운영자도 이해하기 쉽고 개발자도 덜 고생합니다.

최종 1단계 설계안
이제 주신 보완사항을 반영해서 최종 확정 가능한 1단계 경량 모델로 정리해드리겠습니다.

1. 최종 역할 정의
SUPER_ADMIN
플랫폼 전체 관리
테넌트 생성/수정/비활성
판매업체 등록 및 테넌트 대표 판매업체 지정
판매업체 관리자 등록
전체 감사 로그 조회 가능
SELLER_ADMIN
자기 테넌트의 판매업체 관리자
채널관리자 등록/수정
구매업체 등록/수정
구매업체 여신한도 관리
계좌정보/업체 담당자 관리
CHANNEL_ADMIN
자기 채널 범위에서만 구매업체 등록/수정
자기 채널 구매업체 담당자 관리
자기 채널 범위 데이터만 조회/관리
BUYER_ADMIN
자기 구매업체 정보 조회/수정
자기 업체 담당자 관리
자기 업체 계정 관리(범위 제한)
2. 최종 데이터 원칙
이건 설계서 맨 앞에 적어도 됩니다.

원칙 A
업체는 법적 거래주체다.

원칙 B
사용자는 로그인 계정이다.

원칙 C
채널은 운영/권한 범위다.

원칙 D
세금계산서의 공급자/공급받는자는 반드시 업체 기준이다.

이 원칙은 특히 세무적으로 중요합니다. 거래당사자와 운영주체가 섞이면 세금계산서, 위수탁 해석, 거래 증빙 정합성이 흔들릴 수 있습니다. Source

1. 최종 테이블 목록
주신 목록 그대로 가면 됩니다.

tb_tenant
tb_channel
tb_company
tb_company_contact
tb_user
tb_buyer_channel
tb_company_bank_account
tb_buyer_financial
tb_audit_log
이 9개면 1단계 회원정보 범위로 충분합니다.
가볍고, 확장도 가능합니다.

1. 최종 테이블 명세
4-1. tb_tenant
플랫폼 분양 단위

컬럼명 타입 설명 제약
tenant_id BIGINT PK 테넌트 ID PK
tenant_code VARCHAR(50) 테넌트 코드 UNIQUE, NOT NULL
tenant_name VARCHAR(200) 플랫폼명 NOT NULL
seller_company_id BIGINT 대표 판매업체 ID FK tb_company.company_id, NULL 가능(초기 생성 시)
status VARCHAR(20) ACTIVE / INACTIVE NOT NULL
created_at DATETIME 생성일시 NOT NULL
updated_at DATETIME 수정일시 NOT NULL
운영 규칙
테넌트당 대표 판매업체는 1개
seller_company_id는 반드시 같은 테넌트 소속의 SELLER 업체여야 함
4-2. tb_channel
운영 채널

컬럼명 타입 설명 제약
channel_id BIGINT PK 채널 ID PK
tenant_id BIGINT 테넌트 ID FK, NOT NULL
channel_code VARCHAR(20) PARCEL / FREIGHT / PICKUP NOT NULL
channel_name VARCHAR(100) 전국택배 / 화물직송 / 공장수령 NOT NULL
status VARCHAR(20) ACTIVE / INACTIVE NOT NULL
sort_order INT 정렬순서
created_at DATETIME 생성일시 NOT NULL
updated_at DATETIME 수정일시 NOT NULL
제약
UNIQUE (tenant_id, channel_code)
4-3. tb_company
업체 마스터

컬럼명 타입 설명 제약
company_id BIGINT PK 업체 ID PK
tenant_id BIGINT 테넌트 ID FK, NOT NULL
company_type VARCHAR(20) SELLER / BUYER NOT NULL
seller_type VARCHAR(20) RAW / PROCESSED / FINISHED SELLER일 때만 사용
company_name VARCHAR(200) 업체명 NOT NULL
business_no VARCHAR(20) 사업자등록번호 NOT NULL
ceo_name VARCHAR(100) 대표자명 NOT NULL
postal_code VARCHAR(10) 우편번호
address1 VARCHAR(255) 주소
address2 VARCHAR(255) 상세주소
phone VARCHAR(30) 대표전화
email VARCHAR(150) 대표 이메일
default_tax_type VARCHAR(20) TAX_FREE / TAXABLE NOT NULL
biz_status VARCHAR(20) ACTIVE / SUSPENDED / CLOSED NOT NULL
biz_checked_at DATETIME 사업자 상태 확인 일시
biz_checked_result VARCHAR(100) 확인 결과
status VARCHAR(20) ACTIVE / INACTIVE NOT NULL
created_at DATETIME 생성일시 NOT NULL
updated_at DATETIME 수정일시 NOT NULL
운영 규칙
company_type = SELLER이면 seller_type 필수
company_type = BUYER이면 seller_type NULL
RAW는 기본 TAX_FREE
PROCESSED, FINISHED는 기본 TAXABLE
중요한 주석
default_tax_type은 기본값입니다.
최종 과세 확정은 상품/주문에서 해야 합니다. 미가공식료품 및 원생산물의 본래 성질이 변하지 않는 정도의 1차 가공까지가 면세 범위라는 기준을 따라야 합니다. Source

제약
UNIQUE (tenant_id, business_no)
4-4. tb_company_contact
업체 담당자

컬럼명 타입 설명 제약
contact_id BIGINT PK 담당자 ID PK
company_id BIGINT 업체 ID FK, NOT NULL
contact_name VARCHAR(100) 담당자명 NOT NULL
contact_role VARCHAR(30) ADMIN / SALES / TAX / SETTLEMENT / SHIPPING / PURCHASE NOT NULL
mobile VARCHAR(30) 휴대전화
email VARCHAR(150) 이메일
is_primary CHAR(1) 대표 담당자 여부 DEFAULT 'N'
linked_user_id BIGINT 연결된 사용자 ID FK tb_user.user_id, NULL 가능
status VARCHAR(20) ACTIVE / INACTIVE NOT NULL
created_at DATETIME 생성일시 NOT NULL
updated_at DATETIME 수정일시 NOT NULL
설명
로그인 없는 담당자도 등록 가능
세금/정산/출고 담당 분리 가능
4-5. tb_user
로그인 사용자

컬럼명 타입 설명 제약
user_id BIGINT PK 사용자 ID PK
tenant_id BIGINT 테넌트 ID FK, NULL 가능
company_id BIGINT 소속 업체 ID FK, NULL 가능
login_id VARCHAR(100) 로그인 ID UNIQUE, NOT NULL
password_hash VARCHAR(255) 비밀번호 해시 NOT NULL
user_name VARCHAR(100) 이름 NOT NULL
mobile VARCHAR(30) 휴대전화
email VARCHAR(150) 이메일
user_role VARCHAR(20) SUPER_ADMIN / SELLER_ADMIN / CHANNEL_ADMIN / BUYER_ADMIN NOT NULL
channel_id BIGINT CHANNEL_ADMIN일 때만 채널 ID FK tb_channel.channel_id, NULL 가능
status VARCHAR(20) ACTIVE / LOCKED / INACTIVE NOT NULL
last_login_at DATETIME 마지막 로그인
created_at DATETIME 생성일시 NOT NULL
updated_at DATETIME 수정일시 NOT NULL
역할별 규칙
SUPER_ADMIN → tenant_id = NULL, company_id = NULL, channel_id = NULL
SELLER_ADMIN → tenant_id NOT NULL, company_id = 판매업체, channel_id = NULL
CHANNEL_ADMIN → tenant_id NOT NULL, company_id = 판매업체, channel_id NOT NULL
BUYER_ADMIN → tenant_id NOT NULL, company_id = 구매업체, channel_id = NULL
추가 권장 검증
CHANNEL_ADMIN.company_id는 반드시 tb_tenant.seller_company_id와 동일 판매업체여야 함
BUYER_ADMIN.company_id는 company_type = BUYER여야 함
4-6. tb_buyer_channel
구매업체 채널 소속

컬럼명 타입 설명 제약
buyer_channel_id BIGINT PK PK PK
tenant_id BIGINT 테넌트 ID FK, NOT NULL
buyer_company_id BIGINT 구매업체 ID FK, NOT NULL
channel_id BIGINT 채널 ID FK, NOT NULL
status VARCHAR(20) ACTIVE / INACTIVE NOT NULL
joined_at DATETIME 등록일시
created_by BIGINT 등록 사용자 ID FK tb_user.user_id
created_at DATETIME 생성일시 NOT NULL
제약
UNIQUE (tenant_id, buyer_company_id, channel_id)
설명
구매업체는 여러 채널 소속 가능
채널관리자는 자기 채널 데이터만 등록 가능
4-7. tb_company_bank_account
업체 계좌정보

컬럼명 타입 설명 제약
bank_account_id BIGINT PK 계좌 ID PK
company_id BIGINT 업체 ID FK, NOT NULL
bank_name VARCHAR(100) 은행명 NOT NULL
account_no_enc VARCHAR(255) 암호화 계좌번호 NOT NULL
account_holder VARCHAR(100) 예금주 NOT NULL
is_default CHAR(1) 기본계좌 여부 DEFAULT 'N'
status VARCHAR(20) ACTIVE / INACTIVE NOT NULL
created_at DATETIME 생성일시 NOT NULL
updated_at DATETIME 수정일시 NOT NULL
운영 규칙
업체당 기본계좌 1개만 허용
계좌번호는 평문 저장 지양
4-8. tb_buyer_financial
구매업체 금융 정보

컬럼명 타입 설명 제약
buyer_financial_id BIGINT PK PK PK
buyer_company_id BIGINT 구매업체 ID FK, NOT NULL
credit_limit_amount DECIMAL(18,2) 여신한도 NOT NULL DEFAULT 0
meat_money_enabled CHAR(1) 미트머니 사용 여부 DEFAULT 'N'
status VARCHAR(20) ACTIVE / INACTIVE NOT NULL
updated_at DATETIME 수정일시 NOT NULL
updated_by BIGINT 수정 사용자 ID FK tb_user.user_id
설명
1단계에서는 여기까지만 두면 충분합니다.
잔액 원장, 충전/차감 내역은 2단계로 분리하면 됩니다.

4-9. tb_audit_log
감사 로그

컬럼명 타입 설명 제약
audit_id BIGINT PK PK PK
tenant_id BIGINT 테넌트 ID FK, NULL 가능
entity_name VARCHAR(50) 대상 테이블명 NOT NULL
entity_id BIGINT 대상 PK NOT NULL
action_type VARCHAR(20) INSERT / UPDATE / DELETE / LOGIN NOT NULL
before_json JSON 변경 전 값
after_json JSON 변경 후 값
actor_user_id BIGINT 작업자 FK tb_user.user_id
acted_at DATETIME 작업일시 NOT NULL
ip_address VARCHAR(50) 접속 IP
꼭 로그 남길 항목
사업자등록번호 변경
기본 과세구분 변경
여신한도 변경
계좌정보 변경
사용자 역할 변경
장부·증빙의 성실 작성과 보존 관점에서 변경 이력은 남기는 게 안전합니다. Source

1. 추가로 꼭 적용하면 좋은 제약 7가지
이건 설계 완성도를 확 끌어올립니다.

① 테넌트당 판매업체 1개
tb_tenant.seller_company_id는 1건
같은 테넌트 내 SELLER 업체도 1개만 허용하는 운영 규칙 추천
② SUPER_ADMIN만 예외
tb_user.user_role = SUPER_ADMIN일 때만 tenant_id/company_id/channel_id NULL 허용
③ CHANNEL_ADMIN은 채널 필수
CHANNEL_ADMIN이면 channel_id NOT NULL
④ BUYER_ADMIN은 구매업체만 소속 가능
연결된 company_id는 반드시 company_type = BUYER
⑤ 구매업체 채널 중복 금지
tb_buyer_channel 중복 방지
⑥ 대표 계좌 1개
업체당 is_default='Y' 1건만 허용
⑦ 사업자 상태 조회 이력 남기기
업체 생성/수정 시 biz_checked_at, biz_checked_result 저장
홈택스 사업자등록 상태 조회 기반 운영 권장 Source
6. 최종 판단
네, 주신 보완안을 적용한 현재 버전이 1단계로 가장 적절합니다.

한 줄로 정리하면:

**“경량 설계인데도, 거래주체·권한주체·운영범위를 분리해서 세무와 운영을 동시에 지키는 구조”**입니다.

특히 이번 수정으로 좋아진 점은 세 가지입니다.

SUPER_ADMIN이 생겨 플랫폼 운영계층이 완성됨
seller_company_id로 테넌트-판매업체 대표 관계가 명확해짐
역할명/채널코드가 통일되어 설계서, API, 화면 정의가 훨씬 쉬워짐
이 정도면 1단계 개발 범위로 충분히 단순하고, 나중에 2단계에서
다중 역할, 권한 매핑, 금융 원장, 세금 프로필 이력으로 자연스럽게 확장 가능합니다.

# SQL

-- =========================================================
-- 맛팜 B2B 폐쇄 플랫폼 - 1단계 회원관리 경량 모델 (최종 확정본)
-- MySQL 8.0+
-- =========================================================

-- 권장 세션 설정
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ---------------------------------------------------------
-- 기존 구 스키마(matpam_mody.sql) 잔재 제거
-- ---------------------------------------------------------
DROP TABLE IF EXISTS tb_member_channel_role;
DROP TABLE IF EXISTS tb_buyer_profile;
DROP TABLE IF EXISTS tb_seller_profile;
DROP TABLE IF EXISTS tb_seller_settlement_account;
DROP TABLE IF EXISTS tb_member_contact;
DROP TABLE IF EXISTS tb_admin_profile;
DROP TABLE IF EXISTS tb_member_master;
DROP TABLE IF EXISTS tb_company_master;

-- ---------------------------------------------------------
-- 신규 스키마 초기화 (종속성 역순)
-- ---------------------------------------------------------
DROP TABLE IF EXISTS tb_audit_log;
DROP TABLE IF EXISTS tb_buyer_financial;
DROP TABLE IF EXISTS tb_company_bank_account;
DROP TABLE IF EXISTS tb_buyer_channel;
DROP TABLE IF EXISTS tb_company_contact;
DROP TABLE IF EXISTS tb_user;
-- tb_tenant와 tb_company의 순환 참조 해결을 위해 FK 먼저 제거
ALTER TABLE tb_tenant DROP FOREIGN KEY fk_tb_tenant_01;
DROP TABLE IF EXISTS tb_company;
DROP TABLE IF EXISTS tb_channel;
DROP TABLE IF EXISTS tb_tenant;

-- =========================================================
-- 1. 테넌트
-- =========================================================
CREATE TABLE IF NOT EXISTS tb_tenant (
    tenant_id            BIGINT NOT NULL AUTO_INCREMENT COMMENT '테넌트 ID',
    tenant_code          VARCHAR(50) NOT NULL COMMENT '테넌트 코드',
    tenant_name          VARCHAR(200) NOT NULL COMMENT '테넌트명',
    seller_company_id    BIGINT NULL COMMENT '대표 판매업체 ID',
    status               ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (tenant_id),
    UNIQUE KEY uk_tb_tenant_01 (tenant_code),
    KEY idx_tb_tenant_01 (seller_company_id),
    KEY idx_tb_tenant_02 (status)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='플랫폼 분양 단위';

-- =========================================================
-- 2. 채널
-- =========================================================
CREATE TABLE IF NOT EXISTS tb_channel (
    channel_id           BIGINT NOT NULL AUTO_INCREMENT COMMENT '채널 ID',
    tenant_id            BIGINT NOT NULL COMMENT '테넌트 ID',
    channel_code         ENUM('PARCEL','FREIGHT','PICKUP') NOT NULL COMMENT '채널코드',
    channel_name         VARCHAR(100) NOT NULL COMMENT '채널명',
    status               ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    sort_order           INT NOT NULL DEFAULT 0 COMMENT '정렬순서',
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (channel_id),
    UNIQUE KEY uk_tb_channel_01 (tenant_id, channel_code),
    UNIQUE KEY uk_tb_channel_02 (tenant_id, channel_id),
    KEY idx_tb_channel_01 (status),
    CONSTRAINT fk_tb_channel_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='테넌트별 운영 채널';

-- =========================================================
-- 3. 업체
-- =========================================================
CREATE TABLE IF NOT EXISTS tb_company (
    company_id              BIGINT NOT NULL AUTO_INCREMENT COMMENT '업체 ID',
    tenant_id               BIGINT NOT NULL COMMENT '테넌트 ID',
    company_type            ENUM('SELLER','BUYER') NOT NULL COMMENT '업체유형',
    seller_type             ENUM('RAW','PROCESSED','FINISHED') NULL COMMENT '판매업체유형',
    company_name            VARCHAR(200) NOT NULL COMMENT '업체명',
    business_no             VARCHAR(20) NOT NULL COMMENT '사업자등록번호',
    ceo_name                VARCHAR(100) NOT NULL COMMENT '대표자명',
    postal_code             VARCHAR(10) NULL COMMENT '우편번호',
    address1                VARCHAR(255) NULL COMMENT '주소',
    address2                VARCHAR(255) NULL COMMENT '상세주소',
    phone                   VARCHAR(30) NULL COMMENT '대표전화',
    email                   VARCHAR(150) NULL COMMENT '대표이메일',
    default_tax_type        ENUM('TAX_FREE','TAXABLE') NOT NULL COMMENT '기본 과세구분',
    biz_status              ENUM('ACTIVE','SUSPENDED','CLOSED') NOT NULL DEFAULT 'ACTIVE' COMMENT '사업자 상태',
    biz_checked_at          DATETIME NULL COMMENT '사업자 상태 확인일시',
    biz_checked_result      VARCHAR(100) NULL COMMENT '사업자 상태 확인 결과',
    status                  ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '사용 상태',
    created_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    -- tenant당 SELLER 1개만 허용하기 위한 가드 컬럼
    seller_tenant_guard     BIGINT GENERATED ALWAYS AS (
                                CASE
                                    WHEN company_type = 'SELLER' THEN tenant_id
                                    ELSE NULL
                                END
                            ) STORED COMMENT 'SELLER 1개 제한용 가드',

    PRIMARY KEY (company_id),
    UNIQUE KEY uk_tb_company_01 (tenant_id, business_no),
    UNIQUE KEY uk_tb_company_02 (tenant_id, company_id),
    UNIQUE KEY uk_tb_company_03 (seller_tenant_guard),
    KEY idx_tb_company_01 (company_type),
    KEY idx_tb_company_02 (status),
    KEY idx_tb_company_03 (seller_type),
    CONSTRAINT fk_tb_company_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_tb_company_01 CHECK (
        (company_type = 'SELLER' AND seller_type IS NOT NULL)
        OR
        (company_type = 'BUYER' AND seller_type IS NULL)
    )
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='법적 거래주체 업체 마스터';

-- =========================================================
-- 4. 사용자
-- =========================================================
CREATE TABLE IF NOT EXISTS tb_user (
    user_id               BIGINT NOT NULL AUTO_INCREMENT COMMENT '사용자 ID',
    tenant_id             BIGINT NULL COMMENT '테넌트 ID',
    company_id            BIGINT NULL COMMENT '소속 업체 ID',
    login_id              VARCHAR(100) NOT NULL COMMENT '로그인 ID',
    password_hash         VARCHAR(255) NOT NULL COMMENT '비밀번호 해시',
    user_name             VARCHAR(100) NOT NULL COMMENT '사용자명',
    mobile                VARCHAR(30) NULL COMMENT '휴대전화',
    email                 VARCHAR(150) NULL COMMENT '이메일',
    user_role             ENUM('SUPER_ADMIN','SELLER_ADMIN','CHANNEL_ADMIN','BUYER_ADMIN') NOT NULL COMMENT '역할',
    channel_id            BIGINT NULL COMMENT '채널 ID',
    status                ENUM('ACTIVE','LOCKED','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    last_login_at         DATETIME NULL COMMENT '마지막 로그인 일시',
    created_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (user_id),
    UNIQUE KEY uk_tb_user_01 (login_id),
    KEY idx_tb_user_01 (tenant_id, company_id),
    KEY idx_tb_user_02 (channel_id),
    KEY idx_tb_user_03 (user_role),
    KEY idx_tb_user_04 (status),
    CONSTRAINT fk_tb_user_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_tb_user_02
        FOREIGN KEY (tenant_id, company_id) REFERENCES tb_company (tenant_id, company_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_tb_user_03
        FOREIGN KEY (tenant_id, channel_id) REFERENCES tb_channel (tenant_id, channel_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    -- SUPER_ADMIN은 tenant_id가 NULL이므로 FK 검증(RESTRICT)을 통과함 (MySQL MATCH SIMPLE 정책)
    CONSTRAINT chk_tb_user_01 CHECK (
        (user_role = 'SUPER_ADMIN'  AND tenant_id IS NULL     AND company_id IS NULL     AND channel_id IS NULL)
        OR
        (user_role = 'SELLER_ADMIN' AND tenant_id IS NOT NULL AND company_id IS NOT NULL AND channel_id IS NULL)
        OR
        (user_role = 'CHANNEL_ADMIN'AND tenant_id IS NOT NULL AND company_id IS NOT NULL AND channel_id IS NOT NULL)
        OR
        (user_role = 'BUYER_ADMIN'  AND tenant_id IS NOT NULL AND company_id IS NOT NULL AND channel_id IS NULL)
    )
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='로그인 사용자 계정';

-- =========================================================
-- 5. 업체 담당자
-- =========================================================
CREATE TABLE IF NOT EXISTS tb_company_contact (
    contact_id            BIGINT NOT NULL AUTO_INCREMENT COMMENT '담당자 ID',
    company_id            BIGINT NOT NULL COMMENT '업체 ID',
    contact_name          VARCHAR(100) NOT NULL COMMENT '담당자명',
    contact_role          ENUM('ADMIN','SALES','TAX','SETTLEMENT','SHIPPING','PURCHASE') NOT NULL COMMENT '담당 역할',
    mobile                VARCHAR(30) NULL COMMENT '휴대전화',
    email                 VARCHAR(150) NULL COMMENT '이메일',
    is_primary            CHAR(1) NOT NULL DEFAULT 'N' COMMENT '대표 담당자 여부',
    linked_user_id        BIGINT NULL COMMENT '연결 사용자 ID',
    status                ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    created_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    -- 업체당 대표 담당자(is_primary='Y') 1명만 허용하기 위한 가드 컬럼
    primary_company_guard BIGINT GENERATED ALWAYS AS (
                                CASE
                                    WHEN is_primary = 'Y' THEN company_id
                                    ELSE NULL
                                END
                            ) STORED COMMENT '대표 담당자 1명 제한용 가드',

    PRIMARY KEY (contact_id),
    UNIQUE KEY uk_tb_company_contact_01 (primary_company_guard),
    KEY idx_tb_company_contact_01 (company_id),
    KEY idx_tb_company_contact_02 (linked_user_id),
    KEY idx_tb_company_contact_03 (status),
    KEY idx_tb_company_contact_04 (contact_role),
    CONSTRAINT fk_tb_company_contact_01
        FOREIGN KEY (company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_tb_company_contact_02
        FOREIGN KEY (linked_user_id) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CONSTRAINT chk_tb_company_contact_01 CHECK (is_primary IN ('Y','N'))
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='업체 담당자 정보';

-- =========================================================
-- 6. 구매업체 채널 소속
-- =========================================================
CREATE TABLE IF NOT EXISTS tb_buyer_channel (
    buyer_channel_id      BIGINT NOT NULL AUTO_INCREMENT COMMENT '구매업체 채널 소속 ID',
    tenant_id             BIGINT NOT NULL COMMENT '테넌트 ID',
    buyer_company_id      BIGINT NOT NULL COMMENT '구매업체 ID',
    channel_id            BIGINT NOT NULL COMMENT '채널 ID',
    status                ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    joined_at             DATETIME NULL COMMENT '참여일시',
    created_by            BIGINT NULL COMMENT '등록 사용자 ID',
    created_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    PRIMARY KEY (buyer_channel_id),
    UNIQUE KEY uk_tb_buyer_channel_01 (tenant_id, buyer_company_id, channel_id),
    KEY idx_tb_buyer_channel_01 (buyer_company_id),
    KEY idx_tb_buyer_channel_02 (channel_id),
    KEY idx_tb_buyer_channel_03 (created_by),
    KEY idx_tb_buyer_channel_04 (status),
    CONSTRAINT fk_tb_buyer_channel_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_tb_buyer_channel_02
        FOREIGN KEY (tenant_id, buyer_company_id) REFERENCES tb_company (tenant_id, company_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_tb_buyer_channel_03
        FOREIGN KEY (tenant_id, channel_id) REFERENCES tb_channel (tenant_id, channel_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_tb_buyer_channel_04
        FOREIGN KEY (created_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='구매업체별 채널 소속 정보';

-- =========================================================
-- 7. 업체 계좌정보
-- =========================================================
CREATE TABLE IF NOT EXISTS tb_company_bank_account (
    bank_account_id         BIGINT NOT NULL AUTO_INCREMENT COMMENT '계좌 ID',
    company_id              BIGINT NOT NULL COMMENT '업체 ID',
    bank_name               VARCHAR(100) NOT NULL COMMENT '은행명',
    account_no_enc          VARCHAR(255) NOT NULL COMMENT '암호화 계좌번호',
    account_holder          VARCHAR(100) NOT NULL COMMENT '예금주',
    is_default              CHAR(1) NOT NULL DEFAULT 'N' COMMENT '기본계좌 여부',
    status                  ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    created_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    -- 업체당 기본계좌 1개만 허용
    default_company_guard   BIGINT GENERATED ALWAYS AS (
                                CASE
                                    WHEN is_default = 'Y' THEN company_id
                                    ELSE NULL
                                END
                            ) STORED COMMENT '기본계좌 1개 제한용 가드',

    PRIMARY KEY (bank_account_id),
    UNIQUE KEY uk_tb_company_bank_account_01 (default_company_guard),
    KEY idx_tb_company_bank_account_01 (company_id),
    KEY idx_tb_company_bank_account_02 (status),
    CONSTRAINT fk_tb_company_bank_account_01
        FOREIGN KEY (company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_tb_company_bank_account_01 CHECK (is_default IN ('Y','N'))
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='업체 계좌정보';

-- =========================================================
-- 8. 구매업체 금융정보
-- =========================================================
CREATE TABLE IF NOT EXISTS tb_buyer_financial (
    buyer_financial_id     BIGINT NOT NULL AUTO_INCREMENT COMMENT '구매업체 금융정보 ID',
    buyer_company_id       BIGINT NOT NULL COMMENT '구매업체 ID',
    credit_limit_amount    DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '여신한도',
    meat_money_enabled     CHAR(1) NOT NULL DEFAULT 'N' COMMENT '미트머니 사용 여부',
    status                 ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
    created_at             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    updated_by             BIGINT NULL COMMENT '수정 사용자 ID',
    PRIMARY KEY (buyer_financial_id),
    UNIQUE KEY uk_tb_buyer_financial_01 (buyer_company_id),
    KEY idx_tb_buyer_financial_01 (updated_by),
    KEY idx_tb_buyer_financial_02 (status),
    CONSTRAINT fk_tb_buyer_financial_01
        FOREIGN KEY (buyer_company_id) REFERENCES tb_company (company_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_tb_buyer_financial_02
        FOREIGN KEY (updated_by) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CONSTRAINT chk_tb_buyer_financial_01 CHECK (meat_money_enabled IN ('Y','N')),
    CONSTRAINT chk_tb_buyer_financial_02 CHECK (credit_limit_amount >= 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='구매업체 금융 기본정보';

-- =========================================================
-- 9. 감사 로그
-- =========================================================
CREATE TABLE IF NOT EXISTS tb_audit_log (
    audit_id              BIGINT NOT NULL AUTO_INCREMENT COMMENT '감사로그 ID',
    tenant_id             BIGINT NULL COMMENT '테넌트 ID',
    entity_name           VARCHAR(50) NOT NULL COMMENT '대상 엔티티명',
    entity_id             BIGINT NOT NULL COMMENT '대상 엔티티 PK',
    action_type           ENUM('INSERT','UPDATE','DELETE','LOGIN') NOT NULL COMMENT '작업유형',
    before_json           JSON NULL COMMENT '변경 전 값',
    after_json            JSON NULL COMMENT '변경 후 값',
    actor_user_id         BIGINT NULL COMMENT '작업 사용자 ID',
    acted_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작업일시',
    ip_address            VARCHAR(50) NULL COMMENT 'IP 주소',
    PRIMARY KEY (audit_id),
    KEY idx_tb_audit_log_01 (tenant_id),
    KEY idx_tb_audit_log_02 (entity_name, entity_id),
    KEY idx_tb_audit_log_03 (actor_user_id),
    KEY idx_tb_audit_log_04 (acted_at),
    CONSTRAINT fk_tb_audit_log_01
        FOREIGN KEY (tenant_id) REFERENCES tb_tenant (tenant_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CONSTRAINT fk_tb_audit_log_02
        FOREIGN KEY (actor_user_id) REFERENCES tb_user (user_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='주요 마스터 변경 및 로그인 감사 로그';

-- =========================================================
-- 순환참조 처리: tb_tenant.seller_company_id -> tb_company
-- 같은 tenant 소속 company만 대표 판매업체로 지정되도록 composite FK 사용
-- =========================================================
ALTER TABLE tb_tenant
    ADD CONSTRAINT fk_tb_tenant_01
        FOREIGN KEY (tenant_id, seller_company_id)
        REFERENCES tb_company (tenant_id, company_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT;

-- =========================================================
-- 초기 기초 데이터 등록 (SUPER_ADMIN 및 기본 테넌트)
-- =========================================================
-- 1. 수퍼관리자 계정 (비밀번호는 'admin123' 가정. 실제 적용 시 Bcrypt 등 암호화된 해시로 변경 필요)
INSERT INTO tb_user (login_id, password_hash, user_name, user_role, status)
VALUES ('superadmin', 'admin123', '최상위 수퍼관리자', 'SUPER_ADMIN', 'ACTIVE');

-- 2. 기본 개발용 테넌트 생성
INSERT INTO tb_tenant (tenant_code, tenant_name, status)
VALUES ('MATPAM_DEV', '맛팜 플랫폼 (개발/기본)', 'ACTIVE');

-- 3. 기본 채널 3종 생성
INSERT INTO tb_channel (tenant_id, channel_code, channel_name, sort_order)
VALUES 
    (1, 'PARCEL', '전국택배', 1),
    (1, 'FREIGHT', '화물직송', 2),
    (1, 'PICKUP', '공장수령', 3);

SET FOREIGN_KEY_CHECKS = 1;
