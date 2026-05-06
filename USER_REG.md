이제부터는 **“회원 타입별 등록 화면 + 저장 로직”**을 실제 개발 가능한 수준으로 끌어내리겠습니다.
핵심은 하나입니다.

화면은 단순하게, 저장 로직은 단단하게.
즉, 사용자는 헷갈리지 않게 입력하고, 서버는 절대 잘못 저장하지 않게 막는 구조로 가야 합니다.
그리고 지금까지 정한 원칙인 업체 = 법적 거래주체 / 사용자 = 로그인 계정 / 채널 = 운영 범위는 그대로 유지해야 합니다. Source

1. 회원 등록 화면 설계 방향
기본 원칙
회원 등록은 회원 타입(user_role) 에 따라 입력 항목이 달라지는 동적 폼으로 설계하는 것이 가장 좋습니다.

회원 타입은 최종적으로 아래 4개입니다.

SUPER_ADMIN
SELLER_ADMIN
CHANNEL_ADMIN
BUYER_ADMIN
즉, 화면은 하나로 가되,
선택한 회원 타입에 따라 보여주는 필드와 저장 검증이 달라지는 방식이 1단계에 가장 적합합니다. Source

2. 회원 등록 화면 구조
화면명
회원 등록 / 수정

화면 구성
화면은 아래 4개 영역으로 나누는 걸 추천합니다.

A. 기본 정보
로그인 ID
비밀번호
비밀번호 확인
사용자명
휴대폰번호
이메일
상태 (ACTIVE / LOCKED / INACTIVE)
B. 회원 유형 정보
회원 타입 (SUPER_ADMIN / SELLER_ADMIN / CHANNEL_ADMIN / BUYER_ADMIN)
C. 소속 정보
테넌트
소속 업체
담당 채널
D. 부가 옵션
업체 담당자 동시 생성 여부
담당자 역할
대표 담당자 여부
3. 회원 타입별 화면 동작
아래가 핵심입니다.
어떤 역할을 선택했느냐에 따라 입력 가능 필드를 다르게 해야 합니다.

3-1. SUPER_ADMIN
화면 처리
회원 타입: SUPER_ADMIN
테넌트: 숨김 또는 비활성
소속 업체: 숨김 또는 비활성
담당 채널: 숨김 또는 비활성
저장 규칙
tenant_id = NULL
company_id = NULL
channel_id = NULL
화면 메시지
“수퍼관리자는 특정 테넌트/업체/채널에 소속되지 않습니다.”
3-2. SELLER_ADMIN
화면 처리
회원 타입: SELLER_ADMIN
테넌트: 필수
소속 업체: 자동 세팅 또는 읽기 전용
tb_tenant.seller_company_id 자동 조회
담당 채널: 숨김
저장 규칙
tenant_id = 선택값
company_id = tenant.seller_company_id
channel_id = NULL
화면 메시지
“판매업체 관리자는 선택한 테넌트의 대표 판매업체에 자동 소속됩니다.”
3-3. CHANNEL_ADMIN
화면 처리
회원 타입: CHANNEL_ADMIN
테넌트: 필수
소속 업체: 자동 세팅 또는 읽기 전용
tb_tenant.seller_company_id
담당 채널: 필수
저장 규칙
tenant_id = 선택값
company_id = tenant.seller_company_id
channel_id = 선택값
화면 메시지
“채널관리자는 판매업체 소속이며, 1개 채널만 담당합니다.”
3-4. BUYER_ADMIN
화면 처리
회원 타입: BUYER_ADMIN
테넌트: 필수
소속 업체: 필수
단, company_type = BUYER만 조회
담당 채널: 숨김
저장 규칙
tenant_id = 선택값
company_id = 선택한 BUYER 업체
channel_id = NULL
화면 메시지
“구매업체 관리자는 구매업체에만 소속될 수 있습니다.”
4. 권한에 따른 등록 가능 범위
등록 화면은 누가 로그인했는지에 따라 회원 타입 선택 범위도 달라져야 합니다.

권한 매트릭스
로그인 사용자	생성 가능 회원 타입	비고
SUPER_ADMIN	SUPER_ADMIN, SELLER_ADMIN, CHANNEL_ADMIN, BUYER_ADMIN	전체
SELLER_ADMIN	SELLER_ADMIN, CHANNEL_ADMIN, BUYER_ADMIN	자기 테넌트만
CHANNEL_ADMIN	BUYER_ADMIN	자기 채널에 소속 가능한 구매업체만
BUYER_ADMIN	없음 또는 추후 확장	1단계에서는 비권장
추천 운영
1단계에서는 BUYER_ADMIN은 회원 생성 권한 없음으로 가는 게 가장 깔끔합니다.
그래야 운영 권한이 단순해집니다.

