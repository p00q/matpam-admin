# [06_RELEASE_NOTE] 구성상품/판매상품 CRUD 무결성 복구 릴리즈

## 작성자: 도희 (Release Manager)
## 작업 일시: 2026-04-15

---

## 1. 현재 상태

| 단계 | 상태 |
|---|---|
| 01 PRD | ✅ 승인 완료 |
| 02 Architecture | ✅ 승인 완료 |
| 03 Backend 구현 | ✅ 완료 |
| 04 Frontend 구현 | ✅ 완료 |
| 05 QA | ✅ 승인 완료 |

---

## 2. 변경 파일 목록

| 파일 | 변경 유형 | 핵심 내용 |
|---|---|---|
| `ComponentProductMapper.xml` | MODIFY | INSERT 4→25컬럼, UPDATE 3→21컬럼, selectNextComponentProdCode 신규 |
| `SalesProductMapper.xml` | MODIFY | salesProductResultMap에 VAT_AMOUNT 매핑 추가 |
| `ComponentProductRegister.jsp` | MODIFY | vatRate hidden input 추가 |
| `cleanup_component_product_bad_data.sql` | NEW | 잘못 저장된 데이터 삭제 스크립트 |

---

## 3. PM 최종 확인 필요

> [!IMPORTANT]
> **데이터 정리 SQL 실행 전 반드시 SELECT 결과를 확인하세요.**
>
> 실행 파일: `src/main/resources/sql/cleanup_component_product_bad_data.sql`
>
> 1. STEP 1 (SELECT)만 먼저 실행 → 삭제 대상 육안 확인
> 2. 삭제할 레코드가 맞으면 STEP 2 (DELETE) 주석 해제 후 실행
> 3. 서버 재기동 후 구성상품 신규 등록 테스트

---

## 4. 배포 체크리스트

- [ ] 데이터 정리 SQL STEP1(SELECT) 실행 → 대상 확인
- [ ] 데이터 정리 SQL STEP2(DELETE) 실행 → COMMIT
- [ ] 서버 재기동 (톰캣 restart)
- [ ] 구성상품 신규 등록 테스트 → DB 25개 컬럼 저장 확인
- [ ] 구성상품 수정 테스트 → vatRate 유지 확인
- [ ] 판매상품 목록 조회 → vatAmount 정상 표시 확인
- [ ] 구성상품 코드 자동생성 확인 (CP-0001 형식)

---

## 5. 롤백 계획

**소요 시간**: 5분 이내
**방법**: git revert 또는 아래 파일 수동 복구

```
이전 상태 복구 대상:
- ComponentProductMapper.xml (INSERT 4컬럼, UPDATE 3컬럼 버전)
- SalesProductMapper.xml (VAT_AMOUNT 속성 제거)
- ComponentProductRegister.jsp (vatRate hidden 제거)
```

> **주의**: DB에서 삭제한 레코드는 복구 불가. 삭제 전 백업 필요 시 SELECT 결과를 CSV로 저장.

---

## 6. 모니터링 포인트

- 구성상품 등록/수정 시 500 에러 발생 여부
- 판매상품 상세 화면에서 VAT 금액 null 표시 여부
- 구성상품 코드 CP-XXXX 중복 여부

---

## 7. Go / No-Go 판정

> [!IMPORTANT]
> 데이터 삭제 SQL 실행 완료 및 서버 재기동 후 기능 테스트 통과 시 **GO**

RELEASE_DECISION: GO
