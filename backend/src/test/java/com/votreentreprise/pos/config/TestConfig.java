package com.votreentreprise.pos.config;

import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.Profile;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import com.votreentreprise.pos.security.JwtTokenProvider;

@Configuration
@Profile("test")
@EnableTransactionManagement
@EntityScan(basePackages = "com.votreentreprise.pos")
@EnableJpaRepositories(basePackages = "com.votreentreprise.pos")
public class TestConfig {
    // Configuration minimale pour les tests d'intégration
    // - Active la découverte des entités JPA
    // - Active la découverte des repositories
    // - Fournit des beans mock pour la sécurité

    @Bean
    @Primary
    public AuthenticationManager mockAuthenticationManager() {
        return new AuthenticationManager() {
            @Override
            public Authentication authenticate(Authentication authentication) throws AuthenticationException {
                // Mock implementation pour les tests
                return authentication;
            }
        };
    }

    @Bean
    @Primary
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
