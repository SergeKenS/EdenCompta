package com.votreentreprise.pos.expenses.domain;

public enum ExpenseCategory {
    SUPPLIES("Fournitures"),
    UTILITIES("Services publics"),
    RENT("Loyer"),
    MAINTENANCE("Maintenance"),
    MARKETING("Marketing"),
    TRAVEL("Voyages"),
    MEALS("Repas"),
    EQUIPMENT("Équipement"),
    INSURANCE("Assurance"),
    LEGAL("Frais juridiques"),
    ACCOUNTING("Comptabilité"),
    SOFTWARE("Logiciels"),
    SUBSCRIPTIONS("Abonnements"),
    REPAIRS("Réparations"),
    CLEANING("Nettoyage"),
    SECURITY("Sécurité"),
    OTHER("Autres");

    private final String displayName;

    ExpenseCategory(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    @Override
    public String toString() {
        return displayName;
    }
}




