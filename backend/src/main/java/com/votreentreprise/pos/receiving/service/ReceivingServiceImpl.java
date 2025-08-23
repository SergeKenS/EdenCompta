package com.votreentreprise.pos.receiving.service;

import com.votreentreprise.pos.receiving.domain.GoodsReceipt;
import com.votreentreprise.pos.receiving.domain.GoodsReceiptLine;
import com.votreentreprise.pos.receiving.repository.GoodsReceiptRepository;
import com.votreentreprise.pos.receiving.repository.GoodsReceiptLineRepository;
import com.votreentreprise.pos.store.domain.Store;
import com.votreentreprise.pos.store.repository.StoreRepository;
import com.votreentreprise.pos.inventory.domain.ProductVariant;
import com.votreentreprise.pos.inventory.repository.ProductVariantRepository;
import com.votreentreprise.pos.inventory.service.InventoryService;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.Quantity;
import com.votreentreprise.pos.common.types.ReceiptStatusType;
import com.votreentreprise.pos.common.exceptions.BusinessException;
import com.votreentreprise.pos.common.exceptions.ResourceNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class ReceivingServiceImpl implements ReceivingService {

    private static final Logger log = LoggerFactory.getLogger(ReceivingServiceImpl.class);

    private final GoodsReceiptRepository goodsReceiptRepository;
    private final GoodsReceiptLineRepository goodsReceiptLineRepository;
    private final StoreRepository storeRepository;
    private final ProductVariantRepository productVariantRepository;
    private final InventoryService inventoryService;

    public ReceivingServiceImpl(GoodsReceiptRepository goodsReceiptRepository,
                                GoodsReceiptLineRepository goodsReceiptLineRepository,
                                StoreRepository storeRepository,
                                ProductVariantRepository productVariantRepository,
                                InventoryService inventoryService) {
        this.goodsReceiptRepository = goodsReceiptRepository;
        this.goodsReceiptLineRepository = goodsReceiptLineRepository;
        this.storeRepository = storeRepository;
        this.productVariantRepository = productVariantRepository;
        this.inventoryService = inventoryService;
    }

    @Override
    @Transactional
    public GoodsReceipt createReceipt(UUID storeId, String createdBy, String sourceOfflineId) {
        log.debug("Création d'une réception pour le magasin {} par {}", storeId, createdBy);

        // Vérifier l'idempotence
        if (sourceOfflineId != null) {
            var existing = goodsReceiptRepository.findBySourceOfflineId(sourceOfflineId);
            if (existing.isPresent()) {
                log.debug("Réception déjà existante avec sourceOfflineId: {}", sourceOfflineId);
                return existing.get();
            }
        }

        Store store = storeRepository.findById(storeId)
                .orElseThrow(() -> new ResourceNotFoundException("Magasin non trouvé: " + storeId));

        GoodsReceipt receipt = new GoodsReceipt(store, createdBy);
        receipt.setSourceOfflineId(sourceOfflineId);

        return goodsReceiptRepository.save(receipt);
    }

    @Override
    @Transactional
    public GoodsReceiptLine addLineToReceipt(UUID receiptId, UUID variantId,
                                             Quantity quantityReceived, Money unitCost,
                                             String batchNumber, String notes) {
        log.debug("Ajout d'une ligne à la réception {} pour la variante {}", receiptId, variantId);

        GoodsReceipt receipt = getReceiptById(receiptId);

        if (!receipt.canBeModified()) {
            throw new BusinessException("Cette réception ne peut plus être modifiée");
        }

        if (!quantityReceived.isPositive()) {
            throw new BusinessException("La quantité reçue doit être positive");
        }

        ProductVariant variant = productVariantRepository.findById(variantId)
                .orElseThrow(() -> new ResourceNotFoundException("Variante non trouvée: " + variantId));

        // Calculer le numéro de ligne suivant
        int nextLineNumber = receipt.getLines().size() + 1;

        GoodsReceiptLine line = new GoodsReceiptLine(receipt, variant, quantityReceived,
                unitCost, nextLineNumber);
        line.setBatchNumber(batchNumber);
        line.setNotes(notes);

        receipt.addLine(line);
        line = goodsReceiptLineRepository.save(line);

        log.debug("Ligne ajoutée avec succès: {}", line.getId());
        return line;
    }

    @Override
    @Transactional
    public GoodsReceipt finalizeReceipt(UUID receiptId, String finalizedBy) {
        log.debug("Finalisation de la réception {} par {}", receiptId, finalizedBy);

        GoodsReceipt receipt = getReceiptById(receiptId);

        if (receipt.getStatus() != ReceiptStatusType.DRAFT) {
            throw new BusinessException("Seules les réceptions en brouillon peuvent être finalisées");
        }

        if (receipt.getLines().isEmpty()) {
            throw new BusinessException("Impossible de finaliser une réception sans lignes");
        }

        // Mettre à jour les stocks pour chaque ligne
        for (GoodsReceiptLine line : receipt.getLines()) {
            inventoryService.addStock(
                    receipt.getStore().getId(),
                    line.getVariant().getId(),
                    line.getQuantityReceived(),
                    line.getUnitCostEffective(),
                    receiptId.toString(),
                    "GOODS_RECEIPT"
            );
        }

        // Marquer comme reçu
        receipt.markAsReceived();

        GoodsReceipt savedReceipt = goodsReceiptRepository.save(receipt);
        log.debug("Réception finalisée avec succès: {}", receiptId);

        return savedReceipt;
    }

    @Override
    @Transactional
    public void cancelReceipt(UUID receiptId, String cancelledBy) {
        log.debug("Annulation de la réception {} par {}", receiptId, cancelledBy);

        GoodsReceipt receipt = getReceiptById(receiptId);

        if (receipt.getStatus() == ReceiptStatusType.RECEIVED) {
            throw new BusinessException("Une réception finalisée ne peut pas être annulée");
        }

        receipt.setStatus(ReceiptStatusType.CANCELLED);
        goodsReceiptRepository.save(receipt);

        log.debug("Réception annulée avec succès: {}", receiptId);
    }

    @Override
    @Transactional(readOnly = true)
    public GoodsReceipt getReceiptById(UUID receiptId) {
        return goodsReceiptRepository.findById(receiptId)
                .orElseThrow(() -> new ResourceNotFoundException("Réception non trouvée: " + receiptId));
    }

    @Override
    @Transactional(readOnly = true)
    public List<GoodsReceipt> getReceiptsByStoreAndDateRange(UUID storeId,
                                                             LocalDateTime from,
                                                             LocalDateTime to,
                                                             ReceiptStatusType status) {
        return goodsReceiptRepository.findByStoreAndDateRangeAndStatus(storeId, from, to, status);
    }

    @Override
    @Transactional
    public void removeLineFromReceipt(UUID receiptId, UUID lineId) {
        log.debug("Suppression de la ligne {} de la réception {}", lineId, receiptId);

        GoodsReceipt receipt = getReceiptById(receiptId);

        if (!receipt.canBeModified()) {
            throw new BusinessException("Cette réception ne peut plus être modifiée");
        }

        GoodsReceiptLine line = goodsReceiptLineRepository.findById(lineId)
                .orElseThrow(() -> new ResourceNotFoundException("Ligne non trouvée: " + lineId));

        if (!line.getReceipt().getId().equals(receiptId)) {
            throw new BusinessException("Cette ligne n'appartient pas à cette réception");
        }

        receipt.removeLine(line);
        goodsReceiptLineRepository.delete(line);

        log.debug("Ligne supprimée avec succès: {}", lineId);
    }

    @Override
    @Transactional
    public GoodsReceiptLine updateReceiptLine(UUID lineId, Quantity newQuantity,
                                              Money newUnitCost, String notes) {
        log.debug("Mise à jour de la ligne {}", lineId);

        GoodsReceiptLine line = goodsReceiptLineRepository.findById(lineId)
                .orElseThrow(() -> new ResourceNotFoundException("Ligne non trouvée: " + lineId));

        if (!line.getReceipt().canBeModified()) {
            throw new BusinessException("Cette ligne ne peut plus être modifiée");
        }

        if (!newQuantity.isPositive()) {
            throw new BusinessException("La quantité doit être positive");
        }

        line.setQuantityReceived(newQuantity);
        line.setUnitCostEffective(newUnitCost);
        line.setNotes(notes);
        line.calculateLineTotal();

        GoodsReceiptLine savedLine = goodsReceiptLineRepository.save(line);
        log.debug("Ligne mise à jour avec succès: {}", lineId);

        return savedLine;
    }
}