package kr.co.matpam.admin.buyer.web;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.matpam.admin.common.service.LoginVO;
import kr.co.matpam.admin.member.service.MeatMoneyService;
import kr.co.matpam.admin.member.service.MemberService;
import kr.co.matpam.admin.member.service.MemberVO;
import kr.co.matpam.admin.order.service.OrderItemVO;
import kr.co.matpam.admin.order.service.OrderService;
import kr.co.matpam.admin.order.service.OrderVO;
import kr.co.matpam.admin.product.service.SalesProductService;
import kr.co.matpam.admin.product.service.SalesProductVO;

/**
 * 소비자 쇼핑몰 (Front) 컨트롤러
 * - 뷰 라우팅: /front/*.do
 * - AJAX API:  /front/api/*.ajax, /front/order/*.ajax
 */
@Controller
public class FrontController {

    private static final Logger LOGGER = LoggerFactory.getLogger(FrontController.class);
    private static final String CART_SESSION_KEY = "FRONT_CART";

    @Resource(name = "salesProductService")
    private SalesProductService salesProductService;

    @Resource(name = "meatMoneyService")
    private MeatMoneyService meatMoneyService;

    @Resource(name = "orderService")
    private OrderService orderService;

    @Resource(name = "memberService")
    private MemberService memberService;

    // =========================================================
    // 1. 뷰 라우팅
    // =========================================================

    /** 로그인 페이지 */
    @GetMapping("/front/login.do")
    public String loginForm(ModelMap model) {
        return "front/login/Login";
    }

    /** 로그아웃 */
    @GetMapping("/front/logout.do")
    public String logout(HttpSession session) {
        session.removeAttribute("loginVO");
        return "redirect:/front/login.do";
    }

    /** 메인 홈 */
    @GetMapping("/front/main.do")
    public String main(ModelMap model) {
        model.addAttribute("pageTitle", "맛팜 쇼핑몰");
        model.addAttribute("contentPage", "/WEB-INF/jsp/front/main/Main.jsp");
        return "front/layout/main";
    }

    /** 상품 목록 */
    @GetMapping("/front/product/list.do")
    public String productList(ModelMap model) {
        model.addAttribute("pageTitle", "전체 상품 | 맛팜");
        model.addAttribute("contentPage", "/WEB-INF/jsp/front/product/ProductList.jsp");
        return "front/layout/main";
    }

    /** 상품 사세 */
    @GetMapping("/front/product/detail.do")
    public String productDetail(@RequestParam Long prodId, ModelMap model) {
        try {
            SalesProductVO searchVO = new SalesProductVO();
            searchVO.setSalesProdId(prodId);
            SalesProductVO product = salesProductService.selectSalesProduct(searchVO);
            model.addAttribute("product", product);
            model.addAttribute("pageTitle", product.getSalesProdName() + " | 맛팜");
            model.addAttribute("contentPage", "/WEB-INF/jsp/front/product/ProductDetail.jsp");
        } catch (Exception e) {
            LOGGER.error("Product detail error: prodId={}", prodId, e);
            return "redirect:/front/product/list.do";
        }
        return "front/layout/main";
    }

    /** 장바구니 */
    @GetMapping("/front/cart.do")
    public String cart(ModelMap model) {
        model.addAttribute("pageTitle", "장바구니 | 맛팜");
        model.addAttribute("contentPage", "/WEB-INF/jsp/front/order/Cart.jsp");
        return "front/layout/main";
    }

    /** 마이페이지 */
    @GetMapping("/front/mypage.do")
    public String mypage(ModelMap model) {
        model.addAttribute("pageTitle", "마이페이지 | 맛팜");
        model.addAttribute("contentPage", "/WEB-INF/jsp/front/mypage/Mypage.jsp");
        return "front/layout/main";
    }

    // =========================================================
    // 2. 인증 AJAX
    // =========================================================

    /** 로그인 처리 */
    @PostMapping("/front/login.ajax")
    @ResponseBody
    public Map<String, Object> login(
            @RequestParam String loginId,
            @RequestParam String loginPw,
            HttpSession session) {

        Map<String, Object> result = new HashMap<>();
        try {
            MemberVO member = memberService.selectMemberById(loginId);

            if (member == null || !loginPw.equals(member.getLoginPw())) {
                result.put("success", false);
                result.put("message", "아이디 또는 비밀번호가 올바르지 않습니다.");
                return result;
            }

            // displayName: companyName 우선, 없으면 managerName
            String displayName = member.getCompanyName() != null
                    ? member.getCompanyName() : member.getManagerName();

            // 세션 loginVO 생성
            LoginVO loginVO = new LoginVO(
                    member.getMemberPk(),
                    member.getLoginId(),
                    displayName,
                    member.getMemberType() != null ? member.getMemberType() : "LOCAL"
            );

            session.setAttribute("loginVO", loginVO);
            result.put("success", true);
        } catch (Exception e) {
            LOGGER.error("Front login error", e);
            result.put("success", false);
            result.put("message", "로그인 처리 중 오류가 발생했습니다.");
        }
        return result;
    }

