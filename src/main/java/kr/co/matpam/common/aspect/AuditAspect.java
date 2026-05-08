package kr.co.matpam.common.aspect;

import javax.annotation.Resource;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;
import com.fasterxml.jackson.databind.ObjectMapper;
import kr.co.matpam.admin.common.service.impl.AuditMapper;
import kr.co.matpam.common.util.MatpamContextHolder;

/**
 * 서비스 실행 후 감사 로그를 자동으로 기록하는 Aspect
 */
@Aspect
@Component
public class AuditAspect {

    @Resource(name = "auditMapper")
    private AuditMapper auditMapper;

    private final ObjectMapper objectMapper = new ObjectMapper();

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
            // 데이터 변경 관련 메서드 패턴 필터링 (insert, update, delete 등)
            if (methodName.matches(".*(insert|update|delete|save|create|remove).*")) {
                String changedData;
                if (result != null) {
                    // 보안: 민감 정보 마스킹/제거 후 저장
                    String rawJson = objectMapper.writeValueAsString(result);
                    // passwordHash 필드 등 민감 정보는 제거하거나 마스킹
                    changedData = rawJson.replaceAll("\"passwordHash\":\"[^\"]*\"", "\"passwordHash\":\"[MASKED]\"");
                } else {
                    changedData = "SUCCESS";
                }
                
                kr.co.matpam.admin.common.service.AuditVO auditVO = new kr.co.matpam.admin.common.service.AuditVO();
                auditVO.setTenantId(tenantId);
                auditVO.setEntityName(className);
                auditVO.setActionType(methodName);
                auditVO.setAfterJson(changedData);
                auditVO.setActorUserId(userId);
                
                auditMapper.insertAuditLog(auditVO);
            }
        } catch (Exception e) {
            // 로깅 실패가 비즈니스 로직에 영향을 주지 않도록 예외 처리
            System.err.println("[AUDIT ERROR] Failed to record audit log: " + e.getMessage());
        }
    }
}