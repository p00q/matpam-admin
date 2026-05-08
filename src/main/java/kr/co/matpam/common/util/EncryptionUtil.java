package kr.co.matpam.common.util;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.ByteBuffer;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * 고성능 보안 암호화 유틸리티 (AES/GCM/NoPadding)
 * 
 * - IV: 매번 랜덤 생성 (12 bytes)
 * - Tag: 16 bytes (128 bits)
 * - 결과 구조: [IV (12)] + [Ciphertext] + [Tag (16)] -> Base64 Encoding
 */
public class EncryptionUtil {

    private static final String ALGORITHM = "AES/GCM/NoPadding";
    private static final int TAG_LENGTH_BIT = 128;
    private static final int IV_LENGTH_BYTE = 12;
    private static final int CURRENT_KEY_VERSION = 1;

    // 환경변수에서 키를 읽어옵니다. (실제 운영 시에는 시스템 환경변수 MATPAM_ENCRYPTION_KEY 설정 필요)
    private static final String SECRET_KEY_STR = System.getenv("MATPAM_ENCRYPTION_KEY") != null 
            ? System.getenv("MATPAM_ENCRYPTION_KEY") 
            : "MATPAM_DEFAULT_SECRET_KEY_32BYTE_!!"; // 32 chars for AES-256

    /**
     * 데이터를 암호화합니다.
     */
    public static String encrypt(String plainText) throws Exception {
        if (plainText == null || plainText.isEmpty()) return plainText;

        byte[] iv = new byte[IV_LENGTH_BYTE];
        new SecureRandom().nextBytes(iv);

        Cipher cipher = Cipher.getInstance(ALGORITHM);
        GCMParameterSpec spec = new GCMParameterSpec(TAG_LENGTH_BIT, iv);
        cipher.init(Cipher.ENCRYPT_MODE, getSecretKey(), spec);

        byte[] cipherText = cipher.doFinal(plainText.getBytes("UTF-8"));

        // IV + CipherText (contains Tag at the end in GCM)
        ByteBuffer bb = ByteBuffer.allocate(iv.length + cipherText.length);
        bb.put(iv);
        bb.put(cipherText);

        return Base64.getEncoder().encodeToString(bb.array());
    }

    /**
     * 데이터를 복호화합니다.
     */
    public static String decrypt(String encryptedText) throws Exception {
        if (encryptedText == null || encryptedText.isEmpty()) return encryptedText;

        byte[] decode = Base64.getDecoder().decode(encryptedText);
        
        ByteBuffer bb = ByteBuffer.wrap(decode);
        byte[] iv = new byte[IV_LENGTH_BYTE];
        bb.get(iv);
        
        byte[] cipherText = new byte[bb.remaining()];
        bb.get(cipherText);

        Cipher cipher = Cipher.getInstance(ALGORITHM);
        GCMParameterSpec spec = new GCMParameterSpec(TAG_LENGTH_BIT, iv);
        cipher.init(Cipher.DECRYPT_MODE, getSecretKey(), spec);

        byte[] plainText = cipher.doFinal(cipherText);

        return new String(plainText, "UTF-8");
    }

    /**
     * 계좌번호 해시 생성 (검색/중복체크용 SHA-256)
     */
    public static String hash(String text) throws Exception {
        if (text == null || text.isEmpty()) return null;
        java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(text.getBytes("UTF-8"));
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    }

    /**
     * 현재 사용 중인 키 버전을 반환합니다.
     */
    public static int getKeyVersion() {
        return CURRENT_KEY_VERSION;
    }

    private static SecretKey getSecretKey() {
        byte[] keyBytes = SECRET_KEY_STR.getBytes();
        // AES-256을 위해 32바이트(256비트) 키 사용
        byte[] finalKey = new byte[32];
        System.arraycopy(keyBytes, 0, finalKey, 0, Math.min(keyBytes.length, 32));
        return new SecretKeySpec(finalKey, "AES");
    }
}
