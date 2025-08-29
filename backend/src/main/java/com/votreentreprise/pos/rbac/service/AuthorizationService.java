package com.votreentreprise.pos.rbac.service;

import java.util.Set;
import java.util.UUID;

public interface AuthorizationService {

    /**
     * Récupère toutes les permissions d'un utilisateur
     */
    Set<String> getPermissionsForUser(UUID userId);

    /**
     * Vérifie si un utilisateur a une permission spécifique
     */
    boolean hasPermission(UUID userId, String permissionKey);

    /**
     * Vérifie si un utilisateur a au moins une des permissions spécifiées
     */
    boolean hasAnyPermission(UUID userId, String... permissionKeys);

    /**
     * Vérifie si un utilisateur a toutes les permissions spécifiées
     */
    boolean hasAllPermissions(UUID userId, String... permissionKeys);

    /**
     * Récupère les rôles d'un utilisateur
     */
    Set<String> getRolesForUser(UUID userId);

    /**
     * Vérifie si un utilisateur a un rôle spécifique
     */
    boolean hasRole(UUID userId, String roleKey);

    /**
     * Vérifie si un utilisateur a au moins un des rôles spécifiés
     */
    boolean hasAnyRole(UUID userId, String... roleKeys);
}
