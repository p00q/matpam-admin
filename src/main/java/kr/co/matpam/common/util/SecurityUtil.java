package kr.co.matpam.common.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 보안 및 개인정보 마스킹 유틸리티
 */
public class SecurityUtil {

    /**
     * 이름 마스킹 (2자: 홍*, 3자: 홍*동, 4자 이상: 홍**동)
     */
    public static String maskName(String name) {
        if (name == null || name.length() < 2) return name;
        if (name.length() == 2) return name.substring(0, 1) + "*";
        
        return name.substring(0, 1) + "*".repeat(name.length() - 2) + name.substring(name.length() - 1);
    }

    /**
     * 휴대폰 번호 마스킹 (010-****-1234)
     */
    public static String maskMobile(String mobile) {
        if (mobile == null || mobile.isEmpty()) return mobile;
        
        String regex = "(\\d{2,3})-(\\d{3,4})-(\\d{4})";
        Matcher matcher = Pattern.compile(regex).matcher(mobile);
        
        if (matcher.find()) {
            return matcher.group(1) + "-****-" + matcher.group(3);
        }
        return mobile;
    }

    /**
     * 이메일 마스킹 (ab****@domain.com)
     */
    public static String maskEmail(String email) {
        if (email == null || !email.contains("@")) return email;
        
        String[] parts = email.split("@");
        String id = parts[0];
        String domain = parts[1];
        
        if (id.length() <= 2) return id + "****@" + domain;
        return id.substring(0, 2) + "****@" + domain;
    }

    /**
     * 사업자번호 마스킹 (123-**-*****)
     */
    public static String maskBusinessNo(String businessNo) {
        if (businessNo == null || businessNo.isEmpty()) return businessNo;
        
        String regex = "(\\d{3})-(\\d{2})-(\\d{5})";
        Matcher matcher = Pattern.compile(regex).matcher(businessNo);
        
        if (matcher.find()) {
            return matcher.group(1) + "-**-*****";
        }
        return businessNo;
    }
}
