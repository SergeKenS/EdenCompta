package com.votreentreprise.pos.users.domain;

public enum UserStatus {
    ACTIVE("Actif", "Compte utilisateur actif et fonctionnel"),
    INACTIVE("Inactif", "Compte temporairement désactivé"),
    SUSPENDED("Suspendu", "Compte suspendu pour violation des règles"),
    LOCKED("Verrouillé", "Compte verrouillé suite à trop de tentatives de connexion"),
    PENDING_ACTIVATION("En attente d'activation", "Compte créé mais pas encore activé"),
    EXPIRED("Expiré", "Compte expiré (mot de passe ou licence)");

    private final String displayName;
    private final String description;

    UserStatus(String displayName, String description) {
        this.displayName = displayName;
        this.description = description;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getDescription() {
        return description;
    }

    @Override
    public String toString() {
        return displayName;
    }

    public boolean isActive() {
        return this == ACTIVE;
    }

    public boolean canLogin() {
        return this == ACTIVE;
    }
}




