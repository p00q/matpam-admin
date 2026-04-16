# [03_BACKEND_CHANGES] 구성상품/판매상품 Mapper CRUD 무결성 복구

## 작업자: 강찬 (Backend Engineer)
## 작업 일시: 2026-04-15

---

## 변경 파일 1: ComponentProductMapper.xml

**경로**: `src/main/resources/egovframework/mapper/matpam/product/ComponentProductMapper.xml`

### 변경 내용 요약
| 항목 | 변경 전 | 변경 후 |
|---|---|---|
| INSERT 컬럼 수 | 4개 | 25개 (전체 반영) |
| UPDATE 컬럼 수 | 3개 | 21개 (전체 반영) |
| selectNextComponentProdCode | **쿼리 없음 (런타임 오류)** | CP-XXXX 자동생성 쿼리 추가 |
| WHERE 절 검색 조건 | 6개 | 11개 (type 코드 조건 추가) |

### INSERT 추가 컬럼 목록
- `SALE_TYPE_CD`, `STORAGE_TYPE_CD`, `CUT_TYPE_CD`, `PROCESS_TYPE_CD`, `UNIT_TYPE_CD`
- `LIST_PRICE`, `COST_PRICE`, `VAT_RATE`, `VAT_AMOUNT`
- `EXPOSURE_STATUS_CD`, `SALE_STATUS_CD`
- `SALE_START_DT`, `SALE_END_DT`, `TOTAL_SALE_QTY`
- `USE_YN`, `DEL_YN`, `OP_TYPE`, `TAX_TYPE`
- `REG_ID`, `MOD_ID`, `MOD_DT`

### NOT NULL 컬럼 안전 처리 (COALESCE)
- `LIST_PRICE`, `VAT_RATE`, `VAT_AMOUNT`, `TOTAL_SALE_QTY` → `COALESCE(#{필드}, 0)`
- `USE_YN` → `COALESCE(#{useYn}, 'Y')`
- `DEL_YN` → `'N'` 하드코딩
- `EXPOSURE_STATUS_CD` → `COALESCE(#{exposureStatusCd}, 'Y')`
- `SALE_STATUS_CD` → `COALESCE(#{saleStatusCd}, 'LIVE')`

---

## 변경 파일 2: SalesProductMapper.xml

**경로**: `src/main/resources/egovframework/mapper/matpam/product/SalesProductMapper.xml`

### 변경 내용 요약
- `salesProductResultMap`에 `<result property="vatAmount" column="VAT_AMOUNT"/>` 추가
- DB에 컬럼이 존재하나 ResultMap에서 누락되어 조회 시 항상 null이었던 문제 해결

---

## 비변경 파일 (검토 후 이상 없음)
- `ComponentProductDAO.java` - 기존 메서드 시그니처 유지, 변경 불필요
- `ComponentProductServiceImpl.java` - normalizePrices(), ensureSalePeriod() 로직 유지
- `SalesProductServiceImpl.java` - calculateTotals() VatCalculator 로직 유지
- `ComponentProductController.java` - addComponentDropdowns() 유지

WAITING_FOR_FRONTEND_OR_QA: 03_BACKEND_DONE
