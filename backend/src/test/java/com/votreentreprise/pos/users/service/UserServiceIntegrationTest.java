package com.votreentreprise.pos.users.service;

import com.votreentreprise.pos.users.domain.User;
import com.votreentreprise.pos.users.domain.UserRole;
import com.votreentreprise.pos.users.domain.UserStatus;
import com.votreentreprise.pos.utils.TestDataBuilder;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
@Transactional
@ActiveProfiles("test")
class UserServiceIntegrationTest {

    @Autowired
    private UserService userService;

    private UUID testStoreId;
    private String testUserId;

    @BeforeEach
    void setUp() {
        testStoreId = TestDataBuilder.TEST_STORE_ID;
        testUserId = "test-user";
    }

    @Test
    void shouldCreateUser() {
        // Given
        String username = "testuser";
        String email = "test@example.com";
        String password = "password123";
        String firstName = "Test";
        String lastName = "User";
        UserRole role = UserRole.CASHIER;

        // When
        User user = userService.createUser(username, email, password, firstName, lastName, role, testStoreId, testUserId);

        // Then
        assertThat(user).isNotNull();
        assertThat(user.getId()).isNotNull();
        assertThat(user.getUsername()).isEqualTo(username);
        assertThat(user.getEmail()).isEqualTo(email);
        assertThat(user.getFirstName()).isEqualTo(firstName);
        assertThat(user.getLastName()).isEqualTo(lastName);
        assertThat(user.getRole()).isEqualTo(role);
        assertThat(user.getStatus()).isEqualTo(UserStatus.PENDING_ACTIVATION);
        assertThat(user.getStore().getId()).isEqualTo(testStoreId);
        assertThat(user.getCreatedBy()).isEqualTo(testUserId);
        assertThat(user.getCreatedAt()).isNotNull();
        assertThat(user.checkPassword(password)).isTrue();
    }

    @Test
    void shouldNotCreateUserWithDuplicateUsername() {
        // Given
        String username = "duplicateuser";
        userService.createUser(username, "first@example.com", "password123", "First", "User", UserRole.CASHIER, testStoreId, testUserId);

        // When & Then
        assertThatThrownBy(() -> userService.createUser(username, "second@example.com", "password123", "Second", "User", UserRole.CASHIER, testStoreId, testUserId))
                .isInstanceOf(com.votreentreprise.pos.common.exceptions.BusinessException.class)
                .hasMessageContaining("Ce nom d'utilisateur est déjà utilisé");
    }

    @Test
    void shouldNotCreateUserWithDuplicateEmail() {
        // Given
        String email = "duplicate@example.com";
        userService.createUser("firstuser", email, "password123", "First", "User", UserRole.CASHIER, testStoreId, testUserId);

        // When & Then
        assertThatThrownBy(() -> userService.createUser("seconduser", email, "password123", "Second", "User", UserRole.CASHIER, testStoreId, testUserId))
                .isInstanceOf(com.votreentreprise.pos.common.exceptions.BusinessException.class)
                .hasMessageContaining("Cette adresse email est déjà utilisée");
    }

    @Test
    void shouldNotCreateUserWithWeakPassword() {
        // Given
        String weakPassword = "123";

        // When & Then
        assertThatThrownBy(() -> userService.createUser("testuser", "test@example.com", weakPassword, "Test", "User", UserRole.CASHIER, testStoreId, testUserId))
                .isInstanceOf(com.votreentreprise.pos.common.exceptions.BusinessException.class)
                .hasMessageContaining("Le mot de passe doit contenir au moins 8 caractères");
    }

    @Test
    void shouldAuthenticateUser() {
        // Given
        String username = "authuser";
        String password = "password123";
        User user = userService.createUser(username, "auth@example.com", password, "Auth", "User", UserRole.CASHIER, testStoreId, testUserId);
        userService.activateUser(user.getId(), testUserId);

        // When
        User authenticatedUser = userService.authenticateUser(username, password);

        // Then
        assertThat(authenticatedUser).isNotNull();
        assertThat(authenticatedUser.getId()).isEqualTo(user.getId());
        assertThat(authenticatedUser.getLastLogin()).isNotNull();
        assertThat(authenticatedUser.getFailedLoginAttempts()).isEqualTo(0);
    }

    @Test
    void shouldNotAuthenticateInactiveUser() {
        // Given
        String username = "inactiveuser";
        String password = "password123";
        User user = userService.createUser(username, "inactive@example.com", password, "Inactive", "User", UserRole.CASHIER, testStoreId, testUserId);
        // User remains PENDING_ACTIVATION

        // When & Then
        assertThatThrownBy(() -> userService.authenticateUser(username, password))
                .isInstanceOf(com.votreentreprise.pos.common.exceptions.BusinessException.class)
                .hasMessageContaining("Compte utilisateur non actif");
    }

