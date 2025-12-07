package kr.co.matpam.admin.product.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.matpam.admin.product.service.ProductService;
import kr.co.matpam.admin.product.service.ProductVO;

@Service("productService")
public class ProductServiceImpl extends EgovAbstractServiceImpl implements ProductService {

    @Resource(name = "productDAO")
    private ProductDAO productDAO;

    @Override
    public List<ProductVO> selectProductList(ProductVO vo) throws Exception {
        return productDAO.selectProductList(vo);
    }

    @Override
    public int selectProductListTotCnt(ProductVO vo) throws Exception {
        return productDAO.selectProductListTotCnt(vo);
    }

    @Override
    public ProductVO selectProduct(Long productNo) throws Exception {
        return productDAO.selectProduct(productNo);
    }
}
