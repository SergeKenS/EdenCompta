package com.votreentreprise.pos;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.NONE)
@ActiveProfiles("test")
class SimpleContextTest {

    @Test
    void contextLoads() {
        // Test simple pour vérifier que le contexte Spring se charge
        System.out.println("✅ Contexte Spring chargé avec succès !");
    }
}
