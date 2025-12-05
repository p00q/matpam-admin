package kr.co.matpam.admin.product.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.matpam.admin.product.service.BundleProductService;
import kr.co.matpam.admin.product.service.BundleProductVO;

/**
 * 구성상품 Service 구현체
 */
@Service("bundleProductService")
public class BundleProductServiceImpl extends EgovAbstractServiceImpl implements BundleProductService {

    private static final Logger LOGGER = LoggerFactory.getLogger(BundleProductServiceImpl.class);

    @Resource(name = "bundleProductDAO")
    private BundleProductDAO bundleProductDAO;

    @Override
    public List<BundleProductVO> selectBundleProductList(BundleProductVO searchVO) throws Exception {
        return bundleProductDAO.selectBundleProductList(searchVO);
    }

    @Override
    public int selectBundleProductListTotCnt(BundleProductVO searchVO) throws Exception {
        return bundleProductDAO.selectBundleProductListTotCnt(searchVO);
    }

    @Override
    public BundleProductVO selectBundleProduct(Long productNo) throws Exception {
        return bundleProductDAO.selectBundleProduct(productNo);
    }

    @Override
    public void insertBundleProduct(BundleProductVO bundleProductVO) throws Exception {
        LOGGER.debug("Insert bundle product: {}", bundleProductVO.getProductName());
        bundleProductDAO.insertBundleProduct(bundleProductVO);
    }

    @Override
    public void updateBundleProduct(BundleProductVO bundleProductVO) throws Exception {
        LOGGER.debug("Update bundle product: {}", bundleProductVO.getProductNo());
        bundleProductDAO.updateBundleProduct(bundleProductVO);
    }

    @Override
    public void deleteBundleProduct(Long productNo) throws Exception {
        LOGGER.debug("Delete bundle product: {}", productNo);
        bundleProductDAO.deleteBundleProduct(productNo);
    }
}
