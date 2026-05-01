package kr.co.matpam.admin;

import java.sql.*;

public class ReorderCodes {
    public static void main(String[] args) {
        // DB 연결 정보 (context-common.xml 기준)
        String url = "jdbc:mysql://localhost:3306/matpam?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Seoul";
        String user = "root";
        String password = "root";

        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement()) {
            
            conn.setAutoCommit(false);
            try {
                System.out.println("Cleaning up tb_code sort orders...");
                // 10, 20... 으로 되어 있는 순서를 1, 2... 순차 번호로 재부여
                stmt.executeUpdate(
                    "UPDATE tb_code c " +
                    "JOIN ( " +
                    "    SELECT CODE_GROUP_ID, CODE_ID, " +
                    "           ROW_NUMBER() OVER(PARTITION BY CODE_GROUP_ID ORDER BY SORT_ORDER, CODE_ID) AS new_order " +
                    "    FROM tb_code " +
                    "    WHERE DEL_YN = 'N' " +
                    ") r ON c.CODE_GROUP_ID = r.CODE_GROUP_ID AND c.CODE_ID = r.CODE_ID " +
                    "SET c.SORT_ORDER = r.new_order"
                );

                System.out.println("Cleaning up tb_detail_code sort orders...");
                stmt.executeUpdate(
                    "UPDATE tb_detail_code c " +
                    "JOIN ( " +
                    "    SELECT CODE_GROUP_ID, CODE_ID, DETAIL_CODE_ID, " +
                    "           ROW_NUMBER() OVER(PARTITION BY CODE_GROUP_ID, CODE_ID ORDER BY SORT_ORDER, DETAIL_CODE_ID) AS new_order " +
                    "    FROM tb_detail_code " +
                    "    WHERE DEL_YN = 'N' " +
                    ") r ON c.CODE_GROUP_ID = r.CODE_GROUP_ID AND c.CODE_ID = r.CODE_ID AND c.DETAIL_CODE_ID = r.DETAIL_CODE_ID " +
                    "SET c.SORT_ORDER = r.new_order"
                );

                conn.commit();
                System.out.println("Reordering process completed successfully.");
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            }
            
        } catch (Exception e) {
            System.err.println("Error during reordering: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
