package kr.co.matpam.admin.product.service.impl;

import java.math.BigDecimal;
import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.matpam.admin.product.service.SalesProductService;
import kr.co.matpam.admin.product.service.SalesProductVO;
import kr.co.matpam.admin.product.service.SalesProductCompositionVO;

@Service("salesProductService")
public class SalesProductServiceImpl extends EgovAbstractServiceImpl implements SalesProductService {

    private static final Logger LOGGER = LoggerFactory.getLogger(SalesProductServiceImpl.class);

    @Resource(name = "salesProductDAO")
    private SalesProductDAO salesProductDAO;

    @Resource(name = "salesProductCompositionDAO")
    private SalesProductCompositionDAO salesProductCompositionDAO;

    @Override
    public List<SalesProductVO> selectSalesProductList(SalesProductVO searchVO) throws Exception {
        return salesProductDAO.selectSalesProductList(searchVO);
    }

    @Override
    public int selectSalesProductListTotCnt(SalesProductVO searchVO) throws Exception {
        return salesProductDAO.selectSalesProductListTotCnt(searchVO);
    }

    @Override
    public SalesProductVO selectSalesProduct(Long salesProdId) throws Exception {
        SalesProductVO vo = salesProductDAO.selectSalesProduct(salesProdId);
        if (vo != null && salesProdId != null) {
            vo.setCompositionList(salesProductCompositionDAO.selectCompListBySalesProdId(salesProdId));
        }
        return vo;
    }

    @Override
    public void increaseViewCount(Long salesProdId) throws Exception {
        if (salesProdId == null) return;
        salesProductDAO.increaseViewCount(salesProdId);
    }

    /**
     * 판매상품 등록 + 구성 저장
     */
    @Override
    @Transactional
    public void insertSalesProduct(SalesProductVO vo) throws Exception {
        // 기본값 보정
        applyDefaultUser(vo);

        // 1) 판매상품 마스터 저장 (useGeneratedKeys로 PK 세팅된다는 전제)
        salesProductDAO.insertSalesProduct(vo);

        // 2) 상세/정책 저장 (분리 테이블)
        salesProductDAO.upsertSalesProductDetail(vo);

        // 3) 구성 저장
        saveComposition(vo.getSalesProdId(), vo.getCompositionList(), vo.getRegId(), vo.getModId());
    }

    /**
     * 판매상품 수정 + 구성 저장
     */
    @Override
    @Transactional
    public void updateSalesProduct(SalesProductVO vo) throws Exception {
        if (vo.getSalesProdId() == null) {
            throw new IllegalArgumentException("salesProdId는 필수입니다.");
        }

        // 수정자 기본값
        if (vo.getModId() == null || vo.getModId().trim().isEmpty()) {
            vo.setModId("SYSTEM");
        }

        if (vo.getRegId() == null || vo.getRegId().trim().isEmpty()) {
            vo.setRegId("SYSTEM");
        }

        // 1) 판매상품 마스터 수정
        salesProductDAO.updateSalesProduct(vo);

        // 2) 상세/정책 저장 (upsert)
        salesProductDAO.upsertSalesProductDetail(vo);

        // 3) 구성 저장(전량 교체 + upsert)
        saveComposition(vo.getSalesProdId(), vo.getCompositionList(), vo.getRegId(), vo.getModId());
    }

    /**
     * 판매상품 삭제(논리삭제)
     * - 마스터 del_yn='Y' 처리 로직이 mapper에 있어야 함
     * - 구성도 같이 논리삭제 처리(일관성)
     */
    @Override
    @Transactional
    public void deleteSalesProduct(Long salesProdId) throws Exception {
        if (salesProdId == null) {
            throw new IllegalArgumentException("salesProdId는 필수입니다.");
        }

        // 판매상품 논리삭제 (SalesProductMapper.xml에 deleteSalesProduct가 del_yn='Y' 처리여야 함)
        salesProductDAO.deleteSalesProduct(salesProdId);

        // 구성도 논리삭제
        salesProductCompositionDAO.deleteCompBySalesProdId(salesProdId);
    }

    /*
     * =========================================================
     * 내부 공통 처리
     * =========================================================
     */

    private void applyDefaultUser(SalesProductVO vo) {
        if (vo.getRegId() == null || vo.getRegId().trim().isEmpty()) {
            vo.setRegId("SYSTEM");
        }
        if (vo.getModId() == null || vo.getModId().trim().isEmpty()) {
            vo.setModId(vo.getRegId());
        }
    }

    /**
     * 구성 저장 전략(현행 tb_sales_product_comp 기준)
     * - 1) 해당 판매상품 구성 전부 del_yn='Y'
     * - 2) 넘어온 구성목록은 upsert(ON DUPLICATE KEY UPDATE)로 저장 + del_yn='N' 복구
     *
     * ※ 복합PK(sales_prod_id, component_prod_id) 구조에서
     * 논리삭제 후 재등록을 안전하게 하려면 "insert"가 아니라 "upsert"가 필수.
     */
    private void saveComposition(Long salesProdId,
            List<SalesProductCompositionVO> compositionList,
            String regId,
            String modId) {

        // A안 정책: null이면 "구성 변경 없음"으로 보고 스킵(삭제도 안 함)
        if (compositionList == null) {
            LOGGER.info("[Composition] compositionList is null -> skip saving compositions. salesProdId={}",
                    salesProdId);
            return;
        }

        // 1) 기존 구성 논리삭제
        salesProductCompositionDAO.deleteCompBySalesProdId(salesProdId);

        // 2) 신규 구성 upsert
        int order = 1;
        for (SalesProductCompositionVO comp : compositionList) {
            if (comp == null)
                continue;
            if (comp.getComponentProdId() == null)
                continue;

            comp.setSalesProdId(salesProdId);

            // comp_qty 기본값(DECIMAL(12,3))
            if (comp.getCompQty() == null) {
                comp.setCompQty(new BigDecimal("1.000"));
            }

            // sort_order 기본값
            if (comp.getSortOrder() == null || comp.getSortOrder() <= 0) {
                comp.setSortOrder(order);
            }

            // 공통
            if (comp.getUseYn() == null || comp.getUseYn().trim().isEmpty()) {
                comp.setUseYn("Y");
            }
            comp.setDelYn("N");

            if (comp.getRegId() == null || comp.getRegId().trim().isEmpty()) {
                comp.setRegId(regId);
            }
            if (comp.getModId() == null || comp.getModId().trim().isEmpty()) {
                comp.setModId(modId);
            }

            salesProductCompositionDAO.upsertComp(comp);
            order++;
        }
    }
}
