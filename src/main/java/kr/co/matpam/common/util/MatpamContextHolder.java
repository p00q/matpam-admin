package kr.co.matpam.common.util;

/**
 * 전역 테넌트 컨텍스트 홀더
 */
public class MatpamContextHolder {

    private static final ThreadLocal<Long> currentTenantId = new ThreadLocal<Long>() {
        @Override
        protected Long initialValue() {
            return 1L;
        }
    };

    private static final ThreadLocal<Long> currentUserId = new ThreadLocal<Long>();

    public static Long getCurrentTenantId() {
        Long id = currentTenantId.get();
        return id != null ? id : 1L;
    }

    public static void setCurrentTenantId(Long tenantId) {
        currentTenantId.set(tenantId);
    }

    public static Long getCurrentUserId() {
        return currentUserId.get();
    }

    public static void setCurrentUserId(Long userId) {
        currentUserId.set(userId);
    }

    public static void clear() {
        currentTenantId.remove();
        currentUserId.remove();
    }
}
