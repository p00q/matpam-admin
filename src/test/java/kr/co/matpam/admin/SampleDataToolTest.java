package kr.co.matpam.admin;

import java.sql.*;
import org.junit.Test;

public class SampleDataToolTest {
    @Test
    public void injectData() throws Exception {
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String user = "root";
        String pass = "root";
        
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Injecting corrected sample data with FK dependencies...");
            
            String[] queries = {
                // 1. 판매자 회원 (조인용)
                "INSERT INTO TB_MEMBER (MEMBER_ID, MEMBER_TYPE_CD, LOGIN_ID, LOGIN_PWD, COMPANY_NAME, CEO_NAME, BIZ_REG_NO, JOIN_STATUS_CD, MEMBER_GRADE_CD, JOIN_DT, DELIVERY_TYPE_CD, OP_TYPE, USE_YN, DEL_YN, REG_ID, REG_DT, MOD_DT, MEAT_MONEY, CREDIT_LIMIT) " +
                "VALUES (10002, 'ROLE_SELLER', 'seller01', 'password', '대박미트', '이사장', '999-00-11111', 'JOINED', 'GRADE_VIP', NOW(), 'NATIONAL', 'NATIONAL', 'Y', 'N', 'SYSTEM', NOW(), NOW(), 0, 0) " +
                "ON DUPLICATE KEY UPDATE COMPANY_NAME='대박미트', OP_TYPE='NATIONAL'",

                // 2. 구매자 회원
                "INSERT INTO TB_MEMBER (MEMBER_ID, MEMBER_TYPE_CD, LOGIN_ID, LOGIN_PWD, COMPANY_NAME, CEO_NAME, BIZ_REG_NO, JOIN_STATUS_CD, MEMBER_GRADE_CD, JOIN_DT, DELIVERY_TYPE_CD, OP_TYPE, USE_YN, DEL_YN, REG_ID, REG_DT, MOD_DT, MEAT_MONEY, CREDIT_LIMIT) " +
                "VALUES (10011, 'ROLE_BUYER', 'buyer_seoul', 'password', '서울미트식당', '김서울', '111-22-33333', 'JOINED', 'GRADE_VIP', NOW(), 'NATIONAL', 'NATIONAL', 'Y', 'N', 'SYSTEM', NOW(), NOW(), 2500000, 10000000) " +
                "ON DUPLICATE KEY UPDATE COMPANY_NAME='서울미트식당', OP_TYPE='NATIONAL'",

                // 3. 판매 상품 (TB_SALES_PRODUCT) - FK용
                "INSERT INTO TB_SALES_PRODUCT (sales_prod_id, sales_prod_code, sales_prod_name, seller_member_id, list_price, sale_price, vat_rate, VAT_AMOUNT, op_type, exposure_status_cd, sale_status_cd, view_cnt, use_yn, del_yn, reg_id, reg_dt, mod_dt) " +
                "VALUES (3001, 'SP-0001', '한우 특상 등심', 10002, 110000, 100000, 10, 10000, 'NATIONAL', 'EXPOSED', 'ON_SALE', 0, 'Y', 'N', 'SYSTEM', NOW(), NOW()) " +
                "ON DUPLICATE KEY UPDATE sales_prod_name='한우 특상 등심'",

                "INSERT INTO TB_SALES_PRODUCT (sales_prod_id, sales_prod_code, sales_prod_name, seller_member_id, list_price, sale_price, vat_rate, VAT_AMOUNT, op_type, exposure_status_cd, sale_status_cd, view_cnt, use_yn, del_yn, reg_id, reg_dt, mod_dt) " +
                "VALUES (3002, 'SP-0002', '수입 냉동 수육용', 10002, 55000, 50000, 0, 0, 'LOCAL', 'EXPOSED', 'ON_SALE', 0, 'Y', 'N', 'SYSTEM', NOW(), NOW()) " +
                "ON DUPLICATE KEY UPDATE sales_prod_name='수입 냉동 수육용'",

                // 4. 샘플 주문
                "INSERT INTO TB_ORDER (order_id, order_no, buyer_member_id, order_dt, order_status_cd, delivery_type_cd, delivery_status_cd, payment_status_cd, goods_total_amt, vat_total_amt, pay_total_amt, receiver_name, receiver_mobile, zip_code, addr1, op_type, use_yn, del_yn, reg_id, reg_dt, mod_dt, agree_third_party_yn, agree_safe_service_yn) " +
                "VALUES (50101, 'ORD-20260409-S01', 10011, NOW(), 'ORDERED', 'NATIONAL', 'WAITING', 'PAID', 300000, 30000, 330000, '김서울', '010-1234-5678', '06000', '서울 강남구', 'NATIONAL', 'Y', 'N', 'SYSTEM', NOW(), NOW(), 'Y', 'Y') " +
                "ON DUPLICATE KEY UPDATE order_status_cd='ORDERED', op_type='NATIONAL'",

                // 5. 주문 상세 (TB_ORDER_ITEM)
                "INSERT INTO TB_ORDER_ITEM (order_item_id, order_id, line_no, sales_prod_id, seller_member_id, sales_prod_name, unit_qty, order_qty, list_unit_price, discount_unit_amt, sale_unit_price, goods_amt, delivery_amt, vat_amt, pay_amt, use_yn, del_yn, reg_id, reg_dt, mod_dt, op_type) " +
                "VALUES (60101, 50101, 1, 3001, 10002, '한우 특상 등심', 1, 3, 100000, 0, 100000, 300000, 0, 30000, 330000, 'Y', 'N', 'SYSTEM', NOW(), NOW(), 'NATIONAL') " +
                "ON DUPLICATE KEY UPDATE sales_prod_name='한우 특상 등심'"
            };

            for (String sql : queries) {
                try {
                    stmt.execute(sql);
                } catch (SQLException e) {
                    System.out.println("Error Executing: " + sql);
                    System.out.println(">> Reason: " + e.getMessage());
                }
            }
            System.out.println("Final corrected sample data injected successfully.");
        }
    }
}