5. 회원 등록 화면 상세 필드 정의
공통 입력 항목
항목	키	필수	설명
로그인 ID	login_id	Y	중복 불가
비밀번호	password	Y	신규 등록 시 필수
비밀번호 확인	password_confirm	Y	화면 검증용
사용자명	user_name	Y	이름
휴대폰번호	mobile	N	포맷 검증
이메일	email	N	이메일 포맷 검증
상태	status	Y	기본값 ACTIVE
회원 타입	user_role	Y	4개 중 하나
조건부 입력 항목
회원 타입	테넌트	소속 업체	채널
SUPER_ADMIN	숨김	숨김	숨김
SELLER_ADMIN	필수	자동세팅	숨김
CHANNEL_ADMIN	필수	자동세팅	필수
BUYER_ADMIN	필수	필수(BUYER만)	숨김
업체 담당자 동시 생성 옵션
회원 등록과 동시에 tb_company_contact를 만들면 운영이 편해집니다.

옵션 필드
담당자 동시 생성 여부 (create_contact_yn)
담당자 역할 (contact_role)
대표 담당자 여부 (is_primary)
기본값 추천
SELLER_ADMIN → ADMIN
CHANNEL_ADMIN → ADMIN 또는 SHIPPING
BUYER_ADMIN → PURCHASE
6. 화면 UX 추천
상단 흐름
회원 타입 선택
타입에 맞는 소속 필드 자동 노출
로그인 정보 입력
연락처 입력
저장
UX 포인트
회원 타입을 먼저 선택하면 나머지 필드가 동적으로 바뀌어야 함
SELLER_ADMIN, CHANNEL_ADMIN은 회사 선택을 직접 하게 하지 말고 자동 세팅
BUYER_ADMIN만 구매업체를 직접 고르게 함
login_id는 “중복확인” 버튼 제공
저장 버튼 누르기 전 프론트 1차 검증 수행
7. API 설계
등록 API
POST /api/admin/users

수정 API
PUT /api/admin/users/{userId}

상세 조회 API
GET /api/admin/users/{userId}

등록 화면용 옵션 조회 API
GET /api/admin/users/form-options?userRole=CHANNEL_ADMIN&tenantId=1

이 옵션 조회 API는 화면 렌더링을 쉽게 만들어줍니다.

응답 예시
Copy{
  "allowedRoles": ["CHANNEL_ADMIN", "BUYER_ADMIN"],
  "tenants": [
    { "tenantId": 1, "tenantName": "맛팜 본사 플랫폼" }
  ],
  "channels": [
    { "channelId": 1, "channelCode": "PARCEL", "channelName": "전국택배" },
    { "channelId": 2, "channelCode": "FREIGHT", "channelName": "화물직송" },
    { "channelId": 3, "channelCode": "PICKUP", "channelName": "공장수령" }
  ],
  "buyerCompanies": [
    { "companyId": 2, "companyName": "대전정육식당" }
  ]
}
8. 저장 요청 DTO 예시
Copy{
  "loginId": "buyeradmin03",
  "password": "Temp1234!",
  "userName": "구매담당김",
  "mobile": "010-1234-5678",
  "email": "buyer3@example.com",
  "userRole": "BUYER_ADMIN",
  "tenantId": 1,
  "companyId": 2,
  "channelId": null,
  "status": "ACTIVE",
  "createContactYn": "Y",
  "contactRole": "PURCHASE",
  "isPrimaryContact": "Y"
}
9. 저장 로직 설계
이제 진짜 중요한 저장 로직입니다.
여기는 프론트 편의보다 서버 검증이 우선입니다.

저장 로직 핵심 순서
1단계. 권한 확인
현재 로그인한 사용자가 해당 역할을 생성할 권한이 있는지 확인합니다.

예:

CHANNEL_ADMIN이 SELLER_ADMIN 생성 시도 → 거절
SELLER_ADMIN이 다른 테넌트 사용자 생성 시도 → 거절
2단계. 역할별 필수값 검증
역할에 따라 tenant_id/company_id/channel_id 조합을 검증합니다.

SUPER_ADMIN
tenant_id == null
company_id == null
channel_id == null
SELLER_ADMIN
tenant_id != null
company_id는 직접 받지 않고 서버에서 자동 세팅
channel_id == null
CHANNEL_ADMIN
tenant_id != null
channel_id != null
company_id는 서버에서 자동 세팅
BUYER_ADMIN
tenant_id != null
company_id != null
channel_id == null
3단계. 기준 데이터 조회
서버는 아래를 DB에서 다시 확인해야 합니다.

