package com.votreentreprise.pos.rbac.repository;

import com.votreentreprise.pos.rbac.domain.Role;
import com.votreentreprise.pos.rbac.domain.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface UserRoleRepository extends JpaRepository<UserRole, UUID> {

    List<UserRole> findByUserId(UUID userId);
    
    @Query("SELECT ur.role FROM UserRole ur WHERE ur.user.id = :userId")
    List<Role> findRolesByUserId(@Param("userId") UUID userId);
    
    @Query("SELECT ur.role.key FROM UserRole ur WHERE ur.user.id = :userId")
    List<String> findRoleKeysByUserId(@Param("userId") UUID userId);
    
    @Query("SELECT DISTINCT p.key FROM UserRole ur " +
           "JOIN ur.role.permissions p " +
           "WHERE ur.user.id = :userId")
    List<String> findPermissionKeysByUserId(@Param("userId") UUID userId);
    
    void deleteByUserIdAndRoleId(UUID userId, UUID roleId);
    
    boolean existsByUserIdAndRoleId(UUID userId, UUID roleId);
}
