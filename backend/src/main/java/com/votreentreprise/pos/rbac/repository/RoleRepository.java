package com.votreentreprise.pos.rbac.repository;

import com.votreentreprise.pos.rbac.domain.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface RoleRepository extends JpaRepository<Role, UUID> {

    Optional<Role> findByKey(String key);
    
    boolean existsByKey(String key);
}
