package com.votreentreprise.pos.rbac.service;

import com.votreentreprise.pos.rbac.domain.Role;
import com.votreentreprise.pos.rbac.domain.UserRole;
import com.votreentreprise.pos.rbac.repository.RoleRepository;
import com.votreentreprise.pos.rbac.repository.UserRoleRepository;
import com.votreentreprise.pos.users.domain.User;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class RbacService {

    private final RoleRepository roleRepository;
    private final UserRoleRepository userRoleRepository;

    /**
     * Attribue un rôle RBAC à un utilisateur
     */
    @Transactional
    public void assignRoleToUser(User user, String roleKey) {
        log.debug("Attribution du rôle {} à l'utilisateur {}", roleKey, user.getId());
        
        Role role = roleRepository.findByKey(roleKey)
                .orElseThrow(() -> new IllegalArgumentException("Rôle non trouvé: " + roleKey));
        
        // Vérifier si l'utilisateur a déjà ce rôle
        if (userRoleRepository.existsByUserIdAndRoleId(user.getId(), role.getId())) {
            log.debug("L'utilisateur {} a déjà le rôle {}", user.getId(), roleKey);
            return;
        }
        
        UserRole userRole = new UserRole(user, role);
        userRoleRepository.save(userRole);
        log.debug("Rôle {} attribué à l'utilisateur {}", roleKey, user.getId());
    }

    /**
     * Attribue automatiquement un rôle RBAC basé sur le rôle utilisateur existant
     */
    @Transactional
    public void assignRoleBasedOnUserRole(User user) {
        String rbacRoleKey = switch (user.getRole().name()) {
            case "MANAGER" -> "MANAGER";
            case "CASHIER" -> "CASHIER";
            case "STOCK_MANAGER" -> "STOCK_CLERK";
            case "ADMIN", "SUPER_ADMIN" -> "MANAGER";
            default -> throw new IllegalArgumentException("Rôle utilisateur non supporté: " + user.getRole());
        };
        
        assignRoleToUser(user, rbacRoleKey);
    }

    /**
     * Supprime un rôle RBAC d'un utilisateur
     */
    @Transactional
    public void removeRoleFromUser(UUID userId, String roleKey) {
        log.debug("Suppression du rôle {} de l'utilisateur {}", roleKey, userId);
        
        Role role = roleRepository.findByKey(roleKey)
                .orElseThrow(() -> new IllegalArgumentException("Rôle non trouvé: " + roleKey));
        
        userRoleRepository.deleteByUserIdAndRoleId(userId, role.getId());
        log.debug("Rôle {} supprimé de l'utilisateur {}", roleKey, userId);
    }
}