    @Test
    void shouldNotAuthenticateWithWrongPassword() {
        // Given
        String username = "wrongpassuser";
        String password = "password123";
        User user = userService.createUser(username, "wrongpass@example.com", password, "WrongPass", "User", UserRole.CASHIER, testStoreId, testUserId);
        userService.activateUser(user.getId(), testUserId);

        // When & Then
        assertThatThrownBy(() -> userService.authenticateUser(username, "wrongpassword"))
                .isInstanceOf(com.votreentreprise.pos.common.exceptions.BusinessException.class)
                .hasMessageContaining("Nom d'utilisateur ou mot de passe incorrect");
    }

    @Test
    void shouldLockAccountAfterMultipleFailedLogins() {
        // Given
        String username = "lockuser";
        String password = "password123";
        User user = userService.createUser(username, "lock@example.com", password, "Lock", "User", UserRole.CASHIER, testStoreId, testUserId);
        userService.activateUser(user.getId(), testUserId);

        // When - Attempt 5 failed logins
        for (int i = 0; i < 5; i++) {
            try {
                userService.authenticateUser(username, "wrongpassword");
            } catch (Exception e) {
                // Expected to fail
            }
        }

        // Then
        assertThat(userService.isAccountLocked(user.getId())).isTrue();
        
        // Should not be able to login even with correct password
        assertThatThrownBy(() -> userService.authenticateUser(username, password))
                .isInstanceOf(com.votreentreprise.pos.common.exceptions.BusinessException.class)
                .hasMessageContaining("Compte temporairement verrouillé");
    }

    @Test
    void shouldUnlockAccount() {
        // Given
        String username = "unlockuser";
        String password = "password123";
        User user = userService.createUser(username, "unlock@example.com", password, "Unlock", "User", UserRole.CASHIER, testStoreId, testUserId);
        userService.activateUser(user.getId(), testUserId);

        // Lock account
        for (int i = 0; i < 5; i++) {
            try {
                userService.authenticateUser(username, "wrongpassword");
            } catch (Exception e) {
                // Expected to fail
            }
        }

        // When
        userService.unlockAccount(user.getId());

        // Then
        assertThat(userService.isAccountLocked(user.getId())).isFalse();
        
        // Should be able to login again
        User authenticatedUser = userService.authenticateUser(username, password);
        assertThat(authenticatedUser).isNotNull();
    }

    @Test
    void shouldUpdateUser() {
        // Given
        User user = userService.createUser("updateuser", "update@example.com", "password123", "Update", "User", UserRole.CASHIER, testStoreId, testUserId);
        String newFirstName = "Updated";
        String newLastName = "Name";
        String newEmail = "updated@example.com";
        String newPhone = "1234567890";

        // When
        User updatedUser = userService.updateUser(user.getId(), newFirstName, newLastName, newEmail, newPhone, UserRole.MANAGER, testStoreId);

        // Then
        assertThat(updatedUser.getFirstName()).isEqualTo(newFirstName);
        assertThat(updatedUser.getLastName()).isEqualTo(newLastName);
        assertThat(updatedUser.getEmail()).isEqualTo(newEmail);
        assertThat(updatedUser.getPhone()).isEqualTo(newPhone);
        assertThat(updatedUser.getRole()).isEqualTo(UserRole.MANAGER);
    }

    @Test
    void shouldActivateUser() {
        // Given
        User user = userService.createUser("activateuser", "activate@example.com", "password123", "Activate", "User", UserRole.CASHIER, testStoreId, testUserId);
        assertThat(user.getStatus()).isEqualTo(UserStatus.PENDING_ACTIVATION);

        // When
        User activatedUser = userService.activateUser(user.getId(), testUserId);

        // Then
        assertThat(activatedUser.getStatus()).isEqualTo(UserStatus.ACTIVE);
    }

    @Test
    void shouldDeactivateUser() {
        // Given
        User user = userService.createUser("deactivateuser", "deactivate@example.com", "password123", "Deactivate", "User", UserRole.CASHIER, testStoreId, testUserId);
        userService.activateUser(user.getId(), testUserId);

        // When
        User deactivatedUser = userService.deactivateUser(user.getId(), testUserId);

        // Then
        assertThat(deactivatedUser.getStatus()).isEqualTo(UserStatus.INACTIVE);
    }

    @Test
    void shouldSuspendUser() {
        // Given
        User user = userService.createUser("suspenduser", "suspend@example.com", "password123", "Suspend", "User", UserRole.CASHIER, testStoreId, testUserId);
        userService.activateUser(user.getId(), testUserId);

        // When
        User suspendedUser = userService.suspendUser(user.getId(), "Violation des règles", testUserId);

        // Then
        assertThat(suspendedUser.getStatus()).isEqualTo(UserStatus.SUSPENDED);
    }

