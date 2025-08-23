package com.votreentreprise.pos.users.service;

import com.votreentreprise.pos.users.domain.User;
import com.votreentreprise.pos.users.domain.UserRole;
import com.votreentreprise.pos.users.domain.UserStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public interface UserService {

    // Authentication
    User authenticateUser(String username, String password);
    void recordSuccessfulLogin(UUID userId);
    void recordFailedLogin(UUID userId);
    boolean isAccountLocked(UUID userId);
    void unlockAccount(UUID userId);

    // CRUD operations
    User createUser(String username, String email, String password, String firstName, 
                   String lastName, UserRole role, UUID storeId, String createdBy);
    
    User getUserById(UUID userId);
    User getUserByUsername(String username);
    User getUserByEmail(String email);
    
    User updateUser(UUID userId, String firstName, String lastName, String email, 
                   String phone, UserRole role, UUID storeId);
    
    void deleteUser(UUID userId, String deletedBy);
    
    // Password management
    void changePassword(UUID userId, String currentPassword, String newPassword);
    void resetPassword(UUID userId, String newPassword, String resetBy);
    void forcePasswordChange(UUID userId, String newPassword, String changedBy);
    
    // Status management
    User activateUser(UUID userId, String activatedBy);
    User deactivateUser(UUID userId, String deactivatedBy);
    User suspendUser(UUID userId, String reason, String suspendedBy);
    User unsuspendUser(UUID userId, String unsuspendedBy);
    
    // Query methods
    List<User> getUsersByStore(UUID storeId);
    Page<User> getUsersByStore(UUID storeId, Pageable pageable);
    
    List<User> getUsersByRole(UserRole role);
    List<User> getUsersByStoreAndRole(UUID storeId, UserRole role);
    
    List<User> getUsersByStatus(UserStatus status);
    List<User> getUsersByStoreAndStatus(UUID storeId, UserStatus status);
    
    List<User> getActiveUsers();
    List<User> getActiveUsersByStore(UUID storeId);
    
    List<User> searchUsers(String searchTerm);
    List<User> searchUsersInStore(UUID storeId, String searchTerm);
    
    // Statistics
    long countUsersByStatus(UserStatus status);
    long countUsersByStoreAndStatus(UUID storeId, UserStatus status);
    
    long countUsersByRole(UserRole role);
    long countUsersByStoreAndRole(UUID storeId, UserRole role);
    
    // Security
    List<User> getUsersWithFailedLogins(Integer threshold);
    List<User> getUsersWithFailedLoginsInStore(UUID storeId, Integer threshold);
    
    // Validation
    boolean isUsernameAvailable(String username);
    boolean isEmailAvailable(String email);
    boolean isUsernameAvailableForUpdate(String username, UUID userId);
    boolean isEmailAvailableForUpdate(String email, UUID userId);
    
    // Role-based access control
    boolean hasRole(UUID userId, UserRole role);
    boolean hasAnyRole(UUID userId, UserRole... roles);
    boolean canPerformAction(UUID userId, String action);
    
    // Store management
    void assignUserToStore(UUID userId, UUID storeId);
    void removeUserFromStore(UUID userId);
}




