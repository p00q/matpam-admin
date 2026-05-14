package kr.co.matpam.common.aspect;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;
import kr.co.matpam.common.annotation.RequiresTenant;
import kr.co.matpam.common.service.MatpamBaseVO;

@Aspect
@Component
public class TenantAspect {
    @Around("@annotation(requiresTenant)")
    public Object enforceTenantContext(ProceedingJoinPoint joinPoint, RequiresTenant requiresTenant) throws Throwable {
        // 1. 제외 대상 URL 및 세션 유무 체크 (미인증 사용자는 인터셉터에 맡김)
        try {
            org.springframework.web.context.request.ServletRequestAttributes attrs = (org.springframework.web.context.request.ServletRequestAttributes) org.springframework.web.context.request.RequestContextHolder.getRequestAttributes();
            if (attrs != null) {
                javax.servlet.http.HttpServletRequest request = attrs.getRequest();
                String uri = request.getRequestURI();
                
                // 로그인/로그아웃 관련은 무조건 통과
                if (uri.contains("/admin/login.do") || uri.contains("/admin/actionLogin.do") || uri.contains("/admin/logout.do")) {
                    return joinPoint.proceed();
                }

                // 세션이 없으면 통과 (인터셉터가 처리하도록 유도)
                javax.servlet.http.HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("loginVO") == null) {
                    return joinPoint.proceed();
                }
            }
        } catch (Exception e) {}

        // 2. 인증된 사용자의 테넌트 체크 (세션은 있는데 테넌트 정보만 유실된 경우 차단)
        Object[] args = joinPoint.getArgs();
        for (int i = 0; i < args.length; i++) {
            if (args[i] instanceof MatpamBaseVO) {
                MatpamBaseVO vo = (MatpamBaseVO) args[i];
                if (vo != null) {
                    Long tid = vo.getTenantId();
                    if (tid == null || tid <= 0) {
                        throw new IllegalStateException("테넌트 정보를 찾을 수 없습니다. (Session exists but No Tenant ID)");
                    }
                }
            }
        }
        return joinPoint.proceed();
    }
}
