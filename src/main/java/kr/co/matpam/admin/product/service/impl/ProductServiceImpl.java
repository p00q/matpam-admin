package kr.co.matpam.admin.product.service.impl;

import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.matpam.admin.product.service.ProductService;
import kr.co.matpam.admin.product.service.ProductVO;
import kr.co.matpam.admin.product.service.ProductPriceVO;

/**
 * 통합 상품 관리 서비스 구현체
 */
@Service("productService")
public class ProductServiceImpl extends EgovAbstractServiceImpl implements ProductService {

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
        return productMapper.selectProductDetail(productId);
    }

    @Override
    public void insertProduct(ProductVO vo) throws Exception {
        productMapper.insertProduct(vo);
    }

    @Override
    public void updateProduct(ProductVO vo) throws Exception {
        productMapper.updateProduct(vo);
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
}
