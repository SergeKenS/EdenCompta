package com.votreentreprise.pos.users.repository;

import com.votreentreprise.pos.users.domain.User;
import com.votreentreprise.pos.users.domain.UserRole;
import com.votreentreprise.pos.users.domain.UserStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserRepository extends JpaRepository<User, UUID> {

    // Find by credentials
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);
    Optional<User> findByUsernameOrEmail(String username, String email);

    // Find by store
    List<User> findByStore_IdOrderByLastNameAsc(UUID storeId);
    Page<User> findByStore_IdOrderByLastNameAsc(UUID storeId, Pageable pageable);
    List<User> findByStore_IdAndStatusOrderByLastNameAsc(UUID storeId, UserStatus status);

    // Find by role
    List<User> findByRoleOrderByLastNameAsc(UserRole role);
    List<User> findByStore_IdAndRoleOrderByLastNameAsc(UUID storeId, UserRole role);

    // Find by status
    List<User> findByStatusOrderByLastNameAsc(UserStatus status);

    // Find active users
    List<User> findByStatusAndStore_IdOrderByLastNameAsc(UserStatus status, UUID storeId);

    // Search by name
    @Query("SELECT u FROM User u WHERE " +
           "LOWER(u.firstName) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
           "LOWER(u.lastName) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
           "LOWER(u.username) LIKE LOWER(CONCAT('%', :searchTerm, '%'))")
    List<User> searchByNameOrUsername(@Param("searchTerm") String searchTerm);

    @Query("SELECT u FROM User u WHERE u.store.id = :storeId AND " +
           "(LOWER(u.firstName) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
           "LOWER(u.lastName) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
           "LOWER(u.username) LIKE LOWER(CONCAT('%', :searchTerm, '%')))")
    List<User> searchByNameOrUsernameInStore(@Param("storeId") UUID storeId, @Param("searchTerm") String searchTerm);

    // Find users by last login
    List<User> findByLastLoginBefore(LocalDateTime date);
    List<User> findByStore_IdAndLastLoginBefore(UUID storeId, LocalDateTime date);

    // Count by status
    long countByStatus(UserStatus status);
    long countByStore_IdAndStatus(UUID storeId, UserStatus status);

    // Count by role
    long countByRole(UserRole role);
    long countByStore_IdAndRole(UUID storeId, UserRole role);

    // Check existence
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
    boolean existsByUsernameAndIdNot(String username, UUID id);
    boolean existsByEmailAndIdNot(String email, UUID id);

    // Find users with failed login attempts
    List<User> findByFailedLoginAttemptsGreaterThanAndAccountLockedUntilIsNotNull(Integer threshold);
    List<User> findByStore_IdAndFailedLoginAttemptsGreaterThanAndAccountLockedUntilIsNotNull(UUID storeId, Integer threshold);
}
