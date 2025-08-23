package com.votreentreprise.pos.users.domain;

public enum UserRole {
    SUPER_ADMIN("Super Administrateur", "Accès complet à tous les magasins et fonctionnalités"),
    ADMIN("Administrateur", "Gestion complète d'un magasin"),
    MANAGER("Gestionnaire", "Gestion des ventes, stocks et rapports"),
    CASHIER("Caissier", "Ventes, remboursements et sessions de caisse"),
    STOCK_MANAGER("Gestionnaire de stock", "Gestion des stocks et réceptions"),
    ACCOUNTANT("Comptable", "Gestion des dépenses et rapports financiers"),
    VIEWER("Lecteur", "Consultation des données en lecture seule");

    private final String displayName;
    private final String description;

    UserRole(String displayName, String description) {
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

    public boolean isAdmin() {
        return this == SUPER_ADMIN || this == ADMIN;
    }

    public boolean canManageUsers() {
        return this == SUPER_ADMIN || this == ADMIN;
    }

    public boolean canManageStores() {
        return this == SUPER_ADMIN;
    }

    public boolean canManageInventory() {
        return this == SUPER_ADMIN || this == ADMIN || this == STOCK_MANAGER;
    }

    public boolean canManageSales() {
        return this == SUPER_ADMIN || this == ADMIN || this == MANAGER || this == CASHIER;
    }

    public boolean canManageExpenses() {
        return this == SUPER_ADMIN || this == ADMIN || this == ACCOUNTANT;
    }

    public boolean canViewReports() {
        return this == SUPER_ADMIN || this == ADMIN || this == MANAGER || this == ACCOUNTANT;
    }
}




