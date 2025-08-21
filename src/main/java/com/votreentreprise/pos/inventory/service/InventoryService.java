package com.votreentreprise.pos.inventory.service;

import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.Quantity;
import com.votreentreprise.pos.inventory.domain.InventoryLevel;

import java.util.UUID;

public interface InventoryService {

    /**
     * Ajouter du stock (réception)
     */
    public void addStock(UUID storeId, UUID variantId, Quantity quantity,
                  Money unitCost, String referenceId, String referenceType);

    /**
     * Retirer du stock (vente)
     */
    void removeStock(UUID storeId, UUID variantId, Quantity quantity,
                     String referenceId, String referenceType);

    /**
     * Ajustement de stock
     */
    void adjustStock(UUID storeId, UUID variantId, Quantity newQuantity,
                     String reason, String adjustedBy);

    /**
     * Obtenir le niveau de stock
     */
    InventoryLevel getInventoryLevel(UUID storeId, UUID variantId);

    /**
     * Vérifier la disponibilité
     */
    boolean isAvailable(UUID storeId, UUID variantId, Quantity requiredQuantity);
}