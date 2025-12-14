package kr.co.matpam.admin.product.service;

import java.io.Serializable;

/**
 * 판매상품 이미지 VO
 */
public class ProductImageVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long imgId;
    private Long salesProdId;
    private String imgUrl;
    private Integer sortOrder;
    private String isMainYn;
    private String regId;
    private String regDt;
    private String modDt;

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

    public String getRegId() {
        return regId;
    }

    public void setRegId(String regId) {
        this.regId = regId;
    }

    public String getRegDt() {
        return regDt;
    }

    public void setRegDt(String regDt) {
        this.regDt = regDt;
    }

    public String getModDt() {
        return modDt;
    }

    public void setModDt(String modDt) {
        this.modDt = modDt;
    }
}