    @Test
    void shouldGetUsersByStore() {
        // Given
        userService.createUser("storeuser1", "store1@example.com", "password123", "Store1", "User", UserRole.CASHIER, testStoreId, testUserId);
        userService.createUser("storeuser2", "store2@example.com", "password123", "Store2", "User", UserRole.MANAGER, testStoreId, testUserId);

        // When
        List<User> users = userService.getUsersByStore(testStoreId);

        // Then
        assertThat(users).hasSizeGreaterThanOrEqualTo(2);
        assertThat(users).allMatch(user -> user.getStore().getId().equals(testStoreId));
    }

    @Test
    void shouldGetUsersByRole() {
        // Given
        userService.createUser("roleuser1", "role1@example.com", "password123", "Role1", "User", UserRole.CASHIER, testStoreId, testUserId);
        userService.createUser("roleuser2", "role2@example.com", "password123", "Role2", "User", UserRole.MANAGER, testStoreId, testUserId);

        // When
        List<User> cashiers = userService.getUsersByRole(UserRole.CASHIER);
        List<User> managers = userService.getUsersByRole(UserRole.MANAGER);

        // Then
        assertThat(cashiers).anyMatch(user -> user.getRole() == UserRole.CASHIER);
        assertThat(managers).anyMatch(user -> user.getRole() == UserRole.MANAGER);
    }

    @Test
    void shouldGetUsersByStatus() {
        // Given
        User user1 = userService.createUser("statususer1", "status1@example.com", "password123", "Status1", "User", UserRole.CASHIER, testStoreId, testUserId);
        User user2 = userService.createUser("statususer2", "status2@example.com", "password123", "Status2", "User", UserRole.MANAGER, testStoreId, testUserId);
        userService.activateUser(user1.getId(), testUserId);

        // When
        List<User> activeUsers = userService.getUsersByStatus(UserStatus.ACTIVE);
        List<User> pendingUsers = userService.getUsersByStatus(UserStatus.PENDING_ACTIVATION);

        // Then
        assertThat(activeUsers).anyMatch(user -> user.getId().equals(user1.getId()));
        assertThat(pendingUsers).anyMatch(user -> user.getId().equals(user2.getId()));
    }

    @Test
    void shouldGetActiveUsers() {
        // Given
        User user1 = userService.createUser("activeuser1", "active1@example.com", "password123", "Active1", "User", UserRole.CASHIER, testStoreId, testUserId);
        User user2 = userService.createUser("activeuser2", "active2@example.com", "password123", "Active2", "User", UserRole.MANAGER, testStoreId, testUserId);
        userService.activateUser(user1.getId(), testUserId);
        userService.activateUser(user2.getId(), testUserId);

        // When
        List<User> activeUsers = userService.getActiveUsers();

        // Then
        assertThat(activeUsers).hasSizeGreaterThanOrEqualTo(2);
        assertThat(activeUsers).allMatch(User::isActive);
    }

    @Test
    void shouldSearchUsers() {
        // Given
        userService.createUser("searchuser1", "search1@example.com", "password123", "Search1", "User", UserRole.CASHIER, testStoreId, testUserId);
        userService.createUser("searchuser2", "search2@example.com", "password123", "Search2", "User", UserRole.MANAGER, testStoreId, testUserId);

        // When
        List<User> searchResults = userService.searchUsers("Search");

        // Then
        assertThat(searchResults).hasSizeGreaterThanOrEqualTo(2);
        assertThat(searchResults).allMatch(user -> 
            user.getFirstName().contains("Search") || 
            user.getLastName().contains("Search") ||
            user.getUsername().contains("Search")
        );
    }

    @Test
    void shouldGetUsersByStorePageable() {
        // Given
        for (int i = 1; i <= 15; i++) {
            userService.createUser(
                "pageuser" + i, 
                "page" + i + "@example.com", 
                "password123", 
                "Page" + i, 
                "User", 
                UserRole.CASHIER, 
                testStoreId, 
                testUserId
            );
        }

        // When
        Page<User> firstPage = userService.getUsersByStore(testStoreId, PageRequest.of(0, 10));
        Page<User> secondPage = userService.getUsersByStore(testStoreId, PageRequest.of(1, 10));

        // Then
        assertThat(firstPage.getContent()).hasSize(10);
        assertThat(firstPage.getTotalElements()).isGreaterThanOrEqualTo(15);
        assertThat(secondPage.getContent()).hasSizeGreaterThanOrEqualTo(5);
    }

