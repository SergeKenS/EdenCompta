package com.votreentreprise.pos.config;

import org.springframework.boot.autoconfigure.flyway.FlywayMigrationStrategy;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;

@Configuration
@EnableTransactionManagement
public class DatabaseConfig {

    /**
     * Configuration spécifique pour les tests
     */
    @Bean
    @Profile("test")
    public FlywayMigrationStrategy cleanMigrateStrategy() {
        return flyway -> {
            // Pour les tests, on peut nettoyer et recréer
            flyway.clean();
            flyway.migrate();
        };
    }

    /**
     * Configuration pour la production - migration seulement
     */
    @Bean
    @Profile("prod")
    public FlywayMigrationStrategy migrationStrategy() {
        return flyway -> {
            // En production, on ne fait que migrer (pas de clean)
            flyway.migrate();
        };
    }

    /**
     * DataSource configuré pour la production si nécessaire
     */
    @Bean
    @Profile("prod")
    @ConfigurationProperties(prefix = "spring.datasource")
    @ConditionalOnProperty(name = "app.datasource.custom", havingValue = "true")
    public DataSource productionDataSource() {
        return DataSourceBuilder.create().build();
    }
}