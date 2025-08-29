package com.votreentreprise.pos.rbac.integration;

import com.votreentreprise.pos.rbac.service.AuthorizationService;
import com.votreentreprise.pos.rbac.service.RbacService;
import com.votreentreprise.pos.users.domain.User;
import com.votreentreprise.pos.users.domain.UserRole;
import com.votreentreprise.pos.users.domain.UserStatus;
import com.votreentreprise.pos.users.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.util.Set;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@ActiveProfiles("test")
@Transactional
public class RbacIntegrationTest {

    @LocalServerPort
    private int port;

    @Autowired
    private TestRestTemplate restTemplate;

    @Autowired
    private UserService userService;

    @Autowired
    private AuthorizationService authorizationService;

    @Autowired
    private RbacService rbacService;

    private User managerUser;
    private User cashierUser;
    private User stockClerkUser;
    private UUID testStoreId;

    @BeforeEach
    void setUp() {
        // Utiliser le magasin de test existant
        testStoreId = com.votreentreprise.pos.utils.TestDataBuilder.TEST_STORE_ID;
        
        // Créer un utilisateur MANAGER
        managerUser = userService.createUser(
                "manager_test", "manager@test.com", "password123",
                "Manager", "Test", UserRole.MANAGER,
                testStoreId, "system"
        );

        // Créer un utilisateur CASHIER
        cashierUser = userService.createUser(
                "cashier_test", "cashier@test.com", "password123",
                "Cashier", "Test", UserRole.CASHIER,
                testStoreId, "system"
        );

        // Créer un utilisateur STOCK_MANAGER (qui sera mappé vers STOCK_CLERK)
        stockClerkUser = userService.createUser(
                "stock_test", "stock@test.com", "password123",
                "Stock", "Test", UserRole.STOCK_MANAGER,
                testStoreId, "system"
        );

        // Attribuer les rôles RBAC aux utilisateurs créés
        rbacService.assignRoleBasedOnUserRole(managerUser);
        rbacService.assignRoleBasedOnUserRole(cashierUser);
        rbacService.assignRoleBasedOnUserRole(stockClerkUser);
    }

    @Test
    void testManagerHasAllPermissions() {
        Set<String> permissions = authorizationService.getPermissionsForUser(managerUser.getId());
        
        assertThat(permissions).contains(
                "INVENTORY.ADD", "INVENTORY.EDIT", "INVENTORY.DELETE", "INVENTORY.RECEIVE",
                "SALE.MAKE", "SALE.REFUND",
                "CASH.OPEN", "CASH.CLOSE",
                "REPORTS.VIEW",
                "SETTINGS.MANAGE"
        );
    }

    @Test
    void testCashierHasSalesAndCashPermissions() {
        Set<String> permissions = authorizationService.getPermissionsForUser(cashierUser.getId());
        
        assertThat(permissions).contains(
                "SALE.MAKE", "SALE.REFUND",
                "CASH.OPEN", "CASH.CLOSE"
        );
        
        assertThat(permissions).doesNotContain(
                "INVENTORY.ADD", "INVENTORY.EDIT", "INVENTORY.DELETE",
                "REPORTS.VIEW", "SETTINGS.MANAGE"
        );
    }

    @Test
    void testStockClerkHasInventoryPermissions() {
        Set<String> permissions = authorizationService.getPermissionsForUser(stockClerkUser.getId());
        
        assertThat(permissions).contains(
                "INVENTORY.ADD", "INVENTORY.EDIT", "INVENTORY.RECEIVE"
        );
        
        assertThat(permissions).doesNotContain(
                "INVENTORY.DELETE",
                "SALE.MAKE", "SALE.REFUND",
                "CASH.OPEN", "CASH.CLOSE",
                "REPORTS.VIEW", "SETTINGS.MANAGE"
        );
    }

    @Test
    void testMePermissionsEndpoint() {
        // TODO: Implémenter avec authentification JWT
        // Pour l'instant, testons juste que le service fonctionne
        Set<String> managerPermissions = authorizationService.getPermissionsForUser(managerUser.getId());
        assertThat(managerPermissions).isNotEmpty();
        
        Set<String> cashierPermissions = authorizationService.getPermissionsForUser(cashierUser.getId());
        assertThat(cashierPermissions).isNotEmpty();
        
        Set<String> stockPermissions = authorizationService.getPermissionsForUser(stockClerkUser.getId());
        assertThat(stockPermissions).isNotEmpty();
    }

    @Test
    void testPermissionChecks() {
        // Test MANAGER
        assertThat(authorizationService.hasPermission(managerUser.getId(), "INVENTORY.ADD")).isTrue();
        assertThat(authorizationService.hasPermission(managerUser.getId(), "SALE.MAKE")).isTrue();
        assertThat(authorizationService.hasPermission(managerUser.getId(), "REPORTS.VIEW")).isTrue();
        
        // Test CASHIER
        assertThat(authorizationService.hasPermission(cashierUser.getId(), "SALE.MAKE")).isTrue();
        assertThat(authorizationService.hasPermission(cashierUser.getId(), "INVENTORY.ADD")).isFalse();
        assertThat(authorizationService.hasPermission(cashierUser.getId(), "REPORTS.VIEW")).isFalse();
        
        // Test STOCK_CLERK
        assertThat(authorizationService.hasPermission(stockClerkUser.getId(), "INVENTORY.ADD")).isTrue();
        assertThat(authorizationService.hasPermission(stockClerkUser.getId(), "SALE.MAKE")).isFalse();
        assertThat(authorizationService.hasPermission(stockClerkUser.getId(), "REPORTS.VIEW")).isFalse();
    }

    @Test
    void testAnyPermissionChecks() {
        // Test MANAGER
        assertThat(authorizationService.hasAnyPermission(managerUser.getId(), "INVENTORY.ADD", "SALE.MAKE")).isTrue();
        assertThat(authorizationService.hasAnyPermission(managerUser.getId(), "INVENTORY.ADD", "NON_EXISTENT")).isTrue();
        
        // Test CASHIER
        assertThat(authorizationService.hasAnyPermission(cashierUser.getId(), "SALE.MAKE", "INVENTORY.ADD")).isTrue();
        assertThat(authorizationService.hasAnyPermission(cashierUser.getId(), "INVENTORY.ADD", "REPORTS.VIEW")).isFalse();
    }
}