    // =========================================================
    // 3. 상품 AJAX API
    // =========================================================

    /** 상품 목록 조회 */
    @GetMapping("/front/api/productList.ajax")
    @ResponseBody
    public Map<String, Object> getProductList(
            @RequestParam(defaultValue = "1") int pageIndex,
            @RequestParam(defaultValue = "12") int pageUnit,
            @RequestParam(required = false) String vatYn,
            @RequestParam(required = false) String keyword) {

        Map<String, Object> result = new HashMap<>();
        try {
            SalesProductVO searchVO = new SalesProductVO();
            searchVO.setPageIndex(pageIndex);
            searchVO.setPageUnit(pageUnit);
            searchVO.setUseYn("Y");
            if (vatYn != null && !vatYn.isEmpty()) searchVO.setSearchCondition(vatYn); // vatYn 필터는 searchCondition으로 전달 (Mapper에서 필터링)
            if (keyword != null && !keyword.isEmpty()) searchVO.setSearchKeyword(keyword);

            List<SalesProductVO> list = salesProductService.selectSalesProductList(searchVO);
            int total = salesProductService.selectSalesProductListTotCnt(searchVO);

            result.put("success", true);
            result.put("data", list);
            result.put("totalCount", total);
        } catch (Exception e) {
            LOGGER.error("Product list error", e);
            result.put("success", false);
            result.put("data", new ArrayList<>());
            result.put("totalCount", 0);
        }
        return result;
    }

    // =========================================================
    // 4. 내 정보 AJAX API
    // =========================================================

