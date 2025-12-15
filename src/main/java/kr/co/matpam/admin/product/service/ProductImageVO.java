package kr.co.matpam.admin.product.service;

import java.io.Serializable;

/**
 * 판매상품 이미지 VO
 */
public class ProductImageVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long imageId;
    private Long productNo;
    private String imageType;
    private String imagePath;
    private String originalName;
    private Integer sortOrder;
    private String imgUrl;
    private String isMainYn;

    public Long getImageId() {
        return imageId;
    }

    public void setImageId(Long imageId) {
        this.imageId = imageId;
    }

    public Long getProductNo() {
        return productNo;
    }

    public void setProductNo(Long productNo) {
        this.productNo = productNo;
    }

    public String getImageType() {
        return imageType;
    }

    public void setImageType(String imageType) {
        this.imageType = imageType;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getOriginalName() {
        return originalName;
    }

    public void setOriginalName(String originalName) {
        this.originalName = originalName;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }

    public String getImgUrl() {
        return imgUrl;
    }

    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }

    public String getIsMainYn() {
        return isMainYn;
    }

    public void setIsMainYn(String isMainYn) {
        this.isMainYn = isMainYn;
    }
}
