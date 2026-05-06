
=====================================================================================================
draft 버전이라서 우선 resultType="map" 중심으로 작성했습니다.
컬럼은 대부분 camelCase alias를 붙였기 때문에, 나중에 VO로 바꿔도 비교적 부드럽게 이동됩니다.
namespace는 예시입니다. 실제 Mapper.java 패키지에 맞게 바꾸시면 됩니다.
페이징은 기존 eGov 스타일을 고려해서
firstIndex, recordCountPerPage 파라미터 기준으로 넣었습니다.
=====================================================================================================


PRODUCT_ORDER_FINANCE_MAPPER_DRAFT.xml

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper
    PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="kr.co.matpam.admin.trade.service.impl.ProductOrderFinanceMapper">

    <!-- =========================================================
         공통 SQL
    ========================================================== -->

    <sql id="productBaseColumns">
        p.product_id            AS productId,
        p.tenant_id             AS tenantId,
        p.seller_company_id     AS sellerCompanyId,
        p.product_code          AS productCode,
        p.product_name          AS productName,
        p.item_kind             AS itemKind,
        p.processing_type       AS processingType,
        p.tax_category          AS taxCategory,
        p.unit_name             AS unitName,
        p.independent_sale_yn   AS independentSaleYn,
        p.stock_managed_yn      AS stockManagedYn,
        p.sale_status           AS saleStatus,
        p.description           AS description,
        p.image_url             AS imageUrl,
        p.created_by            AS createdBy,
        p.created_at            AS createdAt,
        p.updated_at            AS updatedAt,
        t.tenant_name           AS tenantName,
        sc.company_name         AS sellerCompanyName
    </sql>

    <sql id="productWhere">
        <where>
            <if test="tenantId != null">
                AND p.tenant_id = #{tenantId}
            </if>
            <if test="sellerCompanyId != null">
                AND p.seller_company_id = #{sellerCompanyId}
            </if>
            <if test="itemKind != null and itemKind != ''">
                AND p.item_kind = #{itemKind}
            </if>
            <if test="processingType != null and processingType != ''">
                AND p.processing_type = #{processingType}
            </if>
            <if test="taxCategory != null and taxCategory != ''">
                AND p.tax_category = #{taxCategory}
            </if>
            <if test="saleStatus != null and saleStatus != ''">
                AND p.sale_status = #{saleStatus}
            </if>
            <if test="stockManagedYn != null and stockManagedYn != ''">
                AND p.stock_managed_yn = #{stockManagedYn}
            </if>
            <if test="searchKeyword != null and searchKeyword != ''">
                AND (
                    p.product_code LIKE CONCAT('%', #{searchKeyword}, '%')
                    OR p.product_name LIKE CONCAT('%', #{searchKeyword}, '%')
                )
            </if>
        </where>
    </sql>

    <sql id="orderBaseColumns">
        o.order_id                   AS orderId,
        o.tenant_id                  AS tenantId,
        o.seller_company_id          AS sellerCompanyId,
        o.buyer_company_id           AS buyerCompanyId,
        o.channel_id                 AS channelId,
        o.order_no                   AS orderNo,
        o.order_status               AS orderStatus,
        o.payment_status             AS paymentStatus,
        o.tax_free_supply_amount     AS taxFreeSupplyAmount,
        o.taxable_supply_amount      AS taxableSupplyAmount,
        o.vat_amount                 AS vatAmount,
        o.total_amount               AS totalAmount,
        o.allocated_advance_amount   AS allocatedAdvanceAmount,
        o.allocated_credit_amount    AS allocatedCreditAmount,
        o.allocated_cash_amount      AS allocatedCashAmount,
        o.ordered_by_user_id         AS orderedByUserId,
        o.ordered_at                 AS orderedAt,
        o.created_at                 AS createdAt,
        o.updated_at                 AS updatedAt,
        t.tenant_name                AS tenantName,
        s.company_name               AS sellerCompanyName,
        b.company_name               AS buyerCompanyName,
        ch.channel_name              AS channelName,
        ch.channel_code              AS channelCode,
        u.user_name                  AS orderedByUserName
    </sql>

    <sql id="orderWhere">
        <where>
            <if test="tenantId != null">
                AND o.tenant_id = #{tenantId}
            </if>
            <if test="sellerCompanyId != null">
                AND o.seller_company_id = #{sellerCompanyId}
            </if>
            <if test="buyerCompanyId != null">
                AND o.buyer_company_id = #{buyerCompanyId}
            </if>
            <if test="channelId != null">
                AND o.channel_id = #{channelId}
            </if>
            <if test="orderStatus != null and orderStatus != ''">
                AND o.order_status = #{orderStatus}
            </if>
            <if test="paymentStatus != null and paymentStatus != ''">
                AND o.payment_status = #{paymentStatus}
            </if>
            <if test="dateFrom != null and dateFrom != ''">
                AND o.ordered_at <![CDATA[>=]]> CONCAT(#{dateFrom}, ' 00:00:00')
            </if>
            <if test="dateTo != null and dateTo != ''">
                AND o.ordered_at <![CDATA[<=]]> CONCAT(#{dateTo}, ' 23:59:59')
            </if>
            <if test="searchKeyword != null and searchKeyword != ''">
                AND (
                    o.order_no LIKE CONCAT('%', #{searchKeyword}, '%')
                    OR b.company_name LIKE CONCAT('%', #{searchKeyword}, '%')
                )
            </if>
        </where>
    </sql>

    <sql id="settlementBaseColumns">
        s.settlement_id        AS settlementId,
        s.tenant_id            AS tenantId,
        s.seller_company_id    AS sellerCompanyId,
        s.buyer_company_id     AS buyerCompanyId,
        s.period_from          AS periodFrom,
        s.period_to            AS periodTo,
        s.opening_balance      AS openingBalance,
        s.sales_amount         AS salesAmount,
        s.vat_amount           AS vatAmount,
        s.received_amount      AS receivedAmount,
        s.credit_used_amount   AS creditUsedAmount,
        s.closing_balance      AS closingBalance,
        s.settlement_status    AS settlementStatus,
        s.closed_at            AS closedAt,
        s.closed_by            AS closedBy,
        t.tenant_name          AS tenantName,
        sc.company_name        AS sellerCompanyName,
        bc.company_name        AS buyerCompanyName,
        u.user_name            AS closedByUserName
    </sql>


    <!-- =========================================================
         1. 상품
    ========================================================== -->

    <select id="selectProductList" resultType="map">
        SELECT
            <include refid="productBaseColumns"/>
        FROM tb_product p
        INNER JOIN tb_tenant t
            ON p.tenant_id = t.tenant_id
        INNER JOIN tb_company sc
            ON p.seller_company_id = sc.company_id
        <include refid="productWhere"/>
        ORDER BY p.created_at DESC, p.product_id DESC
        <if test="recordCountPerPage != null and recordCountPerPage > 0">
            LIMIT #{firstIndex}, #{recordCountPerPage}
        </if>
    </select>

    <select id="selectProductListTotCnt" resultType="int">
        SELECT COUNT(1)
        FROM tb_product p
        INNER JOIN tb_tenant t
            ON p.tenant_id = t.tenant_id
        INNER JOIN tb_company sc
            ON p.seller_company_id = sc.company_id
        <include refid="productWhere"/>
    </select>

    <select id="selectProductDetail" resultType="map">
        SELECT
            <include refid="productBaseColumns"/>
        FROM tb_product p
        INNER JOIN tb_tenant t
            ON p.tenant_id = t.tenant_id
        INNER JOIN tb_company sc
            ON p.seller_company_id = sc.company_id
        WHERE p.product_id = #{productId}
    </select>

    <select id="selectProductsForOrder" resultType="map">
        SELECT
            p.product_id          AS productId,
            p.tenant_id           AS tenantId,
            p.seller_company_id   AS sellerCompanyId,
            p.product_code        AS productCode,
            p.product_name        AS productName,
            p.item_kind           AS itemKind,
            p.processing_type     AS processingType,
            p.tax_category        AS taxCategory,
            p.unit_name           AS unitName,
            p.stock_managed_yn    AS stockManagedYn,
            p.sale_status         AS saleStatus
        FROM tb_product p
        WHERE p.sale_status = 'ON_SALE'
          AND p.product_id IN
            <foreach collection="productIdList" item="productId" open="(" separator="," close=")">
                #{productId}
            </foreach>
        ORDER BY p.product_id ASC
    </select>

    <insert id="insertProduct" useGeneratedKeys="true" keyProperty="productId">
        INSERT INTO tb_product (
            tenant_id,
            seller_company_id,
            product_code,
            product_name,
            item_kind,
            processing_type,
            tax_category,
            unit_name,
            independent_sale_yn,
            stock_managed_yn,
            sale_status,
            description,
            image_url,
            created_by,
            created_at,
            updated_at
        ) VALUES (
            #{tenantId},
            #{sellerCompanyId},
            #{productCode},
            #{productName},
            #{itemKind},
            #{processingType},
            #{taxCategory},
            #{unitName},
            #{independentSaleYn},
            #{stockManagedYn},
            #{saleStatus},
            #{description},
            #{imageUrl},
            #{createdBy},
            NOW(),
            NOW()
        )
    </insert>

    <update id="updateProduct">
        UPDATE tb_product
           SET product_name         = #{productName},
               item_kind            = #{itemKind},
               processing_type      = #{processingType},
               tax_category         = #{taxCategory},
               unit_name            = #{unitName},
               independent_sale_yn  = #{independentSaleYn},
               stock_managed_yn     = #{stockManagedYn},
               sale_status          = #{saleStatus},
               description          = #{description},
               image_url            = #{imageUrl},
               updated_at           = NOW()
         WHERE product_id = #{productId}
    </update>

    <update id="updateProductSaleStatus">
        UPDATE tb_product
           SET sale_status = #{saleStatus},
               updated_at  = NOW()
         WHERE product_id = #{productId}
    </update>


    <!-- =========================================================
         2. 상품 세금 규칙
    ========================================================== -->

    <select id="selectNextTaxRuleVersion" resultType="int">
        SELECT COALESCE(MAX(rule_version), 0) + 1
          FROM tb_product_tax_rule
         WHERE product_id = #{productId}
    </select>

    <select id="selectCurrentApprovedTaxRule" resultType="map">
        SELECT
            tax_rule_id        AS taxRuleId,
            product_id         AS productId,
            rule_version       AS ruleVersion,
            tax_category       AS taxCategory,
            legal_basis_memo   AS legalBasisMemo,
            effective_from     AS effectiveFrom,
            effective_to       AS effectiveTo,
            approval_status    AS approvalStatus,
            requested_by       AS requestedBy,
            approved_by        AS approvedBy,
            approved_at        AS approvedAt,
            created_at         AS createdAt
        FROM tb_product_tax_rule
        WHERE product_id = #{productId}
          AND approval_status = 'APPROVED'
          AND effective_from <![CDATA[<=]]> NOW()
          AND (effective_to IS NULL OR effective_to <![CDATA[>]]> NOW())
        ORDER BY effective_from DESC, rule_version DESC, tax_rule_id DESC
        LIMIT 1
    </select>

    <select id="selectApprovedTaxRulesByProductIds" resultType="map">
        SELECT t1.*
        FROM (
            SELECT
                r.tax_rule_id        AS taxRuleId,
                r.product_id         AS productId,
                r.rule_version       AS ruleVersion,
                r.tax_category       AS taxCategory,
                r.legal_basis_memo   AS legalBasisMemo,
                r.effective_from     AS effectiveFrom,
                r.effective_to       AS effectiveTo,
                r.approval_status    AS approvalStatus,
                ROW_NUMBER() OVER (
                    PARTITION BY r.product_id
                    ORDER BY r.effective_from DESC, r.rule_version DESC, r.tax_rule_id DESC
                ) AS rn
            FROM tb_product_tax_rule r
            WHERE r.approval_status = 'APPROVED'
              AND r.effective_from <![CDATA[<=]]> NOW()
              AND (r.effective_to IS NULL OR r.effective_to <![CDATA[>]]> NOW())
              AND r.product_id IN
                <foreach collection="productIdList" item="productId" open="(" separator="," close=")">
                    #{productId}
                </foreach>
        ) t1
        WHERE t1.rn = 1
        ORDER BY t1.productId
    </select>

    <select id="selectProductTaxRuleHistory" resultType="map">
        SELECT
            r.tax_rule_id        AS taxRuleId,
            r.product_id         AS productId,
            r.rule_version       AS ruleVersion,
            r.tax_category       AS taxCategory,
            r.legal_basis_memo   AS legalBasisMemo,
            r.effective_from     AS effectiveFrom,
            r.effective_to       AS effectiveTo,
            r.approval_status    AS approvalStatus,
            r.requested_by       AS requestedBy,
            rq.user_name         AS requestedByUserName,
            r.approved_by        AS approvedBy,
            ap.user_name         AS approvedByUserName,
            r.approved_at        AS approvedAt,
            r.created_at         AS createdAt
        FROM tb_product_tax_rule r
        LEFT JOIN tb_user rq
            ON r.requested_by = rq.user_id
        LEFT JOIN tb_user ap
            ON r.approved_by = ap.user_id
        WHERE r.product_id = #{productId}
        ORDER BY r.rule_version DESC, r.tax_rule_id DESC
    </select>

    <insert id="insertProductTaxRule" useGeneratedKeys="true" keyProperty="taxRuleId">
        INSERT INTO tb_product_tax_rule (
            product_id,
            rule_version,
            tax_category,
            legal_basis_memo,
            effective_from,
            effective_to,
            approval_status,
            requested_by,
            approved_by,
            approved_at,
            created_at
        ) VALUES (
            #{productId},
            #{ruleVersion},
            #{taxCategory},
            #{legalBasisMemo},
            #{effectiveFrom},
            #{effectiveTo},
            #{approvalStatus},
            #{requestedBy},
            #{approvedBy},
            #{approvedAt},
            NOW()
        )
    </insert>

    <update id="approveProductTaxRule">
        UPDATE tb_product_tax_rule
           SET approval_status = 'APPROVED',
               approved_by     = #{approvedBy},
               approved_at     = NOW()
         WHERE tax_rule_id = #{taxRuleId}
    </update>

    <update id="rejectProductTaxRule">
        UPDATE tb_product_tax_rule
           SET approval_status = 'REJECTED',
               approved_by     = #{approvedBy},
               approved_at     = NOW()
         WHERE tax_rule_id = #{taxRuleId}
    </update>

    <update id="syncProductTaxCategoryByApprovedRule">
        UPDATE tb_product p
        INNER JOIN tb_product_tax_rule r
            ON p.product_id = r.product_id
           SET p.tax_category = r.tax_category,
               p.updated_at   = NOW()
         WHERE r.tax_rule_id = #{taxRuleId}
    </update>


    <!-- =========================================================
         3. 상품 연관 관계
    ========================================================== -->

    <select id="selectRelatedProductList" resultType="map">
        SELECT
            r.relation_id          AS relationId,
            r.base_product_id      AS baseProductId,
            r.related_product_id   AS relatedProductId,
            r.relation_kind        AS relationKind,
            r.bundle_mode          AS bundleMode,
            r.sort_order           AS sortOrder,
            r.effective_from       AS effectiveFrom,
            r.effective_to         AS effectiveTo,
            r.status               AS status,
            r.created_by           AS createdBy,
            r.created_at           AS createdAt,
            bp.product_code        AS baseProductCode,
            bp.product_name        AS baseProductName,
            rp.product_code        AS relatedProductCode,
            rp.product_name        AS relatedProductName,
            rp.processing_type     AS relatedProcessingType,
            rp.tax_category        AS relatedTaxCategory
        FROM tb_product_relation r
        INNER JOIN tb_product bp
            ON r.base_product_id = bp.product_id
        INNER JOIN tb_product rp
            ON r.related_product_id = rp.product_id
        WHERE r.base_product_id = #{baseProductId}
          <if test="status != null and status != ''">
            AND r.status = #{status}
          </if>
        ORDER BY r.sort_order ASC, r.relation_id ASC
    </select>

    <insert id="insertProductRelation" useGeneratedKeys="true" keyProperty="relationId">
        INSERT INTO tb_product_relation (
            base_product_id,
            related_product_id,
            relation_kind,
            bundle_mode,
            sort_order,
            effective_from,
            effective_to,
            status,
            created_by,
            created_at
        ) VALUES (
            #{baseProductId},
            #{relatedProductId},
            #{relationKind},
            #{bundleMode},
            #{sortOrder},
            #{effectiveFrom},
            #{effectiveTo},
            #{status},
            #{createdBy},
            NOW()
        )
    </insert>

    <update id="updateProductRelationStatus">
        UPDATE tb_product_relation
           SET status = #{status}
         WHERE relation_id = #{relationId}
    </update>


    <!-- =========================================================
         4. 상품 가격
    ========================================================== -->

    <select id="selectProductPriceList" resultType="map">
        SELECT
            pp.price_id            AS priceId,
            pp.product_id          AS productId,
            pp.tenant_id           AS tenantId,
            pp.channel_id          AS channelId,
            pp.buyer_company_id    AS buyerCompanyId,
            pp.unit_price          AS unitPrice,
            pp.currency_code       AS currencyCode,
            pp.effective_from      AS effectiveFrom,
            pp.effective_to        AS effectiveTo,
            pp.status              AS status,
            pp.approved_by         AS approvedBy,
            pp.created_at          AS createdAt,
            ch.channel_name        AS channelName,
            bc.company_name        AS buyerCompanyName
        FROM tb_product_price pp
        LEFT JOIN tb_channel ch
            ON pp.channel_id = ch.channel_id
        LEFT JOIN tb_company bc
            ON pp.buyer_company_id = bc.company_id
        WHERE pp.product_id = #{productId}
        ORDER BY pp.effective_from DESC, pp.price_id DESC
    </select>

    <select id="selectApplicablePrice" resultType="map">
        SELECT
            pp.price_id          AS priceId,
            pp.product_id        AS productId,
            pp.unit_price        AS unitPrice,
            pp.currency_code     AS currencyCode,
            pp.tenant_id         AS tenantId,
            pp.channel_id        AS channelId,
            pp.buyer_company_id  AS buyerCompanyId,
            pp.effective_from    AS effectiveFrom,
            pp.effective_to      AS effectiveTo
        FROM tb_product_price pp
        WHERE pp.product_id = #{productId}
          AND pp.tenant_id = #{tenantId}
          AND pp.status = 'ACTIVE'
          AND pp.effective_from <![CDATA[<=]]> NOW()
          AND (pp.effective_to IS NULL OR pp.effective_to <![CDATA[>]]> NOW())
          AND (
                (#{buyerCompanyId} IS NOT NULL AND pp.buyer_company_id = #{buyerCompanyId})
                OR
                (#{channelId} IS NOT NULL AND pp.buyer_company_id IS NULL AND pp.channel_id = #{channelId})
                OR
                (pp.buyer_company_id IS NULL AND pp.channel_id IS NULL)
              )
        ORDER BY
            CASE
                WHEN pp.buyer_company_id IS NOT NULL THEN 1
                WHEN pp.channel_id IS NOT NULL THEN 2
                ELSE 3
            END ASC,
            pp.effective_from DESC,
            pp.price_id DESC
        LIMIT 1
    </select>

    <insert id="insertProductPrice" useGeneratedKeys="true" keyProperty="priceId">
        INSERT INTO tb_product_price (
            product_id,
            tenant_id,
            channel_id,
            buyer_company_id,
            unit_price,
            currency_code,
            effective_from,
            effective_to,
            status,
            approved_by,
            created_at
        ) VALUES (
            #{productId},
            #{tenantId},
            #{channelId},
            #{buyerCompanyId},
            #{unitPrice},
            #{currencyCode},
            #{effectiveFrom},
            #{effectiveTo},
            #{status},
            #{approvedBy},
            NOW()
        )
    </insert>

    <update id="updateProductPriceStatus">
        UPDATE tb_product_price
           SET status = #{status}
         WHERE price_id = #{priceId}
    </update>


    <!-- =========================================================
         5. 가공 레시피
    ========================================================== -->

    <select id="selectProcessRecipeBySourceTarget" resultType="map">
        SELECT
            recipe_id             AS recipeId,
            source_product_id     AS sourceProductId,
            target_product_id     AS targetProductId,
            standard_input_qty    AS standardInputQty,
            standard_output_qty   AS standardOutputQty,
            loss_rate             AS lossRate,
            memo                  AS memo,
            status                AS status
        FROM tb_product_process_recipe
        WHERE source_product_id = #{sourceProductId}
          AND target_product_id = #{targetProductId}
    </select>

    <select id="selectProcessRecipeListBySourceProduct" resultType="map">
        SELECT
            r.recipe_id              AS recipeId,
            r.source_product_id      AS sourceProductId,
            r.target_product_id      AS targetProductId,
            r.standard_input_qty     AS standardInputQty,
            r.standard_output_qty    AS standardOutputQty,
            r.loss_rate              AS lossRate,
            r.memo                   AS memo,
            r.status                 AS status,
            tp.product_name          AS targetProductName,
            tp.product_code          AS targetProductCode
        FROM tb_product_process_recipe r
        INNER JOIN tb_product tp
            ON r.target_product_id = tp.product_id
        WHERE r.source_product_id = #{sourceProductId}
        ORDER BY r.recipe_id DESC
    </select>

    <insert id="insertProductProcessRecipe" useGeneratedKeys="true" keyProperty="recipeId">
        INSERT INTO tb_product_process_recipe (
            source_product_id,
            target_product_id,
            standard_input_qty,
            standard_output_qty,
            loss_rate,
            memo,
            status
        ) VALUES (
            #{sourceProductId},
            #{targetProductId},
            #{standardInputQty},
            #{standardOutputQty},
            #{lossRate},
            #{memo},
            #{status}
        )
    </insert>


    <!-- =========================================================
         6. 주문
    ========================================================== -->

    <select id="selectOrderList" resultType="map">
        SELECT
            <include refid="orderBaseColumns"/>
        FROM tb_order o
        INNER JOIN tb_tenant t
            ON o.tenant_id = t.tenant_id
        INNER JOIN tb_company s
            ON o.seller_company_id = s.company_id
        INNER JOIN tb_company b
            ON o.buyer_company_id = b.company_id
        LEFT JOIN tb_channel ch
            ON o.channel_id = ch.channel_id
        LEFT JOIN tb_user u
            ON o.ordered_by_user_id = u.user_id
        <include refid="orderWhere"/>
        ORDER BY o.ordered_at DESC, o.order_id DESC
        <if test="recordCountPerPage != null and recordCountPerPage > 0">
            LIMIT #{firstIndex}, #{recordCountPerPage}
        </if>
    </select>

    <select id="selectOrderListTotCnt" resultType="int">
        SELECT COUNT(1)
        FROM tb_order o
        INNER JOIN tb_tenant t
            ON o.tenant_id = t.tenant_id
        INNER JOIN tb_company s
            ON o.seller_company_id = s.company_id
        INNER JOIN tb_company b
            ON o.buyer_company_id = b.company_id
        LEFT JOIN tb_channel ch
            ON o.channel_id = ch.channel_id
        LEFT JOIN tb_user u
            ON o.ordered_by_user_id = u.user_id
        <include refid="orderWhere"/>
    </select>

    <select id="selectOrderDetail" resultType="map">
        SELECT
            <include refid="orderBaseColumns"/>
        FROM tb_order o
        INNER JOIN tb_tenant t
            ON o.tenant_id = t.tenant_id
        INNER JOIN tb_company s
            ON o.seller_company_id = s.company_id
        INNER JOIN tb_company b
            ON o.buyer_company_id = b.company_id
        LEFT JOIN tb_channel ch
            ON o.channel_id = ch.channel_id
        LEFT JOIN tb_user u
            ON o.ordered_by_user_id = u.user_id
        WHERE o.order_id = #{orderId}
    </select>

    <select id="selectOrderLinesByOrderId" resultType="map">
        SELECT
            l.order_line_id              AS orderLineId,
            l.order_id                   AS orderId,
            l.line_no                    AS lineNo,
            l.product_id                 AS productId,
            l.relation_group_id          AS relationGroupId,
            l.product_name_snapshot      AS productNameSnapshot,
            l.item_kind_snapshot         AS itemKindSnapshot,
            l.processing_type_snapshot   AS processingTypeSnapshot,
            l.tax_category_snapshot      AS taxCategorySnapshot,
            l.tax_rule_id_snapshot       AS taxRuleIdSnapshot,
            l.unit_name_snapshot         AS unitNameSnapshot,
            l.qty                        AS qty,
            l.unit_price                 AS unitPrice,
            l.supply_amount              AS supplyAmount,
            l.vat_amount                 AS vatAmount,
            l.total_amount               AS totalAmount,
            l.shipment_status            AS shipmentStatus,
            l.created_at                 AS createdAt
        FROM tb_order_line l
        WHERE l.order_id = #{orderId}
        ORDER BY l.line_no ASC
    </select>

    <insert id="insertOrder" useGeneratedKeys="true" keyProperty="orderId">
        INSERT INTO tb_order (
            tenant_id,
            seller_company_id,
            buyer_company_id,
            channel_id,
            order_no,
            order_status,
            payment_status,
            tax_free_supply_amount,
            taxable_supply_amount,
            vat_amount,
            total_amount,
            allocated_advance_amount,
            allocated_credit_amount,
            allocated_cash_amount,
            ordered_by_user_id,
            ordered_at,
            created_at,
            updated_at
        ) VALUES (
            #{tenantId},
            #{sellerCompanyId},
            #{buyerCompanyId},
            #{channelId},
            #{orderNo},
            #{orderStatus},
            #{paymentStatus},
            #{taxFreeSupplyAmount},
            #{taxableSupplyAmount},
            #{vatAmount},
            #{totalAmount},
            #{allocatedAdvanceAmount},
            #{allocatedCreditAmount},
            #{allocatedCashAmount},
            #{orderedByUserId},
            #{orderedAt},
            NOW(),
            NOW()
        )
    </insert>

    <insert id="insertOrderLine" useGeneratedKeys="true" keyProperty="orderLineId">
        INSERT INTO tb_order_line (
            order_id,
            line_no,
            product_id,
            relation_group_id,
            product_name_snapshot,
            item_kind_snapshot,
            processing_type_snapshot,
            tax_category_snapshot,
            tax_rule_id_snapshot,
            unit_name_snapshot,
            qty,
            unit_price,
            supply_amount,
            vat_amount,
            total_amount,
            shipment_status,
            created_at
        ) VALUES (
            #{orderId},
            #{lineNo},
            #{productId},
            #{relationGroupId},
            #{productNameSnapshot},
            #{itemKindSnapshot},
            #{processingTypeSnapshot},
            #{taxCategorySnapshot},
            #{taxRuleIdSnapshot},
            #{unitNameSnapshot},
            #{qty},
            #{unitPrice},
            #{supplyAmount},
            #{vatAmount},
            #{totalAmount},
            #{shipmentStatus},
            NOW()
        )
    </insert>

    <update id="updateOrderStatus">
        UPDATE tb_order
           SET order_status = #{orderStatus},
               updated_at   = NOW()
         WHERE order_id = #{orderId}
    </update>

    <update id="updateOrderPaymentSummary">
        UPDATE tb_order
           SET payment_status           = #{paymentStatus},
               allocated_advance_amount = #{allocatedAdvanceAmount},
               allocated_credit_amount  = #{allocatedCreditAmount},
               allocated_cash_amount    = #{allocatedCashAmount},
               updated_at               = NOW()
         WHERE order_id = #{orderId}
    </update>


    <!-- =========================================================
         7. 세금문서
    ========================================================== -->

    <insert id="insertTaxDocumentsByOrderId">
        INSERT INTO tb_tax_document (
            order_id,
            buyer_company_id,
            seller_company_id,
            document_type,
            tax_category,
            issue_status,
            supply_amount,
            vat_amount,
            total_amount,
            created_at
        )
        SELECT
            o.order_id,
            o.buyer_company_id,
            o.seller_company_id,
            CASE
                WHEN l.tax_category_snapshot = 'TAXABLE' THEN 'TAX_INVOICE'
                ELSE 'INVOICE'
            END AS document_type,
            l.tax_category_snapshot,
            'READY' AS issue_status,
            SUM(l.supply_amount) AS supply_amount,
            SUM(l.vat_amount)    AS vat_amount,
            SUM(l.total_amount)  AS total_amount,
            NOW()
        FROM tb_order o
        INNER JOIN tb_order_line l
            ON o.order_id = l.order_id
        WHERE o.order_id = #{orderId}
        GROUP BY
            o.order_id,
            o.buyer_company_id,
            o.seller_company_id,
            l.tax_category_snapshot
    </insert>

    <select id="selectTaxDocumentsByOrderId" resultType="map">
        SELECT
            tax_document_id   AS taxDocumentId,
            order_id          AS orderId,
            buyer_company_id  AS buyerCompanyId,
            seller_company_id AS sellerCompanyId,
            document_type     AS documentType,
            tax_category      AS taxCategory,
            document_no       AS documentNo,
            issue_status      AS issueStatus,
            supply_amount     AS supplyAmount,
            vat_amount        AS vatAmount,
            total_amount      AS totalAmount,
            issued_at         AS issuedAt,
            created_at        AS createdAt
        FROM tb_tax_document
        WHERE order_id = #{orderId}
        ORDER BY tax_document_id ASC
    </select>

    <update id="updateTaxDocumentIssueResult">
        UPDATE tb_tax_document
           SET document_no  = #{documentNo},
               issue_status = #{issueStatus},
               issued_at    = #{issuedAt}
         WHERE tax_document_id = #{taxDocumentId}
    </update>


    <!-- =========================================================
         8. 출고
    ========================================================== -->

    <insert id="insertShipment" useGeneratedKeys="true" keyProperty="shipmentId">
        INSERT INTO tb_shipment (
            tenant_id,
            order_id,
            shipment_no,
            shipment_status,
            shipping_company,
            tracking_no,
            shipped_at,
            created_by,
            created_at
        ) VALUES (
            #{tenantId},
            #{orderId},
            #{shipmentNo},
            #{shipmentStatus},
            #{shippingCompany},
            #{trackingNo},
            #{shippedAt},
            #{createdBy},
            NOW()
        )
    </insert>

    <insert id="insertShipmentLine" useGeneratedKeys="true" keyProperty="shipmentLineId">
        INSERT INTO tb_shipment_line (
            shipment_id,
            order_line_id,
            product_id,
            lot_id,
            shipped_qty,
            created_at
        ) VALUES (
            #{shipmentId},
            #{orderLineId},
            #{productId},
            #{lotId},
            #{shippedQty},
            NOW()
        )
    </insert>

    <select id="selectShipmentListByOrderId" resultType="map">
        SELECT
            s.shipment_id        AS shipmentId,
            s.tenant_id          AS tenantId,
            s.order_id           AS orderId,
            s.shipment_no        AS shipmentNo,
            s.shipment_status    AS shipmentStatus,
            s.shipping_company   AS shippingCompany,
            s.tracking_no        AS trackingNo,
            s.shipped_at         AS shippedAt,
            s.created_by         AS createdBy,
            s.created_at         AS createdAt,
            u.user_name          AS createdByUserName
        FROM tb_shipment s
        LEFT JOIN tb_user u
            ON s.created_by = u.user_id
        WHERE s.order_id = #{orderId}
        ORDER BY s.shipment_id DESC
    </select>

    <select id="selectShipmentLinesByShipmentId" resultType="map">
        SELECT
            sl.shipment_line_id        AS shipmentLineId,
            sl.shipment_id             AS shipmentId,
            sl.order_line_id           AS orderLineId,
            sl.product_id              AS productId,
            sl.lot_id                  AS lotId,
            sl.shipped_qty             AS shippedQty,
            sl.created_at              AS createdAt,
            ol.line_no                 AS lineNo,
            ol.product_name_snapshot   AS productNameSnapshot,
            lot.lot_no                 AS lotNo
        FROM tb_shipment_line sl
        INNER JOIN tb_order_line ol
            ON sl.order_line_id = ol.order_line_id
        LEFT JOIN tb_stock_lot lot
            ON sl.lot_id = lot.lot_id
        WHERE sl.shipment_id = #{shipmentId}
        ORDER BY sl.shipment_line_id ASC
    </select>

    <update id="updateShipmentStatus">
        UPDATE tb_shipment
           SET shipment_status = #{shipmentStatus},
               shipped_at      = #{shippedAt}
         WHERE shipment_id = #{shipmentId}
    </update>

    <update id="updateOrderLineShipmentStatus">
        UPDATE tb_order_line
           SET shipment_status = #{shipmentStatus}
         WHERE order_line_id = #{orderLineId}
    </update>


    <!-- =========================================================
         9. 재고 LOT / 재고원장 / 가공배치
    ========================================================== -->

    <insert id="insertStockLot" useGeneratedKeys="true" keyProperty="lotId">
        INSERT INTO tb_stock_lot (
            tenant_id,
            product_id,
            lot_no,
            manufacture_date,
            expiry_date,
            current_qty,
            status,
            created_at
        ) VALUES (
            #{tenantId},
            #{productId},
            #{lotNo},
            #{manufactureDate},
            #{expiryDate},
            #{currentQty},
            #{status},
            NOW()
        )
    </insert>

    <select id="selectAvailableLotsByProduct" resultType="map">
        SELECT
            lot_id             AS lotId,
            tenant_id          AS tenantId,
            product_id         AS productId,
            lot_no             AS lotNo,
            manufacture_date   AS manufactureDate,
            expiry_date        AS expiryDate,
            current_qty        AS currentQty,
            status             AS status,
            created_at         AS createdAt
        FROM tb_stock_lot
        WHERE product_id = #{productId}
          AND status = 'ACTIVE'
          AND current_qty <![CDATA[>]]> 0
        ORDER BY manufacture_date ASC, lot_id ASC
    </select>

    <update id="updateStockLotCurrentQty">
        UPDATE tb_stock_lot
           SET current_qty = #{currentQty},
               status = CASE WHEN #{currentQty} <![CDATA[<=]]> 0 THEN 'CLOSED' ELSE status END
         WHERE lot_id = #{lotId}
    </update>

    <insert id="insertStockLedger" useGeneratedKeys="true" keyProperty="stockTxnId">
        INSERT INTO tb_stock_ledger (
            tenant_id,
            product_id,
            lot_id,
            txn_type,
            qty,
            ref_table,
            ref_id,
            memo,
            txn_at,
            created_by
        ) VALUES (
            #{tenantId},
            #{productId},
            #{lotId},
            #{txnType},
            #{qty},
            #{refTable},
            #{refId},
            #{memo},
            #{txnAt},
            #{createdBy}
        )
    </insert>

    <select id="selectStockLedgerByRef" resultType="map">
        SELECT
            stock_txn_id    AS stockTxnId,
            tenant_id       AS tenantId,
            product_id      AS productId,
            lot_id          AS lotId,
            txn_type        AS txnType,
            qty             AS qty,
            ref_table       AS refTable,
            ref_id          AS refId,
            memo            AS memo,
            txn_at          AS txnAt,
            created_by      AS createdBy
        FROM tb_stock_ledger
        WHERE ref_table = #{refTable}
          AND ref_id = #{refId}
        ORDER BY stock_txn_id ASC
    </select>

    <insert id="insertProcessBatch" useGeneratedKeys="true" keyProperty="processBatchId">
        INSERT INTO tb_process_batch (
            tenant_id,
            seller_company_id,
            source_product_id,
            target_product_id,
            input_qty,
            output_qty,
            loss_qty,
            processed_at,
            processed_by,
            memo
        ) VALUES (
            #{tenantId},
            #{sellerCompanyId},
            #{sourceProductId},
            #{targetProductId},
            #{inputQty},
            #{outputQty},
            #{lossQty},
            #{processedAt},
            #{processedBy},
            #{memo}
        )
    </insert>

    <select id="selectProcessBatchList" resultType="map">
        SELECT
            pb.process_batch_id     AS processBatchId,
            pb.tenant_id            AS tenantId,
            pb.seller_company_id    AS sellerCompanyId,
            pb.source_product_id    AS sourceProductId,
            pb.target_product_id    AS targetProductId,
            pb.input_qty            AS inputQty,
            pb.output_qty           AS outputQty,
            pb.loss_qty             AS lossQty,
            pb.processed_at         AS processedAt,
            pb.processed_by         AS processedBy,
            pb.memo                 AS memo,
            sp.product_name         AS sourceProductName,
            tp.product_name         AS targetProductName,
            u.user_name             AS processedByUserName
        FROM tb_process_batch pb
        INNER JOIN tb_product sp
            ON pb.source_product_id = sp.product_id
        INNER JOIN tb_product tp
            ON pb.target_product_id = tp.product_id
        LEFT JOIN tb_user u
            ON pb.processed_by = u.user_id
        WHERE pb.tenant_id = #{tenantId}
          <if test="sellerCompanyId != null">
            AND pb.seller_company_id = #{sellerCompanyId}
          </if>
          <if test="dateFrom != null and dateFrom != ''">
            AND pb.processed_at <![CDATA[>=]]> CONCAT(#{dateFrom}, ' 00:00:00')
          </if>
          <if test="dateTo != null and dateTo != ''">
            AND pb.processed_at <![CDATA[<=]]> CONCAT(#{dateTo}, ' 23:59:59')
          </if>
        ORDER BY pb.processed_at DESC, pb.process_batch_id DESC
    </select>


    <!-- =========================================================
         10. 여신 정책 / 여신 원장
    ========================================================== -->

    <select id="selectCreditPolicy" resultType="map">
        SELECT
            p.credit_policy_id      AS creditPolicyId,
            p.tenant_id             AS tenantId,
            p.seller_company_id     AS sellerCompanyId,
            p.buyer_company_id      AS buyerCompanyId,
            p.credit_limit_amount   AS creditLimitAmount,
            p.payment_terms_days    AS paymentTermsDays,
            p.status                AS status,
            p.approved_by           AS approvedBy,
            p.approved_at           AS approvedAt,
            p.created_at            AS createdAt,
            p.updated_at            AS updatedAt,
            sc.company_name         AS sellerCompanyName,
            bc.company_name         AS buyerCompanyName
        FROM tb_buyer_credit_policy p
        INNER JOIN tb_company sc
            ON p.seller_company_id = sc.company_id
        INNER JOIN tb_company bc
            ON p.buyer_company_id = bc.company_id
        WHERE p.tenant_id = #{tenantId}
          AND p.seller_company_id = #{sellerCompanyId}
          AND p.buyer_company_id = #{buyerCompanyId}
    </select>

    <insert id="insertBuyerCreditPolicy" useGeneratedKeys="true" keyProperty="creditPolicyId">
        INSERT INTO tb_buyer_credit_policy (
            tenant_id,
            seller_company_id,
            buyer_company_id,
            credit_limit_amount,
            payment_terms_days,
            status,
            approved_by,
            approved_at,
            created_at,
            updated_at
        ) VALUES (
            #{tenantId},
            #{sellerCompanyId},
            #{buyerCompanyId},
            #{creditLimitAmount},
            #{paymentTermsDays},
            #{status},
            #{approvedBy},
            #{approvedAt},
            NOW(),
            NOW()
        )
    </insert>

    <update id="updateBuyerCreditPolicy">
        UPDATE tb_buyer_credit_policy
           SET credit_limit_amount = #{creditLimitAmount},
               payment_terms_days  = #{paymentTermsDays},
               status              = #{status},
               approved_by         = #{approvedBy},
               approved_at         = #{approvedAt},
               updated_at          = NOW()
         WHERE credit_policy_id = #{creditPolicyId}
    </update>

    <insert id="insertCreditLimitHistory" useGeneratedKeys="true" keyProperty="creditLimitHistId">
        INSERT INTO tb_buyer_credit_limit_history (
            credit_policy_id,
            old_limit_amount,
            new_limit_amount,
            reason,
            requested_by,
            approved_by,
            approved_at,
            created_at
        ) VALUES (
            #{creditPolicyId},
            #{oldLimitAmount},
            #{newLimitAmount},
            #{reason},
            #{requestedBy},
            #{approvedBy},
            #{approvedAt},
            NOW()
        )
    </insert>

    <insert id="insertBuyerCreditLedger" useGeneratedKeys="true" keyProperty="creditLedgerId">
        INSERT INTO tb_buyer_credit_ledger (
            tenant_id,
            seller_company_id,
            buyer_company_id,
            txn_type,
            order_id,
            amount,
            balance_after,
            memo,
            txn_at,
            created_by
        ) VALUES (
            #{tenantId},
            #{sellerCompanyId},
            #{buyerCompanyId},
            #{txnType},
            #{orderId},
            #{amount},
            #{balanceAfter},
            #{memo},
            #{txnAt},
            #{createdBy}
        )
    </insert>

    <select id="selectLatestCreditBalance" resultType="java.math.BigDecimal">
        SELECT COALESCE(balance_after, 0)
        FROM tb_buyer_credit_ledger
        WHERE tenant_id = #{tenantId}
          AND seller_company_id = #{sellerCompanyId}
          AND buyer_company_id = #{buyerCompanyId}
        ORDER BY txn_at DESC, credit_ledger_id DESC
        LIMIT 1
    </select>

    <select id="selectAvailableCreditAmount" resultType="map">
        SELECT
            p.credit_policy_id      AS creditPolicyId,
            p.credit_limit_amount   AS creditLimitAmount,
            COALESCE((
                SELECT l.balance_after
                  FROM tb_buyer_credit_ledger l
                 WHERE l.tenant_id = p.tenant_id
                   AND l.seller_company_id = p.seller_company_id
                   AND l.buyer_company_id = p.buyer_company_id
                 ORDER BY l.txn_at DESC, l.credit_ledger_id DESC
                 LIMIT 1
            ), 0) AS usedCreditAmount,
            p.credit_limit_amount - COALESCE((
                SELECT l.balance_after
                  FROM tb_buyer_credit_ledger l
                 WHERE l.tenant_id = p.tenant_id
                   AND l.seller_company_id = p.seller_company_id
                   AND l.buyer_company_id = p.buyer_company_id
                 ORDER BY l.txn_at DESC, l.credit_ledger_id DESC
                 LIMIT 1
            ), 0) AS availableCreditAmount
        FROM tb_buyer_credit_policy p
        WHERE p.tenant_id = #{tenantId}
          AND p.seller_company_id = #{sellerCompanyId}
          AND p.buyer_company_id = #{buyerCompanyId}
          AND p.status = 'ACTIVE'
    </select>


    <!-- =========================================================
         11. 외부입금 / 선수금
    ========================================================== -->

    <select id="selectExternalPaymentByBankTxnRef" resultType="map">
        SELECT
            external_payment_id      AS externalPaymentId,
            tenant_id                AS tenantId,
            seller_company_id        AS sellerCompanyId,
            buyer_company_id         AS buyerCompanyId,
            receipt_bank_account_id  AS receiptBankAccountId,
            bank_txn_ref             AS bankTxnRef,
            payer_name               AS payerName,
            deposited_amount         AS depositedAmount,
            deposited_at             AS depositedAt,
            payment_type             AS paymentType,
            match_status             AS matchStatus,
            matched_order_id         AS matchedOrderId,
            created_at               AS createdAt
        FROM tb_external_payment_txn
        WHERE bank_txn_ref = #{bankTxnRef}
    </select>

    <insert id="insertExternalPaymentTxn" useGeneratedKeys="true" keyProperty="externalPaymentId">
        INSERT INTO tb_external_payment_txn (
            tenant_id,
            seller_company_id,
            buyer_company_id,
            receipt_bank_account_id,
            bank_txn_ref,
            payer_name,
            deposited_amount,
            deposited_at,
            payment_type,
            match_status,
            matched_order_id,
            created_at
        ) VALUES (
            #{tenantId},
            #{sellerCompanyId},
            #{buyerCompanyId},
            #{receiptBankAccountId},
            #{bankTxnRef},
            #{payerName},
            #{depositedAmount},
            #{depositedAt},
            #{paymentType},
            #{matchStatus},
            #{matchedOrderId},
            NOW()
        )
    </insert>

    <update id="updateExternalPaymentMatch">
        UPDATE tb_external_payment_txn
           SET match_status     = #{matchStatus},
               matched_order_id = #{matchedOrderId}
         WHERE external_payment_id = #{externalPaymentId}
    </update>

    <insert id="insertBuyerAdvanceLedger" useGeneratedKeys="true" keyProperty="advanceLedgerId">
        INSERT INTO tb_buyer_advance_ledger (
            tenant_id,
            seller_company_id,
            buyer_company_id,
            txn_type,
            external_payment_id,
            order_id,
            amount,
            balance_after,
            memo,
            txn_at,
            created_by
        ) VALUES (
            #{tenantId},
            #{sellerCompanyId},
            #{buyerCompanyId},
            #{txnType},
            #{externalPaymentId},
            #{orderId},
            #{amount},
            #{balanceAfter},
            #{memo},
            #{txnAt},
            #{createdBy}
        )
    </insert>

    <select id="selectLatestAdvanceBalance" resultType="java.math.BigDecimal">
        SELECT COALESCE(balance_after, 0)
        FROM tb_buyer_advance_ledger
        WHERE tenant_id = #{tenantId}
          AND seller_company_id = #{sellerCompanyId}
          AND buyer_company_id = #{buyerCompanyId}
        ORDER BY txn_at DESC, advance_ledger_id DESC
        LIMIT 1
    </select>

    <select id="selectAdvanceLedgerList" resultType="map">
        SELECT
            advance_ledger_id     AS advanceLedgerId,
            tenant_id             AS tenantId,
            seller_company_id     AS sellerCompanyId,
            buyer_company_id      AS buyerCompanyId,
            txn_type              AS txnType,
            external_payment_id   AS externalPaymentId,
            order_id              AS orderId,
            amount                AS amount,
            balance_after         AS balanceAfter,
            memo                  AS memo,
            txn_at                AS txnAt,
            created_by            AS createdBy
        FROM tb_buyer_advance_ledger
        WHERE tenant_id = #{tenantId}
          AND seller_company_id = #{sellerCompanyId}
          AND buyer_company_id = #{buyerCompanyId}
        ORDER BY txn_at DESC, advance_ledger_id DESC
        <if test="recordCountPerPage != null and recordCountPerPage > 0">
            LIMIT #{firstIndex}, #{recordCountPerPage}
        </if>
    </select>


    <!-- =========================================================
         12. 주문 충당
    ========================================================== -->

    <insert id="insertPaymentAllocation" useGeneratedKeys="true" keyProperty="allocationId">
        INSERT INTO tb_payment_allocation (
            order_id,
            source_type,
            source_ref_id,
            allocated_amount,
            allocated_at,
            created_by
        ) VALUES (
            #{orderId},
            #{sourceType},
            #{sourceRefId},
            #{allocatedAmount},
            #{allocatedAt},
            #{createdBy}
        )
    </insert>

    <select id="selectPaymentAllocationsByOrderId" resultType="map">
        SELECT
            allocation_id      AS allocationId,
            order_id           AS orderId,
            source_type        AS sourceType,
            source_ref_id      AS sourceRefId,
            allocated_amount   AS allocatedAmount,
            allocated_at       AS allocatedAt,
            created_by         AS createdBy
        FROM tb_payment_allocation
        WHERE order_id = #{orderId}
        ORDER BY allocation_id ASC
    </select>


    <!-- =========================================================
         13. 정산
    ========================================================== -->

    <insert id="insertSettlement" useGeneratedKeys="true" keyProperty="settlementId">
        INSERT INTO tb_settlement (
            tenant_id,
            seller_company_id,
            buyer_company_id,
            period_from,
            period_to,
            opening_balance,
            sales_amount,
            vat_amount,
            received_amount,
            credit_used_amount,
            closing_balance,
            settlement_status,
            closed_at,
            closed_by
        ) VALUES (
            #{tenantId},
            #{sellerCompanyId},
            #{buyerCompanyId},
            #{periodFrom},
            #{periodTo},
            #{openingBalance},
            #{salesAmount},
            #{vatAmount},
            #{receivedAmount},
            #{creditUsedAmount},
            #{closingBalance},
            #{settlementStatus},
            #{closedAt},
            #{closedBy}
        )
    </insert>

    <insert id="insertSettlementLine" useGeneratedKeys="true" keyProperty="settlementLineId">
        INSERT INTO tb_settlement_line (
            settlement_id,
            line_type,
            ref_table,
            ref_id,
            amount,
            memo,
            created_at
        ) VALUES (
            #{settlementId},
            #{lineType},
            #{refTable},
            #{refId},
            #{amount},
            #{memo},
            NOW()
        )
    </insert>

    <select id="selectSettlementList" resultType="map">
        SELECT
            <include refid="settlementBaseColumns"/>
        FROM tb_settlement s
        INNER JOIN tb_tenant t
            ON s.tenant_id = t.tenant_id
        INNER JOIN tb_company sc
            ON s.seller_company_id = sc.company_id
        INNER JOIN tb_company bc
            ON s.buyer_company_id = bc.company_id
        LEFT JOIN tb_user u
            ON s.closed_by = u.user_id
        <where>
            <if test="tenantId != null">
                AND s.tenant_id = #{tenantId}
            </if>
            <if test="sellerCompanyId != null">
                AND s.seller_company_id = #{sellerCompanyId}
            </if>
            <if test="buyerCompanyId != null">
                AND s.buyer_company_id = #{buyerCompanyId}
            </if>
            <if test="settlementStatus != null and settlementStatus != ''">
                AND s.settlement_status = #{settlementStatus}
            </if>
            <if test="periodFrom != null and periodFrom != ''">
                AND s.period_from <![CDATA[>=]]> #{periodFrom}
            </if>
            <if test="periodTo != null and periodTo != ''">
                AND s.period_to <![CDATA[<=]]> #{periodTo}
            </if>
        </where>
        ORDER BY s.period_to DESC, s.settlement_id DESC
        <if test="recordCountPerPage != null and recordCountPerPage > 0">
            LIMIT #{firstIndex}, #{recordCountPerPage}
        </if>
    </select>

    <select id="selectSettlementDetail" resultType="map">
        SELECT
            <include refid="settlementBaseColumns"/>
        FROM tb_settlement s
        INNER JOIN tb_tenant t
            ON s.tenant_id = t.tenant_id
        INNER JOIN tb_company sc
            ON s.seller_company_id = sc.company_id
        INNER JOIN tb_company bc
            ON s.buyer_company_id = bc.company_id
        LEFT JOIN tb_user u
            ON s.closed_by = u.user_id
        WHERE s.settlement_id = #{settlementId}
    </select>

    <select id="selectSettlementLinesBySettlementId" resultType="map">
        SELECT
            settlement_line_id   AS settlementLineId,
            settlement_id        AS settlementId,
            line_type            AS lineType,
            ref_table            AS refTable,
            ref_id               AS refId,
            amount               AS amount,
            memo                 AS memo,
            created_at           AS createdAt
        FROM tb_settlement_line
        WHERE settlement_id = #{settlementId}
        ORDER BY settlement_line_id ASC
    </select>

    <update id="updateSettlementStatus">
        UPDATE tb_settlement
           SET settlement_status = #{settlementStatus},
               closed_at         = #{closedAt},
               closed_by         = #{closedBy}
         WHERE settlement_id = #{settlementId}
    </update>


    <!-- =========================================================
         14. 폼 옵션 / 운영 편의 조회
    ========================================================== -->

    <select id="selectBuyerCompanyListByTenant" resultType="map">
        SELECT
            company_id     AS companyId,
            company_name   AS companyName,
            business_no    AS businessNo,
            ceo_name       AS ceoName,
            status         AS status
        FROM tb_company
        WHERE tenant_id = #{tenantId}
          AND company_type = 'BUYER'
          AND status = 'ACTIVE'
        ORDER BY company_name ASC
    </select>

    <select id="selectSellerCompanyByTenant" resultType="map">
        SELECT
            t.tenant_id           AS tenantId,
            t.tenant_code         AS tenantCode,
            t.tenant_name         AS tenantName,
            t.seller_company_id   AS sellerCompanyId,
            c.company_name        AS sellerCompanyName,
            c.business_no         AS businessNo,
            c.ceo_name            AS ceoName,
            c.status              AS companyStatus
        FROM tb_tenant t
        LEFT JOIN tb_company c
            ON t.seller_company_id = c.company_id
        WHERE t.tenant_id = #{tenantId}
    </select>

    <select id="selectChannelListByTenant" resultType="map">
        SELECT
            channel_id     AS channelId,
            tenant_id      AS tenantId,
            channel_code   AS channelCode,
            channel_name   AS channelName,
            status         AS status,
            sort_order     AS sortOrder
        FROM tb_channel
        WHERE tenant_id = #{tenantId}
          AND status = 'ACTIVE'
        ORDER BY sort_order ASC, channel_id ASC
    </select>

    <select id="selectOnSaleProductOptionList" resultType="map">
        SELECT
            p.product_id         AS productId,
            p.product_code       AS productCode,
            p.product_name       AS productName,
            p.item_kind          AS itemKind,
            p.processing_type    AS processingType,
            p.tax_category       AS taxCategory,
            p.unit_name          AS unitName,
            p.stock_managed_yn   AS stockManagedYn,
            p.sale_status        AS saleStatus,
            sc.company_name      AS sellerCompanyName
        FROM tb_product p
        INNER JOIN tb_company sc
            ON p.seller_company_id = sc.company_id
        WHERE p.tenant_id = #{tenantId}
          AND p.sale_status = 'ON_SALE'
          <if test="sellerCompanyId != null">
            AND p.seller_company_id = #{sellerCompanyId}
          </if>
          <if test="processingType != null and processingType != ''">
            AND p.processing_type = #{processingType}
          </if>
          <if test="itemKind != null and itemKind != ''">
            AND p.item_kind = #{itemKind}
          </if>
          <if test="searchKeyword != null and searchKeyword != ''">
            AND (
                p.product_code LIKE CONCAT('%', #{searchKeyword}, '%')
                OR p.product_name LIKE CONCAT('%', #{searchKeyword}, '%')
            )
          </if>
        ORDER BY p.product_name ASC, p.product_id ASC
    </select>

    <select id="selectActiveReceiptBankAccountListByCompany" resultType="map">
        SELECT
            bank_account_id   AS bankAccountId,
            company_id        AS companyId,
            bank_name         AS bankName,
            account_holder    AS accountHolder,
            is_default        AS isDefault,
            status            AS status,
            created_at        AS createdAt,
            updated_at        AS updatedAt
        FROM tb_company_bank_account
        WHERE company_id = #{companyId}
          AND status = 'ACTIVE'
        ORDER BY
            CASE WHEN is_default = 'Y' THEN 0 ELSE 1 END ASC,
            bank_account_id ASC
    </select>

    <select id="selectReceiptBankAccountValidation" resultType="map">
        SELECT
            b.bank_account_id   AS bankAccountId,
            b.company_id        AS companyId,
            b.bank_name         AS bankName,
            b.account_holder    AS accountHolder,
            b.is_default        AS isDefault,
            b.status            AS status,
            c.company_name      AS companyName,
            c.tenant_id         AS tenantId
        FROM tb_company_bank_account b
        INNER JOIN tb_company c
            ON b.company_id = c.company_id
        WHERE b.bank_account_id = #{bankAccountId}
    </select>

    <select id="selectBuyerFundingSummary" resultType="map">
        SELECT
            t.tenant_id AS tenantId,
            #{sellerCompanyId} AS sellerCompanyId,
            #{buyerCompanyId} AS buyerCompanyId,

            COALESCE((
                SELECT al.balance_after
                FROM tb_buyer_advance_ledger al
                WHERE al.tenant_id = t.tenant_id
                  AND al.seller_company_id = #{sellerCompanyId}
                  AND al.buyer_company_id = #{buyerCompanyId}
                ORDER BY al.txn_at DESC, al.advance_ledger_id DESC
                LIMIT 1
            ), 0) AS advanceBalance,

            COALESCE(cp.credit_limit_amount, 0) AS creditLimitAmount,

            COALESCE((
                SELECT cl.balance_after
                FROM tb_buyer_credit_ledger cl
                WHERE cl.tenant_id = t.tenant_id
                  AND cl.seller_company_id = #{sellerCompanyId}
                  AND cl.buyer_company_id = #{buyerCompanyId}
                ORDER BY cl.txn_at DESC, cl.credit_ledger_id DESC
                LIMIT 1
            ), 0) AS usedCreditAmount,

            GREATEST(
                COALESCE(cp.credit_limit_amount, 0) -
                COALESCE((
                    SELECT cl.balance_after
                    FROM tb_buyer_credit_ledger cl
                    WHERE cl.tenant_id = t.tenant_id
                      AND cl.seller_company_id = #{sellerCompanyId}
                      AND cl.buyer_company_id = #{buyerCompanyId}
                    ORDER BY cl.txn_at DESC, cl.credit_ledger_id DESC
                    LIMIT 1
                ), 0),
                0
            ) AS availableCreditAmount

        FROM tb_tenant t
        LEFT JOIN tb_buyer_credit_policy cp
            ON cp.tenant_id = t.tenant_id
           AND cp.seller_company_id = #{sellerCompanyId}
           AND cp.buyer_company_id = #{buyerCompanyId}
           AND cp.status = 'ACTIVE'
        WHERE t.tenant_id = #{tenantId}
    </select>

    <select id="selectProductByProductCode" resultType="map">
        SELECT
            product_id          AS productId,
            tenant_id           AS tenantId,
            seller_company_id   AS sellerCompanyId,
            product_code        AS productCode,
            product_name        AS productName,
            item_kind           AS itemKind,
            processing_type     AS processingType,
            tax_category        AS taxCategory,
            unit_name           AS unitName,
            independent_sale_yn AS independentSaleYn,
            stock_managed_yn    AS stockManagedYn,
            sale_status         AS saleStatus,
            created_at          AS createdAt,
            updated_at          AS updatedAt
        FROM tb_product
        WHERE tenant_id = #{tenantId}
          AND product_code = #{productCode}
        LIMIT 1
    </select>

    <select id="selectOrderByOrderNo" resultType="map">
        SELECT
            order_id           AS orderId,
            tenant_id          AS tenantId,
            seller_company_id  AS sellerCompanyId,
            buyer_company_id   AS buyerCompanyId,
            channel_id         AS channelId,
            order_no           AS orderNo,
            order_status       AS orderStatus,
            payment_status     AS paymentStatus,
            total_amount       AS totalAmount,
            ordered_at         AS orderedAt
        FROM tb_order
        WHERE order_no = #{orderNo}
        LIMIT 1
    </select>


    <!-- =========================================================
         15. 대시보드 / 통계
    ========================================================== -->

    <select id="selectProductStats" resultType="map">
        SELECT
            COUNT(1) AS totalCount,
            COALESCE(SUM(CASE WHEN processing_type = 'RAW_GOODS' THEN 1 ELSE 0 END), 0) AS rawGoodsCount,
            COALESCE(SUM(CASE WHEN processing_type = 'PROCESSED_GOODS' THEN 1 ELSE 0 END), 0) AS processedGoodsCount,
            COALESCE(SUM(CASE WHEN processing_type = 'PROCESS_SERVICE' THEN 1 ELSE 0 END), 0) AS processServiceCount,
            COALESCE(SUM(CASE WHEN tax_category = 'TAX_FREE' THEN 1 ELSE 0 END), 0) AS taxFreeCount,
            COALESCE(SUM(CASE WHEN tax_category = 'TAXABLE' THEN 1 ELSE 0 END), 0) AS taxableCount,
            COALESCE(SUM(CASE WHEN sale_status = 'ON_SALE' THEN 1 ELSE 0 END), 0) AS onSaleCount,
            COALESCE(SUM(CASE WHEN sale_status = 'STOPPED' THEN 1 ELSE 0 END), 0) AS stoppedCount,
            COALESCE(SUM(CASE WHEN sale_status = 'HIDDEN' THEN 1 ELSE 0 END), 0) AS hiddenCount
        FROM tb_product
        WHERE 1 = 1
          <if test="tenantId != null">
            AND tenant_id = #{tenantId}
          </if>
          <if test="sellerCompanyId != null">
            AND seller_company_id = #{sellerCompanyId}
          </if>
    </select>

    <select id="selectOrderStats" resultType="map">
        SELECT
            COUNT(1) AS totalCount,
            COALESCE(SUM(total_amount), 0) AS totalAmount,
            COALESCE(SUM(tax_free_supply_amount), 0) AS taxFreeSupplyAmount,
            COALESCE(SUM(taxable_supply_amount), 0) AS taxableSupplyAmount,
            COALESCE(SUM(vat_amount), 0) AS vatAmount,
            COALESCE(SUM(CASE WHEN order_status = 'DRAFT' THEN 1 ELSE 0 END), 0) AS draftCount,
            COALESCE(SUM(CASE WHEN order_status = 'PLACED' THEN 1 ELSE 0 END), 0) AS placedCount,
            COALESCE(SUM(CASE WHEN order_status = 'CONFIRMED' THEN 1 ELSE 0 END), 0) AS confirmedCount,
            COALESCE(SUM(CASE WHEN order_status = 'PARTIAL_SHIPPED' THEN 1 ELSE 0 END), 0) AS partialShippedCount,
            COALESCE(SUM(CASE WHEN order_status = 'SHIPPED' THEN 1 ELSE 0 END), 0) AS shippedCount,
            COALESCE(SUM(CASE WHEN order_status = 'COMPLETED' THEN 1 ELSE 0 END), 0) AS completedCount,
            COALESCE(SUM(CASE WHEN order_status = 'CANCELED' THEN 1 ELSE 0 END), 0) AS canceledCount,
            COALESCE(SUM(CASE WHEN payment_status = 'UNPAID' THEN 1 ELSE 0 END), 0) AS unpaidCount,
            COALESCE(SUM(CASE WHEN payment_status = 'PARTIAL_ALLOCATED' THEN 1 ELSE 0 END), 0) AS partialAllocatedCount,
            COALESCE(SUM(CASE WHEN payment_status = 'ALLOCATED' THEN 1 ELSE 0 END), 0) AS allocatedCount,
            COALESCE(SUM(CASE WHEN payment_status = 'REFUNDED' THEN 1 ELSE 0 END), 0) AS refundedCount
        FROM tb_order
        WHERE 1 = 1
          <if test="tenantId != null">
            AND tenant_id = #{tenantId}
          </if>
          <if test="sellerCompanyId != null">
            AND seller_company_id = #{sellerCompanyId}
          </if>
          <if test="buyerCompanyId != null">
            AND buyer_company_id = #{buyerCompanyId}
          </if>
          <if test="dateFrom != null and dateFrom != ''">
            AND ordered_at <![CDATA[>=]]> CONCAT(#{dateFrom}, ' 00:00:00')
          </if>
          <if test="dateTo != null and dateTo != ''">
            AND ordered_at <![CDATA[<=]]> CONCAT(#{dateTo}, ' 23:59:59')
          </if>
    </select>

    <select id="selectPaymentStats" resultType="map">
        SELECT
            COUNT(1) AS totalCount,
            COALESCE(SUM(deposited_amount), 0) AS totalDepositedAmount,
            COALESCE(SUM(CASE WHEN payment_type = 'ADVANCE_DEPOSIT' THEN deposited_amount ELSE 0 END), 0) AS advanceDepositAmount,
            COALESCE(SUM(CASE WHEN payment_type = 'ORDER_PAYMENT' THEN deposited_amount ELSE 0 END), 0) AS orderPaymentAmount,
            COALESCE(SUM(CASE WHEN payment_type = 'CREDIT_SETTLEMENT' THEN deposited_amount ELSE 0 END), 0) AS creditSettlementAmount,
            COALESCE(SUM(CASE WHEN match_status = 'UNMATCHED' THEN 1 ELSE 0 END), 0) AS unmatchedCount,
            COALESCE(SUM(CASE WHEN match_status = 'MATCHED' THEN 1 ELSE 0 END), 0) AS matchedCount,
            COALESCE(SUM(CASE WHEN match_status = 'PARTIAL' THEN 1 ELSE 0 END), 0) AS partialCount,
            COALESCE(SUM(CASE WHEN match_status = 'CANCELED' THEN 1 ELSE 0 END), 0) AS canceledCount
        FROM tb_external_payment_txn
        WHERE 1 = 1
          <if test="tenantId != null">
            AND tenant_id = #{tenantId}
          </if>
          <if test="sellerCompanyId != null">
            AND seller_company_id = #{sellerCompanyId}
          </if>
          <if test="buyerCompanyId != null">
            AND buyer_company_id = #{buyerCompanyId}
          </if>
          <if test="dateFrom != null and dateFrom != ''">
            AND deposited_at <![CDATA[>=]]> CONCAT(#{dateFrom}, ' 00:00:00')
          </if>
          <if test="dateTo != null and dateTo != ''">
            AND deposited_at <![CDATA[<=]]> CONCAT(#{dateTo}, ' 23:59:59')
          </if>
    </select>

    <select id="selectSettlementStats" resultType="map">
        SELECT
            COUNT(1) AS totalCount,
            COALESCE(SUM(sales_amount), 0) AS totalSalesAmount,
            COALESCE(SUM(vat_amount), 0) AS totalVatAmount,
            COALESCE(SUM(received_amount), 0) AS totalReceivedAmount,
            COALESCE(SUM(credit_used_amount), 0) AS totalCreditUsedAmount,
            COALESCE(SUM(closing_balance), 0) AS totalClosingBalance,
            COALESCE(SUM(CASE WHEN settlement_status = 'OPEN' THEN 1 ELSE 0 END), 0) AS openCount,
            COALESCE(SUM(CASE WHEN settlement_status = 'CLOSED' THEN 1 ELSE 0 END), 0) AS closedCount,
            COALESCE(SUM(CASE WHEN settlement_status = 'CONFIRMED' THEN 1 ELSE 0 END), 0) AS confirmedCount
        FROM tb_settlement
        WHERE 1 = 1
          <if test="tenantId != null">
            AND tenant_id = #{tenantId}
          </if>
          <if test="sellerCompanyId != null">
            AND seller_company_id = #{sellerCompanyId}
          </if>
          <if test="buyerCompanyId != null">
            AND buyer_company_id = #{buyerCompanyId}
          </if>
          <if test="periodFrom != null and periodFrom != ''">
            AND period_from <![CDATA[>=]]> #{periodFrom}
          </if>
          <if test="periodTo != null and periodTo != ''">
            AND period_to <![CDATA[<=]]> #{periodTo}
          </if>
    </select>

    <select id="selectTaxDocumentStats" resultType="map">
        SELECT
            COUNT(1) AS totalCount,
            COALESCE(SUM(CASE WHEN tax_category = 'TAX_FREE' THEN total_amount ELSE 0 END), 0) AS taxFreeDocumentAmount,
            COALESCE(SUM(CASE WHEN tax_category = 'TAXABLE' THEN total_amount ELSE 0 END), 0) AS taxableDocumentAmount,
            COALESCE(SUM(CASE WHEN issue_status = 'READY' THEN 1 ELSE 0 END), 0) AS readyCount,
            COALESCE(SUM(CASE WHEN issue_status = 'ISSUED' THEN 1 ELSE 0 END), 0) AS issuedCount,
            COALESCE(SUM(CASE WHEN issue_status = 'FAILED' THEN 1 ELSE 0 END), 0) AS failedCount,
            COALESCE(SUM(CASE WHEN issue_status = 'CANCELED' THEN 1 ELSE 0 END), 0) AS canceledCount
        FROM tb_tax_document
        WHERE 1 = 1
          <if test="sellerCompanyId != null">
            AND seller_company_id = #{sellerCompanyId}
          </if>
          <if test="buyerCompanyId != null">
            AND buyer_company_id = #{buyerCompanyId}
          </if>
    </select>

</mapper>



=====================================================================================================
파일 위치 추천
src/main/java/kr/co/matpam/admin/trade/service/impl/ProductOrderFinanceMapper.java

전제

이전에 작성한 PRODUCT_ORDER_FINANCE_MAPPER_DRAFT.xml의 namespace와 정확히 일치하도록 작성
현재 XML이 resultType="map" 중심이므로, Java도 우선 Map<String, Object> 기반으로 맞춤
eGovFrame 스타일 기준으로 @Mapper("productOrderFinanceMapper") 사용
=====================================================================================================


ProductOrderFinanceMapper.java


package kr.co.matpam.admin.trade.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * MATPAM B2B 폐쇄 플랫폼
 * 상품 / 주문 / 출고 / 재고 / 정산 / 여신·입금 Mapper
 *
 * <p>주의:
 * <ul>
 *     <li>본 인터페이스는 PRODUCT_ORDER_FINANCE_MAPPER_DRAFT.xml 과 1:1 매핑 전제</li>
 *     <li>현재는 VO 대신 Map 기반 초안</li>
 *     <li>향후 ProductVO / OrderVO / PaymentVO / SettlementVO 로 점진적 전환 권장</li>
 * </ul>
 */
@Mapper("productOrderFinanceMapper")
public interface ProductOrderFinanceMapper {

    // =========================================================
    // 1. 상품
    // =========================================================

    List<Map<String, Object>> selectProductList(Map<String, Object> param) throws Exception;

    int selectProductListTotCnt(Map<String, Object> param) throws Exception;

    Map<String, Object> selectProductDetail(@Param("productId") Long productId) throws Exception;

    List<Map<String, Object>> selectProductsForOrder(@Param("productIdList") List<Long> productIdList) throws Exception;

    int insertProduct(Map<String, Object> param) throws Exception;

    int updateProduct(Map<String, Object> param) throws Exception;

    int updateProductSaleStatus(@Param("productId") Long productId,
                                @Param("saleStatus") String saleStatus) throws Exception;


    // =========================================================
    // 2. 상품 세금 규칙
    // =========================================================

    int selectNextTaxRuleVersion(@Param("productId") Long productId) throws Exception;

    Map<String, Object> selectCurrentApprovedTaxRule(@Param("productId") Long productId) throws Exception;

    List<Map<String, Object>> selectApprovedTaxRulesByProductIds(@Param("productIdList") List<Long> productIdList) throws Exception;

    List<Map<String, Object>> selectProductTaxRuleHistory(@Param("productId") Long productId) throws Exception;

    int insertProductTaxRule(Map<String, Object> param) throws Exception;

    int approveProductTaxRule(@Param("taxRuleId") Long taxRuleId,
                              @Param("approvedBy") Long approvedBy) throws Exception;

    int rejectProductTaxRule(@Param("taxRuleId") Long taxRuleId,
                             @Param("approvedBy") Long approvedBy) throws Exception;

    int syncProductTaxCategoryByApprovedRule(@Param("taxRuleId") Long taxRuleId) throws Exception;


    // =========================================================
    // 3. 상품 연관 관계
    // =========================================================

    List<Map<String, Object>> selectRelatedProductList(@Param("baseProductId") Long baseProductId,
                                                       @Param("status") String status) throws Exception;

    int insertProductRelation(Map<String, Object> param) throws Exception;

    int updateProductRelationStatus(@Param("relationId") Long relationId,
                                    @Param("status") String status) throws Exception;


    // =========================================================
    // 4. 상품 가격
    // =========================================================

    List<Map<String, Object>> selectProductPriceList(@Param("productId") Long productId) throws Exception;

    Map<String, Object> selectApplicablePrice(Map<String, Object> param) throws Exception;

    int insertProductPrice(Map<String, Object> param) throws Exception;

    int updateProductPriceStatus(@Param("priceId") Long priceId,
                                 @Param("status") String status) throws Exception;


    // =========================================================
    // 5. 가공 레시피
    // =========================================================

    Map<String, Object> selectProcessRecipeBySourceTarget(@Param("sourceProductId") Long sourceProductId,
                                                          @Param("targetProductId") Long targetProductId) throws Exception;

    List<Map<String, Object>> selectProcessRecipeListBySourceProduct(@Param("sourceProductId") Long sourceProductId) throws Exception;

    int insertProductProcessRecipe(Map<String, Object> param) throws Exception;


    // =========================================================
    // 6. 주문
    // =========================================================

    List<Map<String, Object>> selectOrderList(Map<String, Object> param) throws Exception;

    int selectOrderListTotCnt(Map<String, Object> param) throws Exception;

    Map<String, Object> selectOrderDetail(@Param("orderId") Long orderId) throws Exception;

    List<Map<String, Object>> selectOrderLinesByOrderId(@Param("orderId") Long orderId) throws Exception;

    int insertOrder(Map<String, Object> param) throws Exception;

    int insertOrderLine(Map<String, Object> param) throws Exception;

    int updateOrderStatus(@Param("orderId") Long orderId,
                          @Param("orderStatus") String orderStatus) throws Exception;

    int updateOrderPaymentSummary(Map<String, Object> param) throws Exception;


    // =========================================================
    // 7. 세금문서
    // =========================================================

    int insertTaxDocumentsByOrderId(@Param("orderId") Long orderId) throws Exception;

    List<Map<String, Object>> selectTaxDocumentsByOrderId(@Param("orderId") Long orderId) throws Exception;

    int updateTaxDocumentIssueResult(Map<String, Object> param) throws Exception;


    // =========================================================
    // 8. 출고
    // =========================================================

    int insertShipment(Map<String, Object> param) throws Exception;

    int insertShipmentLine(Map<String, Object> param) throws Exception;

    List<Map<String, Object>> selectShipmentListByOrderId(@Param("orderId") Long orderId) throws Exception;

    List<Map<String, Object>> selectShipmentLinesByShipmentId(@Param("shipmentId") Long shipmentId) throws Exception;

    int updateShipmentStatus(Map<String, Object> param) throws Exception;

    int updateOrderLineShipmentStatus(@Param("orderLineId") Long orderLineId,
                                      @Param("shipmentStatus") String shipmentStatus) throws Exception;


    // =========================================================
    // 9. 재고 LOT / 재고원장 / 가공배치
    // =========================================================

    int insertStockLot(Map<String, Object> param) throws Exception;

    List<Map<String, Object>> selectAvailableLotsByProduct(@Param("productId") Long productId) throws Exception;

    int updateStockLotCurrentQty(@Param("lotId") Long lotId,
                                 @Param("currentQty") BigDecimal currentQty) throws Exception;

    int insertStockLedger(Map<String, Object> param) throws Exception;

    List<Map<String, Object>> selectStockLedgerByRef(@Param("refTable") String refTable,
                                                     @Param("refId") Long refId) throws Exception;

    int insertProcessBatch(Map<String, Object> param) throws Exception;

    List<Map<String, Object>> selectProcessBatchList(Map<String, Object> param) throws Exception;


    // =========================================================
    // 10. 여신 정책 / 여신 원장
    // =========================================================

    Map<String, Object> selectCreditPolicy(@Param("tenantId") Long tenantId,
                                           @Param("sellerCompanyId") Long sellerCompanyId,
                                           @Param("buyerCompanyId") Long buyerCompanyId) throws Exception;

    int insertBuyerCreditPolicy(Map<String, Object> param) throws Exception;

    int updateBuyerCreditPolicy(Map<String, Object> param) throws Exception;

    int insertCreditLimitHistory(Map<String, Object> param) throws Exception;

    int insertBuyerCreditLedger(Map<String, Object> param) throws Exception;

    BigDecimal selectLatestCreditBalance(@Param("tenantId") Long tenantId,
                                         @Param("sellerCompanyId") Long sellerCompanyId,
                                         @Param("buyerCompanyId") Long buyerCompanyId) throws Exception;

    Map<String, Object> selectAvailableCreditAmount(@Param("tenantId") Long tenantId,
                                                    @Param("sellerCompanyId") Long sellerCompanyId,
                                                    @Param("buyerCompanyId") Long buyerCompanyId) throws Exception;


    // =========================================================
    // 11. 외부입금 / 선수금
    // =========================================================

    Map<String, Object> selectExternalPaymentByBankTxnRef(@Param("bankTxnRef") String bankTxnRef) throws Exception;

    int insertExternalPaymentTxn(Map<String, Object> param) throws Exception;

    int updateExternalPaymentMatch(Map<String, Object> param) throws Exception;

    int insertBuyerAdvanceLedger(Map<String, Object> param) throws Exception;

    BigDecimal selectLatestAdvanceBalance(@Param("tenantId") Long tenantId,
                                          @Param("sellerCompanyId") Long sellerCompanyId,
                                          @Param("buyerCompanyId") Long buyerCompanyId) throws Exception;

    List<Map<String, Object>> selectAdvanceLedgerList(Map<String, Object> param) throws Exception;


    // =========================================================
    // 12. 주문 충당
    // =========================================================

    int insertPaymentAllocation(Map<String, Object> param) throws Exception;

    List<Map<String, Object>> selectPaymentAllocationsByOrderId(@Param("orderId") Long orderId) throws Exception;


    // =========================================================
    // 13. 정산
    // =========================================================

    int insertSettlement(Map<String, Object> param) throws Exception;

    int insertSettlementLine(Map<String, Object> param) throws Exception;

    List<Map<String, Object>> selectSettlementList(Map<String, Object> param) throws Exception;

    Map<String, Object> selectSettlementDetail(@Param("settlementId") Long settlementId) throws Exception;

    List<Map<String, Object>> selectSettlementLinesBySettlementId(@Param("settlementId") Long settlementId) throws Exception;

    int updateSettlementStatus(Map<String, Object> param) throws Exception;


    // =========================================================
    // 14. 폼 옵션 / 운영 편의 조회
    // =========================================================

    List<Map<String, Object>> selectBuyerCompanyListByTenant(@Param("tenantId") Long tenantId) throws Exception;

    Map<String, Object> selectSellerCompanyByTenant(@Param("tenantId") Long tenantId) throws Exception;

    List<Map<String, Object>> selectChannelListByTenant(@Param("tenantId") Long tenantId) throws Exception;

    List<Map<String, Object>> selectOnSaleProductOptionList(Map<String, Object> param) throws Exception;

    List<Map<String, Object>> selectActiveReceiptBankAccountListByCompany(@Param("companyId") Long companyId) throws Exception;

    Map<String, Object> selectReceiptBankAccountValidation(@Param("bankAccountId") Long bankAccountId) throws Exception;

    Map<String, Object> selectBuyerFundingSummary(@Param("tenantId") Long tenantId,
                                                  @Param("sellerCompanyId") Long sellerCompanyId,
                                                  @Param("buyerCompanyId") Long buyerCompanyId) throws Exception;

    Map<String, Object> selectProductByProductCode(@Param("tenantId") Long tenantId,
                                                   @Param("productCode") String productCode) throws Exception;

    Map<String, Object> selectOrderByOrderNo(@Param("orderNo") String orderNo) throws Exception;


    // =========================================================
    // 15. 대시보드 / 통계
    // =========================================================

    Map<String, Object> selectProductStats(Map<String, Object> param) throws Exception;

    Map<String, Object> selectOrderStats(Map<String, Object> param) throws Exception;

    Map<String, Object> selectPaymentStats(Map<String, Object> param) throws Exception;

    Map<String, Object> selectSettlementStats(Map<String, Object> param) throws Exception;

    Map<String, Object> selectTaxDocumentStats(Map<String, Object> param) throws Exception;
}

====================================================================================
파일 위치 추천
src/main/java/kr/co/matpam/admin/trade/service/ProductOrderFinanceService.java
====================================================================================

ProductOrderFinanceService.java

package kr.co.matpam.admin.trade.service;

import java.util.List;
import java.util.Map;

public interface ProductOrderFinanceService {

    // 상품
    List<Map<String, Object>> selectProductList(Map<String, Object> param) throws Exception;

    int selectProductListTotCnt(Map<String, Object> param) throws Exception;

    Map<String, Object> selectProductDetail(Long productId) throws Exception;

    // 주문
    List<Map<String, Object>> selectOrderList(Map<String, Object> param) throws Exception;

    int selectOrderListTotCnt(Map<String, Object> param) throws Exception;

    Map<String, Object> selectOrderDetail(Long orderId) throws Exception;

    List<Map<String, Object>> selectOrderLinesByOrderId(Long orderId) throws Exception;

    Long createOrder(Map<String, Object> param) throws Exception;

    // 입금 / 선수금 / 여신
    Long confirmDeposit(Map<String, Object> param) throws Exception;

    void updateCreditLimit(Map<String, Object> param) throws Exception;

    Map<String, Object> selectBuyerFundingSummary(Long tenantId, Long sellerCompanyId, Long buyerCompanyId) throws Exception;

    // 출고
    Long createShipment(Map<String, Object> param) throws Exception;

    // 통계
    Map<String, Object> selectDashboardSummary(Map<String, Object> param) throws Exception;
}

===========================================================================================
파일 위치 추천
src/main/java/kr/co/matpam/admin/trade/service/impl/ProductOrderFinanceServiceImpl.java
===========================================================================================

ProductOrderFinanceServiceImpl.java

package kr.co.matpam.admin.trade.service.impl;

import kr.co.matpam.admin.trade.service.ProductOrderFinanceService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * MATPAM B2B 폐쇄 플랫폼
 * 상품 / 주문 / 출고 / 재고 / 정산 / 여신·입금 Service 구현 초안
 *
 * <p>설계 포인트
 * <ul>
 *     <li>현재는 Map 기반 초안</li>
 *     <li>향후 ProductVO / OrderVO / PaymentVO / SettlementVO 로 전환 권장</li>
 *     <li>주문라인 snapshot / 선수금 / 여신 원장 흐름 구현 포함</li>
 * </ul>
 */
@Service("productOrderFinanceService")
public class ProductOrderFinanceServiceImpl implements ProductOrderFinanceService {

    private static final BigDecimal ZERO = new BigDecimal("0.00");
    private static final BigDecimal VAT_RATE = new BigDecimal("0.10");

    @Resource(name = "productOrderFinanceMapper")
    private ProductOrderFinanceMapper mapper;

    // =========================================================
    // 조회
    // =========================================================

    @Override
    public List<Map<String, Object>> selectProductList(Map<String, Object> param) throws Exception {
        return mapper.selectProductList(param);
    }

    @Override
    public int selectProductListTotCnt(Map<String, Object> param) throws Exception {
        return mapper.selectProductListTotCnt(param);
    }

    @Override
    public Map<String, Object> selectProductDetail(Long productId) throws Exception {
        return mapper.selectProductDetail(productId);
    }

    @Override
    public List<Map<String, Object>> selectOrderList(Map<String, Object> param) throws Exception {
        return mapper.selectOrderList(param);
    }

    @Override
    public int selectOrderListTotCnt(Map<String, Object> param) throws Exception {
        return mapper.selectOrderListTotCnt(param);
    }

    @Override
    public Map<String, Object> selectOrderDetail(Long orderId) throws Exception {
        return mapper.selectOrderDetail(orderId);
    }

    @Override
    public List<Map<String, Object>> selectOrderLinesByOrderId(Long orderId) throws Exception {
        return mapper.selectOrderLinesByOrderId(orderId);
    }

    @Override
    public Map<String, Object> selectBuyerFundingSummary(Long tenantId,
                                                         Long sellerCompanyId,
                                                         Long buyerCompanyId) throws Exception {
        return mapper.selectBuyerFundingSummary(tenantId, sellerCompanyId, buyerCompanyId);
    }

    @Override
    public Map<String, Object> selectDashboardSummary(Map<String, Object> param) throws Exception {
        Map<String, Object> result = new HashMap<>();
        result.put("productStats", mapper.selectProductStats(param));
        result.put("orderStats", mapper.selectOrderStats(param));
        result.put("paymentStats", mapper.selectPaymentStats(param));
        result.put("settlementStats", mapper.selectSettlementStats(param));
        result.put("taxDocumentStats", mapper.selectTaxDocumentStats(param));
        return result;
    }

    // =========================================================
    // 주문 생성
    // =========================================================

    /**
     * 주문 생성 핵심 로직
     *
     * <pre>
     * 1) 기본값/필수값 검증
     * 2) 상품 조회 + 판매 가능 검증
     * 3) 승인된 세금 규칙 조회
     * 4) 가격 확정
     * 5) 주문라인 snapshot 생성
     * 6) 합계 계산
     * 7) 선수금/여신 자동 충당 계산
     * 8) tb_order / tb_order_line 저장
     * 9) 선수금 / 여신 원장 반영
     * 10) 세금문서 대기건 생성
     * </pre>
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createOrder(Map<String, Object> param) throws Exception {

        validateOrderRequest(param);

        Long tenantId = getLong(param, "tenantId");
        Long sellerCompanyId = getLong(param, "sellerCompanyId");
        Long buyerCompanyId = getLong(param, "buyerCompanyId");
        Long channelId = getLong(param, "channelId");
        Long orderedByUserId = getLong(param, "orderedByUserId");

        List<Map<String, Object>> lineList = getMapList(param, "lines");
        require(!lineList.isEmpty(), "ORDER_001:주문상품은 1건 이상 필요합니다.");

        // 1. 상품 ID 수집
        List<Long> productIdList = new ArrayList<>();
        for (Map<String, Object> line : lineList) {
            Long productId = getLong(line, "productId");
            require(productId != null, "ORDER_002:상품 ID는 필수입니다.");
            if (!productIdList.contains(productId)) {
                productIdList.add(productId);
            }
        }

        // 2. 상품 조회
        List<Map<String, Object>> productList = mapper.selectProductsForOrder(productIdList);
        Map<Long, Map<String, Object>> productMap = toLongKeyMap(productList, "productId");
        require(productMap.size() == productIdList.size(), "ORDER_003:유효하지 않은 상품이 포함되어 있습니다.");

        // 3. 승인된 세금규칙 조회
        List<Map<String, Object>> taxRuleList = mapper.selectApprovedTaxRulesByProductIds(productIdList);
        Map<Long, Map<String, Object>> taxRuleMap = toLongKeyMap(taxRuleList, "productId");

        BigDecimal taxFreeSupplyAmount = ZERO;
        BigDecimal taxableSupplyAmount = ZERO;
        BigDecimal vatAmount = ZERO;
        BigDecimal totalAmount = ZERO;

        int lineNo = 1;

        for (Map<String, Object> line : lineList) {
            Long productId = getLong(line, "productId");
            BigDecimal qty = scaleQty(getBigDecimal(line, "qty"));
            require(qty.compareTo(BigDecimal.ZERO) > 0, "ORDER_004:수량은 0보다 커야 합니다.");

            Map<String, Object> product = productMap.get(productId);
            require(product != null, "ORDER_005:상품 정보를 찾을 수 없습니다. productId=" + productId);

            String saleStatus = getString(product, "saleStatus");
            require("ON_SALE".equals(saleStatus), "ORDER_006:판매 중이 아닌 상품이 포함되어 있습니다. productId=" + productId);

            Map<String, Object> taxRule = taxRuleMap.get(productId);
            require(taxRule != null, "ORDER_007:승인된 세금 규칙이 없는 상품입니다. productId=" + productId);

            BigDecimal unitPrice = resolveUnitPrice(tenantId, buyerCompanyId, channelId, productId, line);
            BigDecimal supplyAmount = money(unitPrice.multiply(qty));
            String taxCategory = getString(taxRule, "taxCategory");
            BigDecimal lineVatAmount = "TAXABLE".equals(taxCategory)
                    ? money(supplyAmount.multiply(VAT_RATE))
                    : ZERO;
            BigDecimal lineTotalAmount = money(supplyAmount.add(lineVatAmount));

            // snapshot 세팅
            line.put("lineNo", lineNo++);
            line.put("productNameSnapshot", getString(product, "productName"));
            line.put("itemKindSnapshot", getString(product, "itemKind"));
            line.put("processingTypeSnapshot", getString(product, "processingType"));
            line.put("taxCategorySnapshot", taxCategory);
            line.put("taxRuleIdSnapshot", getLong(taxRule, "taxRuleId"));
            line.put("unitNameSnapshot", getString(product, "unitName"));
            line.put("qty", qty);
            line.put("unitPrice", unitPrice);
            line.put("supplyAmount", supplyAmount);
            line.put("vatAmount", lineVatAmount);
            line.put("totalAmount", lineTotalAmount);

            String itemKind = getString(product, "itemKind");
            String shipmentStatus = "SERVICE".equals(itemKind) ? "NOT_APPLICABLE" : "WAITING";
            line.put("shipmentStatus", shipmentStatus);

            if (isBlank(getString(line, "relationGroupId"))) {
                line.put("relationGroupId", UUID.randomUUID().toString().replace("-", "").substring(0, 16));
            }

            if ("TAXABLE".equals(taxCategory)) {
                taxableSupplyAmount = money(taxableSupplyAmount.add(supplyAmount));
                vatAmount = money(vatAmount.add(lineVatAmount));
            } else {
                taxFreeSupplyAmount = money(taxFreeSupplyAmount.add(supplyAmount));
            }

            totalAmount = money(totalAmount.add(lineTotalAmount));
        }

        // 4. 자금 요약 조회
        Map<String, Object> fundingSummary = mapper.selectBuyerFundingSummary(tenantId, sellerCompanyId, buyerCompanyId);
        BigDecimal advanceBalance = fundingSummary == null ? ZERO : money(getBigDecimal(fundingSummary, "advanceBalance"));
        BigDecimal usedCreditAmount = fundingSummary == null ? ZERO : money(getBigDecimal(fundingSummary, "usedCreditAmount"));
        BigDecimal availableCreditAmount = fundingSummary == null ? ZERO : money(getBigDecimal(fundingSummary, "availableCreditAmount"));

        // 5. 자동 충당 정책: 선수금 우선 -> 여신
        BigDecimal allocatedAdvanceAmount = min(totalAmount, advanceBalance);
        BigDecimal remainAfterAdvance = money(totalAmount.subtract(allocatedAdvanceAmount));
        BigDecimal allocatedCreditAmount = min(remainAfterAdvance, availableCreditAmount);
        BigDecimal allocatedCashAmount = ZERO;

        BigDecimal allocatedTotal = money(allocatedAdvanceAmount.add(allocatedCreditAmount).add(allocatedCashAmount));

        String paymentStatus;
        if (allocatedTotal.compareTo(ZERO) == 0) {
            paymentStatus = "UNPAID";
        } else if (allocatedTotal.compareTo(totalAmount) < 0) {
            paymentStatus = "PARTIAL_ALLOCATED";
        } else {
            paymentStatus = "ALLOCATED";
        }

        // 6. 주문 헤더 기본값 세팅
        if (isBlank(getString(param, "orderNo"))) {
            param.put("orderNo", generateOrderNo());
        }
        param.put("orderStatus", defaultString(getString(param, "orderStatus"), "PLACED"));
        param.put("paymentStatus", paymentStatus);
        param.put("taxFreeSupplyAmount", taxFreeSupplyAmount);
        param.put("taxableSupplyAmount", taxableSupplyAmount);
        param.put("vatAmount", vatAmount);
        param.put("totalAmount", totalAmount);
        param.put("allocatedAdvanceAmount", allocatedAdvanceAmount);
        param.put("allocatedCreditAmount", allocatedCreditAmount);
        param.put("allocatedCashAmount", allocatedCashAmount);
        if (param.get("orderedAt") == null) {
            param.put("orderedAt", new Date());
        }
        param.put("orderedByUserId", orderedByUserId);

        // 7. 주문 저장
        mapper.insertOrder(param);
        Long orderId = getLong(param, "orderId");
        require(orderId != null, "ORDER_008:주문 저장 후 orderId를 확인할 수 없습니다.");

        for (Map<String, Object> line : lineList) {
            line.put("orderId", orderId);
            mapper.insertOrderLine(line);
        }

        // 8. 선수금 차감 원장
        if (allocatedAdvanceAmount.compareTo(ZERO) > 0) {
            BigDecimal newAdvanceBalance = money(advanceBalance.subtract(allocatedAdvanceAmount));

            Map<String, Object> advanceLedger = new HashMap<>();
            advanceLedger.put("tenantId", tenantId);
            advanceLedger.put("sellerCompanyId", sellerCompanyId);
            advanceLedger.put("buyerCompanyId", buyerCompanyId);
            advanceLedger.put("txnType", "ORDER_ALLOCATED");
            advanceLedger.put("externalPaymentId", null);
            advanceLedger.put("orderId", orderId);
            advanceLedger.put("amount", allocatedAdvanceAmount.negate());
            advanceLedger.put("balanceAfter", newAdvanceBalance);
            advanceLedger.put("memo", "주문 자동충당");
            advanceLedger.put("txnAt", new Date());
            advanceLedger.put("createdBy", orderedByUserId);
            mapper.insertBuyerAdvanceLedger(advanceLedger);

            Map<String, Object> allocation = new HashMap<>();
            allocation.put("orderId", orderId);
            allocation.put("sourceType", "ADVANCE");
            allocation.put("sourceRefId", getLong(advanceLedger, "advanceLedgerId"));
            allocation.put("allocatedAmount", allocatedAdvanceAmount);
            allocation.put("allocatedAt", new Date());
            allocation.put("createdBy", orderedByUserId);
            mapper.insertPaymentAllocation(allocation);
        }

        // 9. 여신 사용 원장
        if (allocatedCreditAmount.compareTo(ZERO) > 0) {
            BigDecimal newUsedCreditAmount = money(usedCreditAmount.add(allocatedCreditAmount));

            Map<String, Object> creditLedger = new HashMap<>();
            creditLedger.put("tenantId", tenantId);
            creditLedger.put("sellerCompanyId", sellerCompanyId);
            creditLedger.put("buyerCompanyId", buyerCompanyId);
            creditLedger.put("txnType", "ORDER_USE");
            creditLedger.put("orderId", orderId);
            creditLedger.put("amount", allocatedCreditAmount);
            creditLedger.put("balanceAfter", newUsedCreditAmount);
            creditLedger.put("memo", "주문 여신 사용");
            creditLedger.put("txnAt", new Date());
            creditLedger.put("createdBy", orderedByUserId);
            mapper.insertBuyerCreditLedger(creditLedger);

            Map<String, Object> allocation = new HashMap<>();
            allocation.put("orderId", orderId);
            allocation.put("sourceType", "CREDIT");
            allocation.put("sourceRefId", getLong(creditLedger, "creditLedgerId"));
            allocation.put("allocatedAmount", allocatedCreditAmount);
            allocation.put("allocatedAt", new Date());
            allocation.put("createdBy", orderedByUserId);
            mapper.insertPaymentAllocation(allocation);
        }

        // 10. 세금문서 대기건 생성
        mapper.insertTaxDocumentsByOrderId(orderId);

        // TODO: auditService.insertOrderAudit(...)

        return orderId;
    }

    // =========================================================
    // 입금 확정
    // =========================================================

    /**
     * 입금 확정
     *
     * <pre>
     * ADVANCE_DEPOSIT   : 선수금 적립
     * ORDER_PAYMENT     : 주문 직접 충당
     * CREDIT_SETTLEMENT : 여신 상환 후 잔여는 선수금
     * </pre>
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long confirmDeposit(Map<String, Object> param) throws Exception {

        Long tenantId = getLong(param, "tenantId");
        Long sellerCompanyId = getLong(param, "sellerCompanyId");
        Long buyerCompanyId = getLong(param, "buyerCompanyId");
        Long receiptBankAccountId = getLong(param, "receiptBankAccountId");
        Long matchedOrderId = getLong(param, "matchedOrderId");
        Long createdBy = getLong(param, "createdBy");

        String bankTxnRef = getString(param, "bankTxnRef");
        String paymentType = getString(param, "paymentType");
        BigDecimal depositedAmount = money(getBigDecimal(param, "depositedAmount"));

        require(tenantId != null, "PAY_001:tenantId는 필수입니다.");
        require(sellerCompanyId != null, "PAY_002:sellerCompanyId는 필수입니다.");
        require(receiptBankAccountId != null, "PAY_003:receiptBankAccountId는 필수입니다.");
        require(!isBlank(bankTxnRef), "PAY_004:bankTxnRef는 필수입니다.");
        require(depositedAmount.compareTo(ZERO) > 0, "PAY_005:입금액은 0보다 커야 합니다.");
        require(in(paymentType, "ADVANCE_DEPOSIT", "ORDER_PAYMENT", "CREDIT_SETTLEMENT"),
                "PAY_006:지원하지 않는 paymentType입니다.");

        // 1. 중복 거래 확인
        Map<String, Object> duplicated = mapper.selectExternalPaymentByBankTxnRef(bankTxnRef);
        require(duplicated == null, "PAY_007:이미 처리된 은행 거래입니다.");

        // 2. 수납계좌 검증
        Map<String, Object> receiptBank = mapper.selectReceiptBankAccountValidation(receiptBankAccountId);
        require(receiptBank != null, "PAY_008:유효하지 않은 수납계좌입니다.");
        require("ACTIVE".equals(getString(receiptBank, "status")), "PAY_009:비활성 수납계좌입니다.");
        require(sellerCompanyId.equals(getLong(receiptBank, "companyId")), "PAY_010:판매업체 수납계좌가 아닙니다.");
        require(tenantId.equals(getLong(receiptBank, "tenantId")), "PAY_011:테넌트가 일치하지 않습니다.");

        // 3. 외부입금 저장
        if (param.get("depositedAt") == null) {
            param.put("depositedAt", new Date());
        }

        String initialMatchStatus = "UNMATCHED";
        if ("ADVANCE_DEPOSIT".equals(paymentType) && buyerCompanyId != null) {
            initialMatchStatus = "MATCHED";
        }
        if ("ORDER_PAYMENT".equals(paymentType) && matchedOrderId != null) {
            initialMatchStatus = "MATCHED";
        }
        if ("CREDIT_SETTLEMENT".equals(paymentType) && buyerCompanyId != null) {
            initialMatchStatus = "MATCHED";
        }

        param.put("matchStatus", initialMatchStatus);
        mapper.insertExternalPaymentTxn(param);

        Long externalPaymentId = getLong(param, "externalPaymentId");
        require(externalPaymentId != null, "PAY_012:외부입금 저장 후 externalPaymentId가 없습니다.");

        // 4. 유형별 처리
        if ("ADVANCE_DEPOSIT".equals(paymentType)) {
            require(buyerCompanyId != null, "PAY_013:선수금 입금은 buyerCompanyId가 필요합니다.");
            addAdvanceDeposit(tenantId, sellerCompanyId, buyerCompanyId, externalPaymentId, depositedAmount,
                    "선수금 입금 확정", createdBy);

        } else if ("ORDER_PAYMENT".equals(paymentType)) {
            require(matchedOrderId != null, "PAY_014:주문 직접 충당은 matchedOrderId가 필요합니다.");
            applyExternalPaymentToOrder(externalPaymentId, matchedOrderId, depositedAmount, buyerCompanyId, createdBy);

        } else if ("CREDIT_SETTLEMENT".equals(paymentType)) {
            require(buyerCompanyId != null, "PAY_015:여신상환 입금은 buyerCompanyId가 필요합니다.");
            settleCreditThenAdvance(tenantId, sellerCompanyId, buyerCompanyId, externalPaymentId, depositedAmount, createdBy);
        }

        // TODO: auditService.insertPaymentAudit(...)

        return externalPaymentId;
    }

    // =========================================================
    // 여신한도 수정
    // =========================================================

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateCreditLimit(Map<String, Object> param) throws Exception {

        Long tenantId = getLong(param, "tenantId");
        Long sellerCompanyId = getLong(param, "sellerCompanyId");
        Long buyerCompanyId = getLong(param, "buyerCompanyId");
        Long approvedBy = getLong(param, "approvedBy");
        Long requestedBy = getLong(param, "requestedBy");

        BigDecimal newLimitAmount = money(getBigDecimal(param, "creditLimitAmount"));
        Integer paymentTermsDays = getInteger(param, "paymentTermsDays", 0);
        String status = defaultString(getString(param, "status"), "ACTIVE");
        String reason = defaultString(getString(param, "reason"), "여신한도 변경");

        require(tenantId != null, "CREDIT_001:tenantId는 필수입니다.");
        require(sellerCompanyId != null, "CREDIT_002:sellerCompanyId는 필수입니다.");
        require(buyerCompanyId != null, "CREDIT_003:buyerCompanyId는 필수입니다.");
        require(newLimitAmount.compareTo(ZERO) >= 0, "CREDIT_004:여신한도는 0 이상이어야 합니다.");
        require(in(status, "ACTIVE", "INACTIVE"), "CREDIT_005:유효하지 않은 status입니다.");

        Map<String, Object> oldPolicy = mapper.selectCreditPolicy(tenantId, sellerCompanyId, buyerCompanyId);

        if (oldPolicy == null) {
            Map<String, Object> insertParam = new HashMap<>();
            insertParam.put("tenantId", tenantId);
            insertParam.put("sellerCompanyId", sellerCompanyId);
            insertParam.put("buyerCompanyId", buyerCompanyId);
            insertParam.put("creditLimitAmount", newLimitAmount);
            insertParam.put("paymentTermsDays", paymentTermsDays);
            insertParam.put("status", status);
            insertParam.put("approvedBy", approvedBy);
            insertParam.put("approvedAt", new Date());

            mapper.insertBuyerCreditPolicy(insertParam);

            Map<String, Object> hist = new HashMap<>();
            hist.put("creditPolicyId", getLong(insertParam, "creditPolicyId"));
            hist.put("oldLimitAmount", ZERO);
            hist.put("newLimitAmount", newLimitAmount);
            hist.put("reason", reason);
            hist.put("requestedBy", requestedBy);
            hist.put("approvedBy", approvedBy);
            hist.put("approvedAt", new Date());
            mapper.insertCreditLimitHistory(hist);

        } else {
            BigDecimal oldLimitAmount = money(getBigDecimal(oldPolicy, "creditLimitAmount"));

            Map<String, Object> updateParam = new HashMap<>();
            updateParam.put("creditPolicyId", getLong(oldPolicy, "creditPolicyId"));
            updateParam.put("creditLimitAmount", newLimitAmount);
            updateParam.put("paymentTermsDays", paymentTermsDays);
            updateParam.put("status", status);
            updateParam.put("approvedBy", approvedBy);
            updateParam.put("approvedAt", new Date());
            mapper.updateBuyerCreditPolicy(updateParam);

            Map<String, Object> hist = new HashMap<>();
            hist.put("creditPolicyId", getLong(oldPolicy, "creditPolicyId"));
            hist.put("oldLimitAmount", oldLimitAmount);
            hist.put("newLimitAmount", newLimitAmount);
            hist.put("reason", reason);
            hist.put("requestedBy", requestedBy);
            hist.put("approvedBy", approvedBy);
            hist.put("approvedAt", new Date());
            mapper.insertCreditLimitHistory(hist);
        }

        // TODO: auditService.insertCreditLimitAudit(...)
    }

    // =========================================================
    // 출고 생성
    // =========================================================

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createShipment(Map<String, Object> param) throws Exception {

        Long orderId = getLong(param, "orderId");
        Long createdBy = getLong(param, "createdBy");
        require(orderId != null, "SHIP_001:orderId는 필수입니다.");

        Map<String, Object> order = mapper.selectOrderDetail(orderId);
        require(order != null, "SHIP_002:주문을 찾을 수 없습니다.");

        Long tenantId = getLong(order, "tenantId");
        List<Map<String, Object>> requestLines = getMapList(param, "lines");
        require(!requestLines.isEmpty(), "SHIP_003:출고 라인은 1건 이상 필요합니다.");

        List<Map<String, Object>> orderLines = mapper.selectOrderLinesByOrderId(orderId);
        Map<Long, Map<String, Object>> orderLineMap = toLongKeyMap(orderLines, "orderLineId");
        Map<Long, BigDecimal> shippedQtyMap = loadExistingShippedQtyMap(orderId);

        Map<String, Object> shipmentParam = new HashMap<>();
        shipmentParam.put("tenantId", tenantId);
        shipmentParam.put("orderId", orderId);
        shipmentParam.put("shipmentNo", defaultString(getString(param, "shipmentNo"), generateShipmentNo()));
        shipmentParam.put("shipmentStatus", "READY");
        shipmentParam.put("shippingCompany", getString(param, "shippingCompany"));
        shipmentParam.put("trackingNo", getString(param, "trackingNo"));
        shipmentParam.put("shippedAt", null);
        shipmentParam.put("createdBy", createdBy);

        mapper.insertShipment(shipmentParam);
        Long shipmentId = getLong(shipmentParam, "shipmentId");
        require(shipmentId != null, "SHIP_004:shipmentId 생성 실패");

        for (Map<String, Object> reqLine : requestLines) {
            Long orderLineId = getLong(reqLine, "orderLineId");
            BigDecimal shippedQty = scaleQty(getBigDecimal(reqLine, "shippedQty"));
            Long lotId = getLong(reqLine, "lotId");

            require(orderLineId != null, "SHIP_005:orderLineId는 필수입니다.");
            require(shippedQty.compareTo(BigDecimal.ZERO) > 0, "SHIP_006:출고수량은 0보다 커야 합니다.");

            Map<String, Object> orderLine = orderLineMap.get(orderLineId);
            require(orderLine != null, "SHIP_007:주문라인을 찾을 수 없습니다. orderLineId=" + orderLineId);

            String itemKindSnapshot = getString(orderLine, "itemKindSnapshot");
            require(!"SERVICE".equals(itemKindSnapshot), "SHIP_008:서비스 라인은 출고 대상이 아닙니다.");

            Long productId = getLong(orderLine, "productId");
            BigDecimal orderedQty = scaleQty(getBigDecimal(orderLine, "qty"));

            // LOT 검증 및 차감
            if (lotId != null) {
                List<Map<String, Object>> lots = mapper.selectAvailableLotsByProduct(productId);
                Map<Long, Map<String, Object>> lotMap = toLongKeyMap(lots, "lotId");
                Map<String, Object> lot = lotMap.get(lotId);

                require(lot != null, "SHIP_009:사용 가능한 LOT가 아닙니다. lotId=" + lotId);

                BigDecimal currentQty = scaleQty(getBigDecimal(lot, "currentQty"));
                require(currentQty.compareTo(shippedQty) >= 0, "SHIP_010:LOT 재고가 부족합니다.");

                BigDecimal newQty = scaleQty(currentQty.subtract(shippedQty));
                mapper.updateStockLotCurrentQty(lotId, newQty);
            }

            Map<String, Object> shipmentLine = new HashMap<>();
            shipmentLine.put("shipmentId", shipmentId);
            shipmentLine.put("orderLineId", orderLineId);
            shipmentLine.put("productId", productId);
            shipmentLine.put("lotId", lotId);
            shipmentLine.put("shippedQty", shippedQty);
            mapper.insertShipmentLine(shipmentLine);

            Long shipmentLineId = getLong(shipmentLine, "shipmentLineId");

            // 재고원장 OUT
            Map<String, Object> stockLedger = new HashMap<>();
            stockLedger.put("tenantId", tenantId);
            stockLedger.put("productId", productId);
            stockLedger.put("lotId", lotId);
            stockLedger.put("txnType", "OUT");
            stockLedger.put("qty", shippedQty);
            stockLedger.put("refTable", "tb_shipment_line");
            stockLedger.put("refId", shipmentLineId);
            stockLedger.put("memo", "출고 처리");
            stockLedger.put("txnAt", new Date());
            stockLedger.put("createdBy", createdBy);
            mapper.insertStockLedger(stockLedger);

            // 누적 출고량 계산
            BigDecimal prevShippedQty = shippedQtyMap.getOrDefault(orderLineId, ZERO);
            BigDecimal totalShippedQty = scaleQty(prevShippedQty.add(shippedQty));
            shippedQtyMap.put(orderLineId, totalShippedQty);

            String lineShipmentStatus = totalShippedQty.compareTo(orderedQty) >= 0 ? "DONE" : "PARTIAL";
            mapper.updateOrderLineShipmentStatus(orderLineId, lineShipmentStatus);
        }

        mapper.updateShipmentStatus(buildShipmentStatusParam(shipmentId, "DONE", new Date()));

        // 주문 전체 출고 상태 재계산
        String orderStatus = resolveOrderShipmentStatus(orderLines, shippedQtyMap);
        mapper.updateOrderStatus(orderId, orderStatus);

        // TODO: auditService.insertShipmentAudit(...)

        return shipmentId;
    }

    // =========================================================
    // 내부 헬퍼 - 주문
    // =========================================================

    private void validateOrderRequest(Map<String, Object> param) {
        require(getLong(param, "tenantId") != null, "ORDER_101:tenantId는 필수입니다.");
        require(getLong(param, "sellerCompanyId") != null, "ORDER_102:sellerCompanyId는 필수입니다.");
        require(getLong(param, "buyerCompanyId") != null, "ORDER_103:buyerCompanyId는 필수입니다.");
        require(param.get("lines") != null, "ORDER_104:주문라인(lines)은 필수입니다.");
    }

    private BigDecimal resolveUnitPrice(Long tenantId,
                                        Long buyerCompanyId,
                                        Long channelId,
                                        Long productId,
                                        Map<String, Object> line) throws Exception {

        BigDecimal manualUnitPrice = getBigDecimal(line, "unitPrice");
        if (manualUnitPrice.compareTo(ZERO) > 0) {
            return money(manualUnitPrice);
        }

        Map<String, Object> priceParam = new HashMap<>();
        priceParam.put("tenantId", tenantId);
        priceParam.put("buyerCompanyId", buyerCompanyId);
        priceParam.put("channelId", channelId);
        priceParam.put("productId", productId);

        Map<String, Object> price = mapper.selectApplicablePrice(priceParam);
        require(price != null, "ORDER_105:적용 가능한 가격이 없습니다. productId=" + productId);

        BigDecimal unitPrice = getBigDecimal(price, "unitPrice");
        require(unitPrice.compareTo(ZERO) >= 0, "ORDER_106:유효하지 않은 가격입니다. productId=" + productId);

        return money(unitPrice);
    }

    // =========================================================
    // 내부 헬퍼 - 입금
    // =========================================================

    private void addAdvanceDeposit(Long tenantId,
                                   Long sellerCompanyId,
                                   Long buyerCompanyId,
                                   Long externalPaymentId,
                                   BigDecimal amount,
                                   String memo,
                                   Long createdBy) throws Exception {

        BigDecimal advanceBalance = safeBalance(mapper.selectLatestAdvanceBalance(tenantId, sellerCompanyId, buyerCompanyId));
        BigDecimal newBalance = money(advanceBalance.add(amount));

        Map<String, Object> ledger = new HashMap<>();
        ledger.put("tenantId", tenantId);
        ledger.put("sellerCompanyId", sellerCompanyId);
        ledger.put("buyerCompanyId", buyerCompanyId);
        ledger.put("txnType", "DEPOSIT_CONFIRMED");
        ledger.put("externalPaymentId", externalPaymentId);
        ledger.put("orderId", null);
        ledger.put("amount", money(amount));
        ledger.put("balanceAfter", newBalance);
        ledger.put("memo", memo);
        ledger.put("txnAt", new Date());
        ledger.put("createdBy", createdBy);
        mapper.insertBuyerAdvanceLedger(ledger);
    }

    private void applyExternalPaymentToOrder(Long externalPaymentId,
                                             Long orderId,
                                             BigDecimal depositedAmount,
                                             Long buyerCompanyIdFromRequest,
                                             Long createdBy) throws Exception {

        Map<String, Object> order = mapper.selectOrderDetail(orderId);
        require(order != null, "PAY_201:주문을 찾을 수 없습니다.");

        Long tenantId = getLong(order, "tenantId");
        Long sellerCompanyId = getLong(order, "sellerCompanyId");
        Long buyerCompanyId = getLong(order, "buyerCompanyId");

        if (buyerCompanyIdFromRequest != null) {
            require(buyerCompanyId.equals(buyerCompanyIdFromRequest), "PAY_202:주문의 구매업체와 입금 구매업체가 다릅니다.");
        }

        BigDecimal totalAmount = money(getBigDecimal(order, "totalAmount"));
        BigDecimal allocatedAdvanceAmount = money(getBigDecimal(order, "allocatedAdvanceAmount"));
        BigDecimal allocatedCreditAmount = money(getBigDecimal(order, "allocatedCreditAmount"));
        BigDecimal allocatedCashAmount = money(getBigDecimal(order, "allocatedCashAmount"));

        BigDecimal alreadyAllocated = money(allocatedAdvanceAmount.add(allocatedCreditAmount).add(allocatedCashAmount));
        BigDecimal remain = money(totalAmount.subtract(alreadyAllocated));
        require(remain.compareTo(ZERO) > 0, "PAY_203:이미 전액 충당된 주문입니다.");

        BigDecimal orderAppliedAmount = min(depositedAmount, remain);
        BigDecimal extraAmount = money(depositedAmount.subtract(orderAppliedAmount));

        if (orderAppliedAmount.compareTo(ZERO) > 0) {
            Map<String, Object> allocation = new HashMap<>();
            allocation.put("orderId", orderId);
            allocation.put("sourceType", "EXTERNAL_PAYMENT");
            allocation.put("sourceRefId", externalPaymentId);
            allocation.put("allocatedAmount", orderAppliedAmount);
            allocation.put("allocatedAt", new Date());
            allocation.put("createdBy", createdBy);
            mapper.insertPaymentAllocation(allocation);

            BigDecimal newAllocatedCashAmount = money(allocatedCashAmount.add(orderAppliedAmount));
            BigDecimal newAllocatedTotal = money(allocatedAdvanceAmount.add(allocatedCreditAmount).add(newAllocatedCashAmount));

            String paymentStatus = newAllocatedTotal.compareTo(totalAmount) >= 0
                    ? "ALLOCATED"
                    : "PARTIAL_ALLOCATED";

            Map<String, Object> updateParam = new HashMap<>();
            updateParam.put("orderId", orderId);
            updateParam.put("paymentStatus", paymentStatus);
            updateParam.put("allocatedAdvanceAmount", allocatedAdvanceAmount);
            updateParam.put("allocatedCreditAmount", allocatedCreditAmount);
            updateParam.put("allocatedCashAmount", newAllocatedCashAmount);
            mapper.updateOrderPaymentSummary(updateParam);
        }

        // 주문 직접입금인데 남는 금액이 있으면 선수금으로 자동 적립
        if (extraAmount.compareTo(ZERO) > 0 && buyerCompanyId != null) {
            addAdvanceDeposit(tenantId, sellerCompanyId, buyerCompanyId, externalPaymentId, extraAmount,
                    "주문 직접입금 초과분 선수금 적립", createdBy);
        }

        Map<String, Object> updateMatch = new HashMap<>();
        updateMatch.put("externalPaymentId", externalPaymentId);
        updateMatch.put("matchStatus", "MATCHED");
        updateMatch.put("matchedOrderId", orderId);
        mapper.updateExternalPaymentMatch(updateMatch);
    }

    private void settleCreditThenAdvance(Long tenantId,
                                         Long sellerCompanyId,
                                         Long buyerCompanyId,
                                         Long externalPaymentId,
                                         BigDecimal depositedAmount,
                                         Long createdBy) throws Exception {

        BigDecimal usedCreditBalance = safeBalance(mapper.selectLatestCreditBalance(tenantId, sellerCompanyId, buyerCompanyId));
        BigDecimal creditOffsetAmount = min(depositedAmount, usedCreditBalance);
        BigDecimal remainAmount = money(depositedAmount.subtract(creditOffsetAmount));

        if (creditOffsetAmount.compareTo(ZERO) > 0) {
            BigDecimal newUsedCreditBalance = money(usedCreditBalance.subtract(creditOffsetAmount));

            Map<String, Object> creditLedger = new HashMap<>();
            creditLedger.put("tenantId", tenantId);
            creditLedger.put("sellerCompanyId", sellerCompanyId);
            creditLedger.put("buyerCompanyId", buyerCompanyId);
            creditLedger.put("txnType", "PAYMENT_OFFSET");
            creditLedger.put("orderId", null);
            creditLedger.put("amount", creditOffsetAmount.negate());
            creditLedger.put("balanceAfter", newUsedCreditBalance);
            creditLedger.put("memo", "여신 상환 입금");
            creditLedger.put("txnAt", new Date());
            creditLedger.put("createdBy", createdBy);
            mapper.insertBuyerCreditLedger(creditLedger);
        }

        if (remainAmount.compareTo(ZERO) > 0) {
            addAdvanceDeposit(tenantId, sellerCompanyId, buyerCompanyId, externalPaymentId, remainAmount,
                    "여신 상환 후 잔여금 선수금 적립", createdBy);
        }
    }

    // =========================================================
    // 내부 헬퍼 - 출고
    // =========================================================

    private Map<Long, BigDecimal> loadExistingShippedQtyMap(Long orderId) throws Exception {
        Map<Long, BigDecimal> result = new HashMap<>();

        List<Map<String, Object>> shipments = mapper.selectShipmentListByOrderId(orderId);
        for (Map<String, Object> shipment : shipments) {
            Long shipmentId = getLong(shipment, "shipmentId");
            List<Map<String, Object>> lines = mapper.selectShipmentLinesByShipmentId(shipmentId);
            for (Map<String, Object> line : lines) {
                Long orderLineId = getLong(line, "orderLineId");
                BigDecimal shippedQty = scaleQty(getBigDecimal(line, "shippedQty"));
                result.put(orderLineId, scaleQty(result.getOrDefault(orderLineId, ZERO).add(shippedQty)));
            }
        }

        return result;
    }

    private String resolveOrderShipmentStatus(List<Map<String, Object>> orderLines,
                                              Map<Long, BigDecimal> shippedQtyMap) {

        boolean hasAnyShipped = false;
        boolean allCompleted = true;

        for (Map<String, Object> orderLine : orderLines) {
            Long orderLineId = getLong(orderLine, "orderLineId");
            String itemKind = getString(orderLine, "itemKindSnapshot");
            BigDecimal orderedQty = scaleQty(getBigDecimal(orderLine, "qty"));

            if ("SERVICE".equals(itemKind)) {
                continue;
            }

            BigDecimal shippedQty = shippedQtyMap.getOrDefault(orderLineId, ZERO);
            if (shippedQty.compareTo(ZERO) > 0) {
                hasAnyShipped = true;
            }
            if (shippedQty.compareTo(orderedQty) < 0) {
                allCompleted = false;
            }
        }

        if (allCompleted && hasAnyShipped) {
            return "SHIPPED";
        }
        if (hasAnyShipped) {
            return "PARTIAL_SHIPPED";
        }
        return "CONFIRMED";
    }

    private Map<String, Object> buildShipmentStatusParam(Long shipmentId, String shipmentStatus, Date shippedAt) {
        Map<String, Object> param = new HashMap<>();
        param.put("shipmentId", shipmentId);
        param.put("shipmentStatus", shipmentStatus);
        param.put("shippedAt", shippedAt);
        return param;
    }

    // =========================================================
    // 공통 유틸
    // =========================================================

    private String generateOrderNo() {
        return "ORD-" + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())
                + "-" + String.format("%04d", new Random().nextInt(10000));
    }

    private String generateShipmentNo() {
        return "SHP-" + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())
                + "-" + String.format("%04d", new Random().nextInt(10000));
    }

    private BigDecimal safeBalance(BigDecimal value) {
        return value == null ? ZERO : money(value);
    }

    private BigDecimal min(BigDecimal a, BigDecimal b) {
        return a.compareTo(b) <= 0 ? a : b;
    }

    private BigDecimal money(BigDecimal value) {
        if (value == null) {
            return ZERO;
        }
        return value.setScale(2, RoundingMode.HALF_UP);
    }

    private BigDecimal scaleQty(BigDecimal value) {
        if (value == null) {
            return BigDecimal.ZERO.setScale(3, RoundingMode.HALF_UP);
        }
        return value.setScale(3, RoundingMode.HALF_UP);
    }

    private void require(boolean condition, String message) {
        if (!condition) {
            throw new IllegalArgumentException(message);
        }
    }

    private boolean in(String value, String... candidates) {
        if (value == null) {
            return false;
        }
        for (String candidate : candidates) {
            if (value.equals(candidate)) {
                return true;
            }
        }
        return false;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String defaultString(String value, String defaultValue) {
        return isBlank(value) ? defaultValue : value;
    }

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> getMapList(Map<String, Object> map, String key) {
        Object value = map.get(key);
        if (value == null) {
            return new ArrayList<>();
        }
        return (List<Map<String, Object>>) value;
    }

    private String getString(Map<String, Object> map, String key) {
        if (map == null || map.get(key) == null) {
            return null;
        }
        return String.valueOf(map.get(key));
    }

    private Long getLong(Map<String, Object> map, String key) {
        if (map == null || map.get(key) == null) {
            return null;
        }
        Object value = map.get(key);
        if (value instanceof Long) {
            return (Long) value;
        }
        if (value instanceof Integer) {
            return ((Integer) value).longValue();
        }
        if (value instanceof BigDecimal) {
            return ((BigDecimal) value).longValue();
        }
        if (value instanceof Number) {
            return ((Number) value).longValue();
        }
        String s = String.valueOf(value).trim();
        return s.isEmpty() ? null : Long.parseLong(s);
    }

    private Integer getInteger(Map<String, Object> map, String key, Integer defaultValue) {
        if (map == null || map.get(key) == null) {
            return defaultValue;
        }
        Object value = map.get(key);
        if (value instanceof Integer) {
            return (Integer) value;
        }
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        String s = String.valueOf(value).trim();
        return s.isEmpty() ? defaultValue : Integer.parseInt(s);
    }

    private BigDecimal getBigDecimal(Map<String, Object> map, String key) {
        if (map == null || map.get(key) == null) {
            return ZERO;
        }
        Object value = map.get(key);
        if (value instanceof BigDecimal) {
            return (BigDecimal) value;
        }
        if (value instanceof Long) {
            return BigDecimal.valueOf((Long) value);
        }
        if (value instanceof Integer) {
            return BigDecimal.valueOf((Integer) value);
        }
        if (value instanceof Double) {
            return BigDecimal.valueOf((Double) value);
        }
        if (value instanceof Float) {
            return BigDecimal.valueOf(((Float) value).doubleValue());
        }
        String s = String.valueOf(value).trim();
        if (s.isEmpty()) {
            return ZERO;
        }
        return new BigDecimal(s);
    }

    private Map<Long, Map<String, Object>> toLongKeyMap(List<Map<String, Object>> list, String keyName) {
        Map<Long, Map<String, Object>> result = new HashMap<>();
        if (list == null) {
            return result;
        }
        for (Map<String, Object> item : list) {
            Long key = getLong(item, keyName);
            if (key != null) {
                result.put(key, item);
            }
        }
        return result;
    }
}


