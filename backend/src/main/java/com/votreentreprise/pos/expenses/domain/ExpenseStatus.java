package com.votreentreprise.pos.expenses.domain;

public enum ExpenseStatus {
    PENDING("En attente"),
    APPROVED("Approuvé"),
    REJECTED("Rejeté"),
    CANCELLED("Annulé");

    private final String displayName;

    ExpenseStatus(String displayName) {
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




