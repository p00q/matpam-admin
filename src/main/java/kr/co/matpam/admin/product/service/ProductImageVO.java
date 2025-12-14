package kr.co.matpam.admin.product.service;

import java.io.Serializable;
import java.util.Date;

/**
 * 판매상품 이미지 VO
 * TB_SALES_PRODUCT_IMAGE
 */
public class ProductImageVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 이미지ID */
    private Long imgId;

    /** 판매상품ID */
    private Long salesProdId;

    /** 이미지경로 */
    private String imgUrl;

    /** 정렬순서 */
    private Integer sortOrder;

    /** 대표이미지여부 (Y/N) */
    private String isMainYn;

    /** 사용여부 */
    private String useYn;

    /** 삭제여부 */
    private String delYn;

    /** 등록자ID */
    private String regId;

    /** 등록일시 */
    private Date regDt;

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
}
