package kr.co.matpam.common.aspect;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;
import kr.co.matpam.common.annotation.RequiresTenant;
import kr.co.matpam.common.service.MatpamBaseVO;
import kr.co.matpam.common.util.MatpamContextHolder;
import java.util.Map;

@Aspect
@Component
public class TenantAspect {

    @Around("@annotation(requiresTenant)")
    public Object enforceTenantContext(ProceedingJoinPoint joinPoint, RequiresTenant requiresTenant) throws Throwable {
        
        Long currentTenantId = MatpamContextHolder.getCurrentTenantId();

        if (currentTenantId == null) {
            // 로그인하지 않은 상태에서 테넌트가 필요한 요청을 보낸 경우
            throw new IllegalStateException("테넌트 컨텍스트를 찾을 수 없습니다. 로그인이 필요합니다.");
        }

        Object[] args = joinPoint.getArgs();
        for (int i = 0; i < args.length; i++) {
            if (args[i] == null) continue;

            if (args[i] instanceof Map) {
                @SuppressWarnings("unchecked")
                Map<String, Object> paramMap = (Map<String, Object>) args[i];
                paramMap.put("tenantId", currentTenantId);
            } else if (args[i] instanceof MatpamBaseVO) {
                // MatpamBaseVO를 상속받은 모든 객체에 테넌트 ID 강제 주입
                ((MatpamBaseVO) args[i]).setTenantId(currentTenantId);
            }
        }

        return joinPoint.proceed(args);
    }
}