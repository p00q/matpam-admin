package kr.co.matpam.admin.product.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.matpam.admin.product.service.ProductImageVO;
import kr.co.matpam.admin.product.service.ProductService;
import kr.co.matpam.admin.product.service.ProductVO;
import kr.co.matpam.admin.product.service.ProductPriceVO;

/**
 * 통합 상품 관리 서비스 구현체
 */
@Service("productService")
public class ProductServiceImpl extends EgovAbstractServiceImpl implements ProductService {

    private static final BigDecimal VAT_RATE = new BigDecimal("0.10");
    private static final BigDecimal VAT_DIVISOR = new BigDecimal("1.10");
    private static final BigDecimal ZERO = new BigDecimal("0.00");

    @Resource(name="productMapper")
    private ProductMapper productMapper;

    @Override
    public List<ProductVO> selectProductList(ProductVO vo) throws Exception {
        return productMapper.selectProductList(vo);
    }

    @Override
    public int selectProductListTotCnt(ProductVO vo) {
        return productMapper.selectProductListTotCnt(vo);
    }

    @Override
    public ProductVO selectProductDetail(Long productId) throws Exception {
        ProductVO product = productMapper.selectProductDetail(productId);
        if (product == null) {
            return null;
        }
        applyImageFields(product, productMapper.selectProductImageList(productId));
        List<Long> recommendedIds = productMapper.selectRecommendedProcessIdList(productId);
        if (recommendedIds != null && !recommendedIds.isEmpty()) {
            product.setRecommendedProcessIdArray(recommendedIds.toArray(new Long[0]));
        }
        return product;
    }

    @Override
    public List<ProductVO> selectRecommendedProcessCandidateList(ProductVO vo) throws Exception {
        return productMapper.selectRecommendedProcessCandidateList(vo);
    }

    @Override
    public void insertProduct(ProductVO vo) throws Exception {
        normalizeProduct(vo);
        if (!hasText(vo.getProductCode())) {
            vo.setCodeBase(resolveCodeBase(vo.getProcessingType()));
            vo.setProductCode(productMapper.selectNextProductCode(vo));
        }
        if (vo.getDisplayOrder() == null) {
            vo.setCodeBase(resolveCodeBase(vo.getProcessingType()));
            vo.setDisplayOrder(productMapper.selectNextDisplayOrder(vo));
        }
        productMapper.insertProduct(vo);
        saveProductImages(vo);
        saveRecommendedProcessRelations(vo);
    }

    @Override
    public void updateProduct(ProductVO vo) throws Exception {
        normalizeProduct(vo);
        if (vo.getDisplayOrder() == null) {
            vo.setCodeBase(resolveCodeBase(vo.getProcessingType()));
            vo.setDisplayOrder(productMapper.selectNextDisplayOrder(vo));
        }
        productMapper.updateProduct(vo);
        saveProductImages(vo);
        saveRecommendedProcessRelations(vo);
    }

    @Override
    public List<ProductPriceVO> selectProductPriceList(Long productId) throws Exception {
        return productMapper.selectProductPriceList(productId);
    }

    @Override
    public void saveProductPrice(ProductPriceVO vo) throws Exception {
        if (vo.getPriceId() == null) {
            productMapper.insertProductPrice(vo);
        } else {
            // 이력 관리를 위해 기존 상태를 변경하거나 신규 인서트하는 로직 추가 가능
            // 현재는 단순 상태 업데이트 또는 처리
        }
    }

    private void normalizeProduct(ProductVO vo) {
        vo.setProductCode(trimToNull(vo.getProductCode()));
        vo.setProductName(trimToNull(vo.getProductName()));
        vo.setUnitName(trimToNull(vo.getUnitName()));
        vo.setMdComment(trimToNull(vo.getMdComment()));
        vo.setSummary(trimToNull(vo.getSummary()));
        vo.setMainImageUrl(trimToNull(vo.getMainImageUrl()));
        vo.setSubImageUrl1(trimToNull(vo.getSubImageUrl1()));
        vo.setSubImageUrl2(trimToNull(vo.getSubImageUrl2()));
        vo.setSubImageUrl3(trimToNull(vo.getSubImageUrl3()));
        if (!hasText(vo.getItemKind())) {
            vo.setItemKind("GOODS");
        }
        if (!hasText(vo.getProcessingType())) {
            vo.setProcessingType("RAW_GOODS");
        }
        if (!hasText(vo.getIndependentSaleYn())) {
            vo.setIndependentSaleYn("Y");
        }
        if (!hasText(vo.getStockManagedYn())) {
            vo.setStockManagedYn("Y");
        }
        if (!hasText(vo.getSaleStatus())) {
            vo.setSaleStatus("ON_SALE");
        }
        if (!hasText(vo.getUnitName())) {
            vo.setUnitName("kg");
        }
        if (!hasText(vo.getIsNew())) {
            vo.setIsNew("N");
        }
        if (!hasText(vo.getIsMonthly())) {
            vo.setIsMonthly("N");
        }
        if (!hasText(vo.getIsHidden())) {
            vo.setIsHidden("N");
        }
        if (!hasText(vo.getStockManageYn())) {
            vo.setStockManageYn(vo.getStockManagedYn());
        }
        if (!hasText(vo.getStockManageYn())) {
            vo.setStockManageYn("N");
        }
        vo.setStockManagedYn(vo.getStockManageYn());
        vo.setTaxCategory("RAW_GOODS".equals(vo.getProcessingType()) ? "TAX_FREE" : "TAXABLE");
        normalizePrice(vo);
        vo.setDescription(sanitizeDescription(vo.getDescription()));
        if (hasText(vo.getMainImageUrl())) {
            vo.setImageUrl(vo.getMainImageUrl());
        }
    }

