package kr.co.matpam.admin.logistics.web;

import java.util.HashMap;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import kr.co.matpam.admin.logistics.service.ShipmentService;
import kr.co.matpam.admin.logistics.service.ShipmentVO;

@Controller
public class LogisticsController {

    @Resource(name = "shipmentService")
    private ShipmentService shipmentService;

    @RequestMapping("/admin/logistics/saveShipment.ajax")
    @ResponseBody
    public Map<String, Object> saveShipment(ShipmentVO shipmentVO) {
        Map<String, Object> res = new HashMap<>();
        try {
            shipmentService.processShipping(shipmentVO);
            res.put("success", true);
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", e.getMessage());
        }
        return res;
    }
}
