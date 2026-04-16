# [04_FRONTEND_CHANGES] JSP 점검 및 vatRate 필드 보완

## 작업자: 루미 (Frontend Engineer)
## 작업 일시: 2026-04-15

---

## 점검 대상 JSP 목록

| JSP | Controller 변수 일치 | 이상 여부 |
|---|---|---|
| ComponentProductList.jsp | componentList, paginationInfo, saleTypes, storageTypes, etc. | ✅ 정상 |
| ComponentProductRegister.jsp | component, sellers, saleTypes, storageTypes, etc. | ⚠️ vatRate 필드 누락 → 수정 |
| SalesProductList.jsp | salesProductList, paginationInfo | ✅ 정상 |
| SalesProductRegister.jsp | salesProduct, sellers, saleStatuses, compositionJson | ✅ 정상 |

---

## 변경 파일: ComponentProductRegister.jsp

**경로**: `src/main/webapp/WEB-INF/jsp/admin/product/ComponentProductRegister.jsp`

### 변경 내용
- `form[name="componentForm"]` 내부, `componentProdId` hidden 바로 아래에 `vatRate` hidden input 추가
- 수정 시 DB에 vatRate=0으로 덮어쓰이던 데이터 손실 방지

```jsp
<input type="hidden" name="vatRate" value="<c:out value='${empty component.vatRate ? 0 : component.vatRate}'/>" />
```

---

## 비변경 파일 (검토 후 이상 없음)
- `ComponentProductList.jsp` - 검색 조건 파라미터, 목록 표시 변수 모두 Controller 일치
- `SalesProductList.jsp` - salesProductList 변수명 일치, 페이징 정상
- `SalesProductRegister.jsp` - compositionJson 로딩, 구성상품 테이블 렌더링 정상

WAITING_FOR_QA: 04_FRONTEND_DONE
