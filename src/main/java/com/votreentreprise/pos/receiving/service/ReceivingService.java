package com.votreentreprise.pos.receiving.service;

import com.votreentreprise.pos.receiving.domain.GoodsReceipt;
import com.votreentreprise.pos.receiving.domain.GoodsReceiptLine;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.Quantity;
import com.votreentreprise.pos.common.types.ReceiptStatusType;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public interface ReceivingService {

    /**
     * Créer une nouvelle réception
     */
    GoodsReceipt createReceipt(UUID storeId, String createdBy, String sourceOfflineId);

    /**
     * Ajouter une ligne à une réception
     */
    GoodsReceiptLine addLineToReceipt(UUID receiptId, UUID variantId,
                                      Quantity quantityReceived, Money unitCost,
                                      String batchNumber, String notes);

    /**
     * Finaliser une réception (met à jour les stocks)
     */
    GoodsReceipt finalizeReceipt(UUID receiptId, String finalizedBy);

    /**
     * Annuler une réception
     */
    void cancelReceipt(UUID receiptId, String cancelledBy);

    /**
     * Récupérer une réception par ID
     */
    GoodsReceipt getReceiptById(UUID receiptId);

    /**
     * Récupérer les réceptions par magasin et période
     */
    List<GoodsReceipt> getReceiptsByStoreAndDateRange(UUID storeId,
                                                      LocalDateTime from,
                                                      LocalDateTime to,
                                                      ReceiptStatusType status);

    /**
     * Supprimer une ligne de réception
     */
    void removeLineFromReceipt(UUID receiptId, UUID lineId);

    /**
     * Mettre à jour une ligne de réception
     */
    GoodsReceiptLine updateReceiptLine(UUID lineId, Quantity newQuantity,
                                       Money newUnitCost, String notes);
}