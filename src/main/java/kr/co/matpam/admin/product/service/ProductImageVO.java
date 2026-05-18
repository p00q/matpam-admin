package kr.co.matpam.admin.product.service;

import java.io.Serializable;
import java.util.Date;

/**
 * Product image mapped to tb_product_image.
 */
public class ProductImageVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long imageId;
    private Long productId;
    private String imageType;
    private String imageUrl;
    private Integer sortOrder;
    private String useYn;
    private Date createdAt;

    public Long getImageId() { return imageId; }
    public void setImageId(Long imageId) { this.imageId = imageId; }

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public String getImageType() { return imageType; }
    public void setImageType(String imageType) { this.imageType = imageType; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }

    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
