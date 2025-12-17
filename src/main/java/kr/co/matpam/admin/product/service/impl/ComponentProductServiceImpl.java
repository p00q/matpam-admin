package kr.co.matpam.admin.product.service.impl;

import java.math.BigDecimal;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

import kr.co.matpam.admin.product.service.ComponentProductService;
import kr.co.matpam.admin.product.service.ComponentProductVO;

/**
 * 구성상품(컴포넌트상품) Service 구현체
 * - 대상 테이블: TB_COMPONENT_PRODUCT
 */
@Service("componentProductService")
public class ComponentProductServiceImpl extends EgovAbstractServiceImpl
        implements ComponentProductService {

    private static final Logger LOGGER = LoggerFactory.getLogger(ComponentProductServiceImpl.class);

    @Resource(name = "componentProductDAO")
    private ComponentProductDAO componentProductDAO;

    /**
     * 구성상품 목록 조회
     */
    @Override
    public List<ComponentProductVO> selectComponentProductList(
            ComponentProductVO searchVO) throws Exception {

        return componentProductDAO.selectComponentProductList(searchVO);
    }

    /**
     * 구성상품 목록 총 건수 조회
     */
    @Override
    public int selectComponentProductListTotCnt(
            ComponentProductVO searchVO) throws Exception {

        return componentProductDAO.selectComponentProductListTotCnt(searchVO);
    }

    /**
     * 구성상품 상세 조회
     */
    @Override
    public ComponentProductVO selectComponentProduct(
            Long componentProdId) throws Exception {

        return componentProductDAO.selectComponentProduct(componentProdId);
    }

    /**
     * 구성상품 등록
     */
    @Override
    public void insertComponentProduct(
            ComponentProductVO componentProductVO) throws Exception {

        LOGGER.debug("Insert component product: {}",
                componentProductVO.getComponentProdName());

        normalizePrices(componentProductVO);

        componentProductDAO.insertComponentProduct(componentProductVO);
    }

    /**
     * 구성상품 수정
     */
    @Override
    public void updateComponentProduct(
            ComponentProductVO componentProductVO) throws Exception {

        LOGGER.debug("Update component product ID: {}",
                componentProductVO.getComponentProdId());

        normalizePrices(componentProductVO);

        componentProductDAO.updateComponentProduct(componentProductVO);
    }

    /**
     * 구성상품 삭제
     */
    @Override
    public void deleteComponentProduct(
            Long componentProdId) throws Exception {

        LOGGER.debug("Delete component product ID: {}", componentProdId);

        componentProductDAO.deleteComponentProduct(componentProdId);
    }

    /**
     * 금액/수량 기본값 보정
     */
    private void normalizePrices(ComponentProductVO vo) {
        if (vo.getListPrice() == null) {
            vo.setListPrice(BigDecimal.ZERO);
        }

        vo.setCostPrice(vo.getListPrice());
        vo.setVatRate(BigDecimal.TEN);
        vo.setTotalSaleQty(vo.getListPrice().longValue());
    }
}
