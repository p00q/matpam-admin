-- ============================================================
-- [데이터 정리] 구성상품 잘못 저장된 데이터 삭제
-- 대상: 기존 INSERT(4컬럼)로 저장된 불완전한 레코드
-- 기준: SALE_TYPE_CD IS NULL or SALE_TYPE_CD = ''
--        (핵심 필드 미저장 = 구 INSERT 방식으로 등록된 데이터)
-- 실행 전 반드시 SELECT로 대상 건수를 먼저 확인할 것!
-- ============================================================

-- ▶ STEP 1: 삭제 대상 확인 (실행 후 PM 육안 확인)
SELECT
    COMPONENT_PROD_ID,
    COMPONENT_PROD_CODE,
    COMPONENT_PROD_NAME,
    SELLER_MEMBER_ID,
    SALE_TYPE_CD,
    LIST_PRICE,
    VAT_AMOUNT,
    USE_YN,
    DEL_YN,
    REG_DT
FROM tb_component_product
WHERE (SALE_TYPE_CD IS NULL OR SALE_TYPE_CD = '')
   OR (LIST_PRICE = 0 AND VAT_AMOUNT = 0 AND SALE_TYPE_CD IS NULL)
ORDER BY COMPONENT_PROD_ID;


-- ▶ STEP 2: 위 결과 확인 후 실제 삭제 (주석 해제 후 실행)
--
-- DELETE FROM tb_component_product
-- WHERE (SALE_TYPE_CD IS NULL OR SALE_TYPE_CD = '')
--    OR (LIST_PRICE = 0 AND VAT_AMOUNT = 0 AND SALE_TYPE_CD IS NULL);
--
-- COMMIT;
