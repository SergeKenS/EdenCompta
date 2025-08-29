package com.votreentreprise.pos.rbac.service;

import com.votreentreprise.pos.rbac.repository.UserRoleRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthorizationServiceImpl implements AuthorizationService {

    private final UserRoleRepository userRoleRepository;

    @Override
    @Transactional(readOnly = true)
    @Cacheable(value = "user-permissions", key = "#userId")
    public Set<String> getPermissionsForUser(UUID userId) {
        log.debug("Récupération des permissions pour l'utilisateur: {}", userId);
        List<String> permissions = userRoleRepository.findPermissionKeysByUserId(userId);
        return new HashSet<>(permissions);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean hasPermission(UUID userId, String permissionKey) {
        log.debug("Vérification de la permission {} pour l'utilisateur: {}", permissionKey, userId);
        Set<String> permissions = getPermissionsForUser(userId);
        return permissions.contains(permissionKey);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean hasAnyPermission(UUID userId, String... permissionKeys) {
        log.debug("Vérification des permissions {} pour l'utilisateur: {}", 
                String.join(", ", permissionKeys), userId);
        Set<String> permissions = getPermissionsForUser(userId);
        for (String permissionKey : permissionKeys) {
            if (permissions.contains(permissionKey)) {
                return true;
            }
        }
        return false;
    }

    @Override
    @Transactional(readOnly = true)
    public boolean hasAllPermissions(UUID userId, String... permissionKeys) {
        log.debug("Vérification de toutes les permissions {} pour l'utilisateur: {}", 
                String.join(", ", permissionKeys), userId);
        Set<String> permissions = getPermissionsForUser(userId);
        for (String permissionKey : permissionKeys) {
            if (!permissions.contains(permissionKey)) {
                return false;
            }
        }
        return true;
    }

    @Override
    @Transactional(readOnly = true)
    @Cacheable(value = "user-roles", key = "#userId")
    public Set<String> getRolesForUser(UUID userId) {
        log.debug("Récupération des rôles pour l'utilisateur: {}", userId);
        List<String> roles = userRoleRepository.findRoleKeysByUserId(userId);
        return new HashSet<>(roles);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean hasRole(UUID userId, String roleKey) {
        log.debug("Vérification du rôle {} pour l'utilisateur: {}", roleKey, userId);
        Set<String> roles = getRolesForUser(userId);
        return roles.contains(roleKey);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean hasAnyRole(UUID userId, String... roleKeys) {
        log.debug("Vérification des rôles {} pour l'utilisateur: {}", 
                String.join(", ", roleKeys), userId);
        Set<String> roles = getRolesForUser(userId);
        for (String roleKey : roleKeys) {
            if (roles.contains(roleKey)) {
                return true;
            }
        }
        return false;
    }
}
