아직 보완이 필요한 점
여기부터가 핵심입니다.
문서 방향은 맞는데, 실제 적용 전에는 아래를 꼭 다시 확인하는 걸 추천합니다.

1) MariaDB라고 했지만, 문서 표현은 여전히 MySQL 8.0+ 성격이 남아 있습니다
문서 안에는 MariaDB(MySQL 8.0+ 호환) 식 표현과 함께
JSON, CHECK, GENERATED ALWAYS AS ... STORED 같은 문법이 같이 보입니다.
이건 개념상 큰 문제는 없지만, 실제 운영 DB가 MariaDB 몇 버전인지에 따라 테스트가 필요합니다. Source

특히 체크 포인트는:

MariaDB 10.3 / 10.4 / 10.5 / 10.6 이상인지
CHECK CONSTRAINT가 실제 강제되는 버전인지
STORED generated column + UNIQUE INDEX 조합이 문제 없는지
JSON을 진짜 JSON처럼 쓸지, 사실상 LONGTEXT로 볼지
즉, DDL 문법이 맞는지보다 “운영 버전에서 강제로 잘 먹는지” 확인이 더 중요합니다.

2) CHECK 제약은 DB만 믿지 말고 서비스 로직에서도 같이 막아야 합니다
문서에서는 역할별 제약을 CHECK로 표현한 부분이 보입니다. 예를 들면:

SUPER_ADMIN이면 tenant_id/company_id/channel_id = NULL
CHANNEL_ADMIN이면 channel_id NOT NULL
SELLER면 seller_type NOT NULL
이건 설계 표현으로는 좋습니다.
하지만 MariaDB에선 버전과 설정에 따라 CHECK를 신뢰하기 애매한 경우가 있어,
실제 서비스 로직에서도 동일 검증을 꼭 넣는 게 맞습니다. Source

즉:

DB 제약 = 1차 방어선
서비스 검증 = 2차 방어선
으로 가야 안전합니다.

3) tb_tenant ↔ tb_company 순환참조는 설계상 맞지만, 초기 데이터 적재 절차를 문서에 더 명확히 써두면 좋습니다
문서에서도 seller_company_id 때문에 순환 참조를 처리하는 구조가 보입니다.
이건 나쁜 설계는 아닙니다. 다만 실무에서는 아래 순서가 명확해야 합니다.

tb_tenant 생성 (seller_company_id = NULL)
tb_company에 SELLER 생성
tb_tenant.seller_company_id 업데이트
필요 시 FK 추가 또는 검증
이 절차를 운영 문서에 박아두면 DBA나 개발자가 덜 헷갈립니다. Source

4) JSON audit log는 실용적이지만, 조회 전략도 같이 정리해야 합니다
문서에서 tb_audit_log.before_json / after_json 구조를 쓰는 건 좋습니다.
1단계에서는 가장 빠른 방법이기도 합니다. Source

다만 실무적으로는 추가로 정해야 합니다.

자주 조회할 감사 항목은 무엇인가
entity_name + entity_id로만 찾을지
actor_user_id + acted_at 인덱스로 충분한지
장기적으로 로그 보관 주기/아카이빙 정책이 필요한지
즉, 저장은 괜찮고, 운영 조회 전략이 한 줄 더 필요합니다.

5) 개인정보 보안 항목은 계좌 외에도 범위를 넓히면 더 좋습니다
문서에 계좌번호 암호화(account_no_enc)는 잘 들어가 있습니다.
하지만 실무 보안 관점에서는 아래도 같이 검토하면 더 좋습니다.

휴대폰 번호 마스킹/암호화
이메일 마스킹
사업자등록번호 표시 마스킹
감사로그에 민감정보 전체 원문 저장 금지
특히 before_json / after_json에 민감정보를 통째로 넣기 시작하면,
감사로그가 오히려 개인정보 저장소가 되는 역전 현상이 생길 수 있습니다.

공통코드 정리 방향과의 정합성
문서 흐름상, 예전에 검토했던 공통코드 정리 방향과도 잘 맞습니다.
특히 아래 코드 체계로 정리하는 방향이 문서와 잘 맞습니다. Source

유지/신설 권장
USER_ROLE

SUPER_ADMIN
SELLER_ADMIN
CHANNEL_ADMIN
BUYER_ADMIN
COMPANY_TYPE

SELLER
BUYER
SELLER_TYPE

RAW
PROCESSED
FINISHED
CHANNEL_TYPE

PARCEL
FREIGHT
PICKUP
BIZ_STATUS

ACTIVE
SUSPENDED
CLOSED
USER_STATUS

ACTIVE
LOCKED
INACTIVE
CONTACT_ROLE

ADMIN
SALES
TAX
SETTLEMENT
SHIPPING
PURCHASE
정리/축소 권장
ROLE_TYPE
MEMBER_TYPE
ADMIN_ROLE
MEMBER_ROLE
SELLER_ROLE
즉, 로그인 권한은 USER_ROLE 하나로 정리하고,
나머지는 회사유형/판매유형/상태코드로 분리하는 게 맞습니다.

제가 추천하는 마지막 보완 체크리스트
적용 전 이 8개만 확인하면 됩니다.

운영 MariaDB 버전 명시
CHECK 제약 실제 강제 여부 테스트
GENERATED COLUMN + UNIQUE INDEX 테스트
JSON 타입 사용 전략 확인
SUPER_ADMIN의 tenant_id = NULL 정책 확정
seller_company_id 초기 적재 절차 문서화
감사로그 민감정보 마스킹 정책 정의
USER_ROLE / COMPANY_TYPE / SELLER_TYPE / CHANNEL_TYPE 공통코드 정식 확정
