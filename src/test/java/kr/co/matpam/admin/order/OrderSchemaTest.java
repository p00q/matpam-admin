package kr.co.matpam.admin.order;

import javax.annotation.Resource;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import kr.co.matpam.admin.order.service.impl.OrderDAO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {
    "classpath:egovframework/spring/context-*.xml"
})
public class OrderSchemaTest {

    @Resource(name = "orderDAO")
    private OrderDAO orderDAO;

    @Test
    public void testFixSchema() throws Exception {
        System.out.println("--- Starting Schema Fix ---");
        try {
            orderDAO.fixOrderSchema();
            System.out.println("--- Schema Fix Applied Successfully ---");
        } catch (Exception e) {
            System.err.println("--- Schema Fix Failed or Already Applied: " + e.getMessage());
        }
    }
}
