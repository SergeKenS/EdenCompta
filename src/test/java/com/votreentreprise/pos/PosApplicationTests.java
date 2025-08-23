package com.votreentreprise.pos;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest(properties = {"spring.main.web-application-type=none"})
@ActiveProfiles("test")
class PosApplicationTests {

    @Test
    void contextLoads() {
        // Ce test vérifie que le contexte Spring se charge correctement
        // Avec web-application-type=none pour éviter le serveur web
    }
}