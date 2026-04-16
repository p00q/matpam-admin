package kr.co.matpam.admin.product.service.impl;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Date;
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
     * 구성상품 자동생성 코드 조회
     */
    @Override
    public String selectNextComponentProdCode() throws Exception {
        return componentProductDAO.selectNextComponentProdCode();
    }

    /**
     * 구성상품 상세 조회
     */
    @Override
    public ComponentProductVO selectComponentProduct(
            ComponentProductVO vo) throws Exception {

        return componentProductDAO.selectComponentProduct(vo);
    }

    /**
     * 구성상품 등록
     */
    @Override
    public void insertComponentProduct(
            ComponentProductVO componentProductVO) throws Exception {

        LOGGER.debug("Insert component product: {}",
                componentProductVO.getComponentProdName());

        if (componentProductVO.getComponentProdCode() == null || componentProductVO.getComponentProdCode().trim().isEmpty()) {
            String nextCode = selectNextComponentProdCode();
            componentProductVO.setComponentProdCode(nextCode);
            LOGGER.debug("Auto-generated ComponentProdCode: {}", nextCode);
        }

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

        // normalizePrices(componentProductVO);

        componentProductDAO.updateComponentProduct(componentProductVO);
    }

    /**
     * 구성상품 삭제
     */
    @Override
    public void deleteComponentProduct(
            ComponentProductVO vo) throws Exception {

        LOGGER.debug("Delete component product ID: {}", vo.getComponentProdId());

        componentProductDAO.deleteComponentProduct(vo);
    }

    /**
     * 금액/수량 기본값 보정
     */
    private void normalizePrices(ComponentProductVO vo) {
        if (vo.getListPrice() == null) {
            vo.setListPrice(BigDecimal.ZERO);
        }

        // costPrice가 입력되지 않았을 경우에만 listPrice로 세팅 (프론트 변경사항 반영)
        if (vo.getCostPrice() == null) {
            vo.setCostPrice(vo.getListPrice());
        }

        // vatAmount값이 프론트에서 넘어왔다면 vatRate(저장소)에 세팅
        if (vo.getVatAmount() != null) {
            vo.setVatRate(vo.getVatAmount());
        } else if (vo.getVatRate() == null) {
            vo.setVatRate(BigDecimal.ZERO);
        }

        if (vo.getTotalSaleQty() == null) {
            vo.setTotalSaleQty(vo.getListPrice().longValue());
        }

        ensureSalePeriod(vo);
    }

    private void ensureSalePeriod(ComponentProductVO vo) {
        if (vo.getSaleStartDt() == null) {
            vo.setSaleStartDt(new Date());
        }

        if (vo.getSaleEndDt() == null) {
            Calendar nextYear = Calendar.getInstance();
            nextYear.setTime(vo.getSaleStartDt());
            nextYear.add(Calendar.YEAR, 1);
            vo.setSaleEndDt(nextYear.getTime());
        }
    }
}
