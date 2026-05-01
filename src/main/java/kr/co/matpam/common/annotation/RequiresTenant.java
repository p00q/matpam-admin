package kr.co.matpam.common.annotation;

import java.lang.annotation.*;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface RequiresTenant {
    // 이 메서드가 실행될 때 반드시 필요한 테넌트 ID를 지정할 수 있음 (선택적)
}