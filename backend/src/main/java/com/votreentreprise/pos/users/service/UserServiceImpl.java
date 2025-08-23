package com.votreentreprise.pos.users.service;

import com.votreentreprise.pos.common.exceptions.BusinessException;
import com.votreentreprise.pos.common.exceptions.ResourceNotFoundException;
import com.votreentreprise.pos.store.domain.Store;
import com.votreentreprise.pos.store.repository.StoreRepository;
import com.votreentreprise.pos.users.domain.User;
import com.votreentreprise.pos.users.domain.UserRole;
import com.votreentreprise.pos.users.domain.UserStatus;
import com.votreentreprise.pos.users.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final StoreRepository storeRepository;

    public UserServiceImpl(UserRepository userRepository, StoreRepository storeRepository) {
        this.userRepository = userRepository;
        this.storeRepository = storeRepository;
    }

    @Override
    @Transactional
    public User authenticateUser(String username, String password) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new BusinessException("Nom d'utilisateur ou mot de passe incorrect"));

        if (!user.isActive()) {
            throw new BusinessException("Compte utilisateur non actif");
        }

        if (user.isAccountLocked()) {
            throw new BusinessException("Compte temporairement verrouillé. Réessayez plus tard.");
        }

        if (!user.checkPassword(password)) {
            recordFailedLogin(user.getId());
            throw new BusinessException("Nom d'utilisateur ou mot de passe incorrect");
        }

        recordSuccessfulLogin(user.getId());
        return user;
    }

    @Override
    @Transactional
    public void recordSuccessfulLogin(UUID userId) {
        User user = getUserById(userId);
        user.recordSuccessfulLogin();
        userRepository.save(user);
    }

    @Override
    @Transactional
    public void recordFailedLogin(UUID userId) {
        User user = getUserById(userId);
        user.recordFailedLogin();
        userRepository.save(user);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isAccountLocked(UUID userId) {
        User user = getUserById(userId);
        return user.isAccountLocked();
    }

    @Override
    @Transactional
    public void unlockAccount(UUID userId) {
        User user = getUserById(userId);
        user.setFailedLoginAttempts(0);
        user.setAccountLockedUntil(null);
        userRepository.save(user);
    }

    @Override
    @Transactional
    public User createUser(String username, String email, String password, String firstName,
                          String lastName, UserRole role, UUID storeId, String createdBy) {
        
        // Validate input
        if (password == null || password.length() < 8) {
            throw new BusinessException("Le mot de passe doit contenir au moins 8 caractères");
        }

        // Check uniqueness
        if (!isUsernameAvailable(username)) {
            throw new BusinessException("Ce nom d'utilisateur est déjà utilisé");
        }
        if (!isEmailAvailable(email)) {
            throw new BusinessException("Cette adresse email est déjà utilisée");
        }

        // Validate store if provided
        Store store = null;
        if (storeId != null) {
            store = storeRepository.findById(storeId)
                    .orElseThrow(() -> new ResourceNotFoundException("Magasin non trouvé: " + storeId));
        }

        // Create user
        User user = new User(username, email, password, firstName, lastName, role);
        user.setStore(store);
        user.setCreatedBy(createdBy);
        user.setStatus(UserStatus.PENDING_ACTIVATION);

        return userRepository.save(user);
    }

    @Override
    @Transactional(readOnly = true)
    public User getUserById(UUID userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur non trouvé: " + userId));
    }

    @Override
    @Transactional(readOnly = true)
    public User getUserByUsername(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur non trouvé: " + username));
    }

    @Override
    @Transactional(readOnly = true)
    public User getUserByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur non trouvé: " + email));
    }

    @Override
    @Transactional
    public User updateUser(UUID userId, String firstName, String lastName, String email,
                          String phone, UserRole role, UUID storeId) {
        
        User user = getUserById(userId);

        // Check email uniqueness if changed
        if (!user.getEmail().equals(email) && !isEmailAvailableForUpdate(email, userId)) {
            throw new BusinessException("Cette adresse email est déjà utilisée");
        }

        // Validate store if provided
        Store store = null;
        if (storeId != null) {
            store = storeRepository.findById(storeId)
                    .orElseThrow(() -> new ResourceNotFoundException("Magasin non trouvé: " + storeId));
        }

        // Update fields
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setRole(role);
        user.setStore(store);

        return userRepository.save(user);
    }

    @Override
    @Transactional
    public void deleteUser(UUID userId, String deletedBy) {
        User user = getUserById(userId);
        
        // Don't allow deletion of super admin
        if (user.getRole() == UserRole.SUPER_ADMIN) {
            throw new BusinessException("Impossible de supprimer un super administrateur");
        }

        userRepository.delete(user);
    }

    @Override
    @Transactional
    public void changePassword(UUID userId, String currentPassword, String newPassword) {
        User user = getUserById(userId);
        
        if (!user.checkPassword(currentPassword)) {
            throw new BusinessException("Mot de passe actuel incorrect");
        }

        if (newPassword == null || newPassword.length() < 8) {
            throw new BusinessException("Le nouveau mot de passe doit contenir au moins 8 caractères");
        }

        user.setPassword(newPassword);
        userRepository.save(user);
    }

    @Override
    @Transactional
    public void resetPassword(UUID userId, String newPassword, String resetBy) {
        User user = getUserById(userId);
        
        if (newPassword == null || newPassword.length() < 8) {
            throw new BusinessException("Le nouveau mot de passe doit contenir au moins 8 caractères");
        }

        user.setPassword(newPassword);
        userRepository.save(user);
    }

    @Override
    @Transactional
    public void forcePasswordChange(UUID userId, String newPassword, String changedBy) {
        resetPassword(userId, newPassword, changedBy);
    }

    @Override
    @Transactional
    public User activateUser(UUID userId, String activatedBy) {
        User user = getUserById(userId);
        user.setStatus(UserStatus.ACTIVE);
        return userRepository.save(user);
    }

    @Override
    @Transactional
    public User deactivateUser(UUID userId, String deactivatedBy) {
        User user = getUserById(userId);
        
        if (user.getRole() == UserRole.SUPER_ADMIN) {
            throw new BusinessException("Impossible de désactiver un super administrateur");
        }
        
        user.setStatus(UserStatus.INACTIVE);
        return userRepository.save(user);
    }

    @Override
    @Transactional
    public User suspendUser(UUID userId, String reason, String suspendedBy) {
        User user = getUserById(userId);
        
        if (user.getRole() == UserRole.SUPER_ADMIN) {
            throw new BusinessException("Impossible de suspendre un super administrateur");
        }
        
        user.setStatus(UserStatus.SUSPENDED);
        return userRepository.save(user);
    }

    @Override
    @Transactional
    public User unsuspendUser(UUID userId, String unsuspendedBy) {
        User user = getUserById(userId);
        user.setStatus(UserStatus.ACTIVE);
        return userRepository.save(user);
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> getUsersByStore(UUID storeId) {
        return userRepository.findByStore_IdOrderByLastNameAsc(storeId);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<User> getUsersByStore(UUID storeId, Pageable pageable) {
        return userRepository.findByStore_IdOrderByLastNameAsc(storeId, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> getUsersByRole(UserRole role) {
        return userRepository.findByRoleOrderByLastNameAsc(role);
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> getUsersByStoreAndRole(UUID storeId, UserRole role) {
        return userRepository.findByStore_IdAndRoleOrderByLastNameAsc(storeId, role);
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> getUsersByStatus(UserStatus status) {
        return userRepository.findByStatusOrderByLastNameAsc(status);
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> getUsersByStoreAndStatus(UUID storeId, UserStatus status) {
        return userRepository.findByStore_IdAndStatusOrderByLastNameAsc(storeId, status);
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> getActiveUsers() {
        return userRepository.findByStatusOrderByLastNameAsc(UserStatus.ACTIVE);
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> getActiveUsersByStore(UUID storeId) {
        return userRepository.findByStatusAndStore_IdOrderByLastNameAsc(UserStatus.ACTIVE, storeId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> searchUsers(String searchTerm) {
        return userRepository.searchByNameOrUsername(searchTerm);
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> searchUsersInStore(UUID storeId, String searchTerm) {
        return userRepository.searchByNameOrUsernameInStore(storeId, searchTerm);
    }

    @Override
    @Transactional(readOnly = true)
    public long countUsersByStatus(UserStatus status) {
        return userRepository.countByStatus(status);
    }

    @Override
    @Transactional(readOnly = true)
    public long countUsersByStoreAndStatus(UUID storeId, UserStatus status) {
        return userRepository.countByStore_IdAndStatus(storeId, status);
    }

    @Override
    @Transactional(readOnly = true)
    public long countUsersByRole(UserRole role) {
        return userRepository.countByRole(role);
    }

    @Override
    @Transactional(readOnly = true)
    public long countUsersByStoreAndRole(UUID storeId, UserRole role) {
        return userRepository.countByStore_IdAndRole(storeId, role);
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> getUsersWithFailedLogins(Integer threshold) {
        return userRepository.findByFailedLoginAttemptsGreaterThanAndAccountLockedUntilIsNotNull(threshold);
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> getUsersWithFailedLoginsInStore(UUID storeId, Integer threshold) {
        return userRepository.findByStore_IdAndFailedLoginAttemptsGreaterThanAndAccountLockedUntilIsNotNull(storeId, threshold);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isUsernameAvailable(String username) {
        return !userRepository.existsByUsername(username);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isEmailAvailable(String email) {
        return !userRepository.existsByEmail(email);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isUsernameAvailableForUpdate(String username, UUID userId) {
        return !userRepository.existsByUsernameAndIdNot(username, userId);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isEmailAvailableForUpdate(String email, UUID userId) {
        return !userRepository.existsByEmailAndIdNot(email, userId);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean hasRole(UUID userId, UserRole role) {
        User user = getUserById(userId);
        return user.hasRole(role);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean hasAnyRole(UUID userId, UserRole... roles) {
        User user = getUserById(userId);
        return user.hasAnyRole(roles);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean canPerformAction(UUID userId, String action) {
        User user = getUserById(userId);
        
        return switch (action) {
            case "MANAGE_USERS" -> user.canManageUsers();
            case "MANAGE_STORES" -> user.canManageStores();
            case "MANAGE_INVENTORY" -> user.canManageInventory();
            case "MANAGE_SALES" -> user.canManageSales();
            case "MANAGE_EXPENSES" -> user.canManageExpenses();
            case "VIEW_REPORTS" -> user.canViewReports();
            default -> false;
        };
    }

    @Override
    @Transactional
    public void assignUserToStore(UUID userId, UUID storeId) {
        User user = getUserById(userId);
        Store store = storeRepository.findById(storeId)
                .orElseThrow(() -> new ResourceNotFoundException("Magasin non trouvé: " + storeId));
        
        user.setStore(store);
        userRepository.save(user);
    }

    @Override
    @Transactional
    public void removeUserFromStore(UUID userId) {
        User user = getUserById(userId);
        user.setStore(null);
        userRepository.save(user);
    }
}




