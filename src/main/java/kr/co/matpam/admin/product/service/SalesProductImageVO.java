package kr.co.matpam.admin.product.service;

import java.io.Serializable;
import java.util.Date;

/**
 * 판매상품 이미지 VO (판매상품 기준 네이밍 통일)
 * - tb_sales_product_image (또는 현행 이미지 테이블) 매핑용
 */
public class SalesProductImageVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 이미지ID(PK) */
    private Long imgId;

    /** 판매상품ID(FK: tb_sales_product.sales_prod_id) */
    private Long salesProdId;

    /** 이미지 URL/경로 */
    private String imgUrl;

    /** 정렬순서 */
    private Integer sortOrder;

    /** 대표이미지 여부(Y/N) */
    private String isMainYn;

    /** 사용여부(Y/N) */
    private String useYn;

    /** 삭제여부(Y/N) */
    private String delYn;

    /** 등록자/등록일 */
    private String regId;
    private Date regDt;

    /** 수정자/수정일 */
    private String modId;
    private Date modDt;

    /** 원본파일명(선택) */
    private String originalName;

    public Long getImgId() {
        return imgId;
    }

    public void setImgId(Long imgId) {
        this.imgId = imgId;
    }

    public Long getSalesProdId() {
        return salesProdId;
    }

    public void setSalesProdId(Long salesProdId) {
        this.salesProdId = salesProdId;
    }

    public String getImgUrl() {
        return imgUrl;
    }

    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }

    public String getIsMainYn() {
        return isMainYn;
    }

    public void setIsMainYn(String isMainYn) {
        this.isMainYn = isMainYn;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public String getDelYn() {
        return delYn;
    }

    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public String getRegId() {
        return regId;
    }

    public void setRegId(String regId) {
        this.regId = regId;
    }

    public Date getRegDt() {
        return regDt;
    }

    public void setRegDt(Date regDt) {
        this.regDt = regDt;
    }

    public String getModId() {
        return modId;
    }

    public void setModId(String modId) {
        this.modId = modId;
    }

    public Date getModDt() {
        return modDt;
    }

    public void setModDt(Date modDt) {
        this.modDt = modDt;
    }

    public String getOriginalName() {
        return originalName;
    }

    public void setOriginalName(String originalName) {
        this.originalName = originalName;
    }
}
