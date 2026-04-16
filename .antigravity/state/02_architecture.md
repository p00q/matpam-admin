# [02_ARCHITECTURE] 구성상품/상품판매 CRUD 무결성 복구 설계

## 1. 개요
*   **작성자**: Tech Lead / Architect 강호
*   **선행 승인**: `01_prd.approved.md` 확인
*   **핵심 목표**: 구성상품(ComponentProduct) INSERT/UPDATE Mapper의 치명적 필드 누락을 전수 복구하고, 이와 연동된 판매상품(SalesProduct) 가격 계산 로직을 안정화한다.

---

## 2. 현황 분석 (As-Is) - 근본 원인 진단

### 2-1. tb_component_product INSERT 현황 (치명적 결함)
현재 `insertComponentProduct` 쿼리는 4개 컬럼만 저장 중:
```sql
-- 현재 (심각한 누락)
INSERT INTO tb_component_product (COMPONENT_PROD_CODE, COMPONENT_PROD_NAME, SELLER_MEMBER_ID, REG_DT)
VALUES (...)
```
DB의 `sale_type_cd`, `storage_type_cd`, `unit_type_cd`, `list_price`, `vat_rate`, `VAT_AMOUNT`, `exposure_status_cd`, `sale_status_cd`, `total_sale_qty`, `use_yn` 등이 **NOT NULL** 컬럼임에도 불구하고 INSERT에서 완전히 누락되어 있음.
→ DB 기본값이 없으면 SQL 에러 발생, 기본값이 있더라도 모두 0/''/NULL로 저장되어 데이터 쓰레기화.

### 2-2. tb_component_product UPDATE 현황 (치명적 결함)
현재 `updateComponentProduct` 쿼리도 3개 컬럼만 수정:
```sql
-- 현재 (주요 필드 미반영)
UPDATE tb_component_product SET COMPONENT_PROD_NAME=?, SELLER_MEMBER_ID=?, MOD_DT=NOW() WHERE ...
```

### 2-3. selectNextComponentProdCode 쿼리 누락
`ComponentProductDAO.java`에서 `selectNextComponentProdCode`를 호출하지만, `ComponentProductMapper.xml`에 해당 쿼리 ID가 **존재하지 않음** → 등록 시 NullPointerException 또는 MyBatis 쿼리 실행 오류 발생.

### 2-4. SalesProductMapper.xml의 VAT_AMOUNT 미매핑
`salesProductResultMap`에 `VAT_AMOUNT` 컬럼 매핑이 없음. DB에는 컬럼이 존재하나 ResultMap에서 누락.

---

## 3. 영향도 분석

| 영역 | 영향 |
|---|---|
| 구성상품 등록 | NOT NULL 위반으로 저장 실패하거나 빈 데이터 저장 |
| 구성상품 수정 | 가격/속성 변경이 DB에 반영 안 됨 |
| 코드 자동생성 | `selectNextComponentProdCode` 쿼리 미존재로 등록 불가 |
| 판매상품 가격계산 | VatCalculator가 읽는 구성상품 `listPrice`, `taxType` 이 null → 계산 오류 |
| 판매상품 VAT_AMOUNT | ResultMap 미매핑으로 조회 시 항상 null |

---

## 4. 설계안 (To-Be)

### 4-1. ComponentProductMapper.xml 전면 재작성

#### 추가 쿼리: selectNextComponentProdCode (신규)
```sql
SELECT CONCAT('CP-', LPAD(IFNULL(MAX(CAST(SUBSTRING(component_prod_code, 4) AS UNSIGNED)), 0) + 1, 4, '0'))
FROM tb_component_product
WHERE component_prod_code LIKE 'CP-%'
```

#### INSERT 전면 보완 (18개 컬럼으로 확장)
저장 대상 컬럼:
- `COMPONENT_PROD_CODE`, `COMPONENT_PROD_NAME`, `SELLER_MEMBER_ID`
- `SALE_TYPE_CD`, `STORAGE_TYPE_CD`, `CUT_TYPE_CD`, `PROCESS_TYPE_CD`, `UNIT_TYPE_CD`
- `LIST_PRICE`, `COST_PRICE`, `VAT_RATE`, `VAT_AMOUNT`
- `EXPOSURE_STATUS_CD`, `SALE_STATUS_CD`
- `SALE_START_DT`, `SALE_END_DT`, `TOTAL_SALE_QTY`
- `USE_YN`, `DEL_YN`, `OP_TYPE`, `TAX_TYPE`
- `REG_ID`, `REG_DT`, `MOD_ID`, `MOD_DT`