    private void normalizePrice(ProductVO vo) {
        BigDecimal supplyPrice = money(vo.getSupplyPrice());
        BigDecimal salePrice = money(vo.getSalePrice());
        BigDecimal vatAmount = ZERO;

        if ("TAX_FREE".equals(vo.getTaxCategory())) {
            if (supplyPrice == null && salePrice != null) {
                supplyPrice = salePrice;
            }
            if (salePrice == null && supplyPrice != null) {
                salePrice = supplyPrice;
            }
        } else {
            if (supplyPrice == null && salePrice != null) {
                supplyPrice = salePrice.divide(VAT_DIVISOR, 2, RoundingMode.HALF_UP);
            }
            if (supplyPrice != null) {
                vatAmount = supplyPrice.multiply(VAT_RATE).setScale(2, RoundingMode.HALF_UP);
                salePrice = supplyPrice.add(vatAmount).setScale(2, RoundingMode.HALF_UP);
            }
        }

        vo.setSupplyPrice(supplyPrice);
        vo.setVatAmount(vatAmount);
        vo.setSalePrice(salePrice);
        vo.setDeliveryFee(money(vo.getDeliveryFee()));
        vo.setSafetyStockQty(money(vo.getSafetyStockQty()));
    }

    private BigDecimal money(BigDecimal value) {
        return value == null ? null : value.setScale(2, RoundingMode.HALF_UP);
    }

    private Long resolveCodeBase(String processingType) {
        if ("RAW_GOODS".equals(processingType)) {
            return 1000000L;
        }
        if ("FINISHED_GOODS".equals(processingType)) {
            return 2000000L;
        }
        return 3000000L;
    }

    private String sanitizeDescription(String value) {
        if (value == null) {
            return null;
        }
        return value
                .replaceAll("(?is)<\\s*(script|iframe)[^>]*>.*?<\\s*/\\s*\\1\\s*>", "")
                .replaceAll("(?is)<\\s*(script|iframe)[^>]*/?\\s*>", "")
                .replaceAll("(?i)\\s+on[a-z]+\\s*=\\s*(['\"]).*?\\1", "")
                .replaceAll("(?i)\\s+on[a-z]+\\s*=\\s*[^\\s>]+", "")
                .replaceAll("(?i)javascript\\s*:", "");
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private void applyImageFields(ProductVO product, List<ProductImageVO> imageList) {
        if (imageList == null || imageList.isEmpty()) {
            product.setMainImageUrl(product.getImageUrl());
            return;
        }
        int subIndex = 0;
        for (ProductImageVO image : imageList) {
            if (image == null || !hasText(image.getImageUrl())) {
                continue;
            }
            if ("MAIN".equals(image.getImageType()) && !hasText(product.getMainImageUrl())) {
                product.setMainImageUrl(image.getImageUrl());
                continue;
            }
            if (!"MAIN".equals(image.getImageType())) {
                subIndex++;
                if (subIndex == 1) {
                    product.setSubImageUrl1(image.getImageUrl());
                } else if (subIndex == 2) {
                    product.setSubImageUrl2(image.getImageUrl());
                } else if (subIndex == 3) {
                    product.setSubImageUrl3(image.getImageUrl());
                }
            }
        }
        if (!hasText(product.getMainImageUrl())) {
            product.setMainImageUrl(product.getImageUrl());
        }
    }

    private void saveProductImages(ProductVO vo) {
        if (vo.getProductId() == null) {
            return;
        }
        productMapper.deleteProductImages(vo.getProductId());
        List<ProductImageVO> images = new ArrayList<>();
        addImage(images, vo.getProductId(), "MAIN", vo.getMainImageUrl(), 0);
        addImage(images, vo.getProductId(), "SUB", vo.getSubImageUrl1(), 1);
        addImage(images, vo.getProductId(), "SUB", vo.getSubImageUrl2(), 2);
        addImage(images, vo.getProductId(), "SUB", vo.getSubImageUrl3(), 3);
        for (ProductImageVO image : images) {
            productMapper.insertProductImage(image);
        }
    }

    private void addImage(List<ProductImageVO> images, Long productId, String imageType, String imageUrl, int sortOrder) {
        if (!hasText(imageUrl)) {
            return;
        }
        ProductImageVO image = new ProductImageVO();
        image.setProductId(productId);
        image.setImageType(imageType);
        image.setImageUrl(imageUrl.trim());
        image.setSortOrder(sortOrder);
        image.setUseYn("Y");
        images.add(image);
    }

    private void saveRecommendedProcessRelations(ProductVO vo) {
        if (vo.getProductId() == null) {
            return;
        }
        productMapper.deleteRecommendedProcessRelations(vo.getProductId());
        Long[] ids = vo.getRecommendedProcessIdArray();
        if (!"RAW_GOODS".equals(vo.getProcessingType()) || ids == null) {
            return;
        }
        int sortOrder = 1;
        for (Long relatedProductId : ids) {
            if (relatedProductId == null || relatedProductId.equals(vo.getProductId())) {
                continue;
            }
            Map<String, Object> param = new HashMap<>();
            param.put("baseProductId", vo.getProductId());
            param.put("relatedProductId", relatedProductId);
            param.put("relationKind", "RAW_TO_PROCESS_SERVICE");
            param.put("bundleMode", "OPTIONAL");
            param.put("sortOrder", sortOrder++);
            param.put("createdBy", vo.getCreatedBy());
            productMapper.insertRecommendedProcessRelation(param);
        }
    }
}