tb_tenant
tb_company
tb_channel
tb_buyer_channel
예시
SELLER_ADMIN, CHANNEL_ADMIN이면
tenant.seller_company_id 조회
BUYER_ADMIN이면
선택한 company_id가 진짜 BUYER인지 확인
CHANNEL_ADMIN이 BUYER_ADMIN 생성하면
그 구매업체가 자기 채널에 속한 업체인지 확인
4단계. 로그인 ID 중복 확인
CopySELECT COUNT(*)
FROM tb_user
WHERE login_id = :loginId;
0이 아니면 저장 거절.

5단계. 비밀번호 해시 생성
비밀번호는 서버에서 해시 처리 후 저장합니다.

권장: bcrypt
또는 argon2
DB에는 평문 저장 금지.

6단계. 사용자 저장
tb_user에 insert.

7단계. 필요 시 담당자 동시 생성
create_contact_yn = 'Y'이면 tb_company_contact도 insert.

8단계. 감사로그 저장
tb_audit_log에 등록 이력 저장.

10. 저장 로직 의사코드
서비스 레벨 의사코드
Copypublic Long registerUser(UserCreateRequest req, LoginUser actor) {

    validateActorPermission(actor, req.getUserRole(), req.getTenantId());

    validateCommonFields(req);

    Long tenantId = null;
    Long companyId = null;
    Long channelId = null;

    switch (req.getUserRole()) {
        case "SUPER_ADMIN":
            tenantId = null;
            companyId = null;
            channelId = null;
            break;

        case "SELLER_ADMIN":
            require(req.getTenantId() != null, "테넌트는 필수입니다.");
            tenantId = req.getTenantId();
            companyId = getSellerCompanyIdByTenant(tenantId);
            channelId = null;
            break;

        case "CHANNEL_ADMIN":
            require(req.getTenantId() != null, "테넌트는 필수입니다.");
            require(req.getChannelId() != null, "채널은 필수입니다.");
            tenantId = req.getTenantId();
            companyId = getSellerCompanyIdByTenant(tenantId);
            channelId = req.getChannelId();
            validateChannelBelongsToTenant(tenantId, channelId);
            break;

        case "BUYER_ADMIN":
            require(req.getTenantId() != null, "테넌트는 필수입니다.");
            require(req.getCompanyId() != null, "구매업체는 필수입니다.");
            tenantId = req.getTenantId();
            companyId = req.getCompanyId();
            channelId = null;
            validateBuyerCompany(tenantId, companyId);
            validateBuyerAccessibleByActor(actor, tenantId, companyId);
            break;

        default:
            throw new BizException("지원하지 않는 회원 타입입니다.");
    }

    validateLoginIdNotExists(req.getLoginId());

    String passwordHash = passwordEncoder.encode(req.getPassword());

    Long userId = insertUser(
        tenantId,
        companyId,
        req.getLoginId(),
        passwordHash,
        req.getUserName(),
        req.getMobile(),
        req.getEmail(),
        req.getUserRole(),
        channelId,
        req.getStatus()
    );

    if ("Y".equals(req.getCreateContactYn())) {
        insertCompanyContact(
            companyId,
            req.getUserName(),
            req.getContactRole(),
            req.getMobile(),
            req.getEmail(),
            req.getIsPrimaryContact(),
            userId
        );
    }

    insertAuditLog(actor, "tb_user", userId, "INSERT", null, buildAfterJson(...));

    return userId;
}
Copy
11. MariaDB 기준 SQL 저장 예시
11-1. 사용자 저장
CopyINSERT INTO tb_user (
    tenant_id,
    company_id,
    login_id,
    password_hash,
    user_name,
    mobile,
    email,
    user_role,
    channel_id,
    status,
    created_at,
    updated_at
) VALUES (
    :tenantId,
    :companyId,
    :loginId,
    :passwordHash,
    :userName,
    :mobile,
    :email,
    :userRole,
    :channelId,
    :status,
    NOW(),
    NOW()
);
11-2. 담당자 동시 생성
CopyINSERT INTO tb_company_contact (
    company_id,
    contact_name,
    contact_role,
    mobile,
    email,
    is_primary,
    linked_user_id,
    status,
    created_at,
    updated_at
) VALUES (
    :companyId,
    :contactName,
    :contactRole,
    :mobile,
    :email,
    :isPrimary,
    :linkedUserId,
    'ACTIVE',
    NOW(),
    NOW()
);
11-3. 감사로그 저장
CopyINSERT INTO tb_audit_log (
    tenant_id,
    entity_name,
    entity_id,
    action_type,
    before_json,
    after_json,
    actor_user_id,
    acted_at,
    ip_address
) VALUES (
    :tenantId,
    'tb_user',
    :entityId,
    'INSERT',
    NULL,
    :afterJson,
    :actorUserId,
    NOW(),
    :ipAddress
);
12. 저장 전 서버 검증 규칙
공통 검증
login_id 공백 금지
login_id 중복 금지
비밀번호 정책 검증
이메일 형식 검증
휴대폰 형식 검증
역할별 검증
SUPER_ADMIN은 tenant/company/channel 모두 NULL
SELLER_ADMIN은 tenant_id 필수, company_id는 서버 자동 세팅
CHANNEL_ADMIN은 tenant_id, channel_id 필수
BUYER_ADMIN은 company_type = BUYER만 허용
권한 검증
SELLER_ADMIN은 자기 테넌트만 가능
CHANNEL_ADMIN은 자기 채널의 구매업체만 가능
BUYER_ADMIN은 회원 생성 불가 또는 제한
13. 추천 에러코드
코드	메시지
USER_001	이미 사용 중인 로그인 ID입니다
USER_002	회원 타입별 필수 값이 누락되었습니다
USER_003	생성 권한이 없습니다
USER_004	유효하지 않은 테넌트입니다
USER_005	유효하지 않은 업체입니다
USER_006	유효하지 않은 채널입니다
USER_007	구매업체만 선택할 수 있습니다
USER_008	채널관리자는 본인 채널의 구매업체만 등록할 수 있습니다
14. 화면 예시 와이어프레임
회원 등록 팝업/페이지
Copy[회원 등록]

