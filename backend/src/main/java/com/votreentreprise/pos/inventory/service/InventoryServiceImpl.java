package com.votreentreprise.pos.inventory.service;

import com.votreentreprise.pos.inventory.domain.InventoryLevel;
import com.votreentreprise.pos.inventory.domain.InventoryTransaction;
import com.votreentreprise.pos.inventory.domain.ProductVariant;
import com.votreentreprise.pos.inventory.repository.InventoryLevelRepository;
import com.votreentreprise.pos.inventory.repository.InventoryTransactionRepository;
import com.votreentreprise.pos.inventory.repository.ProductVariantRepository;
import com.votreentreprise.pos.store.domain.Store;
import com.votreentreprise.pos.store.repository.StoreRepository;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.Quantity;
import com.votreentreprise.pos.common.types.TransactionType;
import com.votreentreprise.pos.common.exceptions.BusinessException;
import com.votreentreprise.pos.common.exceptions.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class InventoryServiceImpl implements InventoryService {

    private final InventoryLevelRepository inventoryLevelRepository;
    private final InventoryTransactionRepository inventoryTransactionRepository;
    private final StoreRepository storeRepository;
    private final ProductVariantRepository productVariantRepository;

    @Override
    @Transactional
    public void addStock(UUID storeId, UUID variantId, Quantity quantity,
                         Money unitCost, String referenceId, String referenceType) {

        Store store = getStore(storeId);
        ProductVariant variant = getVariant(variantId);

        // Récupérer ou créer le niveau d'inventaire
        InventoryLevel level = inventoryLevelRepository
                .findByStoreIdAndVariantId(storeId, variantId)
                .orElse(new InventoryLevel(store, variant));

        // Calculer le nouveau coût moyen
        Money newAverageCost = calculateNewAverageCost(level, quantity, unitCost);
        Quantity newQuantity = level.getQuantityOnHand().add(quantity);

        // Mettre à jour le niveau
        level.updateQuantityAndCost(newQuantity, newAverageCost);
        inventoryLevelRepository.save(level);

        // Créer la transaction
        InventoryTransaction transaction = new InventoryTransaction(
                store, variant, TransactionType.PURCHASE, quantity,
                unitCost, referenceId, referenceType);
        inventoryTransactionRepository.save(transaction);


    }

    @Override
    @Transactional
    public void removeStock(UUID storeId, UUID variantId, Quantity quantity,
                            String referenceId, String referenceType) {

        Store store = getStore(storeId);
        ProductVariant variant = getVariant(variantId);

        InventoryLevel level = inventoryLevelRepository
                .findByStoreIdAndVariantId(storeId, variantId)
                .orElseThrow(() -> new BusinessException("Aucun stock trouvé pour cette variante"));

        // Vérifier la disponibilité
        if (level.getQuantityOnHand().getValue().compareTo(quantity.getValue()) < 0) {
            throw new BusinessException("Stock insuffisant");
        }

        Quantity newQuantity = level.getQuantityOnHand().subtract(quantity);
        level.updateQuantityAndCost(newQuantity, level.getAverageCost());
        inventoryLevelRepository.save(level);

        // Créer la transaction (quantité négative pour sortie)
        InventoryTransaction transaction = new InventoryTransaction(
                store, variant, TransactionType.SALE,
                Quantity.of(quantity.getValue().negate()),
                level.getAverageCost(), referenceId, referenceType);
        inventoryTransactionRepository.save(transaction);


    }

    @Override
    @Transactional
    public void adjustStock(UUID storeId, UUID variantId, Quantity newQuantity,
                            String reason, String adjustedBy) {

        Store store = getStore(storeId);
        ProductVariant variant = getVariant(variantId);

        InventoryLevel level = inventoryLevelRepository
                .findByStoreIdAndVariantId(storeId, variantId)
                .orElse(new InventoryLevel(store, variant));

        Quantity difference = newQuantity.subtract(level.getQuantityOnHand());

        if (difference.getValue().compareTo(BigDecimal.ZERO) != 0) {
            // Mettre à jour le niveau
            level.updateQuantityAndCost(newQuantity, level.getAverageCost());
            inventoryLevelRepository.save(level);

            // Créer la transaction d'ajustement
            InventoryTransaction transaction = new InventoryTransaction(
                    store, variant, TransactionType.ADJUSTMENT, difference,
                    level.getAverageCost(), null, "ADJUSTMENT");
            transaction.setNotes(reason);
            transaction.setCreatedBy(adjustedBy);
            inventoryTransactionRepository.save(transaction);
        }


    }

    @Override
    @Transactional(readOnly = true)
    public InventoryLevel getInventoryLevel(UUID storeId, UUID variantId) {
        return inventoryLevelRepository.findByStoreIdAndVariantId(storeId, variantId)
                .orElseThrow(() -> new ResourceNotFoundException("Niveau d'inventaire non trouvé"));
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isAvailable(UUID storeId, UUID variantId, Quantity requiredQuantity) {
        return inventoryLevelRepository.findByStoreIdAndVariantId(storeId, variantId)
                .map(level -> level.getQuantityOnHand().getValue()
                        .compareTo(requiredQuantity.getValue()) >= 0)
                .orElse(false);
    }

    private Money calculateNewAverageCost(InventoryLevel currentLevel,
                                          Quantity incomingQuantity, Money incomingCost) {
        BigDecimal currentQty = currentLevel.getQuantityOnHand().getValue();
        BigDecimal currentCost = currentLevel.getAverageCost().getAmount();
        BigDecimal incomingQty = incomingQuantity.getValue();
        BigDecimal incomingCostAmount = incomingCost.getAmount();

        if (currentQty.compareTo(BigDecimal.ZERO) == 0) {
            return incomingCost;
        }

        BigDecimal totalValue = currentCost.multiply(currentQty)
                .add(incomingCostAmount.multiply(incomingQty));
        BigDecimal totalQuantity = currentQty.add(incomingQty);

        BigDecimal newAverageCost = totalValue.divide(totalQuantity, 2, RoundingMode.HALF_EVEN);
        return Money.of(newAverageCost);
    }

    private Store getStore(UUID storeId) {
        return storeRepository.findById(storeId)
                .orElseThrow(() -> new ResourceNotFoundException("Magasin non trouvé: " + storeId));
    }

    private ProductVariant getVariant(UUID variantId) {
        return productVariantRepository.findById(variantId)
                .orElseThrow(() -> new ResourceNotFoundException("Variante non trouvée: " + variantId));
    }
}