    /** 내 미트 머니 잔액 */
    @GetMapping("/front/api/myMoney.ajax")
    @ResponseBody
    public Map<String, Object> getMyMoney(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
            BigDecimal balance = meatMoneyService.getBalance(loginVO.getMemberPk());
            result.put("success", true);
            result.put("balance", balance);
        } catch (Exception e) {
            result.put("success", false);
            result.put("balance", BigDecimal.ZERO);
        }
        return result;
    }

    /** 내 주문 내역 */
    @GetMapping("/front/api/myOrders.ajax")
    @ResponseBody
    public Map<String, Object> getMyOrders(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
            OrderVO searchVO = new OrderVO();
            searchVO.setBuyerMemberId(loginVO.getMemberPk());

            List<OrderVO> orders = orderService.selectOrderList(searchVO);
            result.put("success", true);
            result.put("orders", orders);
        } catch (Exception e) {
            LOGGER.error("My orders error", e);
            result.put("success", false);
            result.put("orders", new ArrayList<>());
        }
        return result;
    }

    /** 미트 머니 거래 내역 */
    @GetMapping("/front/api/moneyHistory.ajax")
    @ResponseBody
    public Map<String, Object> getMoneyHistory(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
            Map<String, Object> params = new HashMap<>();
            params.put("memberId", loginVO.getMemberPk());
            params.put("pageUnit", 20);

            List<Map<String, Object>> history = meatMoneyService.selectMoneyHistoryList(params);
            result.put("success", true);
            result.put("history", history);
        } catch (Exception e) {
            LOGGER.error("Money history error", e);
            result.put("success", false);
            result.put("history", new ArrayList<>());
        }
        return result;
    }

    // =========================================================
    // 5. 장바구니 AJAX API (Session 기반)
    // =========================================================

    /** 장바구니 항목 수 */
    @GetMapping("/front/api/cartCount.ajax")
    @ResponseBody
    public Map<String, Object> getCartCount(HttpSession session) {
        List<Map<String, Object>> cart = getOrInitCart(session);
        Map<String, Object> result = new HashMap<>();
        result.put("count", cart.size());
        return result;
    }

    /** 장바구니 전체 목록 */
    @GetMapping("/front/api/cartList.ajax")
    @ResponseBody
    public Map<String, Object> getCartList(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("items", getOrInitCart(session));
        return result;
    }

    /** 장바구니 상품 추가 */
    @PostMapping("/front/api/addCart.ajax")
    @ResponseBody
    public Map<String, Object> addToCart(
            @RequestParam Long prodId,
            @RequestParam(defaultValue = "1") int qty,
            HttpSession session) {

        Map<String, Object> result = new HashMap<>();
        try {
            SalesProductVO searchVO = new SalesProductVO();
            searchVO.setSalesProdId(prodId);
            SalesProductVO product = salesProductService.selectSalesProduct(searchVO);
            if (product == null) {
                result.put("success", false);
                result.put("message", "상품을 찾을 수 없습니다.");
                return result;
            }

            List<Map<String, Object>> cart = getOrInitCart(session);

            // 동일 상품이면 수량 증가
            boolean found = false;
            for (Map<String, Object> item : cart) {
                if (prodId.equals(item.get("prodId"))) {
                    item.put("qty", (int) item.get("qty") + qty);
                    found = true;
                    break;
                }
            }
            if (!found) {
                Map<String, Object> item = new HashMap<>();
                item.put("prodId", prodId);
                item.put("prodName", product.getSalesProdName());
                item.put("unitPrice", product.getSalesPrice());
                item.put("qty", qty);
                item.put("vatYn", product.getVatYn()); // 과세여부 추가
                cart.add(item);
            }

            session.setAttribute(CART_SESSION_KEY, cart);
            result.put("success", true);
            result.put("cartCount", cart.size());
        } catch (Exception e) {
            LOGGER.error("Add to cart error: prodId={}", prodId, e);
            result.put("success", false);
            result.put("message", "장바구니 추가에 실패했습니다.");
        }
        return result;
    }

    /** 장바구니 서버 동기화 (수량 변경 / 삭제 후 전체 교체) */
    @PostMapping("/front/api/syncCart.ajax")
    @ResponseBody
    public Map<String, Object> syncCart(
            @RequestBody List<Map<String, Object>> cartItems,
            HttpSession session) {

        session.setAttribute(CART_SESSION_KEY, cartItems);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    // =========================================================
    // 6. 주문/결제 AJAX
    // =========================================================

    /** 장바구니 → 주문 확정 (Meat Money 차감) */
    @PostMapping("/front/order/checkout.ajax")
    @ResponseBody
    public Map<String, Object> checkout(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
            List<Map<String, Object>> cart = getOrInitCart(session);

            if (cart.isEmpty()) {
                result.put("success", false);
                result.put("message", "장바구니가 비어있습니다.");
                return result;
            }

            // 총 결제 금액 계산
            BigDecimal totalOrderAmt = BigDecimal.ZERO;
            BigDecimal totalVatAmt = BigDecimal.ZERO;
            List<OrderItemVO> orderItems = new ArrayList<>();

            for (Map<String, Object> item : cart) {
                Long prodId = Long.parseLong(item.get("prodId").toString());
                SalesProductVO searchVO = new SalesProductVO();
                searchVO.setSalesProdId(prodId);
                SalesProductVO product = salesProductService.selectSalesProduct(searchVO);
                
                if (product == null) continue;

                BigDecimal unitPrice = product.getSalesPrice(); // 할인 적용된 가격
                int qty = Integer.parseInt(item.get("qty").toString());
                BigDecimal lineAmt = unitPrice.multiply(BigDecimal.valueOf(qty));
                
                // 부가세 계산 (별도 합계 방식)
                BigDecimal lineVat = BigDecimal.ZERO;
                if ("Y".equals(product.getVatYn())) {
                    // 10% 별도 합계
                    lineVat = lineAmt.multiply(new BigDecimal("0.1")).setScale(0, java.math.RoundingMode.HALF_UP);
                }

                totalOrderAmt = totalOrderAmt.add(lineAmt);
                totalVatAmt = totalVatAmt.add(lineVat);

                OrderItemVO oi = new OrderItemVO();
                oi.setSalesProdId(prodId);
                oi.setSalesProdName(product.getSalesProdName());
                oi.setQty((long) qty);
                oi.setUnitPrice(unitPrice);
                oi.setItemOrderAmt(lineAmt);
                oi.setItemVatAmt(lineVat);
                oi.setItemPayAmt(lineAmt.add(lineVat));
                orderItems.add(oi);
            }

            BigDecimal totalPayAmt = totalOrderAmt.add(totalVatAmt);

            // 잔액 확인
            BigDecimal balance = meatMoneyService.getBalance(loginVO.getMemberPk());
            if (balance.compareTo(totalPayAmt) < 0) {
                result.put("success", false);
                result.put("message", "미트 머니 잔액이 부족합니다. 결제예정: " + totalPayAmt.toPlainString() + "원 (잔액: " + balance.toPlainString() + "원)");
                return result;
            }

            // 주문 생성
            OrderVO orderVO = new OrderVO();
            orderVO.setBuyerMemberId(loginVO.getMemberPk());
            orderVO.setBuyerName(loginVO.getMemberName());
            orderVO.setTotalOrderAmt(totalOrderAmt);
            orderVO.setTotalVatAmt(totalVatAmt);
            orderVO.setTotalDiscountAmt(BigDecimal.ZERO); // 이미 UnitPrice에 반영됨
            orderVO.setTotalPayAmt(totalPayAmt);
            orderVO.setOrderStatusCd("ORDER");
            orderVO.setPaymentStatusCd("PAID");
            orderVO.setOpType(loginVO.getOpType() != null ? loginVO.getOpType() : "LOCAL");
            orderVO.setOrderItems(orderItems);

            String orderId = orderService.processOrder(orderVO);

            // 장바구니 비우기
            session.removeAttribute(CART_SESSION_KEY);

            result.put("success", true);
            result.put("orderId", orderId);
            result.put("deductedAmt", totalPayAmt);
            result.put("message", "주문이 완료되었습니다.");
        } catch (IllegalArgumentException e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        } catch (Exception e) {
            LOGGER.error("Checkout error", e);
            result.put("success", false);
            result.put("message", "결제 처리 중 오류가 발생했습니다.");
        }
        return result;
    }

    // =========================================================
    // 내부 유틸
    // =========================================================

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> getOrInitCart(HttpSession session) {
        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute(CART_SESSION_KEY);
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute(CART_SESSION_KEY, cart);
        }
        return cart;
    }
}
