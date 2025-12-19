package kr.co.matpam.admin.product.service;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

/**
 * 구성상품 VO (tb_component_product 기준)
 * - ERD 컬럼 1:1 매핑
 * - 화면 표시를 위한 조인/코드명 필드 일부 포함
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ComponentProductVO implements Serializable {

    // ====== 검색/페이징(egov PaginationInfo 호환) ======
    private Integer pageIndex; // 현재 페이지
    private Integer pageUnit; // 페이지당 목록 개수
    private Integer pageSize; // 페이지 리스트 크기
    private Integer firstIndex;
    private Integer lastIndex;
    private Integer recordCountPerPage;
    private Integer totalRecordCount;
    private Integer totalPageCount;
    private Integer startPage;
    private Integer endPage;
    private Integer searchPage;

    private static final long serialVersionUID = 1L;

    /*
     * =========================================================
     * tb_component_product (PK/기본정보)
     * =========================================================
     */
    /** 구성상품ID (PK) */
    private Long componentProdId;

    /** 구성상품코드 */
    private String componentProdCode;

    /** 구성상품명 */
    private String componentProdName;

    /** 판매자회원ID (tb_member.member_id) */
    private Long sellerMemberId;

    /*
     * =========================================================
     * tb_component_product (상품 속성 코드)
     * =========================================================
     */
    private String saleTypeCd;
    private String storageTypeCd;
    private String cutTypeCd;
    private String processTypeCd;
    private String unitTypeCd;

    /*
     * =========================================================
     * tb_component_product (금액/상태/기간)
     * =========================================================
     */
    private BigDecimal listPrice;
    private BigDecimal costPrice;

    /** 노출상태코드 */
    private String exposureStatusCd;

    /** 판매상태코드 */
    private String saleStatusCd;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date saleStartDt;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date saleEndDt;

    /** 누적판매수량 (ERD: total_sale_qty bigint) */
    private Long totalSaleQty;

    /** 사용여부 */
    private String useYn;

    /** 삭제여부 */
    private String delYn;

    /*
     * =========================================================
     * 공통 등록/수정
     * =========================================================
     */
    private String regId;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date regDt;

    private String modId;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date modDt;

    /*
     * =========================================================
     * 화면 표시용(조인/계산/코드명) - DB컬럼 아님
     * =========================================================
     */
    /** 판매자명 (tb_member.company_name) */
    private String sellerName;

    /** 코드명(조인 결과 표시용) */
    private String saleTypeName;
    private String storageTypeName;
    private String cutTypeName;
    private String processTypeName;
    private String unitTypeName;
    private String exposureStatusName;
    private String saleStatusName;

    /** 부가세 금액 */
    private BigDecimal vatAmount;

    /*
     * =========================================================
     * tb_sales_product_comp 연동용(선택) - 판매상품 구성에서 사용할 때만
     * =========================================================
     */
    /** 판매상품ID */
    private Long salesProdId;

    /** 구성수량 */
    private BigDecimal compQty;

    /** 정렬순서 */
    private Integer sortOrder;

    /** 검색어 */
    private String searchKeyword;

    // ====== 레거시 호환 메서드 (컨트롤러 수정 없이 빌드 통과) ======
    public Date getSaleStartDate() {
        return this.saleStartDt;
    }

    public void setSaleStartDate(Date d) {
        this.saleStartDt = d;
    }

    public Date getSaleEndDate() {
        return this.saleEndDt;
    }

    public void setSaleEndDate(Date d) {
        this.saleEndDt = d;
    }

    /**
     * displayYn이 기존 Y/N이라면:
     * exposureStatusCd 정책이 Y/N이면 그대로 매핑,
     * 코드값이면 여기서 변환 로직을 태우거나, 우선 임시로 동일 저장.
     */
    public String getDisplayYn() {
        return this.exposureStatusCd;
    }

    public void setDisplayYn(String yn) {
        this.exposureStatusCd = yn;
    }

    // productName -> componentProdName alias
    public String getProductName() {
        return this.componentProdName;
    }

    public void setProductName(String name) {
        this.componentProdName = name;
    }

    public String getSearchKeyword() {
        return searchKeyword;
    }

    public void setSearchKeyword(String searchKeyword) {
        this.searchKeyword = searchKeyword;
    }

    public Integer getPageIndex() {
        return pageIndex;
    }

    public void setPageIndex(Integer pageIndex) {
        this.pageIndex = pageIndex;
    }

    public Integer getPageUnit() {
        return pageUnit;
    }

    public void setPageUnit(Integer pageUnit) {
        this.pageUnit = pageUnit;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }

    public Integer getFirstIndex() {
        return firstIndex;
    }

    public void setFirstIndex(Integer firstIndex) {
        this.firstIndex = firstIndex;
    }

    public Integer getLastIndex() {
        return lastIndex;
    }

    public void setLastIndex(Integer lastIndex) {
        this.lastIndex = lastIndex;
    }

    public Integer getRecordCountPerPage() {
        return recordCountPerPage;
    }

    public void setRecordCountPerPage(Integer recordCountPerPage) {
        this.recordCountPerPage = recordCountPerPage;
    }

}
