package kr.co.matpam.admin;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.junit.Test;

public class HashGenTest {
    @Test
    public void genHash() {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        System.out.println("NEW_HASH_START:" + encoder.encode("qwe123!@#") + ":NEW_HASH_END");
    }
}
