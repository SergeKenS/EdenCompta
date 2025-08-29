package com.votreentreprise.pos.rbac.service;

import com.votreentreprise.pos.rbac.domain.Role;

import com.votreentreprise.pos.rbac.repository.RoleRepository;
import com.votreentreprise.pos.rbac.repository.UserRoleRepository;
import com.votreentreprise.pos.users.domain.User;
import com.votreentreprise.pos.users.domain.UserRole;
import com.votreentreprise.pos.users.domain.UserStatus;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
public class RbacServiceTest {

    @Autowired
    private RbacService rbacService;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private UserRoleRepository userRoleRepository;

    @Autowired
    private com.votreentreprise.pos.users.repository.UserRepository userRepository;

    private User testUser;
    private UUID testStoreId;

    @BeforeEach
    void setUp() {
        testStoreId = UUID.fromString("550e8400-e29b-41d4-a716-446655440000");
        
        // Créer un utilisateur de test
        testUser = new User();
        testUser.setUsername("test_user_" + System.currentTimeMillis()); // Nom unique
        testUser.setEmail("test" + System.currentTimeMillis() + "@example.com"); // Email unique
        testUser.setPasswordHash("password123");
        testUser.setFirstName("Test");
        testUser.setLastName("User");
        testUser.setRole(UserRole.MANAGER);
        testUser.setStatus(UserStatus.ACTIVE);
        
        // Sauvegarder l'utilisateur
        testUser = userRepository.save(testUser);
    }

    @Test
    void testAssignRoleToUser() {
        // Récupérer le rôle existant au lieu d'en créer un nouveau
        Role managerRole = roleRepository.findByKey("MANAGER")
                .orElseThrow(() -> new RuntimeException("Rôle MANAGER non trouvé"));

        // Attribuer le rôle à l'utilisateur
        rbacService.assignRoleToUser(testUser, "MANAGER");

        // Vérifier que l'attribution a été faite
        assertThat(userRoleRepository.existsByUserIdAndRoleId(testUser.getId(), managerRole.getId())).isTrue();
    }

    @Test
    void testAssignRoleBasedOnUserRole() {
        // Récupérer le rôle existant au lieu d'en créer un nouveau
        Role managerRole = roleRepository.findByKey("MANAGER")
                .orElseThrow(() -> new RuntimeException("Rôle MANAGER non trouvé"));

        // Attribuer le rôle basé sur le rôle utilisateur
        rbacService.assignRoleBasedOnUserRole(testUser);

        // Vérifier que l'attribution a été faite
        assertThat(userRoleRepository.existsByUserIdAndRoleId(testUser.getId(), managerRole.getId())).isTrue();
    }
}