1. 회원 유형
   ( ) SUPER_ADMIN
   ( ) SELLER_ADMIN
   ( ) CHANNEL_ADMIN
   ( ) BUYER_ADMIN

2. 기본 정보
   로그인 ID         [____________] [중복확인]
   비밀번호          [____________]
   비밀번호 확인     [____________]
   사용자명          [____________]
   휴대폰번호        [____________]
   이메일            [____________]
   상태              [ ACTIVE v ]

3. 소속 정보
   테넌트            [ 맛팜 본사 플랫폼 v ]
   소속 업체          [ 자동세팅 / 구매업체 선택 ]
   담당 채널          [ 전국택배 v ]   <- CHANNEL_ADMIN일 때만 표시

4. 담당자 생성
   담당자 동시 생성   [ ] 생성
   담당자 역할        [ PURCHASE v ]
   대표 담당자 여부   [ ] 대표담당자

[저장] [취소]
15. 가장 실무적인 구현 팁
팁 1
회원 등록과 업체 등록은 분리하세요.
특히 1단계에서는 한 화면에서 “업체도 만들고 회원도 만들고 채널도 연결”까지 하면 반드시 복잡해집니다.

정석은:

업체 등록
채널 매핑
회원 등록
입니다.

팁 2
company_id는 가급적 사용자가 직접 고르지 않게 하세요.

SELLER_ADMIN, CHANNEL_ADMIN은 자동 세팅
BUYER_ADMIN만 선택 허용
이렇게 해야 잘못된 소속 저장이 줄어듭니다.

팁 3
DB 제약만 믿지 말고 서비스 로직 검증도 꼭 두세요. 특히 MariaDB에서는 CHECK 제약이 버전/환경 차이를 탈 수 있으니,
역할별 tenant/company/channel 조합 검증은 서버에서 한 번 더 해야 안전합니다.

팁 4
감사로그에는 비밀번호, 계좌번호, 민감정보 원문을 그대로 넣지 마세요. after_json에는 필요한 최소 필드만 저장하는 게 좋습니다.

최종 추천안
제가 추천하는 최종 구조는 이겁니다.

화면
회원 등록 화면은 1개
user_role 선택에 따라 동적 폼 변경
저장
서버에서 역할별 조합 강제
company_id, channel_id는 가능한 한 자동 계산
저장 시 tb_user + tb_company_contact(선택) + tb_audit_log 트랜잭션 처리
운영
SUPER_ADMIN: 전체 생성 가능
SELLER_ADMIN: 자기 테넌트의 판매/채널/구매 사용자 생성 가능
CHANNEL_ADMIN: 자기 채널의 구매업체 사용자 생성 가능
BUYER_ADMIN: 1단계에서는 생성 권한 없음
