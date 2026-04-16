package kr.co.matpam.admin.buyer.web;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.co.matpam.admin.common.service.LoginVO;
import kr.co.matpam.admin.member.service.MeatMoneyService;
import kr.co.matpam.admin.product.service.SalesProductService;
import kr.co.matpam.admin.product.service.SalesProductVO;

/**
 * 구매자용 REST API 컨트롤러
 * - 별도의 프론트엔드(Vite) 프로젝트와 연동
 */
@RestController
@RequestMapping("/api/buyer")
public class BuyerApiController {

    @Resource(name = "salesProductService")
    private SalesProductService salesProductService;

    @Resource(name = "meatMoneyService")
    private MeatMoneyService meatMoneyService;

    /**
     * 상품 목록 조회
     */
    @GetMapping("/products")
    public Map<String, Object> getProducts(SalesProductVO searchVO, javax.servlet.http.HttpServletRequest request) throws Exception {
        Map<String, Object> result = new HashMap<>();

        // 운영권한 격리
        searchVO.setOpType((String) request.getAttribute("opType"));
        
        // 기본 페이징 설정 (필요시)
        searchVO.setPageUnit(20);
        searchVO.setPageIndex(1);
        
        List<SalesProductVO> productList = salesProductService.selectSalesProductList(searchVO);
        int totalCnt = salesProductService.selectSalesProductListTotCnt(searchVO);

        result.put("status", "success");
        result.put("data", productList);
        result.put("totalCount", totalCnt);
        
        return result;
    }

    /**
     * 현재 로그인 회원 머니 정보 조회
     */
    @GetMapping("/member/money")
    public Map<String, Object> getMemberMoney(HttpSession session) throws Exception {
        Map<String, Object> result = new HashMap<>();
        
        LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
        
        if (loginVO == null) {
            result.put("status", "error");
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        BigDecimal balance = meatMoneyService.getBalance(loginVO.getMemberPk());
        
        result.put("status", "success");
        result.put("balance", balance);
        result.put("memberId", loginVO.getMemberPk());
        result.put("memberName", loginVO.getMemberName());
        
        return result;
    }

    /**
     * 주문/결제 요청 (미트머니 사용)
     */
    @org.springframework.web.bind.annotation.PostMapping("/order")
    public Map<String, Object> placeOrder(HttpSession session, @org.springframework.web.bind.annotation.RequestBody Map<String, Object> orderData) throws Exception {
        Map<String, Object> result = new HashMap<>();
        
        LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
        if (loginVO == null) {
            result.put("status", "error");
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        // 주문 총액 확인 (프론트에서 전달)
        BigDecimal totalAmount = new BigDecimal(orderData.get("totalAmount").toString());
        
        try {
            // 1. 머니 차감 (Service 내부에서 잔액 체크 및 트랜잭션 처리)
            String tempOrderNo = "ORD-" + System.currentTimeMillis();
            meatMoneyService.deductMoney(loginVO.getMemberPk(), totalAmount, tempOrderNo);
            
            result.put("status", "success");
            result.put("message", "주문 및 결제가 완료되었습니다.");
            result.put("orderNo", tempOrderNo);
        } catch (Exception e) {
            result.put("status", "error");
            result.put("message", "결제 실패: " + e.getMessage());
        }
        
        return result;
    }
}