NOT NULL 컬럼 기본값 처리 (COALESCE):
- `LIST_PRICE`: `COALESCE(#{listPrice}, 0)`
- `VAT_RATE`: `COALESCE(#{vatRate}, 0)`
- `VAT_AMOUNT`: `COALESCE(#{vatAmount}, 0)`
- `TOTAL_SALE_QTY`: `COALESCE(#{totalSaleQty}, 0)`
- `USE_YN`: `COALESCE(#{useYn}, 'Y')`
- `DEL_YN`: `'N'`
- `EXPOSURE_STATUS_CD`: `COALESCE(#{exposureStatusCd}, 'Y')`
- `SALE_STATUS_CD`: `COALESCE(#{saleStatusCd}, 'LIVE')`

#### UPDATE 전면 보완 (동일 컬럼 대상)

### 4-2. SalesProductMapper.xml - VAT_AMOUNT ResultMap 추가
```xml
<result property="vatAmount" column="VAT_AMOUNT"/>
```
→ `salesProductResultMap`에 추가

### 4-3. 변경 파일 목록

| 파일 | 변경 유형 | 변경 이유 |
|---|---|---|
| `ComponentProductMapper.xml` | MODIFY | INSERT/UPDATE 누락 전체 보완, selectNextComponentProdCode 신규 |
| `SalesProductMapper.xml` | MODIFY | salesProductResultMap에 VAT_AMOUNT 매핑 추가 |

---

## 5. API 명세 (변경 없음, 기존 엔드포인트 유지)

| URL | Method | 역할 |
|---|---|---|
| `/admin/product/componentProductList.do` | GET | 구성상품 목록 |
| `/admin/product/componentProductForm.do` | GET | 구성상품 등록/수정 폼 |
| `/admin/product/insertComponentProduct.do` | POST | 구성상품 등록 |
| `/admin/product/updateComponentProduct.do` | POST | 구성상품 수정 |
| `/admin/product/deleteComponentProduct.do` | GET | 구성상품 삭제 |
| `/admin/product/salesProductList.do` | GET | 판매상품 목록 |
| `/admin/product/salesProductRegister.do` | GET/POST | 판매상품 등록/수정 |

---

## 6. JSP → Controller Model 변수명 확정 (현행 유지)

| Model Key | JSP 변수 | 컨트롤러 |
|---|---|---|
| `componentList` | `${componentList}` | `ComponentProductController` |
| `component` | `${component}` | `ComponentProductController` |
| `sellers` | `${sellers}` | 양쪽 Controller |
| `saleTypes`, `saleStatuses`, `storageTypes`, `cutTypes`, `processTypes`, `unitTypes` | `${xxx}` | `ComponentProductController` |
| `salesProduct` | `${salesProduct}` | `SalesProductController` |
| `salesProductList` | `${salesProductList}` | `SalesProductController` |

---

## 7. MyBatis Form Parameter 확정

구성상품 폼 파라미터 (POST):
- `componentProdId`, `componentProdCode`, `componentProdName`, `sellerMemberId`
- `saleTypeCd`, `storageTypeCd`, `cutTypeCd`, `processTypeCd`, `unitTypeCd`
- `listPrice`, `costPrice`, `vatRate`, `vatAmount`
- `exposureStatusCd`, `saleStatusCd`, `saleStartDt`, `saleEndDt`
- `totalSaleQty`, `useYn`, `taxType`

---

## 8. DDL 필요 여부
**DDL 변경 없음.** 현재 `full_schema_audit.txt` 기준 `tb_component_product` 스키마는 정상이며, 애플리케이션 Mapper 코드만 수정하면 됨.

---

## 9. 리스크

| 리스크 | 수준 | 대응 |
|---|---|---|
| 기존 잘못 저장된 데이터 (0/null 값) | 중 | 수정 화면에서 재저장 유도 또는 데이터 보정 스크립트 별도 검토 |
| JSP 폼 필드 누락 시 null 저장 | 중 | COALESCE 기본값으로 방어, ServiceImpl에서 normalizePrices 유지 |

---

## 10. PM 결정 필요 사항
- **없음.** 이번 작업은 확정된 정책 기준 내 기술 구현만 수행함.

WAITING_FOR_APPROVAL: 02_ARCHITECTURE
