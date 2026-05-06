package kr.co.matpam.admin.financial.web;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import kr.co.matpam.admin.financial.service.B2bFinancialService;

@Controller
public class FinancialController {

    @Resource(name = "b2bFinancialService")
    private B2bFinancialService b2bFinancialService;

    @RequestMapping("/admin/financial/getMeatMoney.ajax")
    @ResponseBody
    public Map<String, Object> getMeatMoney(@RequestParam Long companyId) {
        Map<String, Object> res = new HashMap<>();
        try {
            // 본사(sellerId=1)와 해당 업체의 금융 정보 조회
            Long tenantId = 1L;
            Long sellerId = 1L;
            
            // 실제 구현 시 서비스에서 세부 항목별로 가져오는 메서드 추가 필요
            // 여기서는 테스트를 위해 B2bFinancialServiceImpl의 로직을 활용하거나 직접 Mapper 호출
            // 우선 가용 총액만 가져오도록 함 (임시)
            BigDecimal total = b2bFinancialService.getAvailableMeatMoney(tenantId, sellerId, companyId);
            
            res.put("success", true);
            res.put("total", total);
            res.put("credit", total); // 임시: 상세 분리는 추후 구현
            res.put("advance", 0);
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", e.getMessage());
        }
        return res;
    }

    @RequestMapping("/admin/financial/adjustCredit.ajax")
    @ResponseBody
    public Map<String, Object> adjustCredit(@RequestParam Long companyId, @RequestParam BigDecimal amount, @RequestParam String memo) {
        Map<String, Object> res = new HashMap<>();
        try {
            b2bFinancialService.adjustCreditLimit(1L, 1L, companyId, amount, memo, 1L);
            res.put("success", true);
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", e.getMessage());
        }
        return res;
    }

    @RequestMapping("/admin/financial/depositAdvance.ajax")
    @ResponseBody
    public Map<String, Object> depositAdvance(@RequestParam Long companyId, @RequestParam BigDecimal amount, @RequestParam String memo) {
        Map<String, Object> res = new HashMap<>();
        try {
            b2bFinancialService.processAdvancePayment(1L, 1L, companyId, amount, "DEPOSIT", memo, 1L);
            res.put("success", true);
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", e.getMessage());
        }
        return res;
    }
}
