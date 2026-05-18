package kr.co.matpam.admin.product.service.impl;

import java.util.List;
import java.util.Map;
import kr.co.matpam.admin.product.service.ProductImageVO;
import kr.co.matpam.admin.product.service.ProductVO;
import kr.co.matpam.admin.product.service.ProductPriceVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * 통합 상품 관리 Mapper 인터페이스
 */
@Mapper("productMapper")
public interface ProductMapper {

    List<ProductVO> selectProductList(ProductVO vo);

    int selectProductListTotCnt(ProductVO vo);

    ProductVO selectProductDetail(Long productId);

    String selectNextProductCode(ProductVO vo);

    Integer selectNextDisplayOrder(ProductVO vo);

    void insertProduct(ProductVO vo);

    void updateProduct(ProductVO vo);

    List<ProductPriceVO> selectProductPriceList(Long productId);

    void insertProductPrice(ProductPriceVO vo);

    void updateProductPriceStatus(ProductPriceVO vo);

    List<ProductImageVO> selectProductImageList(Long productId);

    void deleteProductImages(Long productId);

    void insertProductImage(ProductImageVO vo);

    List<ProductVO> selectRecommendedProcessCandidateList(ProductVO vo);

    List<Long> selectRecommendedProcessIdList(Long productId);

    void deleteRecommendedProcessRelations(Long productId);

    void insertRecommendedProcessRelation(Map<String, Object> param);
}
