package kr.co.matpam.common.aspect;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;
import com.fasterxml.jackson.databind.ObjectMapper;
import kr.co.matpam.admin.common.service.impl.AuditMapper;
import kr.co.matpam.common.util.MatpamContextHolder;

@Aspect
@Component
public class AuditAspect {

    private final AuditMapper auditMapper;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public AuditAspect(AuditMapper auditMapper) {
        this.auditMapper = auditMapper;
    }

    @AfterReturning(pointcut = "execution(* kr.co.matpam..service.*Service.*(..))", returning = "result")
    public void logAudit(JoinPoint joinPoint, Object result) {
        
        Long tenantId = MatpamContextHolder.getCurrentTenantId();
        Long userId = MatpamContextHolder.getCurrentUserId();

        // 로그인하지 않은 상태에서는 0L로 기록
        if (tenantId == null) tenantId = 0L;
        if (userId == null) userId = 0L;

        String methodName = joinPoint.getSignature().getName();
        String className = joinPoint.getTarget().getClass().getSimpleName();
        
        try {
            // 데이터 변경 관련 메서드 패턴 필터링
            if (methodName.matches(".*(insert|update|delete|save|create|remove).*")) {
                String changedData = (result != null) ? objectMapper.writeValueAsString(result) : "SUCCESS";
                auditMapper.insertAuditLog(tenantId, className, methodName, changedData, "SUCCESS", userId);
            }
        } catch (Exception e) {
            System.err.println("[AUDIT ERROR] Failed to record audit log: " + e.getMessage());
        }
    }
}