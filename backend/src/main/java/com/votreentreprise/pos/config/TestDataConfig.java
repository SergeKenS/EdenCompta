package com.votreentreprise.pos.config;

import com.votreentreprise.pos.store.domain.Store;
import com.votreentreprise.pos.store.repository.StoreRepository;
import com.votreentreprise.pos.users.domain.User;
import com.votreentreprise.pos.users.domain.UserRole;
import com.votreentreprise.pos.users.domain.UserStatus;
import com.votreentreprise.pos.users.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.util.UUID;

@Configuration
@Profile("dev")
public class TestDataConfig {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StoreRepository storeRepository;

    @Bean
    public CommandLineRunner loadTestData() {
        return args -> {
            // Vérifier si les données de test existent déjà
            if (userRepository.count() > 0) {
                System.out.println("Données de test déjà présentes, skip...");
                return;
            }

            System.out.println("Chargement des données de test...");

            // Créer un magasin de test
            Store testStore = new Store();
            testStore.setId(UUID.fromString("550e8400-e29b-41d4-a716-446655440000"));
            testStore.setName("Magasin Test");
            testStore.setAddress("123 Rue Test");
            testStore.setPhone("0123456789");
            storeRepository.save(testStore);

            // Créer les utilisateurs de test
            BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
            String passwordHash = encoder.encode("admin123");

            // Super Admin
            User admin = new User();
            admin.setId(UUID.fromString("550e8400-e29b-41d4-a716-446655440050"));
            admin.setUsername("admin");
            admin.setEmail("admin@pos.com");
            admin.setPasswordHash(passwordHash);
            admin.setFirstName("Super");
            admin.setLastName("Administrateur");
            admin.setRole(UserRole.SUPER_ADMIN);
            admin.setStatus(UserStatus.ACTIVE);
            admin.setCreatedBy("system");
            userRepository.save(admin);

            // Manager
            User manager = new User();
            manager.setId(UUID.fromString("550e8400-e29b-41d4-a716-446655440051"));
            manager.setUsername("manager1");
            manager.setEmail("manager1@pos.com");
            manager.setPasswordHash(passwordHash);
            manager.setFirstName("Jean");
            manager.setLastName("Dupont");
            manager.setRole(UserRole.MANAGER);
            manager.setStatus(UserStatus.ACTIVE);
            manager.setStore(testStore);
            manager.setCreatedBy("admin");
            userRepository.save(manager);

            // Caissier
            User cashier = new User();
            cashier.setId(UUID.fromString("550e8400-e29b-41d4-a716-446655440052"));
            cashier.setUsername("cashier1");
            cashier.setEmail("cashier1@pos.com");
            cashier.setPasswordHash(passwordHash);
            cashier.setFirstName("Marie");
            cashier.setLastName("Martin");
            cashier.setRole(UserRole.CASHIER);
            cashier.setStatus(UserStatus.ACTIVE);
            cashier.setStore(testStore);
            cashier.setCreatedBy("admin");
            userRepository.save(cashier);

            System.out.println("Données de test chargées avec succès !");
            System.out.println("Utilisateurs créés :");
            System.out.println("- admin (SUPER_ADMIN) - Email: admin@pos.com");
            System.out.println("- manager1 (MANAGER) - Email: manager1@pos.com");
            System.out.println("- cashier1 (CASHIER) - Email: cashier1@pos.com");
        };
    }
}
