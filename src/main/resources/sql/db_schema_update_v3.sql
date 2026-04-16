-- =========================================================
-- 맛팜(Matpam) 주문 관리 운영 격리 강화 (3단계)
-- =========================================================

-- 1. 택배 배송 정보 테이블 (TB_ORDER_DELIVERY_PARCEL) OP_TYPE 추가
ALTER TABLE tb_order_delivery_parcel ADD COLUMN op_type VARCHAR(20) DEFAULT 'NATIONAL' COMMENT '운영타입(NATIONAL, LOCAL, FACTORY)';

-- 2. 화물/직배송 정보 테이블 (TB_ORDER_DELIVERY_FREIGHT) OP_TYPE 추가
ALTER TABLE tb_order_delivery_freight ADD COLUMN op_type VARCHAR(20) DEFAULT 'NATIONAL' COMMENT '운영타입(NATIONAL, LOCAL, FACTORY)';

-- 3. 공장수령 정보 테이블 (TB_ORDER_DELIVERY_FACTORY) OP_TYPE 추가
ALTER TABLE tb_order_delivery_factory ADD COLUMN op_type VARCHAR(20) DEFAULT 'NATIONAL' COMMENT '운영타입(NATIONAL, LOCAL, FACTORY)';

-- 4. 기존 데이터 보정 (JOIN을 통한 일괄 업데이트 - 필요시)
-- UPDATE tb_order_delivery_parcel p JOIN tb_order o ON p.order_id = o.order_id SET p.op_type = o.op_type;
-- UPDATE tb_order_delivery_freight f JOIN tb_order o ON f.order_id = o.order_id SET f.op_type = o.op_type;
-- UPDATE tb_order_delivery_factory y JOIN tb_order o ON y.order_id = o.order_id SET y.op_type = o.op_type;
