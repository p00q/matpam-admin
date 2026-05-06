package kr.co.matpam.admin.product.service.impl;

import java.util.List;
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

    void insertProduct(ProductVO vo);

    void updateProduct(ProductVO vo);

    List<ProductPriceVO> selectProductPriceList(Long productId);

    void insertProductPrice(ProductPriceVO vo);

    void updateProductPriceStatus(ProductPriceVO vo);
}
