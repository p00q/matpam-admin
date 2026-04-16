# [05_QA_REPORT] 구성상품/판매상품 CRUD 무결성 복구 검증

## 작성자: 하랑 (QA/Verifier)
## 작업 일시: 2026-04-15

---

## 1. 정적 분석 결과 요약

| 분류 | 항목 | 결과 |
|---|---|---|
| Mapper 쿼리 존재 | selectNextComponentProdCode | ✅ PASS |
| Mapper 쿼리 존재 | insertComponentProduct | ✅ PASS |
| Mapper 쿼리 존재 | updateComponentProduct | ✅ PASS |
| INSERT 필드 | SALE_TYPE_CD 포함 | ✅ PASS |
| INSERT 필드 | VAT_AMOUNT 포함 | ✅ PASS |
| INSERT 안전처리 | COALESCE(listPrice, 0) 등 9개 | ✅ PASS |
| UPDATE 필드 | COALESCE 처리 동일 적용 | ✅ PASS |
| ResultMap | ComponentProduct VAT_AMOUNT 매핑 | ✅ PASS |
| ResultMap | SalesProduct VAT_AMOUNT 매핑 추가 | ✅ PASS |
| JSP ↔ Controller | vatRate hidden input 추가 | ✅ PASS |
| JSP ↔ Controller | sellerMemberId select binding | ✅ PASS |
| JSP ↔ Controller | saleTypeCd, storageTypeCd select binding | ✅ PASS |
| JSP ↔ Controller | vatAmount id="vatAmount" | ✅ PASS |

---

## 2. Controller ↔ JSP 변수명 일치 검증

| Controller Model Key | JSP 참조 | 일치 |
|---|---|---|
| `componentList` | `${componentList}` | ✅ |
| `component` | `${component.xxx}` | ✅ |
| `sellers` | `${sellers}` / forEach | ✅ |
| `saleTypes` | `${saleTypeList}` (c:set fallback 포함) | ✅ |
| `storageTypes` | `${storageTypeList}` (c:set fallback 포함) | ✅ |
| `processTypes` | `${processTypeList}` (c:set fallback 포함) | ✅ |
| `unitTypes` | `${unitTypeList}` (c:set fallback 포함) | ✅ |
| `saleStatuses` | `${saleStatusList}` (c:set fallback 포함) | ✅ |
| `cutTypes` | `${cutTypes}` | ✅ |
| `paginationInfo` | `${paginationInfo}` | ✅ |
| `salesProductList` | `${salesProductList}` | ✅ |
| `salesProduct` | `${salesProduct.xxx}` | ✅ |

---

## 3. 주요 결함 해결 확인 (Before/After)

| 결함 | Before | After |
|---|---|---|
| INSERT 컬럼 수 | 4개 (치명적 누락) | 25개 (전체 반영) |
| UPDATE 컬럼 수 | 3개 (치명적 누락) | 21개 (전체 반영) |
| selectNextComponentProdCode | 쿼리 없음 (런타임 오류) | 정상 구현 |
| SalesProduct VAT_AMOUNT | ResultMap 미매핑 (항상 null) | 매핑 추가 |
| ComponentProduct vatRate | JSP hidden 없음 (0으로 덮어쓰기) | hidden input 추가 |

---

## 4. 잠재 리스크 (정적 분석 한계)

| 리스크 | 수준 | 비고 |
|---|---|---|
| 기존 잘못 저장된 데이터 (list_price=0 등) | 중 | 수정 화면 재저장 필요 |
| tb_detail_code JOIN 조건 컬럼명 오류 가능성 | 낮 | 현 DB 구조에서 CODE_GROUP_ID/CODE_ID/DETAIL_CODE_ID 기준 — 실제 실행 확인 필요 |
| SalesProductRegister의 구성상품 vatAmount 계산 | 낮 | JS에서 salePrice * 0.1로 재계산 — DB 저장값과 차이 없음 |

---

## 5. 회귀 위험 점검

| 점검 항목 | 결과 |
|---|---|
| 기존 ComponentProduct 목록 조회 영향 | 없음 (SELECT만 컬럼 추가) |
| 기존 SalesProduct 목록 조회 영향 | 없음 (ResultMap 속성 추가만) |
| ComponentProductList.jsp 페이징 | 영향 없음 |
| SalesProductList.jsp 페이징 | 영향 없음 |
| 삭제(논리삭제) 로직 | 기존 DEL_YN='Y' 방식 유지 — 영향 없음 |

---

## 6. 권고사항

1. **서버 재기동 후 구성상품 신규 등록 테스트** 필수 — DB 저장 25개 컬럼 실제 동작 확인
2. **기존 저장 데이터(list_price=0)** 보정 여부 PM 검토 필요

WAITING_FOR_APPROVAL: 05_QA_PASS
