package com.votreentreprise.pos.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.validation.annotation.Validated;

@Configuration
public class AppConfig {

    @Bean
    @ConfigurationProperties(prefix = "app")
    @Validated
    public AppProperties appProperties() {
        return new AppProperties();
    }

    public static class AppProperties {
        private String name = "POS Backend";
        private String version = "1.0.0";
        private boolean debugMode = false;

        // Getters et Setters
        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getVersion() {
            return version;
        }

        public void setVersion(String version) {
            this.version = version;
        }

        public boolean isDebugMode() {
            return debugMode;
        }

        public void setDebugMode(boolean debugMode) {
            this.debugMode = debugMode;
        }
    }
}