    @Test
    void shouldCountUsersByStatus() {
        // Given
        User user1 = userService.createUser("countuser1", "count1@example.com", "password123", "Count1", "User", UserRole.CASHIER, testStoreId, testUserId);
        User user2 = userService.createUser("countuser2", "count2@example.com", "password123", "Count2", "User", UserRole.MANAGER, testStoreId, testUserId);
        userService.activateUser(user1.getId(), testUserId);

        // When
        long activeCount = userService.countUsersByStatus(UserStatus.ACTIVE);
        long pendingCount = userService.countUsersByStatus(UserStatus.PENDING_ACTIVATION);

        // Then
        assertThat(activeCount).isGreaterThanOrEqualTo(1);
        assertThat(pendingCount).isGreaterThanOrEqualTo(1);
    }

    @Test
    void shouldCheckUsernameAvailability() {
        // Given
        String username = "availableuser";

        // When
        boolean isAvailable = userService.isUsernameAvailable(username);

        // Then
        assertThat(isAvailable).isTrue();

        // Create user with this username
        userService.createUser(username, "available@example.com", "password123", "Available", "User", UserRole.CASHIER, testStoreId, testUserId);

        // Check again
        boolean isStillAvailable = userService.isUsernameAvailable(username);
        assertThat(isStillAvailable).isFalse();
    }

    @Test
    void shouldCheckEmailAvailability() {
        // Given
        String email = "available@example.com";

        // When
        boolean isAvailable = userService.isEmailAvailable(email);

        // Then
        assertThat(isAvailable).isTrue();

        // Create user with this email
        userService.createUser("availableuser", email, "password123", "Available", "User", UserRole.CASHIER, testStoreId, testUserId);

        // Check again
        boolean isStillAvailable = userService.isEmailAvailable(email);
        assertThat(isStillAvailable).isFalse();
    }

    @Test
    void shouldCheckRolePermissions() {
        // Given
        User user = userService.createUser("permissionuser", "permission@example.com", "password123", "Permission", "User", UserRole.MANAGER, testStoreId, testUserId);

        // When & Then
        assertThat(userService.hasRole(user.getId(), UserRole.MANAGER)).isTrue();
        assertThat(userService.hasRole(user.getId(), UserRole.CASHIER)).isFalse();
        assertThat(userService.hasAnyRole(user.getId(), UserRole.MANAGER, UserRole.CASHIER)).isTrue();
        assertThat(userService.canPerformAction(user.getId(), "MANAGE_SALES")).isTrue();
        assertThat(userService.canPerformAction(user.getId(), "MANAGE_STORES")).isFalse();
    }

    @Test
    void shouldChangePassword() {
        // Given
        String username = "changepassuser";
        String oldPassword = "oldpassword123";
        String newPassword = "newpassword123";
        User user = userService.createUser(username, "changepass@example.com", oldPassword, "ChangePass", "User", UserRole.CASHIER, testStoreId, testUserId);
        userService.activateUser(user.getId(), testUserId);

        // When
        userService.changePassword(user.getId(), oldPassword, newPassword);

        // Then
        User updatedUser = userService.getUserById(user.getId());
        assertThat(updatedUser.checkPassword(newPassword)).isTrue();
        assertThat(updatedUser.checkPassword(oldPassword)).isFalse();
    }

    @Test
    void shouldNotChangePasswordWithWrongCurrentPassword() {
        // Given
        String username = "wrongpassuser";
        String oldPassword = "oldpassword123";
        String newPassword = "newpassword123";
        User user = userService.createUser(username, "wrongpass@example.com", oldPassword, "WrongPass", "User", UserRole.CASHIER, testStoreId, testUserId);
        userService.activateUser(user.getId(), testUserId);

        // When & Then
        assertThatThrownBy(() -> userService.changePassword(user.getId(), "wrongoldpassword", newPassword))
                .isInstanceOf(com.votreentreprise.pos.common.exceptions.BusinessException.class)
                .hasMessageContaining("Mot de passe actuel incorrect");
    }

    @Test
    void shouldAssignUserToStore() {
        // Given
        User user = userService.createUser("assignuser", "assign@example.com", "password123", "Assign", "User", UserRole.CASHIER, null, testUserId);

        // When
        userService.assignUserToStore(user.getId(), testStoreId);

        // Then
        User updatedUser = userService.getUserById(user.getId());
        assertThat(updatedUser.getStore().getId()).isEqualTo(testStoreId);
    }

    @Test
    void shouldRemoveUserFromStore() {
        // Given
        User user = userService.createUser("removeuser", "remove@example.com", "password123", "Remove", "User", UserRole.CASHIER, testStoreId, testUserId);

        // When
        userService.removeUserFromStore(user.getId());

        // Then
        User updatedUser = userService.getUserById(user.getId());
        assertThat(updatedUser.getStore()).isNull();
    }
}




